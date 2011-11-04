unit uProjectProperties;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  uRBProject, StdCtrls, ExtCtrls, ComCtrls, ExtDlgs, utools,
  uRBTrackDefinition,
  uSelectObjectForm;

type
  TFormProjectProperties = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    leProjectname: TLabeledEdit;
    leAuthor: TLabeledEdit;
    leEmail: TLabeledEdit;
    leHomepage: TLabeledEdit;
    TabSheet2: TTabSheet;
    leGauge: TLabeledEdit;
    TabSheet3: TTabSheet;
    memoDescription: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    memoCredits: TMemo;
    Label3: TLabel;
    Image1: TImage;
    Button3: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    lScreenshot: TLabel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    edDOStopsign: TEdit;
    bDOSelectStopsign: TButton;
    leSubDir: TLabeledEdit;
    lParallelDist: TLabel;
    edParallelDist: TEdit;
    Label6m: TLabel;
    lParallelDist2: TLabel;
    edParallelDist2: TEdit;
    Label8m: TLabel;
    l1000mStationmarkerstop: TLabel;
    edStationmarkerStop: TEdit;
    l1000mStationmarkerpass: TLabel;
    edStationmarkerPass: TEdit;
    b1000mStationmarkerstop: TButton;
    b1000mStationmarkerpass: TButton;
    TabSheetMap: TTabSheet;
    LabelMap5: TLabel;
    EdMapResolution: TEdit;
    LabelMap6: TLabel;
    LabelMap7: TLabel;
    edMapFilename: TEdit;
    bBrowseMap: TButton;
    OpenPictureDialog2: TOpenPictureDialog;
    lSignalPost: TLabel;
    edSignalPost: TEdit;
    bSignalpostselect: TButton;
    lvmaxslow: TLabel;
    edVmaxSlowSignal: TEdit;
    lkmh: TLabel;
    lSignalBack: TLabel;
    edSignalBack: TEdit;
    bSignalbackSelect: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure bDOSelectStopsignClick(Sender: TObject);
    procedure b1000mStationmarkerstopClick(Sender: TObject);
    procedure b1000mStationmarkerpassClick(Sender: TObject);
    procedure bBrowseMapClick(Sender: TObject);
    procedure bSignalpostselectClick(Sender: TObject);
    procedure bSignalbackSelectClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
  private
    { Private declarations }
    FProject: TRBProject;
    activeItem: TListItem;
  public
    { Public declarations }
    procedure DoIt(const project: TRBProject);
  end;

var
  FormProjectProperties: TFormProjectProperties;

implementation



{$R *.dfm}

procedure TFormProjectProperties.FormCreate(Sender: TObject);
begin
//
//  lvTracktypes.items.clear;
//  lvCurveTracks.items.clear;
end;

procedure TFormProjectProperties.DoIt(const project: TRBProject);
var i: integer;
    TD: TRBTrackDefinition;
begin
  FProject := project;
  leProjectname.text := Fproject.Projectname;
  leAuthor.text := Fproject.Author;
  leEmail.text := Fproject.AuthorEmailAddress;
  leHomepage.text := Fproject.HomepageURL;
  memoDescription.Lines.text := Fproject.Description;
  memocredits.lines.text := Fproject.Credits;
  leSubDir.text := FProject.Routefilessubdir;

  leGauge.Text := inttostr(Fproject.Gauge);
  edVmaxSlowSignal.text := inttostr(FProject.VmaxSlowSignal);
  edDOStopsign.text := Fproject.DefaultObjects.values['stopsign'];
  edSignalPost.text := Fproject.DefaultObjects.values['signalpost'];
  edSignalBack.text := Fproject.DefaultObjects.values['signalback'];
  edStationmarkerStop.text := Fproject.DefaultObjects.values['stationmarkerstop'];
  edStationmarkerPass.text := Fproject.DefaultObjects.values['stationmarkerpass'];
  edParallelDist.Text := floattostrPoint( project.ParallelTrackDist);
  edParallelDist2.Text := floattostrPoint( project.ParallelTrackDistPlatf);

  Image1.hint := fproject.LogoPath;
  if fileexists(Image1.hint) then
    Image1.picture.LoadFromFile(Image1.hint);

  EdMapResolution.Text := inttostr(FProject.BackgroundMapScale);
  edMapFilename.text   := FProject.BackgroundMapfilename;

  Pagecontrol1.ActivePageIndex := 0;

  ShowModal();
