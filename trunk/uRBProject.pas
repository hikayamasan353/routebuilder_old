unit uRBProject;

// Route Builder
// enthält TRBProject
// Autor: up
// Erstellt: 14.7.02

interface

uses sysutils, types, classes, graphics, contnrs, controls, extctrls, math,
     uGlobalDef,
     uRBPoint,
     uRBRouteDefinition, uCurrentSituation,
     uRBConnection,
     uRBConnectionList,
     uRBStation,
     uRBObject,
     uRBGrid,
     uRBSignal,
     uTools,
     tRBTimetable,
     uRBTrain,
    uRBPlatformList,
    uRBGroundTexturelist,
    uRBBackgroundTexturelist,
    uRBCatenaryPolelist,
    uRBRoofList,
    uRBWallList,
     toptions;

type
  TRBProject = class
    private
    public
      Projectname,
      Author,
      AuthorEmailAddress,
      Description,
      Credits,
      HomepageURL,
      Projectfilename,
      Objectlibrary: string;
      VmaxSlowSignal,
      Gauge: integer;
      Dikes,
      Walls,
      Backgrounds,
      Grounds,
      Freeobjects,
      Trains,
      Routes,
      Stations,
      Points,
      Grids,
      Signals,
      Timetables: TObjectlist;
      Connections: TRBConnectionlist;
      Routefilesdir,
      Routefilessubdir,
      BackgroundMapfilename,
      LogoPath: string;
      DefaultObjects: TStringlist;
      ExpertMode: boolean;
      BackgroundMapScale, // pixel/1000m
      DeveloperID: integer;
      NextTrackID: integer;
      ParallelTrackDist,ParallelTrackDistPlatf: double;
      SetStatusProc: procedure (const what: string) of object;
      //Gleisplan, FreeObjects (Verweise),
      //Fahrtrassen, Liste möglicher Fahrzeuge,
      //Fahrplänen, Screenshot oder Logo(optional)
      constructor Create(UseExpertmode: boolean=false);
      destructor Destroy();
      function SaveToFile(const filename: string=''): boolean;
      function SaveRegionToFile(const filename,_author,comment: string): boolean;
      function ImportRegionFromFile(const filename: string): boolean;
      function LoadFromFile(const filename: string; Parent: TWincontrol): boolean;
      function CanSave(): boolean;
      function FindPointByID(id: integer): TRBPoint;
      function FindPointNearPoint(point: TDoublePoint; radius: double): TRBPoint;
      function FindConnectionByID(id: integer): TRBConnection;
      function FindRouteDefinitionByID(id: Cardinal): TRBRouteDefinition;
      function FindRouteDefinitionByName(const n: string): TRBRouteDefinition;
      function FindConnectionsAtPoint(point: TRBPoint; connlist: TObjectList; NotThis: TRBConnection=nil): integer;
      function GetStationByName(const stationname: string): TRBStation;
      function GetStationByIndex(index: integer): TRBStation;
      function GetStationCount(): integer;
      function GetStationByTrackID(id: integer): TRBStation;
      function GetTrainByName(const trainname: string): TRBTrain;
      function GetMaxRouteDefinitionID: integer;
      function IsTrackInRouteDefinition(track :TRBConnection; RDID: Cardinal=0): boolean;
      function FindConnectionFromTo(p1,p2: TRBPoint): TRBConnection;
      function FindConnectionAtPointInRouteDefinition(point: TRBPoint; RDID: integer; NotThisOne: TRBConnection): TRBConnection;
      procedure AddTrackToCurrentRouteDefinition(track: TRBConnection);
      procedure DeleteTrackFromCurrentRouteDefinition(track: TRBConnection);
      procedure GetRouteDefinitionsAsNames(destination: TStrings);
      procedure Clear();
      procedure AddPoint(p: TRBPoint);
      function GetPointIDMax: integer;
      procedure DeletePoint(p: TRBPoint);
      procedure ClearArea(area1,area2: TDoublePoint);
      procedure AddConnection(c: TRBConnection);
      function DeleteConnection(c: TRBConnection): boolean;
      procedure AddObject(o: TRBObject);
      procedure DeleteObject(o: TRBObject);
      function AddGrid(rootconnection: TRBConnection): TRBGrid;
      function DeleteGridByName(const n: string): boolean;
      function GetNearestGrid(p: TDoublePoint): TRBGrid;
      procedure SetGridAngles();
      function GetConnectionParentGrid(connid: integer): TRBGrid;
      procedure SnapToGrid(conn: TRBConnection; grid: TRBGrid);
      function SnapPointToGrid(point: TRBPoint): boolean;
      procedure SetPointsNotTurned;
      function DeleteSignalByName(const n: string): boolean;
      function ExportPreprocess(): boolean;
      function IsPointInSegment(p1,p2,p3: TDoublePoint; l: integer; var a,b: double): boolean;
      function GetTracksInSegment(p1,p2: TDoublePoint; l: integer; Tracklist: TObjectlist; NotThisOne: TRBConnection): integer;
      procedure AddToSameRouteDefinitionAs(newconn,oldconn:TRBConnection);
      procedure DeletefromAllRouteDefinitions(conn: TRBConnection);
      function StationIsInRouteDefinition(sta: TRBStation; const platf: string; RD: TRBRouteDefinition): boolean;
      procedure GetStationPlatformListForRouteDefinition(RD: TRBRouteDefinition; sl: TStrings);
      procedure GetStationListForRouteDefinition(RD: TRBRouteDefinition; sl: TStrings);
      procedure GetStationListForRouteDefinitions(RDlist: TStrings; sl: TStrings);
  end;


implementation

uses
  Dialogs;


// Funktion    : Create
// Datum       : 14.7.02
// Autor       : up
// Beschreibung: erzeugt ein leeres Projektobjekt.
//               die Eigenschaften wie Projectname... sind bei neuen Projekten
//               zu setzen, alternativ kann auf Create ein Loadfromfile() folgen.
constructor TRBProject.Create(UseExpertmode: boolean=false);
begin
  projectfilename := '';
  NextTrackID     := 1;
  Objectlibrary   := '';
  Gauge           := 1435;
  VmaxSlowSignal  := 40;
  ParallelTrackDist := cParalleltrackdist;
  ParallelTrackDistPlatf := cParalleltrackPlatformdist;
  Expertmode := UseExpertmode;
  // das sind owned-Listen, d.h. sie kümmern sich um die Speicherverwaltung der Einzelobjekte
  Dikes  := TObjectlist.Create();
  Walls  := TObjectlist.Create();
  Freeobjects  := TObjectlist.Create();
  Backgrounds := TObjectlist.Create();
  Grounds     := TObjectlist.Create();
  Trains      := TObjectlist.Create();
  Routes      := TObjectlist.Create();
  Timetables  := TObjectlist.Create();
  Stations    := TObjectlist.Create;
  Points      := TObjectlist.Create;
  Connections := TRBConnectionlist.Create;
  Grids       := TObjectlist.Create;
  Signals     := TObjectlist.Create;
  DefaultObjects:=TStringlist.create();
  DefaultObjects.add('stopsign=signs\ne5.b3d');
  DefaultObjects.add('signalpost=signals\signal_post.b3d');
  DefaultObjects.add('stationmarkerstop=marker\stationmarker_stop.bmp');
  DefaultObjects.add('stationmarkerpass=marker\stationmarker_pass.bmp');
{  TrackDefinitions := TStringlist.create();
  TrackDefinitions.add('track0.b3d,2');
  TrackDefinitions.add('brown.b3d,0');
  TrackDefinitions.add('brown_overhead.b3d,2');
  TrackDefinitions.add('grey.b3d,2');
  TrackDefinitions.add('grey_overhead.b3d,1');}
