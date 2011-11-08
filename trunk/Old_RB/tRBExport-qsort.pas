unit tRBExport;

interface

uses
uRBProject, tmain, Classes, Math, SysUtils, DateUtils, contnrs, forms,
uRBConnection, uRBPoint, uRBConnectionList,
uRBTrackTexturelist, uRBGroundTexturelist,uRBBackgroundTexturelist, uRBPlatformlist,
uRBCatenaryPoleList, uRBObject, uRBWallList, uRBRooflist,
uRBTrackDefinition, uTrackTypes, uRBGrid,
uRBRouteDefinition, uRBStation, uEditorFrame, uTools, uGlobalDef,
tRBTimetable, uRBTrain, uRBSignal, uRBTrackObject,
uRBExportTimetable;

const
//  FormOptions.MaxCurveSmooth = 4000; // bei angeschaltetem smoothing werden Kurven mit größeren Radien begradigt
  cMaxTrackXOffset = 100; // Gleise, die weiter als 100 m vom Hauptgleis liegen, enden
  cMaxTrackOffsetCrack = 10; // Abstand, bis zu dem der GleisZwischenraum mit "Crack" gefüllt wird
//  cMaxSegmentsAfterEnd = 25;
  maxcommadigits = 4;

type
  // Objekt zum Zwischenspeichern von Exportdetails
  // so können Tracks besser aneinander gefügt werden
  TSecTrackExportInfo= class(TObject)
    ID: integer;
    track: TRBConnection;
    trackno: integer;
    secstart,secend,secstartx,secendx: integer;
    backwards: boolean;
    constructor Create(aTrack: TRBConnection; aTrackno,asecstart,asecend,asecstartx,asecendx: integer);
  end;

  TRBExport_Mod= class(TObject)
   protected
    FSmooth: boolean;
    GroundTextureList: TRBGroundTexturelist;
    WallList: TRBWallList;
    BackgroundTextureList: TRBBackgroundTexturelist;
    TrackTexturelist: TRBTrackTexturelist;
    Platformlist: TRBPlatformlist;
    Rooflist: TRBRooflist;
    CatenaryPoleList: TRBCatenaryPoleList;
    FPoints: TObjectlist;
    FTimetable: TRBExportTimetable;
    FObjCount: integer;
    FConnections,
    FPrimaryConnections: TRBConnectionList;
    currentSecTrackNumber,
    FreeObjID_Other,
    FreeObjID_Stopsign: integer;
    UsedTrackObjects,
    UsedGrounds,
    UsedWalls,
    UsedBackgrounds,
    UsedFreeObj,
    UsedPlatforms,
    UsedRoofs,
    UsedPoles,
    Header,RouteFreeObj: Tstringlist;
    StartIndex,NextIndex: integer;
    procedure AddObjectToFilelist(const folder,objfile: string);
    procedure ExportHeader(ExportInterface: TStringList);
    procedure ExportTrainSection(ExportInterface: TStringlist; Train:String);
    procedure ExportObjectSection(ExportInterface:TStringList);
    procedure ExportObjectSectionPass2(dest: TStrings);
    procedure ExportRailwaySection(ExportInterface:TStringList; direction:Integer);
    procedure ExportSecondaryTracks(starttrack: TRBConnection; exportedTracks: TRBConnectionlist; RoutePart: TStringlist; direction: integer);
    procedure GetFromTo(Track,NextTrack: TRBConnection; var Pos1,Pos2: TRBPoint);
    procedure TrackPropertiesCmd(Track: TRBConnection; zposition: double; trackno,direction: integer; RoutePart: TStrings; var prevpolestype: string);
    function CmdRailType(distance: double; tracknumber,texture: integer; height: double): string;
    function CmdForm(distance: double; tracknumber,PlatformPos: integer; const roof,platformtype: string): string;
    function CmdDike(distance: double; tracknumber,side: integer; const wall: string): string;
    function CmdDikeEnd(distance: double; tracknumber: integer): string;
    function CmdWall(distance: double; tracknumber,side: integer; const wall: string): string;
    function CmdWallEnd(distance: double; tracknumber: integer): string;
    function CmdFreeObj(distance: double; tracknumber,objid: integer; xoffset,height,angle: double): string;
    function CmdStop(distance: double; side: integer): string;
    function CmdPoles(distance: double; tracknumber,trackcount,side,interval: integer; const poletype: string): string;
    function CmdPoleEnd(distance: double; tracknumber: integer): string;
    function CmdCrack(distance: double; tracknumber1,tracknumber2,texture: integer): string;
    function CmdPitch(distance: double; promille: integer): string;
    function CmdSecondaryRailSegmentStart(startdistance,startx: double; trackno: integer; height: double; texture,id: integer; switch_possible: boolean): string;
    function CmdSecondaryRailSegmentCmdOnly(startdistance: double; trackno: integer): string;
    function CmdSecondaryRailSegmentEnd(enddistance,endx: double; trackno: integer; height: double): string;
    function CmdCurve(distance,curve,railheight: double): string;
    function CmdMarker(distance,duration: double; const filename: string): string;
    function getSecTrackOffset(routePart: TStringlist; z: double; trackno: integer): double;
    procedure SecSwitchCorrection(RoutePart: TStringlist; last_z: double; var b: double);
    function FindExportedTrack(list: TObjectlist; atrack: TRBConnection): TSecTrackExportInfo; overload;
    function FindExportedTrack(list: TObjectlist; p: TRBPoint): TSecTrackExportInfo; overload;
    function GetMatchingExportedTrack(list: TObjectlist; p: TRBPoint; var z,x,trackno: integer): boolean;
    procedure CopyConnections();
    procedure ImproveConnections();
    procedure ImproveConnections25();
    procedure ImproveConnection(connstart: TRBConnection; seglen: integer=0);
    function SetRouteConnectionsOrientations(var connlist: TRBConnectionlist; _startindex: integer; var direction: integer): boolean;
    function TrackObjID(texture,len: integer; catenary: boolean): integer;
    procedure FindStations(var direction: integer);
    function GetTrackTypeIndex(tracktype,curve: integer): integer;
    function TrackTypeHasSwitch(tracktype: integer): boolean;
    function TrackTypeSwitchObject(tracktype: integer; _dir,_set: TSwitchDirection): string;
    function GetGroundIndex(const ground: string): integer;
    function GetBackgroundIndex(const background: string): integer;
    function GetWallIndex(const wall: string): integer;
    function GetPlatformIndex(const platformname: string): integer;
    function GetRoofIndex(const roofname: string): integer;
    function GetFreeobjIndex(const folder,objname: string): integer; overload;
    function GetFreeobjIndex(const folder,objname,postfix: string): integer; overload;
    function GetFreeobjIndex(const completeobjname: string): integer; overload;
    function GetPoleIndex(pole: string): integer;
    procedure Paralleltrack(var dist: double);
    function SecTrackNumberPossibleAt(Routepart: TStringlist; SecTrackNumber: integer; last_z: double): boolean;
    function ParseRouteCmdRail(const cmd: string; var z: double; var trn: integer): boolean;
   public
    GetFromProject:TRBProject;
    basepath,subdir,objpath,
    Timetable: string;
    BVE4,Night: boolean;
    filelist: TStrings;
    Exportfile,
    Credits: TStringlist;
    Statuslines: TStrings;
    StartStation,
    NextStation: TRBStation;
    DepartureTime: TDateTime;
    DrawConnections: TRBConnectionListProc;
    TrainInterval,
    badSecTrackNumbers: integer;
    dest_reached: boolean;
    PassStations,
    FExportRDs: TStrings;
    ExportSchedule: TRBSchedule;
    Train: TRBTrain;
    constructor Create(smooth: boolean);
    destructor Destroy;
    procedure ExportToCsv(_Train, asubdir: String; Routes: TStrings);
   end;


implementation

uses toptions, texport, Dialogs;

constructor TSecTrackExportInfo.Create(aTrack: TRBConnection; aTrackno,asecstart,asecend,asecstartx,asecendx: integer);
begin
  Track := aTrack;
  ID := Track.id;
  Trackno := aTrackno;
  secstart := asecstart;
  secend := asecend;
  secstartx := asecstartx;
  secendx := asecendx;
  backwards := false;
end;

constructor TRBExport_Mod.Create(smooth: boolean);
begin
  inherited Create();
  FSmooth := smooth;
  FPoints := TObjectlist.Create;
  FConnections := TRBConnectionlist.Create;
  FPrimaryConnections := TRBConnectionlist.Create;
  FPrimaryConnections.OwnsObjects := false;
  RouteFreeObj := TStringlist.Create;
  Credits := TStringlist.Create;
  Credits.Sorted := true;
  Credits.Duplicates := dupIgnore;
  ExportSchedule := nil;

  GroundTextureList:= TRBGroundTextureList.Create();
  BackgroundTextureList:= TRBBackgroundTextureList.Create();
  TrackTexturelist:= TRBTrackTexturelist.Create();
  Platformlist := TRBPlatformlist.Create();
  CatenaryPoleList := TRBCatenaryPoleList.Create();
  WallList := TRBWallList.Create;
  Rooflist := TRBRooflist.Create;

  UsedTrackObjects := TStringlist.Create;
  UsedGrounds := TStringlist.Create;
  UsedWalls := TStringlist.Create;
  UsedBackgrounds := TStringlist.Create;
  UsedFreeObj := TStringlist.Create;
  UsedPlatforms := TStringlist.Create;
  UsedRoofs := TStringlist.Create;
  UsedPoles := TStringlist.Create;
  PassStations := TSTringlist.create;

  Header := TStringlist.create;
end;


procedure TRBExport_Mod.ExportHeader(ExportInterface: TStringList);
begin
FObjCount := 0;
FormExport.ExportStatusText.Caption:='Writing header...';   //Caption für Status im Exportformular
FormExport.ExportStatusProgress.Position:=5;           //Progress für Gauge im Exportformular

ExportInterface.Add(';made with RouteBuilder ' + VersionString + ' - visit ' + HomepageURL);


ExportInterface.Add('with Route');
ExportInterface.Add('.Comment '+GetFromProject.Description
  +'$chr(13)$chr(10)'+Timetable+' '+Startstation.StationName+' - ' + Nextstation.StationName
  +'$chr(13)$chr(10)'+'Created by '+GetFromProject.Author+'$chr(13)$chr(10)'
  +'-----------------------'+'$chr(13)$chr(10)'+'Made with Route Builder');
ExportInterface.Add('.Timetable '+Timetable);
ExportInterface.Add('.RunInterval '+inttostr( TrainInterval ) );
ExportInterface.Add('.Change 0');
ExportInterface.Add('.Gauge '+IntToStr(GetFromProject.Gauge));
ExportInterface.Add('.DeveloperId '+IntToStr(GetFromProject.DeveloperID));
ExportInterface.Add('');

FormExport.ExportStatusProgress.Position:=15; //Progress für Gauge im Exportformular

end;



procedure TRBExport_Mod.GetFromTo(Track,NextTrack: TRBConnection; var Pos1,Pos2: TRBPoint);
begin
  // ermittle Start und Ende des Tracks. Das ist nicht trivial, denn die Tracks sind nicht
  // unbedingt gleich ausgerichtet. Der eine kann vorwärts führen und der andere rückwärts.
  // er muss dann sozusagen umgedreht werden, um vorwärts zu kommen.
  if NextTrack<>nil then
  begin
    // falls P1 vom Track mit P1 oder P2 des nächsten identisch ist
    if (Track.P1=NextTrack.P1)or(Track.P1=NextTrack.P2) then
    begin
      // Track fängt bei P2 an und geht weiter zu P1
      Pos1 := Track.P2;
      Pos2 := Track.P1;
    end
    else
    begin
      // Track fängt bei P1 an und geht weiter zu P2
      Pos1 := Track.P1;
      Pos2 := Track.P2;
    end;
  end
  else
  begin
    // dies ist der letzte Track. Um die richtige Richtung zu ermitteln, vergleichen wir mit dem letzten Punkt (Pos2)
    if Pos2=Track.P1 then
    begin
      // der Track geht von P1 nach P2
      Pos1 := Track.P1;
      Pos2 := Track.P2;
    end
    else
    begin
      // der Track geht umgekehrt von P2 nach P1
      Pos1 := Track.P2;
      Pos2 := Track.P1;
    end;
  end;
end;




procedure TRBExport_Mod.ExportTrainSection(ExportInterface: TStringlist; Train:String);
var i,j: integer;
    TD: TRBTrackDefinition;
