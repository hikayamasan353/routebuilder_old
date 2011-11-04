unit ri_wait;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ZipForge, ShellApi, ri_main, ExtCtrls, ComCtrls;

type
  TRouteinstaller_Wait = class(TForm)
    Label1: TLabel;
    ZipForge1: TZipForge;
    Timer1: TTimer;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure Split(Main_FileName, NewFromMain_Filename : string);
    function GetTempFolder: String;
    procedure Timer1Timer(Sender: TObject);
    procedure ZipForge1OverallProgress(Sender: TObject; Progress: Double;
      Operation: TZFProcessOperation; ProgressPhase: TZFProgressPhase;
      var Cancel: Boolean);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Routeinstaller_Wait: TRouteinstaller_Wait;

implementation


{$R *.dfm}

procedure TRouteinstaller_Wait.FormCreate(Sender: TObject);
begin
//ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TRouteinstaller_Wait.Split(Main_FileName, NewFromMain_Filename : string);
var
 MainFile  : TFileStream;
 SplitFile : TFileStream;
 HelpStr   : string[10];
 GetSize   : integer;
begin
//Prozedur zum trennen der Dateien
 MainFile    := TFileStream.create(Main_FileName, fmOpenReadWrite or fmShareDenyWrite);
 try
   SplitFile := TFileStream.Create(NewFromMain_Filename, fmCreate or fmShareDenyNone);
   try
     //MainFile.Position   := sizepos-1; //MainFile.Size - 11;
     //MainFile.Read(HelpStr, 10);
     //MessageDlg(HelpStr, mtWarning, [mbOK], 0);
     //GetSize := StrToInt(HelpStr);
     GetSize := splitpos;
     MainFile.Position := GetSize;
     SplitFile.CopyFrom(MainFile, MainFile.Size-GetSize);
     SplitFile.Size := SplitFile.Size - 11;
     MainFile.Size :=  GetSize;
   finally
    SplitFile.Free;
   end;
 finally
  MainFile.Free;
 end;
end;

function TRouteinstaller_Wait.GetTempFolder: String;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
//Funktion zum ermitteln des Tempörären Verzeichnisses
  GetTempPath(MAX_PATH, Buffer);
  Result := Buffer;
end;

procedure TRouteinstaller_Wait.Timer1Timer(Sender: TObject);
begin
  timer1.enabled := false;
    //MessageDlg('is package. splitting', mtWarning, [mbOK], 0);
    application.processmessages();
try
     CopyFile(PChar(Application.ExeName),PChar(GetTempFolder+ExtractFileName(Application.ExeName)),false);

     //Angehängte Datei files.zip trennen
     Split(GetTempFolder+ExtractFileName(Application.ExeName), GetTempFolder+'\files.zip');

     //Alle Dateien aus files.zip extrahieren, Ordner erstellen
     ZipForge1.Active:=false;

     ZipForge1.BaseDir:=GetTempFolder;
     ZipForge1.FileName:=GetTempFolder+'\files.zip';
     ZipForge1.OpenArchive;
     ZipForge1.ExtractFiles('*.*');

     ZipForge1.CloseArchive;

     Application.Terminate;
     ShellExecute(Handle,'open',PChar(GetTempFolder+ExtractFileName(Application.ExeName)),nil,PChar(GetTempFolder),SW_NORMAL);
  except
    on e: exception do
    begin
      MessageDlg('Problems during the extraction of some temporary needed files.'
      +' The program won`t continue. Error message: ' + e.Message,mtError,[mbOk],0);
      Application.Terminate;
    end;
  end;
end;

procedure TRouteinstaller_Wait.ZipForge1OverallProgress(Sender: TObject;
  Progress: Double; Operation: TZFProcessOperation;
  ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
begin
  ProgressBar1.position := round(progress);
end;

end.