end;

destructor TRBProject.Destroy;
begin
  Clear();
  // enthaltene Objekte werden automatisch gelöscht.
  Signals.free;
  Grids.free;
  Dikes.free;
  Walls.free;
  Freeobjects.free;
  Grounds.free;
  Backgrounds.free;
  Trains.free;
  Routes.free;
  Timetables.free;
  Stations.free;
  Points.free;
  Connections.free;
  DefaultObjects.free;
//  TrackDefinitions.free;
  inherited;
end;

procedure TRBProject.Clear();
var i: integer;
begin
  for i:=0 to Points.count-1 do
    Points[i].free;
  Points.clear;
  for i:=0 to Connections.count-1 do
    Connections[i].free;
  Connections.clear;
//  TrackDefinitions.clear;
end;

// Funktion    : CanSave
// Datum       : 14.7.02
// Autor       : up
// Beschreibung: überprüft, ob das Projekt gespeichert werden kann
//               oder ob nur "save as" funktioniert.
//               Kann verwendet werden, um den Menüpunkt "save" zu enablen.
//               Ein neues Projekt hat nämlich noch keinen Dateinamen, da geht nur save as.
function TRBProject.CanSave(): boolean;
begin
  result := (projectfilename <> '');
end;



// Funktion    : Loadfromfile
// Datum       : 14.7.02
// Autor       : up
// Beschreibung: lädt eine Projektdatei. Im Fehlerfall result=false
// Wichtiger Hinweis: Das TRBProject-Objekt muss vorher frisch erstellt sein, damit die Objektlisten leer sind.
// Diese Funktion leer die Listen nicht, damit sie eventuell auch mal als "hinzuladen" verwendet werden kann!
function TRBProject.LoadFromFile(const filename: string; Parent: TWincontrol): boolean;
var projectfile: TStringlist;
    id,i,j,delta: integer;
    RD: TRBRouteDefinition;
    St: TRBStation;
    P:  TRBPoint;
    C:  TRBConnection;
    O:  TRBObject;
    g:  TRBGrid;
    s:  TRBSchedule;
    sig: TRBSignal;
    n,v: string;
    conn: TRBConnection;
    sl: TStringlist;
