unit uStationsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  uRBStation,
  uRBProject,
  uRBConnection,
  uCurrentSituation,
  uGlobalDef,
  tOptions,
  ExtCtrls, ComCtrls, UWave;

resourcestring cStationAlreadyExists = 'A Station with this name already exists.'; 

type
  TFormStations = class(TForm)
    Label1: TLabel;
    lbStations: TListBox;
    Label2: TLabel;
    edStationname: TEdit;
    bAddStation: TButton;
    bSetStation: TButton;
    bDeleteStation: TButton;
    Label3: TLabel;
    lbPlatformtracks: TListBox;
    Label4: TLabel;
    bDeletePlatformTrack: TButton;
    edPlatformNo: TEdit;
    bgo: TButton;
    bFind: TButton;
    bPlatformSet: TButton;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    lMinStopTime: TLabel;
    edMinStopTime: TEdit;
    Label5: TLabel;
    tbPeople: TTrackBar;
    lPeople: TLabel;
    lPeopleNum: TLabel;
    lSounds: TLabel;
    edArrival: TEdit;
    lArrival: TLabel;
    Panel1: TPanel;
    lDeparture: TLabel;
    edDeparture: TEdit;
    bTestArrival: TButton;
    bTestDeparture: TButton;
    Wave1: TWave;
    cbStopOpposite: TCheckBox;
    procedure bFindClick(Sender: TObject);
    procedure bAddStationClick(Sender: TObject);
    procedure bDeleteStationClick(Sender: TObject);
    procedure lbStationsClick(Sender: TObject);
    procedure bSetStationClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bgoClick(Sender: TObject);
    procedure bDeletePlatformTrackClick(Sender: TObject);
    procedure lbPlatformtracksClick(Sender: TObject);
    procedure bPlatformSetClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure tbPeopleChange(Sender: TObject);
    procedure bTestArrivalClick(Sender: TObject);
    procedure bTestDepartureClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CurrentProject: TRBProject;
    procedure UpdateControls;
  end;

var
  FormStations: TFormStations;

implementation

uses tmain;

{$R *.dfm}

procedure TFormStations.bFindClick(Sender: TObject);
var id: integer;
begin
    id := strtointdef(CurrentProject.GetStationByIndex(lbStations.ItemIndex).Values[edPlatformNo.text],-1);
    if id=-1 then exit;
  // set current position to this track ID
    CurrentSituation.CurrentConnection := CurrentProject.FindConnectionByID( id );
    Currentsituation.Offset.x := CurrentSituation.CurrentConnection.P1.point.x;
    Currentsituation.Offset.y := CurrentSituation.CurrentConnection.P1.point.y;
    Currentsituation.cursor.x := round(Currentsituation.offset.x);
    Currentsituation.cursor.y := round(Currentsituation.offset.y);
    FormMain.FrmEditor.UpdateView;
//  close;
end;

procedure TFormStations.bAddStationClick(Sender: TObject);
var St: TRBStation;
begin
  if (lbStations.items.IndexOf(edStationname.text)<>-1) then
  begin
    MessageDlg(cStationAlreadyExists, mtError, [mbCancel], 0);
    exit;
  end;
  if (edStationname.text<>'') then
  begin
    lbStations.ItemIndex := lbStations.Items.add( edStationname.text );
    St := TRBStation.Create(edStationname.text);
    CurrentProject.Stations.add(St);
    edStationname.Text:= '';
    lbStationsClick(self);
  end;
end;

procedure TFormStations.bDeleteStationClick(Sender: TObject);
var a: integer;
begin
  a:= lbStations.ItemIndex;
  if a>=0 then
  begin
    lbStations.Items.delete(a);
    CurrentProject.Stations.Delete(a);
  end;
  if a>0 then lbStations.ItemIndex := a-1;
end;

procedure TFormStations.lbStationsClick(Sender: TObject);
var sta: TRBStation;
begin
  if lbStations.count=0 then exit;
  sta := CurrentProject.GetStationByIndex(lbStations.ItemIndex);
  edStationname.text := sta.StationName;
  edMinStopTime.text := inttostr(sta.MinStopTime);
  tbPeople.Position  := sta.PeopleCount;
  edArrival.Text     := sta.ArrivalSound;
  edDeparture.text   := sta.DepartureSound;
  cbStopOpposite.Checked := (sta.StopsignSide=-1);
  // Bahnsteige übertragen
  lbPlatformtracks.items.clear;
  sta.GetPlatformNumbers(lbPlatformtracks.items);
  if lbPlatformtracks.items.count>0 then
  begin
   lbPlatformtracks.itemindex := 0;
   lbPlatformtracksClick(self);
  end;
end;

procedure TFormStations.bSetStationClick(Sender: TObject);
var a: integer;
    sta: TRBStation;
