unit uRBConnectable;

// Route Builder
// enthält TRBConnectable
// Autor: up
// Erstellt: 14.7.02

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ExtCtrls,
  math, uGlobalDef;

type
  TRBConnectable = class(TPaintbox)
  protected
    { Protected declarations }
    FXPosition,
    FZPosition,
    FLastXPosition,
    FLastZPosition,
    FLength: integer;
    FDraggingPossible: boolean;
    FChangeRadiusPossible: boolean;
    FDragging: boolean;
    FchangingRadius: boolean;
    FAX,FAY,FAXP,FAYP: integer; // dragging-Koordinaten

    procedure RBTrack1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure RBTrack1MouseMove(Sender: TObject; Shift: TShiftState; X,  Y: Integer);
    procedure RBTrack1MouseUp(Sender: TObject; Button: TMouseButton;  Shift: TShiftState; X, Y: Integer);
    procedure SetXPosition(x: integer);
    procedure SetZPosition(z: integer);
    procedure SetLength(l: integer);
  public
    { Public declarations }
    ConnectedTo: TRBConnectable;
    Connection:  Cardinal; // 0, außer wenn ein Gleis am Abzweig einer Weiche hängt, dann 1  
    ParallelTo:  TRBConnectable;
    Curve:    integer; // Kurvenradius in m (negativ: Linkskurve, sonst Rechtskurve)
    AlphaStart,
    AlphaEnd  : double;
    XOffset   : integer;
    // Positionsangaben sind Propertys, da schreiben sich auf verknüpfte Connectables auswirkt!
    property XPosition: integer Read FXPosition Write SetXPosition; // Position links - rechts (in m)
    property ZPosition: integer Read FZPosition Write SetZPosition;    // Position in Fahrtrichtung (in m)
    property Length   : integer Read FLength    Write SetLength; // Länge in Fahrtrichtung (in m).
                         // Hinweis: Die YPosition ist immer YPosition(vorheriges Gleis)+Length(vorheriges Gleis)
    function CalcRadius(dx,alpha: integer): integer;
    function GetXOffset: integer; virtual;
    function GetAlphaEnd: double; virtual;
    procedure CalcXOffset();
    procedure DoConnect(Conn: TRBConnectable; aConnection: cardinal=0);

    constructor Create();
    constructor CreateAndConnectTo(ConnectTo: TRBConnectable; aConnection: cardinal=0);
    constructor CreateParallelTo(ParallelTo: TRBConnectable; XOffset: integer);
  end;


implementation


constructor TRBConnectable.Create();
begin
  inherited Create(nil); // no owner, weil unsere ObjectList sich um die Freigabe kümmert
  ConnectedTo := nil;
  ParallelTo  := nil;
  Connection  := 0;
  FDragging := false;
  FChangeRadiusPossible := false;
  XPosition := 0;
  ZPosition := 0;
  Length    := 25;
  OnMouseDown := RBTrack1MouseDown;
  OnMouseMove := RBTrack1MouseMove;
  OnMouseUp   := RBTrack1MouseUp;
  Width := 29;
end;

// Funktion    : CreateParallelTo
// Datum       : 14.7.02
// Autor       : up
// Beschreibung: erzeugt Parallelobjekt, um XOffset m verschoben (<0 links, >0 rechts)
constructor TRBConnectable.CreateParallelTo(ParallelTo: TRBConnectable; XOffset: integer);
begin
  Create();
  ParallelTo := ParallelTo;
  // übernehmen der betreffenden Größen
  ZPosition := ParallelTo.ZPosition;
  XPosition := ParallelTo.XPosition + XOffset;
  Length    := ParallelTo.Length;
end;

// Funktion    : CreateAndConnectTo
// Datum       : 14.7.02
// Autor       : up
// Beschreibung: erzeugt Objekt, das am angegeben in Fahrtrichtung angehängt wird
constructor TRBConnectable.CreateAndConnectTo(ConnectTo: TRBConnectable; aConnection: cardinal);
begin
  Create();
  DoConnect(ConnectTo,aConnection);
end;

procedure TRBConnectable.DoConnect(Conn: TRBConnectable; aConnection: cardinal);
begin
  if Conn=nil then exit;
  ConnectedTo := Conn;
  Connection := aConnection;
  ZPosition := Conn.ZPosition + Conn.Length;
  XPosition := Conn.XPosition;
  FDraggingPossible := false;