begin
  if not fileexists(filename) then begin result := false; exit; end;
  try
  clear;
  if assigned(SetStatusProc) then SetStatusProc('loading...');
  projectfile := TStringlist.Create;
  projectfile.LoadFromFile(filename);
  // Inhalt der Datei in die Eigenschaften einsortieren
  Projectname :=        projectfile.values['projectname'];
  Author      :=        projectfile.values['author'];
  Authoremailaddress := projectfile.values['authoremailaddress'];
  gauge       :=        strtointdef(projectfile.values['gauge'],1435);
  LogoPath    :=        projectfile.values['logopath'];
  HomepageURL :=        projectfile.values['homepageurl'];
  Routefilesdir :=      projectfile.values['routefilesdir'];
  Routefilessubdir :=   projectfile.values['routefilessubdir'];
  DeveloperID :=        strtointdef(projectfile.values['developerid'],0);
  description :=        StringReplace(projectfile.values['description'],'[crlf]',#13#10,[rfReplaceAll]);
  credits     :=        StringReplace(projectfile.values['credits'],'[crlf]',#13#10,[rfReplaceAll]);
  NextTrackID :=        strtointdef(projectfile.values['nexttrackid'],1);
  BackgroundMapfilename:=projectfile.values['BackgroundMapfilename'];
  BackgroundMapScale := strtointdef(projectfile.values['BackgroundMapScale'],1);
  DefaultObjects.CommaText := projectfile.values['defaultobjects'];
  if projectfile.values['ParallelTrackDist']<>'' then
    ParallelTrackDist := strtofloat1(projectfile.values['ParallelTrackDist']);
  if projectfile.values['ParallelTrackDistPlatform']<>'' then
    ParallelTrackDistPlatf := strtofloat1(projectfile.values['ParallelTrackDistPlatform']);
  if projectfile.values['Objectlibrary']<>'' then
    Objectlibrary := projectfile.values['Objectlibrary'];
  // TODO: weitere Eigenschaften

  if assigned(SetStatusProc) then SetStatusProc('loading points...');
  // lade Points
  for i:=0 to projectfile.count-1 do
  begin
    if copy(projectfile[i],1,5)='point' then
    begin
      n := copy(projectfile[i],1,pos('=',projectfile[i])-1);
      v := copy(projectfile[i],length(n)+2,maxint);
      P := TRBPoint.CreateFromCommaString(v);
      Points.add(p);
    end;
  end;

  if assigned(SetStatusProc) then SetStatusProc('loading connections...');
  // lade connections
  for i:=0 to projectfile.count-1 do
  begin
    if copy(projectfile[i],1,4)='conn' then
    begin
      n := copy(projectfile[i],1,pos('=',projectfile[i])-1);
      v := copy(projectfile[i],length(n)+2,maxint);
      C := TRBConnection.CreateFromString(v,points);
      if (c.P1<>nil)and(c.p2<>nil) then
      begin
        // Höhe übertragen
        if c.Height<>0 then
        begin
          c.P1.height := c.height;
          c.height := 0;
        end;
        Connections.add(C);
      end;
    end;
  end;

  // Nachbehandlung Connections. Konvertierung in Version 1.2.
  // falls wallLeft-Strings etc. Zahlen enthalten, diese über die WallList in strings auflösen.
  //if assigned(SetStatusProc) then SetStatusProc('converting from 1.1.x format...');
  for i:=0 to Connections.count-1 do
  begin
    conn := Connections[i] as TRBConnection;
    // ground
    if strtointdef(conn.Ground,-999)<>-999 then
    begin
      sl := TRBGroundTexturelist.create;
      conn.Ground := sl.Values[conn.Ground];
      sl.free;
    end;
    // background
    if strtointdef(conn.backGround,-999)<>-999 then
    begin
      sl := TRBBackgroundTexturelist.Create;
      conn.backGround := sl.Values[conn.backGround];
      sl.free;
    end;
    // poles
    if strtointdef(conn.PolesType,-999)<>-999 then
    begin
      sl := TRBCatenaryPoleList.Create;
      conn.PolesPos := sgn (strtoint(conn.polestype));
      conn.PolesType := sl.Values[ inttostr( abs( strtoint(conn.PolesType) ) )];
      sl.free;
    end;
    // walls, TSO
    sl := TRBWalllist.create;
    if strtointdef(conn.WallLeft,-999)<>-999 then
    begin
      conn.WallLeft := sl.Values[conn.WallLeft];
      conn.WallRight := sl.Values[conn.WallRight];
      conn.TSOLeft := sl.Values[conn.TSOLeft];
      conn.TSORight := sl.Values[conn.TSORight];
    end;
    sl.free;
    // platforms
    if strtointdef(conn.PlatformType,-999)<>-999 then
    begin
      sl := TRBPlatformlist.create;
      conn.PlatformType := sl.Values[conn.PlatformType];
      sl.free;
    end;
    // roofs
    if strtointdef(conn.RoofType,-999)<>-999 then
    begin
      sl := TRBRooflist.create;
      conn.RoofType := sl.Values[conn.RoofType];
      sl.free;
    end;
  end;

  if assigned(SetStatusProc) then SetStatusProc('loading Route Definitions...');
  // lade RouteDefinition
  i:=1;
  while (projectfile.Values['routedefinition'+inttostr(i)+'id']<>'') do
  begin
    RD := TRBRouteDefinition.Create();
    RD.RouteDefinitionID   := strtointdef(projectfile.Values['routedefinition'+inttostr(i)+'id'],0);
    RD.RouteDefinitionname := projectfile.Values['routedefinition'+inttostr(i)+'name'];
    RD.CommaText           := projectfile.Values['routedefinition'+inttostr(i)];
    Routes.add(RD);
    inc(i);
  end;

  if assigned(SetStatusProc) then SetStatusProc('loading stations...');
  // lade Bahnhöfe
  i := 1;
  while (projectfile.Values['station'+inttostr(i)] <>'') do
  begin
    St := TRBStation.Create();
    St.SetFromString(projectfile.Values['station'+inttostr(i)]);
    Stations.Add(St);
    inc(i);
  end;

  if assigned(SetStatusProc) then SetStatusProc('loading free objects...');
  // lade FreeObjects
  i := 1;
  while (projectfile.Values['freeobject'+inttostr(i)] <>'') do
  begin
    O := TRBObject.CreateFromString(projectfile.Values['freeobject'+inttostr(i)]);
    FreeObjects.Add(O);
    inc(i);
  end;

  if assigned(SetStatusProc) then SetStatusProc('loading timetables...');
  // lade Fahrpläne
  i := 1;
  while (projectfile.Values['Timetable'+inttostr(i)] <>'') do
  begin
    s := TRBSchedule.CreateFromString(projectfile.Values['Timetable'+inttostr(i)]);
    for j:=s.RouteDefinitions.Count-1 downto 0 do
    begin
      s.RouteDefinitions.Objects[j] := FindRouteDefinitionByName(s.RouteDefinitions[j]);
      // RD unbekannt: aus Fahrplan löschen
      if s.RouteDefinitions.Objects[j]=nil then
        s.RouteDefinitions.Delete(j);
    end;

    Timetables.Add(s);
    inc(i);
  end;

  if assigned(SetStatusProc) then SetStatusProc('loading grids...');
  // lade grids
  i := 1;
  while (projectfile.Values['grid'+inttostr(i)] <> '') do
  begin
    g := TRBGrid.Create(TRBGridItem);
    g.FillFromString('',projectfile.Values['grid'+inttostr(i)]);
    Grids.add(g);
    inc(i);
  end;

  if assigned(SetStatusProc) then SetStatusProc('loading signals...');
  // lade signale
  i := 1;
  while (projectfile.Values['signal'+inttostr(i)] <> '') do
  begin
    sig := TRBSignal.Createfromstring(projectfile.Values['signal'+inttostr(i)]);
    // knüpfe Connection ans Objekt
    sig.Connection := FindConnectionByID(sig.connectionid);
    if sig.Connection<>nil then
      Signals.add(sig);
    inc(i);
  end;

  if assigned(SetStatusProc) then SetStatusProc('processing...');
  SetGridAngles();

  projectfile.free;
  // setze Projektdateiname für Save-Funktion
  projectfilename := filename;
  result := true;
  except
    result := false;
  end;
  if assigned(SetStatusProc) then SetStatusProc('done.');
end;

// speichert Region, Points+Objects relativ zur linken unteren Ecke der Region
function TRBProject.SaveRegionToFile(const filename,_author,comment: string): boolean;
var regionfile: TStringlist;
    i,j: integer;
    p: TRBPoint;
    c: TRBConnection;
    St: TRBStation;
    o: TRBObject;
    g: TRBGrid;
    Basepoint: TDoublePoint;
begin
  Basepoint.X := min(Currentsituation.SelArea1.x,Currentsituation.SelArea2.x);
  Basepoint.Y := min(Currentsituation.SelArea1.y,Currentsituation.SelArea2.y);
  // now save to _filename
  regionfile := TStringlist.Create;
  regionfile.Values['rbregionfile']       := '1';
  regionfile.values['fromprojectname']    := Projectname;
  regionfile.values['author']             := _Author;
  regionfile.values['comment']            := comment;
  // speichere points
  j:=0;
  for i:=0 to points.count-1 do
  begin
    p := points[i] as TRBPoint;
    if IsDoublePointInRect(P.point,Currentsituation.SelArea1,Currentsituation.SelArea2) then
    begin
      p.Move(-Basepoint.x,-Basepoint.y,0);
      regionfile.values['point'+inttostr(j+1)] := p.GetAsString();
      inc(j);
      p.Move(Basepoint.x,Basepoint.y,0);
    end;
  end;

  // speichere connections
  j:=0;
  for i:=0 to connections.count-1 do
  begin
    c := connections[i] as TRBConnection;
    c.exported := false;
    if IsDoublePointInRect(c.P1.point,Currentsituation.SelArea1,Currentsituation.SelArea2) and
       IsDoublePointInRect(c.P2.point,Currentsituation.SelArea1,Currentsituation.SelArea2) then
    begin
      regionfile.values['conn'+inttostr(j+1)] := c.GetAsString();
      c.exported := true;
      inc(j);
    end;
  end;

  // speichere Bahnhöfe
{  for i:=0 to Stations.count-1 do
  begin
    St := stations[i] as TRBStation;
    regionfile.Values['station'+inttostr(i+1)] := St.GetAsString();
  end;}

  // speichere Objekte
  j:=0;
  for i:=0 to Freeobjects.count-1 do
  begin
    o := FreeObjects[i] as TRBObject;
    // save if bound to connection in region
    c := FindConnectionByID(o.boundtoConnID);
    if(c<>nil)and(c.exported) then
    begin
      regionfile.Values['freeobject'+inttostr(j+1)] := o.getAsString();
      inc(j);
    end
    else
    // or if not bound and in region
    if (o.boundtoConnID=0)and(IsDoublePointInRect(o.point,Currentsituation.SelArea1,Currentsituation.SelArea2)) then
    begin
      // move relative
      o.Move(-Basepoint.x,-Basepoint.y,0);
      regionfile.Values['freeobject'+inttostr(j+1)] := o.getAsString();
      inc(j);
      o.Move(Basepoint.x,Basepoint.y,0);
    end;
  end;

  // speichere Grids
  j:=0;
  for i:=0 to Grids.Count-1 do
  begin
    g := Grids[i] as TRBGrid;
    c := FindConnectionByID(g.RootConnection);
    if IsDoublePointInRect(c.P1.point,Currentsituation.SelArea1,Currentsituation.SelArea2) and
       IsDoublePointInRect(c.P2.point,Currentsituation.SelArea1,Currentsituation.SelArea2) then
    begin
      regionfile.values['grid'+inttostr(j+1)] := g.GetAsString();
      inc(j);
    end;
  end;

  regionfile.savetofile(filename);
  regionfile.free;
end;


// Funktion    : SaveToFile
// Datum       : 14.7.02
// Autor       : up
// Beschreibung: speichert das Projekt unter dem angegebenen Dateinamen.
//               wird keiner übergeben, wird der Name verwendet, unter dem
//               das Projekt geladen wurde. Wenn der fehlt, ist result=false.
function TRBProject.SaveToFile(const filename: string=''): boolean;
var _filename: string;
    projectfile: TStringlist;
    i,id: integer;
    RD: TRBRouteDefinition;
    St: TRBStation;
    p: TRBPoint;
    C: TRBConnection;
    o: TRBObject;
    g: TRBGrid;
    s: TRBSchedule;
    sig: TRBSignal;
begin
  if filename='' then
    _filename := Projectfilename
  else
    _filename := filename;
  if _filename='' then begin result := false; exit; end;

  try
  // now save to _filename
  projectfile := TStringlist.Create;
  // add project components
  projectfile.values['projectname']        := Projectname;
  projectfile.values['application']        := ProgramName + ' ' + VersionString;
  projectfile.values['author']             := Author;
  projectfile.values['authoremailaddress'] := Authoremailaddress;
  projectfile.values['description']        := StringReplace(description,#13#10,'[crlf]',[rfReplaceAll]);
  projectfile.Values['credits']            := StringReplace(credits,#13#10,'[crlf]',[rfReplaceAll]);
  projectfile.Values['homepageurl']        := HomepageURL;
  projectfile.values['gauge']              := inttostr(gauge);
  projectfile.values['developerid']        := inttostr(DeveloperID);
  projectfile.values['nexttrackid']        := inttostr(NextTrackID);
  projectfile.Values['Routefilesdir']      := Routefilesdir;
  projectfile.Values['Routefilessubdir']   := Routefilessubdir;
  projectfile.Values['LogoPath']           := LogoPath;
  projectfile.Values['BackgroundMapfilename'] :=BackgroundMapfilename;
  projectfile.Values['BackgroundMapScale'] := inttostr(BackgroundMapScale);
  projectfile.values['defaultobjects']     := DefaultObjects.commatext;
  projectfile.values['ParallelTrackDist']  := floattostrPoint(ParallelTrackDist);
  projectfile.values['ParallelTrackDistPlatform']  := floattostrPoint(ParallelTrackDistPlatf);
  projectfile.values['Objectlibrary']      := Objectlibrary;

{
  // TODO: Restliche Projekteigenschaften
  // Tracks
  for i:=0 to Tracks.Count-1 do
  begin
    id := (Tracks[i] as TRBTrack).ID;
    projectfile.values['track'+inttostr(id)] := (Tracks[i] as TRBTrack).PropertiesCommaSeparated;
  end;
 }
  // speichere points
  for i:=0 to points.count-1 do
  begin
    p := points[i] as TRBPoint;
    projectfile.values['point'+inttostr(i+1)] := p.GetAsString();
  end;

  // speichere connections
  for i:=0 to connections.count-1 do
  begin
    c := connections[i] as TRBConnection;
    projectfile.values['conn'+inttostr(i+1)] := c.GetAsString();
  end;

  // speichere RouteDefinition
  for i:=0 to Routes.Count-1 do
  begin
    RD := Routes[i] as TRBRoutedefinition;
    projectfile.Values['routedefinition'+inttostr(i+1)+'id'] := inttostr(RD.RouteDefinitionID);
    projectfile.Values['routedefinition'+inttostr(i+1)+'name'] := RD.RouteDefinitionname;
    projectfile.Values['routedefinition'+inttostr(i+1)] := RD.CommaText;
  end;

  // speichere Bahnhöfe
  for i:=0 to Stations.count-1 do
  begin
    St := stations[i] as TRBStation;
    projectfile.Values['station'+inttostr(i+1)] := St.GetAsString();
  end;

  // speichere Objekte
  for i:=0 to Freeobjects.count-1 do
  begin
    o := FreeObjects[i] as TRBObject;
    projectfile.Values['freeobject'+inttostr(i+1)] := o.getAsString();
  end;

  // speichere Fahrpläne - einkommentieren um in Betrieb zu nehmen
  for i:=0 to Timetables.count-1 do
  begin
    s := Timetables[i] as TRBSchedule;
    projectfile.Values['Timetable'+inttostr(i+1)] := s.getAsString();
  end;

  // speichere Grids
  for i:=0 to Grids.Count-1 do
  begin
    g := Grids[i] as TRBGrid;
    projectfile.values['grid'+inttostr(i+1)] := g.GetAsString();
  end;

  // speichere Signale
  for i:=0 to signals.Count-1 do
  begin
    sig := signals[i] as TRBSignal;
    projectfile.values['signal'+inttostr(i+1)] := sig.GetAsString();
  end;


{  // speichere TrackDefinitions
  for i:=0 to TrackDefinitions.count-1 do
  begin
    projectfile.values['trackdefinition'+inttostr(i+1)] := TrackDefinitions[i];
  end;
 }
  // save
  projectfile.SaveToFile(_filename);
  projectfile.Free;
  result := true;
  except
    result := false;
  end;

end;




function TRBProject.FindPointByID(id: integer): TRBPoint;
var i: integer;
begin
  for i:=0 to Points.count-1 do
  begin
    if(Points[i] as TRBPoint).id = id then begin result := Points[i] as TRBPoint; exit; end;
  end;
  result := nil;
end;

function TRBProject.FindConnectionByID(id: integer): TRBConnection;
begin
  if Connections=nil then
    result :=nil
  else
    result := Connections.FindByID(id);
end;

function TRBProject.FindConnectionsAtPoint(point: TRBPoint; connlist: TObjectList; NotThis: TRBConnection): integer;
begin
  result := Connections.FindConnectionsAtPoint(point,connlist,notThis);
end;

function TRBProject.FindPointNearPoint(point: TDoublePoint; radius: double): TRBPoint;
var i: integer;
begin
  for i:=0 to Points.count-1 do
  begin
    if Distance((Points[i] as TRBPoint).point,point)<radius then
    begin
      result := (Points[i] as TRBPoint);
      exit;
    end;
  end;
  result := nil;
end;

function TRBProject.FindConnectionFromTo(p1,p2: TRBPoint): TRBConnection;
var connlist: TRBConnectionlist;
    j: integer;
    conn: TRBConnection;
begin
  result := nil;
  connlist := TRBConnectionlist.Create;
  connlist.OwnsObjects := false;
  // ermittle alle Tracks an diesem Punkt
  if FindConnectionsAtPoint(p1,connlist,nil)<>0 then
  begin
    for j:=0 to connlist.count-1 do
    begin
      conn := connlist.GetConnection(j);
      if ((conn.P1=p1)and(conn.p2=p2))or((conn.P1=p2)and(conn.p2=p1)) then
      begin
        result := conn;
        exit;
      end;
    end;
  end;
  connlist.Free;
end;

function TRBProject.FindConnectionAtPointInRouteDefinition(point: TRBPoint; RDID: integer; NotThisOne: TRBConnection): TRBConnection;
var connlist: TObjectlist;
    j: integer;
begin
  result := nil;
  connlist := TObjectlist.Create;
  connlist.OwnsObjects := false;
  // ermittle alle Tracks an diesem Punkt
  if FindConnectionsAtPoint(point,connlist,NotThisOne)<>0 then
  begin
    for j:=connlist.count-1 downto 0 do
    begin
      // nicht in gegebener RouteDefinition oder unerwünscht: entfernen
      if not IsTrackInRouteDefinition(connlist[j] as TRBConnection,RDID) then
        connlist.delete(j);
    end;
  end;
  // Erfolg nur, wenn genau ein Track übrig bleibt
  if connlist.count=1 then result := connlist[0] as TRBConnection;
  connlist.Free;
end;

function TRBProject.GetMaxRouteDefinitionID: integer;
var i,maxid: integer;
    RD: TRBRouteDefinition;
begin
  maxid := 1;
  for i:=0 to Routes.Count-1 do
  begin
    RD := Routes[i] as TRBRoutedefinition;
    if RD.RouteDefinitionID>maxid then maxid := RD.RouteDefinitionID;
  end;
  result := maxid;
end;

function TRBProject.FindRouteDefinitionByID(id: Cardinal): TRBRouteDefinition;
var i: integer;
begin
  for i:=0 to Routes.count-1 do
  begin
    if(Routes[i] as TRBRoutedefinition).RouteDefinitionID = id then
    begin
      result := Routes[i] as TRBRoutedefinition;
      exit;
    end;
  end;
  result := nil;
end;

function TRBProject.FindRouteDefinitionByName(const n: string): TRBRouteDefinition;
var i: integer;
begin
  for i:=0 to Routes.count-1 do
  begin
    if(Routes[i] as TRBRoutedefinition).RouteDefinitionname = n then
    begin
      result := Routes[i] as TRBRoutedefinition;
      exit;
    end;
  end;
  result := nil;
end;

// Funktion    : IsTrackInRouteDefinition
// Datum       : 8.8.02
// Autor       : up
// Beschreibung: siehe Funktionsname. Wird RDID nicht übergeben, gilt die aktuelle RouteDefinition.
function TRBProject.IsTrackInRouteDefinition(track :TRBConnection; RDID: Cardinal): boolean;
var RouteDefID: Cardinal;
    RD: TRBRouteDefinition;
begin
  result := false;
  if RDID=0 then
    RouteDefID := Currentsituation.CurrentRouteDefinitionID
  else
    RouteDefID := RDID;
  RD := FindRouteDefinitionByID(RouteDefId);
  if RD=nil then exit;
  result := (RD.IndexOf(inttostr(track.ID))>=0);
end;

procedure TRBProject.AddTrackToCurrentRouteDefinition(track: TRBCOnnection);
var RouteDefID: Cardinal;
    RD: TRBRouteDefinition;
begin
  RouteDefID := Currentsituation.CurrentRouteDefinitionID;
  RD := FindRouteDefinitionByID(RouteDefId);
  if RD=nil then exit;
  RD.AddTrack(Track.ID);
end;

procedure TRBProject.DeleteTrackFromCurrentRouteDefinition(track: TRBCOnnection);
var RouteDefID: Cardinal;
    RD: TRBRouteDefinition;
begin
  RouteDefID := Currentsituation.CurrentRouteDefinitionID;
  RD := FindRouteDefinitionByID(RouteDefId);
  if RD=nil then exit;
  RD.DeleteTrack(Track.ID);
end;

// Funktion    : GetRouteDefinitionsAsNames
// Datum       : 8.8.02
// Autor       : up
// Beschreibung: erzeugt eine Liste der RouteDefinition-Namen, z.B. um eine
//               Auswahlbox zu füllen, in der man beim Export auswählt, welche Route man exportieren will
//               destination muss existieren, die Liste wird zunächst geleert.
//               Im objects-Array von destination werden Verweise auf die entspr. Objekte abgelegt.
// Beispiel    : GetRouteDefinitionsAsNames(Combobox1.items);
//               ...
//               nach Auswahl: Combobox.items.objects[Combobox.itemindex] as TRBRouteDefinition
//               enthält die gewählte RouteDefinition, die wiederum in ihren Einzelstrings
//               die enthaltenen Tracks haben: RouteDefinition[i] sind die in Strings konvertierte Track-IDs
procedure TRBProject.GetRouteDefinitionsAsNames(destination: TStrings);
var i: integer;
    RD: TRBRouteDefinition;
begin
  if destination=nil then exit;
  destination.Clear();
  // speichere RouteDefinition
  for i:=0 to Routes.Count-1 do
  begin
    RD := Routes[i] as TRBRoutedefinition;
    destination.addObject(RD.GetTitle,RD);
  end;
end;

function TRBProject.GetStationByName(const stationname: string): TRBStation;
var i: integer;
    St: TRBStation;
begin
  for i:=0 to Stations.Count-1 do
  begin
    St := Stations[i] as TRBStation;
    if St.StationName = Stationname then begin result := St; end;
  end;
  result := nil;
end;

function TRBProject.GetStationByIndex(index: integer): TRBStation;
begin
  if (index>=stations.count)or(index<0) then
    result := nil
  else
    result := Stations[index] as TRBStation;
end;

function TRBProject.GetStationCount: integer;
begin
  result := Stations.Count;
end;

function TRBProject.GetPointIDMax: integer;
var i,maxid: longint;
begin
  maxid := 0;
  for i:=0 to points.count-1 do
  begin
    if (points[i] as TRBPoint).id>maxid then maxid := (points[i] as TRBPoint).id;
  end;
  result := maxid;
end;

procedure TRBProject.AddPoint(p: TRBPoint);
begin
  p.id := GetPointIDMax +1;
  points.add(p);
end;

function TRBProject.AddGrid(rootconnection: TRBConnection): TRBGrid;
var newgrid: TRBGrid;
begin
  newgrid := TRBGrid.Create(TRBGridItem);
  newgrid.GridName := 'grid at conn-ID ' + inttostr(rootconnection.id);
  newgrid.RootConnection := rootconnection.id;
  newgrid.GridAngle := rootconnection.GetAngle(nil);
  newgrid.AddConnection(rootconnection.id,0,0);
  grids.Add(newgrid);
  result := newgrid;
end;

function TRBProject.DeleteGridByName(const n: string): boolean;
var i: integer;
begin
  for i:=0 to grids.count-1 do
  begin
    if (Grids[i] as TRBGrid).GridName=n then
    begin
      Grids.Delete(i);
      result := true;
      exit;
    end;
  end;
  result := false;
end;


function TRBProject.GetConnectionParentGrid(connid: integer): TRBGrid;
var i: integer;
begin
  result := nil;
  for i:=0 to grids.Count-1 do
  begin
    if (grids[i] as TRBGrid).IsConnInGrid(connid) then
      result := grids[i] as TRBGrid;
  end;
end;

function TRBProject.SnapPointToGrid(point: TRBPoint): boolean;
var connlist: TRBConnectionlist;
    i: integer;
    grid: TRBGrid;
begin
  connlist := TRBConnectionlist.create();
  connlist.OwnsObjects := false;
  FindConnectionsAtPoint(point,connlist);
  for i:=0 to connlist.count-1 do
  begin
    grid := GetConnectionParentGrid(connlist.GetConnection(i).id);
    if grid<>nil then
    begin
      SnapToGrid(connlist.GetConnection(i),grid);
      connlist.free;
      result := true;
      exit;
    end;
  end;
  connlist.free;
  result := false;
end;

procedure TRBProject.SnapToGrid(conn: TRBConnection; grid: TRBGrid);
var griditem: TRBGriditem;
    i,best: integer;
    root: TRBConnection;
    p1,p2,gridconst: TDoublePoint;
    p: array[0..5] of TDoublePoint;
    d,bestdist: double;
begin
  griditem := grid.GetGridItemByID(conn.id);
  if griditem=nil then exit; // gehört nicht zum Grid
  root := FindConnectionByID(grid.RootConnection);
  gridconst.x := cParalleltrackdist;
  gridconst.y := 25;
  // berechne snap-points: Start und Ende...
  p[0] := grid.GetGridPoint(griditem.x,griditem.z,root.P1.point,gridconst);
  p[1] := grid.GetGridPoint(griditem.x,griditem.z+1,root.P1.point,gridconst);
  // Eckpunkte Start
  p[2] := grid.GetGridPoint(griditem.x+0.5,griditem.z,root.P1.point,gridconst);
  p[3] := grid.GetGridPoint(griditem.x-0.5,griditem.z,root.P1.point,gridconst);
  // Eckpunkte Ende
  p[4] := grid.GetGridPoint(griditem.x+0.5,griditem.z+1,root.P1.point,gridconst);
  p[5] := grid.GetGridPoint(griditem.x-0.5,griditem.z+1,root.P1.point,gridconst);
  // snappen p1
  best := -1; bestdist := 9999;
  for i:=0 to 5 do
  begin
    d := distance(p[i],conn.p1.point);
    if(d<bestdist) then
    begin
      best := i;
      bestdist := d;
    end;
  end;
  if best<>-1 then
    conn.p1.point := p[best];
  // p2
  best := -1; bestdist := 9999;
  for i:=0 to 5 do
  begin
    d := distance(p[i],conn.p2.point);
    if(d<bestdist) then
    begin
      best := i;
      bestdist := d;
    end;
  end;
  if best<>-1 then
    conn.p2.point := p[best];
end;

procedure TRBProject.SetGridAngles();
var i: integer;
    conn: TRBConnection;
    grid: TRBGrid;
begin
  for i:=0 to grids.Count-1 do
  begin
    grid := grids[i] as TRBGrid;
    conn := FindConnectionByID(grid.RootConnection);
    if conn<>nil then
      grid.GridAngle := conn.GetAngle(nil);
  end;
end;

function TRBProject.GetNearestGrid(p: TDoublePoint): TRBGrid;
var i,j: integer;
    mindist: double;
    p2: TDoublePoint;
    conn: TRBConnection;
begin
  result := nil;
  j := -1;
  mindist := 99999;
  for i:=0 to grids.Count-1 do
  begin
    conn := FindConnectionByID((grids[i] as TRBGrid).RootConnection);
    if conn<>nil then
    begin
      if Distance(p,conn.P1.point) < mindist then
      begin
        j := i;
        mindist := Distance(p,conn.P1.point);
      end;
    end;
  end;
  if j<>-1 then  result := grids[j] as TRBGrid;
end;

procedure TRBProject.AddConnection(c: TRBConnection);
var i,maxid: longint;
begin
  maxid := 0;
  for i:=0 to connections.count-1 do
  begin
    if (connections[i] as TRBConnection).id>maxid then maxid := (connections[i] as TRBConnection).id;
  end;
  c.id := maxid +1;
  connections.add(c);
end;

procedure TRBProject.DeletePoint(p: TRBPoint);
var i: integer;
begin
  // first delete all connections from or to this point
  for i:= connections.count-1 downto 0 do
  begin
    if ((Connections[i] as TRBConnection).P1=p)
    or ((Connections[i] as TRBConnection).P2=p) then
    begin
      if currentsituation.CurrentConnection=(Connections[i] as TRBConnection) then
        currentsituation.CurrentConnection := nil;
      connections.delete(i);
    end;
  end;
  for i:=0 to points.count-1 do
  begin
    if points[i] as TRBPoint=p then
    begin
      points.delete(i);
      exit;
    end;
  end;
end;

function TRBProject.DeleteConnection(c: TRBConnection): boolean;
var i: integer;
begin
  // Track aus allen Grids entfernen
  for i:=Grids.count-1 downto 0 do
  begin
    (Grids[i] as TRBGrid).DeleteConnection(c.id);
    if c.id=(Grids[i] as TRBGrid).RootConnection then
    begin
      MessageDlg('This is the root connection of a grid and cannot be deleted. '+#13+#10+'Delete the grid first.', mtError, [mbCancel], 0);
      result := false;
      exit;
    end;
  end;

  // bound objects entfernen
  for i:=Freeobjects.Count-1 downto 0 do
  begin
    if (Freeobjects[i] as TRBObject).boundtoConnID=c.id then
      DeleteObject(Freeobjects[i] as TRBObject);
  end;

  DeleteTrackFromCurrentRouteDefinition(c);

  for i:=0 to Connections.count-1 do
  begin
    if Connections[i] as TRBConnection=c then
    begin
      connections.delete(i);
      result := true;
      exit;
    end;
  end;

  result := false;
end;

// Funktion: ExportPreprocess
// Autor   : up
// Datum   : 10.10.02
// Beschr. : Erledigt Vorarbeiten für den Export, dh. bringt gewisse Sachen in Ordnung.
// Ergebnis: false, falls die Arbeit scheiterte und der Export nicht durchgeführt werden kann.
function TRBProject.ExportPreprocess(): boolean;
var i,j: integer;
    RD: TRBRouteDefinition;
begin
  result := true;
  // connections checken
  for i:=0 to connections.count-1 do
  begin
    (Connections[i] as TRBConnection).ExportPreprocess();
  end;
  // routedefinitions checken. eventuell nicht mehr existierende tracks rauswerfen
  for i:=0 to Routes.Count-1 do
  begin
    RD := Routes[i] as TRBRouteDefinition;
    for j:=RD.Count-1 downto 0 do
    begin
      if FindConnectionByID(strtointdef(RD[j],0))=nil then
        RD.delete(j);
    end;

  end;
  for i:=0 to Stations.count-1 do
  begin
    (Stations[i] as TRBStation).exported := false;
  end;
end;

function TRBProject.GetStationByTrackID(id: integer): TRBStation;
var i: integer;
begin
  result := nil;
  if stations=nil then exit;
  for i:=0 to Stations.count-1 do
  begin
    if (stations[i] as TRBStation).TrackIDIsInStation(id) then
    begin
      result := stations[i] as TRBStation;
      exit;
    end;           
  end;

end;

// Funktion: PointInSegment
// Autor   : up
// Datum   : 21.10.02
// Beschr. : Trigonometrie-Keule! Es wird ermittelt, ob p3 in einem Rechteck liegt,
// welches durch die Verbindung von p1 und p2 und einer beidseitigen Breite l definiert ist,
// also verdreht in der Horizontalebene liegt. Es handelt sich sozusagen um den Bereich
// rechts und links der Strecke |p1p2| bis zu l Meter.
// Rückgabe: true, wenn p3 in dem Rechteck liegt.
// Parameter: a ist der Abstand von der Grundlinie zu p3, wobei 0 bedeutet, dass er
// direkt auf gleicher Höhe (in Fahrtrichtung) von p1 liegt und 1, dass er auf Höhe von p2 liegt.
// b ist der rechtwinklige Abstand von der Strecke |p1p2| in Einheiten von l, d.h. bei b=1
// liegt p3 genau l Meter von der Strecke |p1p2| senkrecht entfernt, und zwar in Fahrtrichtung rechts
// bei -1 links, bei 0 genau auf der Strecke.
// a dient zur Berechnung der Richtungskoordinate Z: Z=a*Länge(p1p2)+Z(P1)
// b dient zur Berechnung der seitlichen Verschiebung Vx: Vx=b*l
function TRBProject.IsPointInSegment(p1,p2,p3: TDoublePoint; l: integer; var a,b: double): boolean;
var alpha: double;
begin
  result := false;
  if Distance(p1,p2)=0 then exit;
  alpha := arcsin((p2.y-p1.y)/Distance(p1,p2)); // Bogenmaß!
  a := (sin(alpha)*(p3.y-p1.y)-cos(alpha)*(p3.x-p1.x))
      /(sin(alpha)*(p2.Y-p1.y)-cos(alpha)*(p2.X-p1.x));

  if (alpha>0.95*pi/2)or(alpha<-0.95*pi/2) then
    b := (p3.X-p1.x-a*(p2.X-p1.x))/(l*sin(alpha))
  else
    b := (p3.y-p1.y-a*(p2.y-p1.y))/(l*cos(alpha));

  result := (a>=0)and(a<=1)and(b>=-1)and(b<=1);

end;

// Funktion: GetTracksInSegment
// Autor   : up
// Datum   : 21.10.02
// Beschr. : erzeugt in Tracks (muss existieren!) eine Liste aller Tracks, die mindestens einen Punkt im seitlichen
// Bereich haben, d.h. beiderseits der Strecke |p1p2| bis zu einer Entfernung von l Metern.
// NotThisOne wird ausgeschlossen. Gibt Anzahl der gefundenen Tracks zurück.
function TRBProject.GetTracksInSegment(p1,p2: TDoublePoint; l: integer; Tracklist: TObjectlist; NotThisOne: TRBConnection): integer;
var i: integer;
    conn: TRBConnection;
    a,b: double;
begin
  result := 0;
  if Tracklist=nil then exit;
  Tracklist.Clear();
  for i:=0 to Connections.Count-1 do
  begin
    conn := Connections[i] as TRBConnection;
    if conn<>notThisOne then
    begin
      if (IsPointInSegment(p1,p2,conn.P1.point,l,a,b))
       or(IsPointInSegment(p1,p2,conn.P2.point,l,a,b)) then
      begin
        Tracklist.add(conn);
      end;
    end;
  end;
  result := Tracklist.count;
end;

procedure TRBProject.AddObject(o: TRBObject);
begin
  FreeObjects.Add(o);
end;

procedure TRBProject.DeleteObject(o: TRBObject);
var i: integer;
begin
  i := FreeObjects.IndexOf(o);
  if i>=0 then
    Freeobjects.Delete(i);
end;


procedure TRBProject.AddToSameRouteDefinitionAs(newconn,oldconn:TRBConnection);
var i: integer;
    RD: TRBRouteDefinition;
begin
  for i:=0 to Routes.count-1 do
  begin
    RD := Routes[i] as TRBRouteDefinition;
    if RD.ContainsTrack(oldconn.id) then
      RD.AddTrack(newconn.id);
  end;
end;

procedure TRBProject.DeletefromAllRouteDefinitions(conn: TRBConnection);
var i: integer;
    RD: TRBRouteDefinition;
begin
  for i:=0 to Routes.count-1 do
  begin
    RD := Routes[i] as TRBRouteDefinition;
    if RD.ContainsTrack(conn.id) then
      RD.DeleteTrack(conn.id);
  end;
end;

function TRBProject.StationIsInRouteDefinition(sta: TRBStation; const platf: string; RD: TRBRouteDefinition): boolean;
var id: integer;
begin
  id := sta.GetTrackIDByPlatformNumber(platf);
  result := RD.ContainsTrack(id);
end;

procedure TRBProject.GetStationPlatformListForRouteDefinition(RD: TRBRouteDefinition; sl: TStrings);
var i,j: integer;
    sta: TRBStation;
    pl: TStringlist;
begin
  pl := TStringlist.create;
  for i:=0 to Stations.count-1 do
  begin
    sta := Stations[i] as TRBStation;
    pl.clear;
    sta.GetPlatformNumbers(pl);
    for j:=0 to pl.count-1 do
    begin
      if StationIsInRouteDefinition(sta,pl[j],RD) then
      begin
        sl.add(sta.StationName + '|' + pl[j]);
      end;
    end;
  end;
  pl.free;
end;

procedure TRBProject.GetStationListForRouteDefinition(RD: TRBRouteDefinition; sl: TStrings);
var i,j: integer;
    sta: TRBStation;
    pl: TStringlist;
begin
  pl := TStringlist.create;
  for i:=0 to Stations.count-1 do
  begin
    sta := Stations[i] as TRBStation;
    pl.clear;
    sta.GetPlatformNumbers(pl);
    for j:=0 to pl.count-1 do
    begin
      if StationIsInRouteDefinition(sta,pl[j],RD) then
      begin
        if sl.indexof(sta.Stationname)<0 then
          sl.add(sta.StationName);
      end;
    end;
  end;
  pl.free;
end;

procedure TRBProject.GetStationListForRouteDefinitions(RDlist: TStrings; sl: TStrings);
var i,j,k: integer;
    sta: TRBStation;
    pl: TStringlist;
begin
  pl := TStringlist.create;
  for i:=0 to Stations.count-1 do
  begin
    sta := Stations[i] as TRBStation;
    pl.clear;
    sta.GetPlatformNumbers(pl);
    for j:=0 to pl.count-1 do
    begin
      for k:=0 to RDList.count-1 do
      begin
        if StationIsInRouteDefinition(sta,pl[j],RDList.objects[k] as TRBRouteDefinition) then
        begin
          if sl.indexof(sta.Stationname)<0 then
            sl.add(sta.StationName);
        end;
      end;
    end;
  end;
  pl.free;
end;

// Funktion: GetTrainByName
// Autor   : u
// Datum   : 22.8.03
// Beschr. : erzeugt ein TRBTrain-Objekt oder nil im Fehlerfall.
// Hinweis : Das Objekt muss vom Aufrufer nach Benutzung mit .free freigegeben werden.
function TRBProject.GetTrainByName(const trainname: string): TRBTrain;
var s: string;
begin
  result := nil;
  s := FormOptions.BVE_Folder+'\Train\'+TrainName;
  if not fileexists(s+'\train.dat') then exit;
  result := TRBTrain.Create();
  result.loadfromfile(s+'\train.dat');
end;


function TRBProject.ImportRegionFromFile(const filename: string): boolean;
var regionfile: TStringlist;
    i,j,p1id,p2id,id_alt,id_neu: integer;
    n,v: string;
    p: TRBPoint;
    C: TRBConnection;
    O: TRBObject;
    g: TRBGrid;
    gi: TRBGridItem;
    point_id: array of integer;
    conn_id: array of integer;
begin
  if not fileexists(filename) then exit;

  regionfile:= TStringlist.create;
  regionfile.loadfromfile(filename);

  // points laden, neue IDs vergeben, alte merken (Index), move
  if assigned(SetStatusProc) then SetStatusProc('loading points...');
  // lade Points
  for i:=0 to regionfile.count-1 do
  begin
    if copy(regionfile[i],1,5)='point' then
    begin
      n := copy(regionfile[i],1,pos('=',regionfile[i])-1);
      v := copy(regionfile[i],length(n)+2,maxint);
      P := TRBPoint.CreateFromCommaString(v);
      id_alt := p.id;
      p.Move(Currentsituation.Cursor.x,Currentsituation.Cursor.y,0);
      AddPoint(p); // erzeugt auch neue ID
      // TODO: Undo-Action
      id_neu := p.id;
      // index
      if length(point_id)<id_alt+1 then setlength(point_id,id_alt+1);
      point_id[id_alt] := id_neu;
    end;
  end;

  // connections laden, anhand Index den richtigen Points zuweisen, neue IDs vergeben, alte merken (Index)
  if assigned(SetStatusProc) then SetStatusProc('loading connections...');
  // lade connections
  for i:=0 to regionfile.count-1 do
  begin
    if copy(regionfile[i],1,4)='conn' then
    begin
      n := copy(regionfile[i],1,pos('=',regionfile[i])-1);
      v := copy(regionfile[i],length(n)+2,maxint);
      C := TRBConnection.CreateFromString(v,nil);
      p1id := strtointdef(StrGetToken(v,',',2),0);
      C.P1 := FindPointByID(point_id[p1id] );
      p2id := strtointdef(StrGetToken(v,',',3),0);
      C.P2 := FindPointByID(point_id[p2id] );
      id_alt := C.id;
      AddConnection(c);
      id_neu := C.id;
      // index
      if length(conn_id)<id_alt+1 then setlength(conn_id,id_alt+1);
      conn_id[id_alt] := id_neu;
    end;
  end;

  // Objekte laden, move
  if assigned(SetStatusProc) then SetStatusProc('loading free objects...');
  // lade FreeObjects
  i := 1;
  while (regionfile.Values['freeobject'+inttostr(i)] <>'') do
  begin
    O := TRBObject.CreateFromString(regionfile.Values['freeobject'+inttostr(i)]);
    // bound objecte auflösen
    if O.boundtoConnID>0 then
      O.boundtoConnID := conn_id[O.boundtoConnID]
    else
      // relativ zum Cursor setzen
      O.Move(Currentsituation.Cursor.x,Currentsituation.Cursor.y,0);
    FreeObjects.Add(O);
    inc(i);
  end;

  // Grids laden, anhand Conn-Index die richtigen Connection-IDs zuordnen
  if assigned(SetStatusProc) then SetStatusProc('loading grids...');
  // lade grids
  i := 1;
  while (regionfile.Values['grid'+inttostr(i)] <> '') do
  begin
    g := TRBGrid.Create(TRBGridItem);
    g.FillFromString('',regionfile.Values['grid'+inttostr(i)]);
    g.RootConnection := conn_id[g.RootConnection];
    g.GridAngle := findconnectionById(g.RootConnection).GetAngle(nil);
    for j:=0 to g.count-1 do
    begin
      gi := g.Items[j] as TRBGridItem;
      gi.id := conn_id[gi.id];
    end;
    // TODO: prüfen of g.gridname schon vergeben ist, dann umbenennen
    Grids.add(g);
    inc(i);
  end;

  regionfile.free;

end;

procedure TRBProject.SetPointsNotTurned;
var i: integer;
begin
  for i:=0 to Points.count-1 do
  begin
    (Points[i] as TRBPoint).turned := false;
  end;
end;

function TRBProject.DeleteSignalByName(const n: string): boolean;
var i: integer;
begin
  for i:=0 to signals.count-1 do
  begin
    if (signals[i] as TRBSignal).Name=n then
    begin
      signals.Delete(i);
      result := true;
      exit;
    end;
  end;
  result := false;
end;

procedure TRBProject.ClearArea(area1,area2: TDoublePoint);
var i: integer;
begin
  for i:=points.count-1 downto 0 do
  begin
    if IsDoublePointInRect( (points[i] as TRBPoint).point,area1,area2) then
    begin
      DeletePoint(points[i] as TRBPoint);
    end;
  end;

  for i:=Freeobjects.Count-1 downto 0 do
  begin
    if IsDoublePointInRect( (freeobjects[i] as TRBobject).point,area1,area2) then
    begin
      DeleteObject(freeobjects[i] as TRBObject);
    end;
  end;
end;

end.
