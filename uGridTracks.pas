unit uGridTracks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ComCtrls, ImgList, StdCtrls, ExtCtrls, utools,
  uRBGrid, uRBConnection, uRBPoint, uRBConnectionList,
  ucurrentsituation, uRBProject, uEditorFrame,
  uGlobalDef;

type
  TFormGridTracks = class(TForm)                    
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    lStatus: TLabel;
    Timer1: TTimer;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton15Click(Sender: TObject);
    procedure ToolButton16Click(Sender: TObject);
  private
    { Private declarations }
    gridroot: TRBConnection;
    curr_id,direction: integer;
    new_x,new_z: double;
    function GetCurrentGrid: TRBGrid;
    procedure EnableDisable;
    function NewPoint(x,z: double): TDoublepoint;
    procedure AddTrack(point1,point2: TRBPoint; s1: TConnectionSpecial; advance: boolean=false);
    procedure AddSwitch(point1,point2,point3: TRBPoint; s1,s2: TConnectionSpecial; advance: boolean=false);
    function GetPointAt(p: TDoublePoint): TRBPoint;
    function GetConnFromTo(p1,p2: TRBPoint;direction:integer): TRBConnection;
  public
    { Public declarations }
    CurrentProject: TRBProject;
    EditorFrame: TFrmEditor;
  end;

var
  FormGridTracks: TFormGridTracks;

implementation

uses toptions, uTrackProperties;

{$R *.dfm}

procedure TFormGridTracks.FormShow(Sender: TObject);
begin
  //
  EnableDisable();
end;

procedure TFormGridTracks.Timer1Timer(Sender: TObject);
begin
  EnableDisable();
end;



procedure TFormGridTracks.EnableDisable;
begin
  lStatus.caption  := '';
  ToolBar1.Enabled := true;
  if (GetCurrentGrid()=nil)
  or((CurrentSituation.CurrentGridX=0)and(CurrentSituation.CurrentGridZ=0)) then
  begin
    //ToolBar1.Enabled := false;
    lStatus.caption  := 'no grid point active';
  end
  else
  begin
    lStatus.caption := format('%f/%f',[new_x,new_z]);
  end;
  ToolButton1.Enabled := ToolBar1.Enabled;
  ToolButton2.Enabled := ToolBar1.Enabled;
  ToolButton3.Enabled := ToolBar1.Enabled;
  ToolButton4.Enabled := ToolBar1.Enabled;
  ToolButton5.Enabled := ToolBar1.Enabled;
  ToolButton6.Enabled := ToolBar1.Enabled;
  ToolButton7.Enabled := ToolBar1.Enabled;
  ToolButton11.Enabled := ToolBar1.Enabled;
  ToolButton12.Enabled := ToolBar1.Enabled;
  ToolButton13.Enabled := ToolBar1.Enabled;
  ToolButton14.Enabled := ToolBar1.Enabled;
end;

// Funktion: GetCurrentGrid
// Autor   : u
// Datum   : 10.08.03
// Beschr. : ermittelt das aktuelle Grid. Wenn gefunden, werden auch gridroot und new_x und new_z gesetzt
function TFormGridTracks.GetCurrentGrid: TRBGrid;
begin
  result := Currentsituation.CurrentGrid;
  if (result<>nil)and(CurrentProject<>nil) then
  begin
    gridroot := CurrentProject.FindConnectionByID(result.RootConnection);
    new_x    := Currentsituation.CurrentGridX;
    new_z    := Currentsituation.CurrentGridz;
    direction:= sgn(new_z);
  end;
end;
// berechnet die Koordinaten des Grid-Punktes x,z
function TFormGridTracks.NewPoint(x,z: double):TDoublepoint;
var gridconst: TDoublePoint;
begin
  if GetCurrentGrid=nil then exit;
  Gridconst.x := cParalleltrackdist;
  Gridconst.y := 25;   // z
  result := GetCurrentGrid.GetGridPoint(x,z,gridroot.P1.point,gridconst);
end;

// erzeugt einen Punkt an der gewünschten Stelle oder liefert den zurück, der schon da ist.
function TFormGridTracks.GetPointAt(p: TDoublePoint): TRBPoint;
begin
  // gibt es hier einen Punkt?
  result := CurrentProject.FindPointNearPoint(p,1.5);
  if result=nil then
  begin
    result := TRBPoint.create(p);
    CurrentProject.AddPoint(result);
    EditorFrame.AddUndoAction(rbaAddPoint,result,nil,result.point);
  end;
