unit ttimetablesRD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, tmain, grids, tRbTimetable, uRBRoutedefinition,
  strutils,uRBStation, uRBProject,
  ExtCtrls;

type
  TFormTimetablesRD = class(TForm)
    RDBox: TCheckListBox;
    btnSelAll: TButton;
    btnSelNone: TButton;
    btnSelOK: TButton;
    Panel1: TPanel;
    procedure btnSelAllClick(Sender: TObject);
    procedure btnSelNoneClick(Sender: TObject);
    procedure btnSelOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function GetStationsInRD(RD:TRbRoutedefinition): TStringlist;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    CurrentTimetable: TRBSchedule;
    CurrentProject: TRBProject;
  end;

var
  FormTimetablesRD: TFormTimetablesRD;
  RDStationlist:TStringlist;

implementation

// Rb- Fahrstreckenverwaltung für Fahrplan
// v1.1.1
// 100%

uses ttimetable;

{$R *.dfm}

procedure TFormTimetablesRD.btnSelAllClick(Sender: TObject);
var i:integer;
begin
//Selektiert alle Rds
 for i:=0 to RdBox.Items.Count-1 do begin
  RdBox.Checked[i]:=true;
 end;
end;

procedure TFormTimetablesRD.btnSelNoneClick(Sender: TObject);
var i:integer;
begin
//Deselektiert alle Rds
 for i:=0 to RdBox.Items.Count-1 do begin
  RdBox.Checked[i]:=false;
 end;
end;

procedure TFormTimetablesRD.btnSelOKClick(Sender: TObject);
var i,i2,i3:integer;
begin
//Listen löschen
// (FormMain.FrmEditor.CurrentProject.Timetables[FormTimetables.cbTimetable.ItemIndex] as TRbSchedule).RouteDefinitions.CommaText:='';
// FormTimetables.cbRouteDefinition.Items.Clear;
 FormTimetables.lstStations.Clear;

 CurrentTimetable.Routedefinitions.clear;

 i2:=0;
 //Rds durchgehen
  for i:=0 to RdBox.Items.Count-1 do
  begin
   if RdBox.Checked[i] then
   begin
   //Wenn Rd ausgewählt dann zu Fahrplan hinzufügen
    CurrentTimetable.Routedefinitions.AddObject(RDBox.Items[i],
                    CurrentProject.FindRouteDefinitionByName(RDBox.Items[i]));
//     FormTimetables.cbRouteDefinition.Items.Add(RDBox.Items[i]);
   end
  end;
   {
   else
   begin
   RDStationlist:=TStringlist.Create;

   //Stationen ermitteln
   RdStationlist:=GetStationsinRd(FormMain.FrmEditor.CurrentProject.FindRouteDefinitionByName(RdBox.Items.Strings[i]));

   i2:=FormTimetables.StopsEditor.RowCount-1;

   repeat
     //Wenn Station einer nicht mehr ausgewählten Rd in Stationseditor dann automatisch entfernen
     if AnsiContainsStr(RdStationlist.CommaText,FormTimetables.StopsEditor.Cells[0,i2]) then begin
      FormTimetables.StopsEditor.Rows[i2].Clear;

       for i3:=i2 to FormTimetables.StopsEditor.RowCount-1 do begin
        FormTimetables.StopsEditor.Cells[0,i2]:=FormTimetables.StopsEditor.Cells[0,i2+1];
        FormTimetables.StopsEditor.Cells[1,i2]:=FormTimetables.StopsEditor.Cells[1,i2+1];
       end;

      if FormTimetables.StopsEditor.RowCount>2 then FormTimetables.StopsEditor.RowCount:=FormTimetables.StopsEditor.RowCount-1;;
     end;
    i2:=i2-1;
   until i2=0;

  end;
end;

//auf erste Rd springen wenn möglich
if FormTimetables.cbRouteDefinition.Items.Count>0 then begin
FormTimetables.cbRouteDefinition.ItemIndex:=0;
FormTimetables.cbRouteDefinitionSelect(self);
end;               }

Close;
end;

procedure TFormTimetablesRD.FormShow(Sender: TObject);
var i:integer;
    RD: TRBRouteDefinition;
begin
RdBox.Items.Clear;
 //Rds einlesen
 for i:=0 to CurrentProject.Routes.Count-1 do
 begin
  RD := CurrentProject.Routes.Items[i] as TRbRouteDefinition;
  RDBox.Items.AddObject(RD.RouteDefinitionname,RD); //Routedefinitions einlesen
  RDBox.Checked[i] := (CurrentTimetable.RouteDefinitions.IndexOf(RD.RouteDefinitionname)>=0 );
 end;
end;


function TFormTimetablesRD.GetStationsInRD(RD:TRbRoutedefinition): TStringlist;
var platforms: TStringlist; i,j,k:integer; station_in_one_rd:Boolean;
    stations:TStringlist;
begin
stations:=TStringlist.Create;
platforms:= TStringlist.create;

for i:=0 to CurrentProject.stations.count-1 do
begin
station_in_one_rd := false;
for j:=0 to CurrentProject.routes.count-1 do
  begin
    (CurrentProject.stations[i] as TRbStation).GetPlatformNumbers(platforms);
    for k:=0 to platforms.count-1 do
      if RD.ContainsTrack((CurrentProject.stations[i] as TRbStation).GetTrackIDByPlatformNumber(platforms[k])) then station_in_one_rd := true;
  end;
if station_in_one_rd=true then stations.Add((CurrentProject.stations[i] as TRbStation).StationName);
end;

result:=stations;
Platforms.Free;
//stations.Free;
end;

end.
