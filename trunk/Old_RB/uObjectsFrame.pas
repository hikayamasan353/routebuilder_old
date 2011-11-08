unit uObjectsFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, Menus, ExtCtrls, ComCtrls, StdCtrls, Shellapi, DragDrop,
  DragDropFiles,
  uRBObject, uRBObjCache, Buttons;

resourcestring
  msg_structureviewernotfound = 'Structure Viewer (strview.exe) not found. Please download on BVE homepage.';
  msg_structureviewerstarted = 'Structure Viewer should be running now. Drag and drop an object to its window to preview.';


type
  TFrmObjects = class(TFrame)
    Label1: TLabel;
    lvObjFolders: TListView;
    lvObjects: TListView;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    runstructureviewer1: TMenuItem;
    ImageList1: TImageList;
    refresh1: TMenuItem;
    lAutor: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lBitmaps: TLabel;
    Label4: TLabel;
    lDescription: TLabel;
    Label5: TLabel;
    lCopyright: TLabel;
    b3DPreview: TSpeedButton;
    iNight: TImage;
    procedure refresh1Click(Sender: TObject);
    procedure lvObjFoldersClick(Sender: TObject);
    procedure lvObjFoldersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvObjFoldersKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure runstructureviewer1Click(Sender: TObject);
    procedure lvObjectsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvObjectsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvObjectsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lvObjectsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvObjectsDblClick(Sender: TObject);
    procedure b3DPreviewClick(Sender: TObject);
  private
    { Private declarations }
    fdragging : boolean;
  public
    { Public declarations }
    LastFolder: string;
  end;

implementation

uses toptions, uRB3DPreviewForm;

{$R *.dfm}

procedure TFrmObjects.refresh1Click(Sender: TObject);
var  F: TSearchRec;
begin
  // clear cache
  RBObjCache.Clear;
  // fill listview1
  lvObjFolders.items.clear;
  lvObjFolders.items.BeginUpdate;
  if Findfirst(extractfilepath(application.exename)+FormOptions.GetObjectFolder+'\*.*',faDirectory,F)= 0 then
  begin
    repeat
       if (F.Attr=faDirectory) and (F.Name<>'.') and (F.Name<>'..') then
       with lvObjFolders.Items.Add do
       begin
         imageindex := 0;
         caption := F.name;
       end;
    until FindNext(F)<>0;
    FindClose(F);
  end;
  lvObjFolders.items.EndUpdate;
end;

procedure TFrmObjects.lvObjFoldersClick(Sender: TObject);
var  F: TSearchRec;
     defExt: string;
begin
  if lvObjFolders.Selected=nil then exit;
  if (lvObjFolders.Selected.caption='backgrounds')or(lvObjFolders.Selected.caption='marker') then
    defExt := '.bmp'
  else
    defExt := '.b3d .csv';
  lastfolder := lvObjFolders.Selected.caption;
  // unten eintragen
  lvObjects.items.clear;
  if lvObjFolders.Selected=nil then exit;
  lvObjects.items.BeginUpdate;
  if Findfirst(extractfilepath(application.exename)+FormOptions.GetObjectFolder+'\' + lvObjFolders.Selected.caption + '\*.*',faAnyFile,F)= 0 then
  begin
    repeat
       if (length(F.name)>2)and(pos(lowercase(ExtractFileExt( F.name )),defExt)>0) then
         with lvObjects.Items.Add do
         begin
           imageindex := 1;
           caption := F.name;
         end;
    until FindNext(F)<>0;
    FindClose(F);
  end;
  if lvObjects.items.count>0 then
    lvObjects.Selected := lvObjects.items[0];
  lvObjects.items.EndUpdate;


end;

procedure TFrmObjects.lvObjFoldersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   lvObjFoldersClick(self);
end;

procedure TFrmObjects.lvObjFoldersKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   lvObjFoldersClick(self);
end;

procedure TFrmObjects.runstructureviewer1Click(Sender: TObject);
var p: string;
begin
  p :=  FormOptions.BVE_Folder + '\strview.exe';
  if not fileexists(p) then
    MessageDlg(msg_structureviewernotfound, mtError, [mbCancel], 0)
  else
  begin
    ShellExecute(application.Handle,'open',pchar(p),'','',1);
    MessageDlg(msg_structureviewerstarted, mtInformation, [mbOK], 0);
  end;
end;

procedure TFrmObjects.lvObjectsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  fdragging := true;
end;

procedure TFrmObjects.lvObjectsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  fdragging := false;
end;

procedure TFrmObjects.lvObjectsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var s: string;
begin
  if (lvObjFolders.selected=nil) or (lvObjects.selected=nil) then exit;
  if fdragging then
  begin
{    DragDropFiles1.DragDropControl := lvObjects;
    DragDropFiles1.FileList.clear;
    s := extractfilepath(application.exename)+ FormOptions.ObjectFolder+ '\' + lvObjFolders.selected.caption
       + '\' + lvObjects.selected.caption;
    DragDropFiles1.FileList.add(s);
    DragDropFiles1.Execute;}
    fdragging := false;
  end;
end;

procedure TFrmObjects.lvObjectsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var a: string;
    o: TRBObject;
    bl: TStringlist;
begin
  lAutor.caption := '';
  if (lvObjFolders.selected=nil) or (lvObjects.selected=nil) or(lvObjFolders.selected.caption='backgrounds') then exit;
  o := TRBObject.Create(lvObjFolders.selected.caption,lvObjects.selected.caption);
  a := o.GetAuthorName;
  lAutor.caption := a;
  lAutor.Hint := a;
  a := o.GetDescription;
  lDescription.caption := a;
  lDescription.hint := a;
  a := o.GetCopyright;
  lCopyright.Caption := a;
  lCopyright.Hint := a;
  bl := TStringlist.Create;
  o.GetBitmaplist(bl);
  lBitmaps.caption := bl.commatext;
  iNight.Visible := o.NightVersionAvailable;
  bl.free;
  o.free;
end;

procedure TFrmObjects.lvObjectsDblClick(Sender: TObject);
begin
//
end;

procedure TFrmObjects.b3DPreviewClick(Sender: TObject);
var filename: string;
begin
  if lvObjects.selected=nil then exit;
  filename := extractfilepath(application.exename)+ FormOptions.ObjectFolder+ '\' + lvObjFolders.selected.caption
       + '\' + lvObjects.selected.caption;
  Form3DPreview.Show();
  Form3DPreview.SetObject(filename);
end;

end.
