unit tRbTimetable;

interface

uses
Contnrs, uRbRouteDefinition,uTools ,DateUtils, windows, Classes, SysUtils;

type
 TRBSchedule=class(TObject)
 public
 ScheduleName: string; // Zugnummer
 RouteDefinitions: TStringlist;
 Train: string; // Führerstandname (kann natürlich auch TRBTrain sein)
 StartStation: string;
 EndStation: string;
 StartTime: TDateTime;
 Stops: TStringlist; // Namen der Haltebahnhöfe
 DistFromPretrain:integer; //Distanz zum vorherfahrenden Zug
 constructor Create;
 destructor Destroy; override;
 //procedure SetVar(SchedulenameIn,TrainIn,StartstationIn,EndstationIn: string; RouteDefinitionIn:TRbRouteDefinition; StartTimeIn:TDateTime);
 procedure AddStop(name:string; duration:integer);
 procedure UpdateStop(name:string; duration:integer);
 procedure ClearStop(name:string; duration:integer);
 function GetStopDuration(name: string): integer;
 constructor CreateFromString(const s:string);
 function GetAsString: string;
 {procedure LoadShedule;
 procedure SaveShedule;}
 end;

// RB Fahrplanschnittstelle
// v 1.0.1 für Rb 1.1
// 100%

implementation

constructor TRBSchedule.Create;
begin
inherited Create();

Stops:=TStringlist.Create;
RouteDefinitions:=TStringlist.Create;
end;

destructor TRBSchedule.Destroy;
begin
inherited destroy();

Stops.Free;
Routedefinitions.Free;
end;

procedure TRbSchedule.AddStop(name:string; duration:integer);
begin
Stops.AddObject(name,TObject(duration));
end;

procedure TRbSchedule.UpdateStop(name:string; duration:integer);
var i:integer;
begin
 if Stops.Count=0 then exit;

  for i:=0 to Stops.Count-1 do begin
   if name=Stops.Strings[i] then begin
    Stops.Delete(i);
    Stops.InsertObject(i,name,TObject(duration));
   end;
  end;
end;

procedure TRbSchedule.ClearStop(name:string; duration:integer);
var i:integer;
begin
 for i:=0 to Stops.Count-1 do begin
  if name=Stops.Strings[i] then Stops.Delete(i);
 end;
end;

function TRbSchedule.GetAsString: string;
var i:integer; tmp:string;
begin

tmp:='';
 for i:=0 to Stops.Count-1 do begin //String für Stationen erzeugen
  if i=Stops.Count-1 then tmp:=tmp+Stops.Strings[i]+';'+inttostr(integer(Stops.Objects[i]))
  else tmp:=tmp+Stops.Strings[i]+';'+inttostr(integer(Stops.Objects[i]))+';';
 end;

result := format('"%s","%s","%s","%s","%s","%s","%s",%s',[ScheduleName,Train,StartStation,Endstation,TimeToStr(StartTime),tmp,IntToStr(DistFromPreTrain),Routedefinitions.CommaText]);
end;

constructor TRbSchedule.CreateFromString(const s:string);
var i:integer;
tmp:string;
begin
create();

//Daten auslesen
ScheduleName:=StripQuotes(StrGetToken(s,',',1));
Train:=StripQuotes(StrGetToken(s,',',2));
StartStation:=StripQuotes(StrGetToken(s,',',3));
EndStation:=StripQuotes(StrGetToken(s,',',4));
StartTime:=StrToTime(StripQuotes(StrGetToken(s,',',5)));

tmp:=StripQuotes(StrGetToken(s,',',6));
DistFromPreTrain:=StrToIntdef(StripQuotes(StrGetToken(s,',',7)),0);

for i:=7 to CountTokens(s,',') do begin //Routedefinitions einlesen
if i=CountTokens(s,',') then Routedefinitions.CommaText:=Routedefinitions.CommaText+StrGetToken(s,',',i)
else if i<CountTokens(s,',') then Routedefinitions.CommaText:=Routedefinitions.CommaText+StrGetToken(s,',',i)+',';
end;

i:=1; //Stationen einlesen
repeat
Stops.AddObject(StrGetToken(tmp,';',i),TObject(strtoint(StrGetToken(tmp,';',i+1))));
inc(i,2);
until i>=CountTokens(tmp,';');

end;

// Funktion:
// Autor   : u
// Datum   :
// Beschr. : ermittelt die Haltedauer auf dem angegebenen Stop
function TRBSchedule.GetStopDuration(name: string): integer;
var i: integer;
begin
  i := Stops.IndexOf(name);
  if i<0 then
    result := 0 // nicht gefunden
  else
    result := integer(stops.Objects[i]);
end;

end.
