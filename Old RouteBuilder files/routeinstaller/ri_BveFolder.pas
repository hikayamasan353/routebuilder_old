unit ri_BveFolder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids,Inifiles, ComCtrls, ShellCtrls, Registry,
  FileCtrl;

type
  TRouteInstaller_BveFolder = class(TForm)
    LabelSelectDir: TLabel;
    LabelSelectedDir: TLabel;
    OKButton: TButton;
    GroupBox1: TGroupBox;
    DirectoryBox1: TDirectoryListBox;
    DriveBox1: TDriveComboBox;
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public

  end;

var
  RouteInstaller_BveFolder: TRouteInstaller_BveFolder;
  inifile: TIniFile;
  regist: TRegistry;

implementation

uses ri_main;


{$R *.dfm}

procedure TRouteInstaller_BveFolder.OKButtonClick(Sender: TObject);
begin
 try
   regist:=TRegistry.Create;
   regist.RootKey:=HKEY_LOCAL_MACHINE;
   regist.OpenKey('Software\Routebuilder',true);
   regist.WriteString('BVE Folder',DirectoryBox1.Directory);
   regist.Free;
   LabelSelectedDir.caption := DirectoryBox1.Directory;
   //RouteInstaller_Main.BvePath_Edit.Text:=DirectoryBox1.Directory;

   modalResult := mrOK;
   except
   raise;
end;
end;

procedure TRouteInstaller_BveFolder.FormCreate(Sender: TObject);
begin
if DirectoryExists('C:\program files\bve') then begin
DriveBox1.Drive:='C';
DirectoryBox1.Directory:='C:\program files\bve';
end
else begin
DriveBox1.Drive:='C';
DirectoryBox1.Directory:='C:\';
end;
end;

end.
