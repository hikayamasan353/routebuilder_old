unit uSelectObjectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uCurrentSituation,
  uObjectsFrame;

type
  TFormSelectObject = class(TForm)
    FrmObjects1: TFrmObjects;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure FrmObjects1lvObjectsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    selected: string;
    objfilename: string;
    DefFolder: string;
    FolderChangeable: boolean;
    procedure SetFolder(const folder: string);
  end;

var
  FormSelectObject: TFormSelectObject;

implementation

uses ComCtrls;

{$R *.dfm}

procedure TFormSelectObject.Button1Click(Sender: TObject);
begin
  if (FrmObjects1.LastFolder<>'')
  and(FrmObjects1.lvObjects.selected<>nil) then
  begin
    selected := FrmObjects1.LastFolder+'\'+FrmObjects1.lvObjects.selected.caption;
    objfilename := FrmObjects1.lvObjects.selected.caption;
    modalresult := mrOK;
    FolderChangeable := true;
  end;
end;

procedure TFormSelectObject.Button2Click(Sender: TObject);
begin
  FolderChangeable := true;
  modalresult := mrCancel;
end;

procedure TFormSelectObject.FormShow(Sender: TObject);
begin
  selected := '';
  FrmObjects1.refresh1Click(self);
  FrmObjects1.lvObjFolders.visible := FolderChangeable;
  if DefFolder<>'' then SetFolder(DefFolder);
end;

procedure TFormSelectObject.SetFolder(const folder: string);
var i: integer;
begin
  DefFolder := folder;
  for i:=0 to  FrmObjects1.lvObjFolders.items.count-1 do
  begin
    if lowercase(FrmObjects1.lvObjFolders.items[i].caption)=lowercase(folder) then
    begin
      FrmObjects1.lvObjFolders.Selected := FrmObjects1.lvObjFolders.items[i];
      FrmObjects1.lvObjFoldersClick(self);
//      FrmObjects1.lvObjFolders.items[i].Selected := true;
      break;
    end;
  end;
  FolderChangeable := true;
end;

procedure TFormSelectObject.FormCreate(Sender: TObject);
begin
  FolderChangeable := true;
  DefFolder := '';
end;

procedure TFormSelectObject.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then
  begin
      modalResult := mrCancel;
  end;

end;

procedure TFormSelectObject.FormShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  if Msg.CharCode=27 then modalResult := mrCancel;
end;

procedure TFormSelectObject.FrmObjects1lvObjectsDblClick(Sender: TObject);
begin
  currentSituation.ignoreClick := true;
  Button1Click(self);
end;

end.
