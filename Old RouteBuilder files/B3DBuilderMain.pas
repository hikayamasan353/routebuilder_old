unit B3DBuilderMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uRB3DPreviewForm, Menus, StateD, ExtCtrls, uRB3DObject;

type
  TForm1 = class(TForm3DPreview)
    PanelNavigator: TPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Quit1: TMenuItem;
    Edit1: TMenuItem;
    AddMesh1: TMenuItem;
    DeleteMesh1: TMenuItem;
    CopyMesh1: TMenuItem;
    SetColor1: TMenuItem;
    SetTexture1: TMenuItem;
    N2: TMenuItem;
    Options1: TMenuItem;
    LabelNavigator: TLabel;
    Help1: TMenuItem;
    Contents1: TMenuItem;
    About1: TMenuItem;
    OpenDialogB3D: TOpenDialog;
    PanelMeshes: TPanel;
    LabelMeshes: TLabel;
    ListBoxFaces: TListBox;
    PanelLeft: TPanel;
    PanelPoints: TPanel;
    LabelPoints: TLabel;
    ListBoxPoints: TListBox;
    Image1: TImage;
    SaveDialogB3d: TSaveDialog;
    procedure Open1Click(Sender: TObject);
    procedure PanelMeshesClick(Sender: TObject);
    procedure ListBoxFacesClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure ListBoxPointsClick(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
  private
    procedure ActivateFace(face_handle: Cardinal);
  public
    { Public declarations }
    group_handle,marker_handle: dword;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Open1Click(Sender: TObject);
begin
  //
  if OpenDialogB3D.Execute then
  begin
    group_handle := SetObject(OpenDialogB3D.FileName);
    PanelMeshesClick(sender);
  end;
end;

procedure TForm1.PanelMeshesClick(Sender: TObject);
var i: integer;
begin
  //
  ListBoxFaces.Clear;
  for i:=0 to B3DObject.GetFaceCount-1 do
  begin
    ListBoxFaces.AddItem('Face'+inttostr(i),B3DObject.GetFace(i));
  end;
end;

procedure TForm1.ListBoxFacesClick(Sender: TObject);
var h,i: Cardinal;
begin
  i:=  ListBoxFaces.ItemIndex;

  h := (ListBoxFaces.Items.Objects[i] as TRB3DFace).engine_handle;

  ActivateFace(h);
end;



procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var found_obj,i,h: Cardinal;
begin
  inherited;
  //
  found_obj := STATE_engine_get_polygon_at_point_2D(x,y);
  ActivateFace(found_obj);

  for i:=0 to ListBoxFaces.Items.Count-1 do
  begin
    h := (ListBoxFaces.Items.Objects[i] as TRB3DFace).engine_handle;
    if h = found_obj then
    begin
      ListBoxFaces.ItemIndex := i;
      break;
    end;
  end;
  FormPaint(self);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  inherited;
  // Änderungen gegenüber Basisklasse
  BorderStyle := bsSizeable;
  FormStyle := fsNormal;
  BorderIcons := [biSystemMenu,biMinimize,biMaximize];

end;

procedure TForm1.FormShow(Sender: TObject);
begin
  inherited;
  BringToFront;
end;


//--------------------------------------------------------------


procedure TForm1.ActivateFace(face_handle: Cardinal);
var i,h: cardinal;
    face: TRB3DFace;
begin
  face:=nil;
  for i:=0 to ListBoxFaces.Items.Count-1 do
  begin
    h := (ListBoxFaces.Items.Objects[i] as TRB3DFace).engine_handle;
    if h=face_handle then
    begin
      STATE_polygon_set_brightness(h,200);
      face := ListBoxFaces.Items.Objects[i] as TRB3DFace;
    end
    else
    begin
      STATE_polygon_set_brightness(h,100); // default ist 86
    end;
  end;

  if(face<>nil)and(face.mesh<>nil) then
  begin
    // fill points listbox
    ListBoxPoints.Clear;
    for i:=0 to face.Mesh.GetPointCount-1 do
    begin
      ListBoxPoints.AddItem('point'+inttostr(i),face.Mesh.GetPoint(i));
    end;

  end;

  FormPaint(self);
end;




procedure TForm1.SaveAs1Click(Sender: TObject);
begin
  inherited;
  if SaveDialogB3D.Execute then
  begin
    B3DObject.SaveToFile(SaveDialogB3d.FileName);
  end;
end;

procedure TForm1.ListBoxPointsClick(Sender: TObject);
var h: Cardinal;
    i,j: integer;
    p : TRB3DMeshPoint;
    x,y,z: double;
begin
  j :=  ListBoxPoints.ItemIndex;
  i :=  ListBoxFaces.ItemIndex;
  if i<0 then exit;
  h := (ListBoxFaces.Items.Objects[i] as TRB3DFace).engine_handle;
  ActivateFace(h);

  if j>=0 then
  begin
    if marker_handle>0 then
    begin
      if STATE_group_is_group(marker_handle,0)>0 then
      begin
        STATE_group_delete_members(marker_handle);
        marker_handle := 0;
      end;
    end;
    p:= (ListboxPoints.Items.Objects[j] as TRB3DMeshPoint);
    state_group_get_location(group_handle,x,y,z);
    marker_handle := AddMarker(group_handle,p.x+x,p.y+y,p.z+z,'marker');
  end;


end;

procedure TForm1.Quit1Click(Sender: TObject);
begin
  inherited;
  Application.Terminate;
end;

end.
