unit updater_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, JvPanel, JvComponent, Buttons, JvInstallLabel,
  JvSpecialProgress, JvLabel, JvCheckListBox, shellapi,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdIPWatch, WinInet, ImgList, inifiles, strutils, JvComCtrls, JvBitBtn,
  CheckLst, JvBlinkingLabel, JvScrollPanel;

type
  TFormMain = class(TForm)
    PageControl1: TPageControl;
    pgWelcome: TTabSheet;
    Memo1: TMemo;
    JvDivider1: TJvDivider;
    panInfo: TJvPanel;
    btnNext: TJvBitBtn;
    Image1: TImage;
    btnBack: TJvBitBtn;
    btnCancel: TJvBitBtn;
    pgGetData: TTabSheet;
    progGetUpdateData: TJvSpecialProgress;
    pgSelUpdates: TTabSheet;
    JvBlinkingLabel1: TJvBlinkingLabel;
    lstupdatedcomp: TJvCheckListBox;
    pgInstall: TTabSheet;
    InstallLabel1: TJvInstallLabel;
    InstallLabel2: TJvInstallLabel;
    progDlInst: TJvSpecialProgress;
    pgEnd: TTabSheet;
    Memo2: TMemo;
    HTTP1: TIdHTTP;
    IdIPWatch1: TIdIPWatch;
    ImageList1: TImageList;
    pgFailed: TTabSheet;
    Memo3: TMemo;
    function DelDir(dir:string):boolean;
    procedure btnBackClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure CloseApp(Sender:TObject);
    procedure pgWelcomeShow(Sender: TObject);
    procedure pgSelUpdatesShow(Sender: TObject);
    procedure pgInstallShow(Sender: TObject);
    procedure pgEndShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function StartUpdate(verz, appname: string): boolean;
    procedure HTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure HTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure HTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure btnCancelClick(Sender: TObject);
    procedure pgGetDataShow(Sender: TObject);
    procedure GetData;
    procedure InstallPatches;


  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TUpdatedComponentRec = record
   needed:ShortInt;
   VersionNum: Integer;
   Name: string;
   DlUrl: string;
   VersionStr: string;
   end;

var
  FormMain: TFormMain;
  Ini: TMemIniFile;
  VD: TStringlist;
  UpdatedComponents: array of TUpdatedComponentRec;
  mHandle: THandle; // Mutexhandle

implementation

{$R *.dfm}

procedure TFormMain.btnBackClick(Sender: TObject);
begin
        PageControl1.ActivePageIndex:=PageControl1.ActivePageIndex-1;
        PageControl1Change(self);
end;

procedure TFormMain.btnNextClick(Sender: TObject);
begin
        if (PageControl1.ActivePageIndex=2) and (lstupdatedcomp.Items[0]='- No updates available -') then begin
        PageControl1.ActivePageIndex:=PageControl1.ActivePageIndex+2;
        PageControl1Change(self);
        exit;
        end;
        
        PageControl1.ActivePageIndex:=PageControl1.ActivePageIndex+1;
        PageControl1Change(self);
end;

procedure TFormMain.PageControl1Change(Sender: TObject);
begin
        if Pagecontrol1.ActivePageIndex=0 then btnBack.Enabled:=False;
        if Pagecontrol1.ActivePageIndex=1 then GetData;
        if Pagecontrol1.ActivePageIndex=3 then InstallPatches;
        if Pagecontrol1.ActivePageIndex>3 then begin
                btnNext.Enabled:=True;
                btnNext.Caption:='Finish';
                btnBack.Enabled:=False;
                btnCancel.Enabled:=False;
                btnNext.OnClick:=CloseApp;
        end;
end;

procedure TFormMain.CloseApp(Sender:TObject);
begin
        Application.Terminate;
end;

procedure TFormMain.pgWelcomeShow(Sender: TObject);
begin
        panInfo.Caption:='  Step 1: Welcome';
end;

procedure TFormMain.pgSelUpdatesShow(Sender: TObject);
begin
        panInfo.Caption:='  Step 3: Selecting updates';

        btnNext.Enabled:=True;
end;

procedure TFormMain.pgInstallShow(Sender: TObject);
begin
        panInfo.Caption:='  Step 4: Downloading and installing updates';
end;

