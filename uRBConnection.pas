unit uRBConnection;

interface

uses sysutils, classes, types, contnrs,
     uglobaldef, math,
     uRBPoint, uTools;

type
     TRBConnection = class
       private
        FP1,FP2: TRBPoint;
       public
        id:         integer;
        Texture:    integer; // Texturindex (interne, vordefinierte Liste!?)
        Speedlimit: integer; // in km/h
        Height:     double; // Höhe über y=0
        Adhesion:   integer; // Adhäsion (Reibwert) 0..100..
        Accuracy:   integer; // Oberbau-Qualität (1 gut ..4 schlecht)
        Fog:        integer; // Nebel (0..100)
        PolesPos:   integer; // Oberleitungsmasten, Position: 0 keine, -1 links, +1 rechts vom Gleis
        exported:   boolean;
        TSOOffsetLeft,
        TSOOffsetRight,
        PlatformPos:  integer;
        PolesType,
        Background,
        Ground,
        PlatformType,
        RoofType,
        TSOLeft,
        TSORight,
        WallLeft,
        WallRight:      string;
        special:        TConnectionSpecial; // Bezier-Kurve? Sonst geradeaus
        Markerfilename: string;  // Dateiname eines Marker-Bitmaps, relativ zu object\
        Markerduration: integer; // wie lange der Marker angezeigt wird (in m)
        Wavefilename  : string;  // Dateiname eines Sounds, relativ zu object\
        b_temp:         double; // temporär verwendeter Wert, wird nicht gespeichert/geladen
        a_temp:         double; // temporär verwendeter Wert, wird nicht gespeichert/geladen
        z_temp:         double; // temporär verwendeter Wert, wird nicht gespeichert/geladen
        curve_temp:     double; 
        switch_turned: integer;
        improved:      boolean;
       constructor Create(p1,p2: TRBPoint); overload;
       constructor Create(const from: TRBConnection); overload;
       constructor CreateFromString(const s: string; points: TObjectlist);
       function GetAsString(): string;
       function Distance(p: TDoublePoint): double;
       function GetCurve(OtherTrack: TRBConnection): integer;
       function YPosition: double;
       function GetLength(): double;
       function IsParallelTo(OtherTrack: TRBConnection): integer;
       function SkalarProduct(OtherTrack: TRBConnection): double;
       function GetAngle(OtherTrack: TRBConnection): double; overload;
       function GetAngle(P: TDoublePoint): double; overload;
       function ExportPreprocess: boolean;
       function GetPointButNot(notp: TRBPoint): TRBPoint;
       function GetPerpendicular1(l: double; f: double=0): TDoublePoint;
       function GetPerpendicular2(l: double; f: double=0): TDoublePoint;
       function GetPointBetween(p: double): TDoublePoint;
       function Curved(): boolean;
       function GetPitch: double;
       procedure CopyProperties(const from: TRBConnection; propertiestopaste: TpropertiesToPaste=ptpAll);
       procedure Turn();
       property P1: TRBPoint read FP1 write FP1;
       property P2: TRBPoint read FP2 write FP2;

     end;

implementation

constructor TRBConnection.Create(p1,p2: TRBPoint);
begin
  FP1 := p1;
  FP2 := p2;
  id := 0;
  Texture    := 1;
  Speedlimit := 0;
  Height     := 0;
  Adhesion   := 255;
  Accuracy   := 1;
  Background := '';
  Ground     := '';
  Fog        := 0;
  PolesPos   := 0;
  PolesType  := '';
  WallLeft := '';
  WallRight:= '';
  TSOLeft  := '';
  TSORight := '';
  TSOOffsetLeft := 0;
  TSOOffsetRight := 0;
  roofType   := '';
  special    := csStraight;
  switch_turned := 1;
end;

constructor TRBConnection.Create(const from: TRBConnection);
begin
  Create(from.P1,from.P2);
  CopyProperties(from);
end;

