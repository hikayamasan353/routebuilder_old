unit ttimetable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, Mask, tRbTimetable, StrUtils, uTools,
  uCurrentsituation, MsgIniSupp, uRBProject;

  type                               
  TFormTimetables = class(TForm)
    cbTimetable: TComboBox;
    Panel1: TPanel;
    lSelectTimetable: TLabel;
    btnNewTimetable: TButton;
    gb1: TGroupBox;
    edName: TEdit;
    lName: TLabel;
    lTrain: TLabel;
    cbTrain: TComboBox;
    lDepTime: TLabel;
    gb2: TGroupBox;
    lstStations: TListBox;
    btnAdd: TButton;
    btnDelete: TButton;
    StopsEditor: TStringGrid;
    edDepartureTime: TMaskEdit;
    btnRowDown: TButton;
    btnRowUp: TButton;
    btnDeleteTimetable: TButton;
    btnEditRD: TButton;
    btnApply: TButton;
    lTTOK: TLabel;
    Timer1: TTimer;
    edDistancePreTrain: TEdit;
    lDistFromPreTrain: TLabel;
    procedure FormShow(Sender: TObject);
    procedure cbTimetableSelect(Sender: TObject);
    procedure cbRouteDefinitionSelect(Sender: TObject);
    procedure btnNewTimetableClick(Sender: TObject);
    procedure edNameClick(Sender: TObject);
    procedure edNameExit(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure StopsEditorSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnRowUpClick(Sender: TObject);
    procedure btnRowDownClick(Sender: TObject);
    procedure btnDeleteTimetableClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnEditRDClick(Sender: TObject);
    procedure cbfilterstationsClick(Sender: TObject);
    function CheckStopList:boolean;
    procedure Timer1Timer(Sender: TObject);
  private
    CurrentTimetable : TRBSchedule;
  public
    { Public-Deklarationen }
    CurrentProject: TRBProject;
  end;

var
  FormTimetables: TFormTimetables;
  tmp:string; //Zwischenspeicherung
  tmp2:array[0..1] of string; //Zwischenspeicherung
  allowclose,onlyloadedtimetables,cancel:boolean; //Kontrollvariablen
  creatednow:integer;

implementation

uses tmain, uRBStation, uRBRouteDefinition, ttrain, ttimetablesRD;

{$R *.dfm}

//Rb Fahrplanverwaltung
//v 1.1.1 RC1
//100 %

procedure TFormTimetables.FormShow(Sender: TObject);
var i:integer;
begin
onlyloadedtimetables:=true;
allowclose:=true;

StopsEditor.Cells[0,0]:='Station';
StopsEditor.Cells[1,0]:='Duration (seconds)';

cbTrain.Items.AddStrings(FormTrain.TrainList.Items); //Züge einlesen

creatednow:=0;
cbTimeTable.Enabled:=False;

 if FormMain.FrmEditor.CurrentProject.Timetables.Count=0 then exit; //Wenn noch keine Fahrpläne in Projekt, dann nicht einlesen

cbTimetable.Items.Clear;
cbTimeTable.Enabled:=True;

 for i:=0 to FormMain.FrmEditor.CurrentProject.Timetables.Count-1 do
 begin
  cbTimetable.Items.Add((FormMain.FrmEditor.CurrentProject.Timetables[i] as TRbSchedule).ScheduleName);
 end;
 if cbTimetable.items.count>0 then
 begin
   cbTimetable.ItemIndex := 0;
   cbTimetableSelect(self);
 end;
end;


procedure TFormTimetables.cbTimetableSelect(Sender: TObject);
var i:integer;
begin
if cbTimetable.ItemIndex=-1 then exit;

StopsEditor.Enabled:=True;

btnDeleteTimetable.Enabled:=True;
gb1.Enabled:=True;
gb2.Enabled:=True;
CurrentTimetable := (FormMain.FrmEditor.CurrentProject.Timetables[cbTimetable.Itemindex] as TRbSchedule);
with CurrentTimetable do
begin
  edName.Text:=ScheduleName;
  cbTrain.ItemIndex:=cbTrain.Items.IndexOf(Train);
  edDepartureTime.Text:=TimeToStr(StartTime);
  btnDeleteTimetable.Caption:='Delete '+ScheduleName;
  if DistFromPreTrain<>0 then edDistancePreTrain.Text:=IntToStr(DistFromPreTrain);

  if Stops.Count=0 then exit;
  for i:=0 to Stops.Count-1 do
  begin //Stationen einlesen
   StopsEditor.RowCount:=StopsEditor.RowCount+1;
   StopsEditor.Cells[0,i+1]:=Stops.Strings[i];
   StopsEditor.Cells[1,i+1]:=inttostr(integer(Stops.Objects[i]));
  end;

end;
cbRouteDefinitionSelect(self);

if StopsEditor.Rowcount>(FormMain.FrmEditor.CurrentProject.Timetables[cbTimetable.Itemindex] as TRbSchedule).Stops.Count+1 then StopsEditor.RowCount:=(FormMain.FrmEditor.CurrentProject.Timetables[cbTimetable.Itemindex] as TRbSchedule).Stops.Count+1; //Wenn lehre Reihe zu viel, löschen

//cbRoutedefinition.Items.CommaText:=(FormMain.FrmEditor.CurrentProject.Timetables[cbTimetable.Itemindex] as TRbSchedule).RouteDefinitions.CommaText;

{if (cbRouteDefinition.Items.Count>0) and (Currentsituation.CurrentRouteDefinition<>nil) then begin
cbRoutedefinition.ItemIndex:=cbRoutedefinition.Items.IndexOf(Currentsituation.CurrentRouteDefinition.RouteDefinitionname);
cbRoutedefinitionSelect(self);
end
else begin
cbRouteDefinition.ItemIndex:=0;
cbRoutedefinitionSelect(self);
end;        }

onlyloadedtimetables:=false;
end;


procedure TFormTimetables.cbRouteDefinitionSelect(Sender: TObject);
var platforms: TStringlist; i,j,k:integer; station_in_one_rd:Boolean;
begin
//if Sender<>cbfilterstations then
lstStations.Clear;
platforms:= TStringlist.create;

for i:=0 to FormMain.FrmEditor.CurrentProject.stations.count-1 do
begin
  station_in_one_rd := false;
  (FormMain.FrmEditor.CurrentProject.stations[i] as TRbStation).GetPlatformNumbers(platforms);
  for j:=0 to CurrentTimetable.RouteDefinitions.count-1 do
  begin
    for k:=0 to platforms.count-1 do
      if (CurrentTimetable.RouteDefinitions.Objects[j] as TRBRouteDefinition).ContainsTrack((FormMain.FrmEditor.CurrentProject.stations[i] as TRbStation).GetTrackIDByPlatformNumber(platforms[k])) then station_in_one_rd := true;
  end;
  if station_in_one_rd=true then lstStations.Items.add((FormMain.FrmEditor.CurrentProject.stations[i] as TRbStation).StationName);
end;
platforms.Free;
end;


procedure TFormTimetables.btnNewTimetableClick(Sender: TObject);
var newTimetable : TRBSchedule;
begin

onlyloadedtimetables:=false;

gb1.Enabled:=True;
gb2.Enabled:=True;

cbTimeTable.Enabled:=True;
btnDeleteTimetable.Enabled:=True;

tmp:='Timetable'+IntToStr(cbTimetable.Items.Count); //zur Aktualisierung des Fahrplannamens in der Liste
edName.Text:=tmp;
cbTimetable.Items.Add(tmp);

//Felder leeren, u.s.w.
edDepartureTime.Clear;
cbTrain.ItemIndex:=0;
//cbRouteDefinition.Text:='-- Select Routedefinition --';
lstStations.Clear;
edDistancePreTrain.Clear;
StopsEditor.Cols[0].Clear;
StopsEditor.Cols[1].Clear;
StopsEditor.RowCount:=2;

btnDeleteTimetable.Caption:='Delete '+tmp;
StopsEditor.Cells[0,0]:='Station';
StopsEditor.Cells[1,0]:='Duration (seconds)';

cbTimetable.ItemIndex:=cbTimetable.Items.IndexOf(tmp); //Auf neuen Fahrplan springen
//cbTimetable.SelText:='Timetable'+IntToStr(cbTimetable.Items.Count);

newTimetable := TRbSchedule.Create;
FormMain.FrmEditor.CurrentProject.Timetables.Add(newTimetable); //Neues Fahrplanelemt erzeugen
newTimetable.ScheduleName:=tmp;
CurrentTimetable := newTimetable;

inc(creatednow);

FormTimetablesRd.CurrentProject := CurrentProject;
FormTimetablesRd.CurrentTimetable := newTimetable;
FormTimetablesRd.ShowModal;

cbRouteDefinitionSelect(sender);
{if (cbRouteDefinition.Items.Count>0) and (Currentsituation.CurrentRouteDefinition<>nil) then
begin
  //cbRoutedefinition.ItemIndex:=cbRoutedefinition.Items.IndexOf(Currentsituation.CurrentRouteDefinition.RouteDefinitionname);
  cbRoutedefinitionSelect(self);
end         }
end;


procedure TFormTimetables.edNameClick(Sender: TObject);
begin
tmp:=edName.Text;
end;


procedure TFormTimetables.edNameExit(Sender: TObject);
var i: integer;
begin
 if tmp='' then exit;
i:=cbTimetable.itemindex;
 if i<0 then exit; // fatal - es ist nicht der richtige Fahrplan selektiert (bzw. keiner)
cbTimetable.Items.Strings[i]:=edName.Text;
cbTimetable.Update;
cbTimetable.itemindex:=i;
end;


procedure TFormTimetables.btnAddClick(Sender: TObject);
var i:integer;
begin

if cbTimetable.ItemIndex=-1 then exit;

StopsEditor.Enabled:=True;
//Routedefinitions, falls benötigt, hinzufügen

//lstStations.CopySelection(lstStations);//Markierte Stops übernehmen
//  if StopsEditor.RowCount
// StopsEditor.RowCount:=StopsEditor.RowCount+1;
 for i:=0 to lstStations.Count-1 do
 if lstStations.Selected[i] then
 begin
  // Stop noch nicht vorhanden?

  if StopsEditor.Cells[0,StopsEditor.RowCount-1]<>'' then StopsEditor.RowCount:=StopsEditor.RowCount+1;
  
  if StopsEditor.Cols[0].IndexOf(lstStations.Items[i])<0 then
  begin
   StopsEditor.Cells[0,StopsEditor.RowCount-1]:=lstStations.Items[i];
   StopsEditor.Cells[1,StopsEditor.RowCount-1]:=IntToStr(30);
   StopsEditor.RowCount:=StopsEditor.RowCount+1;
  end
 end;

end;


procedure TFormTimetables.btnDeleteClick(Sender: TObject);
var i:integer;
begin
// nicht die Überschriftenzeile löschen!
if StopsEditor.Selection.Top = 0 then exit;

if StopsEditor.Cells[0,StopsEditor.Selection.Top]='' then exit;
StopsEditor.Rows[StopsEditor.Selection.Top].Clear;

 for i:=StopsEditor.Selection.Top to StopsEditor.RowCount-1 do begin
  StopsEditor.Cells[0,i]:=StopsEditor.Cells[0,i+1];
  StopsEditor.Cells[1,i]:=StopsEditor.Cells[1,i+1];
 end;
if StopsEditor.RowCount>2 then StopsEditor.RowCount:=StopsEditor.RowCount-1;

end;

procedure TFormTimetables.StopsEditorSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin

if (Acol=0) or ((Acol=0) and (StopsEditor.Cells[0,ARow]='')) then begin
StopsEditor.Options:=[goFixedVertLine,goFixedHorzLine,goRowMoving,goAlwaysShowEditor];
//CanSelect:=False;
//CanSelect:=True; //Editieren der Bahnhofsnamen verhindern
end
else begin
StopsEditor.Options:=[goFixedVertLine,goFixedHorzLine,goRowMoving,goEditing,goAlwaysShowEditor];
//CanSelect:=True;
end;
end;


procedure TFormTimetables.btnRowUpClick(Sender: TObject);
var i:integer;
begin
 // erste Zeile (Titelzeile) nicht löschen
 if (StopsEditor.Selection.Top=0) or (StopsEditor.Cells[0,StopsEditor.Selection.Top-1]='') or (StopsEditor.Cells[0,StopsEditor.Selection.Top]='') or (StopsEditor.Cells[1,StopsEditor.Selection.Top]='') or (StopsEditor.Cells[1,StopsEditor.Selection.Top-1]='') or (StopsEditor.Selection.Top-1=0) then exit;
 for i:=StopsEditor.Selection.Top-1 to StopsEditor.Selection.Top do
 begin
  if i=StopsEditor.Selection.Top-1 then
  begin
   tmp2[0]:=StopsEditor.Cells[0,i];
   tmp2[1]:=StopsEditor.Cells[1,i];
   StopsEditor.Cells[0,i]:=StopsEditor.Cells[0,i+1];
   StopsEditor.Cells[1,i]:=StopsEditor.Cells[1,i+1];
  end
  else if i=StopsEditor.Selection.Top then
  begin
   StopsEditor.Cells[0,i]:=tmp2[0];
   StopsEditor.Cells[1,i]:=tmp2[1];
  end;
 end;
(FormMain.FrmEditor.CurrentProject.Timetables[cbTimetable.Itemindex] as TRbschedule).Stops.Clear; //Neusortierung der Stops erzwingen
end;


procedure TFormTimetables.btnRowDownClick(Sender: TObject);
var i:integer;
begin
if (StopsEditor.Selection.Top=0) or (StopsEditor.Cells[0,StopsEditor.Selection.Top+1]='') or (StopsEditor.Cells[0,StopsEditor.Selection.Top+1]='') or (StopsEditor.Cells[1,StopsEditor.Selection.Top]='') or (StopsEditor.Cells[1,StopsEditor.Selection.Top]='') then exit;
 for i:=StopsEditor.Selection.Top to StopsEditor.Selection.Top+1 do begin
  if i=StopsEditor.Selection.Top then begin
   tmp2[0]:=StopsEditor.Cells[0,i];
   tmp2[1]:=StopsEditor.Cells[1,i];
   StopsEditor.Cells[0,i]:=StopsEditor.Cells[0,i+1];
   StopsEditor.Cells[1,i]:=StopsEditor.Cells[1,i+1];
  end
  else if i=StopsEditor.Selection.Top+1 then begin
   StopsEditor.Cells[0,i]:=tmp2[0];
   StopsEditor.Cells[1,i]:=tmp2[1];
  end;
 end;
(FormMain.FrmEditor.CurrentProject.Timetables[cbTimetable.Itemindex] as TRBSchedule).Stops.Clear;
end;


procedure TFormTimetables.btnDeleteTimetableClick(Sender: TObject);
var i: integer;
begin
edName.Clear;

if btnDeleteTimetable.Caption<>'Delete' then
begin
  //cbTimetableDropDown(self);
  
  i := cbTimetable.Itemindex;
  // nur löschen wenn selektiert
  if i>=0 then
  FormMain.FrmEditor.CurrentProject.Timetables.Delete( i );

  //cbTimetable.DeleteSelected;
  // nicht erforderlich bzw. gefährlich
  //Sollte nach löschen eines Fahrplanes Liste geöffnet werden kommt Fehler,daher:

  cbTimetable.Clear;
  edDistancePreTrain.Clear;

  if FormMain.FrmEditor.CurrentProject.Timetables.Count=0  then begin
  cbTimetable.Enabled:=False;
  edName.Clear;
  edDepartureTime.Clear;
  //cbRouteDefinition.Text:='-- Select Routedefinition --';
  lstStations.Clear;
  StopsEditor.Cols[0].Clear;
  StopsEditor.Cols[1].Clear;
  StopsEditor.RowCount:=2;

  StopsEditor.Cells[0,0]:='Station';
  StopsEditor.Cells[1,0]:='Duration (seconds)';
  btnDeleteTimetable.Caption:='Delete';
  btnDeleteTimetable.Enabled:=False;
  end
  else begin
   for i:=0 to FormMain.FrmEditor.CurrentProject.Timetables.Count-1 do
    begin
     cbTimetable.Items.Add((FormMain.FrmEditor.CurrentProject.Timetables[i] as TRbSchedule).ScheduleName);
    end;
  cbTimetable.Enabled:=True;
  btnDelete.Enabled:=True;
  cbTimetable.ItemIndex:=cbTimetable.Items.Count-1;
  cbTimetableSelect(self);
  btnDeleteTimetable.Caption:='Delete '+edName.Text;
  end;

end;
allowclose:=true;
end;

procedure TFormTimetables.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
{
if cancel=false then
begin
if (cbTimetable.Items.Count>0) then cbTimetableDropDown(FormTimetables); //Ausgewählten Fahrplan speichern
if allowclose=false then Action:=caNone;


 edname.Clear;
 edDepartureTime.Clear;
  //cbRouteDefinition.Text:='-- Select Routedefinition --';
 lstStations.Clear;
 StopsEditor.Cols[0].Clear;
 StopsEditor.Cols[1].Clear;
 StopsEditor.RowCount:=2;
// cbRouteDefinition.Clear;
end;   }
end;

procedure TFormTimetables.btnCloseClick(Sender: TObject);
begin
Close;
end;

procedure TFormTimetables.btnApplyClick(Sender: TObject);
var i,i2,ii:integer;
begin
 if ((edName.Text='') or (edDepartureTime.Text='  :  :  ') or (StopsEditor.RowCount<3)) and ((cbTimetable.Items.Count>0) and (onlyloadedtimetables=false)) then begin //prüfen ob Eingabefelder leer, wenn ja Fehlermeldung+FormClose verhindern
  MessageDlg(lngmsg.GetMsg('ttimetables_notcomplete'),mtError,[mbOk],0);
  btnNewTimetable.Enabled:=False;
  allowclose:=false;
  exit;
 end
//  else if (cbTimetable.Items.Count=0) or (cbTimetable.ItemIndex=-1)  or ((CheckStopList) and (cbTimetable.Items.Count>0)) then exit //Wenn kein Fahrplan angewählt abbrechen
 else btnNewTimetable.Enabled:=True;

if edDistancePreTrain.Text='' then edDistancePreTrain.Text:='0';

allowclose:=true;

if StopsEditor.Cells[0,StopsEditor.RowCount-1]='' then
  StopsEditor.RowCount:=StopsEditor.RowCount-1;


 with CurrentTimeTable do
 begin
  ScheduleName:=edName.Text;
  Train:=cbTrain.Text;
  StartTime:=StrToTime(edDepartureTime.Text);
  DistFromPretrain:=StrToInt(edDistancePreTrain.Text);

  StartStation:=StopsEditor.Cells[0,1];
  EndStation:=StopsEditor.Cells[0,StopsEditor.Rowcount-1];

  //if StopsEditor.Cells[0,StopsEditor.RowCount-1]='' then StopsEditor.RowCount:=StopsEditor.Rowcount-1;

  for i:=1 to StopsEditor.RowCount-1 do begin
   if (Stops.CommaText<>'') and (AnsiContainsStr(Stops.CommaText,StopsEditor.Cells[0,i])) then UpdateStop(StopsEditor.Cells[0,i],StrToInt(StopsEditor.Cells[1,i]))
   else AddStop(StopsEditor.Cells[0,i],StrToInt(StopsEditor.Cells[1,i]));
  end;

  for i:=0 to Stops.Count-1 do begin
   if AnsiContainsStr(StopsEditor.Cols[0].CommaText,Stops.Strings[i])=False then ClearStop(Stops.Strings[i],0);
  end;
 end;

 btnNewTimetable.Enabled := true;

 lTTOK.Visible := true;
 Timer1.Enabled := true;
 {cancel:=true;
Close;

if creatednow=0 then exit;

 edname.Clear;
 edDepartureTime.Clear;
  //cbRouteDefinition.Text:='-- Select Routedefinition --';
 lstStations.Clear;
 StopsEditor.Cols[0].Clear;
 StopsEditor.Cols[1].Clear;
 StopsEditor.RowCount:=2;
// cbRouteDefinition.Clear;

 btnDeleteTimetable.Caption:='Delete '+tmp;
 StopsEditor.Cells[0,0]:='Station';
 StopsEditor.Cells[1,0]:='Duration (seconds)';
 i:=FormMain.FrmEditor.CurrentProject.Timetables.Count-1;
 i2:=FormMain.FrmEditor.CurrentProject.Timetables.Count-creatednow;

 repeat
  if FormMain.FrmEditor.CurrentProject.Timetables[i]<>nil then FormMain.FrmEditor.CurrentProject.Timetables.Delete(i);
  dec(i);
 until i=i2-1;
 cbTimetable.Clear; }
end;

procedure TFormTimetables.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key='#13' then btnApplyClick(sender);
end;

procedure TFormTimetables.btnEditRDClick(Sender: TObject);
begin
FormTimetablesRd.CurrentTimetable := CurrentTimetable;
FormTimetablesRd.CurrentProject := CurrentProject;
FormTimetablesRd.ShowModal;
cbRouteDefinitionSelect(sender);
end;

procedure TFormTimetables.cbfilterstationsClick(Sender: TObject);
var i:integer;
begin
{ if (cbfilterstations.Checked) and (cbRouteDefinition.Items.Count>0) then begin
  cbRouteDefinitionSelect(cbRouteDefinition);
  cbRoutedefinition.Enabled:=True;
 end
 else begin
   if cbRouteDefinition.Items.Count=0 then exit;
  lstStations.Clear;

   for i:=0 to cbRouteDefinition.Items.Count-1 do begin
    cbRouteDefinition.ItemIndex:=i;
    cbRouteDefinitionSelect(cbfilterstations);
    cbRoutedefinition.Enabled:=False;
   end;
end;           }
end;

function TFormTimetables.CheckStopList:boolean;
var i:integer;
begin
result:=false;

for i:=0 to StopsEditor.Rowcount-1 do begin
if (StopsEditor.Cells[0,i]='') or (StopsEditor.Cells[1,i]='') then result:=true;
end;

if (StopsEditor.Cells[0,StopsEditor.Rowcount-1]='') and (StopsEditor.Cells[1,StopsEditor.Rowcount-1]='') then begin
StopsEditor.RowCount:=StopsEditor.RowCount-1;
end;
end;

procedure TFormTimetables.Timer1Timer(Sender: TObject);
begin
  lTTOK.visible := false;
  Timer1.Enabled := false;
end;

end.


