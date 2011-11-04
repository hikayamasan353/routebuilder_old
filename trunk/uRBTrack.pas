unit uRBTrack;

// Route Builder
// enthält TRBTrack
// Autor: up
// Erstellt: 14.7.02

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Forms,
  uRBConnectable,
  uGlobalDef,
  uCurrentSituation,
  uTools;

const RailGaugePix = 16; // eigentlich 14,35. Spurweite in Pixeln. Gerade wegen Symmetrie.
      CrossTieLength=RailGaugePix+4; //Schwellenlänge
      TrackWidth   = 21; // Gesamtbreite des Schienenkörpers (=Schwellenlänge)
      TrackXOffset = 70;
      TrackComponentWidth =TrackWidth+TrackXOffset*2;
      TrackLengthDef=250; // Standardlänge eines Gleisstücks (=25m)
      HotspotXOffset=10; // Abstand linke Kante - Gleismitte-Pixel

type
  TRBTrack = class(TRBConnectable)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure PaintOneSegment(segx,segy,len: integer; sina,cosa: double);
    procedure PaintTrackConn(x,y: integer; active: boolean=false);
    procedure PaintStraight(active: boolean=false);
    procedure PaintCurve(active: boolean=false);
    procedure Paint(); override;
    function GetpropertiesCommaseparated(): string; virtual;
  public
    { Public declarations }
    ID:         integer;
    YPosition:  integer; // Höhe in m (absolut, nicht im Vergleich zum Hauptgleis!) -> @height
    Texture:    integer; // Texturindex (interne, vordefinierte Liste!?)
    Speedlimit: integer; // in km/h
    Pitch:      integer; // Steigung in Promille
    Adhesion:   integer; // Adhäsion (Reibwert) 0..100..
    Accuracy:   integer; // Oberbau-Qualität (1 gut ..4 schlecht)
    Background: integer; // Hintergrundbild-Index
    Ground:     integer; // Untergrundtextur-Index
    Fog:        integer; // Nebel (0..100)
    ConnID:     integer; // ID des ConnectedTo-Tracks (nur beim Laden verwendet, solange ConnectedTo-Objekt noch nicht bekannt ist)
    ParrID:     integer; // dasselbe für ParralelTo
    Markerfilename: string;  // Dateiname eines Marker-Bitmaps, relativ zu object\
    Markerduration: integer; // wie lange der Marker angezeigt wird (in m)
    Wavefilename  : string;  // Dateiname eines Sounds, relativ zu object\
    constructor Create();
    constructor CreateParallelTo(Track: TRBTrack; aXOffset: integer);
    constructor CreateAndConnectTo(Track: TRBTrack; aconnection: cardinal=0);
    constructor CreateFromCommaSeparated(_id: integer; const cs: string); virtual;
    procedure   InitTrack();
    procedure   OnClickTrack(sender: TObject);
    procedure   CopyPropertiesFromTrack(Track: TRBTrack);
    property    propertiesCommaseparated: string read GetpropertiesCommaseparated;
  end;


implementation



procedure TRBTrack.InitTrack();
begin
  Width      := TrackComponentWidth;
  Height     := TrackLengthDef;
  // default-Werte
  XOffset    := 0;
  YPosition  := 0;
  Texture    := 0;
  Speedlimit := 0;
  Pitch      := 0;
  Curve      := 0;
  Adhesion   := 100;
  Accuracy   := 1;
  Background := 1;
  Ground     := 1;
  Fog        := 0;
  AlphaStart := 0;
  AlphaEnd := 0;
  FDraggingPossible := true;
  FChangeRadiusPossible := true;
  OnClick := OnClickTrack;
end;

constructor TRBTrack.Create();
begin
  inherited;
  InitTrack();
end;

constructor TRBTrack.CreateParallelTo(Track: TRBTrack; aXOffset: integer);
begin
  inherited CreateparallelTo(Track,aXOffset);
  InitTrack();
  CopyPropertiesFromTrack(Track);
end;

constructor TRBTrack.CreateAndConnectTo(Track: TRBTrack; aconnection: cardinal);
begin
  inherited CreateAndConnectTo(Track,aconnection);
  InitTrack();
  FDraggingPossible := false;
  CopyPropertiesFromTrack(Track);
  AlphaStart := Track.GetAlphaEnd(); // bei Weichen ist das von der Stellung abhängig
  CalcXOffset();
end;

