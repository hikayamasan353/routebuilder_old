unit uRBConnectionList;

interface

uses sysutils, classes, contnrs,
     uglobaldef, utools,
     uRBPoint, urbConnection,
     toptions;

type TRBConnectionlist = class(TObjectlist)
       public
        function FindConnectionsAtPoint(point: TRBPoint; connlist: TObjectList; NotThis: TRBConnection): integer;
        procedure DeleteConnection(conn: TRBConnection);
        function FindByID(id: integer): TRBConnection;
        procedure AddConnection(conn: TRBConnection);
        function GetConnection(index: integer): TRBConnection;
        procedure MoveConnection(conn: TRBConnection; newindex: integer);
        function GetTracksInSegment(p1,p2: TDoublePoint; l: integer; Tracklist: TRBconnectionlist; NotThisOne: TRBConnection): integer;
        function ImproveConnection(conn: TRBConnection; pointcount: integer; improvedpoints: TObjectlist): integer;
        procedure InsertConnection(conn: TRBConnection; index: integer);
        function GetConnIndexWithSmallestAngle(conn: TRBConnection): integer;
        function GetConnWithSmallestAngle(conn: TRBConnection): TRBConnection;
     end;

     TRBConnectionListProc =  procedure (connlist: TRBConnectionlist) of object;

implementation

function TRBConnectionlist.FindConnectionsAtPoint(point: TRBPoint; connlist: TObjectList; NotThis: TRBConnection): integer;
var i: integer;
begin
  connlist.clear();
  for i:=0 to count-1 do
  begin
    // notwendige Abfrage, da manchmal aus derzeit ungeklärten Gründen nicht-Connections in dieser Liste sind (TODO: wo kommen die her?)
    if items[i] is TRBConnection then
    begin
      if((items[i] as TRBConnection).P1=point)or((items[i] as TRBConnection).P2=point) then
      begin
        if items[i] as TRBConnection <> NotThis then
          connlist.add(items[i] as TRBConnection);
      end;
    end;
  end;
  result := connlist.count;
end;

function TRBConnectionlist.GetConnection(index: integer): TRBConnection;
begin
  if index<count then
  begin
    if items[index] is TRBConnection then
      result := items[index] as TRBConnection
    else
      result := nil;
  end
  else
    result := nil;
end;

procedure TRBConnectionlist.DeleteConnection(conn: TRBConnection);
var i: integer;
begin
  i := IndexOf(conn);
  if i>=0 then delete(i);
end;

function TRBConnectionlist.FindByID(id: integer): TRBConnection;
var i: integer;
begin
  for i:=0 to count-1 do
  begin
    if(items[i] as TRBConnection).id = id then
    begin
      result := items[i] as TRBConnection;
      exit;
    end;
  end;
  result := nil;
end;

procedure TRBConnectionlist.AddConnection(conn: TRBConnection);
begin
//  if indexof(conn)<0 then // auf keinen Fall!!!!!
    add(conn);
end;

procedure TRBConnectionlist.MoveConnection(conn: TRBConnection; newindex: integer);
var i: integer;
begin
  i := indexof(conn);
  if i>=0 then
    Move(i,newindex);
end;

// Funktion: GetTracksInSegment
// Autor   : up
// Datum   : 11.1.03
// Beschr. : sucht zwischen p1 und p2 sowie links und rechts bis zu l Metern nach Connections
// und gibt sie in der Tracklist zurück (außer die ist nil) und gibt die Anzahl der Treffer zurück
function TRBConnectionlist.GetTracksInSegment(p1,p2: TDoublePoint; l: integer; Tracklist: TRBconnectionlist; NotThisOne: TRBConnection): integer;
var i,c: integer;
    conn: TRBConnection;
    a,b: double;
begin
  result := 0;
  c := 0;
  if Tracklist<>nil then
    Tracklist.Clear();
  for i:=0 to Count-1 do
  begin
    conn := GetConnection(i);
    if conn<>notThisOne then
    begin
      if (IsPointInSegment(p1,p2,conn.P1.point,l,a,b))
       or(IsPointInSegment(p1,p2,conn.P2.point,l,a,b)) then
      begin
        conn.b_temp := b;
        conn.a_temp := a;
        if Tracklist<>nil then Tracklist.add(conn);
        inc(c);
      end;
    end;
  end;
  result := c;
end;

