unit tPackageFolders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids,Inifiles, ComCtrls, ShellCtrls, Registry,
  tOptions;

type
  TFormSetPackageFolders = class(TForm)
    LabelSelectDir: TLabel;
    ShellTreeView1: TShellTreeView;
    LabelSelectedDir: TLabel;
    OKButton: TButton;
    procedure ShellTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure OKButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public

  end;

var
  FormSetPackageFolders: TFormSetPackageFolders;
  inifile: TIniFile;
  regist: TRegistry;

implementation

uses tcreatepackage;


{$R *.dfm}

procedure TFormSetPackageFolders.ShellTreeView1Change(Sender: TObject;
  Node: TTreeNode);
begin
LabelSelectedDir.Caption:=ShellTreeView1.Path;
end;

procedure TFormSetPackageFolders.OKButtonClick(Sender: TObject);
begin
//if FormCreatePackage.id=1 then begin
//FormSetPackageFolders.ObjectsDir:=ShellTreeView1.Path;
//FormSetPackageFolders.La
end;

procedure TFormSetPackageFolders.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action := caFree;
end;

end.