begin
  if (edStationname.text='') then exit;
  a:= lbStations.ItemIndex;
  if a>=0 then
  begin
    lbStations.items[a] := edStationname.text;
    sta := CurrentProject.GetStationByIndex(a);
    sta.StationName := edStationname.text;
    sta.ArrivalSound := edArrival.text;
    sta.DepartureSound := edDeparture.text;
    sta.MinStopTime := strtointdef(edMinStopTime.text,20);
    sta.PeopleCount := tbPeople.Position;
    if cbStopOpposite.Checked then sta.StopsignSide := -1 else sta.StopsignSide := 1;
  end;
end;

procedure TFormStations.FormShow(Sender: TObject);
var i,c: integer;
    St: TRBStation;
begin
  //
  lbStations.items.Clear();
  if CurrentProject=nil then exit;

  c := CurrentProject.GetStationCount;
  for i:=0 to c-1 do
  begin
    St := CurrentProject.GetStationByIndex(i);
    lbStations.items.add(St.StationName);
  end;
  if c>0 then lbStations.ItemIndex := 0;

  lbStationsClick(self);
end;

procedure TFormStations.bgoClick(Sender: TObject);
var id: integer;
begin
  if lbStations.ItemIndex=-1 then exit;
  if edPlatformNo.text='' then exit;
  if lbPlatformtracks.Items.IndexOf(edPlatformNo.text)<0 then
  begin
    id := (Currentsituation.CurrentConnection as TRBConnection).ID;
    (Currentsituation.CurrentConnection as TRBConnection).special := csFixed;
    CurrentProject.GetStationByIndex(lbStations.ItemIndex).Values[edPlatformNo.text] := inttostr(id);
    // Bahnsteige neu eintragen
    //lbStationsClick(self);
    lbPlatformtracks.Items.Add(edPlatformNo.text);
    lbPlatformtracks.ItemIndex := lbPlatformtracks.count-1;
    bPlatformSetClick(self); 
  end;
end;

procedure TFormStations.bDeletePlatformTrackClick(Sender: TObject);
begin
  if (lbStations.ItemIndex>-1) and (lbPlatformtracks.ItemIndex>-1) then
  begin
    CurrentProject.GetStationByIndex(lbStations.ItemIndex).DeletePlatform(lbPlatformtracks.Items[lbPlatformtracks.itemindex]);
  end;
end;

procedure TFormStations.lbPlatformtracksClick(Sender: TObject);
begin
  if lbPlatformtracks.ItemIndex=-1 then exit;
  edPlatformNo.text := lbPlatformtracks.Items[lbPlatformtracks.itemindex];
end;

procedure TFormStations.bPlatformSetClick(Sender: TObject);
var a,id: integer;
begin
  if (edPlatformno.text='') then exit;
  a:= lbPlatformtracks.ItemIndex;
  if a>=0 then
  begin
    lbPlatformtracks.items[a] := edPlatformno.text;
    id := (Currentsituation.CurrentConnection as TRBConnection).ID;
    CurrentProject.GetStationByIndex(lbStations.ItemIndex).Values[edPlatformNo.text] := inttostr(id);
    FormMain.FrmEditor.UpdateView();
  end;
end;

procedure TFormStations.UpdateControls;
begin
  bgo.Enabled := (Currentsituation.CurrentConnection<>nil);
  bPlatformSet.Enabled := (Currentsituation.CurrentConnection<>nil);
  bFind.Enabled := (lbPlatformtracks.ItemIndex>=0);
  bDeletePlatformTrack.Enabled := (lbPlatformtracks.ItemIndex>=0);
end;

procedure TFormStations.Timer1Timer(Sender: TObject);
var sta: TRBStation;
begin
  bgo.Enabled := (Currentsituation.CurrentConnection <>nil);
  bPlatformSet.Enabled := (Currentsituation.CurrentConnection <>nil) and (edPlatformNo.text<>'');
  if (Currentsituation.CurrentConnection<>nil)and(CurrentProject<>nil) then
  begin
    sta := CurrentProject.GetStationByTrackID(Currentsituation.CurrentConnection.id);
    if sta<>nil then
    begin
        if sta.StationName <> CurrentProject.GetStationByIndex(lbStations.ItemIndex).StationName then
        begin
          lbStations.ItemIndex := lbStations.Items.IndexOf(sta.StationName);
          lbStationsClick(self);
        end;
    end;
  end;
end;

procedure TFormStations.tbPeopleChange(Sender: TObject);
begin
  lPeopleNum.caption := inttostr(tbPeople.Position);
end;

procedure TFormStations.bTestArrivalClick(Sender: TObject);
var f: string;
begin
  f := extractfilepath(Application.ExeName)+'\'+formOptions.ObjectFolder+'\sounds\'+edArrival.Text;
  if fileexists(f) then
  begin
    Wave1.WaveData.LoadFromFile(f);
    Wave1.play;
  end;
end;

procedure TFormStations.bTestDepartureClick(Sender: TObject);
var f: string;
begin
  f := extractfilepath(Application.ExeName)+'\'+formOptions.ObjectFolder+'\sounds\'+edDeparture.Text;
  if fileexists(f) then
  begin
    Wave1.WaveData.LoadFromFile(f);
    Wave1.play;
  end;
end;

end.
