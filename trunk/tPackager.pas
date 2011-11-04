unit tPackager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ZipForge, IniFiles, trbExport, StdCtrls, uRbProject, ShellApi,
  ComCtrls, ExtCtrls, ZipMstr, AbBase, AbBrowse, AbZBrows, AbZipper;

type
  TFormPackage = class(TForm)
    Label1: TLabel;
    ProgressBar: TProgressBar;
    Image1: TImage;
    AbZipper1: TAbZipper;
    procedure JoinFiles(Main_FileName, Hidden_Filename : string; WriteStr:pchar);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DeleteTempDir(directory: string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    //ExportModule: TRBExport_Mod;
    ObjectFileList: TStringlist;
    RouteFileList: TStringlist;
    ProjectModule: TRBProject;
    Sl: TStringList;
    RouteSubDir: string;
    procedure CreatePackage(RouteName,RouteImage,RouteAuthor,RouteHomepage,RouteDescription,ActDir,RouteThanks: String; Rtmax,Rfmax:Integer);
  end;

var
  FormPackage: TFormPackage;

implementation

uses toptions, tcreatepackage;

{$R *.dfm}

procedure TFormPackage.CreatePackage(RouteName,RouteImage,RouteAuthor,RouteHomepage,RouteDescription,ActDir,RouteThanks: String; Rtmax,Rfmax:Integer);
var RouteIni:TInifile;
    DescrFile,FilesFile,ThanksFile:Textfile;
    i:Integer;
    Inifilename: string;

begin
application.ProcessMessages;

Inifilename := ActDir+'routepackages\temp\route.ini';

//Temporäres Verzeichnis anlegen
ForceDirectories(extractfilepath(inifilename));

//Streckeninformationen in von Route Installer benötigte Ini schreiben
RouteIni:=TInifile.Create(inifilename);
RouteIni.WriteString('Route','Name',RouteName);
RouteIni.WriteString('Route','Image',extractfilename(RouteImage));
RouteIni.WriteString('Route','Author',RouteAuthor);
RouteIni.WriteString('Route','Homepage',RouteHomepage);

  ProgressBar.StepBy(10);
Application.ProcessMessages;

//Beschreibung in Textdatei schreiben
AssignFile(DescrFile,ActDir+'routepackages\temp\description.dat');
Rewrite(DescrFile);
WriteLn(DescrFile,RouteDescription);
CloseFile(DescrFile);

//Credis in credits.dat schreiben
AssignFile(ThanksFile,ActDir+'routepackages\temp\credits.dat');
Rewrite(ThanksFile);
WriteLn(ThanksFile,RouteThanks);
CloseFile(ThanksFile);

//Dateiliste in files.dat schreiben, wird von RouteInstaller benötigt
AssignFile(FilesFile,ActDir+'routepackages\temp\files.dat');
Rewrite(FilesFile);

  ProgressBar.StepBy(10);
Application.ProcessMessages;

//Alle Dateien in den temporären Ordner kopieren
for i:=0 to Objectfilelist.Count-1 do begin
  ForceDirectories(extractfilepath(ActDir+'routepackages\temp\railway\object\'+RouteSubDir +'\'+Objectfilelist[i]));
  CopyFile(Pchar(ActDir+formoptions.objectfolder+'\'+Objectfilelist[i]),PChar(ActDir+'routepackages\temp\railway\object\'+RouteSubDir +'\'+Objectfilelist[i]),true);
  WriteLn(FilesFile,'\railway\object\'+ routesubdir+ '\'+Objectfilelist[i]);
end;
for i:=0 to Routefilelist.Count-1 do begin
  ForceDirectories(extractfilepath(ActDir+'routepackages\temp\railway\route\'+RouteSubDir +'\'+Routefilelist[i]));
  CopyFile(Pchar(FormOptions.BVE_Folder+'\railway\route\'+ RouteSubDir+'\'+Routefilelist[i]),PChar(ActDir+'routepackages\temp\railway\route\'+RouteSubDir +'\'+Routefilelist[i]),true);
  WriteLn(FilesFile,'\railway\route\'+routeSubdir+'\'+Routefilelist[i]);
end;

ProgressBar.StepBy(15);
application.ProcessMessages;

if fileexists(routeimage) then CopyFile(PChar(routeimage),PChar(ActDir+'routepackages\temp\'+ExtractFilename(routeimage)),false)
else CopyFile(PChar(ActDir+'routeinstaller\noscreen.bmp'),PChar(ActDir+'routepackages\temp\noscreen.bmp'),true);

CloseFile(FilesFile);
DeleteFile(ActDir+'routepackages\temp\files.zip');

  ProgressBar.StepBy(10);
application.ProcessMessages;

//Alle Dateien im temporären Verzeichnis in files.zip integrieren
AbZipper1.BaseDirectory:=ActDir+'routepackages\temp\';
AbZipper1.FileName:=ActDir+'routepackages\files.zip';
AbZipper1.AddFiles('*.*',0);
AbZipper1.CloseArchive;
{ZipForge1.Active := false;
ZipForge1.BaseDir:=ActDir+'routepackages\temp\';
ZipForge1.FileName:=ActDir+'routepackages\files.zip';
ZipForge1.OpenArchive(fmCreate);
ZipForge1.AddFiles('*.*');
ZipForge1.CloseArchive;      }
//ZipForge1.Free; // Komponente nicht freigeben, wird eventuell ein weiteres Mal gebraucht!

  ProgressBar.StepBy(15);
application.ProcessMessages;

if FormCreatePackage.outputdir='' then FormCreatePackage.outputdir:='completed_packages';

//routeinstaller-EXE in temporäres Verzeichnis kopieren
CopyFile(Pchar(ActDir+'routeinstaller\routeinstaller.exe'),PChar('routepackages\RBinstaller-'+RouteName+'.exe'),true);

//routeinstaller-EXE und files.zip vereinigen
JoinFiles('routepackages\RBinstaller-'+RouteName+'.exe','routepackages\files.zip','0');

JoinFiles('routepackages\RBinstaller-'+RouteName+'.exe','0','RbIntExt');

ProgressBar.StepBy(15);
application.ProcessMessages;
                                                                               
if not DirectoryExists(ActDir+'completed_packages') then CreateDir(ActDir+'completed_packages');
CopyFile(Pchar('routepackages\RBinstaller-'+RouteName+'.exe'),PChar(FormCreatePackage.outputdir+'\RBinstaller-'+RouteName+'.exe'),false);

ProgressBar.StepBy(15);
application.ProcessMessages;


ProgressBar.position := 0;

Close;

end;

procedure TFormPackage.JoinFiles(Main_FileName, Hidden_Filename : string; WriteStr:pchar);
var
 MainFile    : TFileStream;
 HiddenFile  : TFileStream;
 SizeOfFile  : Cardinal;
 SearchWord  : string;
begin
//Prozedur zur verschmelzung der Dateien
 MainFile       := TFileStream.Create(Main_FileName, fmOpenReadWrite or fmShareDenyWrite);
 try
   SizeOfFile     := MainFile.Size;

   if Hidden_Filename<>'0' then begin
   HiddenFile     := TFileStream.Create(Hidden_Filename, fmOpenRead or fmShareDenyNone);
   try
     MainFile.Seek(0, soFromEnd);
     MainFile.CopyFrom(HiddenFile, 0);
     MainFile.Seek(0, soFromEnd);
   finally
    HiddenFile.Free;
   end;
   end;
   SearchWord := '$RBPKG$'+IntToStr(SizeOfFile) + #0;
   MainFile.Seek(0, soFromEnd);
   if WriteStr<>'0' then
     MainFile.WriteBuffer(WriteStr,strlen(WriteStr))
   else
     MainFile.Write(SearchWord[1], length(SearchWord));

 finally
  MainFile.Free;
 end;
end;

procedure TFormPackage.FormShow(Sender: TObject);
begin
//TODO: Verbessern der Aufrufparameter
//CreatePackage(ProjectModule.Projectname,ProjectModule.LogoPath,ProjectModule.Author,ProjectModule.HomepageURL,ProjectModule.Description,ExtractFilePath(Application.ExeName),ProjectModule.Credits,0,0)
end;

procedure TFormPackage.FormCreate(Sender: TObject);
begin
  ObjectFilelist := TStringlist.create;
  RouteFilelist := TStringlist.create;
end;

procedure TFormPackage.FormDestroy(Sender: TObject);
begin
  ObjectFilelist.free;
  RouteFilelist.free;

end;

procedure TFormPackage.DeleteTempDir(directory: string);
var fos: TSHFileOpStruct;
begin
  //DeleteFile(directory);

  ZeroMemory(@fos, SizeOf(fos));
  with fos do begin
    wFunc := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom := PChar(directory+#0);
  end;
  SHFileOperation(fos);
{  if (SHFileOperation(fos)<>0) then
    MessageBox(0, 'Fehler beim Löschen', nil, MB_ICONERROR);}
end;


procedure TFormPackage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //temporäre Dateien löschen
  DeleteTempDir(ExtractFilePath(Application.ExeName)+'routepackages');
end;

end.
 