end;

function TFormGridTracks.GetConnFromTo(p1,p2: TRBPoint;direction:integer): TRBConnection;
begin
  result := CurrentProject.FindConnectionFromTo(p1,p2);
  if result=nil then
  begin
    if direction=1 then
      result := TRBConnection.Create(p1,p2)
    else
      result := TRBConnection.Create(p2,p1);
    CurrentProject.AddConnection(result);
    EditorFrame.AddUndoAction(rbaAddConnection,result,nil,result.P1.point);
  end
  else
  begin
    // sicherstellen, dass gefundene conn richtig herum ist
    if result.P1=p1 then
    begin
      if direction<0 then result.Turn;
    end
    else
    begin
      if direction>0 then result.Turn;
    end;
  end;
end;

procedure TFormGridTracks.ToolButton1Click(Sender: TObject);
var p: TDoublePoint;
    point1,point2: TRBPoint;
    conn: TRBConnection;
begin
  GetCurrentGrid();
  if GetCurrentGrid.GetConnIDAt(round(new_x),round(new_z))<>-1 then
  begin
    exit;
  end;
  point1 := GetPointAt(NewPoint(new_x,new_z));
  point2 := GetPointAt(NewPoint(new_x,new_z+1));
  AddTrack(point1,point2,csFixed,true);
end;

procedure TFormGridTracks.AddTrack(point1,point2: TRBPoint; s1: TConnectionSpecial; advance: boolean);
var conn: TRBConnection;
begin
  if(point1.height<>point2.height) then
  begin
    if point1.height=0 then point1.height := point2.height;
    if point2.height=0 then point2.height := point1.height;
  end;
  conn := GetConnFromTo(point1,point2,1);
  conn.special := s1;
  GetCurrentGrid.AddConnection(conn.id,round(new_x),round(new_z));
  EditorFrame.ApplyConnAppearance(conn);
  CurrentProject.SnapPointToGrid(point1);
  CurrentProject.SnapPointToGrid(point2);
  CurrentSituation.CurrentConnection := conn;
  CurrentSituation.CurrentPoint      := point2;
  if advance then inc( Currentsituation.CurrentGridz );
  CurrentSituation.PleaseUpdateView  := true;
  if FormTrackProperties.Visible and (conn<>FormTrackProperties.Track) then
  begin
    FormTrackProperties.Track := conn;
    FormTrackProperties.FormShow(self);
  end;
end;

procedure TFormGridTracks.AddSwitch(point1,point2,point3: TRBPoint; s1,s2: TConnectionSpecial; advance: boolean);
var  conn1,conn2: TRBConnection;
begin
  // Abzweig
  conn1 := GetConnFromTo(point1,point3,1);
  conn1.special := s2;
  GetCurrentGrid.AddConnection(conn1.id,round(new_x),round(new_z));
  EditorFrame.ApplyConnAppearance(conn1);
  CurrentProject.SnapPointToGrid(point1);
  CurrentProject.SnapPointToGrid(point2);
  CurrentProject.SnapPointToGrid(point3);
  // Gerade
  conn2 := GetConnFromTo(point1,point2,1);
  conn2.special := s1;
  GetCurrentGrid.AddConnection(conn2.id,round(new_x),round(new_z));
  EditorFrame.ApplyConnAppearance(conn2);
  if advance then inc( Currentsituation.CurrentGridz );
  CurrentSituation.CurrentConnection := conn2;
  CurrentSituation.CurrentPoint      := point2;
  CurrentSituation.PleaseUpdateView  := true;
end;

procedure TFormGridTracks.ToolButton2Click(Sender: TObject);
var point1,point2,point3: TRBPoint;
begin
  GetCurrentGrid();
  // Weiche links
  point1 := GetPointAt(NewPoint(new_x,new_z));
  point2 := GetPointAt(NewPoint(new_x,new_z+1));
  point3 := GetPointAt(NewPoint(new_x-0.5,new_z+1));
  AddSwitch(point1,point2,point3,csSwitchLeftUpStraight,csSwitchLeftUpCurve,true);
end;

procedure TFormGridTracks.ToolButton3Click(Sender: TObject);
var point1,point2,point3: TRBPoint;
begin
  GetCurrentGrid();
  // Weiche rechts
  point1 := GetPointAt(NewPoint(new_x,new_z));
  point2 := GetPointAt(NewPoint(new_x,new_z+1));
  point3 := GetPointAt(NewPoint(new_x+0.5,new_z+1));
  AddSwitch(point1,point2,point3,csSwitchRightUpStraight,csSwitchRightUpCurve,true);
