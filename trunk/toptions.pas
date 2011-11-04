unit toptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, TabNotBk, StdCtrls, ExtCtrls, Inifiles, ShellApi, registry,
  uGlobalDef, utools, uRBObject,uRBConnection, uRBPoint;

type
  TFormOptions = class(TForm)
    Panel1: TPanel;
    Btn_Cancel: TButton;
    Btn_OK: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    StructureViewer_Check: TCheckBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    CheckBoxCopyTrackPropLast: TCheckBox;
    CheckBoxCopyTrackPropClip: TCheckBox;
    LabelBveDir: TLabel;
    BveFolderSearchButton: TButton;
    cbFit4m: TCheckBox;
    AutoUpdate_Check: TCheckBox;
    Label2: TLabel;
    edDistanceBeyondLast: TEdit;
    Label3: TLabel;
    edArrowStepSize: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edMaxCurveSmooth: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edDefLanguage: TEdit;
    Label8: TLabel;
    edObjFolder: TEdit;
    Label9: TLabel;
    edShortestCurve: TEdit;
    Label10: TLabel;
    cbCurvedSecondary: TCheckBox;
    bBrowseLanguageFile: TButton;
    OpenDialog1: TOpenDialog;
    cbNewConnFixed: TCheckBox;
    BVE_Folder_Set: TEdit;
    lDefTrain: TLabel;
    cbTrains: TComboBox;
    cbExportPrimaryTrains: TCheckBox;
    cbCatenaryPoles50: TCheckBox;
    Label11: TLabel;
    edCurvebanking: TEdit;
    cbTSOFrames: TCheckBox;
    cbAllowMultipleConnGrid: TCheckBox;
    cbElliptical: TCheckBox;
    cbShowSignalNames: TCheckBox;
    cbGroundless: TCheckBox;
    bDefaultTrack: TButton;
    procedure BveFolderSearchButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DeveloperMod_CheckClick(Sender: TObject);
    procedure StructureViewer_CheckClick(Sender: TObject);
    procedure AutoUpdate_CheckClick(Sender: TObject);
    procedure Btn_OKClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckBoxCopyTrackPropLastClick(Sender: TObject);
    procedure CheckBoxCopyTrackPropClipClick(Sender: TObject);
    procedure edArrowStepSizeChange(Sender: TObject);
    procedure bBrowseLanguageFileClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure bDefaultTrackClick(Sender: TObject);
  private
    { Private-Deklarationen }
    dummypoint: TRBPoint;
  public
    BVE_Folder,AktVZ: string;
    UseDeveloperMod: Boolean;
    UseStructureViewer: Boolean;
    CurvedSecondary,
    UseAutoUpdateEvery: Boolean;
    ArrowStepSize: double;
    DistanceBeyondLast,
    MaxCurveSmooth,
    MinCurve,
    AutoUpdateNow: Integer;
    UseFit4m: boolean;
    UseMinLength: boolean;
    NewConnFixed: boolean;
    ShowConfigBveFolder: Boolean;
    iniset: TInifile;
    DefaultTrain: string;
    DefaultTrack: TRBConnection;
    function GetObjectFolder: string;
    procedure SetObjectFolder(const f: string);
    property Objectfolder: string read GetObjectfolder write SetObjectFolder;
    function ExportTrainsOnPrimaryTracks: boolean;
    function CatenaryPolesEvery50m: boolean;
    function UseEllipcitalCurves: boolean;
    function GetCurveBankingFactor: double;
    function GetMinZoomSolid: integer;
    function CopyTrackPropLast: boolean;
    function CopyTrackPropClip: boolean;
    function GetTSOAsFrames: boolean;
    function MultipleTracksInGrid: boolean;
    function GetShowSignalNames: boolean;
    function GetGroundlessBuilding: boolean;
  end;

var
  FormOptions: TFormOptions;
  iniSet: TIniFile;
  DefaultLanguage: string;

implementation

uses tBveFolder, uTrackProperties;