end;

// interne Funktion, wird aufgerufen, wenn x-Position sich ändert
procedure TRBConnectable.SetXPosition(x: integer);
begin
  // derzeit keine Auswirkung auf verknüpfte Connectables
  FXPosition := x;
end;

procedure TRBConnectable.SetZPosition(z: integer);
begin
  // derzeit keine Auswirkung auf verknüpfte Connectables
  FZPosition := z;
end;

procedure TRBConnectable.SetLength(l: integer);
begin
  // derzeit keine Auswirkung auf verknüpfte Connectables
  FLength := l;
end;

// Funktion    : GetXOffset
// Datum       : 29.7.02
// Autor       : up
// Beschreibung: holt den XOffset. In Ableitungen (Weichen!) kann dies anders aussehen.
function TRBConnectable.GetXOffset: integer;
begin
  result := XOffset;
end;

// s.o.
function TRBConnectable.GetAlphaEnd: double;
begin
  result := AlphaEnd;
end;


// Funktion    : CalcRadius
// Datum       : 15.7.02
// Autor       : up
// Beschreibung: berechnet Radius aus Verschiebung des oberen Punktes bei gegebenem Kurvenwinkel alpha
//               Radius>0: Rechtskurve. Radius=0: Gerade.
function TRBConnectable.CalcRadius(dx,alpha: integer): integer;
begin
  if alpha=0 then result := 0;
  result := round(dx/(1-cos(alpha*pi/180)));
end;


procedure TRBConnectable.RBTrack1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FDraggingPossible and (mbLeft = Button) and not(ssCtrl in Shift)then
  begin
      Fdragging := true;
      FAX := x;
      FAY := y;
      FLastXPosition := FXPosition;
      FLastZPosition := FZPosition;
      FAXP := Left;
      FAYP := top;
  end;
  if FChangeRadiusPossible and (mbLeft = Button)and (ssCtrl in Shift) then
  begin
    FchangingRadius := true;
    FAX := x;
  end;
end;

procedure TRBConnectable.RBTrack1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);

begin
  if FDragging then
  begin
    left := ((left + (x-fax))div PixelperMeter) * PixelperMeter;
    top  := ((top  + (y-fay))div PixelperMeter) * PixelperMeter;
//    left := left + (x-fax);
  //  top  := top  + (y-fay);
  end;
  if FChangingRadius then
  begin
    //Curve := CalcRadius(x-fax,30 );
    if(x=fax) then
      Curve := 0
    else
    begin
      Curve := round(500*PixelPerMeter/(x-fax));
      // normalerweise machen wir 100m-Schritte, bei Shift auf einen m genau
      if not(ssShift in Shift) and (abs(curve)>=MinCurve) then curve := CurveRadStep*(curve div CurveRadStep);
      if (Curve>0) and (Curve<MinCurve)  then Curve := MinCurve;
      if (Curve<0) and (Curve>-MinCurve) then Curve := -MinCurve;
    end;
    CalcXOffset();

    repaint;
  end;
end;

procedure TRBConnectable.CalcXOffset();
var alpha: double;
begin
  // die folgende etwas komplizierte Formel
  //   berechnet den horizontalen Abstand vom Anfang bis Ende des Gleises (in Pixeln)
  if Curve<>0 then
  begin
    alpha := 180*length/curve/pi;
    if alphastart=0 then
      XOffset := round(curve*(1-cos(degtorad(alpha)))*Pixelpermeter)
    else
      XOffset := round(curve*2*sin(degtorad(alpha/2))*sin(degtorad(alphastart+alpha/2))*PixelperMeter);
  end
  else
    XOffset := round(length*sin(AlphaStart*pi/180)*Pixelpermeter);
  if ConnectedTo<>nil then XOffset := XOffset + ConnectedTo.GetXOffset;

end;

procedure TRBConnectable.RBTrack1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FDragging then
  begin
    left := ((left + (x-fax))div PixelperMeter) * PixelperMeter;
    top  := ((top  + (y-fay))div PixelperMeter) * PixelperMeter;
    FZPosition := FLastZPosition - (top-fayp)div PixelperMeter;
    FXPosition := FLastXPosition + (left-faxp)div PixelperMeter;
  end;
  FDragging       := false;
  FChangingRadius := false;
end;

end.

