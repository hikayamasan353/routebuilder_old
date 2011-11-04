unit ri_progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, shellapi;

type
  TRouteInstaller_Install = class(TForm)
    ShowInstallRouteLabel: TLabel;
    ShowProgress: TProgressBar;
    ShowInstallRoute: TPanel;
    lStatus: TLabel;
    Timer1: TTimer;
    procedure CloseProgram;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private

  public
    BVEFolder: string;
  end;

var
  RouteInstaller_Install: TRouteInstaller_Install;
  FileList: TStringList;

implementation

uses ri_main;

{$R *.dfm}


procedure DeleteRecurse( src : String ) ;
var 
  sts : Integer ;
  SR: TSearchRec;
begin
  sts := FindFirst( src + '*.*' , faDirectory , SR ) ;
  if sts = 0 then
  begin
    if ( SR.Name <> '.' ) and ( SR.Name <> '..' ) then
    begin
      if SR.Attr = faDirectory then
      begin
        DeleteRecurse( src + SR.Name + '\' ) ;
        {$I-}RmDir( src + SR.Name ) ;{$I+}
      end
      else
        DeleteFile( src + SR.Name ) ;
      end ;
    while FindNext( SR ) = 0 do
    if ( SR.Name <> '.' ) and ( SR.Name <> '..' ) then
    begin
    if SR.Attr = faDirectory then
    begin
        DeleteRecurse( src + SR.Name + '\' ) ;
        {$I-}RmDir( src + SR.Name ) ;{$I+}
    end
    else
        DeleteFile( src + SR.Name ) ;
    end ;
    FindClose( SR ) ;
  end ;
end ;



procedure TRouteInstaller_Install.CloseProgram;
var f: Textfile;
begin
try
DeleteFile(Routeinstaller_Main.GetTempFolder+'\credits.dat');
DeleteFile(Routeinstaller_Main.GetTempFolder+'\description.dat');
DeleteFile(Routeinstaller_Main.GetTempFolder+'\files.dat');
DeleteFile(Routeinstaller_Main.GetTempFolder+'\files.zip');
DeleteFile(Routeinstaller_Main.GetTempFolder+'\route.ini');
DeleteRecurse(Routeinstaller_Main.GetTempFolder+'\railway\');
if FileExists(Routeinstaller_Main.GetTempFolder+'\noscreen.bmp') then
  DeleteFile(Routeinstaller_Main.GetTempFolder+'\noscreen.bmp')
else
  DeleteFile(Routeinstaller_Main.GetTempFolder+String(Routeinstaller_Main.Route_Image.Picture.Bitmap));

  AssignFile(f, ChangeFileExt(application.exename, '.bat'));
  ReWrite(f);
  WriteLn(f, ':1');
  WriteLn(f, Format('Erase "%s"', [application.exename]));
  WriteLn(f, Format('If exist "%s" Goto 1', [application.exename]));
  //%0 enthält den Namen der Batch-Datei (wie ParamStr(0))
  WriteLn(f, 'Erase "%0"');
  CloseFile(f);

  Application.Terminate;
  //ShellExecute(handle,'open', PChar(ExtractFileName(ChangeFileExt(ParamStr(0), '.bat'))),nil, PChar(ExtractFileDir(ChangeFileExt(ParamStr(0), '.bat'))), SW_HIDE);
  //halt;
  except
  MessageDlg('Problems during the deletion of some temporary files. The program won`t continue.',mtError,[mbOk],0);
  Application.Terminate;
  end;
end;

procedure TRouteInstaller_Install.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  CloseProgram;
  Action := cafree;
end;

procedure TRouteInstaller_Install.Timer1Timer(Sender: TObject);
var i: integer;
begin
//MessageDlg('installing', mtWarning, [mbOK], 0);
  Timer1.Enabled := false;
try
Filelist:=TStringlist.Create;

Filelist.LoadFromFile(Routeinstaller_Main.GetTempFolder+'\files.dat');

Showprogress.Max:=Filelist.Count-1;

for i:=0 to Filelist.Count-1 do
begin
  Showprogress.Position:=i;
  //MessageDlg(BVEFolder, mtWarning, [mbOK], 0);
  ForceDirectories(ExtractFilePath(BVEFolder+'\'+Filelist.Strings[i]));
  CopyFile(PChar(Routeinstaller_Main.GetTempFolder+Filelist.Strings[i]),PChar(BVEFolder+'\'+Filelist.Strings[i]),False);
  lStatus.Caption := Filelist.Strings[i];
  DeleteFile(Routeinstaller_Main.GetTempFolder+Filelist.Strings[i]);
  Application.ProcessMessages;
end;

MessageDlg('Route installed sucessfully',mtInformation,[mbOk],0);
CloseProgram;
except
  MessageDlg('Problems during the installation of the route. The program won`t continue.',mtError,[mbOk],0);
  Application.Terminate;
end;
end;

end.
