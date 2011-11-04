unit uRB3DPreviewForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StateD, ComCtrls, StdCtrls, ExtCtrls, uRBB3DObject, uRB3DObject,
  ImgList, Buttons, uGlobalDef, uRBProject, uCurrentSituation, uTools,
  uRBto3DStateWorld;

type
  TForm3DPreview = class(TForm)
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure bSaveClick(Sender: TObject);
  protected
    { Private declarations }
    camera,
    bmp,
    polygon,
    group: DWORD;
    LoadWld,
    xx,yy: integer;
    rotating,moving,incomplete: boolean;
    basepath: string;
    B3DObject: TRBB3DObject;
    CamLoc: array[0..2] of Double;
    to3DState: TRBto3DStateWorld;
    function b3dObjectToState(const b3d: TRB3DObject; const grpname: string='b3d'): dword;
  public
    { Public declarations }
    project: TRBProject;
    function SetObject(const filename: string): dword;
    procedure PreviewWorld(cam: TDoublePoint);
    procedure SetProgress(i: integer);
    function AddMarker(group: cardinal; x,y,z: double; const grpname: string): cardinal;
  end;

var
  Form3DPreview: TForm3DPreview;

implementation

{$R *.dfm}



procedure TForm3DPreview.FormShow(Sender: TObject);
var
  ErrorMsg : string;
  ground: DWORD;
begin
  if LoadWld=Ok then exit;

  LoadWld := STATE_engine_load_world(pChar(extractfilepath(application.exename)+'3d\floor.wld'), '', '3d\Bitmaps', EDITOR_MODE);

  if(LoadWld <> OK) then
  begin
   ErrorMsg := 'The world failed to load. Aborting.';
   MessageBox(Handle,PChar(ErrorMsg),'Error',MB_OK or MB_ICONWARNING);
   Close;
   exit;
 end;
 group := 0;


 camera := STATE_camera_get_default_camera;

 CamLoc[0] := 20; // -z in BVE
 CamLoc[1] := 0; // x
 CamLoc[2] := 6; // y

 STATE_camera_set_location(STATE_camera_get_default_camera(),
  CamLoc[0],
  CamLoc[1],
  CamLoc[2]);

  //STATE_engine_set_picture_quality(1000000);

  FormPaint(Sender);
end;

procedure TForm3DPreview.FormPaint(Sender: TObject);
begin
 if (STATE_engine_is_engine_empty() = YES) then exit;

  STATE_engine_render(Handle,camera);


end;

procedure TForm3DPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
// STATE_engine_close;
//  if b3dobject<>nil then    b3dobject.free;
  LoadWld := -1;
end;

procedure TForm3DPreview.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var rot,forw,vert: integer;
begin
  rot := 0;
  forw := 0;
  vert:=0;
  case key of
    vk_up:    forw := -5;
    vk_down:  forw := +5;
    vk_left:  rot := +10;
    vk_right: rot := -10;
    VK_ADD:   vert := 2;
    VK_SUBTRACT: vert := -2;
  end;
  if rot<>0 then
    STATE_camera_rotate_z(STATE_camera_get_default_camera(),rot,CAMERA_SPACE);
  if forw<>0 then
    STATE_camera_move(STATE_camera_get_default_camera(), CAMERA_SPACE,forw,0,0);
  if vert<>0 then
    STATE_camera_move(STATE_camera_get_default_camera(), CAMERA_SPACE,0,0,vert);
  //STATE_camera_set_location(STATE_camera_get_default_camera(), CamLoc[0], CamLoc[1], CamLoc[2]);

  if group<>0 then
  begin
    case key of
      vk_left: if  ssShift in Shift then STATE_group_rotate(group,5,OBJECT_SPACE,2);
      vk_right: if  ssShift in Shift then STATE_group_rotate(group,-5,OBJECT_SPACE,2);
    end;
  end;
  FormPaint(Sender);
end;






function TForm3DPreview.b3dObjectToState(const b3d: TRB3DObject; const grpname: string): dword;
var pol_point: array[0..5] of double;
    center,loc: array[0..2] of double;
    box: array[0..1,0..2] of double;
    transparent_index,i,j,coord_index: integer;
    poly,bmp: DWORD;
    face: TRB3DFace;
    point: TRB3DMeshPoint;
    filename: string;
begin
  incomplete := false;
  loc[0]:=0; loc[1]:=0; loc[2]:=0;
  pol_point[3] := 0;
  pol_point[4] := 0;
  pol_point[5] := 255;
  group := STATE_group_create(pchar(grpname));
  for i:=0 to b3d.GetFaceCount-1 do
  begin
    poly := STATE_polygon_create();
    face := b3d.GetFace(i);
    for j:=0 to face.GetPointCount-1 do
    begin
      point := face.GetPoint(j);
      point.Get(pol_point[0],pol_point[1],pol_point[2]);
      coord_index := point.GetIndex;
      face.GetBitmapCoord(coord_index,pol_point[3],pol_point[4],pol_point[5]);
      STATE_polygon_add_point(poly, pol_point);
    end;
    if face.Bitmap=nil then
      STATE_polygon_set_color_fill(poly,face.Color.R,face.Color.G,face.Color.B)
    else
    begin
      transparent_index := -1;
      filename:= basepath+'\'+face.bitmap.filename;
      bmp := STATE_bitmap_load(pchar(filename), -1);
      if bmp<>0 then
      begin
       if face.bitmap.TransparentColor.isset then
        transparent_index :=  STATE_bitmap_rgb_color_to_index(bmp, face.bitmap.TransparentColor.R,face.bitmap.TransparentColor.G,face.bitmap.TransparentColor.B);
       bmp := STATE_bitmap_load(pchar(filename), transparent_index);
       STATE_polygon_set_bitmap_fill(poly,bmp);
      end
      else
      begin
        incomplete := true;
      end;
    end;
    face.engine_handle := poly;
    STATE_engine_add_polygon(poly);
    STATE_polygon_set_group(poly,group);

  end;
  STATE_group_set_location(group,loc);
  // get center (group wurde dort positioniert)
