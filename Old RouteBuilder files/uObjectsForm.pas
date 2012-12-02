unit uObjectsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, uObjectsFrame, uGlobalDef,
  uRBObject, uRBProject, Menus,
  toptions,
  uCurrentSituation;

  
type
  TFormObjects = class(TForm)
    FrmObjects1: TFrmObjects;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FrmObjects1lvObjectsDblClick(Sender: TObject);
    procedure FrmObjects1lvObjectsSelectItem(Sender: TObject;
      Item: TListItem; Selected: Boolean);
    procedure FrmObjects1b3DPreviewClick(Sender: TObject);
    procedure FrmObjects1Label4DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CurrentProject: TRBProject;
  end;

var
  FormObjects: TFormObjects;

implementation

uses tmain;

{$R *.dfm}

procedure TFormObjects.FormShow(Sender: TObject);
begin
  FrmObjects1.refresh1Click(self);
end;

procedure TFormObjects.FormCreate(Sender: TObject);
begin
  ObjectBasePath := extractfilepath(application.exename) + formoptions.ObjectFolder+'\';
  Screen.Cursors[crTurnCursor] := LoadCursor(HInstance, 'CUR_TURN');
end;

procedure TFormObjects.FrmObjects1lvObjectsDblClick(Sender: TObject);
var o: TRBObject;
begin
  FrmObjects1.lvObjectsDblClick(Sender);
  // insert
  if (FrmObjects1.lvObjFolders.selected=nil) or (FrmObjects1.lvObjects.selected=nil) then exit;
  o := TRBObject.Create(FrmObjects1.lvObjFolders.selected.caption,FrmObjects1.lvObjects.selected.caption);
  o.point := CurrentSituation.Cursor;
  o.angle := 0;
  CurrentProject.AddObject(o);
  CurrentSituation.PleaseUpdateView := true;
end;

procedure TFormObjects.FrmObjects1lvObjectsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  FrmObjects1.lvObjectsSelectItem(Sender, Item, Selected);

  FormMain.FrmEditor.addselectedobject1.enabled := (FormObjects.FrmObjects1.lvObjFolders.selected<>nil)
                            and (FormObjects.FrmObjects1.lvObjects.selected<>nil);
  FormMain.FrmEditor.tbAddObj.enabled := FormMain.FrmEditor.addselectedobject1.enabled;

end;

procedure TFormObjects.FrmObjects1b3DPreviewClick(Sender: TObject);
begin
  FrmObjects1.b3DPreviewClick(Sender);

end;

procedure TFormObjects.FrmObjects1Label4DblClick(Sender: TObject);
var o: TRBObject;
begin
  if (FrmObjects1.lvObjFolders.selected=nil) or (FrmObjects1.lvObjects.selected=nil) then exit;
  o := TRBObject.Create(FrmObjects1.lvObjFolders.selected.caption,FrmObjects1.lvObjects.selected.caption);
  o.SaveAsCSV;
  o.free;

end;

end.
