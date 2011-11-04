unit uRBStation;

interface

uses sysutils, classes, uTools;

type
     TRBStation= class(Tstringlist)
       public
       StationName,
       ArrivalSound,
       DepartureSound: string;
       exported: boolean;
       DoorSide: integer; // -1=links, +1=rechts
       StopsignSide: integer; // -1=gegenüber Bahnsteig, +1=auf Bahnsteig, 0=Gleismitte
       PeopleCount: integer; // Fahrgastaufkommen 0..250
       MinStopTime: integer; // minimale Aufenthaltsdauer
       constructor Create(const AStationName: string='');
       function StationNameExt(): string;
       function GetTrackIDByPlatformNumber(const platformnumber: string): integer;
       function GetPlatformNumberByTrackID(id: integer): string;
       procedure GetPlatformNumbers(platformnumbers: TStrings);
       function GetAsString: string;
       function SetFromString(const s: string): boolean;
       function DeletePlatform(const platformname: string): boolean;
       function TrackIDIsInStation(id: integer): boolean;
     end;

implementation

constructor TRBStation.Create(const AStationName: string);
begin
  inherited Create();
  StationName := AStationName;
  DoorSide    := 1;
  StopSignSide:= -1;
  PeopleCount := 100;
  MinStopTime := 20;
  ArrivalSound:= '';
  DepartureSound:= '';
end;

function TRBStation.StationNameExt:string;
begin
  result := StationName+'|'+inttostr(Doorside)+'|'+inttostr(StopSignSide)+'|'+inttostr(PeopleCount)
    +'|'+inttostr(MinStopTime)+'|'+ArrivalSound+'|'+DepartureSound;
end;


// Funktion: GetTrackIDByPlatformNumber
// Autor   : up
// Datum   : 10.9.02
// Beschr. : holt Track, der zur angegebenen Bahnsteignummer gehört (string, kann auch z.B. 1a sein)
// falls diese Bahnsteignummer unbekannt ist, ist das Resultat -1
function TRBStation.GetTrackIDByPlatformNumber(const platformnumber: string): integer;
begin
  result := strtointdef(values[platformnumber],-1);
end;

// Funktion: GetPlatformNumberByTrackID
// Autor   : up
// Datum   : 10.9.02
// Beschr. : holt Bahnsteignummer eines Tracks oder, falls dieser Track kein Bahnsteigtrack
//           dieses Bahnhofs ist, Leerstring
function TRBStation.GetPlatformNumberByTrackID(id: integer): string;
var i: integer;
begin
  result := '';
  for i:= 0 to count-1 do
  begin
    if values[names[i]] = inttostr(id) then
    begin
     result := names[i];
     exit;
    end;
  end;
end;


// Funktion: GetAsString
// Autor   : up
// Datum   : 10.9.02
// Beschr. : erzeugt einzeiligen Datenstring (zum Abspeichern)
function TRBStation.GetAsString(): string;
begin
  if count>0 then
    result := '"' + StationNameExt() + '",' + commatext
  else
    result := '"' + StationNameExt() + '"';
end;

// Funktion: SetFromString
// Autor   : up
// Datum   : 10.9.02
// Beschr. : belegt Objekt mithilfe des Strings s (z.B. nach Laden), gibt bei Erfolg true zurück
function TRBStation.SetFromString(const s: string): boolean;
begin
  commatext := s;
  if count=0 then
    result := false
  else
  begin
    Stationname := StrGetToken( strings[0], '|',1);
    Doorside    := strtointdef( StrGetToken( strings[0], '|',2), 1);
    StopSignSide:= strtointdef( StrGetToken( strings[0], '|',3), -1);
    PeopleCount := strtointdef( StrGetToken( strings[0], '|',4), 100);
    MinStopTime := strtointdef( StrGetToken( strings[0], '|',5), 20);
    ArrivalSound:= StrGetToken( strings[0], '|',6);
    DepartureSound:= StrGetToken( strings[0], '|',7);
    delete(0);
    result := true;
  end;
end;

// Funktion: GetPlatformNumbers
// Autor   : up
// Datum   : 10.9.02
// Beschr. : füllt übergebene Stringslist (muss created worden sein!) mit den Bahnsteignummern
//           dieses Bahnhofs
procedure TRBStation.GetPlatformNumbers(platformnumbers: TStrings);
var i: integer;
begin
  platformnumbers.clear();
  for i:=0 to count-1 do
  begin
    platformnumbers.Add(names[i]);
  end;
end;

function TRBStation.DeletePlatform(const platformname: string): boolean;
var i: integer;
begin
  i := indexofname(platformname);
  if i>=0 then delete(i);
end;

function TRBStation.TrackIDIsInStation(id: integer): boolean;
var i: integer;
begin
  for i:=0 to count-1 do
  begin
    if values[names[i]]=inttostr(id) then
    begin
      result := true;
      exit;
    end;
  end;
  result := false;
end;

end.
