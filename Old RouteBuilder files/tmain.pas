unit tmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Inifiles, Shellapi,uRBProject, MsgINISupp,
  LngINISupp, jpeg, ExtCtrls, ComCtrls, 
  StdCtrls, Buttons, ImgList, ToolWin,  uGlobalDef, uRBRouteDefinition,
  URBEditorFrame2, uEditorFrame, uRBSaveRegionForm, uRBRegionBrowser,
  uCurrentsituation,
  utools, DXDraws, DIB;

type
  TFormMain = class(TForm)
    MM1: TMainMenu;
    Project: TMenuItem;
    Projekt_Create: TMenuItem;
    Project_Continue: TMenuItem;
    MenuSaveAs: TMenuItem;
    N1: TMenuItem;
    RB_Exit: TMenuItem;
    Help: TMenuItem;
    Help2: TMenuItem;
    AboutRB: TMenuItem;
    N2: TMenuItem;
    GoToHomepage: TMenuItem;
    Extras: TMenuItem;
    MenuProperties: TMenuItem;
    AutoUpdate1: TMenuItem;
    AddonManager: TMenuItem;
    StatusBar: TStatusBar;
    MenuExport: TMenuItem;
    View: TMenuItem;
    MenuTrackProperties: TMenuItem;
    MenuTimetables: TMenuItem;
    MenuRoutes: TMenuItem;
    Trains: TMenuItem;
    MenuObjects: TMenuItem;
    Options: TMenuItem;
    N3: TMenuItem;
    menuSave: TMenuItem;
    N4: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    tbSave: TToolButton;
    ToolButton4: TToolButton;
    ImageListToolbar: TImageList;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    tbExport: TToolButton;
    ToolButton11: TToolButton;
    FrmEditor: TFrmEditor;
    CoolBar1: TCoolBar;
    RouteBuilderTechnicalInformation1: TMenuItem;
    moveeverything1: TMenuItem;
    RouteBuilderStreckenbauForumdeutsch1: TMenuItem;
    Map1: TMenuItem;
    RouteBuilderBugtrackingForum1: TMenuItem;
    N5: TMenuItem;
    MakePackage1: TMenuItem;
    mTrackTypes1: TMenuItem;
    LngINISupp1: TLngINISupp;
    replace1: TMenuItem;
    MenuGrids: TMenuItem;
    MenuGridTracks: TMenuItem;
    N6: TMenuItem;
    l1: TMenuItem;
    Changeproperty1: TMenuItem;
    SaveRegionas1: TMenuItem;
    SaveDialog2: TSaveDialog;
    ImportRegion1: TMenuItem;
    Signals1: TMenuItem;
    DXDraw1: TDXDraw;
    Emptyarea1: TMenuItem;
    procedure Projekt_CreateClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OptionenClick(Sender: TObject);
    procedure AddonManagerClick(Sender: TObject);
    procedure AutoUpdate1Click(Sender: TObject);
    procedure AboutRBClick(Sender: TObject);
    procedure GoToHomepageClick(Sender: TObject);
    procedure OptionsClick(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure menuSaveClick(Sender: TObject);
    procedure MenuSaveAsClick(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MenuTrackPropertiesClick(Sender: TObject);
    procedure MenuTimetablesClick(Sender: TObject);
    procedure MenuRoutesClick(Sender: TObject);
    procedure TrainsClick(Sender: TObject);
    procedure MenuObjectsClick(Sender: TObject);
    procedure RB_ExitClick(Sender: TObject);
    procedure MenuExportClick(Sender: TObject);
    procedure tbExportClick(Sender: TObject);
    procedure MenuPropertiesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FrmEditorToolButton5Click(Sender: TObject);
    procedure Help2Click(Sender: TObject);
    procedure RouteBuilderTechnicalInformation1Click(Sender: TObject);
    procedure moveeverything1Click(Sender: TObject);
    procedure RouteBuilderStreckenbauForumdeutsch1Click(Sender: TObject);
    procedure FrmEditortbMap1Click(Sender: TObject);
    procedure FrmEditortbStraightClick(Sender: TObject);
    procedure RouteBuilderBugtrackingForum1Click(Sender: TObject);
    procedure MakePackage1Click(Sender: TObject);
    procedure mTrackTypes1Click(Sender: TObject);
    procedure replace1Click(Sender: TObject);
    procedure FrmEditorcbTrackTypeChange(Sender: TObject);
    procedure MenuGridsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuGridTracksClick(Sender: TObject);
    procedure l1Click(Sender: TObject);
    procedure FrmEditortb3DWorldClick(Sender: TObject);
    procedure FrmEditorToolButton6Click(Sender: TObject);
    procedure Changeproperty1Click(Sender: TObject);
    procedure SaveRegionas1Click(Sender: TObject);
    procedure FrmEditorTimer1Timer(Sender: TObject);
    procedure ImportRegion1Click(Sender: TObject);
    procedure Signals1Click(Sender: TObject);
    procedure DXDraw1DblClick(Sender: TObject);
    procedure DXDraw1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DXDraw1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DXDraw1Initialize(Sender: TObject);
    procedure DXDraw1Finalize(Sender: TObject);
    procedure Emptyarea1Click(Sender: TObject);
  private
    { Private declarations }
    procedure FinalizeLoad();
    procedure OpenOther();
  public
    LastRecentlyUsedFiles: TStringlist;
    FTrackSurface: TDirectDrawSurface;
    procedure SetProjectLoaded(aprojectloaded: boolean);
    procedure SetStatus(const what: string);
    procedure AddRecentlyUsed(f: string);
    procedure PaintDX();
  end;

var
  FormMain: TFormMain;
  Definition_Unit: TRBRouteDefinition;
  Project_Unit: TRBProject;
implementation

uses tWizard_CreateProject, tBveFolder, toptions, taddons, tabout,
  ttrain, uRouteDefinitionsForm, texport, uObjectsForm, uProjectProperties,
  uwelcome, uMoveEverything, uStationsForm, tcreatepackage, uTrackTypes,
  uReplaceForm, uRBGridsForm, uGridTracks, ttimetable, uRB3DPreviewForm,
  uChangePropertyForm;

{$R *.dfm}

procedure TFormMain.Projekt_CreateClick(Sender: TObject);
begin
if FormMain.FrmEditor.CurrentProject<>nil then MessageDlg(lngmsg.GetMsg('tmain_ask_save'),mtConfirmation,[mbYes,mbNo],0);
if(CreateProj_Wizard.Showmodal=mrOK) then
      SetProjectLoaded(true);
end;

procedure TFormMain.FinalizeLoad();
begin
      if (FrmEditor.CurrentProject.Objectlibrary<>'')and(FrmEditor.CurrentProject.Objectlibrary<>FormOptions.edObjFolder.text) then
      begin
        if MessageDlg(lngmsg.GetMsg('tmain_different_lib'), mtConfirmation, [mbYes,mbNo], 0) = mrYes then
          FormOptions.SetObjectFolder( FrmEditor.CurrentProject.Objectlibrary );
        // da zu diesem Zeitpunkt der Schaden schon geschehen sein kann, müssen wir nochmal laden!
        FrmEditor.CurrentProject.free;
        FrmEditor.CurrentProject := nil;
        FrmEditor.CurrentProject := TRBProject.Create();
        FrmEditor.CurrentProject.SetStatusProc := SetStatus;
        FrmEditor.LoadProject(FormWelcome.todo);
      end;
      SetProjectLoaded(true);
      AddRecentlyUsed(FrmEditor.CurrentProject.Projectfilename);
      SetStatus('ready');
      FrmEditor.Show;
      PaintDX;
end;


procedure TFormMain.FormShow(Sender: TObject);
var i: integer;

begin
  FormMain.SetProjectLoaded(false);
  FormMain.WindowState := wsMaximized;

  // Sprachunterstützung
  if DefaultLanguage='' then DefaultLanguage := 'english.lng';
  LngINISupp1.FileName := DefaultLanguage;
  LngINISupp1.Open;
  LngMsg := TMsgINISupp.create(self);
  LngMsg.LngINISupp := LngIniSupp1;
  LngMsg.Open;



  // welcome-Dialog
  FormWelcome.ListView1.clear();
  for i:=0 to LastRecentlyUsedFiles.count-1 do
    if (LastRecentlyUsedFiles[i]<>'')and(fileexists(LastRecentlyUsedFiles[i])) then
      with FormWelcome.ListView1.items.add do
        caption := LastRecentlyUsedFiles[i];

  // Fenstertitel und Statusbar setzen
  Caption := ProgramName + ' '+VersionString;
  StatusBar.Panels[0].Text := ProgramName;
  StatusBar.Panels[1].Text := 'Version ' + VersionString;

  // Öffnen per Doppelclick auf rbp-Datei
  if (ParamCount=1) and (fileexists(paramstr(1))) then
  begin
    FrmEditor.CurrentProject := TRBProject.Create();
    FrmEditor.CurrentProject.SetStatusProc := SetStatus;
    SetStatus('loading...');
    FrmEditor.LoadProject(paramstr(1));
    FinalizeLoad();
  end
  else
  begin
    if FormWelcome.ShowModal()=mrOK then
    begin
      if FormWelcome.todo='new' then Projekt_CreateClick(self)
      else
      if FormWelcome.todo='open' then OpenOther()
      else
      if FormWelcome.todo<>'' then
      begin
        FrmEditor.CurrentProject := TRBProject.Create();
        FrmEditor.CurrentProject.SetStatusProc := SetStatus;
        SetStatus('loading...');
        FrmEditor.LoadProject(FormWelcome.todo);
        FinalizeLoad();
      end;
    end;

  end;


  FrmEditor.ArrowStepSize := FormOptions.ArrowStepSize;

end;

procedure TFormMain.OptionenClick(Sender: TObject);
begin
  FormOptions.ShowModal;  //Optionen
  FrmEditor.ArrowStepSize := FormOptions.ArrowStepSize;
  FrmEditor.UpdateView();
end;

procedure TFormMain.AddonManagerClick(Sender: TObject);
begin
FormAddons.Showmodal;   // Addonmodul
end;

procedure TFormMain.AutoUpdate1Click(Sender: TObject);
begin
ShellExecute(Application.Handle,Pchar('open'),PChar(FormOptions.AktVZ+'\update.exe'),nil,PChar(ExtractFilePath(FormOptions.AktVZ+'\autoupdate.exe')),sw_ShowNormal);  //Ruft update.exe normal auf

end;

procedure TFormMain.AboutRBClick(Sender: TObject);
begin
FormAbout.ShowModal;  //About Dialog
end;

procedure TFormMain.GoToHomepageClick(Sender: TObject);
begin
ShellExecute(Application.Handle,'open',PChar(HomepageURL),nil,PChar(HomepageURL),sw_ShowNormal);  //ruft Homepage mit Browser normal auf
end;

procedure TFormMain.OptionsClick(Sender: TObject);
begin
  FormOptions.ShowModal();
  FrmEditor.UpdateView();
end;

procedure TFormMain.OpenOther();
begin
if OpenDialog1.Execute then
  begin
    FrmEditor.CurrentProject := TRBProject.Create();
    FrmEditor.CurrentProject.SetStatusProc := SetStatus;
    SetStatus('loading...');
    try
      FrmEditor.LoadProject(OpenDialog1.FileName);
      SetProjectLoaded(true);
      AddRecentlyUsed(FrmEditor.CurrentProject.Projectfilename);
      // Objektverzeichnis setzen wenn nötig
      if (FrmEditor.CurrentProject.Objectlibrary<>'')and(FrmEditor.CurrentProject.Objectlibrary<>FormOptions.edObjFolder.text) then
      begin
        if MessageDlg(lngmsg.GetMsg('tmain_different_lib'), mtConfirmation, [mbYes,mbNo], 0) = mrYes then
          FormOptions.SetObjectFolder( FrmEditor.CurrentProject.Objectlibrary );
        // da zu diesem Zeitpunkt der Schaden schon geschehen sein kann, müssen wir nochmal laden!
        FrmEditor.CurrentProject.free;
        FrmEditor.CurrentProject := nil;
        FrmEditor.CurrentProject := TRBProject.Create();
        FrmEditor.CurrentProject.SetStatusProc := SetStatus;
        FrmEditor.LoadProject(OpenDialog1.FileName);
      end;
    except
      on e: exception do
      begin
        MessageDlg(lngmsg.GetMsg('tmain_errorloading') +' ' + e.message,mtError,[mbAbort],0);
        FrmEditor.CurrentProject.Free;
        FrmEditor.CurrentProject := nil;
      end;
    end;
    SetStatus('ready');
  end;
end;

procedure TFormMain.OpenClick(Sender: TObject);
begin
  if FrmEditor.CurrentProject<>nil then
  begin
    if MessageDlg(lngmsg.GetMsg('tmain_ask_save'),mtConfirmation,[mbYes,mbNo],0)=mrYes then
      MenuSaveClick(self);

    formgrids.close();
    FormRouteDefinitions.close();
    FormTimetables.Close();
    formstations.close();

    FrmEditor.CurrentProject.free;
    FrmEditor.CurrentProject := nil;
    FrmEditor.PanMap.Hide;

    SetProjectLoaded(false);
  end;
  if FormWelcome.ShowModal()=mrOK then
  begin
    if FormWelcome.todo='new' then Projekt_CreateClick(self)
    else
    if FormWelcome.todo='open' then OpenOther()
    else
    if FormWelcome.todo<>'' then
    begin
      FrmEditor.CurrentProject := TRBProject.Create();
      FrmEditor.CurrentProject.SetStatusProc := SetStatus;
      SetStatus('loading...');
      FrmEditor.LoadProject(FormWelcome.todo);
      FinalizeLoad();
    end;
  end;
{  if OpenDialog1.Execute then
  begin
    FrmEditor.CurrentProject := TRBProject.Create();
    FrmEditor.CurrentProject.SetStatusProc := SetStatus;
    SetStatus('loading...');
    try
      FrmEditor.LoadProject(OpenDialog1.FileName);
      SetProjectLoaded(true);
      AddRecentlyUsed(FrmEditor.CurrentProject.Projectfilename);
      // Objektverzeichnis setzen wenn nötig
      if (FrmEditor.CurrentProject.Objectlibrary<>'')and(FrmEditor.CurrentProject.Objectlibrary<>FormOptions.edObjFolder.text) then
      begin
        if MessageDlg(lngmsg.GetMsg('tmain_different_lib'), mtConfirmation, [mbYes,mbNo], 0) = mrYes then
          FormOptions.SetObjectFolder( FrmEditor.CurrentProject.Objectlibrary );
        // da zu diesem Zeitpunkt der Schaden schon geschehen sein kann, müssen wir nochmal laden!
        FrmEditor.CurrentProject.free;
        FrmEditor.CurrentProject := nil;
        FrmEditor.CurrentProject := TRBProject.Create();
        FrmEditor.CurrentProject.SetStatusProc := SetStatus;
        FrmEditor.LoadProject(OpenDialog1.FileName);
      end;
    except
      on e: exception do
      begin
        MessageDlg(lngmsg.GetMsg('tmain_errorloading') +' ' + e.message,mtError,[mbAbort],0);
        FrmEditor.CurrentProject.Free;
        FrmEditor.CurrentProject := nil;
      end;
    end;
    SetStatus('ready');
  end;    }
end;

procedure TFormMain.menuSaveClick(Sender: TObject);
begin
  if FrmEditor.CurrentProject<>nil then
  begin
    if FrmEditor.CurrentProject.Projectfilename='' then
      MenuSaveAsClick(self)
    else
    begin
      SetStatus('saving...');
      Screen.Cursor := crHourGlass;
      FrmEditor.CurrentProject.Objectlibrary := FormOptions.ObjectFolder;
      FrmEditor.CurrentProject.SaveToFile();
      Screen.Cursor := crArrow;
      SetStatus('ready');
    end;
    AddRecentlyUsed(FrmEditor.CurrentProject.Projectfilename);
  end;

end;

procedure TFormMain.MenuSaveAsClick(Sender: TObject);
begin
  if FrmEditor.CurrentProject<>nil then
  begin
    SaveDialog1.InitialDir := extractfilepath(FrmEditor.CurrentProject.Projectfilename);
    if SaveDialog1.Execute then
    begin
      FrmEditor.CurrentProject.Objectlibrary := FormOptions.ObjectFolder;
      if pos('.rbp',lowercase(SaveDialog1.FileName))=0 then
        SaveDialog1.FileName := SaveDialog1.FileName+'.rbp';
      SetStatus('saving...');
      FrmEditor.CurrentProject.SaveToFile(SaveDialog1.FileName);
      SetStatus('ready');
      FrmEditor.CurrentProject.projectfilename := SaveDialog1.FileName;
    end;
  end;

end;

procedure TFormMain.Cut1Click(Sender: TObject);
begin
//
end;

procedure TFormMain.Copy1Click(Sender: TObject);
begin
//
end;

procedure TFormMain.Paste1Click(Sender: TObject);
begin
//
end;

procedure TFormMain.Undo1Click(Sender: TObject);
begin
  FrmEditor.Undo();
end;

procedure TFormMain.SetProjectLoaded(aprojectloaded: boolean);
begin
  // enable Menüpunkt und Toolbuttons abhängig davon ob ein Projekt geladen ist (up)
  MenuSave.Enabled   := aprojectloaded;
  MenuSaveAs.Enabled := aprojectloaded;
  MenuExport.Enabled := aprojectloaded;
  SaveRegionas1.Enabled := aprojectloaded;
  ImportRegion1.Enabled := aprojectloaded;
  tbExport.Enabled   := aprojectloaded;
  tbSave.Enabled     := aprojectloaded;
  MenuProperties.Enabled := aprojectloaded;
  MenuTrackProperties.Enabled := aprojectloaded;
  MenuTimetables.Enabled := aprojectloaded;
  MenuRoutes.Enabled := aprojectloaded;
  MenuObjects.Enabled:= aprojectloaded;
  MenuGrids.Enabled  := aprojectloaded;
  MenuGridTracks.Enabled := aprojectloaded;
  FrmEditor.Visible  := aprojectloaded;
  DXDraw1.Visible := aprojectloaded;
  Signals1.enabled   := aprojectloaded;
  if aprojectloaded then
    StatusBar.Panels[0].Text := FrmEditor.CurrentProject.Projectname
  else
    StatusBar.Panels[0].Text := '';
end;

procedure TFormMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=ord('T')) and (ssCtrl in Shift) then
  begin
    FrmEditor.properties1Click(self);
  end
  else
  if (key=ord('C')) and (ssCtrl in Shift) then
  begin
    FrmEditor.copyproperties1Click(self);
  end
  else
  if (key=ord('V')) and (ssCtrl in Shift) then
  begin
    FrmEditor.pasteproperties1Click(self);
  end
  else
  if (key=ord('Z')) and (ssCtrl in Shift) then
  begin
    FrmEditor.Undo();
  end
  else
  if (key=ord('G')) and (ssCtrl in Shift) then
  begin
    FrmEditor.addtogrid1Click(self);
  end
  else
  if (key=ord('D')) and (ssCtrl in Shift) then
  begin
    // delete
    FrmEditor.deleteobject1Click(self);
  end
  else  if (key=ord('L')) and (ssCtrl in Shift) then
  begin
    FrmEditor.cloneobject1Click(self);
  end
  else  if (key=ord('M')) and (ssCtrl in Shift) then
  begin
    FrmEditor.objectproperties1Click(self);
  end
  else  if (key=ord('P')) and (ssCtrl in Shift) then
  begin
    FrmEditor.addnewpointandconnect1Click(self);
  end
  // simple track laying
  else if (key=ord(' ')) and (Shift = []) then
  begin
    FormGridTracks.ToolButton1Click(self);
  end
  else if (key=ord('L')) and (Shift = []) then
  begin
    FormGridTracks.ToolButton2Click(self);
  end
  else if (key=ord('R')) and (Shift = []) then
  begin
    FormGridTracks.ToolButton3Click(self);
  end
  else if (key=ord('A')) and (Shift = []) then
  begin
    FormGridTracks.ToolButton15Click(self);
  end
  else if (key=8) and (Shift = []) then
  begin
    FormGridTracks.ToolButton16Click(self);
  end
  else if (key=37) and (Shift = []) then
  begin
    dec(Currentsituation.CurrentGridX);
    FrmEditor.UpdateView(self,true);
  end
  else if (key=39) and (Shift = []) then
  begin
    inc(Currentsituation.CurrentGridX);
    FrmEditor.UpdateView(self,true);
  end
  else if (key=38) and (Shift = []) then
  begin
    inc(Currentsituation.CurrentGridZ);
    FrmEditor.UpdateView(self,true);
  end
  else if (key=40) and (Shift = []) then
  begin
    dec(Currentsituation.CurrentGridZ);
    FrmEditor.UpdateView(self,true);
  end



end;


procedure TFormMain.MenuTrackPropertiesClick(Sender: TObject);
begin
  if FrmEditor.CurrentProject<>nil then
    FrmEditor.properties1Click(self);
end;

procedure TFormMain.MenuTimetablesClick(Sender: TObject);
begin
    FrmEditor.ToolButton6Click(Sender); 
end;

procedure TFormMain.MenuRoutesClick(Sender: TObject);
begin
  FrmEditor.ToolButton1Click(Sender);
end;

procedure TFormMain.TrainsClick(Sender: TObject);
begin
  FormTrain.ShowModal;
end;

procedure TFormMain.MenuObjectsClick(Sender: TObject);
begin
  if FrmEditor.CurrentProject<>nil then
    FormObjects.Show;
end;

procedure TFormMain.RB_ExitClick(Sender: TObject);
begin
{  if FrmEditor.CurrentProject<>nil then
   begin
    if MessageDlg(lngmsg.GetMsg('tmain_ask_save') ,mtConfirmation,[mbYes,mbNo],0)=mrYes then MenuSaveClick(self);
   end;   }
  close;
end;

procedure TFormMain.MenuExportClick(Sender: TObject);
begin
  if FrmEditor.CurrentProject<>nil then
  begin
    if FrmEditor.CurrentProject.Routes.count=0 then
    begin
      MessageDlg(lngmsg.GetMsg('tmain_no_rd'),mtWarning,[mbOK],0);
      // zeige RouteDefinition-Dialog
      FrmEditor.ToolButton1Click(Sender);
      exit;
    end;

    FormExport.ProjectToExport := FrmEditor.CurrentProject;
    FormExport.ShowModal;
  end
  else
  begin
    MessageDlg(lngmsg.GetMsg('tmain_no_pr') ,mtWarning,[mbOK],0)
  end;
end;
procedure TFormMain.tbExportClick(Sender: TObject);
begin
  SetStatus('exporting...');
  MenuExportClick(sender);
  SetStatus('ready');
end;

procedure TFormMain.MenuPropertiesClick(Sender: TObject);
begin
  FormProjectProperties.DoIt( FrmEditor.CurrentProject );
end;

procedure TFormMain.FormCreate(Sender: TObject);
var s: string;
begin
  KeyPreview := true;
  LastRecentlyUsedFiles := TStringlist.Create;
  s := extractfilepath(application.exename)+'\default.lru'; // Auslieferungszustand
  if fileexists(s) then LastRecentlyUsedFiles.loadfromfile(s);
  s := extractfilepath(application.exename)+'\routebuilder.lru';
  if fileexists(s) then LastRecentlyUsedFiles.loadfromfile(s);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  LastRecentlyUsedFiles.free;
end;

// Funktion: AddRecentlyUsed
// Autor   : up
// Datum   : 5.12.02
// Beschr. : fügt der Liste der zuletzt benutzten Projektdateien f hinzu (f mit Pfad)
procedure TFormMain.AddRecentlyUsed(f: string);
var s: string;
begin
  if LastRecentlyUsedFiles.IndexOf(f)>=0 then
    LastRecentlyUsedFiles.Delete(LastRecentlyUsedFiles.IndexOf(f));
  LastRecentlyUsedFiles.Insert(0,f);
  s := extractfilepath(application.exename)+'\routebuilder.lru';
  LastRecentlyUsedFiles.savetofile(s);
end;

procedure TFormMain.FrmEditorToolButton5Click(Sender: TObject);
begin
  FrmEditor.ToolButton1Click(Sender);

end;

procedure TFormMain.Help2Click(Sender: TObject);
begin
  //  open  RouteBuilder Manual.pdf
  ShellExecute(0,'open',pchar(ExtractFilePath(Application.exename)+'\RouteBuilder Manual.pdf'),
    pchar(''),pchar(ExtractFilePath(Application.exename)),sw_ShowNormal);
end;

procedure TFormMain.RouteBuilderTechnicalInformation1Click(
  Sender: TObject);
begin
ShellExecute(Application.Handle,'open',PChar(Homepage2URL),nil,PChar(Homepage2URL),sw_ShowNormal);  //ruft Homepage mit Browser normal auf
end;

procedure TFormMain.moveeverything1Click(Sender: TObject);
begin
  //
  FormmoveEverything.project := FrmEditor.CurrentProject;
  if FormmoveEverything.showModal()=mrOK then
    FrmEditor.UpdateView();
end;

procedure TFormMain.RouteBuilderStreckenbauForumdeutsch1Click(
  Sender: TObject);
begin
ShellExecute(Application.Handle,'open',PChar(HomepageFURL),nil,PChar(HomepageFURL),sw_ShowNormal);  //ruft Homepage mit Browser normal auf

end;

procedure TFormMain.FrmEditortbMap1Click(Sender: TObject);
begin
  FrmEditor.tbMapClick(Sender);

end;

procedure TFormMain.FrmEditortbStraightClick(Sender: TObject);
begin
  FrmEditor.straight1Click(Sender);

end;

procedure TFormMain.RouteBuilderBugtrackingForum1Click(Sender: TObject);
begin
ShellExecute(Application.Handle,'open',PChar(Homepage3URL),nil,PChar(Homepage3URL),sw_ShowNormal);  //ruft Homepage mit Browser normal auf
end;

procedure TFormMain.MakePackage1Click(Sender: TObject);
begin
//
  if FrmEditor.CurrentProject<>nil then
  begin
    FormCreatePackage.ObjDirEdit.Text :=  FrmEditor.CurrentProject.Routefilessubdir;
    FormCreatePackage.RouteDirEdit.Text :=  FrmEditor.CurrentProject.Routefilessubdir;
    FormCreatePackage.ProjectToExport :=  FrmEditor.CurrentProject;
    FormCreatePackage.ShowModal();
  end;

end;

procedure TFormMain.mTrackTypes1Click(Sender: TObject);
begin
  Formtracktypes.ShowModal();
end;

procedure TFormMain.replace1Click(Sender: TObject);
begin
  formReplace.CurrentProject := FrmEditor.CurrentProject;
  formReplace.ShowModal();
end;

procedure TFormMain.FrmEditorcbTrackTypeChange(Sender: TObject);
begin
  FrmEditor.cbTrackTypeChange(Sender);
  SetFocusedControl(FrmEditor.tbZoom);
end;

procedure TFormMain.SetStatus(const what: string);
begin
  statusbar.panels[1].text := what;
  Application.ProcessMessages;
end;

procedure TFormMain.MenuGridsClick(Sender: TObject);
begin
  if FrmEditor.CurrentProject<>nil then
    FrmEditor.tbGridsClick(self);
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var sr,sr1: TSearchrec;
    p,p1: string;
begin
  if FrmEditor.CurrentProject<>nil then
  begin
    if MessageDlg(lngmsg.GetMsg('tmain_ask_save') ,mtConfirmation,[mbYes,mbNo],0)=mrYes then MenuSaveClick(self);
  end;
  // cleanup bmp_swap cagal
  p := extractfilepath(application.exename)+'\'+FormOptions.ObjectFolder+'\*.*';
  if Findfirst(p,faDirectory,sr)=0 then
  begin
    repeat
      if sr.Attr and faDirectory >0 then
      begin
        p1 := extractfilepath(application.exename)+'\'+FormOptions.ObjectFolder+'\' + sr.name + '\*.bmp_swap';
        if Findfirst(p1,faAnyFile,sr1)=0 then
        begin
          repeat
            if sr1.Attr and faAnyFile >0 then
              DeleteFile(extractfilepath(application.exename)+'\'+FormOptions.ObjectFolder+'\' + sr.name + '\' + sr1.name );
          until findnext(sr1)<>0;
          Findclose(sr1);
        end;
      end;
    until findnext(sr)<>0;
    FindClose(sr);
  end;

end;

procedure TFormMain.MenuGridTracksClick(Sender: TObject);
begin
  if FrmEditor.CurrentProject<>nil then
  begin
    FormGridTracks.CurrentProject := FrmEditor.CurrentProject;
    FormGridTracks.Show;
  end;
end;

procedure TFormMain.l1Click(Sender: TObject);
begin
  //
  if FrmEditor.CurrentProject=nil then exit;
  FrmEditor.tb3DWorldClick(Sender);
end;

procedure TFormMain.FrmEditortb3DWorldClick(Sender: TObject);
begin
  SetStatus('rendering 3D world...');
  FrmEditor.tb3DWorldClick(Sender);

end;

procedure TFormMain.FrmEditorToolButton6Click(Sender: TObject);
begin
  FrmEditor.ToolButton6Click(Sender);

end;

procedure TFormMain.Changeproperty1Click(Sender: TObject);
begin
  //
  formchangeproperty.project :=  FrmEditor.CurrentProject;
  formchangeproperty.ShowModal();
end;

procedure TFormMain.SaveRegionas1Click(Sender: TObject);
var srf: TFormSaveRegion;
begin
  if FrmEditor.CurrentProject=nil then exit;
  SaveDialog2.InitialDir := extractfilepath(application.exename)+'\regions';
  if SaveDialog2.Execute then
  begin
    if pos('.rbr',lowercase(SaveDialog2.FileName))=0 then
      SaveDialog2.FileName := SaveDialog2.FileName+'.rbr';
    srf := TFormSaveRegion.Create(self);
    srf.leAuthor.Text := FrmEditor.CurrentProject.Author;
    if (srf.ShowModal=mrOK) then
    begin
      SetStatus('saving...');
      FrmEditor.CurrentProject.SaveRegionToFile(SaveDialog2.FileName,srf.leAuthor.text,srf.memoComment.lines.text);
      SetStatus('ready');
    end;
    srf.free;
  end;
end;

procedure TFormMain.FrmEditorTimer1Timer(Sender: TObject);
var p: TPoint;
begin
  FrmEditor.Timer1Timer(Sender);
  // Größe des DirectDraw-Schirms an PBCursor anpassen
  p.X:=0; p.y:=0;
  p := FrmEditor.PBCursor.ClientToParent(p,self);
  DXDraw1.Left := p.x;
  DXDraw1.Top  := p.y;
  p.X:=FrmEditor.PBCursor.width-1; p.y:=FrmEditor.PBCursor.height-1;
  p := FrmEditor.PBCursor.ClientToParent(p,self);
  DXDraw1.Width := p.x-DXDraw1.left;
  DXDraw1.Height := p.y-DXDraw1.Top;
  
end;

procedure TFormMain.ImportRegion1Click(Sender: TObject);
var rb: TFormRegionBrowser;
begin
  if FrmEditor.CurrentProject=nil then exit;

  rb := TFormRegionBrowser.Create(self);
  rb.DirectoryListBox1.Directory := extractfilepath(application.exename)+'\regions';
  if rb.ShowModal=mrOK then
  begin
    SetStatus('importing...');
    FrmEditor.CurrentProject.ImportRegionFromFile(rb.FileListBox1.FileName);
    SetStatus('ready');
    FrmEditor.UpdateView();
  end;

  rb.free;
  {OpenDialog2.InitialDir := extractfilepath(FrmEditor.CurrentProject.Projectfilename);
  if OpenDialog2.Execute then
  begin
    SetStatus('importing...');
    FrmEditor.CurrentProject.ImportRegionFromFile(OpenDialog2.FileName);
    SetStatus('ready');
    FrmEditor.UpdateView();
  end;}

end;

procedure TFormMain.Signals1Click(Sender: TObject);
begin
  FrmEditor.tbSignalsClick(self);
end;

procedure TFormMain.DXDraw1DblClick(Sender: TObject);
begin
  if FrmEditor<>nil then FrmEditor.PBCursorDblClick(sender);
end;

procedure TFormMain.DXDraw1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FrmEditor<>nil then FrmEditor.PBCursorMouseDown(sender,button,shift,x,y);
end;

procedure TFormMain.DXDraw1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if FrmEditor<>nil then
  begin
    FrmEditor.MouseOverEffectCanvas := DXDraw1.Surface.Canvas;
    FrmEditor.ScrollBox1MouseMove(sender,shift,x,y);
    DXDraw1.Surface.Canvas.Release;
    DXDraw1.Flip;
  end;
end;


procedure TFormMain.DXDraw1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FrmEditor<>nil then FrmEditor.PBCursorMouseUp(sender,button,shift,x,y);
end;

procedure TFormMain.PaintDX();
begin
  if not DXDraw1.CanDraw then Exit;
  if FrmEditor=nil then exit;
  if FrmEditor.Visible=false then exit;
  if FrmEditor.CurrentProject=nil then exit;

  DXDraw1.Surface.Fill(RGB(0, 40, 0));

  FrmEditor.PaintBlackArea(DXDraw1.Surface.Canvas);
  if CurrentSituation.zoom>=FormOptions.GetMinZoomSolid() then
    FrmEditor.paintConnectionsSolid(DXDraw1.Surface);
  FrmEditor.paintConnections(DXDraw1.Surface.Canvas);
  FrmEditor.paintPoints(DXDraw1.Surface.Canvas);
  FrmEditor.paintFreeObjects(DXDraw1.Surface.Canvas);
  FrmEditor.paintSelArea(DXDraw1.Surface.Canvas);
  FrmEditor.paintCursor(DXDraw1.Surface.Canvas);
  FrmEditor.paintActiveGridItem(DXDraw1.Surface.Canvas);
  DXDraw1.Surface.Canvas.Release;
  DXDraw1.Flip;
end;

procedure TFormMain.DXDraw1Initialize(Sender: TObject);
begin
  FTrackSurface := TDirectDrawSurface.Create(DXDraw1.DDraw);
  FTrackSurface.LoadFromFile(extractfilepath(application.exename)+'tr_straight.bmp');
end;

procedure TFormMain.DXDraw1Finalize(Sender: TObject);
begin
  FTrackSurface.Free;
end;

procedure TFormMain.Emptyarea1Click(Sender: TObject);
begin
  FrmEditor.CurrentProject.ClearArea(currentsituation.selarea1,currentsituation.selarea2);
  FrmEditor.UpdateView();
end;

end.