// Funktion    : CreateFromCommaSeparated
// Datum       : 31.7.02
// Autor       : up
// Beschreibung: erzeugt einen Track aus einer Textzeile (aus Projektdatei).
// Hinweis     : verbindet den Track nicht mit dem vorherigen! Muss hinterher geschehen!
// Das geht nämlich nicht, weil wir hier keinen Zugriff auf die Trackliste haben
constructor TRBTrack.CreateFromCommaSeparated(_id: integer; const cs: string);
begin
  Create();
  ID         := _id;
  FXPosition := strtointdef(StrGetToken(cs,'|',1),0);
  FZPosition := strtointdef(StrGetToken(cs,'|',2),0);
  FLength    := strtointdef(StrGetToken(cs,'|',3),0);
  Curve      := strtointdef(StrGetToken(cs,'|',4),0);
  XOffset    := strtointdef(StrGetToken(cs,'|',5),0);
  YPosition  := strtointdef(StrGetToken(cs,'|',6),0);
  Texture    := strtointdef(StrGetToken(cs,'|',7),0);
  Speedlimit := strtointdef(StrGetToken(cs,'|',8),0);
  Pitch      := strtointdef(StrGetToken(cs,'|',9),0);
  Adhesion   := strtointdef(StrGetToken(cs,'|',10),0);
  Accuracy   := strtointdef(StrGetToken(cs,'|',11),0);
  Background := strtointdef(StrGetToken(cs,'|',12),0);
  Ground     := strtointdef(StrGetToken(cs,'|',13),0);
  Fog        := strtointdef(StrGetToken(cs,'|',14),0);
  Markerduration := strtointdef(StrGetToken(cs,'|',15),0);
  Markerfilename := StrGetToken(cs,'|',16);
  Wavefilename   := StrGetToken(cs,'|',17);
  ConnID     := strtointdef(StrGetToken(cs,'|',18),0);
  Connection := strtointdef(StrGetToken(cs,'|',19),0);

 { result := inttostr(FXPosition)+'|'+inttostr(FZPosition)+'|'+inttostr(FLength)
    + '|' + inttostr(curve)    + '|' + inttostr(XOffset) +'|'+inttostr(YPosition)
    + '|' + inttostr(Texture)  + '|' + inttostr(Speedlimit)
    + '|' + inttostr(Pitch)    + '|' + inttostr(Adhesion)+'|'+inttostr(Accuracy)
    + '|' + inttostr(Background)+'|' + inttostr(Ground)  +'|'+inttostr(Fog)
    + '|' + inttostr(Markerduration) + '|"' + Markerfilename + '"|"' + Wavefilename
    +'"|' + inttostr(ConnID)   + '|' + inttostr(ParrID) + '|' ;
}
end;


procedure TRBTrack.OnClickTrack(sender: TObject);
var old: TRBConnectable;
begin
  // altes merken
  old := Currentsituation.CurrentConnectable;
  // dieses als aktuelles setzen
  Currentsituation.CurrentConnectable := self;
  // altes zeichnen
  if old<>nil then old.Repaint;
  // dieses
  repaint;
end;

procedure TRBTrack.CopyPropertiesFromTrack(Track: TRBTrack);
begin
  YPosition  := Track.YPosition;
  Texture    := Track.Texture;
  Speedlimit := Track.Speedlimit;
  Pitch      := Track.Pitch;
  Curve      := Track.Curve;
  Adhesion   := Track.Adhesion;
  Accuracy   := Track.Accuracy;
  Background := Track.Background;
  Ground     := Track.Ground;
  Fog        := Track.Fog;
end;



// Funktion    : GetpropertiesCommaseparated
// Datum       : 15.7.02
// Autor       : up
// Beschreibung: Serialisierung der Eigenschaften
function TRBTrack.GetpropertiesCommaseparated(): string;
var ConnID,ParrID: integer;
begin
  if ConnectedTo<>nil then
    ConnID := (ConnectedTo as TRBTrack).id
  else
    ConnID := 0;
  if ParallelTo<>nil then
    ParrID := (ParallelTo as TRBTrack).id
  else
    ParrID := 0;
  result := inttostr(FXPosition)+'|'+inttostr(FZPosition)+'|'+inttostr(FLength)
    + '|' + inttostr(curve)    + '|' + inttostr(XOffset) +'|'+inttostr(YPosition)
    + '|' + inttostr(Texture)  + '|' + inttostr(Speedlimit)
    + '|' + inttostr(Pitch)    + '|' + inttostr(Adhesion)+'|'+inttostr(Accuracy)
    + '|' + inttostr(Background)+'|' + inttostr(Ground)  +'|'+inttostr(Fog)
    + '|' + inttostr(Markerduration) + '|"' + Markerfilename + '"|"' + Wavefilename
    +'"|' + inttostr(ConnID)   + '|' + inttostr(Connection) + '|' ;
  // TODO: weitere Properties
end;

procedure TRBTrack.PaintOneSegment(segx,segy,len: integer; sina,cosa: double);
var xs,ys: integer;
    IsInCurrentRouteDefinition: boolean;
