unit update_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, IdAntiFreeze, Shellapi,Inifiles, WinINet,IdIPWatch, IdComponent, IdBaseComponent, IdAntiFreezeBase,IdTCPConnection, IdTCPClient, IdHTTP;

type
  TUpdateWizard = class(TForm)
    Image1: TImage;
    StatusLabel: TLabel;
    DlProgressBar: TProgressBar;
    IdAntiFreeze1: TIdAntiFreeze;
    OkButton: TButton;
    IdIPWatch1: TIdIPWatch;
    IdHTTP1: TIdHTTP;
    procedure FormCreate(Sender: TObject);
    procedure UpdateSoftware;
    procedure CleanUpdate;
    procedure IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure OkButtonClick(Sender: TObject);
    procedure InstallPatch(FileName: string; Params: string);
    procedure IdHTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure delay(msec: LongInt);
    procedure CheckForUpdate;
    
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  UpdateWizard: TUpdateWizard;
  CfgIni: TIniFile;
  ActDir:String;
  UpdateDbStorage:TStringlist;
  i:Integer;

implementation

{$R *.dfm}

procedure TUpdateWizard.FormCreate(Sender: TObject);
begin
 try
 i:=0;
ActDir:=ExtractFilePath(Application.ExeName);
if fileexists(ActDir+'inet_update.cfg') then CfgIni:=TInifile.Create(ActDir+'inet_update.cfg');
UpdateWizard.Caption:=CfgIni.ReadString('Configuration','ProgramName','Unknown')+' update-wizard';
OkButton.Caption:='Check for update...';
 except
 if MessageDlg('An error has occured while trying to initialize the application. The program won`t continue.',mtError,[mbOk],0)=mrOk then Application.Terminate;
 end;
end;

procedure TUpdateWizard.UpdateSoftware;
var responseStream: TFileStream;
begin
 try
 //0000
 //http://patch.exe
 //patch.exe
 //http://versiondb.tmp
 //localversiondb.tmp
DlProgressBar.Visible:=True;

IdHttp1.OnWorkBegin:=IdHttp1WorkBegin;
IdHttp1.OnWork:=IdHttp1Work;
IdHttp1.OnWorkEnd:=IdHttp1WorkEnd;

StatusLabel.Caption:='Downloading update...';
  responseStream := TFileStream.Create(UpdateDbStorage.Strings[2], fmCreate);
  IdHTTP1.Get(UpdateDbStorage.Strings[1], responseStream);
  responseStream.free;
DlProgressBar.Visible:=False;

StatusLabel.Caption:='Installing update...';
InstallPatch(ActDir+UpdateDbStorage.Strings[2],'0');
delay(1000);
CleanUpdate;
  except
   if MessageDlg('An error has occured while downloading the updated program files. This can cause abnormal program termination. The application won`t continue.',mtError,[mbOk],0)=mrOk then CleanUpdate; Application.Terminate;
   end;
end;

procedure TUpdateWizard.CleanUpdate;
begin
try
//delay(500);
if i=0 then begin
i:=1;
StatusLabel.Caption:='Deleting temporary files...';
if fileexists(ActDir+'versiondb.tmp') then begin
Cfgini.WriteString('Configuration','LocalVersionNumber',UpdateDbStorage.Strings[0]);
Cfgini.WriteString('Configuration','VersionDbFile',UpdateDbStorage.Strings[3]);
Cfgini.WriteString('Configuration','LocalVersionDbFile',UpdateDbStorage.Strings[4]);
DeleteFile(ActDir+CfgIni.ReadString('Configuration','LocalVersionDbFile','versiondb.tmp'));
DeleteFile(ActDir+UpdateDbStorage.Strings[2]);
end;
StatusLabel.Caption:='Update installed sucessfully';
OkButton.Caption:='Ok';
UpdateDbStorage.Free;
CfgIni.Free;
end;
except
 if MessageDlg('An error has occured while removing temorary files. The program has been updated. The application won`t continue.',mtError,[mbOk],0)=mrOk then Application.Terminate;
   //CleanUpdate;
   //Application.Terminate;
