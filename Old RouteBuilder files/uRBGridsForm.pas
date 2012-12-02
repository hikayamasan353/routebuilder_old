unit uRBGridsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  uCurrentsituation,
  uRBProject,
  uRBConnection,
  uRBPoint,
  uRBGrid,
  utools,
  uGlobalDef, ExtCtrls;

type
  TFormGrids = class(TForm)
    lbGrids: TListBox;
    bNewGrid: TButton;
    Label2: TLabel;
    edDegrees: TEdit;
    Label1: TLabel;
    edGridname: TEdit;
    bApply: TButton;
    bDeleteGrid: TButton;
    lGridInfo: TLabel;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure lbGridsClick(Sender: TObject);
    procedure edGridnameChange(Sender: TObject);
    procedure edDegreesChange(Sender: TObject);
    procedure bNewGridClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure bDeleteGridClick(Sender: TObject);
    procedure bApplyClick(Sender: TObject);
  private
    { Private declarations }
    gridindex: integer;
  public
    { Public declarations }
    project: TRBProject;
    procedure FillList;
  end;

var
  FormGrids: TFormGrids;

implementation

uses tmain;

{$R *.dfm}

procedure TFormGrids.FormShow(Sender: TObject);
begin
  FillList();
end;

procedure TFormGrids.lbGridsClick(Sender: TObject);
var grid: TRBGrid;
begin
  if lbGrids.ItemIndex<0 then exit;
  Timer1.Enabled:=false;
  GridIndex := lbGrids.ItemIndex;
  grid := lbGrids.Items.Objects[lbGrids.ItemIndex] as TRBGrid;
  edGridname.text := grid.GridName;
  edDegrees.text  := floattostrpoint(grid.GridAngle);
  Currentsituation.CurrentGrid := grid;
  bApply.Enabled := false;
  bDeleteGrid.Enabled := true;
  lGridInfo.Caption := inttostr(grid.Count) + ' connections';
  // show
  Currentsituation.Currentconnection := project.FindConnectionByID(grid.RootConnection);
  Currentsituation.PleaseUpdateView := true;
  Timer1.Enabled:=true;
end;

procedure TFormGrids.edGridnameChange(Sender: TObject);
begin
  if lbGrids.ItemIndex>=0 then bApply.Enabled := true;
end;

procedure TFormGrids.edDegreesChange(Sender: TObject);
begin
  if lbGrids.ItemIndex>=0 then bApply.Enabled := true;
end;

procedure TFormGrids.bNewGridClick(Sender: TObject);
var grid: TRBGrid;
begin
  if currentsituation.currentconnection=nil then exit;
  grid := project.AddGrid(Currentsituation.CurrentConnection);
  if edGridname.text<>'' then
    grid.gridname := edGridname.text;
  FillList;
  FormMain.FrmEditor.UpdateView();
  lbGridsClick(self);
end;

procedure TFormGrids.FillList;
var i: integer;
begin
  lbGrids.Items.Clear;
  if not Visible then exit;
  for i:=0 to project.Grids.count-1 do
  begin
    with  project.Grids[i] as TRBGrid do
    begin
      lbGrids.items.AddObject(GridName,project.Grids[i] as TRBGrid)
    end;
  end;
end;

procedure TFormGrids.Timer1Timer(Sender: TObject);
var old,i: integer;
begin
  old := -1;
  if not Visible then exit;
  if Currentsituation.PleaseUpdateView then
  begin
    FillList;
  end;
  if(Currentsituation.CurrentGrid<>nil) then
  begin
    i := lbGrids.Items.IndexOf(Currentsituation.CurrentGrid.GridName);
    if (i<>lbGrids.ItemIndex)and(i<>old) then
    begin
      lbGrids.ItemIndex := i;
      lbGridsClick(self);
    end;
  end;
  bNewGrid.Enabled := (Currentsituation.CurrentConnection <> nil)and(edGridname.text<>'');
  //old := lbGrids.Items.IndexOf(Currentsituation.CurrentGrid.GridName);
end;

procedure TFormGrids.bDeleteGridClick(Sender: TObject);
begin
  project.deleteGridByName(edGridName.text);
  FillList;
  lbGridsClick(self);
end;

procedure TFormGrids.bApplyClick(Sender: TObject);
var grid: TRBGrid;
    old_angle: double;
    P: TDoublePoint;
    conn: TRBConnection;
    i: integer;
    griditem: TRBGridItem;
    TurnP,P1,P2: TRBPoint;
begin
  lbGrids.ItemIndex := gridindex;
  if lbGrids.ItemIndex<0 then exit;
  grid := lbGrids.Items.Objects[lbGrids.ItemIndex] as TRBGrid;
  grid.GridName := edGridName.Text;
  FillList();
  old_angle := grid.GridAngle;
  grid.GridAngle := strtofloat1(edDegrees.text);
  if old_angle<>grid.GridAngle then
  begin
    // drehen um P1 der RootConn
    conn := project.FindConnectionByID(grid.RootConnection);
    TurnP := conn.P1;
    project.SetPointsNotTurned();
    for i:=0 to grid.count-1 do
    begin
      griditem := grid.items[i] as TRBGridItem;
      conn := project.FindConnectionByID(griditem.id);
      if conn<>nil then
      begin
        if (conn.P1<>TurnP) and (not conn.P1.turned) then
          conn.P1.turn(TurnP.point,old_angle-grid.GridAngle);
        if (conn.P2<>TurnP) and (not conn.P2.turned) then
          conn.P2.turn(TurnP.point,old_angle-grid.GridAngle);
      end;
    end;
  end;
  Currentsituation.PleaseUpdateView := true;
end;

end.