procedure TRBConnection.CopyProperties(const from: TRBConnection; propertiestopaste: TpropertiesToPaste);
begin
  if (propertiestopaste=ptpAll)or(propertiestopaste=ptpEditor) then
  begin
    Texture := from.Texture;
    Speedlimit := from.Speedlimit;
    Height := from.Height;
    Adhesion := from.Adhesion;
    Accuracy := from.Accuracy;
    Background := from.Background;
    ground := from.Ground;
    fog := from.fog;
    polespos := from.polespos;
    polestype := from.polestype;
    PlatformType := from.PlatformType;
    PlatformPos := from.PlatformPos;
    if propertiestopaste=ptpAll then special := from.special;
    Markerfilename := from.Markerfilename;
    Markerduration := from.Markerduration;
    Wavefilename := from.Wavefilename;
    WallLeft := from.WallLeft;
    WallRight := from.WallRight;
    TSOLeft := from.TSOLeft;
    TSORight := from.TSORight;
    TSOOffsetLeft := from.TSOOffsetLeft;
    TSOOffsetRight := from.TSOOffsetRight;
    RoofType := from.RoofType;
  end
  else
  if propertiestopaste=ptpGround then
    ground := from.Ground
  else
  if propertiestopaste=ptpBackGround then
    background := from.Background
  else
  if propertiestopaste=ptpSpeedlimit then
    Speedlimit := from.Speedlimit
  else
  if propertiestopaste=ptpPoles then
  begin
    PolesPos := from.polesPos;
    PolesType := from.polesType;
  end
  else
  if propertiestopaste=ptpTrack then
    Texture := from.Texture
  else
  if propertiestopaste=ptpWalls then
  begin
    WallLeft := from.WallLeft;
    WallRight := from.WallRight;
  end
  else
  if propertiestopaste=ptpTSO then
  begin
    TSOLeft := from.TSOLeft;
    TSORight := from.TSORight;
    TSOOffsetLeft := from.TSOOffsetLeft;
    TSOOffsetRight := from.TSOOffsetRight;
  end
  else
  if propertiestopaste=ptpAccuracy then
    Accuracy := from.Accuracy
  else
  if propertiestopaste=ptpAdhesion then
    Adhesion := from.Adhesion
  else
  if propertiestopaste=ptpFog then
    Fog := from.Fog
  else
  if propertiestopaste=ptpHeight then
    height := from.Height;
end;

constructor TRBConnection.CreateFromString(const s: string; points: TObjectlist);
var i,p1id,p2id: integer;
begin
  Create(nil,nil);
  id := strtointdef(StrGetToken(s,',',1),0);
  p1id := strtointdef(StrGetToken(s,',',2),0);
  p2id := strtointdef(StrGetToken(s,',',3),0);
  texture := strtointdef(StrGetToken(s,',',4),0);
  speedlimit := strtointdef(StrGetToken(s,',',5),0);
  Height := strtofloat1(StrGetToken(s,',',6));
  adhesion := strtointdef(StrGetToken(s,',',7),0);
  accuracy := strtointdef(StrGetToken(s,',',8),0);
  background := StripQuotes(StrGetToken(s,',',9));
  ground := StripQuotes(StrGetToken(s,',',10));
  fog := strtointdef(StrGetToken(s,',',11),0);
  markerfilename := StripQuotes(StrGetToken(s,',',12));
  markerduration := strtointdef(StrGetToken(s,',',13),0);
  wavefilename := StripQuotes(StrGetToken(s,',',14));
  PlatformPos := strtointdef(StrGetToken(s,',',15),0);
  PlatformType := StripQuotes(StrGetToken(s,',',16));
  PolesPos := sgn(strtointdef(StrGetToken(s,',',17),0));
  special := TConnectionSpecial(strtointdef(StrGetToken(s,',',18),0));
  WallLeft := StripQuotes(StrGetToken(s,',',19));
  WallRight := StripQuotes(StrGetToken(s,',',20));
  RoofType := StripQuotes(StrGetToken(s,',',21));
  TSOLeft := StripQuotes(StrGetToken(s,',',22));
  TSOOffsetLeft := strtointdef(StrGetToken(s,',',23),0);
  TSORight := StripQuotes(StrGetToken(s,',',24));
  TSOOffsetRight := strtointdef(StrGetToken(s,',',25),0);
  PolesType := StripQuotes(StrGetToken(s,',',26));

  if points=nil then exit;

  // suche Punkte
  for i:=0 to points.count-1 do
  begin
    if (points[i] as TRBPoint).id=p1id then FP1 := points[i] as TRBPoint;
    if (points[i] as TRBPoint).id=p2id then FP2 := points[i] as TRBPoint;
    if (FP1<>nil)and(FP2<>nil) then exit;
  end;
end;

function TRBConnection.GetAsString: string;
begin
  result := format('%d,%d,%d,%d,%d,%s,%d,%d,"%s","%s",%d,'
                  +'"%s",%d,"%s",%d,"%s",%d,'
                  +'%d,"%s","%s","%s","%s",%d,"%s",%d,"%s"',
    [id,fp1.id,fp2.id,texture,speedlimit,floattostrpoint(Height),adhesion,accuracy,background,ground,fog,
     markerfilename,markerduration,wavefilename,platformpos,platformtype,polespos,
     ord(special),WallLeft,WallRight,RoofType,TSOLeft,TSOOffsetLeft,TSORight,TSOOffsetRight,PolesType]);
end;