// Funktion: ImproveConnection
// Autor   : up
// Datum   : 8.12.02
// Beschr. : sucht in der Liste nach Hilfpunkten für die conn und gibt Liste der bezier- oder interpolierten Punkte zurück
// erzeugt pointcount Point-Objekte und gibt sie in der Liste zurück. Diese müssen freigegeben werden
function TRBConnectionlist.ImproveConnection(conn: TRBConnection; pointcount: integer; improvedpoints: TObjectlist): integer;
var i: integer;
    mina,h: double;
    connlist: TRBConnectionlist;
    conn1: TRBConnection;
    helppointsExist: boolean;
    Point,Helppoint1,Helppoint2: TRBPoint;
    p: TDoublePoint;
begin
  improvedpoints.Clear;
  connlist := TRBConnectionlist.create;
  connlist.OwnsObjects := false;
  helppointsExist := true;
  FindConnectionsAtPoint(conn.P1,connlist,conn);

  if (connlist.count=0)or(not conn.curved) then
  begin
    helppointsExist := false;
  end
  else
  begin
    conn1 := connlist.GetConnection(0);
    mina := 90;
    // mehr als 1 gefunden? (Weiche, richtigen aussuchen)
    for i:=0 to connlist.count-1 do
      if abs(180-Triangle(conn.P1.point,connlist.getConnection(i).GetPointButnot(conn.P1).point,conn.P2.point))<mina then
      begin
        conn1 := connlist.getconnection(i);
        mina := abs(180-Triangle(conn.P1.point,connlist.getConnection(i).GetPointButnot(conn.P1).point,conn.P2.point));
      end;
    if conn1.P1=conn.P1 then
     Helppoint1 := conn1.p2
    else
     Helppoint1 := conn1.P1;
    connlist.clear();
    // Hilfspunkt 2
    FindConnectionsAtPoint(conn.P2,connlist,conn);
    if connlist.count=0 then
    begin
      helppointsExist := false;
    end
    else
    begin
      conn1 := connlist.GetConnection(0);
      mina := 90;
      try
      for i:=0 to connlist.count-1 do
        if abs(180-Triangle(conn.P1.point,connlist.getConnection(i).GetPointButnot(conn.P1).point,conn.P2.point))<mina then
        begin
          conn1 := connlist.getconnection(i);
          mina := abs(180-Triangle(conn.P1.point,connlist.getConnection(i).GetPointButnot(conn.P1).point,conn.P2.point));
        end;
      finally
      if conn1.P1=conn.P2 then
       Helppoint2 := conn1.p2
      else
       Helppoint2 := conn1.P1;
      connlist.clear();
      end;
    end;
  end;

  
  // zusätzliche Punkte
  for i:=1 to pointcount-1 do
  begin
    // wenn keine Hilfspunkte existieren, linear interpolieren
    if not helppointsExist then
    begin
      TRBPoint.Interpolate(conn.P1,
                conn.P2,i/pointcount,p,h)
    end
    else
    begin
      if formoptions.UseEllipcitalCurves then
        // sonst  kurvige Interpolation
        TRBPoint.CurveValue(conn.P1,
                conn.P2,
                Helppoint1, Helppoint2,
                i/pointcount,p,h)
    else
      // sonst Bezier-Interpolation (d.h. kubisch, glaube ich...)
        TRBPoint.BezierValue(conn.P1,
                conn.P2,
                Helppoint1, Helppoint2,
                i/pointcount,cBezierFactor/sqrt(conn.GetLength()),p,h);
    end;
    // neuer sekundärer Point
    Point := TRBPoint.Create(p,h);
    improvedpoints.Add(Point);
  end;
  connlist.free;
  result := improvedpoints.Count;
end;

procedure TRBConnectionlist.insertConnection(conn: TRBConnection; index: integer);
begin
  Insert(index,conn);
end;

function TRBConnectionlist.GetConnIndexWithSmallestAngle(conn: TRBConnection): integer;
var i,min_i: integer;
    min_a: double;
begin
  min_i := -1;
  min_a := 999;
  for i:=0 to count-1 do
  begin
    if abs( getconnection(i).GetAngle(conn) ) < min_a then
    begin
      min_a := abs( getconnection(i).GetAngle(conn) );
      min_i := i;
    end;
  end;
  result := min_i;
end;

function TRBConnectionlist.GetConnWithSmallestAngle(conn: TRBConnection): TRBConnection;
begin
  result := GetConnection( GetConnIndexWithSmallestAngle(conn) );
end;

end.