end;

procedure TFormProjectProperties.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key=#27 then close;
end;

procedure TFormProjectProperties.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFormProjectProperties.Button1Click(Sender: TObject);
begin
  // Änderungen übernehmen in Fproject
  Fproject.Projectname := leProjectname.text;
  Fproject.Author := leAuthor.text;
  Fproject.AuthorEmailAddress := leEmail.text;
  Fproject.HomepageURL := leHomepage.text;
  Fproject.description :=  memoDescription.lines.text;
  Fproject.Credits := memoCredits.lines.text;
  FProject.gauge := StrToIntDef(leGauge.text,1435);
  Fproject.VmaxSlowSignal := strtointdef(edVmaxSlowSignal.text,40);
  Fproject.DefaultObjects.Values['stopsign'] := edDOStopsign.text;
  Fproject.DefaultObjects.Values['signalpost'] := edSignalpost.text;
  Fproject.DefaultObjects.Values['signalback'] := edSignalback.text;
  Fproject.DefaultObjects.Values['stationmarkerstop'] := edStationmarkerStop.text;
  Fproject.DefaultObjects.Values['stationmarkerpass'] := edStationmarkerPass.text;
  FProject.Routefilessubdir := leSubDir.text;
  FProject.LogoPath := Image1.Hint;
  FProject.ParallelTrackDist := strtofloat1(edParallelDist.text);
  FProject.ParallelTrackDistPlatf := strtofloat1(edParallelDist2.text);
  FProject.BackgroundMapfilename :=  edMapFilename.text;
  FProject.BackgroundMapScale := strtointdef(EdMapResolution.text,0);;

  modalResult := mrOK;
end;

procedure TFormProjectProperties.Button3Click(Sender: TObject);
begin
  if Openpicturedialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(Openpicturedialog1.filename);
    Image1.hint := Openpicturedialog1.filename;
  end;
end;

procedure TFormProjectProperties.bDOSelectStopsignClick(Sender: TObject);
begin
  if formSelectObject.showModal()=mrOK then
  begin
    edDOStopsign.text := formSelectObject.selected;
  end;
end;

procedure TFormProjectProperties.b1000mStationmarkerstopClick(Sender: TObject);
begin
  if formSelectObject.showModal()=mrOK then
  begin
    edStationmarkerStop.text := formSelectObject.selected;
  end;
end;

procedure TFormProjectProperties.b1000mStationmarkerpassClick(Sender: TObject);
begin
  if formSelectObject.showModal()=mrOK then
  begin
    edStationmarkerPass.text := formSelectObject.selected;
  end;
end;

procedure TFormProjectProperties.bBrowseMapClick(Sender: TObject);
begin
  OpenPictureDialog2.FileName := edMapFilename.text;
  if OpenPictureDialog2.Execute then
  begin
    edMapFilename.text := OpenPictureDialog2.FileName;
  end;
end;

procedure TFormProjectProperties.bSignalpostselectClick(Sender: TObject);
begin
  if formSelectObject.showModal()=mrOK then
  begin
    edSignalpost.text := formSelectObject.selected;
  end;
end;

procedure TFormProjectProperties.bSignalbackSelectClick(Sender: TObject);
begin
  if formSelectObject.showModal()=mrOK then
  begin
    edSignalback.text := formSelectObject.selected;
  end;
end;

procedure TFormProjectProperties.FormShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  if msg.CharCode=27 then close;
end;

end.