begin
  IsInCurrentRouteDefinition := CurrentSituation.CurrentRouteDefinitionContainsTrack(ID);
  with Canvas do
  begin
    // Schwellen
    if IsInCurrentRouteDefinition then
      Pen.Color := CrossTieColorSel // hellbraun
    else
      Pen.Color := CrossTieColor; // braun
    Pen.Width := 2;
    MoveTo(TrackXOffset+round(segx-CrossTieLength*cosa/2),round(segy-CrossTieLength*sina/2));
    LineTo(TrackXOffset+round(segx+CrossTieLength*cosa/2),round(segy+CrossTieLength*sina/2));
    // Schienen
    Pen.Color := clWhite;
    Pen.Width := 1;
    // links
    xs := round(segx-RailGaugePix*cosa/2 - len*sina/2 );
    ys := round(segy-RailGaugePix*sina/2 + len*cosa/2 );
    MoveTo(TrackXOffset+xs,ys);
    xs := round(segx-RailGaugePix*cosa/2 + len*sina/2 );
    ys := round(segy-RailGaugePix*sina/2 - len*cosa/2 );
    LineTo(TrackXOffset+xs,ys);
    // rechts
    xs := round(segx+RailGaugePix*cosa/2 - len*sina/2 );
    ys := round(segy+RailGaugePix*sina/2 + len*cosa/2 );
    MoveTo(TrackXOffset+xs,ys);
    xs := round(segx+RailGaugePix*cosa/2 + len*sina/2 );
    ys := round(segy+RailGaugePix*sina/2 - len*cosa/2 );
    LineTo(TrackXOffset+xs,ys);
  end;
end;





procedure TRBTrack.PaintStraight(active: boolean);
var len,n,i,segx,segy: integer;
    sina,cosa: double;
begin
  cosa := cos(alphastart*pi/180);
  sina := sin(alphastart*pi/180);
  // Länge jedes Segments   (Pixel)
  len := 4;
  // Anzahl Segmente
  n := round(height/len+0.5);

  i:=1;
  repeat
    segx := round(HotspotXOffset + sina*(i-0.5)*len);
    segy := round(height-cosa*len*(i-0.5));
    PaintOneSegment(segx,segy,len,sina,cosa);
    if (i=1) or(i=n) then PaintTrackConn(segx,segy,active);
    inc(i);
  until i>n;
end;

// zeichnet den "Schienenverbinder"
procedure TRBTrack.PaintTrackConn(x,y: integer; active: boolean);
begin
  with Canvas do
  begin
    Pen.Color   := clWhite;
    Pen.Style   := psSolid;
    if active then
      Brush.Color := clRed
    else
      Brush.Color := clOlive;
    Brush.Style := bsSolid;
    Ellipse(TrackXOffset+x-3,y-3,TrackXOffset+x+3,y+3);
  end;
end;


procedure TRBTrack.PaintCurve(active: boolean);
var segx,segy,len,i,n,mx,my: integer;
    alpha,seg,cosa,sina: double;
begin
    // curve<>0
    //seg:=0;
    // Länge jedes Segments   (Pixel)
    len := 4;
    // Anzahl Segmente
    n := round(height/len+0.5);
    alpha := 0;
    if curve=0 then
      alpha := 0
    else
      alpha := 180*height/(pi*Curve*PixelPerMeter); // Maßstab?
    AlphaEnd := AlphaStart + alpha;
    // Mittelpunkt des Kreises
    mx := round((CrossTieLength/2 + curve*PixelPerMeter)*cos(AlphaStart*pi/180));
    my := -round((CrossTieLength/2 + curve*PixelPerMeter)*sin(AlphaStart*pi/180));
    i:=1;
    repeat
      cosa := cos((alpha*(2*i-1)/(2*n)+AlphaStart)*pi/180);
      sina := sin((alpha*(2*i-1)/(2*n)+AlphaStart)*pi/180);
      segx := round(mx-curve*PixelPerMeter*cosa);
      segy := height-round(my+curve*PixelPerMeter*sina);  //height*(2*i-1)/(2*n);
      PaintOneSegment(segx,segy,len,sina,cosa);
      if(i=1)or(i=n) then PaintTrackConn(segx,segy,active);
//      PaintSegment(mx,my,round(curve*PixelPerMeter),round(len),alpha*(2*i-1)/(2*n)+AlphaStart);
      inc(i);
    until i>n;
end;

procedure TRBTrack.Paint();
begin
  if Curve=0 then
  begin
    PaintStraight( self=CurrentSituation.CurrentConnectable );
  end
  else
  begin
    PaintCurve( self=CurrentSituation.CurrentConnectable );
  end;
end;


end.