procedure TFormMain.pgEndShow(Sender: TObject);
begin
        panInfo.Caption:='  Step 5: Finishing update-process';

        if ParamStr(1)='\runandfinish' then begin
                PageControl1Change(self);
                exit;
        end;

        Application.ProcessMessages;
        Update;

        try
                ini.UpdateFile;
                Ini.Free;
                Ini:=nil;

                CopyFile(PChar('updcache\update_settings.dat'),PChar('update_settings.dat'),False);

                DelDir('updcache');

        except
         on E:Exception do begin
                 MessageDlg('The updates were installed succesfully but there was an error when finishing the update process.'+#10#13+'Message: '+E.Message,mtError,[mbOk],0);
                DelDir('updcache');
                if Ini<>nil then Ini.Free;
                 Application.Terminate;
         end;
        end;

end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
        if ParamStr(1)='\runandfinish' then begin
                PageControl1.ActivePageIndex:=4;
                exit;
        end;

        PageControl1.ActivePageIndex:=0;

        try
                ForceDirectories(ExtractFilePath(Application.ExeName)+'updcache\');
                CopyFile(PChar('update_settings.dat'),PChar('updcache\update_settings.dat'),False);

                Ini:=TMemIniFile.Create('updcache\update_settings.dat');

        except
         on E:Exception do begin
                MessageDlg('Error while initializing program. Please try again later or re-install Route Builder.'+#10#13+'Message: '+E.Message,mtError,[mbOk],0);
                  DelDir('updcache');
                 if Ini<>nil then Ini.Free;
                 Application.Terminate;
         end;
        end;
end;

function TFormMain.StartUpdate(verz, appname: string): boolean;
var StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
        progDlInst.Position:=0;
          if verz[length(verz)]<>'\' then verz:=verz+'\';
          FillChar(StartupInfo, SizeOf(TStartupInfo),0);
          StartupInfo.cb:=SizeOf(TStartupInfo);
          progDlInst.Position:=30;

                if CreateProcess(nil, PChar(verz+appname), nil, nil, false,
                 NORMAL_PRIORITY_CLASS, nil, nil, startupinfo, ProcessInfo) then begin
                 progDlInst.Position:=45;
                  try
                    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
                   progDlInst.Position:=60;
                 finally
                   CloseHandle(ProcessInfo.hProcess);
                   CloseHandle(ProcessInfo.hThread);
                    progDlInst.Position:=80;
                  end;
          result:=true;
         end
         else
         result:=false;
         progDlInst.Position:=100;
end;


procedure TFormMain.HTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
        progDlInst.Position:=AWorkcount;
end;

procedure TFormMain.HTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
        progDlInst.Maximum:=AWorkCountMax;
end;

procedure TFormMain.HTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
        progDlInst.Position:=0;
end;

function TFormMain.DelDir(dir:string):boolean;
var 
  fos: TSHFileOpStruct; 
begin 
         ZeroMemory(@fos, SizeOf(fos));
         with fos do
         begin
            wFunc  := FO_DELETE;
            fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
            pFrom  := PChar(dir + #0);
          end;
         Result := (0 = ShFileOperation(fos)); 
end;

procedure TFormMain.btnCancelClick(Sender: TObject);
begin
       if vd<>nil then vd.Free;
        DelDir('updcache');
        if Ini<>nil then Ini.Free;
        Application.Terminate;
end;

procedure TFormMain.GetData;
var DownloadData: TFileStream;
    i,j:integer;
begin

        try

        btnBack.Enabled:=False;
        btnNext.Enabled:=False;

        InstallLabel1.SetImage(0,1);

        Application.ProcessMessages;
        Update;

        IdIpWatch1.Active:=True;
        IdIpWatch1.ForceCheck;

        Application.ProcessMessages;
        Update;

        if not IdIPWatch1.IsOnline then
               if MessageDlg('Currently your computer is not connected to the internet. Do you want to connect now?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
                     InternetAutodial(internet_autodial_force_online, handle)
               else begin
                     PageControl1.ActivePageIndex:=5;
                     PageControl1Change(self);
                     exit;
               end;
        
        IdIpWatch1.ForceCheck;

        if not IdIPWatch1.IsOnline then begin
                PageControl1.ActivePageIndex:=5;
                PageControl1Change(self);
                exit;
        end;

        IdIpWatch1.Active:=False;

        InstallLabel1.SetImage(0,0);

        progGetUpdateData.StepIt;

        InstallLabel1.SetImage(1,1);

        Application.ProcessMessages;
        Update;


        DownloadData:=TFileStream.Create('updcache\vd.db',fmCreate);
        Http1.Get(Ini.ReadString('Settings','DbServerUrl','')+'vd.db',DownloadData);
        DownloadData.Free;

        progGetUpdateData.StepIt;

        InstallLabel1.SetImage(1,0);

        progGetUpdateData.StepIt;

        InstallLabel1.SetImage(2,1);

        Application.ProcessMessages;
        Update;

        VD:=TStringlist.Create;
        VD.LoadFromFile('updcache\vd.db');

        j:=0;

//update-settings.dat
//[Settings]
//DbServerurl=http://www.xy.at/
//[Components]
//main program_version=0000

//vd.db
//component:Main program
//versionint=0000
//versionstr=0.0.0.0
//Url=http://www.url.com
//neededupdate=0/1

        for i:=0 to vd.Count-1 do begin

                if AnsiContainsStr(vd.Strings[i],'component:') then begin
                     inc(j);
                      SetLength(UpdatedComponents,j);
                     UpdatedComponents[j-1].Name:=RightStr(vd.Strings[i],length(vd.Strings[i])-10);
                     UpdatedComponents[j-1].VersionNum:=StrToInt(RightStr(vd.Strings[i+1],length(vd.Strings[i+1])-11));
                     UpdatedComponents[j-1].VersionStr:=RightStr(vd.Strings[i+2],length(vd.Strings[i+2])-11);
                     UpdatedComponents[j-1].DlUrl:=RightStr(vd.Strings[i+3],length(vd.Strings[i+3])-4);
                     UpdatedComponents[j-1].needed:=StrToInt(RightStr(vd.Strings[i+4],length(vd.Strings[i+4])-13));
                end;
        end;

        vd.Free;
        vd:=nil;

        InstallLabel1.SetImage(2,0);

        progGetUpdateData.StepIt;

        InstallLabel1.SetImage(3,1);

        Application.ProcessMessages;
        Update;

        for i:=low(UpdatedComponents) to high(UpdatedComponents) do begin
               if UpdatedComponents[i].VersionNum>Ini.ReadInteger('Components',lowercase(UpdatedComponents[i].Name)+'_version',0) then begin
                       lstupdatedcomp.Items.Add(UpdatedComponents[i].Name+' ('+UpdatedComponents[i].VersionStr+')');
                       lstupdatedcomp.State[i]:=cbChecked;
                       if UpdatedComponents[i].needed=1 then
                        lstupdatedcomp.ItemEnabled[0]:=False;
                end;
end;

        if lstupdatedcomp.Count=0 then begin
               lstupdatedcomp.Items.Add('- No updates available -');
              lstupdatedcomp.ItemEnabled[0]:=false;
        end;

        InstallLabel1.SetImage(3,0);

        progGetUpdateData.StepIt;

        Application.ProcessMessages;
        Update;

        sleep(200);

        PageControl1.ActivePageIndex:=2;
        PageControl1Change(self);

        except
         on E:Exception do begin
          MessageDlg('Error while gathering required information from server. Please try again later.'+#10#13+'Message: '+E.Message,mtError,[mbOk],0);
          if vd<>nil then vd.Free;
          DelDir('updcache');
          if Ini<>nil then Ini.Free;
          Application.Terminate;
         end;
        end;
end;

procedure TFormMain.InstallPatches;
var i,j: integer;
    FS: TFileStream;
begin

        try

        btnNext.Enabled:=false;

        j:=0;

        InstallLabel2.SetImage(0,1);

        Application.ProcessMessages;
        Update;

        for i:=0 to lstupdatedcomp.Count-1 do begin
               if (lstupdatedcomp.Items[i]=UpdatedComponents[i].Name+' ('+UpdatedComponents[i].VersionStr+')') and lstupdatedcomp.Checked[i] then begin
                       inc(j);
                       progDlInst.Caption:='Downloading: '+UpdatedComponents[i].Name;

                        Application.ProcessMessages;
                        Update;

                        FS:=TFilestream.Create('comp_patch0'+IntToStr(j)+'.exe',fmCreate);
                      Http1.Get(UpdatedComponents[i].DlUrl,Fs);
                      Fs.Free;
               end;
        end;

        InstallLabel2.SetImage(0,0);
        InstallLabel2.SetImage(1,1);

        Application.ProcessMessages;
        Update;

        for i:=1 to j do begin
            progDlInst.Caption:='Installing updates, please wait';

            Application.ProcessMessages;
            Update;

            StartUpdate(ExtractFilepath(Application.ExeName),'comp_patch0'+IntToStr(i)+'.exe');
            DeleteFile('comp_patch0'+IntToStr(i)+'.exe');
        end;

        for i:=0 to lstupdatedcomp.Count-1 do begin
           if (lstupdatedcomp.Items[i]=UpdatedComponents[i].Name+' ('+UpdatedComponents[i].VersionStr+')') and (lstupdatedcomp.Checked[i]) then begin
                   Ini.WriteInteger('Components',lowercase(UpdatedComponents[i].Name)+'_version',UpdatedComponents[i].VersionNum);
           end;
        end;

        InstallLabel2.SetImage(1,0);

        Application.ProcessMessages;
        Update;

        PageControl1.ActivePageIndex:=4;
        PageControl1Change(self);

        except
         on E:Exception do begin
          MessageDlg('Error while installing or downloading updates. Please try again later.'+#10#13+'Message: '+E.Message,mtError,[mbOk],0);
         DelDir('updcache');
         if Ini<>nil then Ini.Free;
        Application.Terminate;
        end;
       end;
end;

procedure TFormMain.pgGetDataShow(Sender: TObject);
begin
        panInfo.Caption:='  Step 2: Get update informations';
end;


initialization
        mHandle := CreateMutex(nil,True,'rbu');
          if GetLastError = ERROR_ALREADY_EXISTS then begin // Anwendung läuft bereits
          ShowMessage('Route Builder update program already started!');
          halt;
end;


finalization
        if mHandle <> 0 then CloseHandle(mHandle)

end.
