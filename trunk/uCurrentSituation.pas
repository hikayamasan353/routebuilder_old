unit uCurrentSituation;

interface

uses Types, uGlobalDef, uRBRouteDefinition, uRBPoint, uRBConnection, uRBObject,
     uRBGrid;

type
     TCurrentSituation = class(TObject)
        CurrentRouteDefinition: TRBRouteDefinition;
        PleaseUpdateView,ignoreClick: boolean; // auf true setzen->Editor-Timer aktualisiert View
        Cursor,Offset,
        SelArea1,SelArea2: TDoublePoint; // Offset vom Koordinatenursprung zum Mittelpunkt des Editorfensters in m
//        CurrentConnection:  Cardinal; // 0, auﬂer wenn CurrentConnectable eine Weiche ist und auf Abzweig steht
        CurrentPoint: TRBPoint;
        CurrentPointTouched: TRBPoint;
        CurrentConnection: TRBConnection;
        CurrentObject,
        CurrentObjectTouched: TRBObject;
        CurrentGrid: TRBGrid;
        CurrentGridX,CurrentGridZ: integer;
        function CurrentRouteDefinitionID: cardinal; // ID der aktuellen RouteDefinition
        function CurrentRouteDefinitionContainsTrack(id: integer): boolean;
        constructor Create;
        public
        Zoom:   double; // pixel per meter
        TrackLength: integer;
     end;

var
    Currentsituation: TCurrentSituation;

implementation


constructor TCurrentSituation.Create;
begin
  inherited;
  Zoom := pixelpermeter;
  TrackLength := 25;
  CurrentPoint := nil;
  CurrentPointTouched := nil;
  CurrentConnection := nil;
  CurrentObject := nil;
  CurrentObjectTouched := nil;
end;

function TCurrentSituation.CurrentRouteDefinitionID: cardinal;
begin
  if CurrentRouteDefinition=nil then
    result := 0
  else
    result := CurrentRouteDefinition.RouteDefinitionID;
end;

function TCurrentSituation.CurrentRouteDefinitionContainsTrack(id: integer): boolean;
begin
  if CurrentRouteDefinition=nil then
    result := false
  else
    result := CurrentRouteDefinition.ContainsTrack(id);
end;


initialization
   Currentsituation:= TCurrentSituation.Create();

finalization
   Currentsituation.free;

end.
