unit uRBMiniMap;

interface

uses sysutils, types, classes, math, contnrs, graphics,
     uRBConnection, uCurrentSituation,
     urbConnectionlist, uRBPoint, uRBProject, uglobaldef, utools;

type
     TRBMiniMap= class(TObject)
                 public
                   boundingRect: TRect;
                   MiniRect : TRect;
                   ShowPoints: boolean;
                   CurrentProject: TRBProject;
                   procedure CalculateBoundingRect(connlist: TRBConnectionlist);
                   function ConvertCoordMiniToWorld(mini: TPoint):TDoublePoint;
                   function ConvertCoordWorldToMini(world: TDoublePoint):TPoint;
                   procedure DrawMap(canvas: TCanvas; connections: TObjectList; points: TObjectList);
                 end;

implementation

procedure TRBMiniMap.CalculateBoundingRect(connlist: TRBConnectionlist);
var i:integer;
    conn: TRBConnection;
    p : TDoublePoint;
begin
  boundingRect.Left := 9999;
  boundingRect.Right:= -9999;
  boundingRect.Top  := -9999;
  boundingRect.Bottom:= 9999;

  for i:=0 to connlist.Count-1 do
  begin
    conn :=  connlist.GetConnection(i);
    p := conn.P1.point;
    boundingRect.Left  := min(boundingRect.Left,round(p.x));
    boundingRect.Right := max(boundingRect.Right,round(p.x));
    boundingRect.top   := max(boundingRect.top,round(p.y));
    boundingRect.bottom:= min(boundingRect.bottom,round(p.y));
    p := conn.P2.point;
    boundingRect.Left  := min(boundingRect.Left,round(p.x));
    boundingRect.Right := max(boundingRect.Right,round(p.x));
    boundingRect.top   := max(boundingRect.top,round(p.y));
    boundingRect.bottom:= min(boundingRect.bottom,round(p.y));
  end;
end;

function TRBMiniMap.ConvertCoordMiniToWorld(mini: TPoint):TDoublePoint;
var xf,yf,f:double;
begin
  xf := abs((boundingRect.right-boundingrect.left)/(miniRect.Right-miniRect.Left));
  yf := abs((boundingRect.bottom-boundingRect.top)/(miniRect.Top-miniRect.Bottom));
  f := max(xf,yf);
  result.X := (mini.x-MiniRect.left)*f  +boundingRect.left;
  result.y := -(mini.y-MiniRect.bottom)*f  +boundingRect.bottom;
end;

function TRBMiniMap.ConvertCoordWorldToMini(world: TDoublePoint):TPoint;
var xf,yf,f:double;
begin
  xf := abs((boundingRect.right-boundingrect.left)/(miniRect.Right-miniRect.Left));
  yf := abs((boundingRect.bottom-boundingRect.top)/(miniRect.Top-miniRect.Bottom));
  f := max(xf,yf);
  if f<>0 then
  begin
    result.X := round((world.x-boundingrect.left)/f  +miniRect.left);
    result.y := round(-(world.y-boundingrect.bottom)/f  +miniRect.bottom);
  end;
end;

procedure TRBMiniMap.DrawMap(canvas: TCanvas; connections: TObjectList; points: TObjectList);
var i: integer;
    p1,p2: TDoublePoint;
    m1,m2,po: TPoint;
    conn: TRBConnection;
    p: TRBPoint;
begin
  canvas.Pen.Style := psSolid;
  canvas.Pen.Width := 2;
  for i:=0 to connections.Count-1 do
  begin
    conn :=  connections.items[i] as TRBConnection;
    p1 := conn.P1.point;
    p2 := conn.P2.point;
    m1 := ConvertCoordWorldToMini(p1);
    m2 := ConvertCoordWorldToMini(p2);
    if CurrentProject.GetStationByTrackID(conn.id)<>nil then
      canvas.Pen.Color := TrackColorStation
    else
    if conn=CurrentSituation.CurrentConnection then
      canvas.Pen.color := TrackColorCurrent
    else
      canvas.Pen.color := TrackColorMap;

    canvas.MoveTo(m1.X,m1.y); canvas.LineTo(m2.x,m2.y);
{    if(conn is TRBSwitch) then
    begin
      p2 := conn.GetEndPoint(1);
      m2 := ConvertCoordWorldToMini(p2);
      canvas.MoveTo(m1.X,m1.y); canvas.LineTo(m2.x,m2.y);
    end;}
  end;
  // Cursor
  po:= ConvertCoordWorldToMini(CurrentSituation.Offset);
  canvas.Pen.Width := 1;
  canvas.Pen.Color := clBlack;
  canvas.Pen.style := psSolid;
  canvas.MoveTo(po.X,po.Y-4);
  canvas.LineTo(po.x,po.y+4);
  canvas.MoveTo(po.x-4,po.y);
  canvas.LineTo(po.x+4,po.y);
//  canvas.Ellipse(p1.x-2,p1.y-2,p1.X+2,p1.y+2);

  if ShowPoints then
  begin
    // Points
    for i:=0 to Points.count-1 do
    begin
      p := points[i] as TRBPoint;
      po:= ConvertCoordWorldToMini(p.point);
      canvas.Brush.Color := clRed;
      canvas.Brush.Style := bsSolid;
      canvas.Pen.Style := psClear;
      canvas.Ellipse(po.x-5,po.y-5,po.x+5,po.Y+5);
    end;
  end;
end;

end.