end;
end;

procedure TUpdateWizard.IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
DlProgressBar.Position:=AWorkCount;
end;

procedure TUpdateWizard.IdHTTP1WorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
DlProgressBar.Max:=AWorkCountMax;
end;

procedure TUpdateWizard.OkButtonClick(Sender: TObject);
begin
if OkButton.Caption='Check for update...' then CheckforUpdate
else if OkButton.Caption='Ok' then Application.Terminate;
end;

procedure TUpdateWizard.CheckForUpdate;
var responseStream: TFileStream;
begin
try
StatusLabel.Caption:='Initializing process...';
OkButton.Caption:='Cancel';
delay(500);

if IdIpWatch1.IsOnline=False then begin
if MessageDlg('Your Computer is not connected to the internet at the moment. To update Route Builder this program needs an active internet-connection. Do you like to connect to the internet now?',mtConfirmation,[mbYes,mbNo],0)=mrNo then begin
Exit;
end;
StatusLabel.Caption:='Connecting...';
InternetAutodial(internet_autodial_force_unattended, handle);
end;

StatusLabel.Caption:='Contacting server...';
  responseStream := TFileStream.Create(ActDir+CfgIni.ReadString('Configuration','LocalVersionDbFile','versiondb.tmp'), fmCreate);
  IdHTTP1.Get(CfgIni.ReadString('Configuration','VersionDbFile','http://'), responseStream);
  responseStream.free;

StatusLabel.Caption:='Checking requested informations...';
  UpdateDbStorage:=TStringlist.Create;
  UpdateDbStorage.LoadFromFile(ActDir+ExtractFileName(CfgIni.ReadString('Configuration','LocalVersionDbFile','versiondb.tmp')));
  if CfgIni.ReadInteger('Configuration','LocalVersionNumber',0000)<StrToInt(UpdateDbStorage.Strings[0]) then begin
   MessageDlg('An update is avaible and will be downloaded now',mtInformation,[mbOk],0);
   UpdateSoftware;
  end
   else if CfgIni.ReadInteger('Configuration','LocalVersionNumber',0000)=StrToInt(UpdateDbStorage.Strings[0]) then MessageDlg('There`s no update available. ',mtInformation,[mbOk],0); CleanUpdate;

  except
  if MessageDlg('An error has occured while trying to create a connection to the server. The program won`t continue',mtError,[mbOk],0)=mrOk then CleanUpdate; Application.Terminate;
   end;
end;

procedure TUpdateWizard.InstallPatch(FileName: string; Params: string);
var 
  exInfo: TShellExecuteInfo;
  Ph: DWORD; 
begin 
  FillChar(exInfo, SizeOf(exInfo), 0); 
  with exInfo do 
  begin 
    cbSize := SizeOf(exInfo); 
    fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT; 
    Wnd := GetActiveWindow(); 
    ExInfo.lpVerb := 'open'; 
    ExInfo.lpParameters := PChar(Params); 
    lpFile := PChar(FileName); 
    nShow := SW_SHOWNORMAL; 
  end; 
  if ShellExecuteEx(@exInfo) then
    Ph := exInfo.HProcess
  else 
  begin
    ShowMessage(SysErrorMessage(GetLastError));
    Exit; 
  end; 
  while WaitForSingleObject(ExInfo.hProcess, 50) <> WAIT_OBJECT_0 do 
    Application.ProcessMessages; 
  CloseHandle(Ph);
end;

procedure TUpdateWizard.IdHTTP1WorkEnd(Sender: TObject;
  AWorkMode: TWorkMode);
begin
//
end;

procedure TUpdateWizard.delay(msec: LongInt);
var start, stop: LongInt;
begin
  start := GetTickCount;
  repeat
    stop := GetTickCount;
    Application.ProcessMessages;
  until (stop-start)>=msec;
end;


end.