{$R *.dfm}

procedure TFormOptions.BveFolderSearchButtonClick(Sender: TObject);
begin
// Form dynamisch erzeugen (gibt sich selbst wieder frei)
with TFormSetBveFolder.Create(self) do
begin
  inifile := iniset;
  ShowModal();
end;
end;

procedure TFormOptions.FormCreate(Sender: TObject);
var
 Language,dtrack: string;
 LanguageDatabase: Textfile;
 RouteRegistry: TRegistry;
begin
  DefaultTrack := TRBConnection.Create();
  dummypoint := TRBPoint.create();
  DefaultTrack.P1 := dummypoint;
  DefaultTrack.P2 := dummypoint;
  // ermittle Optionen
  AktVz := ExtractFilePath(Application.ExeName);
  iniSet:= TIniFile.Create(AktVZ+'set.ini');  //Verbinden mit Ini
  BVE_Folder:=iniSet.ReadString('Settings','BVE_Folder','');
  if BVE_Folder='' then
  begin
     // hole aus Registry (Route Installer)
     RouteRegistry:=TRegistry.Create;
     RouteRegistry.RootKey:=HKEY_LOCAL_MACHINE;
     RouteRegistry.OpenKey('Software\Routebuilder',true);
     if RouteRegistry.ReadString('Bve Folder')<>'' then
       BVE_Folder:=RouteRegistry.ReadString('Bve Folder')
     else
     begin
       BveFolderSearchButtonClick(self);
       BVE_Folder := BVE_Folder_Set.text;
       RouteRegistry.WriteString('Bve Folder',BVE_Folder);
     end;
     iniSet.WriteString('Settings','BVE_Folder',BVE_Folder);
     RouteRegistry.Free;
  end;
   if iniSet.ReadString('Settings','ShowConfigBveFolder','')='True' then
   begin
     with TFormSetBveFolder.Create(self) do ShowModal();
   end;
  edObjFolder.text := iniSet.ReadString('Settings','ObjectFolder','lib');
  DefaultTrain := iniSet.ReadString('Settings','DefaultTrain','');
  UseDeveloperMod:=iniSet.ReadBool('Settings','UseDeveloperMod',True);
  UseStructureViewer:=iniSet.ReadBool('Settings','UseStructureViewer',True);
  // Standardverhalten wird definiert durch checked-Status im Form
  CheckBoxCopyTrackPropLast.checked :=iniSet.ReadBool('TrackAdding','CopyPropLast',CheckBoxCopyTrackPropLast.checked);
  CheckBoxCopyTrackPropClip.checked :=iniSet.ReadBool('TrackAdding','CopyPropClip',CheckBoxCopyTrackPropClip.checked);


  if iniSet.ReadBool('Settings','UseAutoUpdateEvery',false)=True then // Wenn Option "Use AutoUpdate" ausgewählt dann
  begin
    // Automatisches Auto-Update Prozedere
    UseAutoUpdateEvery:=True;  //Wert auf "True"
    AutoUpdateNow:=iniSet.ReadInteger('Settings','AutoUpdateNow',0); //Ermittelt Wert aus Ini (Start=0,Ende=10)
    iniSet.WriteInteger('Settings','AutoUpdateNow',AutoUpdateNow+1); //Addiert "1" zu vorher ermittelten Wert "AutoUpdateNow"
    if AutoUpdateNow=10 then  //Wenn Wert ist 10 dann
    begin
      ShellExecute(Application.Handle,'open',PChar(AktVZ+'\autoupdate.exe'),nil,PChar(AktVZ+'\autoupdate.exe'),sw_ShowNormal); //AutoUpdate starten
      iniSet.WriteInteger('Settings','AutoUpdateNow',0);  //Wert auf null setzen, von vorne beginnen
    end;
  end;


  BVE_Folder_Set.text:= BVE_Folder;

  // Editor-Tab (uwe)
  cbFit4m.Checked := iniset.ReadBool('editor','fit4m',true);
  cbTSOFrames.checked := iniset.ReadBool('editor','tsoframes',false);
  dtrack := iniset.ReadString('editor','defaultrack','0,0,0,11,70,0.0000000000,255,1,"bluesky2.bmp","empty.b3d",1000,"",0,"",0,"",0,0,"","","","grass6",0,"grass6",0,""');
  if dtrack<>'' then
  begin
    DefaultTrack.free;
    DefaultTrack := TRBConnection.CreateFromString(dtrack,nil);
    DefaultTrack.P1 := dummypoint;
    DefaultTrack.P2 := dummypoint;
  end;

