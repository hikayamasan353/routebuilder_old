unit uRBGrid;


interface

uses sysutils, classes, math, utools, uglobaldef;


type
     TRBGridItem = class(TCollectionItem)
       public
         id, // id of connection
         x,z: integer; // sector coordinates of connection
     end;

     TRBGrid = class(TCollection)
       public
         GridName: string;
         GridAngle: double;
         RootConnection: integer;
         procedure AddConnection(id,x,z: integer);
         procedure DeleteConnection(id: integer);
         function GetCellCountX: integer;
         function GetCellCountZ: integer;
         function GetCellXMin: integer;
         function GetCellXMax: integer;
         function GetCellZMin: integer;
         function GetCellZMax: integer;
         function GetAsString: string;
         procedure FillFromString(const aName,aValue: string);
         function GetConnIDAt(_x,_z: integer): integer;
         function IsConnInGrid(_id: integer): boolean;
         function GetGridItemByID(_id: integer): TRBGridItem;
         function GetGridPoint(_x,_z: double; root,GridConst: TDoublePoint): TDoublePoint;
         function GetXZofPoint(p,rootpoint: TDoublePoint; var _x,_z: integer): boolean;
     end;

implementation

function TRBGrid.GetCellCountX: integer;
begin
  result := GetCellXMax() - GetCellXMin();
end;

function TRBGrid.GetCellCountZ: integer;
begin
  result := GetCellZMax() - GetCellZMin();
end;

function TRBGrid.GetCellXMin: integer;
var i,found: integer;
begin
  if count=0 then begin result := 0; end;
  found := 9999;
  for i:=0 to count-1 do
    found := min((items[i] as TRBGridItem).x,found);
  result := found;
end;

function TRBGrid.GetCellXMax: integer;
var i,found: integer;
begin
  if count=0 then begin result := 0; end;
  found := -9999;
  for i:=0 to count-1 do
    found := max((items[i] as TRBGridItem).x,found);
  result := found;
end;

function TRBGrid.GetCellZMin: integer;
var i,found: integer;
begin
  if count=0 then begin result := 0; end;
  found := 9999;
  for i:=0 to count-1 do
    found := min((items[i] as TRBGridItem).z,found);
  result := found;
end;

function TRBGrid.GetCellZMax: integer;
var i,found: integer;
begin
  if count=0 then begin result := 0; end;
  found := -9999;
  for i:=0 to count-1 do
    found := max((items[i] as TRBGridItem).z,found);
  result := found;
end;

function TRBGrid.GetAsString: string;
var i: integer;
    griditem: TRBGridItem;
begin
  result := '"'+GridName+'",'+inttostr(RootConnection);
  for i:=0 to count-1 do
  begin
    griditem := items[i] as TRBGridItem;
    result := result + ','+inttostr(griditem.id) + ',' + inttostr(griditem.x) + ',' + inttostr(griditem.z) ;
  end;
end;

// Funktion: FillFromString
// Autor   : u
// Datum   : 18.5.03
// Beschr. : erstellt Grid aus aValue, aName wird ignoriert.
//    wichtig: GridAngle muss danach noch gesetzt werden. 
procedure TRBGrid.FillFromString(const aName,aValue: string);
var i,c,track_id: integer;
    griditem: TRBGridItem;
begin
  GridName := StripQuotes( StrGetToken(aValue,',',1) );
  RootConnection := strtointdef(StrGetToken(aValue,',',2),-1);
  clear();
  i := 0;
  c := 3;
  while StrGetToken(aValue,',',c)<>'' do
  begin
    track_id := strtointdef(StrGetToken(aValue,',',c),-1);
    if not IsConnInGrid(track_id) then
    begin
      griditem := add() as TRBGridItem;
      griditem.id := track_id;
      griditem.x := strtointdef(StrGetToken(aValue,',',c+1),-1);
      griditem.z := strtointdef(StrGetToken(aValue,',',c+2),-1);
    end;
    inc(i);
    inc(c,3);
  end;
end;

procedure TRBGrid.AddConnection(id,x,z: integer);
var griditem: TRBGridItem;
begin
  griditem := add() as TRBGridItem;
  griditem.id := id;
  griditem.x := x;
  griditem.z := z;
end;

procedure TRBGrid.DeleteConnection(id: integer);
var i: integer;
begin
  for i:=count-1 downto 0 do
    if (items[i] as TRBGriditem).id=id then
      delete(i);
end;

function TRBGrid.GetConnIDAt(_x,_z: integer): integer;
var i: integer;
begin
  for i:=0 to count-1 do
    with (items[i] as TRBGriditem) do
    begin
       if (x=_x)and(z=_z) then begin result := id; exit; end;
    end;
  result := -1;
end;

function tRBGrid.IsConnInGrid(_id: integer): boolean;
var i: integer;
begin
  for i:=0 to count-1 do
    with (items[i] as TRBGriditem) do
    begin
       if (id=_id) then begin result := true; exit; end;
    end;
  result := false;
end;

function TRBGrid.GetGridItemByID(_id: integer): TRBGridItem;
var i: integer;
begin
  for i:=0 to count-1 do
    with (items[i] as TRBGriditem) do
    begin
       if (id=_id) then begin result := items[i] as TRBGriditem; exit; end;
    end;
  result := nil;
end;

function TRBGrid.GetGridPoint(_x,_z: double; root,GridConst: TDoublePoint): TDoublePoint;
begin
  result.x := root.x + _z*GridConst.y*cos(GridAngle*pi/180) + _x*GridConst.x*cos((90-GridAngle)*pi/180);
  result.y := root.y + _z*GridConst.y*sin(GridAngle*pi/180) - _x*GridConst.x*sin((90-GridAngle)*pi/180);
end;

function TRBGrid.GetXZofPoint(p,rootpoint: TDoublePoint; var _x,_z: integer): boolean;
var x,z: integer;
    p1,gridconst: TDoublePoint;
    d,maxdist,bestdist: double;
begin
  bestdist := 9999999;
  Gridconst.x :=cParalleltrackdist;
  Gridconst.y := 25;
  maxdist := distance(Gridconst,doublepoint(0,0));
  result := false;
  for x := -cMaxGridSize to cMaxGridSize do
  begin
     for z := -cMaxGridSize to cMaxGridSize do
     begin
       p1 :=  GetGridPoint(x,z+0.5,rootpoint,gridconst    );
       d :=  Distance(p1,p);
       if (d< maxdist)and(d<bestdist) then
       begin
         bestdist := d;
         _x := x;
         _z := z;
         result := true;
       end;
     end;
  end;
end;

end.