end;

procedure TFormGridTracks.ToolButton4Click(Sender: TObject);
var point1,point2,point3: TRBPoint;
begin
  GetCurrentGrid();
  // Weiche rechts
  point1 := GetPointAt(NewPoint(new_x,new_z+1));
  point2 := GetPointAt(NewPoint(new_x,new_z));
  point3 := GetPointAt(NewPoint(new_x-0.5,new_z));
  AddSwitch(point1,point2,point3,csSwitchRightUpStraight,csSwitchRightUpCurve);
end;

procedure TFormGridTracks.ToolButton5Click(Sender: TObject);
var point1,point2,point3: TRBPoint;
begin
  GetCurrentGrid();
  // Weiche links
  point1 := GetPointAt(NewPoint(new_x,new_z+1));
  point2 := GetPointAt(NewPoint(new_x,new_z));
  point3 := GetPointAt(NewPoint(new_x+0.5,new_z));
  AddSwitch(point1,point2,point3,csSwitchLeftUpStraight,csSwitchLeftUpCurve);

end;

procedure TFormGridTracks.ToolButton6Click(Sender: TObject);
var point1,point2: TRBPoint;
begin
  GetCurrentGrid();
  // Kurve links
  point1 := GetPointAt(NewPoint(new_x,new_z));
  point2 := GetPointAt(NewPoint(new_x-0.5,new_z+1));
  AddTrack(point1,point2,csFixedCurveLeft);
end;

procedure TFormGridTracks.ToolButton7Click(Sender: TObject);
var point1,point2: TRBPoint;
begin
  GetCurrentGrid();
  // Kurve rechts
  point1 := GetPointAt(NewPoint(new_x,new_z));
  point2 := GetPointAt(NewPoint(new_x+0.5,new_z+1));
  AddTrack(point1,point2,csFixedCurveRight);
end;

procedure TFormGridTracks.ToolButton11Click(Sender: TObject);
var point1,point2: TRBPoint;
begin
  GetCurrentGrid();
  // Kurve links
  point1 := GetPointAt(NewPoint(new_x-0.5,new_z));
  point2 := GetPointAt(NewPoint(new_x,new_z+1));
  AddTrack(point1,point2,csFixedCurveLeft);
end;

procedure TFormGridTracks.ToolButton12Click(Sender: TObject);
var point1,point2: TRBPoint;
begin
  GetCurrentGrid();
  // Kurve rechts
  point1 := GetPointAt(NewPoint(new_x+0.5,new_z));
  point2 := GetPointAt(NewPoint(new_x,new_z+1));
  AddTrack(point1,point2,csFixedCurveRight);
end;

procedure TFormGridTracks.ToolButton13Click(Sender: TObject);
var point1,point2: TRBPoint;
begin
  GetCurrentGrid();
  // links unten nach rechts oben
  point1 := GetPointAt(NewPoint(new_x-0.5,new_z));
  point2 := GetPointAt(NewPoint(new_x+0.5,new_z+1));
  AddTrack(point1,point2,csFixed);
end;

procedure TFormGridTracks.ToolButton14Click(Sender: TObject);
var point1,point2: TRBPoint;
begin
  GetCurrentGrid();
  // rechts unten nach links oben
  point1 := GetPointAt(NewPoint(new_x+0.5,new_z));
  point2 := GetPointAt(NewPoint(new_x-0.5,new_z+1));
  AddTrack(point1,point2,csFixed);
end;

// new grid root
procedure TFormGridTracks.ToolButton8Click(Sender: TObject);
var grid: TRBGrid;
    conn: TRBConnection;
begin
  // erzeuge zwei points und eine connection
  EditorFrame.tbNewPointClick(self);
  Currentsituation.Cursor.y := Currentsituation.Cursor.y +25;
  EditorFrame.tbAddAndConnectClick(self);
  currentsituation.CurrentConnection.special := csFixed;
  // erzeuge grid
  grid := CurrentProject.AddGrid(currentsituation.CurrentConnection);
  grid.GridAngle := currentsituation.CurrentConnection.GetAngle(nil);
  inc( Currentsituation.CurrentGridz );
  currentsituation.CurrentGrid := grid;
  Currentsituation.PleaseUpdateView := true;
end;

procedure TFormGridTracks.ToolButton9Click(Sender: TObject);
begin
// Doppelkreuzweiche von links unten nach rechts oben
end;

