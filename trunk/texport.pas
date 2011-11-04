unit texport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uRBProject, ttrain, tRBExport,uEditorFrame, Shellapi,
  Gauges, ComCtrls,
  uRBConnectionlist, uGlobalDef, uTools, uRBRouteDefinition,
  uRBStation, uRBMinimap, tPackager, CheckLst, tRBTimetable;

type
  TFormExport = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    RoutefileOptionsBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    export_set_Trains: TComboBox;
    export_set_Routes: TComboBox;
    leSubdir: TLabeledEdit;
    ExportStatusProgress: TProgressBar;
    ExportBtn: TButton;
    Label3: TLabel;
    MemoStatus: TMemo;
    Label4: TLabel;
    bClose: TButton;
    cbRunBVE: TCheckBox;
    cbCopyfiles: TCheckBox;
    lbFilelist: TListBox;
    Label5: TLabel;
    cbRunPackageWizard: TCheckBox;
    ExportStatusText: TLabel;
    ProgressBarCopy: TProgressBar;
    lCopy: TLabel;
    leRoutefilename: TLabeledEdit;
    MemoStatus1: TMemo;
    Label7: TLabel;
    cbStartStation: TComboBox;
    Label8: TLabel;
    cbNextStation: TComboBox;
    leDepartureTime: TLabeledEdit;
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    ProgressBar2: TProgressBar;
    Image2: TImage;
    Label6: TLabel;
    lbRD: TListBox;
    bAdd: TButton;
    bdelRD: TButton;
    Label9: TLabel;
    lbStops: TCheckListBox;
    lStops: TLabel;
    cbTimetables: TComboBox;
    cbNight: TCheckBox;
    cbBVE4: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure ExportBtnClick(Sender: TObject);
    function StartDevelopermode:string; virtual;
    procedure bCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbStartStationChange(Sender: TObject);
    procedure cbNextStationChange(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure cbRunPackageWizardClick(Sender: TObject);
    procedure bAddClick(Sender: TObject);
    procedure bdelRDClick(Sender: TObject);
    procedure cbTimetablesChange(Sender: TObject);
  private
    exportfile: TStringlist;
    TrainInterval: integer;
  public
      ProjectToExport: TRBProject;
      ExportModule: TRBExport_Mod;
      CreditsFile: TStringlist;
      procedure CopyFiles();
      procedure UpdateStationlist(Sender: TObject);
      procedure PaintConnectionsIntoMap(connlist: TRBConnectionlist);
   end;
var
  FormExport: TFormExport;

implementation

uses toptions, uStationsForm;

{$R *.dfm}

procedure TFormExport.FormShow(Sender: TObject);
var i: integer;
    St: TRBStation;
begin
 ProjectToExport.GetRouteDefinitionsAsNames(export_set_Routes.Items);  //Ladet Routen
 TrainInterval := 600;
 cbTimetables.Items.Clear;
 for i:=0 to ProjectToExport.Timetables.Count-1 do
 begin
   cbTimetables.Items.Add((ProjectToExport.Timetables[i] as TRbSchedule).ScheduleName);
 end;
 cbTimetables.Items.Add('-');
 cbTimetables.itemindex := cbTimetables.Items.count-1;

  export_set_Routes.ItemIndex := 0;

//  export_set_RoutesChange(self);
{  for i:=0 to ProjectToExport.GetStationCount-1 do
  begin
    St := ProjectToExport.GetStationByIndex(i);
    cbStartStation.Items.Add(St.StationName);
    cbNextStation.Items.Add(St.StationName);
  end;}
  cbStartStation.ItemIndex := 0;
  cbNextStation.ItemIndex := 0;
  cbStartStationChange(self);

  Pagecontrol1.ActivePageIndex := 0;
  export_set_Trains.Items:=FormTrain.TrainList.Items;   //Ladet von der Liste der FST in FormTrain
  export_set_Trains.itemindex := export_set_Trains.items.indexof(FormOptions.DefaultTrain);
  leSubdir.text := ProjectToExport.Routefilessubdir;
  ExportStatusText.caption := '';
  ExportStatusProgress.Position := 0;
end;

procedure TFormExport.ExportBtnClick(Sender: TObject);
var destfilename,objpath: string;
    i: integer;
    TimeSeparatorBkp: char;
begin
  if leRoutefilename.Text='' then begin
   //Checkt ob Projektstreckendatei vergeben wurde, wenn nich dann
   MessageDlg(lngmsg.GetMsg('texport_no_filename'),mtWarning,[mbOK], 0);
   Exit;
  end;

  if leSubdir.Text='' then begin
   //Checkt ob Streckendatei-Ordner vergeben wurde, wenn nicht dann
   MessageDlg(lngmsg.GetMsg('texport_no_dir'),mtWarning,[mbOK], 0);
   Exit;
  end;



  Pagecontrol1.ActivePageIndex := 1;

  ExportStatusText.Caption:='Initializing...';  //Caption für Status
  ExportModule := TRBExport_Mod.Create(true);
  ExportModule.DrawConnections := PaintConnectionsIntoMap;
  ExportModule.filelist := lbFilelist.items;
  ExportModule.Exportfile := Exportfile;
  ExportModule.GetFromProject := ProjectToExport;
  ExportModule.basepath := extractfilepath(application.ExeName);
  ExportModule.Statuslines := MemoStatus.Lines;
  ExportModule.PassStations.Clear;
  ExportModule.ExportSchedule := nil;
  ExportModule.Night := cbNight.checked;
  ExportModule.TrainInterval := TrainInterval;
  ExportModule.BVE4 := cbBVE4.checked;
  ExportModule.Train := ProjectToExport.GetTrainByName(export_set_trains.text);
  if (cbTimetables.itemindex>=0)and(cbTimetables.text<>'-') then
    ExportModule.ExportSchedule := ProjectToExport.Timetables[cbTimetables.itemindex] as TRbSchedule;
  for i:=0 to lbStops.Items.count-1 do
  begin
    if not lbStops.Checked[i] then
      ExportModule.PassStations.add(lbStops.Items[i]);
  end;

  for i:=0 to ProjectToExport.Stations.count-1 do
  begin
    if (ProjectToExport.Stations[i] as TRBStation).StationName = cbStartStation.Text then
       ExportModule.StartStation := ProjectToExport.stations[i] as TRBStation;
    if (ProjectToExport.Stations[i] as TRBStation).StationName = cbNextStation.Text then
       ExportModule.NextStation := ProjectToExport.stations[i] as TRBStation;
  end;
  //ExportModule.StartStation := ProjectToExport.stations[cbStartStation.itemindex] as TRBStation;
  //ExportModule.NextStation := ProjectToExport.stations[cbNextStation.itemindex] as TRBStation;
  TimeSeparatorBkp := TimeSeparator;
  TimeSeparator := ':';
  try
  ExportModule.departureTime := strtotime(leDepartureTime.text);
  except
  ExportModule.departureTime := strtotime('09:00');
  end;
  ExportModule.Timetable := cbTimetables.text;
  TimeSeparator := TimeSeparatorBkp;

  // if RD list is empty, add current
  {
  if lbRD.items.count=0 then
  begin
    lbRD.AddItem(export_set_Routes.Text,ProjectToExport.FindRouteDefinitionByID(export_set_Routes.itemindex));
  end;
   }   //kann eigentlich nicht vorkommen



  MemoStatus.Lines.clear;

{  if Proj_RouteFileDir.ItemIndex=0 then
    destfilename := FormOptions.BVE_Folder+'\'+Proj_RouteFiledir.Text+'\'+Proj_RouteFile.Text+'.csv';
  if Proj_RouteFileDir.ItemIndex=1 then}
  destfilename := FormOptions.BVE_Folder+'\railway\route\'+lesubdir.Text+'\'+leRoutefilename.Text+'.csv';

  objpath := FormOptions.BVE_Folder+'\railway\object\'+lesubdir.Text+'\';

  Creditsfile.clear;
  CreditsFile.Add('credits -- freeobject artists');
  CreditsFile.Add('used with kind permission/free-to-use-donations/');
  CreditsFile.Add('by routebuilder object base library agreement');
  CreditsFile.Add('-------------------------------------------------------------');

  Screen.Cursor := crHourGlass;

  // Starte Export
  ExportModule.ExportToCsv(export_set_trains.text, lesubdir.Text, lbRD.Items );

  Screen.Cursor := crDefault;

  if not ExportModule.dest_reached then
    MessageDlg( lngmsg.GetMsg('texport_incomplete'), mtWarning, [mbOK], 0);
    

  CreditsFile.AddStrings(ExportModule.Credits);
  CreditsFile.Add('');
  CreditsFile.Add('Additional credits:');
  CreditsFile.Add(ProjectToExport.Credits);

  ExportModule.free;

  lCopy.Visible := false;
  ProgressBarCopy.Visible := false;

  MemoStatus1.Lines.Text := MemoStatus.Lines.Text;

  Pagecontrol1.ActivePageIndex := 2;
end;


function TFormExport.StartDevelopermode;
var exename: string;
begin
    if cbBVE4.checked then
       exename := 'bvedotnet.exe'
    else
       exename := 'bve.exe';
    ShellExecute(Application.Handle,'open',
       PChar(FormOptions.BVE_Folder+'\'+exename),
       PChar('"'+FormOptions.BVE_Folder+'\railway\route\'+leSubdir.text+'\'+leRoutefilename.Text+'.csv"'+' /d='+IntToStr(ProjectToExport.DeveloperID)),
       PChar(FormOptions.BVE_Folder+'\railway\route\'+leSubdir.Text+'\'+leRoutefilename.Text),SW_SHOW);
end;



procedure TFormExport.bCloseClick(Sender: TObject);
begin
  if cbCopyfiles.checked then CopyFiles();
  if cbRunBVE.checked then StartDevelopermode();
  if cbRunPackageWizard.checked then
  begin
    // Dateiliste zusammenstellen
    // Objectfilelist relativ zu path\objects
    FormPackage.Objectfilelist.AddStrings(  lbFilelist.Items );
    // Routefilelist relativ zu path\route
    FormPackage.RouteFileList.Add(FormExport.leRoutefilename.Text+'.csv');
    FormPackage.RouteFileList.Add(FormExport.leRoutefilename.Text+'_credits.txt');

    FormPackage.RouteSubDir :=  leSubdir.text;

    FormPackage.Show();
    FormPackage.CreatePackage(//leRoutefilename.text,
     ProjectToExport.Projectname,
     ProjectToExport.LogoPath,ProjectToExport.Author,
     ProjectToExport.HomepageURL,ProjectToExport.Description,
     ExtractFilePath(Application.ExeName),ProjectToExport.Credits,0,0);
  end;
  close();
end;

procedure TFormExport.CopyFiles();
var routepath,objpath,basepath: string;
    i: integer;
begin
  lCopy.Visible := true;
  ProgressBarCopy.Visible := true;

  //Exportfile to ...
  routepath := FormOptions.BVE_Folder+'\railway\route\'+ leSubdir.text+'\';
  objpath   := FormOptions.BVE_Folder+'\railway\object\'+ leSubdir.text+'\';
  basepath  := extractfilepath(application.exename);

  // sicherstellen, dass Verzeichnisse existieren, falls nötig, erstellen (up)
  ForceDirectories(routepath);
  ForceDirectories(objpath);

  // speichere Strecke
  ExportFile.SaveToFile(routepath+'\'+FormExport.leRoutefilename.Text+'.csv');

  // speichere credits
  CreditsFile.SaveToFile(routepath+'\'+FormExport.leRoutefilename.Text+'_credits.txt');

  // kopiere Objekte
  for i:=0 to lbFilelist.Items.count-1 do
  begin
    progressbarcopy.Position := (100*i) div lbFilelist.Items.count;
    Application.ProcessMessages();
    Forcedirectories(extractfilepath(objpath + lbFilelist.Items[i]));
    // src, dest
    CopyFile(pchar(basepath + '\'+formoptions.ObjectFolder+'\'+ lbFilelist.Items[i])
            ,pchar(objpath + lbFilelist.Items[i]),false);
  end;

end;

procedure TFormExport.FormCreate(Sender: TObject);
begin
  exportfile := TStringlist.create();
  CreditsFile := TStringlist.Create();
end;

procedure TFormExport.FormDestroy(Sender: TObject);
begin
  exportfile.free;
  Creditsfile.free;
end;

procedure TFormExport.cbStartStationChange(Sender: TObject);
begin
  while ((cbStartStation.ItemIndex = cbNextStation.ItemIndex)or(cbNextStation.ItemIndex=-1))
    and(cbNextStation.Items.count>1) do
  begin
    if cbNextStation.ItemIndex=cbNextStation.Items.Count-1 then
      cbNextStation.ItemIndex := 0
    else
      cbNextStation.ItemIndex := cbNextStation.ItemIndex+1;
  end;
end;

procedure TFormExport.cbNextStationChange(Sender: TObject);
begin
  while ((cbStartStation.ItemIndex = cbNextStation.ItemIndex)or(cbStartStation.ItemIndex=-1))
    and(cbstartStation.Items.count>1) do
  begin
    if cbStartStation.ItemIndex=cbStartStation.Items.Count-1 then
      cbStartStation.ItemIndex := 0
    else
      cbStartStation.ItemIndex := cbStartStation.ItemIndex+1;
  end;
end;

procedure TFormExport.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  if Msg.CharCode=27 then
  begin
    handled := true;
    Close;
  end;
end;

procedure TFormExport.PaintConnectionsIntoMap(connlist: TRBConnectionlist);
var Minimap: TRBMinimap;
    x,y: Integer;
    farpoint: TDoublePoint;
    fak: double;
begin
  // Minimap
  Minimap := TRBMinimap.Create;
  Minimap.ShowPoints := false; // TODO: eventuell zuschaltbar
  Minimap.CurrentProject := ProjectToExport;
  x := Paintbox1.Width;
  y := Paintbox1.Height;

{  fak := ProjectToExport.BackgroundMapScale/100;
  farpoint.x := x*fak;
  farpoint.y := y*fak;
 }
  Minimap.CalculateBoundingRect(ProjectToExport.Connections);
{  Minimap.boundingRect.Bottom:= 0;
  Minimap.boundingRect.Left  := 0;
  Minimap.boundingRect.Top   := round(farpoint.y);
  Minimap.boundingRect.right := round(farpoint.x);
 }
  Minimap.MiniRect := Paintbox1.Canvas.ClipRect;
{  Minimap.MiniRect.Left := Paintbox1.Left;
  Minimap.MiniRect.top := Paintbox1.top;
  Minimap.MiniRect.Right := Paintbox1.Width-1;
  Minimap.MiniRect.bottom := Paintbox1.height-1;}
  if Minimap.MiniRect.Right<>Minimap.MiniRect.left then
    Minimap.DrawMap(Paintbox1.Canvas,connlist,nil);
  Minimap.Free;
end;


procedure TFormExport.cbRunPackageWizardClick(Sender: TObject);
begin
  if cbRunPackageWizard.Checked then cbCopyfiles.checked := true;
  cbCopyfiles.Enabled := not cbRunPackageWizard.Checked;
end;

procedure TFormExport.bAddClick(Sender: TObject);
begin
  lbRD.AddItem(export_set_Routes.Text,
    export_set_Routes.Items.Objects[export_set_Routes.Itemindex]);
  UpdateStationlist(sender);
end;

procedure TFormExport.bdelRDClick(Sender: TObject);
begin
  if lbRD.ItemIndex>=0 then
  begin
    lbRD.DeleteSelected;
    UpdateStationList(sender);
  end;
end;

procedure TFormExport.UpdateStationlist(Sender: TObject);
var i: integer;
begin
  cbStartStation.Items.clear;
  cbNextStation.Items.clear;
  ProjectToExport.GetStationListForRouteDefinitions(lbRD.items,cbStartStation.items);
  ProjectToExport.GetStationListForRouteDefinitions(lbRD.items,cbNextStation.items);
  ProjectToExport.GetStationListForRouteDefinitions(lbRD.items,lbStops.items);
  for i:=0 to lbStops.items.count-1 do
    lbStops.Checked[i] := true;
end;

procedure TFormExport.cbTimetablesChange(Sender: TObject);
var schedule: TRBSchedule;
    i,j: integer;
begin
  // settings vom Fahrplan übernehmen
  // Train, Start Station, End Station, Stops, Durations, Departure
  i := cbTimetables.ItemIndex;
  if (i<0) then exit;
  if (cbTimetables.Items[i]='-') then
  begin
    // zurücksetzen?
  end
  else
  begin
    schedule := ProjectToExport.Timetables[i] as TRbSchedule;
    // Filename
    leRoutefilename.text := schedule.ScheduleName;
    // Train interval
    TrainInterval := schedule.DistFromPretrain;
    // RD
    lbRD.items.clear();
    lbRD.items.assign(schedule.RouteDefinitions);
    // RD-objects anklinken
    for j:=0 to lbRD.items.count-1 do
    begin
      lbRD.items.objects[j] := ProjectToExport.FindRouteDefinitionByName(lbRD.items[j]);
    end;
    UpdateStationlist(sender);
    // Train
    export_set_Trains.ItemIndex := export_set_Trains.Items.IndexOf(schedule.Train);
    // Stations
    cbStartStation.ItemIndex := cbStartStation.Items.IndexOf(schedule.StartStation);
    cbNextStation.ItemIndex := cbStartStation.Items.IndexOf(schedule.EndStation);
    leDepartureTime.Text := FormatDateTime('hh:mm',schedule.StartTime);
    for j:=0 to lbStops.items.count-1 do
      lbStops.Checked[j] := false;
    for j:=0 to schedule.Stops.count-1 do
    begin
      i := lbStops.Items.IndexOf(schedule.Stops[j]);
      if i>=0 then lbStops.Checked[i] := true;
    end;
  end;
end;

end.