//  cbMinimumlength.checked := iniset.ReadBool('editor','minlength',true);
  cbNewConnFixed.checked := iniset.ReadBool('editor','newconnfixed',true);
  cbElliptical.checked := iniset.ReadBool('editor','ellipticalcurves',true);
  cbShowSignalNames.Checked := iniset.ReadBool('editor','showsignalnames',true);
  NewConnFixed := cbNewConnFixed.checked;
  UseFit4m := cbFit4m.Checked;
//  UseMinLength := cbMinimumlength.checked;
  ArrowStepSize := strtofloat1(iniset.Readstring('editor','ArrowStepSize','0.1'));
  edArrowStepSize.Text := inttostr(round(ArrowStepSize*100));

  // Export-Tab (uwe)
  edDistanceBeyondLast.text := inttostr(iniset.ReadInteger('export','distancebeyondlast',100));
  edMaxCurveSmooth.text := inttostr(iniset.ReadInteger('export','maxcurvesmooth',4000));
  edShortestCurve.text := inttostr(iniset.ReadInteger('export','mincurvesmooth',150));
  cbCurvedSecondary.Checked := iniset.ReadBool('export','CurvedSecondary',false);
  cbCatenaryPoles50.checked := iniset.ReadBool('export','Catenary50m',false);
  edCurvebanking.Text := iniset.ReadString('export','CurveBankingFactor','1.37');
  cbAllowMultipleConnGrid.checked := iniset.ReadBool('export','AllowMultipleConnGrid',true);
  cbGroundless.Checked := iniset.ReadBool('export','GroundlessBuilding',false);

  DistanceBeyondLast := strtointdef( edDistanceBeyondLast.text,100 );
  MaxCurveSmooth     := strtointdef(edMaxCurveSmooth.text,4000);
  MinCurve           := strtointdef(edShortestCurve.text,150);

  CurvedSecondary    :=   cbCurvedSecondary.Checked;

  DefaultLanguage:=iniSet.ReadString('Settings','DefaultLanguage','english.lng');
  edDefLanguage.text := DefaultLanguage;
end;

procedure TFormOptions.FormShow(Sender: TObject);
var
F: TSearchRec;
begin
  //Ermittelt Standart/gerade verwendete Sprache
//Setzt Werte der Optionen-Variablen
// Developermod_Check.Checked:=UseDeveloperMod;
 StructureViewer_Check.Checked:=UseStructureViewer;
 AutoUpdate_Check.Checked:=UseAutoUpdateEvery;
 CheckBoxCopyTrackPropLast.checked := CopyTrackPropLast;
 CheckBoxCopyTrackPropClip.Checked := CopyTrackPropClip;

 if Findfirst(BVE_Folder+'\Train\*.*',faDirectory,F)= 0 then
 begin
  repeat
   begin
   if (F.Attr=faDirectory) and (F.Name<>'.') and (F.Name<>'..') then
     cbTrains.Items.Add(F.Name);
   end;
  until FindNext(F)<>0;
  FindClose(F);
 end;

 if cbTrains.items.indexof(DefaultTrain)>=0 then
 begin
   cbTrains.ItemIndex := cbTrains.items.indexof(DefaultTrain);
 end;

// SetLanguage.Text:=DefaultLanguage;  //Gerade verwendete Sprache in Box markieren
end;

