unit uRBSwitch;

interface

uses sysutils, uRBTrack, uGlobalDef, uCurrentSituation, uTools;

type
     TSwitchType= (swNoSwitch, swRight, swLeft);

     TRBSwitch = class(TRBTrack)
       private
       public
         SwitchType: TSwitchType;
         PositionCurve:  boolean; // weiche auf Abzweig gestellt?
         XOffsetStraight: integer; // denn connectable merkt sich nur XOffset, d.h. des abzweigenden Gleises
         function GetXOffset: integer; override;
         function GetAlphaEnd: double; override;
         procedure Paint(); override;
         constructor CreateAndConnectTo(connectTo: TRBTrack; aswitchtype: TSwitchType; acurve: integer; aconnection: cardinal=0);
         constructor CreateFromCommaSeparated(_id: integer; const cs: string); override;
         function GetpropertiesCommaseparated(): string; override;

     end;

implementation



constructor TRBSwitch.CreateAndConnectTo(connectTo: TRBTrack; aswitchtype: TSwitchType; acurve: integer; aconnection: cardinal);
begin
  inherited CreateAndConnectTo(connectTo,aConnection);
  SwitchType := aSwitchType;
  PositionCurve := false;
  XOffsetStraight := round(length*sin(AlphaStart*pi/180)*Pixelpermeter) + connectTo.GetXOffset();
  if SwitchType= swRight then
    Curve := acurve
  else
    Curve := -acurve;
  CalcXOffset();
end;

procedure TRBSwitch.Paint();
begin
  PaintStraight((self=CurrentSituation.CurrentConnectable) and (not PositionCurve));
  PaintCurve((self=CurrentSituation.CurrentConnectable) and (PositionCurve));
end;

// Funktion    : GetXOffset
// Datum       : 29.7.02
// Autor       : up
// Beschreibung: holt den XOffset abhängig von Weichenstellung
function TRBSwitch.GetXOffset: integer;
begin
  if positioncurve then
    result := XOffset
  else
    result := XOffsetStraight;
end;

// bei Geradeausstellung ist dies AlphaStart, sonst AlphaEnd
function TRBSwitch.GetAlphaEnd: double;
begin
  if positioncurve then
    result := AlphaEnd
  else
    result := AlphaStart;
end;

function TRBSwitch.GetpropertiesCommaseparated(): string;
begin
  result := inherited GetpropertiesCommaseparated();
  if SwitchType=swLeft then
    result := result + 'switchl|'
  else
    result := result + 'switchr|';
  result := result + inttostr(XOffsetStraight) + '|';
end;


constructor TRBSwitch.CreateFromCommaSeparated(_id: integer; const cs: string);
var s: string;
begin
  inherited CreateFromCommaSeparated(_id,cs);
  s := StrGetToken(cs,'|',20);
  if s='switchl' then SwitchType := swLeft
  else
  if s='switchr' then SwitchType := swRight;
  XOffsetStraight := strtointdef(StrGetToken(cs,'|',21),0);
end;


end.