// berechne Abstand zum Mittelpunkt der Strecke
function TRBConnection.Distance(p: TdoublePoint): double;
begin
  result := uTools.Distance( p, doublepoint((FP2.point.x+FP1.point.x)/ 2,
                                            (FP2.point.y+FP1.point.y)/ 2) );
end;

function TRBConnection.GetLength(): double;
begin
  result := uTools.Distance(p1.point,p2.point);
end;

function TRBConnection.GetCurve(OtherTrack: TRBConnection): integer;
var a: integer;
begin
  a := round(GetAngle(OtherTrack));
  if a=0 then
    result := 0
  else
    result := round(GetLength()*180/pi/a);
end;


function TRBConnection.YPosition: double;
begin
  result := Height;
end;

function TRBConnection.GetAngle(P: TDoublePoint): double;
begin
  result := -angle(P1.point,p) + angle(p1.point,p2.point);
end;

// berechnet Winkel zwischen dieser Connection und einer anderen als °
function TRBConnection.GetAngle(OtherTrack: TRBConnection): double;

begin
  if OtherTrack=nil then
  begin
    result := angle(p1.point,p2.point);
    exit;
  end;
  result := -angle(OtherTrack.P1.point,OtherTrack.P2.point) + angle(p1.point,p2.point);
{  a1 := p2.point.Y-p1.point.y;
  b1 := p2.point.x-p1.point.x;
  a2 := OtherTrack.p2.point.Y-OtherTrack.p1.point.y;
  b2 := OtherTrack.p2.point.x-OtherTrack.p1.point.x;
  if(p1=otherTrack.P2)or(p2=otherTrack.p1) then
  begin
    a2 := -a2;
    b2 := -b2;
  end;
  try
  result := round(180*arctan((a1*b2-a2*b1)/(a1*a2+b1*b2))/pi);
  except
  result := 0;
  end;   }
end;

function TRBConnection.ExportPreprocess: boolean;
begin
  if speedlimit<=0 then speedlimit := 70;
  result := true;
end;

function TRBConnection.GetPointButNot(notp: TRBPoint): TRBPoint;
begin
  result := nil;
  if p1<>notp then
    result:= p1
  else
    if p2<>notp then
      result := p2;
end;

// Funktion: Turn
// Autor   : up
// Datum   : 7.12.02
// Beschr. : dreht das Stück um. Dreht den Bahnsteig ebenfalls um, damit er auf der gleichen Seite bleibt
procedure TRBConnection.Turn;
var p: TRBPoint;
    j: integer;
    s: string;
begin
  p := p1;
  p1 := p2;
  p2 := p;
  polespos := -Polespos;
  if PlatformPos>0 then
  begin
    PlatformPos := 3-PlatformPos; // aus 2 wird 1, aus 1 wird 2
  end;
  s := WallLeft;
  WallLeft := WallRight;
  WallRight := s;

  s := TSOLeft;
  TSOLeft := TSORight;
  TSORight := s;

  j := TSOOffsetLeft;
  TSOOffsetLeft := TSOOffsetRight;
  TSOOffsetRight := j;

  switch_turned := - switch_turned;

end;

function TRBConnection.GetPerpendicular1(l,f: double): TDoublePoint;
var p,pp: TDoublePoint;
begin
  pp := GetPointBetween(f);
  Perpendicular(pp,p2.point,l/GetLength(),p);
  result := p;
end;

function TRBConnection.GetPerpendicular2(l,f: double): TDoublePoint;
var p,pp: TDoublePoint;
begin
  pp := GetPointBetween(1-f);
  Perpendicular(pp,p1.point,l/GetLength(),p);
  result := p;
end;



function TRBConnection.IsParallelTo(OtherTrack: TRBConnection): integer;
begin
  raise Exception.create('function IsParallelTo not implemented');
end;


function TRBConnection.Skalarproduct(OtherTrack: TRBConnection): double;
begin
//
  result := (FP2.point.x-FP1.point.x)*(OtherTrack.P2.point.x-OtherTrack.P1.point.x)
          + (FP2.point.y-FP1.point.y)*(OtherTrack.P2.point.y-OtherTrack.P1.point.y);
end;

// ermittelt einen Punkt auf der Connection (p=0..1)
function TRBConnection.GetPointBetween(p: double): TDoublePoint;
begin
  result.x := P1.point.x + (P2.point.x-P1.point.x)*p;
  result.y := P1.point.y + (P2.point.y-P1.point.y)*p;
end;

function TRBConnection.Curved: boolean;
begin
  result := (special = csCurve);
end;

function TRBConnection.GetPitch: double;
begin
  result := -180*arctan((FP2.height-FP1.height)/GetLength())/pi;
end;

end.