begin
  FormExport.ExportStatusText.Caption:='Writing train...';    //Caption für Status im Exportformular

  ExportInterface.Add('with Train');
  ExportInterface.Add('.Folder '+Train);

  // BVETSS 1.0 support
  for i:=0 to UsedTrackObjects.count-1 do
  begin
    ExportInterface.Add('.Run('+inttostr(i)+') '+inttostr( FormTrackTypes.GetTrackDefinitionRunsound(UsedTrackObjects[i]) ) );
  end;

  if BVE4 then
  begin
    ExportInterface.Add('.Timetable(0).Day.Load ..\..\Railway\Object\'+subdir+'\misc\timetable_'+Timetable+'.bmp');
//    ExportInterface.Add('.Timetable(0).Night.Load ..\..\Railway\Object\'+subdir+'\misc\timetable_'+Timetable+'.bmp');
  end;

  ExportInterface.Add('');

end;




procedure TRBExport_Mod.ExportObjectSection(ExportInterface:TStringList);
var
  i,j,maxfreeobjid: Integer;
  o: TRBObject;
  TD: TRBTrackDefinition;
begin
  RouteFreeObj.Clear();

  FormExport.ExportStatusText.Caption:='Writing objects...';   //Caption für Status im Exportformular
  FormExport.ExportStatusProgress.Position:=35;          //Progress für Gauge im Exportformular

  ExportInterface.Add('with Structure');


     {
 //GROUND-OBJEKTE
 for i:=0 to GroundTextureList.Count-1 do begin
   ExportInterface.Add('.ground('+IntToStr(GroundTextureList.getIDByIndex(i))+') '
     +subdir+'\grounds\'+GroundTextureList.getObjectfilenamebyID(GroundTextureList.getIDByIndex(i)));
   // dest=src
   AddObjectToFilelist('grounds',GroundTextureList.getObjectfilenamebyID(GroundTextureList.getIDByIndex(i)));
 end;         }
{
 // Wall/Dike-OBJEKTE
 // Hinweis: Wall und Dike ist für uns das gleiche.
 // Wir zeigen immer links Wall und rechts Dike an
 // Wegen Einschränkung von BVE, der sonst nur links und rechts die gleiche Wand zeigen kann
 // TODO: nur verwendete Walls in die Liste aufnehmen, da nur 0-15 erlaubt sind! 
 for i:=0 to WallList.Count-1 do
 begin
   ExportInterface.Add('.wallL('+IntToStr(WallList.getIDByIndex(i))+') '
     +subdir+'\walls\'+WallList.getObjectfilenamebyID(WallList.getIDByIndex(i))+'_l.b3d');
   ExportInterface.Add('.dikeL('+IntToStr(WallList.getIDByIndex(i))+') '
     +subdir+'\walls\'+WallList.getObjectfilenamebyID(WallList.getIDByIndex(i))+'_l.b3d');
   ExportInterface.Add('.wallR('+IntToStr(WallList.getIDByIndex(i))+') '
     +subdir+'\walls\'+WallList.getObjectfilenamebyID(WallList.getIDByIndex(i))+'_r.b3d');
   ExportInterface.Add('.dikeR('+IntToStr(WallList.getIDByIndex(i))+') '
     +subdir+'\walls\'+WallList.getObjectfilenamebyID(WallList.getIDByIndex(i))+'_r.b3d');
   // dest=src
   AddObjectToFilelist('walls',WallList.getObjectfilenamebyID(WallList.getIDByIndex(i))+'_l.b3d') ;
   AddObjectToFilelist('walls',WallList.getObjectfilenamebyID(WallList.getIDByIndex(i))+'_r.b3d') ;
 end;  }

 //SCHIENEN-OBJEKTE
 UsedTrackObjects.Clear;
 UsedGrounds.Clear;
 UsedWalls.Clear;
 UsedBackgrounds.Clear;
 UsedFreeObj.Clear;
 UsedPlatforms.Clear;
 UsedRoofs.Clear;

 // um das Nicht-Dach zu erzeugen...
 GetRoofIndex('');

 ExportInterface.Add(objectdef_placeholder);

// ExportInterface.Add('.rail(0) '+subdir+'\tracks\track0.b3d');
 AddObjectToFilelist('tracks','track0.b3d');

{ for i:=0 to 9 do
 begin
   // Standardgleis ist unsichtbar (track0)
 //  ExportInterface.Add('.rail('+inttostr(i)+') '+subdir+'\tracks\track0.b3d');
    ExportInterface.Add('.rail('+IntToStr(TrackTextureList.getIDByIndex(i))+') '
      +subdir+'\tracks\'+TrackTextureList.getObjectfilenamebyID(TrackTextureList.getIDByIndex(i)));
    AddObjectToFilelist('tracks',TrackTextureList.getObjectfilenamebyID(TrackTextureList.getIDByIndex(i)));
 end;  }

 {// Platform-Objekte
 for i:=0 to Platformlist.count-1 do
 begin
   ExportInterface.Add('.formr('+IntToStr(Platformlist.getIDByIndex(i))+') '
    +subdir+'\platforms\'+Platformlist.getObjectfilenamebyID(Platformlist.getIDByIndex(i))+'r.b3d'); // geht nicht mit csv!
   AddObjectToFilelist('platforms',Platformlist.getObjectfilenamebyID(Platformlist.getIDByIndex(i))+'r.b3d');
   ExportInterface.Add('.forml('+IntToStr(Platformlist.getIDByIndex(i))+') '
    +subdir+'\platforms\'+Platformlist.getObjectfilenamebyID(Platformlist.getIDByIndex(i))+'l.b3d'); // geht nicht mit csv!
   AddObjectToFilelist('platforms',Platformlist.getObjectfilenamebyID(Platformlist.getIDByIndex(i))+'l.b3d');
   ExportInterface.Add('.formcr('+IntToStr(Platformlist.getIDByIndex(i))+') '
    +subdir+'\platforms\'+Platformlist.getObjectfilenamebyID(Platformlist.getIDByIndex(i))+'cr.b3d'); // geht nicht mit csv!
   AddObjectToFilelist('platforms',Platformlist.getObjectfilenamebyID(Platformlist.getIDByIndex(i))+'cr.b3d');
   ExportInterface.Add('.formcl('+IntToStr(Platformlist.getIDByIndex(i))+') '
    +subdir+'\platforms\'+Platformlist.getObjectfilenamebyID(Platformlist.getIDByIndex(i))+'cl.b3d'); // geht nicht mit csv!
   AddObjectToFilelist('platforms',Platformlist.getObjectfilenamebyID(Platformlist.getIDByIndex(i))+'cl.b3d');
 end;     }

 {// Roof-Objekte
 for i:=0 to Rooflist.count-1 do
 begin
   ExportInterface.Add('.roofr('+IntToStr(Rooflist.getIDByIndex(i))+') '
    +subdir+'\platforms\'+RoofList[i]+'r.b3d'); // geht nicht mit csv!
   AddObjectToFilelist('platforms',RoofList[i]+'r.b3d');
   ExportInterface.Add('.roofl('+IntToStr(Rooflist.getIDByIndex(i))+') '
    +subdir+'\platforms\'+RoofList[i]+'l.b3d'); // geht nicht mit csv!
   AddObjectToFilelist('platforms',RoofList[i]+'l.b3d');
   ExportInterface.Add('.roofcr('+IntToStr(Rooflist.getIDByIndex(i))+') '
    +subdir+'\platforms\'+RoofList[i]+'cr.b3d'); // geht nicht mit csv!
   AddObjectToFilelist('platforms',RoofList[i]+'cr.b3d');
   ExportInterface.Add('.roofcl('+IntToStr(Rooflist.getIDByIndex(i))+') '
    +subdir+'\platforms\'+RoofList[i]+'cl.b3d'); // geht nicht mit csv!
   AddObjectToFilelist('platforms',RoofList[i]+'cl.b3d');
 end;    }

 maxfreeobjid := 0;
 // Gleisobjekte (FreeObj)
 {for i:=0 to TrackTexturelist.Count-1 do
 begin
    ExportInterface.Add('.freeobj('+IntToStr(TrackTextureList.getIDByIndex(i))+') '
     +subdir+'\tracks\'+TrackTextureList.getObjectfilenamebyID(TrackTextureList.getIDByIndex(i)));
    if (TrackTextureList.getIDByIndex(i)>maxfreeobjid) then maxfreeobjid := TrackTextureList.getIDByIndex(i);
    AddObjectToFilelist('tracks',TrackTextureList.getObjectfilenamebyID(TrackTextureList.getIDByIndex(i)));
 end;        }

 // Default Objects
 inc(maxfreeobjid);
 // stop sign
 if GetFromProject.DefaultObjects.Values['stopsign']<>'' then
 begin
   FreeObjID_Stopsign := GetFreeobjIndex(StrGetToken(GetFromProject.DefaultObjects.Values['stopsign'],'\',1),
                       StrGetToken(GetFromProject.DefaultObjects.Values['stopsign'],'\',2));

{   ExportInterface.Add('.freeobj('+IntToStr(maxfreeobjid)+') '
    +subdir+'\'+ GetFromProject.DefaultObjects.Values['stopsign']);
   FreeObjID_Stopsign := maxfreeobjid;
   AddObjectToFilelist(StrGetToken(GetFromProject.DefaultObjects.Values['stopsign'],'\',1),
                       StrGetToken(GetFromProject.DefaultObjects.Values['stopsign'],'\',2));
   inc(maxfreeobjid);  }
 end;
  {
 // restliche FreeObjects
 FreeObjID_Other := maxfreeobjid;
 for i:=0 to GetFromProject.Freeobjects.Create.count-1 do
 begin
   o := GetFromProject.FreeObjects[i] as TRBObject;
   if RouteFreeObj.indexof(o.GetPath())<0 then
   begin
     o.AddAuthors(Credits);
     RouteFreeObj.add(o.GetPath());
     ExportInterface.Add('.freeobj('+inttostr(FreeObjID_Other+RouteFreeObj.indexof(o.GetPath())) +') '
      +subdir+'\'+o.GetPath() );
     AddObjectToFilelist(o.Folder,o.Objectfilename);
     inc(maxfreeobjid);
   end;
 end;    }
  {
 // Oberleitungsmasten-Objekte für alle Gleise gleich
 for i:=0 to CatenaryPoleList.count-1 do
 begin
   for j:=0 to 0 do
   begin
     ExportInterface.Add('.pole('+inttostr(j)+';'+IntToStr(CatenaryPoleList.getIDByIndex(i)-1)+') '
      +subdir+'\poles\'+CatenaryPoleList.getObjectfilenamebyID(CatenaryPoleList.getIDByIndex(i)));
     AddObjectToFilelist('poles',CatenaryPoleList.getObjectfilenamebyID(CatenaryPoleList.getIDByIndex(i)));
   end;
 end;   }


{  //HINTERGRUND-TEXTUREN
 for i:=0 to BackgroundTextureList.Count-1 do begin
   ExportInterface.Add('.background('+IntToStr(BackgroundTextureList.getIDByIndex(i))+') '
    +subdir+'\backgrounds\'+BackgroundTextureList.getObjectfilenamebyID(BackgroundTextureList.getIDByIndex(i)));
   // einfaches Filelist.add, weil es bmps sind und keine b3ds
   Filelist.add('backgrounds\'+BackgroundTextureList.getObjectfilenamebyID(BackgroundTextureList.getIDByIndex(i)));
 end;      }

  ExportInterface.Add('');

  FormExport.ExportStatusProgress.Position:=40;  //Progress für Gauge im Exportformular
end;

// Funktion: ExportObjectSectionPass2
// Autor   : up
// Datum   : 10.1.03
// Beschr. : 2. Pass Objekt-Header. Erzeugt Kommandos für verwendete Tracks etc.
procedure TRBExport_Mod.ExportObjectSectionPass2(dest: TStrings);
var i,j: integer;
    o: TRBObject;
begin
 for i:=0 to UsedTrackObjects.count-1 do
 begin
   dest.Add('.rail('+inttostr(i)+') '+subdir+'\'+usedtrackobjects[i]);
   AddObjectToFilelist( StrGetToken(usedtrackobjects[i],'\',1),StrGetToken(usedtrackobjects[i],'\',2) );
 end;

 //GROUND-OBJEKTE
 for i:=0 to UsedGrounds.Count-1 do begin
   dest.Add('.ground('+IntToStr(i)+') '
     +subdir+'\grounds\'+ UsedGrounds[i]);
   // dest=src
   AddObjectToFilelist('grounds',UsedGrounds[i]);
 end;

 // Wall/Dike-OBJEKTE
 // Hinweis: Wall und Dike ist für uns das gleiche.
 // Wir zeigen immer links Wall und rechts Dike an
 // Wegen Einschränkung von BVE, der sonst nur links und rechts die gleiche Wand zeigen kann
 for i:=0 to UsedWalls.Count-1 do
 begin
   dest.Add('.wallL('+IntToStr(i)+') '
     +subdir+'\walls\'+UsedWalls[i]+'_l.b3d');
   dest.Add('.dikeL('+IntToStr(i)+') '
     +subdir+'\walls\'+UsedWalls[i]+'_l.b3d');
   dest.Add('.wallR('+IntToStr(i)+') '
     +subdir+'\walls\'+UsedWalls[i]+'_r.b3d');
   dest.Add('.dikeR('+IntToStr(i)+') '
     +subdir+'\walls\'+UsedWalls[i]+'_r.b3d');
   // dest=src
   AddObjectToFilelist('walls',UsedWalls[i]+'_l.b3d') ;
   AddObjectToFilelist('walls',UsedWalls[i]+'_r.b3d') ;
 end;

// Platform-Objekte
 for i:=0 to UsedPlatforms.count-1 do
 begin
   dest.Add('.formr('+IntToStr(i)+') '
    +subdir+'\platforms\'+usedplatforms[i]+'r.b3d'); // geht nicht mit csv!
   AddObjectToFilelist('platforms',usedplatforms[i]+'r.b3d');
   dest.Add('.forml('+IntToStr(i)+') '
    +subdir+'\platforms\'+usedplatforms[i]+'l.b3d'); // geht nicht mit csv!
   AddObjectToFilelist('platforms',usedplatforms[i]+'l.b3d');
   dest.Add('.formcr('+IntToStr(i)+') '
    +subdir+'\platforms\'+usedplatforms[i]+'cr.b3d'); // geht nicht mit csv!
   AddObjectToFilelist('platforms',usedplatforms[i]+'cr.b3d');
   dest.Add('.formcl('+IntToStr(i)+') '
    +subdir+'\platforms\'+usedplatforms[i]+'cl.b3d'); // geht nicht mit csv!
   AddObjectToFilelist('platforms',usedplatforms[i]+'cl.b3d');
 end;

// Roof-Objekte
 for i:=0 to UsedRoofs.count-1 do
   if UsedRoofs[i]<>'' then   // da es roof(0) nicht gibt
   begin
     dest.Add('.roofr('+IntToStr(i)+') '
      +subdir+'\platforms\'+UsedRoofs[i]+'r.b3d'); // geht nicht mit csv!
     AddObjectToFilelist('platforms',UsedRoofs[i]+'r.b3d');
     dest.Add('.roofl('+IntToStr(i)+') '
      +subdir+'\platforms\'+UsedRoofs[i]+'l.b3d'); // geht nicht mit csv!
     AddObjectToFilelist('platforms',UsedRoofs[i]+'l.b3d');
     dest.Add('.roofcr('+IntToStr(i)+') '
      +subdir+'\platforms\'+UsedRoofs[i]+'cr.b3d'); // geht nicht mit csv!
     AddObjectToFilelist('platforms',UsedRoofs[i]+'cr.b3d');
     dest.Add('.roofcl('+IntToStr(i)+') '
      +subdir+'\platforms\'+UsedRoofs[i]+'cl.b3d'); // geht nicht mit csv!
     AddObjectToFilelist('platforms',UsedRoofs[i]+'cl.b3d');
   end;

 // Oberleitungsmasten-Objekte
 for i:=0 to UsedPoles.count-1 do
 begin
   for j:=0 to 0 do
   begin
     dest.Add('.pole('+inttostr(j)+';'+IntToStr(i)+') '
      +subdir+'\poles\'+UsedPoles[i]);
     AddObjectToFilelist('poles',UsedPoles[i]);
   end;
 end;

 // FreeObjects
 for i:=0 to UsedFreeObj.count-1 do
 begin
   o := TRBObject.Create(StrGetToken( UsedFreeObj[i],'|',1),StrGetToken( UsedFreeObj[i],'|',2));
   o.AddAuthors(Credits);
//     RouteFreeObj.add(o.GetPath());
   if Night and o.NightVersionAvailable then
   begin
     dest.Add('.freeobj('+inttostr(i) +') '
      +subdir+'\'+o.GetPathNightVersion() );
     AddObjectToFilelist(o.Folder,o.NightVersionObjectFilename);
   end
   else
   begin
     dest.Add('.freeobj('+inttostr(i) +') '
      +subdir+'\'+o.GetPath() );
     AddObjectToFilelist(o.Folder,o.Objectfilename);
   end;
   o.free;
 end;
  dest.Add('');
  dest.Add('with Texture');
  //HINTERGRUND-TEXTUREN
 for i:=0 to UsedBackgrounds.Count-1 do
 begin
   if Night then UsedBackgrounds[i] := 'black.bmp';
   dest.Add('texture.background('+IntToStr(i)+') '
    +subdir+'\backgrounds\'+UsedBackgrounds[i]);
   // einfaches Filelist.add, weil es bmps sind und keine b3ds
   Filelist.add('backgrounds\'+UsedBackgrounds[i]);
 end;
end;


function RoutePartCompare(List: TStringList; Index1, Index2: Integer): Integer;
var z1,z2: double;
begin
  z1 := strtofloat1(trim(strgettoken(list[index1],',',1)));
  z2 := strtofloat1(trim(strgettoken(list[index2],',',1)));
  if z1=z2 then
  begin
    if (pos('rail',list[index1])>0)and(pos('poles',list[index2])>0) then result := -1;
    if (pos('rail',list[index2])>0)and(pos('poles',list[index1])>0) then result := +1;
  end
  else
    result := sgn(z1-z2);
end;

function SecPartDistCompare(conn1,conn2: pointer): Integer;
var z1,z2: double;
begin
  z1 := TRBConnection(conn1).a_temp;
  z2 := TRBConnection(conn2).a_temp;
  result := sgn(z1-z2);
end;

function TRBExport_Mod.GetTrackTypeIndex(tracktype,curve: integer): integer;
var s: string;
begin
  s := FormTrackTypes.GetTrackDefinitionObject(tracktype,curve);
  if UsedTrackObjects.IndexOf(s)>=0 then
    result := UsedTrackObjects.IndexOf(s)
  else
    result := UsedTrackObjects.Add(s);
end;

function TRBExport_Mod.TrackTypeHasSwitch(tracktype: integer): boolean;
var s: string;
begin
  s := FormTrackTypes.GetTrackDefinitionSwitchBasefilename(tracktype);
  result :=  (s<>'');
end;

function TRBExport_Mod.TrackTypeSwitchObject(tracktype: integer; _dir,_set: TSwitchDirection): string;
begin
  result := ExtractFileName( FormTrackTypes.GetTrackDefinitionSwitchObject(tracktype,_dir,_set) );
end;



function TRBExport_Mod.GetGroundIndex(const ground: string): integer;
var s: string;
    r: integer;
begin
  //s := GroundTextureList.getObjectfilenamebyID(groundid);
  s := ground;
  // multiples Objekt?
  if pos(',',s)>0 then
  begin
    r := random(CountTokens(s,','))+1;
    s := StrGetToken(s,',',r);
  end;
  if usedGrounds.indexof(s)>=0 then
    result := UsedGrounds.indexof(s)
  else
    result := UsedGrounds.add(s);
end;

function TRBExport_Mod.GetBackgroundIndex(const background: string): integer;
var s: string;
begin
//  s := backGroundTextureList.getObjectfilenamebyID(backgroundid);
  s := background;
  if usedbackGrounds.indexof(s)>=0 then
    result := UsedbackGrounds.indexof(s)
  else
    result := Usedbackgrounds.add(s);
end;

// unterstützt multiple Walls
function TRBExport_Mod.GetWallIndex(const wall: string): integer;
var s: string;
    i,r: integer;
begin
//  s := WallList.getObjectfilenamebyID(wallid);
  s := wall;
  // multiples Objekt?
  if pos(',',s)>0 then
  begin
    r := random(CountTokens(s,','))+1;
    s := StrGetToken(s,',',r);
  end;
  if usedWalls.indexof(s)>=0 then
    result := usedWalls.indexof(s)
  else
    result := usedWalls.add(s);
end;

function TRBExport_Mod.GetPlatformIndex(const platformname: string): integer;
var s: string;
begin
//  s := Platformlist.getObjectfilenamebyID(platformid);
  s := platformname;
  if usedPlatforms.indexof(s)>=0 then
    result := usedPlatforms.indexof(s)
  else
    result := usedPlatforms.add(s);

end;

function TRBExport_Mod.GetRoofIndex(const roofname: string): integer;
var s: string;
begin
  //s := Rooflist.getObjectfilenamebyID(roofid);
  s := roofname;
  if usedRoofs.indexof(s)>=0 then
    result := usedRoofs.indexof(s)
  else
    result := usedRoofs.add(s);

end;

function TRBExport_Mod.GetPoleIndex(pole: string): integer;
var s: string;
begin
  //s := CatenaryPoleList.getObjectfilenamebyID(poleid);
  s := pole;
  if usedPoles.indexof(s)>=0 then
    result := usedPoles.indexof(s)
  else
    result := usedPoles.add(s);

end;

function TRBExport_Mod.GetFreeobjIndex(const folder,objname: string): integer;
var s,s1: string;
    r: integer;
begin
  if (folder='')or(objname='') then begin result := -1; exit; end;
  if pos(',',objname)>0 then
  begin
    r := random(CountTokens(objname,','))+1;
    s1 := StrGetToken(objname,',',r);
  end
  else s1 := objname;
  s := folder+'|'+s1;
  if UsedFreeObj.indexof(s)>=0 then
    result := UsedFreeObj.indexof(s)
  else
    result := UsedFreeObj.add(s);
end;

function TRBExport_Mod.GetFreeobjIndex(const folder,objname,postfix: string): integer;
var s,s1: string;
    r: integer;
begin
  if (folder='')or(objname='') then begin result := -1; exit; end;
  if pos(',',objname)>0 then
  begin
    r := random(CountTokens(objname,','))+1;
    s1 := StrGetToken(objname,',',r);
  end
  else s1 := objname;
  s := folder+'|'+s1+postfix;
  if UsedFreeObj.indexof(s)>=0 then
    result := UsedFreeObj.indexof(s)
  else
    result := UsedFreeObj.add(s);
end;

function TRBExport_Mod.GetFreeobjIndex(const completeobjname: string): integer;
var folder,objname: string;
begin
  folder := StrGetToken(completeobjname,'\',1);
  objname := StrGetToken(completeobjname,'\',2);
  result := GetFreeobjIndex(folder,objname);
end;


procedure TRBExport_Mod.ExportRailwaySection(ExportInterface:TStringList; direction:Integer);
var
  i,j,k,h,x,z,no: Integer;
  SecStart,SecEnd,
  SecStartX,SecEndX,
  ObXOffset,ObZOffset,plen,
  ZPosition,
  seglen,
  oalpha,
  sec,a,aa,aaa,b,a1,a2,b1,b2,bs1,bs2,ao,bo,radsum,
  XSecOffset,XSecOffsetEnd,SecStartxFirst,SecStartAlpha: double;
  backwards: boolean;
  id,curve,nextcurve,
  PoleSide,
  trackcount,
  ddirection,
  sectrackno,
  PolesType,
  PrevPolesType,
  secPolesType: integer;
  o: TRBObject;
  OldDecimalSeparator: char;
  Pos1,Pos2: TRBPoint;
  TrackLeftPresent,
  TrackRightPresent,
  firstexportedsectrack,
  secondary_exported,
  found_unexported,
  turn: boolean;
  switchobjectfilename,
  cmd: string;
  CurrentTime:TDateTime;
  ArrivalTimeStr,DepartTimeStr: string;
  Track,NextTrack,PrevTrack,SecTrack,NextSecTrack : TRBConnection; // war ursprünglich membervariable, lokal hier dürfte aber reichen (up)
  TmpList,
  SecondaryTracks,
  connlist,
  ExportedTracks: TRBConnectionlist;
  LastFoundSecTracksX,
  FoundSecTracksX: array of double;
  LastFoundSecTracks,
  FoundSecTracks: array of TRBConnection;
  currsectrack: TRBConnection;
  ExportedFreeObjects: TObjectlist;
  SecTrackStartPoint: TRBPoint;
  ExportInfo: TSecTrackExportInfo;
  RoutePart: TStringlist;
  railendindex: array[1..16] of integer;
  railxoffset: array[1..16] of double;
  first_is_fixed: boolean;
  NearTheEnd : integer;
  drawconnlist: TRBConnectionList;

  procedure ExportSignal();
  var sig: TRBSignal;
      j1, postid, backid: integer;
  begin
    backid := GetFreeobjIndex(GetFromProject.DefaultObjects.values['signalback']);

    for j1:=0 to GetFromProject.Signals.count-1 do
    begin
      sig := GetFromProject.Signals[j1] as TRBSignal;
      if sig.connectionid = Track.ID then
      begin
        postid := GetFreeobjIndex(GetFromProject.DefaultObjects.values['signalpost']);
        if (sig.PostObjName<>'') then
          postid := GetFreeobjIndex(sig.PostObjName);
        if sig.Direction = ddirection*track.switch_turned then
        begin
          if sig.Relay then
            RoutePart.Add(floattostrpoint(ZPosition,maxcommadigits)+', .relay '
               +floattostrPoint(sig.xoffs,maxcommadigits)+';'+floattostrPoint(sig.yoffs,maxcommadigits))
          else
            RoutePart.Add(floattostrpoint(ZPosition,maxcommadigits)+', .signal -' + inttostr(sig.GetCode())
              +';'+sig.Name+';'+floattostrPoint(sig.xoffs,maxcommadigits)+';'+floattostrPoint(sig.yoffs,maxcommadigits)
              +';'+inttostr(ord(sig.SignalType)));
          // Pfosten
          RoutePart.Add(CmdFreeObj(ZPosition,0,postid,sig.xoffs,0,0));
        end
        else
        begin
          // Signal-Dummy in Gegenrichtung aufstellen
          // Pfosten
          RoutePart.Add(CmdFreeObj(ZPosition+25,0,postid,-sig.xoffs,0,180));
          // Rückseite
          RoutePart.Add(CmdFreeObj(ZPosition+25,0,backid,-sig.xoffs,sig.yoffs,180));
          // TODO!
        end;
      end;
    end;
  end;

  //----------------------------------------------------------------------

  procedure ExportStation();
  var j1,stoptime: integer;
      sta: TRBStation;
      pass_station: boolean;
      platformside: integer;
      arrival,depart: double;
  begin
    for j1:=0 to GetfromProject.GetStationCount()-1 do
    begin
      sta := GetFromProject.GetStationByIndex(j1);
      if (sta.TrackIDIsInStation(Track.ID))
      and(not sta.exported) then
      begin
        if  NextStation=sta then
        begin
          dest_reached := true;
          NearTheEnd := ExportAfterEndStation;
        end;
        // Auf welcher Seite ist der Bahnsteig?
        platformside := 0;
        if track.PlatformPos=1 then platformside :=1;
        if track.PlatformPos=2 then platformside :=-1;
        // durchfahren?
        pass_station := (PassStations.IndexOf(sta.stationname)>=0);
        // Fahrzeit berechnen
        CurrentTime := IncSecond(CurrentTime, int64(round(sec)) );
        if Train=nil then
          sec := 90 // Standardaufschlag wegen Anfahren und Bremsen 
        else
          sec := round(1.2*Track.Speedlimit/(Train.GetDeceleration)); // 1.2 macht 20% Aufschlag zur Sicherheit
          // eigentlich wäre /2 richtig, aber wir nehmen einfach das Doppelte für die Beschleunigungsphase hinzu
        // Runden auf die nächsten vollen 30 Sekunden
        CurrentTime := ceil(CurrentTime*24*120)/24/120;
        arrival :=  currentTime;
        ArrivalTimeStr := floattostrPoint( HourOf(CurrentTime) + MinuteOf(CurrentTime)/100 + SecondOf(CurrentTime)/10000, 4 );
        if not pass_station then
        begin
          if ExportSchedule=nil then
            stoptime := 60 // sec
          else
            stoptime := ExportSchedule.GetStopDuration(sta.StationName);
          CurrentTime := IncSecond(CurrentTime, stoptime );
        end;
        // Runden auf die nächsten vollen 30 Sekunden
        //CurrentTime := ceil(CurrentTime*24*120)/24/120;
        depart := CurrentTime;
        DepartTimeStr := floattostrPoint( HourOf(CurrentTime) + MinuteOf(CurrentTime)/100  + SecondOf(CurrentTime)/10000, 4);
        // bis ans Ende des Segments fahren
        RoutePart.Add(floattostrpoint(ZPosition,maxcommadigits)+', .Sta '
           +sta.stationname
           +';'+ArrivalTimeStr+';'+DepartTimeStr
           +';1;'         // Durchfahrtswarnung
           +inttostr(platformside)+';'         // Türen  (-1=links, +1=rechts)
           +inttostr(integer(not pass_station))
           +';0' // ATS
           +';'+ConcatIfNotOneEmpty('..\object\'+subdir+'\sounds\',sta.ArrivalSound) // Ankunftsansage
           +';'+inttostr(sta.MinStopTime) //Min. Dauer
           +';'+inttostr(sta.PeopleCount) // Fahrgastaufkommen
           +';'+ConcatIfNotOneEmpty('..\object\'+subdir+'\sounds\',sta.DepartureSound)); // Abfahrtsansage
        AddObjectToFilelist('sounds',sta.DepartureSound);
        AddObjectToFilelist('sounds',sta.ArrivalSound);
        // .stop vorverlegen, damit man auch vor dem Strich halten kann
        RoutePart.Add(floattostrpoint(ZPosition+15,maxcommadigits)+', .stop 0');
        // in Fahrplan eintragen
        FTimetable.addStation(round(zposition),sta.StationName,arrival,depart,not pass_station,Track.Speedlimit);
        // marker anbringen
        if ZPosition>1000 then
        begin
          if pass_station then
          begin
            if GetFromProject.DefaultObjects.values['stationmarkerpass']<>'' then
              RoutePart.Add(CmdMarker(ZPosition,1000, GetFromProject.DefaultObjects.values['stationmarkerpass'] ));
          end
          else
          begin
            if GetFromProject.DefaultObjects.values['stationmarkerstop']<>'' then
              RoutePart.Add(CmdMarker(ZPosition,1000, GetFromProject.DefaultObjects.values['stationmarkerstop'] ));
          end;
        end;
        sta.exported := true;
        // Stopschild
        if FreeObjID_Stopsign<>-1 then
          RoutePart.add(CmdFreeObj(ZPosition+15,0,FreeObjID_Stopsign,cStopsignXOffset*platformside*sta.StopsignSide,0,0)) // TODO links oder rechts
        else
          RoutePart.add(CmdStop(ZPosition+15,1));
      end;
    end;
  end;

  //--------------------------------------------------------------------
  procedure TrackProperties();
  begin
    // Track-Eigenschaften, die es nur bei Primärtracks gibt
    // Track-Eigenschaften: Nebel
    if (PrevTrack=nil) or (PrevTrack.Fog<>Track.Fog) then
    begin
      if Night then
          RoutePart.add(floattostrpoint(ZPosition,maxcommadigits)+', .fog 25;150;0;0;0')
      else
      begin
        if Track.Fog<>0 then
          RoutePart.add(floattostrpoint(ZPosition,maxcommadigits)+', .fog 25;'+inttostr(Track.fog+25)+';224;224;224')
        else
          RoutePart.add(floattostrpoint(ZPosition,maxcommadigits)+', .fog 0;0;0;0;0');
      end;
    end;

    // Track-Eigenschaften: Adhesion
    if (PrevTrack=nil) or (PrevTrack.Adhesion<>Track.Adhesion) then
    begin
      RoutePart.add(floattostrpoint(ZPosition,maxcommadigits)+', .adhesion '+inttostr(Track.Adhesion));
    end;

    // Track-Eigenschaften: Limit
    if (PrevTrack=nil) or (PrevTrack.Speedlimit<>Track.Speedlimit) then
    begin
      RoutePart.add(floattostrpoint(ZPosition,maxcommadigits)+', .limit '+inttostr(Track.speedlimit) + ';0;0');
    end;

    // Track-Eigenschaften: Hintergrund
    if (PrevTrack=nil) or (PrevTrack.Background<>Track.Background) then
    begin
      RoutePart.add(floattostrpoint(ZPosition,maxcommadigits)+', .back '+ inttostr( GetBackgroundIndex( Track.Background )));
    end;

    // Track-Eigenschaften: Grund
    if ((PrevTrack=nil) or (PrevTrack.Ground<>Track.Ground)) and not FormOptions.GetGroundlessBuilding then
    begin
      if Track.Ground<>'' then
        RoutePart.add(floattostrpoint(ZPosition,maxcommadigits)+', .ground '+inttostr( GetGroundIndex( Track.Ground )) );
    end;

    // Track-Eigenschaften: Pitch (relativ zum letzten Track)
    if (PrevTrack<>nil) then
    begin
//      RoutePart.add( CmdPitch(ZPosition-25,round((Track.p1.Height-PrevTrack.p2.Height)*40)) );
      RoutePart.add( CmdPitch(ZPosition,round((Track.p2.Height-Track.p1.Height)*40)) );
    end;

    // Track-Eigenschaft: Wave
    if (Track.Wavefilename<>'') then
    begin
      RoutePart.add(floattostrpoint(ZPosition,maxcommadigits)+', .announce ..\object\'+subdir+'\sounds\'+Track.Wavefilename);
      AddObjectToFilelist('sounds',Track.Wavefilename);
    end;
  end;

  // ------------------------------------------------------------------------
  procedure TrackExtensions(secTrack: TRBConnection; zpos,xoffs,hoehe,winkel: double; turn:boolean);
  var poschar: char;
      wa,postid,turnfactor,backid,j1,sigzoffs: integer;
      signaldummyid: array[1..3] of integer;
      sig: TRBSignal;
      o: TRBObject;
      obXoffset,obYoffset: double;
  begin
    if bve4 then hoehe := 0;
    if turn then turnfactor := -1 else turnfactor := 1;
    // Platform
    if (secTrack.PlatformPos<>0)and(secTrack.PlatformType<>'') then
    begin
      if secTrack.PlatformPos=1 then poschar := 'R'
      else if secTrack.PlatformPos=2 then  poschar := 'L';
      if turn then
      begin
        if poschar='R' then poschar :='L' else poschar := 'R';
      end;
      RoutePart.Add( CmdFreeObj(zpos,-1,GetFreeobjIndex('platforms',secTrack.PlatformType+poschar+'.b3d'),xoffs,hoehe,winkel) );
      RoutePart.Add( CmdFreeObj(zpos,-1,GetFreeobjIndex('platforms',secTrack.PlatformType+'C'+poschar+'.b3d'),xoffs,hoehe,winkel) );
      // Roof
      if secTrack.RoofType<>'' then
      begin
        RoutePart.Add( CmdFreeObj(zpos,-1,GetFreeobjIndex('platforms',secTrack.RoofType+poschar+'.b3d'),xoffs,hoehe,winkel) );
        RoutePart.Add( CmdFreeObj(zpos,-1,GetFreeobjIndex('platforms',secTrack.RoofType+'C'+poschar+'.b3d'),xoffs,hoehe,winkel) );
      end;
    end;
    // Pole
    if (secTrack.PolesPos<>0) then
    begin
      if secTrack.PolesPos<0 then wa := 180;
      if turn then wa := 180-wa;
      // Unterdrücken jedes zweiten Mastes (experimentell)
      if (curve<>0) or (not (secTrack.special in [csStraight,csFixed])) or (not FormOptions.CatenaryPolesEvery50m) or (round(zpos) mod 50 = 0) then
        RoutePart.Add( CmdFreeObj(zpos,-1,GetFreeobjIndex('poles',secTrack.PolesType),xoffs,hoehe,winkel+wa) );
    end;
    // TSO and Wall
  {  if xoffs=0 then
    begin
      if secTrack.WallIDLeft>0 then
      begin
        if turn then
          RoutePart.Add( CmdFreeObj(zpos,0,GetFreeobjIndex('walls',WallList.getObjectfilenamebyID(secTrack.WallIDLeft),'_r.b3d'),xoffs,hoehe-secTrack.Height,winkel) )
        else
          RoutePart.Add( CmdFreeObj(zpos,0,GetFreeobjIndex('walls',WallList.getObjectfilenamebyID(secTrack.WallIDLeft),'_l.b3d'),xoffs,hoehe-secTrack.Height,winkel) );
      end;
      if secTrack.WallIDRight>0 then
      begin
        if turn then
          RoutePart.Add( CmdFreeObj(zpos,0,GetFreeobjIndex('walls',WallList.getObjectfilenamebyID(secTrack.WallIDRight),'_l.b3d'),xoffs,hoehe-secTrack.Height,winkel) )
        else
          RoutePart.Add( CmdFreeObj(zpos,0,GetFreeobjIndex('walls',WallList.getObjectfilenamebyID(secTrack.WallIDRight),'_r.b3d'),xoffs,hoehe-secTrack.Height,winkel) );
      end;    end
    else  }
    begin
      if secTrack.WallLeft<>'' then
      begin
        if turn then
          RoutePart.Add( CmdFreeObj(zpos,-1,GetFreeobjIndex('walls',secTrack.WallLeft,'_r.b3d'),xoffs,hoehe,winkel) )
        else
          RoutePart.Add( CmdFreeObj(zpos,-1,GetFreeobjIndex('walls',secTrack.WallLeft,'_l.b3d'),xoffs,hoehe,winkel) );
      end;
      if secTrack.WallRight<>'' then
      begin
        if turn then
          RoutePart.Add( CmdFreeObj(zpos,-1,GetFreeobjIndex('walls',secTrack.WallRight,'_l.b3d'),xoffs,hoehe,winkel) )
        else
          RoutePart.Add( CmdFreeObj(zpos,-1,GetFreeobjIndex('walls',secTrack.WallRight,'_r.b3d'),xoffs,hoehe,winkel) );
      end;
    end;
    if secTrack.TSOLeft<>'' then
    begin
      if turn then
        RoutePart.Add( CmdFreeObj(zpos,-1,GetFreeobjIndex('walls',secTrack.TSOLeft,'_r.b3d'),xoffs,hoehe+SecTrack.TSOOffsetLeft/1000,winkel) )
//        RoutePart.Add( CmdFreeObj(zpos+25,-1,GetFreeobjIndex('walls',WallList.getObjectfilenamebyID(secTrack.TSOIDLeft),'_l.b3d'),-xoffs,hoehe+SecTrack.TSOOffsetRight/1000,winkel+180) )
      else
        RoutePart.Add( CmdFreeObj(zpos,-1,GetFreeobjIndex('walls',secTrack.TSOLeft,'_l.b3d'),xoffs,hoehe+SecTrack.TSOOffsetLeft/1000,winkel) );
    end;
    if secTrack.TSORight<>'' then
    begin
      if turn then
//        RoutePart.Add( CmdFreeObj(zpos+25,-1,GetFreeobjIndex('walls',WallList.getObjectfilenamebyID(secTrack.TSOIDRight),'_r.b3d'),-xoffs,hoehe+SecTrack.TSOOffsetLeft/1000,winkel+180) )
        RoutePart.Add( CmdFreeObj(zpos,-1,GetFreeobjIndex('walls',secTrack.TSORight,'_l.b3d'),xoffs,hoehe+SecTrack.TSOOffsetRight/1000,winkel) )
      else
        RoutePart.Add( CmdFreeObj(zpos,-1,GetFreeobjIndex('walls',secTrack.TSORight,'_r.b3d'),xoffs,hoehe+SecTrack.TSOOffsetRight/1000,winkel) );
    end;
    // bound freeobj?
    for j1:=0 to GetFromProject.Freeobjects.count-1 do
    begin
      if ExportedFreeObjects.IndexOf(GetFromProject.Freeobjects[j1])<0 then
      begin
        o := GetFromProject.Freeobjects[j1] as TRBObject;
        if o.boundtoConnID=secTrack.ID then
        begin
          ObZOffset := o.point.y;
          ObXOffset := o.point.x;
          if (((o.Folder<>'trains')or FormOptions.ExportTrainsOnPrimaryTracks)
            or(  abs(ObXOffset+xoffs)>cTrainSupressXOffset)) then
          begin
            // Winkel berechnen
            if secTrack.switch_turned<0 then
              RoutePart.Add(CmdFreeObj(zPosition-ObZOffset+25,
                                -1,GetFreeobjIndex(o.Folder,o.Objectfilename),
                                -ObXOffset+xoffs,o.yoffset+sectrack.p1.height,180-o.angle))
            else
              RoutePart.Add(CmdFreeObj(zPosition+ObZOffset,
                                -1,GetFreeobjIndex(o.Folder,o.Objectfilename),
                                ObXOffset+xoffs,o.yoffset+sectrack.p1.height,-o.angle));
            ExportedFreeObjects.Add(o);
          end;
        end;
      end;
    end;
    // signal an secondary track?
    if xoffs<>0 then
    begin

      // Signal-Dummy in Gegenrichtung aufstellen
//      postid := GetFreeobjIndex(GetFromProject.DefaultObjects.values['signalpost']);
      backid := GetFreeobjIndex(GetFromProject.DefaultObjects.values['signalback']);
      for j1:=1 to 3 do
        signaldummyid[j1] := GetFreeobjIndex('signals','signal_dummy'+inttostr(j1)+'.b3d');

      for j1:=0 to GetFromProject.Signals.count-1 do
      begin
        sig := GetFromProject.Signals[j1] as TRBSignal;
        if sig.connectionid = secTrack.ID then
        begin
          postid := GetFreeobjIndex(GetFromProject.DefaultObjects.values['signalpost']);
          if (sig.PostObjName<>'') then
            postid := GetFreeobjIndex(sig.PostObjName);

          if not turn then
          begin
            if(sig.Direction=1) then
            begin
              RoutePart.Add(CmdFreeObj(ZPos,-1,postid,xoffs+sig.xoffs,hoehe,winkel));
              // Signalschirm-Objekt
              RoutePart.Add(CmdFreeObj(ZPos,-1,signaldummyid[ord(sig.SignalType)],xoffs+sig.xoffs,hoehe+sig.yoffs,winkel));
              // Rückseite
              //RoutePart.Add(CmdFreeObj(ZPos,-1,backid,xoffs+sig.xoffs,hoehe+sig.yoffs,winkel));
            end
            else
            begin
              RoutePart.Add(CmdFreeObj(ZPos+25,-1,postid,xoffs-sig.xoffs,hoehe,180+winkel));
              // Signalschirm-Objekt
              RoutePart.Add(CmdFreeObj(ZPos+25,-1,signaldummyid[ord(sig.SignalType)],xoffs-sig.xoffs,hoehe+sig.yoffs,180+winkel));
              // Rückseite
              RoutePart.Add(CmdFreeObj(ZPos+25,-1,backid,xoffs-sig.xoffs,hoehe+sig.yoffs,180+winkel));
            end;
          end
          else // turned
          begin
            if(sig.Direction=-1) then
            begin
              RoutePart.Add(CmdFreeObj(ZPos-25,-1,postid,xoffs+sig.xoffs,hoehe,winkel+180));
              // Signalschirm-Objekt
              RoutePart.Add(CmdFreeObj(ZPos-25,-1,signaldummyid[ord(sig.SignalType)],xoffs+sig.xoffs,hoehe+sig.yoffs,winkel+180));
              // Rückseite
              //RoutePart.Add(CmdFreeObj(ZPos-25,-1,backid,xoffs+sig.xoffs,hoehe+sig.yoffs,winkel+180));
            end
            else
            begin
              RoutePart.Add(CmdFreeObj(ZPos,-1,postid,xoffs-sig.xoffs,hoehe,winkel));
              // Signalschirm-Objekt
              RoutePart.Add(CmdFreeObj(ZPos,-1,signaldummyid[ord(sig.SignalType)],xoffs-sig.xoffs,hoehe+sig.yoffs,winkel));
              // Rückseite
              RoutePart.Add(CmdFreeObj(ZPos,-1,backid,xoffs-sig.xoffs,hoehe+sig.yoffs,winkel));
            end;
          end;
        end;
      end;
    end;

  end;

  //--------------------------------------------------------------------------
  procedure ExportTrack();
  begin
    // es folgt das eigentliche Gleis
    // Weiche?
    if (Track.special in [csSwitchLeftUpStraight,csSwitchLeftUpCurve, csSwitchRightUpStraight,csSwitchRightUpCurve ])
    and(TrackTypeHasSwitch(Track.texture)) then
    begin
      // unsichtbares Gleis
      RoutePart.Add(CmdRailType(ZPosition,0,GetTrackTypeIndex(0,0),Track.p1.height));
      aa := 0;
      // Weichenobjekt
      switchobjectfilename := '';
      if Track.special in [csSwitchLeftUpStraight,csSwitchLeftUpCurve] then
      begin
        if curve=0 then
          switchobjectfilename := tracktypeswitchobject(Track.Texture,spLeft,spRight)
        else
        begin
          switchobjectfilename := tracktypeswitchobject(Track.Texture,spLeft,spLeft);
          aa := 4.5;
        end;
      end
      else
      if Track.special in [csSwitchRightUpStraight,csSwitchRightUpCurve] then
      begin
        if curve=0 then
          switchobjectfilename := tracktypeswitchobject(Track.Texture,spRight,spLeft)
        else
        begin
          switchobjectfilename := tracktypeswitchobject(Track.Texture,spRight,spRight);
          aa := -4.5;
        end;
      end;
      // Weiche hinzufügen
      if switchobjectfilename<>'' then
      begin
        if Track.switch_turned*direction<0 then
        begin
          if nextcurve=0 then
            RoutePart.Add(CmdFreeObj(zPosition+25,
                                  -1,GetFreeobjIndex('tracks',switchobjectfilename),
                                  0,track.p1.height,180))
          else
            RoutePart.Add(CmdFreeObj(zPosition+25,
                                  -1,GetFreeobjIndex('tracks',switchobjectfilename),
                                  0,track.p1.height,180-90*25/nextcurve/pi));
        end
        else
          RoutePart.Add(CmdFreeObj(zPosition,
                                  -1,GetFreeobjIndex('tracks',switchobjectfilename),
                                  0,track.p1.height,0+aa));
        // Weichengeräusch induzieren
        RoutePart.Add(CmdSecondaryRailSegmentStart(zPosition,0,sectrackno,0,GetTrackTypeIndex(0,0),0,false));
        RoutePart.Add(CmdSecondaryRailSegmentEnd(zPosition+25,4,sectrackno,0));
        inc(sectrackno);
        if sectrackno>=16 then sectrackno := 1;
      end;
    end
    else
    begin
      if (curve=0)or((curve>FormOptions.MaxCurveSmooth)and FSmooth ) then
      begin
        RoutePart.Add(CmdRailType(ZPosition,0,GetTrackTypeIndex(track.texture,0),Track.p1.height));
      end
      else
      begin
        RoutePart.Add(CmdRailType(ZPosition,0,GetTrackTypeIndex(track.texture,curve),Track.p1.height));
      end;
    end;
    Track.curve_temp := curve;
    if direction>0 then
      TrackExtensions(Track,ZPosition,0,Track.p1.Height,0,false)
    else
//      TrackExtensions(Track,ZPosition+25,0,Track.Height,180,false);
      TrackExtensions(Track,ZPosition,0,Track.p1.Height,0,true);
    if Track.Markerfilename<>'' then
    begin
      RoutePart.Add(CmdMarker(ZPosition,Track.Markerduration,'marker\'+Track.Markerfilename));
      AddObjectToFilelist('marker',Track.Markerfilename);
    end;
//    TrackPropertiesCmd(Track,ZPosition,0,direction,RoutePart,prevpolestype);
  end;

  //----------------------------------------------------------------------------
  function GetCurve(track1,track2: TRBConnection): integer;
  begin
    if (track1<>nil) then
    begin
   {   if track1.special=csSwitchLeftUpCurve then
      begin
        a := -Track2.GetAngle(track1) + 180*25/cSwitchCurveAngle/pi/2;
      end
      else
      if track1.special=csSwitchRightUpCurve then
      begin
        a := -Track2.GetAngle(track1) - 180*25/cSwitchCurveAngle/pi/2;
      end
      else   }
      begin
        a := -Track2.GetAngle(track1);
      end;
      if a=0 then
        result := 0
      else
        result := round((25*180)/pi/a);
    end;

    if FSmooth then
    begin
      if (abs(result)>FormOptions.MaxCurveSmooth) then
        // begradigen
        result := 0
      else // Radius auf Vielfache von 25 runden
        result := 25*((result+12) div 25);

      if result<>0 then
      begin
        result := max(FormOptions.MinCurve,abs(result))*sgn(result);
      //  a := 25*180/pi/result;
      end;
    end;
    // Weichen
    if Track2.special in [csFixed,csSwitchLeftUpStraight,csSwitchRightUpStraight] then
      result := 0;
    if Track2.special=csSwitchLeftUpCurve then
      result :=  -round(cSwitchCurveAngle)*Track2.switch_turned*direction;
    if Track2.special=csSwitchRightUpCurve then
      result := +round(cSwitchCurveAngle)*Track2.switch_turned*direction;
    // feste Kurven
    if Track2.special=csFixedCurveLeft then
      result := -round(cSwitchCurveAngle)*Track2.switch_turned*direction;
    if Track2.special=csFixedCurveRight then
      result := +round(cSwitchCurveAngle)*Track2.switch_turned*direction;
  end;
  //------------------------------------------------------------------------------
  procedure ExportFreeObjects();
  var ii: integer;
      hk: double;
  begin
    for ii:=0 to GetFromProject.Freeobjects.Count-1 do
    begin
      // noch nicht exportiert?
      if ExportedFreeObjects.IndexOf(GetFromProject.Freeobjects[ii])<0 then
      begin
        o := GetFromProject.Freeobjects[ii] as TRBObject;
        if o.boundtoConnID=0 then
        begin
          if IsPointInSegment(Pos1.point,Pos2.point,o.point,cSearchWidth,ao,bo) then
          begin
            ObZOffset := ao*Distance(Pos1.point,Pos2.point);
            ObXOffset := bo*cSearchWidth;
            if (ZPosition+ObZOffset>0) then
            begin
              // supress trains on this track
              if (((o.Folder<>'trains')or FormOptions.ExportTrainsOnPrimaryTracks)or(abs(ObXOffset)>cTrainSupressXOffset)) then
              begin
                // Winkel berechnen
                oalpha := (angle(Pos1.point,Pos2.point)-90)
                        - o.angle;
                while oalpha>360 do oalpha:=oalpha-360;
                while oalpha<-360 do oalpha:=oalpha+360;
                hk := 0;
                if bve4 then hk := track.p1.height;

                RoutePart.Add(CmdFreeObj(zPosition+ObZOffset,
                                    -1,GetFreeobjIndex(o.Folder,o.Objectfilename),
                                    ObXOffset,o.yoffset-hk{-track.height},oalpha));
                ExportedFreeObjects.Add(o);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  //---------------------------------------------------------------------------
  procedure ExportSecondaryTrack();
  var grid: TRBGrid;
      griditem,primarygriditem: TRBGridItem;
      ii,i1,i2,jj,jbest,sdirection: integer;
      an,an1,best,seccurve,dist1,dist2,tt,pdist1,pdist2,hk: double;
      secTrack,rootconn: TRBConnection;
      trackobj: string;
      tob: TRBTrackObject;
      PIntersect: TDoublePoint;
      already_exported_track_here: boolean;
  begin
    grid := GetFromProject.GetConnectionParentGrid(Track.id);
    if grid<>nil then
    begin
      primarygriditem := grid.GetGridItemByID(Track.id);
      rootconn := FConnections.FindByID(grid.RootConnection);
      for ii:=0 to grid.Count-1 do
      begin
        griditem := grid.items[ii] as TRBGridItem;
        if (griditem.z=primarygriditem.z)and(griditem.id<>primarygriditem.id)then
        begin
          secTrack := FConnections.FindByID(griditem.id);
          if (secTrack<>nil) then
//          and(not (secTrack.special in [csSwitchLeftUpCurve,csSwitchRightUpCurve])) then
          begin
            // Abstände
            if Track.SkalarProduct(secTrack)<0 then secTrack.Turn;

            //begin
            dist1 := distance(Track.P1.point,secTrack.P1.point);
            dist2 := distance(Track.P2.point,secTrack.P2.point);

            // auf welcher Seite liegt dist1?
            if (dist2<>0) then
            begin
              // Winkel des Dreiecks Track.P1, Track.P2, secTrack.P2
              an1 := Track.GetAngle(secTrack.P2.point);
              if an1>180  then an1 := an1-360;
              if an1<-180 then an1 := an1+360;
              if not((an1>0)and(an1<90)) then dist2 := -dist2;
            end;
            if (dist1<>0) then
            begin
              // Winkel des Dreiecks Track.P2, Track.P1, secTrack.P1
              an1 := -angle(Track.P2.point,Track.P1.point) + angle(Track.p2.point,secTrack.p1.point);
              if an1>180  then an1 := an1-360;
              if an1<-180 then an1 := an1+360;
              if not((an1>0)and(an1<90)) then dist1 := -dist1;
            end;

            try
            an := arcsin((dist2-dist1)/25)*180/pi;
            except
            an := 0;
            end;
            // folgende Kurve berücksichtigen
            if curve+nextcurve<>0 then
              an1 := an -180*25/(curve+nextcurve)/pi/2
            else
              an1 := an;
            // nur exportieren wenn noch nicht exportiert
            // wurde an dieser Stelle des Grids schonmal ein Track exportiert?
            already_exported_track_here := false;
            for jj:=0 to grid.count-1 do
            begin
              if ((grid.items[jj] as TRBGridItem).x=griditem.x)
              and((grid.items[jj] as TRBGridItem).z=griditem.z)
              and(ExportedTracks.FindByID((grid.items[jj] as TRBGridItem).id)<>nil) then
              begin
                already_exported_track_here := true;
                break;
              end;
            end;
            if ((not already_exported_track_here)or FormOptions.MultipleTracksInGrid())and(not (secTrack.special in [csSwitchRightUpCurve,csSwitchLeftUpCurve])) then
//            if (ExportedTracks.indexof(secTrack)<0)and(griditem.x<>primarygriditem.x)then
            begin
              if secTrack.special in [csFixed] then
              begin
                trackobj :=FormTrackTypes.GetTrackDefinitionObject(secTrack.Texture,0);
              end
              else if secTrack.special in [csFixedCurveLeft] then
                trackobj :=FormTrackTypes.GetTrackDefinitionObject(secTrack.Texture,-round(cSwitchCurveAngle))
              else if secTrack.special in [csFixedCurveRight] then
                trackobj :=FormTrackTypes.GetTrackDefinitionObject(secTrack.Texture,round(cSwitchCurveAngle))
              else if secTrack.special in [csSwitchRightUpStraight] then
                trackobj :='tracks\'+tracktypeswitchobject(secTrack.Texture,spRight,spLeft)
              else if secTrack.special in [csSwitchLeftUpStraight] then
                trackobj :='tracks\'+tracktypeswitchobject(secTrack.Texture,spLeft,spRight);

              if secTrack.P1.height<> secTrack.P2.height then
              begin
                // create pitched track
                tob := TRBTrackObject.Create(trackobj);
                tob.MakePitchTrack((secTrack.P2.height-secTrack.P1.height)*secTrack.switch_turned);
                trackobj := tob.GetPath;
                tob.free;
              end;


              // Unterdrücken von Geradeaus-Stücken von Weichen, wenn Abzweig gefahren wird
              if  (not (secTrack.special in [csSwitchLeftUpStraight,csSwitchRightUpStraight])
               or (griditem.x<>primarygriditem.x)) then
              begin
                hk := 0;
                if bve4 then hk := track.p1.height;
                //if track.SkalarProduct(secTrack)*ddirection<0 then
                if secTrack.switch_turned<0 then
                begin
                  RoutePart.Add(CmdFreeObj(Track.z_temp+25,-1,GetFreeobjIndex(trackobj),
                      dist2,secTrack.p2.height-hk,180+an1));
                end
                else
                  RoutePart.Add(CmdFreeObj(Track.z_temp,-1,GetFreeobjIndex(trackobj),
                    dist1,secTrack.p1.height-hk,an));
              end;
              ExportedTracks.AddConnection(secTrack);
            end;
            // Erweiterungen: Platform/Roof/Poles/Dikes
            hk := 0;
            if bve4 then hk := track.p1.height;
            if secTrack.switch_turned<0 then
//            if track.SkalarProduct(secTrack)*ddirection<0 then
            begin
{              if (dist1-dist2)>0 then
                TrackExtensions(secTrack,Track.z_temp+25,dist2,secTrack.height,180-an1,
                 false)
              else}
                TrackExtensions(secTrack,Track.z_temp+25,dist2,secTrack.p2.height-hk,180+an1,
                 true)
            end
            else
              TrackExtensions(secTrack,Track.z_temp,dist1,secTrack.p1.height-hk,an,
                 false);
{            for jj:=0 to grid.count-1 do
            begin
              if ((grid.items[jj] as TRBGridItem).x=griditem.x)and((grid.items[jj] as TRBGridItem).z=griditem.z) then
              begin
                secTrack := FConnections.FindByID((grid.items[jj] as TRBGridItem).Id);
                ExportedTracks.AddConnection(secTrack);
              end;
            end;}
          end;
        end;
      end;
    end;
//    else
    begin
      // nicht-grid-tracks suchen
      // letzte gefundene Tracks kopieren
      setlength(FoundSecTracks,0);
      setlength(FoundSecTracksX,0);
      setlength(LastFoundSecTracks,0);
      setlength(LastFoundSecTracksX,0);
      // suche Schnittpunkte
      i1:=0; i2 := 0;
      for jj:=0 to SecondaryTracks.Count-1 do
      begin
        secTrack := SecondaryTracks.GetConnection(jj);
        grid := GetFromProject.GetConnectionParentGrid(secTrack.id);
        if {(ExportedTracks.IndexOf(secTrack)<0)and}(grid=nil) then
        begin
          // an P1 rechts
          if Intersection( Track.GetPointBetween(cPerpendicularSearchDist),  Track.GetPerpendicular1(cSearchwidth,cPerpendicularSearchDist),
                  secTrack.P1.point,secTrack.P2.point, PIntersect ) then
          begin
            setlength(LastFoundSecTracksX,i1+1);
            setlength(LastFoundSecTracks,i1+1);
            LastFoundSecTracksX[i1] := -direction*Distance( Track.GetPointBetween(cPerpendicularSearchDist), PIntersect );
            LastFoundSecTracks[i1] := SecTrack;
            inc(i1);
          end;
          // links
          if Intersection( Track.GetPointBetween(cPerpendicularSearchDist),  Track.GetPerpendicular1(-cSearchwidth,cPerpendicularSearchDist),
                  secTrack.P1.point,secTrack.P2.point, PIntersect ) then
          begin
            setlength(LastFoundSecTracksX,i1+1);
            setlength(LastFoundSecTracks,i1+1);
            LastFoundSecTracksX[i1] := direction*Distance( Track.GetPointBetween(cPerpendicularSearchDist), PIntersect );
            LastFoundSecTracks[i1] := SecTrack;
            inc(i1);
          end;

          // an P2 rechts
          if Intersection( Track.GetPointBetween(1-cPerpendicularSearchDist),  Track.GetPerpendicular2(-cSearchwidth,cPerpendicularSearchDist),
                  secTrack.P1.point,secTrack.P2.point, PIntersect ) then
          begin
            setlength(FoundSecTracksX,i2+1);
            setlength(FoundSecTracks,i2+1);
            FoundSecTracksX[i2] := -direction*Distance( Track.GetPointBetween(1-cPerpendicularSearchDist), PIntersect );
            FoundSecTracks[i2] := SecTrack;
            inc(i2);
          end;
          // rechts
          if Intersection( Track.GetPointBetween(1-cPerpendicularSearchDist),  Track.GetPerpendicular2(cSearchwidth,cPerpendicularSearchDist),
                  secTrack.P1.point,secTrack.P2.point, PIntersect ) then
          begin
            setlength(FoundSecTracksX,i2+1);
            setlength(FoundSecTracks,i2+1);
            FoundSecTracksX[i2] := direction*Distance( Track.GetPointBetween(1-cPerpendicularSearchDist), PIntersect );
            FoundSecTracks[i2] := SecTrack;
            inc(i2);
          end;

        end;
      end;
      // Nachbargleise gefunden?
      if(length(FoundSecTracksX)>0) then
      begin
        // sortieren von FoundSecTracksX
        if(length(FoundSecTracksX)>1) then
          Quicksort(FoundSecTracksX);
        for ii:=0 to length(FoundSecTracksX)-1 do
        begin
          an := 0; jbest := -1; best := 12;
          // falls Anzahl Nachbargleise identisch mit letztem Segment...
          if(length(FoundSecTracksX)=length(LastFoundSecTracksX)) then
          begin
            jbest := ii;
          end
          else
          begin
            // suche passende Position
            for jj:=0 to length(LastFoundSecTracksX)-1 do
            begin
              if (abs(FoundSecTracksX[ii]-LastFoundSecTracksX[jj]) < best) then
              begin
                best := abs(FoundSecTracksX[ii]-LastFoundSecTracksX[jj]);
                jbest :=jj;
              end;
            end;
          end;
          // passendes gefunden?
          if jbest<>-1 then
          begin
            sectrack := LastFoundSecTracks[jbest];
            seccurve := sectrack.GetAngle(FoundSecTracks[ii]);
            if seccurve<>0 then
              seccurve := 180*25/seccurve/pi
            else
            begin
              // Parallelgleis?
              if (abs(abs(FoundSecTracksX[ii])-cParalleltrackdist)<cparallelTrackDev)
              and(abs(abs(LastFoundSecTracksX[ii])-cParalleltrackdist)<cparallelTrackDev) then
              begin
                seccurve := Track.curve_temp*sgn(ddirection);
                if (Track.curve_temp<>0) then
                begin
                  if (FoundSecTracksX[ii]<0)  then
                    seccurve := (Track.curve_temp+FoundSecTracksX[ii])*sgn(ddirection)
                  else
                    seccurve := (Track.curve_temp+FoundSecTracksX[ii])*sgn(ddirection);
                end;
              end;
            end;
            dist1 := LastFoundSecTracksX[jbest];
            dist2 := FoundSecTracksX[ii];
            // tauschen falls nötig
            if ddirection<0 then
            begin
              tt := dist1; dist1 := dist2; dist2 := tt;
              seccurve := -seccurve;
            end;

            // Parallelgleischeck
          {  pdist1 := -999;
            pdist2 := -999;
            if (abs(cParalleltrackdist*round(dist1/cParalleltrackdist)-dist1)<cparallelTrackDev) then
              pdist1 := cParalleltrackdist*round(dist1/cParalleltrackdist);
            if (abs(cParalleltrackdist*round(dist2/cParalleltrackdist)-dist2)<cparallelTrackDev) then
              pdist2 := cParalleltrackdist*round(dist2/cParalleltrackdist);
            if(pdist1=pdist2)and(pdist1<>-999)and(pdist2<>-999)then
            begin
              dist1 := pdist1;
              dist2 := pdist2;
            end;   }
            an := (arctan((dist2-dist1)/25)*180/pi);
            if(dist1=dist2) then
            begin
              if Track.curve_temp=0 then
                seccurve := 0
              else
                seccurve := Track.curve_temp -dist1;
              an := 0;
            end;
            if (seccurve>FormOptions.MaxCurveSmooth)and FSmooth then seccurve := 0;
            trackobj :=FormTrackTypes.GetTrackDefinitionObject(secTrack.Texture,round(seccurve));
            hk := 0;
            if bve4 then hk := track.p1.height;

            if secTrack.P1.height<> secTrack.P2.height then
            begin
              // create pitched track
              tob := TRBTrackObject.Create(trackobj);
              tob.MakePitchTrack((secTrack.P2.height-secTrack.P1.height)*secTrack.switch_turned);
              trackobj := tob.GetPath;
              tob.free;
            end;

            RoutePart.Add(CmdFreeObj(Track.z_temp,-1,GetFreeobjIndex(trackobj),
                  dist1,secTrack.p1.height-hk{-Track.height},an));
            // Erweiterungen: Platform/Roof/Poles/Dikes
            TrackExtensions(secTrack,Track.z_temp,dist1,secTrack.p1.height-hk{-Track.height},an,
               (Track.skalarproduct(secTrack)*ddirection<0));
            // invalidieren
            LastFoundSecTracksX[jbest] := 99e19;
          end
          else // kein passender bisheriger SecTrack gefunden
          begin
            sectrack := FoundSecTracks[ii];
            seccurve := curve;
            if seccurve<>0 then
              seccurve := 180*25/seccurve/pi;
            trackobj :=FormTrackTypes.GetTrackDefinitionObject(secTrack.Texture,round(seccurve));
            dist1 := FoundSecTracksX[ii];
            an := 0;
            if Track.z_temp>=0 then
            begin
              hk := 0;
              if bve4 then hk := track.p1.height;

              if secTrack.P1.height<> secTrack.P2.height then
              begin
                // create pitched track
                tob := TRBTrackObject.Create(trackobj);
                tob.MakePitchTrack((secTrack.P2.height-secTrack.P1.height)*secTrack.switch_turned);
                trackobj := tob.GetPath;
                tob.free;
              end;

              RoutePart.Add(CmdFreeObj(Track.z_temp,-1,GetFreeobjIndex(trackobj),
                  dist1,secTrack.p1.height-hk{-Track.height},an));
              // Erweiterungen: Platform/Roof/Poles/Dikes
              TrackExtensions(secTrack,Track.z_temp,dist1,secTrack.p1.height-hk{-Track.height},an,
               (Track.skalarproduct(secTrack)*ddirection<0));
            end;
          end;
        end;
      end;
    end;
  end;

//==============================================================================
begin

  Statuslines.add('Writing Railway');    //Caption für Status im Exportformular
  FormExport.ExportStatusProgress.Position:=45;  //Progress für Gauge im Exportformular
  Application.ProcessMessages();

  ExportInterface.Add('with Track');

  // Start bei 0
  ZPosition:=0;

  // Initialisierungen
  Tmplist:= TRBConnectionlist.create();
  Tmplist.OwnsObjects := false;
  ExportedTracks:= TRBConnectionlist.create();
  ExportedTracks.OwnsObjects := false; // war true???
  SecondaryTracks:= TRBConnectionlist.create();
  SecondaryTracks.OwnsObjects := false; // wichtig, da beim entfernen aus der Liste sonst die Objekte selbst gelöscht werden!
  setlength(LastFoundSecTracksX,0);
  setlength(FoundSecTracksX,0);
  setlength(FoundSecTracks,0);
  connlist:= TRBConnectionlist.create();
  connlist.OwnsObjects := false; // wichtig, da beim entfernen aus der Liste sonst die Objekte selbst gelöscht werden!
  ExportedFreeObjects := TObjectlist.create();
  ExportedFreeObjects.OwnsObjects := false;
  RoutePart := TStringlist.create;
  RoutePart.Sorted := false;
  for i:=1 to 16 do
  begin
    railendindex[i] := -1;
    railxoffset[i]  := 0;
  end;

  // Start bei Startuhrzeit (TODO: übernehmen aus Fahrplan)
  CurrentTime := DepartureTime;

  // Streckenstück-Zwischenspeicher löschen
  RoutePart.Clear();


  // Sekundärtrack-Liste erzeugen
  SecondaryTracks.Clear();
  for i:=0 to FConnections.count-1 do
  begin
    if  FPrimaryConnections.IndexOf( FConnections.GetConnection(i) )<0 then
      SecondaryTracks.AddConnection(FConnections.GetConnection(i) );
  end;


    PrevTrack := nil;

    // ermittle Starttrack
    Track := FPrimaryConnections.GetConnection(StartIndex);

    sectrackno := 1;
    i := StartIndex;
    sec := 0;
    trackcount := 0;
    PrevPolesType := -99;

    drawconnlist := TRBConnectionList.Create;
    drawconnlist.OwnsObjects := false;

    // Die RouteDefinition durchlaufen
    repeat
      if dest_reached then dec(NearTheEnd,25);
      plen := 0;
      j := i;

      Track := FPrimaryConnections.GetConnection(j);
      j := j+Direction;

      FormExport.ExportStatusProgress.Position := 45+((45*trackcount) div FPrimaryConnections.count);
      FormExport.ExportStatusText.Caption := 'Laying track '+inttostr(trackcount)+'/'+inttostr(FPrimaryConnections.count);
      inc(trackcount);
      Application.ProcessMessages();

      // ermittle nächsten Track
      if (j<FPrimaryConnections.Count)and(j>=0) then
        NextTrack := FPrimaryConnections.GetConnection(j)
      else NextTrack:=nil;

      if Track<>nil then
      begin
        curve := 0;
        nextcurve := 0;
        if NextTrack<>nil then
        begin
          if Track.p2=NextTrack.P1 then
            ddirection := 1
          else
            ddirection := -1;
        end;
        // berechne Radius
        if PrevTrack<>nil then curve := GetCurve(PrevTrack, Track);
        if NextTrack<>nil then nextcurve := GetCurve(Track, NextTrack);

        if (trackcount<>0)and(curve<>0) then
          RoutePart.Add(CmdCurve(ZPosition,curve,round(FormOptions.GetCurveBankingFactor*Track.Speedlimit*Track.Speedlimit/curve)))
        else
          RoutePart.Add(CmdCurve(ZPosition,0,0));

        if direction=1 then
        begin
          Pos1 := Track.P1;
          Pos2 := Track.P2;
        end
        else
        begin
          Pos1 := Track.P2;
          Pos2 := Track.P1;
        end;

        plen := plen + Track.GetLength();

        // Fahrzeit
        sec := sec + (Track.getLength()/(Track.Speedlimit*1000))*3600;

        Track.z_temp := ZPosition;

        TrackProperties();

        ExportStation();

        ExportSignal();

        // diesen Track in die Liste der exportierten aufnehmen (damit er nicht versehentlich nochmal exportiert wird, als Parallelgleis oder so)
        ExportedTracks.add(Track);
        PrevTrack := Track;

        ExportTrack();

        ExportSecondaryTrack();

        ExportFreeObjects();

        drawconnlist.Add(Track);
        if assigned(DrawConnections) then
        begin
          DrawConnections(drawconnlist);
        end;
        drawconnlist.Clear;

        // weiter geht es bei...
        ZPosition := ZPosition + 25;//plen;
      end; // if track<>nil

      i := j;//+Direction;

    until (i>=FPrimaryConnections.count)or(i<0)or(dest_reached and (NearTheEnd<=0));

    drawconnlist.free;

    if assigned(DrawConnections) then
    begin
      DrawConnections(FPrimaryConnections);
    end;

    //----------------------------Sekundärgleise-----------------------------
 {   currentSecTrackNumber := 1;
    repeat
      FormExport.ExportStatusText.caption := 'exporting secondary track ' + inttostr(currentSecTrackNumber) + '...';
      found_unexported := false;
      for i:=0 to FConnections.count-1 do
      begin
        FormExport.ProgressBar2.Position := (i*100) div FConnections.count;
        Application.ProcessMessages();
        if ExportedTracks.IndexOf(FConnections.GetConnection(i))<0 then
        begin
          found_unexported := true;
          ExportSecondaryTracks(FConnections.GetConnection(i),ExportedTracks,RoutePart,direction);
          break;
        end;
      end;
    until found_unexported=false;    }


    Statuslines.add('Sorting Commands');    //Caption für Status im Exportformular

    // sortiere RoutePart aufsteigend
//    RoutePart.Sort();
    RoutePart.CustomSort(RoutePartcompare);

    // erstelltes Stück dem Export hinzufügen
    ExportInterface.addstrings(RoutePart);

 {   if trackcount<FPrimaryConnections.count then
    begin
      MessageDlg('Not all connections of RouteDefinition could be exported.', mtWarning, [mbOK], 0);
    end;      }

    FormExport.ExportStatusProgress.Position:=90;    //Progress für Gauge im Exportformular
//  except
//    MessageDlg('Exception while Exporting.', mtError, [mbCancel], 0);
//  end;

  RoutePart.free;
  ExportedTracks.free;
  SecondaryTracks.free;
  TmpList.free;
  connlist.free;
end;

procedure TRBExport_Mod.SecSwitchCorrection(RoutePart: TStringlist; last_z: double; var b: double);
var i,j: integer;
    s: string;
    o: double;
begin
  for i:=1 to cMaxSecTrackNumber do
  begin
    j := FindInStringlist(RoutePart,CmdSecondaryRailSegmentCmdOnly(last_z,i));
    if j>=0 then
    begin
      // ermittle Offset an dieser Stelle
      s := copy(RoutePart[j],length(CmdSecondaryRailSegmentCmdOnly(last_z,i))+1,999);
      o := strtofloat1( StrGetToken(s,';',1)     );
      if abs(o-b)<cswitchdevsec then b := o;
      exit;
    end;
  end;
end;

function TRBExport_Mod.getSecTrackOffset(routePart: TStringlist; z: double; trackno: integer): double;
var j: integer;
    s: string;
begin
  j := FindInStringlist(RoutePart,CmdSecondaryRailSegmentCmdOnly(z,trackno));
  if j<0 then
    result := 0
  else
  begin
    s := copy(RoutePart[j],length(CmdSecondaryRailSegmentCmdOnly(z,trackno)),999);
    result := strtofloat( StrGetToken(s,';',1) );
  end;
end;


// Funktion: ExportSecondaryTracks
// Autor   : up
// Datum   : 11.1.03
// Beschr. : exportiert rekursiv startend ab starttrack alle noch nicht exportierten Tracks als Sekundärgleise
// Hinweis : Diese Funktion ist kompliziert.
procedure TRBExport_Mod.ExportSecondaryTracks(starttrack: TRBConnection; exportedTracks: TRBConnectionlist; RoutePart: TStringlist; direction: integer);
var SecondaryTracks,connlist: TRBConnectionlist;
    cc,i,j,directionsec,
    curve,
    oldsectracknumber: integer;
    P,P1: TRBPoint;
    PriTrack,Track,PrevTrack: TRBConnection;
    to_be_exported: boolean;
    a,b,last_z,last_sec_z: double;
    PIntersect: TDoublePoint;
    last_conn, first_conn: boolean;
    grid: TRBGrid;
    griditem,PriGriditem: TRBGridItem;
    prevpolestype: string;

  procedure CheckSecTrackNumber();
  begin
    cc := 0;
    oldsectracknumber := currentSecTrackNumber;
    while not SecTrackNumberPossibleAt(RoutePart,currentSecTrackNumber,last_z)
       or not SecTrackNumberPossibleAt(RoutePart,currentSecTrackNumber,last_z+25) do
    begin
      // falls Gleis bereits begonnen, beende es (25m zurück)
      inc(currentSecTrackNumber);
      inc(cc);
      if currentSecTrackNumber>cMaxSecTrackNumber then  currentSecTrackNumber := 1;
      if cc>cMaxSecTrackNumber then begin inc(badSecTrackNumbers); break; end;
    end;
    if (not first_conn) and (oldsectracknumber<>currentSecTrackNumber) then
    begin
      RoutePart.Add(CmdSecondaryRailSegmentEnd(last_sec_z,b,oldsectracknumber,Track.YPosition));
    end;
  end;

  procedure CalcCurve(fak: integer);
  begin
    if FormOptions.CurvedSecondary and (PrevTrack<>nil) then
    begin
      a := -Track.GetAngle(PrevTrack);
      if a=0 then
        curve := 0
      else
        curve := round((25*180)/pi/a);
      if FSmooth then
      begin
        if (abs(curve)>FormOptions.MaxCurveSmooth) then
          // begradigen
          curve := 0
        else // Radius auf Vielfache von 25 runden
          curve := 25*((curve+12) div 25);

        if curve<>0 then
        begin
          curve := max(FormOptions.MinCurve,abs(curve))*sgn(curve);
          a := 25*180/pi/curve;
        end;
      end;
    end
    else
      curve := 0;
    // Weichen
    if Track.special in [csFixed,csSwitchLeftUpStraight,csSwitchRightUpStraight] then
      curve := 0;

    if Track.special=csSwitchLeftUpCurve then
      curve := -round(cSwitchCurveAngle);
    if Track.special=csSwitchRightUpCurve then
      curve := round(cSwitchCurveAngle);
  {  if Track.special=csSwitchLeftDownCurve then
      curve := -round(cSwitchCurveAngle);
    if Track.special=csSwitchRightDownCurve then
      curve := round(cSwitchCurveAngle);}
    curve := curve*fak;
  end;

  procedure AddRoutePart(start: boolean);
  var switchobjectfilename: string;
  begin
    // switch?
    if (Track.special in [csSwitchLeftUpStraight,csSwitchLeftUpCurve, csSwitchRightUpStraight,csSwitchRightUpCurve ])
    and(TrackTypeHasSwitch(Track.texture)) then
    begin
      // unsichtbares Gleis
      if start then
        RoutePart.Add( CmdSecondaryRailSegmentStart(last_sec_z,b,currentSecTrackNumber,Track.p1.height-PriTrack.p1.Height,GetTrackTypeIndex(0,0),track.id,first_conn) )
      else
      begin
        RoutePart.Add( CmdSecondaryRailSegmentEnd(((round(last_sec_z) div 25) * 25)+25,b,currentSecTrackNumber,Track.YPosition) );
      end;
      // Weichenobjekt
      // TODO: Orientierung ermitteln etc.
      switchobjectfilename := '';
      if Track.special = csSwitchLeftUpStraight then
      begin
        if curve=0 then
          switchobjectfilename := tracktypeswitchobject(Track.Texture,spLeft,spRight)
        else
          switchobjectfilename := tracktypeswitchobject(Track.Texture,spLeft,spLeft);
      end
      else
      if Track.special = csSwitchRightUpStraight then
      begin
        if curve=0 then
          switchobjectfilename := tracktypeswitchobject(Track.Texture,spRight,spLeft)
        else
          switchobjectfilename := tracktypeswitchobject(Track.Texture,spRight,spRight);
      end;
      // Weiche hinzufügen
      if switchobjectfilename<>'' then
      begin
        if Track.switch_turned*direction<0 then
          RoutePart.Add(CmdFreeObj(last_sec_z+25,
                                  currentSecTrackNumber,GetFreeobjIndex('tracks',switchobjectfilename),
                                  0,track.p1.height,180))
        else
          RoutePart.Add(CmdFreeObj(last_sec_z,
                                  currentSecTrackNumber,GetFreeobjIndex('tracks',switchobjectfilename),
                                  0,track.p1.height,0));
      end;
    end
    else
    begin
      if start then
      begin
        if (curve=0)or((curve>FormOptions.MaxCurveSmooth)and FSmooth ) then
        begin
          RoutePart.Add( CmdSecondaryRailSegmentStart(last_sec_z,b,currentSecTrackNumber,Track.p1.height-PriTrack.p1.Height,GetTrackTypeIndex(track.texture,0),track.id,first_conn) );
        end
        else
        begin
          RoutePart.Add( CmdSecondaryRailSegmentStart(last_sec_z,b,currentSecTrackNumber,Track.p1.height-PriTrack.p1.Height,GetTrackTypeIndex(track.texture,curve),track.id,first_conn) );
        end;
      end
      else
      begin
        if directionsec=1 then
        begin
          if b<>0 then SecSwitchCorrection(RoutePart,((round(last_sec_z) div 25) * 25)+25,b);
          RoutePart.Add( CmdSecondaryRailSegmentEnd(((round(last_sec_z) div 25) * 25)+25,b,currentSecTrackNumber,Track.YPosition) );
        end
        else
        begin
          if b<>0 then SecSwitchCorrection(RoutePart,((round(last_sec_z) div 25) * 25)+25,b);
          RoutePart.Add( CmdSecondaryRailSegmentEnd(((round(last_sec_z) div 25) * 25)+25,b,currentSecTrackNumber,Track.YPosition) );
        end;
      end;
    end;
  end;

begin
  // wurde dieser starttrack nicht schon exportiert?
  if exportedTracks.IndexOf(starttrack)>=0 then exit;
  last_sec_z := 0;
  SecondaryTracks := TRBConnectionlist.create;
  SecondaryTracks.OwnsObjects := false;
  connlist := TRBConnectionlist.create;
  connlist.OwnsObjects := false;
  // suche in die eine Richtung
  P := starttrack.P2;
  track := starttrack;
  prevpolestype := 'xxx';
  // den Starttrack hinzufügen
  SecondaryTracks.AddConnection(starttrack);
  repeat
    FConnections.FindConnectionsAtPoint(P,connlist,track);
    prevtrack := Track;
    if connlist.Count>0 then
    begin
      // ignoriere falls schon exportiert
      for i:=connlist.count-1 downto 0 do
      begin
        if exportedTracks.indexof(connlist.GetConnection(i))>=0 then
        begin
          connlist.Delete(i);
        end;
      end;
      // jetzt immer noch was vorhanden?
      if connlist.count>0 then
      begin
        // nimm die erste connection
        track := connlist.GetConnection(0);
        if track.P2=P then Track.Turn;
        // Gegenrichtung (Weiche, nicht spitz abbiegen!)?
        if Track.SkalarProduct(PrevTrack)<0 then connlist.Delete(0);
        if connlist.count>0 then
        begin
          track := connlist.GetConnWithSmallestAngle(PrevTrack);
          if track.P2=P then Track.Turn;
          SecondaryTracks.AddConnection(track);
          P := track.GetPointButNot(P);
        end;
      end;
    end;
  until connlist.count=0;
  // andere Richtung
  track := starttrack;
//  track.turn;
  P := track.P1;
  repeat
    FConnections.FindConnectionsAtPoint(P,connlist,track);
    if connlist.Count>0 then
    begin
      // ignoriere falls schon exportiert
      for i:=connlist.count-1 downto 0 do
      begin
        if exportedTracks.indexof(connlist.GetConnection(i))>=0 then
        begin
          connlist.Delete(i);
        end;
      end;
      // jetzt immer noch was vorhanden?
      if connlist.count>0 then
      begin
        // nimm die erste connection
        track := connlist.GetConnection(0);
        if track.P1=P then Track.Turn;
        // Gegenrichtung (Weiche, nicht spitz abbiegen!)?
        if Track.SkalarProduct(PrevTrack)<0 then connlist.Delete(0);
        if connlist.count>0 then
        begin
          track := connlist.GetConnWithSmallestAngle(PrevTrack);
          if track.P1=P then Track.Turn;
          SecondaryTracks.AddConnection(track);
          P := track.GetPointButNot(P);
        end;
      end;
    end;
  until connlist.count=0;

  //---
  if SecondaryTracks.Count>0 then
  begin
    FormExport.ExportStatusText.caption := 'exporting secondary track ' + inttostr(currentSecTrackNumber) + ' ('
     + inttostr(SecondaryTracks.count) + ' connections)...';

    last_z:=-1;
    // nun die PrimaryConnections durchgehen und jeweils den Abstand zum SecondaryTrack berechnen
    if direction=-1 then
      i := FPrimaryConnections.Count-1
    else
      i := 0;
    last_conn := false;
    first_conn := true;
    while true do
    begin
      if direction=1 then
      begin
        if i=FPrimaryConnections.count-1 then last_conn := true;
      end
      else
      begin
        if i=0 then last_conn := true;
      end;
      PriTrack := FPrimaryConnections.GetConnection(i);
      // is dieser Track in einem Grid?
      grid := GetFromProject.GetConnectionParentGrid(PriTrack.id);
      if grid=nil then
      begin
        // Schnittpunkt zwischen Senkrechter und SecondaryTrack suchen
        Track := nil;
        for j:=0 to SecondaryTracks.count-1 do
        begin
          PrevTrack := Track;
          Track := SecondaryTracks.GetConnection(j);
       //   if ExportedTracks.IndexOf(Track)<0 then
          begin
            directionSec := sgn(PriTrack.SkalarProduct(Track));
           // if direction>0 then
            begin
              // eine Seite
              if Intersection( PriTrack.P1.point,  PriTrack.GetPerpendicular1(cSearchwidth,0.01),
                Track.P1.point,Track.P2.point, PIntersect )
  //              and (IsPointInSegment(PriTrack.P1.point,PriTrack.P2.point,Track.P2.point,cSearchWidth,b,b)
  //              and IsPointInSegment(PriTrack.P1.point,PriTrack.P2.point,Track.P1.point,cSearchWidth,b,b))
                then
              begin
                b := -direction*Distance( PriTrack.P1.point, PIntersect );
                if abs(b)<csearchWidth then
                begin
                  // Gleis erzeugen
                  last_z := PriTrack.z_temp;
                  CheckSecTrackNumber();
                  if (round(last_z) mod 25=0)and(FindInStringlist(RoutePart,CmdSecondaryRailSegmentCmdOnly(last_z,currentSecTrackNumber) )<0)
                  and((first_conn and (last_z<>0))or(b<>0)) then
                  begin
                    if FSmooth then ParallelTrack(b);
                    Track.b_temp := b;
                    CalcCurve(directionsec*direction*Track.switch_turned);
  //          directionSec := sgn(PriTrack.SkalarProduct(Track));
                    if first_conn then last_sec_z := last_z else last_sec_z := last_sec_z+25;
                    AddRoutePart(true);
                    if first_conn then
                    begin
                      TrackPropertiesCmd(Track,last_z,currentSecTrackNumber,directionSec*direction,RoutePart,prevpolestype);
                      last_sec_z := last_sec_z + 25;
                    end
                    else
                    begin
                      while(last_sec_z <= last_z) do
                      begin
                        TrackPropertiesCmd(Track,last_sec_z,currentSecTrackNumber,directionSec*direction,RoutePart,prevpolestype);
                        last_sec_z := last_sec_z + 25;
                      end;
                    end;
       //             exportedTracks.Add(Track);
                    last_sec_z := last_z;
                    first_conn := false;
                  end;
                  break;
                end;
              end
              else
              // andere Seite
              if Intersection( PriTrack.P1.point,  PriTrack.GetPerpendicular1(-cSearchwidth,0.01),
                Track.P1.point,Track.P2.point, PIntersect )
  //              and (IsPointInSegment(PriTrack.P1.point,PriTrack.P2.point,Track.P2.point,cSearchWidth,b,b)
  //              and IsPointInSegment(PriTrack.P1.point,PriTrack.P2.point,Track.P1.point,cSearchWidth,b,b))
                then
              begin
                b := direction*Distance( PriTrack.P1.point, PIntersect );
                if abs(b)<csearchWidth then
                begin
                  // Gleis erzeugen
                  last_z := PriTrack.z_temp;
                  CheckSecTrackNumber();
                  if (round(last_z) mod 25=0)and(FindInStringlist(RoutePart,CmdSecondaryRailSegmentCmdOnly(last_z,currentSecTrackNumber) )<0)
                  and((first_conn and (last_z<>0))or(b<>0)) then
                  begin
                    if FSmooth then ParallelTrack(b);
                    Track.b_temp := b;
                    CalcCurve(directionsec*direction*Track.switch_turned);
  //          directionSec := sgn(PriTrack.SkalarProduct(Track));
                    if first_conn then last_sec_z := last_z else last_sec_z := last_sec_z+25;
                    AddRoutePart(true);
                    if first_conn then
                      TrackPropertiesCmd(Track,last_z,currentSecTrackNumber,directionSec*direction,RoutePart,prevpolestype)
                    else
                    begin
                      while(last_sec_z <= last_z) do
                      begin
                        TrackPropertiesCmd(Track,last_sec_z,currentSecTrackNumber,directionSec*direction,RoutePart,prevpolestype);
                        last_sec_z := last_sec_z + 25;
                      end;
                    end;
         //           exportedTracks.Add(Track);
                    last_sec_z := last_z;
    //                TrackPropertiesCmd(Track,last_z,currentSecTrackNumber,directionSec*direction,RoutePart,prevpolestype);
                    first_conn := false;
                  end;
                  break;
                end;
              end;
            end;
            PrevTrack := Track;
          end; // if not exported
        end; // for j
      end
      else
      begin
        // PriTrack is in grid
        priGridItem := grid.GetGridItemByID(PriTrack.id);
        for j:=0 to SecondaryTracks.count-1 do
        begin
          Track := SecondaryTracks.GetConnection(j);
          // ist der Track ein Nachbartrack des Primärtracks?
          griditem := grid.GetGridItemByID(Track.id);
          if (griditem<>nil)and(griditem.z=priGriditem.z) then
          begin
            // Gleis erzeugen
            directionSec := sgn(PriTrack.SkalarProduct(Track));
            last_z := 5*floor((PriTrack.z_temp)/5);
            b := (griditem.x-prigriditem.x)*cParalleltrackdist*direction;
            CheckSecTrackNumber();
            if (round(last_z) mod 25=0)and(FindInStringlist(RoutePart,CmdSecondaryRailSegmentCmdOnly(last_z,currentSecTrackNumber) )<0)
            and((first_conn and (last_z<>0))or(b<>0)) then
            begin
              if FSmooth then ParallelTrack(b);
              Track.b_temp := b;
              CalcCurve(directionsec*direction*Track.switch_turned);
//          directionSec := sgn(PriTrack.SkalarProduct(Track));
              if first_conn then last_sec_z := last_z else last_sec_z := last_sec_z+25;
              AddRoutePart(true);
              if first_conn then
              begin
                TrackPropertiesCmd(Track,last_z,currentSecTrackNumber,directionSec*direction,RoutePart,prevpolestype);
                last_sec_z := last_sec_z + 25;
              end
              else
              begin
                while(last_sec_z <= last_z) do
                begin
                  TrackPropertiesCmd(Track,last_sec_z,currentSecTrackNumber,directionSec*direction,RoutePart,prevpolestype);
                  last_sec_z := last_sec_z + 25;
                end;
              end;
 //             exportedTracks.Add(Track);
              last_sec_z := last_z;
              first_conn := false;
            end;
            PrevTrack := Track;
            break;

          end; // if griditem
        end; // for sec

      end; // if grid<>0 else
      if direction=1 then
      begin
        inc(i);
        if i=FPrimaryConnections.count then break;
      end
      else
      begin
        dec(i);
        if i=-1 then break;
      end;
    end; // Schleife über Primärgleise

    // als exportiert markieren
    for j:=0 to SecondaryTracks.count-1 do
    begin
      exportedTracks.AddConnection(SecondaryTracks.GetConnection(j));
    end;
    if last_sec_z>0 then
    begin
      AddRoutePart(false);
 {     if directionsec=1 then
      begin
        if b<>0 then SecSwitchCorrection(RoutePart,((round(last_sec_z) div 25) * 25)+25,b);
        RoutePart.Add( CmdSecondaryRailSegmentEnd(((round(last_sec_z) div 25) * 25)+25,b,currentSecTrackNumber,Track.YPosition) );
      end
      else
      begin
        if b<>0 then SecSwitchCorrection(RoutePart,((round(last_sec_z) div 25) * 25)+25,b);
        RoutePart.Add( CmdSecondaryRailSegmentEnd(((round(last_sec_z) div 25) * 25)+25,b,currentSecTrackNumber,Track.YPosition) );
      end;
       }
      inc(currentSecTrackNumber);
      if currentSecTrackNumber>cMaxSecTrackNumber then  currentSecTrackNumber := 1; // TODO
      if assigned(DrawConnections) then DrawConnections(SecondaryTracks);
      last_sec_z := 0;
    end
{    if (last_z=0) or (first_conn) then
    begin
      // hier wurde ein Gleis begonnen und nicht fortgeführt. Das müssen wir löschen.
      j := RoutePart.IndexOf( CmdSecondaryRailSegmentCmdOnly(0,currentSecTrackNumber) );
      if j>=0 then
        RoutePart.Delete(j);
    end;}

  end
  else
  begin
    // leeres Streckenstück (sollte eigentlich nicht auftreten)
    exportedTracks.AddConnection(startTrack);
  end;
  SecondaryTracks.free;
  connlist.free;
end;

procedure TRBExport_Mod.Paralleltrack(var dist: double);
begin
  if(abs(dist)<=cSwitchdev) then dist := 0;

  if (abs(dist)>=GetFromProject.ParallelTrackDist-cParalleltrackdev)
  and(abs(dist)<=GetFromProject.ParallelTrackDist+cParalleltrackdev) then
  begin
    dist := sgn(dist)*GetFromProject.ParallelTrackDist;
  end;
end;

procedure TRBExport_Mod.ExportToCsv(_Train, asubdir: String; Routes: TStrings);
var
 sl,trainsection: TStringList;
 i,j,direction: integer;
begin
  Statuslines.Add('Preparing');
  Application.ProcessMessages;
  FExportRDs := Routes;
  dest_reached := false;
  badSecTrackNumbers := 0;
  FreeObjID_Stopsign := -1;
  subdir := asubdir;
  Filelist.clear();

  ExportFile.Clear();
  Credits.clear();
  
  // ermittle zu exportierende RouteDefinitions
{  RD := GetFromProject.Routes[RouteID] as TRBRoutedefinition;

  if RD.Count=0 then
  begin
    MessageDlg( lngmsg.GetMsg('trbexport_no_conn'), mtError, [mbCancel], 0);
    exit;
  end;         }

  // Export-Preprocessing
  if not GetFromProject.ExportPreprocess then
  begin
    MessageDlg( lngmsg.GetMsg( 'trbexport_prepare_error'), mtError, [mbCancel], 0);
    exit;
  end;

  // kopiere die Connections (Grund siehe eins weiter)
  FormExport.ExportStatusProgress.Position:=1;      //Progress für Gauge im Exportformular
  CopyConnections();

  // verbessere die Connections (da dies die connections verändert, arbeiten wir auf einer Kopie)
  // dies füllt gleichzeitig die FPrimaryConnections-Liste mit den (verbesserten) Tracks des Hauptgleises
  Statuslines.Add('Improving connections');
  Application.ProcessMessages;
  FormExport.ExportStatusProgress.Position:=30;      //Progress für Gauge im Exportformular
  ImproveConnections25();

  // ordne die Einzelstücke in der aktuellen Route richtig herum (P1 der nächsten = P2 der vorigen)
  Statuslines.Add('Getting route');
  Application.ProcessMessages;

  
 { sl := TStringlist.create;
  for i:=0 to FPrimaryConnections.Count-1 do
  begin
    sl.add(inttostr(FPrimaryConnections.getConnection(i).id)+'='+ floattostr(FPrimaryConnections.getConnection(i).P1.point.x)
      +#9+floattostr(FPrimaryConnections.getConnection(i).P1.point.y)
      +#9+floattostr(FPrimaryConnections.getConnection(i).P2.point.x)
      +#9+floattostr(FPrimaryConnections.getConnection(i).P2.point.y));
  end;
  sl.SaveToFile(extractfilepath(application.ExeName)+'\debugcoord.csv');
  sl.free;     }
  // Suche Startpunkt und Richtung
  FindStations(direction);

  // setze strecke richtig zusammen, direction ist danach immer 1 (vorwärts durchlaufen)
  if not SetRouteConnectionsOrientations(FPrimaryConnections,startindex,direction) then
  begin
    //MessageDlg('Destination station not reached.', mtError, [mbCancel], 0);
    exit;
  end;

  // Suche nochmal den Start- und Endpunkt, er kann sich verändert haben
  FindStations(direction);

  // debug:
  //create coordinate output
 { sl := TStringlist.create;
  for i:=0 to FPrimaryConnections.Count-1 do
  begin
    sl.add(floattostr(FPrimaryConnections.getConnection(i).P1.point.x)
      +#9+floattostr(FPrimaryConnections.getConnection(i).P1.point.y));
  end;
  sl.SaveToFile(extractfilepath(application.ExeName)+'\debugcoord.csv');
  sl.free;     }


  Statuslines.Add('Exporting');
  application.ProcessMessages;

  FTimetable := TRBExportTimetable.Create(TRBTimetableItem);

  // erzeuge Kopf des csv-Files
  FormExport.ExportStatusProgress.Position:=91;      //Progress für Gauge im Exportformular
  ExportHeader(Exportfile);

  Exportfile.Add(traindef_placeholder);

  // erzeuge Objektbereich
  FormExport.ExportStatusProgress.Position:=92;      //Progress für Gauge im Exportformular

  Header.Clear;
  ExportObjectSection(Exportfile);

  // erzeuge Streckenbereich
  FormExport.ExportStatusProgress.Position:=94;      //Progress für Gauge im Exportformular
  ExportRailwaySection(Exportfile, direction);

  if badSecTrackNumbers>0 then
     Statuslines.Add('secondary track overruns: ' + inttostr(badSecTrackNumbers));

  FormExport.ExportStatusProgress.Position:=96;    //Progress für Gauge im Exportformular

  ExportObjectSectionPass2(Header);

  // Header einfügen
  ReplacePlaceholder(Exportfile,objectdef_placeholder,Header);

  // erzeuge Train-Bereich // TODO: die richtigen Sounds zuordnen, daher erst hinterher!
  FormExport.ExportStatusProgress.Position:=98;      //Progress für Gauge im Exportformular
  trainsection := TStringlist.create;
  Train := TRBTrain.Create;
  Train.Load(_Train);
  ExportTrainSection(Trainsection, _Train);

  // Trainsection einfügen
  ReplacePlaceholder(Exportfile,traindef_placeholder,Trainsection);
  trainsection.free;

  if BVE4 then
  begin
    FTimetable.Name := Timetable;
    FTimetable.Train := Train;
    FTimetable.ExportAsBitmap( ExtractFilePath(Application.ExeName) + '\' + formoptions.GetObjectFolder + '\misc\timetable_'+Timetable+'.bmp');
    filelist.Add('\misc\timetable_'+Timetable+'.bmp');
  end;

  FormExport.ExportStatusProgress.Position:=100;    //Progress für Gauge im Exportformular

  Statuslines.Add('FreeObj Count='+inttostr(FObjCount));

  Statuslines.Add('Completed.');

  FTimetable.free;


end;

// Funktion: TrackPropertiesCmd
// Autor   : up
// Datum   : 7.1.03
// Beschr. : erzeugt alle Track-Eigenschaften-Kommandos
procedure TRBExport_Mod.TrackPropertiesCmd(Track: TRBConnection; zposition: double; trackno,direction: integer; RoutePart: TStrings; var prevpolestype: string);
var PolesType: string;
begin
  // Bahnsteig?
  if Track.PlatformPos>0 then
  begin
    if direction=1 then
      RoutePart.Add(CmdForm(ZPosition,trackno,Track.PlatformPos,Track.RoofType,Track.Platformtype))
    else
      RoutePart.Add(CmdForm(ZPosition,trackno,3-Track.PlatformPos,Track.RoofType,Track.Platformtype));
  end;

  // Walls?
  if Track.WallLeft<>'' then
  begin
    // wallend löschen?
    if direction=1 then
    begin
      if RoutePart.indexof(CmdDikeEnd(ZPosition,trackno))>=0 then
        RoutePart.Delete(RoutePart.indexof(CmdDikeEnd(ZPosition,trackno)));
      RoutePart.Add(CmdDike(ZPosition,trackno,-1,Track.WallLeft));
      RoutePart.Add(CmdDikeEnd(ZPosition+25,trackno));
    end
    else
    begin
      if RoutePart.indexof(CmdWallEnd(ZPosition,trackno))>=0 then
        RoutePart.Delete(RoutePart.indexof(CmdWallEnd(ZPosition,trackno)));
      RoutePart.Add(CmdWall(ZPosition,trackno,1,Track.WallLeft));
      RoutePart.Add(CmdWallEnd(ZPosition+25,trackno));
    end
  end;
  if Track.WallRight<>'' then
  begin
    if direction=1 then
    begin
      if RoutePart.indexof(CmdWallEnd(ZPosition,trackno))>=0 then
        RoutePart.Delete(RoutePart.indexof(CmdWallEnd(ZPosition,trackno)));
      RoutePart.Add(CmdWall(ZPosition,trackno,1,Track.WallRight));
      RoutePart.Add(CmdWallEnd(ZPosition+25,trackno));
    end
    else
    begin
      if RoutePart.indexof(CmdDikeEnd(ZPosition,trackno))>=0 then
        RoutePart.Delete(RoutePart.indexof(CmdDikeEnd(ZPosition,trackno)));
      RoutePart.Add(CmdDike(ZPosition,trackno,-1,Track.WallRight));
      RoutePart.Add(CmdDikeEnd(ZPosition+25,trackno));
    end;
  end;

  // Bahnsteig und Masten auf der gleichen Seite?
  if ((Track.PlatformPos=1)and(Track.PolesPos=1))or((Track.PlatformPos=2)and(Track.PolesPos=-1)) then
    PolesType:='pole_db2.b3d' // langer Ausleger
  else
    PolesType:=track.PolesType; // kurzer Ausleger}

  // Oberleitung
  if (PrevPolesType<>PolesType)  then
  begin
    begin
//      if direction=-1 then PolesType := -PolesType;
      // wenn rechts keine Schienen liegen, Masten rechts
      //if not TrackRightpresent then PoleSide := -1
      // wenn rechts keine Schienen liegen, Masten links
      //else if not TrackLeftpresent then PoleSide := 1
      //else
      // links und rechts liegen Schienen, TODO: Turmmast aufstellen
//            PoleSide := -1;
      if (Track.PolesPos=0)or(Track.PolesType='') then
        RoutePart.Add(CmdPoleEnd(ZPosition,trackno))
      else
        RoutePart.Add(CmdPoles(ZPosition,trackno,0,Track.PolesPos,25,Polestype))
    end;
  end;
  PrevPolesType := PolesType;
end;

function TRBExport_Mod.CmdRailType(distance: double; tracknumber,texture: integer; height: double): string;
begin
  if BVE4 then
    result := floattostrpoint(distance,maxcommadigits) + ', .railtype ' + inttostr(tracknumber) + ';' + inttostr(texture)
  else
    result := floattostrpoint(distance,maxcommadigits) + ', .railtype ' + inttostr(tracknumber) + ';' + inttostr(texture) + ' , .height ' + floattostrpoint(height,maxcommadigits);
end;

function TRBExport_Mod.CmdForm(distance: double; tracknumber,PlatformPos: integer; const roof,platformtype: string): string;
begin
  result := floattostrpoint(distance,maxcommadigits)+ ', .form ' + inttostr(tracknumber) + ';'
          + PlatformPosChar(PlatformPos) + ';' + inttostr( GetRoofIndex( roof ) )
          +';'+inttostr( GetPlatformIndex( Platformtype ));
end;

function TRBExport_Mod.CmdPoles(distance: double; tracknumber,trackcount,side,interval: integer; const poletype: string): string;
begin
  result := floattostrpoint(distance,maxcommadigits)+ ', .pole '+inttostr(tracknumber)
   +';'+inttostr(trackcount)+';'+inttostr(side)+';'+inttostr(interval)
   +';'+inttostr(GetPoleIndex( poletype) );
end;

function TRBExport_Mod.CmdPoleEnd(distance: double; tracknumber: integer): string;
begin
  result := floattostrpoint(distance,maxcommadigits)+ ', .poleend '+inttostr(tracknumber);
end;

// side= -1 für links, +1 für rechts
function TRBExport_Mod.CmdWall(distance: double; tracknumber,side: integer; const wall: string): string;
begin
  result := floattostrpoint(distance,maxcommadigits)+ ', .wall '+inttostr(Tracknumber)+';'
           +inttostr(side)+';'+inttostr( GetWallIndex( wall ) );
end;

function TRBExport_Mod.CmdWallEnd(distance: double; tracknumber: integer): string;
begin
  result := floattostrpoint(distance,maxcommadigits)+ ', .wallend '+inttostr(Tracknumber);
end;

// side= -1 für links, +1 für rechts
function TRBExport_Mod.CmdDike(distance: double; tracknumber,side: integer; const wall: string): string;
begin
  result := floattostrpoint(distance,maxcommadigits)+ ', .dike '+inttostr(Tracknumber)+';'
           +inttostr(side)+';'+inttostr(GetWallIndex(wall));
end;

function TRBExport_Mod.CmdDikeEnd(distance: double; tracknumber: integer): string;
begin
  result := floattostrpoint(distance,maxcommadigits)+ ', .dikeend '+inttostr(Tracknumber);
end;

function TRBExport_Mod.CmdCrack(distance: double; tracknumber1,tracknumber2,texture: integer): string;
begin
  result := floattostrpoint(distance,maxcommadigits)+', .crack ' + inttostr(tracknumber1) + ';' + inttostr(tracknumber2)+';'+inttostr(texture);
end;

function TRBExport_Mod.CmdPitch(distance: double; promille: integer): string;
begin
  result := floattostrpoint(distance,maxcommadigits)+', .pitch ' + inttostr(promille);
end;

function TRBExport_Mod.CmdCurve(distance,curve,railheight: double): string;
begin
  result := floattostrpoint(distance,maxcommadigits)+', .curve '+floattostrpoint(curve,maxcommadigits)+';'+floattostrpoint(railheight,maxcommadigits);
end;

function TRBExport_Mod.CmdMarker(distance,duration: double; const filename: string): string;
var folder,obj: string;
begin
  result := floattostrpoint(distance,maxcommadigits)+', .Marker '+subdir+'\'+filename+';'+floattostrpoint(duration,maxcommadigits);
  folder := strgettoken(filename,'\',1);
  obj := strgettoken(filename,'\',2);
  AddObjectToFilelist(folder,obj);
end;

function TRBExport_Mod.CmdFreeObj(distance: double; tracknumber,objid: integer; xoffset,height,angle: double): string;
var _angle: double;
   _tracknumber : integer;
begin
  if objid<0 then exit;
  _tracknumber := tracknumber;
  if bve4 and(_tracknumber=-1) then _tracknumber :=0;
  _angle := angle;
  while _angle>360 do _angle := _angle-360;
  while _angle<-360 do _angle := _angle+360;
  result := floattostrPoint(distance)+', .freeobj ' + inttostr(_tracknumber) + ';'
     + inttostr(objid)+';'+floattostrPoint(xoffset,maxcommadigits) + ';'+ floattostrPoint(height,maxcommadigits) + ';' + floattostrpoint(_angle,maxcommadigits);
  inc(FObjCount);
end;

function TRBExport_Mod.CmdStop(distance: double; side: integer): string;
begin
  result := floattostrPoint(distance,maxcommadigits)+', .stop ' + inttostr(side);
end;

function TRBExport_Mod.CmdSecondaryRailSegmentStart(startdistance,startx: double; trackno: integer; height: double; texture,id: integer; switch_possible: boolean): string;
var _startx: double;
    i: integer;
begin
  if (abs(startx)<cSwitchdev)and switch_possible  then _startx := 0 else _startx := startx;
  result := floattostrpoint(startdistance,maxcommadigits)+', .rail '+inttostr(trackno)+';'+floattostrPoint(_startx) +';'+floattostrpoint(height,maxcommadigits)+';'+inttostr(texture) + '    ;id=' + inttostr(id);
end;

function TRBExport_Mod.CmdSecondaryRailSegmentCmdOnly(startdistance: double; trackno: integer): string;
begin
  result := floattostrpoint(startdistance,maxcommadigits)+', .rail '+inttostr(trackno)+';';
end;

function TRBExport_Mod.CmdSecondaryRailSegmentEnd(enddistance,endx: double; trackno: integer; height: double): string;
var _endx: double;
begin
  if (abs(endx)<cSwitchdev) then _endx := 0 else _endx := endx;
  result := floattostrpoint(enddistance,maxcommadigits)+', .railend '+inttostr(trackno)+';'+floattostrPoint(_endx,maxcommadigits)
 // +';'+inttostr(height);
end;

// Funktion: FindExportedTrack
// Autor   : up
// Datum   : 22.10.02
// Beschr. : durchsucht die SecTrackExportInfo-Objektliste list nach dem Track atrack.
function TRBExport_Mod.FindExportedTrack(list: TObjectlist; atrack: TRBConnection): TSecTrackExportInfo;
var i: integer;
begin
  for i:=0 to list.count-1 do
  begin
    if (list[i] as TSecTrackExportInfo).track=atrack then
    begin
      result := list[i] as TSecTrackExportInfo;
      exit;
    end;
  end;
  result := nil;
end;

// Funktion: FindExportedTrack
// Autor   : up
// Datum   : 22.10.02
// Beschr. : durchsucht die SecTrackExportInfo-Objektliste list nach dem Point atrack.
function TRBExport_Mod.FindExportedTrack(list: TObjectlist; p: TRBPoint): TSecTrackExportInfo;
var i: integer;
begin
  for i:=0 to list.count-1 do
  begin
    if ((list[i] as TSecTrackExportInfo).track.P1=p)or((list[i] as TSecTrackExportInfo).track.P2=p) then
    begin
      result := list[i] as TSecTrackExportInfo;
      exit;
    end;
  end;
  result := nil;
end;

// Funktion: GetMatchingExportedTrack
// Autor   : up
// Datum   : 22.10.02
// Beschr. : sucht in list nach ExportInfo mit dem gegebenen Punkt
// und gibt bei Erfolg in z und x die beim export verwendeten Werte zurück
// falls kein solcher Punkt bisher exportiert wurde: false
function TRBExport_Mod.GetMatchingExportedTrack(list: TObjectlist; p: TRBPoint; var z,x,trackno: integer): boolean;
var ExportInfo: TSecTrackExportInfo;
begin
  result := false;
  ExportInfo := FindExportedTrack(list,p);
  if ExportInfo<>nil then
  begin
    if ExportInfo.track.P1=p then
    begin
      trackno := ExportInfo.trackno;
      if ExportInfo.backwards then
      begin
        z := ExportInfo.secend;
        x := ExportInfo.secendx;
      end
      else
      begin
        z := ExportInfo.secstart;
        x := ExportInfo.secstartx;
      end;
      result := true;
    end;
    if ExportInfo.track.P2=p then
    begin
      trackno := ExportInfo.trackno;
      if ExportInfo.backwards then
      begin
        z := ExportInfo.secstart;
        x := ExportInfo.secstartx;
      end
      else
      begin
        z := ExportInfo.secend;
        x := ExportInfo.secendx;
      end;
      result := true;
    end
  end;
end;

destructor TRBExport_Mod.Destroy;
begin
  TrackTexturelist.Free;
  BackGroundTextureList.Free;
  GroundTextureList.Free;
  Walllist.free;
  Rooflist.free;

  Credits.free;
  FPoints.free;
  FConnections.free;
  FPrimaryConnections.free;
  Header.free;
  UsedTrackObjects.free;
  UsedGrounds.free;
  UsedWalls.free;
  UsedBackgrounds.free;
  UsedFreeObj.free;
  UsedPlatforms.free;
  UsedRoofs.free;
  UsedPoles.free;

  PassStations.free;

  if Train<>nil then
    Train.free;
end;

// kopieren der Connections
procedure TRBExport_Mod.CopyConnections;
var i,j: integer;
    c: TRBConnection;
    p1,p2: TRBPoint;
begin
  FPoints.clear;
  FConnections.clear;
  FPrimaryConnections.clear;
  for i:=0 to GetFromProject.Connections.count-1 do
  begin
    c := TRBConnection.Create(GetFromProject.connections[i] as TRBConnection);
    c.id := (GetFromProject.connections[i] as TRBConnection).id;
    p1 := nil;
    p2 := nil;
    // suche nach eventuell bereits erstellten Punkten
    for j:=0 to FPoints.Count-1 do
    begin
      if Distance((FPoints[j] as TRBPoint).point,c.P1.point)<0.1 then
        p1 := FPoints[j] as TRBPoint;
      if Distance((FPoints[j] as TRBPoint).point,c.P2.point)<0.1 then
        p2 := FPoints[j] as TRBPoint;
    end;
    // nicht gefundene Points erzeugen
    if p1=nil then begin p1 := TRBPoint.create(c.P1); FPoints.add(p1); end;
    if p2=nil then begin p2 := TRBPoint.create(c.P2); FPoints.add(p2); end;
    // Connection verbindet diese Punkte
    c.P1 := p1;
    c.p2 := p2;
    FConnections.add(c);
    FormExport.ExportStatusProgress.Position:=(40*i) div GetFromProject.Connections.count;
  end;
end;

// bezier-Verbesserung der Verbindungen
procedure TRBExport_Mod.ImproveConnections;
var i,j: integer;
    foundunimproved: boolean;
begin
  j := 0;
  for i:=0 to FConnections.count-1 do FConnections.GetConnection(i).improved := false;
  repeat
    foundunimproved := false;
    for i:=0 to FConnections.count-1 do
    begin
      if (not FConnections.GetConnection(i).improved) // bereits verbesserte haben id=0
      and(FConnections.GetConnection(i).GetLength() > cmaxlenimprove) then
      begin
        foundunimproved := true;
        ImproveConnection(FConnections.GetConnection(i));
        break; // da die Liste geändert wurde müssen wir wieder ganz von vorn beginnen
      end
      else
        FConnections.GetConnection(i).improved := true;
    end;
    inc(j);
    FormExport.ExportStatusProgress.Position:=30+(15*j) div FConnections.count;
  until foundunimproved=false;
end;

procedure TRBExport_Mod.ImproveConnections25;
var i,j: integer;
    foundunimproved: boolean;
begin
  j := 0;
  for i:=0 to FConnections.count-1 do FConnections.GetConnection(i).improved := false;
  repeat
    foundunimproved := false;
    for i:=0 to FConnections.count-1 do
    begin
      if (not FConnections.GetConnection(i).improved) then 
      begin
        foundunimproved := true;
        ImproveConnection(FConnections.GetConnection(i),25);
        break; // da die Liste geändert wurde müssen wir wieder ganz von vorn beginnen
      end;
    end;
    inc(j);
    FormExport.ExportStatusProgress.Position:=30+(15*j) div FConnections.count;
  until foundunimproved=false;
end;

// eine Connection bezier-verbessern, so dass die Einzelconnections kürzer oder gleich cmaxlenimprove sind
// seglen wenn dies nicht 0 ist (default)
procedure TRBExport_Mod.ImproveConnection(connstart: TRBConnection; seglen: integer);
var point,Startpoint,Endpoint,Helppoint1,helppoint2: TRBPoint;
    P: TDoublePoint;
    a,anz: integer;
    i,id: integer;
    wave: string;
    l,partlen,mina: double;
    conn,conn2: TRBConnection;
    connlist: TRBConnectionlist;
    helppointsExist: boolean;
    primary: boolean;
    improvedpoints: TObjectlist;
    RD: TRBRouteDefinition;
begin
  connlist := TRBConnectionlist.Create;
  connlist.OwnsObjects := false;
  improvedpoints:= TObjectlist.Create;
  improvedpoints.OwnsObjects := false;
  primary := false;
  // gehört dies zum Hauptgleis? (d.h. in der zu exportierenden RouteDefinition?)
  for i:=0 to FExportRDs.count-1 do
  begin
    RD := (FExportRDs.objects[i]) as TRBRouteDefinition;
    primary := primary or RD.ContainsTrack(connstart.ID);
  end;
  id := 0;
  wave := connstart.Wavefilename;
  // ist an dieser Connection ein Bahnhof? Dann die ID merken und später im neuen Track setzen
 { for i:=0 to GetfromProject.GetStationCount()-1 do
  begin
    if GetFromProject.GetStationByIndex(i).TrackIDIsInStation(connstart.ID) then
    begin
      // ID merken
      id := connstart.id;
    end
  end;              }
  // ID immer merken
  id := connstart.id;

  if seglen=0 then
    partlen := cMaxLenImprove
  else
    partlen := seglen;

  // Länge jedes der neuen Abschnitte
  l := connstart.GetLength();
//  if  (connstart.special in [csStraight,csCurve]) then
    anz := round(l/partlen); // runden
{  else
    anz := (round(l/partlen) div 5) * 5;}

  if anz<=1 then
  begin
    connstart.improved := true;
    if primary then
      FPrimaryConnections.addConnection(connstart);
    exit;
  end;

  FConnections.ImproveConnection(connstart,anz,improvedpoints);

  startpoint := connstart.P1;
  endpoint   := connstart.P2;
  //startpoint.hard := true;

  for i:=0 to improvedpoints.Count-1 do
  begin
      // neue Connection
    Conn := TRBConnection.Create(startpoint,improvedpoints[i] as TRBPoint);
    Conn.CopyProperties(connstart);                  //erhält keine ID!
    conn.improved := true;
    startpoint := improvedpoints[i] as TRBPoint;
    FPoints.Add(startPoint);
    Conn.id := id; // ID nur <>0 an einem Bahnhof, damit die später wieder erkannt werden
    if i=0 then
      conn.wavefilename := wave
    else
      conn.wavefilename := '';
    FConnections.Add(conn);
    if primary then
      FPrimaryConnections.addConnection(conn);
  end;

  // Verbindung zum letzten Punkt
  Conn := TRBConnection.Create(improvedpoints[improvedpoints.Count-1] as TRBPoint,connstart.P2);
  Conn.CopyProperties(connstart);
  Conn.improved := true;
  conn.id := id;
  FConnections.Add(conn);
  if primary then
    FPrimaryConnections.addConnection(conn);

  // alte löschen
  if primary then
    FPrimaryConnections.DeleteConnection(connstart);
  FConnections.DeleteConnection(connstart);
  connlist.Free;
  improvedpoints.free;

end;

// dreht und verschiebt Connections, so dass eine Art verkettete, lineare Liste entsteht,
// neu: deren erste Connection fängt bei P1 an, und an ihrem P2 hängt der P1 der zweiten etc.
// scirection ist immer 1 und entfällt ab sofort!
function TRBExport_Mod.SetRouteConnectionsOrientations(var connlist: TRBConnectionlist; _startindex: integer; var direction: integer): boolean;
var i,n,sdirection,end_countdown: integer;
    tmplist,tmpprimlist: TRBconnectionlist;
    P: TRBPoint;
    track: TRBConnection;
    turned: boolean;
begin
  if connlist=nil then exit;
  
  tmplist := TRBConnectionlist.create;
  tmplist.OwnsObjects := false;
  tmpprimlist := TRBConnectionlist.create;
  tmpprimlist.OwnsObjects := false;
  end_countdown := 0; // Anzahl maximal nach dem eigentlichen Ende zu exportierender Segmente
  // Orientierung prüfen
  // erste Connection (die liegen nicht in der richtigen Reihenfolge, daher Find-Funktion verwenden)
{  if FPrimaryConnections.FindConnectionsAtPoint(FPrimaryConnections.GetConnection(startindex).P2,Tmplist,
                                                FPrimaryConnections.GetConnection(startindex))=0 then
  begin
    // es gibt keine Connection, die an P2 der ersten hängt -> umdrehen
    FPrimaryConnections.GetConnection(startindex).Turn();
  end;}
//  sdirection := 1;
//  repeat
    tmpprimlist.Clear();
    track := connlist.GetConnection(_startindex);
    turned := false;
  repeat
    tmpprimlist.AddConnection(Track);
    i := 0;
    repeat
      //if sdirection>0 then
      //begin
        if connlist.FindConnectionsAtPoint(Track.P2,Tmplist,Track)>0 then
        begin
          // passt P2 an P2?
          if TmpList.GetConnection(0).P2= Track.P2 then
            // umdrehen
            TmpList.GetConnection(0).Turn();
          // bei diesem Track weitermachen
          Track := TmpList.GetConnection(0);
          tmpprimlist.AddConnection(Track);
          if end_countdown>0 then
          begin
            dec(end_countdown);
            if end_countdown=0 then begin end_countdown:=-1; break; end;
          end;
          if Track=connlist.GetConnection(NextIndex) then
          begin
//            end_countdown := cMaxSegmentsAfterEnd;
            end_countdown := FormOptions.DistanceBeyondLast div cMaxLenImprove;
            //break;
          end;
        end
        else break;
      {end
      else
      begin
        if connlist.FindConnectionsAtPoint(Track.P1,Tmplist,Track)>0 then
        begin
          // passt P1 an P1?
          if TmpList.GetConnection(0).P1= Track.P1 then
            // umdrehen
            TmpList.GetConnection(0).Turn();
          // bei diesem Track weitermachen
          Track := TmpList.GetConnection(0);
  //        tmpprimlist.AddConnection(Track);
          tmpprimlist.insertConnection(Track,0);
  //        FPrimaryConnections.MoveConnection(Track,0);
          if end_countdown>0 then
          begin
            dec(end_countdown);
            if end_countdown=0 then begin end_countdown:=-1; break; end;
          end;
          if Track=connlist.GetConnection(NextIndex) then
          begin
            end_countdown := FormOptions.DistanceBeyondLast div cMaxLenImprove;
            //break;
          end;
        end else break;
      end; }
    until (track=nil)or(end_countdown=-1);
    if end_countdown=0 then
    begin
      if (turned) then
      begin
        result := false;
        exit;
      end;
      Track.Turn;
      turned := true;
    end
    else
      Break;
  until track=nil;
  tmplist.free;
//  direction := sdirection;
  // neue, sortierte Liste übernehmen
  connlist.free;
  connlist := tmpprimlist;
  result := true;
end;



// Funktion: AddObjectToFilelist
// Autor   : up
// Datum   : 4.12.02
// Beschr. : fügt ein Objekt mitsamt abhängigen bmps der Dateiliste hinzu
procedure TRBExport_Mod.AddObjectToFilelist(const folder,objfile: string);
var o: TRBObject;
    bl: TStringlist;
    i: integer;
begin
  if objfile='' then exit;
  o := TRBObject.create(folder,objfile);
  bl := TStringlist.Create;
  o.GetBitmaplist(bl);
  if filelist.indexof(folder+'\'+objfile)<0 then
    filelist.Add(folder+'\'+objfile);
  for i:=0 to bl.count-1 do
    if filelist.indexof(folder+'\'+bl[i])<0 then
      filelist.add(folder+'\'+bl[i]);
  bl.free;
  o.free;
end;

// Funktion: TrackObjID
// Autor   : up
// Datum   : 5.12.02
// Beschr. : ermittelt die Objekt-ID des FreeObjekts für das Gleisstück
function TRBExport_Mod.TrackObjID(texture,len: integer; catenary: boolean): integer;
begin
  result := 1;

  inc(result,(texture-1)*8);

  if len=7 then inc(result,2);
  if (len=13)or(len=12) then inc(result,4);
  if len=25 then inc(result,6);

  if catenary then inc(result,1);

end;

procedure TRBExport_Mod.FindStations(var direction: integer);
var i: integer;
begin
  // finde Startbahnhof
  startindex := -1;
  nextindex := -1;
  for i:=0 to FPrimaryConnections.count-1 do
  begin
    if StartStation.TrackIDIsInStation(FPrimaryConnections.GetConnection(i).id) then
    begin
      StartIndex := i;
    end;
    if NExtStation.TrackIDIsInStation(FPrimaryConnections.GetConnection(i).id) then
    begin
      NextIndex := i;
    end;
  end;
  Direction := sgn(NextIndex-StartIndex);
end;

function TRBExport_Mod.SecTrackNumberPossibleAt(Routepart: TStringlist; SecTrackNumber: integer; last_z: double): boolean;
var z,startz,endz: double;
    i,trn: integer;
begin
  result := false;
  if FindInStringlist(RoutePart,CmdSecondaryRailSegmentCmdOnly(last_z,SecTrackNumber))>=0 then exit;
  if FindInStringlist(RoutePart,CmdSecondaryRailSegmentCmdOnly(last_z+25,SecTrackNumber))>=0 then exit;
  result := true;
  exit;
 { startz := 1e10;
  endz   := 0;
  for i:=0 to Routepart.count-1 do
  begin
    ParseRouteCmdRail(Routepart[i],z,trn);
    if (trn=SecTrackNumber) then
    begin
      if z<startz then startz := z;
      if z>endz   then endz   := z;
    end;
  end;
  if(startz>1e10-1)and(endz=0)then
    result := true
  else
    result := (last_z>endz); }
  { for i:=0 to Routepart.count-1 do
  begin
    if ParseRouteCmdRail(Routepart[i],z,trn) and (trn=SecTrackNumber)and(z=last_z) then
    begin
      result := false;
      exit;
    end;
  end;
  result := true;    }
end;

function TRBExport_Mod.ParseRouteCmdRail(const cmd: string; var z: double; var trn: integer): boolean;
var p: integer;
    r: string;
begin
  p := pos('.rail ',cmd);
  if p<=0 then begin result := false; exit; end;
  p := pos(',',cmd);
  z := strtofloat1( copy(cmd,1,p-1) );
  p := pos('.rail ',cmd);
  r := copy(cmd,p+length('.rail')+1,999);
  trn := strtointdef(StrGetToken(r,';',1),0 );
end;

end.
