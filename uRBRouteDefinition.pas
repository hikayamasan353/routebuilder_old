unit uRBRouteDefinition;

interface

uses sysutils, classes;

type
     TRBRouteDefinition = class(TStringList)
        public
        RouteDefinitionID:   integer;
        RouteDefinitionname: string;
        function GetTitle: string;
        function ContainsTrack(ID: integer): boolean;
        procedure AddTrack(ID: integer);
        procedure DeleteTrack(ID: integer);
        function GetConnIDAt(i: integer): integer;
     end;

implementation

function TRBRouteDefinition.GetTitle: string;
begin
  result :=  'ID' + inttostr(RouteDefinitionID) + ': ' + RouteDefinitionname;
end;

function TRBRouteDefinition.ContainsTrack(ID: integer): boolean;
begin
  result := (indexof(inttostr(ID))>=0);
end;

procedure TRBRouteDefinition.AddTrack(ID: integer);
begin
  if not ContainsTrack(ID) then
    Add(inttostr(ID));
end;

procedure TRBRouteDefinition.DeleteTrack(ID: integer);
begin
  if ContainsTrack(ID) then
    Delete(indexof(inttostr(ID)));
end;

function TRBRouteDefinition.GetConnIDAt(i: integer): integer;
begin
  result := strtointdef(strings[i],0);
end;
end.
