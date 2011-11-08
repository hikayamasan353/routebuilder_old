unit uTrackProperties;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls,
  utools,
  uCurrentSituation,
  uFreeObjectPropertiesForm,
  uRBProject,
  uRBConnection,
  uRBTrackTexturelist,
  uRBGroundTexturelist,
  uRBBackgroundTexturelist,
  uRBPlatformlist,
  uRBRooflist,
  uRBCatenaryPoleList,
  uRBWallList,
  uRBObject,
  uRBSignal,
  uRBSignalsForm,
  uStationsForm, UWave,
  toptions, Buttons, ExtDlgs,
  uGlobalDef, Menus,
  uSelectObjectForm;

type
  TFormTrackProperties = class(TForm)
    Panel1: TPanel;
    bOK: TButton;
    PageControl1: TPageControl;
    TabSheet1Track: TTabSheet;
    Image1: TImage;
    Label1: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    imgBackground: TImage;
    LabelID: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditLength: TEdit;
    cbPlatformPos: TComboBox;
    cbPoleSide: TComboBox;
    TabSheet1: TTabSheet;
    Label4: TLabel;
    edSpeedlimit: TEdit;
    Label5: TLabel;
    Label7: TLabel;
    edAdhesion: TEdit;
    cbAccuracy: TComboBox;
    Label12: TLabel;
    Button5: TButton;
    edPlayWave: TEdit;
    Wave1: TWave;
    TabSheet2: TTabSheet;
    lWall: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    EdFog: TEdit;
    Label15: TLabel;
    Label17: TLabel;
    edMarkerFilename: TEdit;
    ImgMarker: TImage;
    Label18: TLabel;
    edMarkerDuration: TEdit;
    Image2: TImage;
    bBrowseMarker: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    Label19: TLabel;
    LLeft: TLabel;
    LRight: TLabel;
    lTSO: TLabel;
    edTSOOffsetLeft: TEdit;
    lvertOffset: TLabel;
    edTSOOffsetRight: TEdit;
    TabSheet3: TTabSheet;
    Image3: TImage;
    ImSignal1: TImage;
    ImSignal1r: TImage;
    ImSignal2: TImage;
    ImSignal2r: TImage;
    lSignal2: TLabel;
    lSignal2v: TLabel;
    lSignal1: TLabel;
    lSignal1v: TLabel;
    PopupSignals: TPopupMenu;
    editsignal1: TMenuItem;
    newsignal1: TMenuItem;
    deletesignal1: TMenuItem;
    edGround: TEdit;
    bSelGroundTexture: TButton;
    bSelPoles: TButton;
    edBackground: TEdit;
    bSelBackground: TButton;
    edRoof: TEdit;
    bSelRoof: TButton;
    edPlatform: TEdit;
    bSelPlatform: TButton;
    cbTrackTextures: TComboBox;
    edPoles: TEdit;
    edTSOLeft: TEdit;
    bSelTSOLeft: TButton;
    edTSORight: TEdit;
    bSelTSORight: TButton;
    edWallLeft: TEdit;
    bSelWallLeft: TButton;
    edWallRight: TEdit;
    bSelWallRight: TButton;
    TabSheet4: TTabSheet;
    lbBoundObjects: TListBox;
    bUnbindObject: TButton;
    bEditBoundObject: TButton;
    bAddObj: TButton;
    bCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button6Click(Sender: TObject);
    procedure bDefineCatenaryPolesClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure cbPlatformPosChange(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure bBrowseMarkerClick(Sender: TObject);
    procedure editsignal1Click(Sender: TObject);
    procedure PopupSignalsPopup(Sender: TObject);
    procedure newsignal1Click(Sender: TObject);
    procedure ImSignal1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure deletesignal1Click(Sender: TObject);
    procedure bSelGroundTextureClick(Sender: TObject);
    procedure bSelBackgroundClick(Sender: TObject);
    procedure bSelPolesClick(Sender: TObject);
    procedure bSelPlatformClick(Sender: TObject);
    procedure bSelRoofClick(Sender: TObject);
    procedure bSelTSOLeftClick(Sender: TObject);
    procedure bSelTSORightClick(Sender: TObject);
    procedure bSelWallLeftClick(Sender: TObject);
    procedure bSelWallRightClick(Sender: TObject);
    procedure cbPoleSideChange(Sender: TObject);
    procedure bUnbindObjectClick(Sender: TObject);
    procedure bEditBoundObjectClick(Sender: TObject);
    procedure bAddObjClick(Sender: TObject);
  private
    { Private declarations }
    FClickedSignalImage: TObject;
    procedure FillBoundObjectsList;
  public
    { Public declarations }
    Track: TRBConnection;
    CurrentProject: TRBProject;
    Updatefunc: TUpdateFuncType;
  end;

var
  FormTrackProperties: TFormTrackProperties;

implementation

uses uPredefinedObjectsForm, uTrackTypes, uRB3DPreviewForm, uEditorFrame;


{$R *.dfm}

procedure TFormTrackProperties.FillBoundObjectsList();
var obj: TRBObject;
    i: integer;
    s: string;
begin
  // objects
  lbBoundObjects.Items.Clear;
  for i:=0 to CurrentProject.Freeobjects.count-1 do
  begin
    obj := CurrentProject.Freeobjects[i] as TRBObject;
    if obj.boundtoConnID=Track.id then
    begin
      s := obj.GetPath + ' (' + floattostrPoint(obj.point.x) + ';' + floattostrPoint(obj.point.y) +')';
      lbBoundObjects.Items.AddObject(s,obj);
    end;
  end;
end;

procedure TFormTrackProperties.FormShow(Sender: TObject);
var
    i: integer;
    p: string;
    sig: TRBSignal;
    obj: TRBObject;
begin
  LabelID.Caption := 'ID=' + inttostr(Track.ID);
  EditLength.text := floattostr(Track.GetLength());
  // Track Textures
  FormTrackTypes.GetTrackDefinitionObjectfilenames(cbTrackTextures.Items);
  cbTrackTextures.itemindex := Track.Texture;

  edGround.Enabled := not FormOptions.GetGroundlessBuilding;
  bSelGroundTexture.enabled := not FormOptions.GetGroundlessBuilding;

  edGround.text := Track.Ground;
  edPoles.text  := Track.PolesType;
  cbPoleSide.ItemIndex := Track.PolesPos+1;
  edBackground.text := Track.Background;
  if fileexists(extractfilepath(application.exename)+ FormOptions.ObjectFolder + '\backgrounds\' + edBackGround.text) then
    imgBackground.Picture.LoadFromFile(extractfilepath(application.exename)+ FormOptions.ObjectFolder
     + '\backgrounds\' + edBackGround.text);
  edPlatform.text := Track.PlatformType;
  edRoof.text := Track.RoofType;
  cbPlatformPos.ItemIndex :=  Track.PlatformPos;
  edRoof.enabled := (edPlatform.text<>'');
  edWallLeft.text := Track.WallLeft;
  edWallRight.text := Track.WallRight;
  edTSOLeft.text := Track.TSOLeft;
  edTSORight.text := Track.TSORight;

  edTSOOffsetLeft.text := inttostr(Track.TSOOffsetLeft);
  edTSOOffsetRight.text := inttostr(Track.TSOOffsetRight);

  edSpeedlimit.text := inttostr(Track.Speedlimit);
  edAdhesion.text   := inttostr(Track.Adhesion);
  cbAccuracy.itemindex := Track.Accuracy-1;
  EdFog.text        := inttostr(Track.Fog);
//  lEHeight.text     := floattostrpoint(Track.YPosition);
  edMarkerFilename.text := Track.Markerfilename;
  edMarkerDuration.text := inttostr(Track.Markerduration);

  edPlayWave.text := Track.Wavefilename;

  if CurrentProject<>nil then
  begin
    // Signale
    p := FormOptions.BVE_Folder+'\';
    ImSignal1.Picture.LoadFromFile(p+getsignalBitmap(false,stHome));
    ImSignal1r.Picture.LoadFromFile(p+getsignalBitmap(true,stHome));
    ImSignal2.Picture.LoadFromFile(p+getsignalBitmap(false,stHome));
    ImSignal2r.Picture.LoadFromFile(p+getsignalBitmap(true,stHome));
    lSignal1.Caption := '';
    lSignal1v.Caption := '';
    lSignal2.Caption := '';
    lSignal2v.Caption := '';

    for i:=0 to CurrentProject.Signals.count-1 do
    begin
      sig := CurrentProject.Signals[i] as TRBSignal;
      if sig.Connection.id = Track.id then
      begin
        if (sig.Direction=1)and (sig.Relay=false) then lSignal1.Caption := sig.Name;
        if (sig.Direction=1)and (sig.Relay=true) then lSignal1v.Caption := sig.Name;
        if (sig.Direction=-1)and (sig.Relay=false) then lSignal2.Caption := sig.Name;
        if (sig.Direction=-1)and (sig.Relay=true) then lSignal2v.Caption := sig.Name;
      end;
    end;
    FillBoundObjectsList();
  end;
end;

procedure TFormTrackProperties.bOKClick(Sender: TObject);
var
    a: double;
begin
//  Track.length := strtointdef(Editlength.text,0);
//  a := Track.AlphaStart;
//  Track.AlphaStart := strtofloatdef( EditStartAlpha.text, 0);
//  Track.AlphaEnd   := Track.AlphaEnd + Track.AlphaStart - a;
//  tl := TRBTrackTexturelist.create;
  Track.Texture := cbTrackTextures.itemindex;
//  tl.free;
  Track.Ground := edGround.text;
  Track.Background := edBackground.text;

  Track.PlatformPos := cbPlatformPos.ItemIndex;
  if Track.PlatformPos>0 then
  begin
    Track.PlatformType := edPlatform.text;
    Track.RoofType := edRoof.text;
  end
  else
  begin
    Track.PlatformType := '';
    Track.RoofType := '';
  end;

  Track.PolesPos := cbPoleside.itemindex-1;
  if Track.PolesPos<>0 then
    Track.PolesType := edPoles.text
  else
    Track.PolesType := '';

  Track.WallLeft := edWallLeft.text;
  Track.WallRight := edWallRight.text;
  Track.TSOLeft := edTSOLeft.text;
  Track.TSORight := edTSORight.text;

  Track.TSOOffsetLeft := strtointdef(edTSOOffsetLeft.text,0);
  Track.TSOOffsetRight := strtointdef(edTSOOffsetRight.text,0);

  Track.Speedlimit := strtointdef(edSpeedlimit.text,Track.Speedlimit);
  Track.Accuracy   := cbAccuracy.ItemIndex+1;
  Track.Adhesion   := strtointdef(edAdhesion.text,Track.Adhesion);
  Track.Wavefilename := edPlayWave.text;
  Track.Fog        := strtointdef(edFog.text,0);
//  Track.Height     := strtofloat1(edHeight.text);
  Track.Markerfilename := edMarkerFilename.text;
  Track.Markerduration := strtointdef(edMarkerDuration.text,0);

  //modalResult:= mrOK;
  if assigned(UpdateFunc) then UpdateFunc(self,true);
end;

procedure TFormTrackProperties.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  // Escape schlieﬂt den Dialog
  if key=#27 then modalResult := mrCancel;
end;

procedure TFormTrackProperties.Button6Click(Sender: TObject);
begin
  //
  close();
  // open stations window
  FormStations.CurrentProject := CurrentProject;
  FormStations.ShowModal();
end;

procedure TFormTrackProperties.bDefineCatenaryPolesClick(Sender: TObject);
begin
    ShowMessage('not yet implemented');
end;

procedure TFormTrackProperties.Button5Click(Sender: TObject);
var f: string;
begin
  f := extractfilepath(Application.ExeName)+'\'+formOptions.ObjectFolder+'\sounds\'+edPlayWave.Text;
  if fileexists(f) then
  begin
    Wave1.WaveData.LoadFromFile(f);
    Wave1.play;
  end;
end;

procedure TFormTrackProperties.cbPlatformPosChange(Sender: TObject);
begin
  edRoof.enabled := (cbPlatformPos.ItemIndex<>0);
end;

procedure TFormTrackProperties.FormShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  if msg.CharCode=27  then modalResult := mrCancel;
end;

procedure TFormTrackProperties.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TFormTrackProperties.bBrowseMarkerClick(Sender: TObject);
begin
  OpenPictureDialog1.InitialDir := extractfilepath(Application.ExeName) + FormOptions.Objectfolder + '\marker\';
  if  OpenPictureDialog1.Execute then
  begin
    edMarkerFilename.text := ExtractFileName( OpenPictureDialog1.FileName );
  end;
end;

procedure TFormTrackProperties.editsignal1Click(Sender: TObject);
var i: integer;
    sig,sigsel: TRBSignal;
begin
  //
  sigsel := nil;
  FormSignals.project := CurrentProject;
  for i:=0 to CurrentProject.Signals.count-1 do
  begin
    sig := CurrentProject.Signals[i] as TRBSignal;
    if sig.Connection.id = Track.id then
    begin
      if (FClickedSignalImage=ImSignal1)and (sig.Direction=1)and (sig.Relay=false) then sigsel := sig;
      if (FClickedSignalImage=ImSignal1r)and (sig.Direction=1)and (sig.Relay=true) then sigsel := sig;
      if (FClickedSignalImage=ImSignal2)and (sig.Direction=-1)and (sig.Relay=false) then sigsel := sig;
      if (FClickedSignalImage=ImSignal2r)and (sig.Direction=-1)and (sig.Relay=true) then sigsel := sig;
    end;
  end;
  if sigsel<>nil then
  begin
    FormSignals.DoIt(sigsel);
  end;
end;

procedure TFormTrackProperties.PopupSignalsPopup(Sender: TObject);
begin
  FClickedSignalImage := Sender;
end;

procedure TFormTrackProperties.newsignal1Click(Sender: TObject);
var sig: TRBSignal;
begin
  sig := TRBSignal.Create;
  if (FClickedSignalImage=ImSignal1) then begin sig.Direction := 1; sig.Relay := false; end;
  if (FClickedSignalImage=ImSignal1r) then begin sig.Direction := 1; sig.Relay := true; end;
  if (FClickedSignalImage=ImSignal2) then begin sig.Direction := -1; sig.Relay := false; end;
  if (FClickedSignalImage=ImSignal2r) then begin sig.Direction := -1; sig.Relay := true; end;
  if sig.relay then
    sig.Name := 'R@'+inttostr(Track.id)
  else
    sig.Name := 'S@'+inttostr(Track.id);
  sig.Connection := Track;
  sig.connectionid := Track.id;
  currentproject.Signals.Add(sig);
  FormSignals.project := CurrentProject;
  FormSignals.DoIt(sig);
end;

procedure TFormTrackProperties.ImSignal1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PopupSignalsPopup(sender);
end;

procedure TFormTrackProperties.deletesignal1Click(Sender: TObject);
var i,j: integer;
    sig,sigsel: TRBSignal;
begin
  //
  j := -1;
  FormSignals.project := CurrentProject;
  for i:=0 to CurrentProject.Signals.count-1 do
  begin
    sig := CurrentProject.Signals[i] as TRBSignal;
    if sig.Connection.id = Track.id then
    begin
      if (FClickedSignalImage=ImSignal1)and (sig.Direction=1)and (sig.Relay=false) then j:=i;
      if (FClickedSignalImage=ImSignal1r)and (sig.Direction=1)and (sig.Relay=true) then j:=i;
      if (FClickedSignalImage=ImSignal2)and (sig.Direction=-1)and (sig.Relay=false) then j:=i;
      if (FClickedSignalImage=ImSignal2r)and (sig.Direction=-1)and (sig.Relay=true) then j:=i;
    end;
  end;
  if j<>-1 then
  begin
    CurrentProject.Signals.Delete(j);
    lSignal1.Caption := '';
    lSignal1v.Caption := '';
    lSignal2.Caption := '';
    lSignal2v.Caption := '';

    for i:=0 to CurrentProject.Signals.count-1 do
    begin
      sig := CurrentProject.Signals[i] as TRBSignal;
      if sig.Connection.id = Track.id then
      begin
        if (sig.Direction=1)and (sig.Relay=false) then lSignal1.Caption := sig.Name;
        if (sig.Direction=1)and (sig.Relay=true) then lSignal1v.Caption := sig.Name;
        if (sig.Direction=-1)and (sig.Relay=false) then lSignal2.Caption := sig.Name;
        if (sig.Direction=-1)and (sig.Relay=true) then lSignal2v.Caption := sig.Name;
      end;
    end;
  end;
end;

procedure TFormTrackProperties.bSelGroundTextureClick(Sender: TObject);
begin
  FormSelectObject.SetFolder('grounds');
  FormSelectObject.FolderChangeable := false;
  if FormSelectObject.ShowModal=mrOK then
    edGround.text := FormSelectObject.objfilename;
end;

procedure TFormTrackProperties.bSelBackgroundClick(Sender: TObject);
begin
  FormSelectObject.SetFolder('backgrounds');
  FormSelectObject.FolderChangeable := false;
  if FormSelectObject.ShowModal=mrOK then
  begin
    edBackGround.text := FormSelectObject.objfilename;
    imgBackground.Picture.LoadFromFile(extractfilepath(application.exename)+ FormOptions.ObjectFolder
     + '\backgrounds\' + edBackGround.text);
  end;
end;

procedure TFormTrackProperties.bSelPolesClick(Sender: TObject);
begin
  FormSelectObject.SetFolder('poles');
  FormSelectObject.FolderChangeable := false;
  if FormSelectObject.ShowModal=mrOK then
    edPoles.text := FormSelectObject.objfilename
end;

procedure TFormTrackProperties.bSelPlatformClick(Sender: TObject);
var s: string;
begin
  FormSelectObject.SetFolder('platforms');
  FormSelectObject.FolderChangeable := false;
  if FormSelectObject.ShowModal=mrOK then
  begin
    s := FormSelectObject.objfilename;
    s:=StringReplace(s,'b3d','',[rfIgnoreCase]);
    s:=StringReplace(s,'csv','',[rfIgnoreCase]);
    s:=StringReplace(s,'CR.','',[rfIgnoreCase]);
    s:=StringReplace(s,'CL.','',[rfIgnoreCase]);
    s:=StringReplace(s,'R.','',[rfIgnoreCase]);
    s:=StringReplace(s,'L.','',[rfIgnoreCase]);
    edPlatform.text := s;
  end;
end;

procedure TFormTrackProperties.bSelRoofClick(Sender: TObject);
var s: string;
begin
  FormSelectObject.SetFolder('platforms');
  FormSelectObject.FolderChangeable := false;
  if FormSelectObject.ShowModal=mrOK then
  begin
    s := FormSelectObject.objfilename;
    s:=StringReplace(s,'b3d','',[rfIgnoreCase]);
    s:=StringReplace(s,'csv','',[rfIgnoreCase]);
    s:=StringReplace(s,'CR.','',[rfIgnoreCase]);
    s:=StringReplace(s,'CL.','',[rfIgnoreCase]);
    s:=StringReplace(s,'R.','',[rfIgnoreCase]);
    s:=StringReplace(s,'L.','',[rfIgnoreCase]);
    edRoof.text := s;
  end;
end;

procedure TFormTrackProperties.bSelTSOLeftClick(Sender: TObject);
var s: string;
begin
  FormSelectObject.SetFolder('walls');
  FormSelectObject.FolderChangeable := false;
  if FormSelectObject.ShowModal=mrOK then
  begin
    s := FormSelectObject.objfilename;
    s:=StringReplace(s,'b3d','',[rfIgnoreCase]);
    s:=StringReplace(s,'csv','',[rfIgnoreCase]);
    s:=StringReplace(s,'_l.','',[rfIgnoreCase]);
    s:=StringReplace(s,'_r.','',[rfIgnoreCase]);
    edTSOLeft.text := s;
  end;
end;

procedure TFormTrackProperties.bSelTSORightClick(Sender: TObject);
var s:string;
begin
  FormSelectObject.SetFolder('walls');
  FormSelectObject.FolderChangeable := false;
  if FormSelectObject.ShowModal=mrOK then
  begin
    s := FormSelectObject.objfilename;
    s:=StringReplace(s,'b3d','',[rfIgnoreCase]);
    s:=StringReplace(s,'csv','',[rfIgnoreCase]);
    s:=StringReplace(s,'_l.','',[rfIgnoreCase]);
    s:=StringReplace(s,'_r.','',[rfIgnoreCase]);
    edTSORight.text := s;
  end;
end;

procedure TFormTrackProperties.bSelWallLeftClick(Sender: TObject);
var s:string;
begin
  FormSelectObject.SetFolder('walls');
  FormSelectObject.FolderChangeable := false;
  if FormSelectObject.ShowModal=mrOK then
  begin
    s := FormSelectObject.objfilename;
    s:=StringReplace(s,'b3d','',[rfIgnoreCase]);
    s:=StringReplace(s,'csv','',[rfIgnoreCase]);
    s:=StringReplace(s,'_l.','',[rfIgnoreCase]);
    s:=StringReplace(s,'_r.','',[rfIgnoreCase]);
    edWallLeft.text := s;
  end;
end;

procedure TFormTrackProperties.bSelWallRightClick(Sender: TObject);
var s:string;
begin
  FormSelectObject.SetFolder('walls');
  FormSelectObject.FolderChangeable := false;
  if FormSelectObject.ShowModal=mrOK then
  begin
    s := FormSelectObject.objfilename;
    s:=StringReplace(s,'b3d','',[rfIgnoreCase]);
    s:=StringReplace(s,'csv','',[rfIgnoreCase]);
    s:=StringReplace(s,'_l.','',[rfIgnoreCase]);
    s:=StringReplace(s,'_r.','',[rfIgnoreCase]);
    edWallRight.text := s;
  end;
end;

procedure TFormTrackProperties.cbPoleSideChange(Sender: TObject);
begin
  edPoles.Enabled := (cbPoleSide.ItemIndex<>1);
end;

procedure TFormTrackProperties.bUnbindObjectClick(Sender: TObject);
var obj: TRBObject;
begin
  if lbBoundObjects.ItemIndex<0 then exit;
  obj := lbBoundObjects.items.objects[lbBoundObjects.ItemIndex] as TRBObject;
  obj.point.x := Currentsituation.Cursor.x;
  obj.point.y := Currentsituation.Cursor.y;
  obj.boundtoConnID := 0;
  lbBoundObjects.DeleteSelected;
end;

procedure TFormTrackProperties.bEditBoundObjectClick(Sender: TObject);
var obj: TRBObject;
begin
  if lbBoundObjects.ItemIndex<0 then exit;
  obj := lbBoundObjects.items.objects[lbBoundObjects.ItemIndex] as TRBObject;
  formfreeObjProperties.freeobj := obj;
  FormFreeObjProperties.ShowModal();
  FillBoundObjectsList();
end;

procedure TFormTrackProperties.bAddObjClick(Sender: TObject);
var o: TRBObject;
begin
  //
  if FormSelectObject.ShowModal=mrOK then
  begin
    o := TRBObject.Create(FormSelectObject.selected);
    o.point.x:=0;
    o.point.y:=0;
    o.yoffset:=0;
    o.angle := 0;
    o.boundtoConnID:= Track.ID;
   // EditorFrame.AddUndoAction(rbaAddObject,o,nil,o.point);
    CurrentProject.AddObject(o);
    FillBoundObjectsList();
    if assigned(UpdateFunc) then UpdateFunc(self,true);
  end;
end;

end.
