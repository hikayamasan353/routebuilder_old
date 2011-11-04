unit tBveFolder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids,Inifiles, ComCtrls, ShellCtrls, Registry,
  tOptions;

type
  TFormSetBveFolder = class(TForm)
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
  FormSetBveFolder: TFormSetBveFolder;
  inifile: TIniFile;
  regist: TRegistry;

implementation


{$R *.dfm}

procedure TFormSetBveFolder.ShellTreeView1Change(Sender: TObject;
  Node: TTreeNode);
begin
LabelSelectedDir.Caption:=ShellTreeView1.Path;
end;

procedure TFormSetBveFolder.OKButtonClick(Sender: TObject);
begin
 try
  inifile.WriteString('Settings','ShowConfigBveFolder','False'); //Schreibt in Ini wenn BVE Verzeichnis das erste mal gesetzt wurde
  inifile.WriteString('Settings','BVE_Folder',ShellTreeView1.Path);  //Schreibt BVE Verzeichnis in Ini

  finally
   FormOptions.BVE_Folder:=ShellTreeView1.Path;
   //schreibt BVE Verzeichnis in Registry
   regist:=TRegistry.Create;
   regist.RootKey:=HKEY_CURRENT_USER;
   regist.OpenKey('Software\Routebuilder',true);
   regist.WriteString('BVE Folder',ShellTreeView1.Path);
   regist.WriteString('RouteBuilder Folder',FormOptions.AktVZ);
   FormOptions.BVE_Folder_Set.text := FormOptions.BVE_Folder;
  regist.Free;
 Close;
 //TODO: "Except"
end;
end;

procedure TFormSetBveFolder.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action := caFree;
end;

end.