//  STATE_group_get_center_of_mass(group,center);
  STATE_group_get_bounding_box(group,box);
  center[0] :=0;//-box[0,0];
  center[1] :=0;//-box[0,1];
  center[2] :=-box[0,2];
  // verschiebe entsprechend
  STATE_group_move(group,center,WORLD_SPACE);
    //  bmp := STATE_bitmap_load('bitmaps\tree1', 174);

//  STATE_polygon_set_bitmap_fill(polygon, bmp);

  if incomplete then
  begin
    MessageDlg('At least one bitmap could not be loaded. Maybe it is '+#13+#10+'compressed.', mtWarning, [mbIgnore], 0);
  end;

  result := group;
end;

function TForm3DPreview.SetObject(const filename: string): dword;
var sl: TStringlist;
begin
    if lowercase(ExtractFileExt(filename))<>'.b3d' then
    begin
      MessageDlg('3D preview only with .b3d files.', mtError, [mbCancel], 0);
      exit;
    end;

    basepath := extractfilepath(filename);

    if not fileexists(filename) then exit;

    b3dObject.LoadFromFileAndParse(FileName);

    if group<>0 then   STATE_group_delete_members(group);

    result := b3dObjectToState(b3dobject,'obj');

    FormPaint(self);
end;

procedure TForm3DPreview.FormCreate(Sender: TObject);
begin
  b3dobject := TRBB3DObject.Create;
  LoadWld := -1;
  to3DState:= TRBto3DStateWorld.create;
end;

procedure TForm3DPreview.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if group=0 then exit;
  xx := x;
  yy := y;
  rotating := (Button = mbLeft);
  moving   := (Button = mbRight);
end;

procedure TForm3DPreview.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var d: array[0..2] of double;
begin
  if group=0 then exit;
  if rotating then
  begin
//    STATE_group_rotate(group,(y-yy),WORLD_SPACE,1);
    CamLoc[2] := CamLoc[2] + (y-yy)/4;
    STATE_group_rotate(group,(x-xx),WORLD_SPACE,2);
    xx := x;
    yy := y;
    STATE_camera_set_location(STATE_camera_get_default_camera(), CamLoc[0], CamLoc[1], CamLoc[2]);
    FormPaint(Sender);
  end;
  if moving then
  begin
    d[0] := 0;
    d[2] := (yy-y)/10;
    d[1] := (x-xx)/10;
    STATE_group_move(group,d,WORLD_SPACE);
    xx := x;
    yy := y;
    FormPaint(Sender);
  end;
end;

procedure TForm3DPreview.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  rotating := false;
  moving := false;
end;

procedure TForm3DPreview.PreviewWorld(cam: TDoublePoint);
var
    filename: string;
    ErrorMsg: string;
    ground: dword;
begin
  if (abs(Currentsituation.SelArea1.x-Currentsituation.SelArea2.x)<1)
  or (abs(Currentsituation.SelArea1.y-Currentsituation.SelArea2.y)<1) then
  begin
    MessageDlg(lngmsg.GetMsg('_3dpreviewform_noarea'),mtError,[mbOk],0);
    exit;
  end;


  to3DState.BasePath := extractfilepath(Application.ExeName);
  to3DState.clear;

  Show;

  ground := STATE_polygon_get_handle_using_name('floor');
  if ground>0 then
    STATE_polygon_delete(ground);

  to3DState.OnProgress := SetProgress;
  to3DState.AddProject(project,Currentsituation.SelArea1,Currentsituation.SelArea2);
  ProgressBar1.Position := ProgressBar1.Max;

  STATE_camera_set_location(STATE_camera_get_default_camera(),-cam.y,cam.x,6);

  //to3DState.SaveToFile(to3DState.BasePath+'3ds\def.wld');

  LoadWld := OK;
  Show; // da LoadWld=ok ist, wird in FormShow keine andere Welt geladen 
  
  FormPaint(Self);
end;

procedure TForm3DPreview.FormDestroy(Sender: TObject);
begin
  to3DState.free;
  STATE_engine_close();
end;

procedure TForm3DPreview.SetProgress(i: integer);
begin
  ProgressBar1.Position := i;
  Application.ProcessMessages;
end;

procedure TForm3DPreview.bSaveClick(Sender: TObject);
begin
  to3DState.SaveToFile(to3DState.BasePath+'3ds\def.wld');
end;

function TForm3DPreview.AddMarker(group: dword; x,y,z: double; const grpname: string): cardinal;
var marker_handle: dword;
    b3dobject: TRBB3DObject;
    center: array[0..2] of double;
    box: array[0..1,0..2] of double;
begin
  b3dobject := TRBB3DObject.Create;
  b3dObject.LoadFromFileAndParse(extractfilepath(application.exename)+'point2.b3d');

  marker_handle := b3dObjectToState(b3dobject,grpname);

//  STATE_group_get_bounding_box(marker_handle,box);
  center[0] :=x;
  center[1] :=y;
  center[2] :=z;
  // verschiebe entsprechend
  STATE_group_set_location(marker_handle,center);
//  STATE_group_move(marker_handle,center,WORLD_SPACE);

  b3dobject.free;

  result := marker_handle;

{    STATE_engine_add_polygon(poly);
    STATE_polygon_set_group(poly,group);

  STATE_polygon_add_patch_easy(polygon,center,0.5,direction,0,rgb);    }
end;

end.