procedure TFormGridTracks.ToolButton10Click(Sender: TObject);
begin
// Doppelkreuzweiche von rechts unten nach links oben
end;



procedure TFormGridTracks.ToolButton15Click(Sender: TObject);
var point1,point2:array[-1..+1] of TRBPoint;
begin
  // auto
  GetCurrentGrid();

  point1[-1] := CurrentProject.FindPointNearPoint(NewPoint(new_x-0.5,new_z),1.5);
  point1[0]  := CurrentProject.FindPointNearPoint(NewPoint(new_x    ,new_z),1.5);
  point1[+1] := CurrentProject.FindPointNearPoint(NewPoint(new_x+0.5,new_z),1.5);
  point2[-1] := CurrentProject.FindPointNearPoint(NewPoint(new_x-0.5,new_z+1),1.5);
  point2[0]  := CurrentProject.FindPointNearPoint(NewPoint(new_x    ,new_z+1),1.5);
  point2[+1] := CurrentProject.FindPointNearPoint(NewPoint(new_x+0.5,new_z+1),1.5);

  // automatisch Verbindungen herstellen.
  if (point1[0]<>nil) then
  begin
    if (point2[0]<>nil) then
    begin
      // Weichen
      if point2[-1]<>nil then
        AddSwitch(point1[0],point2[0],point2[-1],csSwitchLeftUpStraight,csSwitchLeftUpCurve)
      else
      if point2[1]<>nil then
        AddSwitch(point1[0],point2[0],point2[1],csSwitchRightUpStraight,csSwitchRightUpCurve)
      else
        AddTrack(point1[0],point2[0],csFixed);
      // Rückwärts-Weichen
      if point1[-1]<>nil then
        AddSwitch(point2[0],point1[0],point1[-1],csSwitchRightUpStraight,csSwitchRightUpCurve)
      else
      if point1[1]<>nil then
        AddSwitch(point2[0],point1[0],point1[1],csSwitchLeftUpStraight,csSwitchLeftUpCurve)
    end
    else
    // Kurven
    if (point2[-1]<>nil) then
      AddTrack(point1[0],point2[-1],csFixedCurveLeft)
    else
    if (point2[+1]<>nil) then
      AddTrack(point1[0],point2[+1],csFixedCurveRight);

  end
  else
  if (point1[-1]<>nil) then
  begin
    if(point2[0]<>nil) then
      AddTrack(point1[-1],point2[0],csFixedCurveLeft)
    else
    if(point2[+1]<>nil) then
      AddTrack(point1[-1],point2[1],csFixed)
  end
  else
  if (point1[+1]<>nil) then
  begin
    if(point2[0]<>nil) then
      AddTrack(point1[1],point2[0],csFixedCurveRight)
    else
    if(point2[-1]<>nil) then
      AddTrack(point1[1],point2[1],csFixed)
  end;



end;

procedure TFormGridTracks.ToolButton16Click(Sender: TObject);
var point1,point2:array[-1..+1] of TRBPoint;
    i,j: integer;
    conn: TRBConnection;
begin
  // auto
  GetCurrentGrid();

  point1[-1] := CurrentProject.FindPointNearPoint(NewPoint(new_x-0.5,new_z),1.5);
  point1[0]  := CurrentProject.FindPointNearPoint(NewPoint(new_x    ,new_z),1.5);
  point1[+1] := CurrentProject.FindPointNearPoint(NewPoint(new_x+0.5,new_z),1.5);
  point2[-1] := CurrentProject.FindPointNearPoint(NewPoint(new_x-0.5,new_z+1),1.5);
  point2[0]  := CurrentProject.FindPointNearPoint(NewPoint(new_x    ,new_z+1),1.5);
  point2[+1] := CurrentProject.FindPointNearPoint(NewPoint(new_x+0.5,new_z+1),1.5);

  // Schleife über alle Kombinationen
  for i:=-1 to 1 do
  begin
    for j:=-1 to 1 do
    begin
      if (point1[i]<>nil)and(point2[j]<>nil) then
      begin
        conn := CurrentProject.FindConnectionFromTo(point1[i],point2[j]);
        if conn<>nil then
        begin
          if CurrentSituation.CurrentConnection=conn then CurrentSituation.CurrentConnection := nil;
          CurrentProject.DeleteConnection(conn);
        end;
      end;
    end;
  end;
  CurrentSituation.PleaseUpdateView  := true;

end;

end.