procedure TFormOptions.DeveloperMod_CheckClick(Sender: TObject);
begin
 {if DeveloperMod_Check.Checked then begin
  UseDeveloperMod:=True;
 end
 else begin
  UseDeveloperMod:=False;
  iniSet.WriteBool('Settings','UseDevelopermod',False);
 end;  }
end;

procedure TFormOptions.StructureViewer_CheckClick(Sender: TObject);
begin
 if StructureViewer_Check.Checked then
 begin
  if fileexists(BVE_Folder+'\' + StructureViewerName) then
  begin
   UseStructureViewer:=True;
  end
 else begin
  // folgende Message wegen Multilanguage auslagern. (up)
  MessageDlg(lngmsg.GetMsg('toptions_no_sv'),mtInformation,[mbOK],0);
  StructureViewer_Check.Checked:=False;
  UseStructureViewer:=False;
  iniSet.WriteBool('Settings','UseStructureViewer',False);
 end;
end;
end;

procedure TFormOptions.AutoUpdate_CheckClick(Sender: TObject);
begin
 if AutoUpdate_Check.Checked then begin
  UseAutoUpdateEvery:=True;
 end
 else begin
  UseAutoUpdateEvery:=False;
  iniSet.WriteBool('Settings','UseAutoUpdateEvery',False);
 end;
end;

procedure TFormOptions.Btn_OKClick(Sender: TObject);
begin
 // Übernehmen der Optionen
 iniSet.WriteString('Settings','DefaultLanguage',edDefLanguage.text);
 iniset.WriteString('Settings','ObjectFolder',edObjFolder.text);

 iniset.WriteString('Settings','DefaultTrain',cbTrains.text);

 iniSet.WriteBool('Settings','UseStructureViewer',UseStructureViewer);
 iniSet.WriteBool('Settings','UseDevelopermod',UseDeveloperMod);
 iniSet.WriteBool('Settings','UseAutoUpdateEvery',UseAutoUpdateEvery);
 iniSet.WriteBool('TrackAdding','CopyPropLast',CheckBoxCopyTrackPropLast.checked);
 iniSet.WriteBool('TrackAdding','CopyPropClip',CheckBoxCopyTrackPropClip.Checked);
// iniSet.WriteString('Settings','DefaultLanguage',SetLanguage.Text);

 iniset.WriteBool('editor','fit4m',cbFit4m.checked );
// iniset.WriteBool('editor','minlength',cbMinimumlength.Checked);
 iniset.Writestring('editor','ArrowStepSize',floattostrPoint(ArrowStepSize));
 iniset.WriteBool('editor','newconnfixed',cbNewConnFixed.checked);
 iniset.WriteBool('editor','ellipticalcurves',cbElliptical.checked);
 iniset.WriteBool('editor','tsoframes',cbTSOFrames.checked);
 iniset.WriteBool('editor','showsignalnames',cbShowSignalNames.Checked);
 iniset.WriteString('editor','defaulttrack',DefaultTrack.GetAsString);

 iniset.WriteInteger('export','distancebeyondlast',strtointdef(edDistanceBeyondLast.text,100));
 iniset.WriteInteger('export','maxcurvesmooth',strtointdef(edMaxCurveSmooth.text,4000));
 iniset.WriteInteger('export','mincurvesmooth',strtointdef(edShortestCurve.text,150));
 iniset.WriteBool('export','CurvedSecondary',cbCurvedSecondary.Checked);
 iniset.WriteBool('export','ExportPrimaryTrains',cbExportPrimaryTrains.Checked);
 iniset.WriteBool('export','Catenary50m',cbCatenaryPoles50.Checked);
 iniset.WriteString('export','CurveBankingFactor',edCurvebanking.text);
 iniset.WriteBool('export','AllowMultipleConnGrid',cbAllowMultipleConnGrid.checked);
 iniset.WriteBool('export','GroundlessBuilding',cbGroundless.checked);

 DistanceBeyondLast := strtointdef( edDistanceBeyondLast.text,100 );
 MaxCurveSmooth     := strtointdef(edMaxCurveSmooth.text,4000);
 MinCurve           := strtointdef(edShortestCurve.text,150);
 CurvedSecondary    := cbCurvedSecondary.Checked;
 NewConnFixed       := cbNewConnFixed.checked;
 DefaultTrain       := cbTrains.Text;

 UseFit4m := cbFit4m.Checked;
 // disabled!
 UseMinLength := false; //cbMinimumlength.checked;

 Close;
end;

procedure TFormOptions.Btn_CancelClick(Sender: TObject);
begin
Close;
end;

procedure TFormOptions.FormDestroy(Sender: TObject);
begin
  iniSet.Free;
  dummypoint.free;
  DefaultTrack.free;
end;

procedure TFormOptions.CheckBoxCopyTrackPropLastClick(Sender: TObject);
begin
  if CheckBoxCopyTrackPropLast.checked then CheckBoxCopyTrackPropClip.Checked := false;
end;

procedure TFormOptions.CheckBoxCopyTrackPropClipClick(Sender: TObject);
begin
  if CheckBoxCopyTrackPropClip.checked then CheckBoxCopyTrackPropLast.Checked := false;
end;

procedure TFormOptions.edArrowStepSizeChange(Sender: TObject);
begin
  ArrowStepSize := strtointdef(edArrowStepSize.text,0)/100;
end;

function TFormOptions.GetObjectFolder:string;
begin
  result := edObjFolder.text;
end;
procedure TFormOptions.bBrowseLanguageFileClick(Sender: TObject);
begin
  opendialog1.FileName := edDefLanguage.Text;
  opendialog1.InitialDir := extractfilepath(Application.ExeName);
  if opendialog1.Execute then
  begin
    edDefLanguage.text := extractfilename(opendialog1.FileName);
  end;
end;

procedure TFormOptions.SetObjectFolder(const f: string);
begin
  edObjFolder.text := f;
  iniset.WriteString('Settings','ObjectFolder',edObjFolder.text);
  ObjectBasePath := extractfilepath(application.exename) + f+'\';
end;

function TFormOptions.ExportTrainsOnPrimaryTracks: boolean;
begin
  result := cbExportPrimaryTrains.checked;
end;

function TFormOptions.CatenaryPolesEvery50m: boolean;
begin
  result := cbCatenaryPoles50.checked;
end;

function TFormOptions.UseEllipcitalCurves:boolean;
begin
  result := cbElliptical.Checked;
  //result := true;
end;

function TFormOptions.GetCurveBankingFactor: double;
begin
  result := strtofloat1(edCurvebanking.text);
end;

function TFormOptions.GetTSOAsFrames: boolean;
begin
  result := cbTSOFrames.checked;
end;

function TFormOptions.CopyTrackPropLast: boolean;
begin
  result := CheckBoxCopyTrackPropLast.Checked;
end;

function TFormOptions.CopyTrackPropClip: boolean;
begin
  result := CheckBoxCopyTrackPropClip.Checked;
end;

function TFormOptions.MultipleTracksInGrid:boolean;
begin
  result := cbAllowMultipleConnGrid.checked;
end;

procedure TFormOptions.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  if msg.CharCode=27 then close;
end;

function TFormOptions.GetShowSignalNames:boolean;
begin
  result := cbShowSignalNames.checked;
end;

function TFormOptions.GetGroundlessBuilding:boolean;
begin
  result := cbGroundless.Checked;
end;

procedure TFormOptions.bDefaultTrackClick(Sender: TObject);
var trackform2: TFormTrackProperties;
begin
  trackform2 := TFormTrackProperties.Create(self);
  trackform2.caption := 'Default Track Properties';
  trackform2.PageControl1.Pages[4].free;
  trackform2.PageControl1.Pages[3].free;
  trackform2.CurrentProject := nil;
  trackform2.Track := DefaultTrack;
  trackform2.bCancel.show;
  trackform2.ShowModal();
end;

function TFormOptions.GetMinZoomSolid: integer;
begin
  result := 4;
end;
end.
