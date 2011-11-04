unit tRBExport;

interface

uses
uRBProject, tmain, Classes, Math, SysUtils, DateUtils, contnrs, forms,
uRBConnection, uRBPoint, uRBConnectionList,
uRBTrackTexturelist, uRBGroundTexturelist,uRBBackgroundTexturelist, uRBPlatformlist,
uRBCatenaryPoleList, uRBObject, uRBWallList, uRBRooflist,
uRBTrackDefinition, uTrackTypes,
uRBRouteDefinition, uRBStation, uEditorFrame, uTools, uGlobalDef;

const
//  FormOptions.MaxCurveSmooth = 4000; // bei angeschaltetem smoothing werden Kurven mit größeren Radien begradigt
  cMaxTrackXOffset = 100; // Gleise, die weiter als 100 m vom Hauptgleis liegen, enden
  cMaxTrackOffsetCrack = 10; // Abstand, bis zu dem der GleisZwischenraum mit "Crack" gefüllt wird
  cKurvenueberhoehungfaktor =  1.37;
//  cMaxSegmentsAfterEnd = 25;

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
    procedure ExportRailwaySection(ExportInterface:TStringList; RouteId, direction:Integer);
    procedure ExportSecondaryTracks(starttrack: TRBConnection; exportedTracks: TRBConnectionlist; RoutePart: TStringlist; direction: integer);
    procedure GetFromTo(Track,NextTrack: TRBConnection; var Pos1,Pos2: TRBPoint);
    procedure TrackPropertiesCmd(Track: TRBConnection; zposition: double; trackno,direction: integer; RoutePart: TStrings; var prevpolestype: integer);
    function CmdRailType(distance: double; tracknumber,texture: integer; height: double): string;
    function CmdForm(distance: double; tracknumber,PlatformPos,roof,platformtype: integer): string;
    function CmdDike(distance: double; tracknumber,side,wallid: integer): string;
    function CmdDikeEnd(distance: double; tracknumber: integer): string;
    function CmdWall(distance: double; tracknumber,side,wallid: integer): string;
    function CmdWallEnd(distance: double; tracknumber: integer): string;
    function CmdFreeObj(distance: double; tracknumber,objid: integer; xoffset,height,angle: double): string;
    function CmdStop(distance: double; side: integer): string;
    function CmdPoles(distance: double; tracknumber,trackcount,side,interval,poletype: integer): string;
    function CmdPoleEnd(distance: double; tracknumber: integer): string;
    function CmdCrack(distance: double; tracknumber1,tracknumber2,texture: integer): string;
    function CmdSecondaryRailSegmentStart(startdistance,startx: double; trackno: integer; height: double; texture,id: integer; switch_possible: boolean): string;
    function CmdSecondaryRailSegmentCmdOnly(startdistance: double; trackno: integer): string;
    function CmdSecondaryRailSegmentEnd(enddistance,endx: double; trackno: integer; height: double): string;
    function CmdCurve(distance,curve,railheight: double): string;
    function getSecTrackOffset(routePart: TStringlist; z: double; trackno: integer): double;
    procedure SecSwitchCorrection(RoutePart: TStringlist; last_z: double; var b: double);
    function FindExportedTrack(list: TObjectlist; atrack: TRBConnection): TSecTrackExportInfo; overload;
    function FindExportedTrack(list: TObjectlist; p: TRBPoint): TSecTrackExportInfo; overload;
    function GetMatchingExportedTrack(list: TObjectlist; p: TRBPoint; var z,x,trackno: integer): boolean;
    procedure CopyConnections();
    procedure ImproveConnections();
    procedure ImproveConnection(connstart: TRBConnection);
    procedure SetRouteConnectionsOrientations(var connlist: TRBConnectionlist; _startindex: integer; var direction: integer);
    function TrackObjID(texture,len: integer; catenary: boolean): integer;
    procedure FindStations(var direction: integer);
    function GetTrackTypeIndex(tracktype,curve: integer): integer;
    function GetGroundIndex(groundid: integer): integer;
    function GetBackgroundIndex(backgroundid: integer): integer;
    function GetWallIndex(wallid: integer): integer;
    function GetPlatformIndex(platformid: integer): integer;
    function GetRoofIndex(roofid: integer): integer;
    function GetFreeobjIndex(const folder,objname: string): integer;
    function GetPoleIndex(poleid: integer): integer;
    procedure Paralleltrack(var dist: double);
    function SecTrackNumberPossibleAt(Routepart: TStringlist; SecTrackNumber: integer; last_z: double): boolean;
    function ParseRouteCmdRail(const cmd: string; var z: double; var trn: integer): boolean;
   public
    RD: TRBRouteDefinition;
    GetFromProject:TRBProject;
    basepath,subdir,objpath: string;
    filelist: TStrings;
    Exportfile,
    Credits: TStringlist;
    Statuslines: TStrings;
    StartStation,
    NextStation: TRBStation;
    DepartureTime: TDateTime;
    DrawConnections: TRBConnectionListProc;
    badSecTrackNumbers: integer;
    constructor Create(smooth: boolean);
    destructor Destroy;
    procedure ExportToCsv(Train, asubdir: String; RouteId:Integer);
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

  Header := TStringlist.create;
end;


procedure TRBExport_Mod.ExportHeader(ExportInterface: TStringList);
begin
FObjCount := 0;
FormExport.ExportStatusText.Caption:='Writing header...';   //Caption für Status im Exportformular
FormExport.ExportStatusProgress.Position:=5;           //Progress für Gauge im Exportformular

ExportInterface.Add(';made with RouteBuilder ' + VersionString + ' - visit ' + HomepageURL);


ExportInterface.Add('with Route');
ExportInterface.Add('.Comment '+'"'+RD.GetTitle+'"$chr(13)$chr(10)'+GetFromProject.Description+'$chr(13)$chr(10)'+'Created by '+GetFromProject.Author+'$chr(13)$chr(10)'+'-----------------------'+'$chr(13)$chr(10)'+'Made with Route Builder');
ExportInterface.Add('.Timetable '+RD.GetTitle);
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
 GetRoofIndex(0);

 ExportInterface.Add(objectdef_placeholder);

{ ExportInterface.Add('.rail(0) '+subdir+'\tracks\track0.b3d');
 AddObjectToFilelist('tracks','track0.b3d');
 for i:=0 to 9 do
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
   dest.Add('.freeobj('+inttostr(i) +') '
      +subdir+'\'+o.GetPath() );
   AddObjectToFilelist(o.Folder,o.Objectfilename);
   o.free;
 end;
  dest.Add('');
  dest.Add('with Texture');
  //HINTERGRUND-TEXTUREN
 for i:=0 to UsedBackgrounds.Count-1 do begin
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

function TRBExport_Mod.GetGroundIndex(groundid: integer): integer;
var s: string;
begin
  s := GroundTextureList.getObjectfilenamebyID(groundid);
  if usedGrounds.indexof(s)>=0 then
    result := UsedGrounds.indexof(s)
  else
    result := UsedGrounds.add(s);
end;

function TRBExport_Mod.GetBackgroundIndex(backgroundid: integer): integer;
var s: string;
begin
  s := backGroundTextureList.getObjectfilenamebyID(backgroundid);
  if usedbackGrounds.indexof(s)>=0 then
    result := UsedbackGrounds.indexof(s)
  else
    result := Usedbackgrounds.add(s);
end;

function TRBExport_Mod.GetWallIndex(wallid: integer): integer;
var s: string;
begin
  s := WallList.getObjectfilenamebyID(wallid);
  if usedWalls.indexof(s)>=0 then
    result := usedWalls.indexof(s)
  else
    result := usedWalls.add(s);
end;

function TRBExport_Mod.GetPlatformIndex(platformid: integer): integer;
var s: string;
begin
  s := Platformlist.getObjectfilenamebyID(platformid);
  if usedPlatforms.indexof(s)>=0 then
    result := usedPlatforms.indexof(s)
  else
    result := usedPlatforms.add(s);

end;

function TRBExport_Mod.GetRoofIndex(roofid: integer): integer;
var s: string;
begin
  s := Rooflist.getObjectfilenamebyID(roofid);
  if usedRoofs.indexof(s)>=0 then
    result := usedRoofs.indexof(s)
  else
    result := usedRoofs.add(s);

end;

function TRBExport_Mod.GetPoleIndex(poleid: integer): integer;
var s: string;
begin
  s := CatenaryPoleList.getObjectfilenamebyID(poleid);
  if usedPoles.indexof(s)>=0 then
    result := usedPoles.indexof(s)
  else
    result := usedPoles.add(s);

end;

function TRBExport_Mod.GetFreeobjIndex(const folder,objname: string): integer;
var s: string;
begin
  s := folder+'|'+objname;
  if UsedFreeObj.indexof(s)>=0 then
    result := UsedFreeObj.indexof(s)
  else
    result := UsedFreeObj.add(s);
end;


procedure TRBExport_Mod.ExportRailwaySection(ExportInterface:TStringList; RouteId, direction:Integer);
var
  i,j,k,j1,h,ii,x,z,no: Integer;
  SecStart,SecEnd,
  SecStartX,SecEndX,
  ObXOffset,ObZOffset,plen,
  ZPosition,
  seglen,
  oalpha,
  sec,a,aa,aaa,b,a1,a2,b1,b2,bs1,bs2,ao,bo,radsum,
  XSecOffset,XSecOffsetEnd,SecStartxFirst,SecStartAlpha: double;
  backwards: boolean;
  id,curve,
  PoleSide,
  trackcount,
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
  cmd: string;
  CurrentTime:TDateTime;
  ArrivalTimeStr,DepartTimeStr: string;
  Track,NextTrack,PrevTrack,SecTrack,NextSecTrack : TRBConnection; // war ursprünglich membervariable, lokal hier dürfte aber reichen (up)
  TmpList,
  Segments,
  SecondaryTracks,
  connlist,
  ExportedTracks: TRBConnectionlist;
  currsectrack: TRBConnection;
  ExportedFreeObjects: TObjectlist;
  SecTrackStartPoint: TRBPoint;
  ExportInfo: TSecTrackExportInfo;
  RoutePart: TStringlist;
  railendindex: array[1..16] of integer;
  railxoffset: array[1..16] of double;
  first_is_fixed: boolean;
begin

  Statuslines.add('Writing Railway');    //Caption für Status im Exportformular
  FormExport.ExportStatusProgress.Position:=45;  //Progress für Gauge im Exportformular
  Application.ProcessMessages();

  ExportInterface.Add('with Track');

  //TODO

  //FormExport.ExportStatusProgress.Progress:=55;    //Progress für Gauge im Exportformular
  //FormExport.ExportStatusProgress.Progress:=60; //Progress für Gauge im Exportformular

  // Start bei 0
  ZPosition:=0;

  // Initialisierungen
  Tmplist:= TRBConnectionlist.create();
  Tmplist.OwnsObjects := false;
  Segments:= TRBConnectionlist.create();
  Segments.OwnsObjects := false;
  ExportedTracks:= TRBConnectionlist.create();
  ExportedTracks.OwnsObjects := false; // war true???
  SecondaryTracks:= TRBConnectionlist.create();
  SecondaryTracks.OwnsObjects := false; // wichtig, da beim entfernen aus der Liste sonst die Objekte selbst gelöscht werden!
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

  //RoutePart.add(CmdRailType(0,0,1)); // nullrail

//  try

    PrevTrack := nil;

    // ermittle Starttrack
    Track := FPrimaryConnections.GetConnection(StartIndex);

    sectrackno := 1;
    i := StartIndex;
    sec := 0;
    trackcount := 0;
    PrevPolesType := -99;

    // Die RouteDefinition durchlaufen
    repeat

      // ermittle 5 nächste Tracks
      Segments.clear;
      sectrackno := 1;
      plen := 0;
      j := i;
      k := 0;
      first_is_fixed := false;
      repeat
        if (j<FPrimaryConnections.count)and(j>=0) then
        begin
          if (FPrimaryConnections.GetConnection(j).special in [csFixed]) then
          begin
            if k=0 then
            begin
              Segments.AddConnection(FPrimaryConnections.GetConnection(j));
              j := j+Direction;
              first_is_fixed := true
            end
            else
            begin
              if not first_is_fixed then
                // dies ist eine "gefixte" Connection
                // -> sie muss immer am Anfang stehen -> Auffüllen dieser aktuellen5er-Liste
                Segments.AddConnection(FPrimaryConnections.GetConnection(j-Direction))
              else
              begin
                Segments.AddConnection(FPrimaryConnections.GetConnection(j));
                j := j+Direction;
              end;
            end
          end
          else
          begin
            Segments.AddConnection(FPrimaryConnections.GetConnection(j));
            j := j+Direction;
          end;
        end;
        inc(k);
      until (k=25 div cMaxLenImprove) //(j=i-25 div cMaxLenImprove)or(j=i+25 div cMaxLenImprove)
         or (j>=FPrimaryConnections.count)or(j<0);

      FormExport.ExportStatusProgress.Position := 45+((45*trackcount) div FPrimaryConnections.count);
      FormExport.ExportStatusText.Caption := 'Laying track '+inttostr(trackcount)+'/'+inttostr(FPrimaryConnections.count);
      inc(trackcount);
      Application.ProcessMessages();

      // ermittle nächsten Track
      if (j<FPrimaryConnections.Count)and(j>=0) then
        NextTrack := FPrimaryConnections.GetConnection(j)
      else NextTrack:=nil;

      if Segments.count>0 then
      begin
        Track := Segments.GetConnection(0);
        // Alle Segmente zusammen sollten 25 m lang sein
        // Berechnen des "Gesamt"radius: (Näherung) Mittelwert der Radien
        curve := 0;

        // berechne Radius
        if (PrevTrack<>nil) then
        begin
            a := -Segments.GetConnection(Segments.count-1).GetAngle(PrevTrack);
            if a=0 then
              curve := 0
            else
              curve := round((25*180)/pi/a);
        end;

        if FSmooth then
        begin
          if (abs(curve)>FormOptions.MaxCurveSmooth) then
            // begradigen
            curve := 0
          else // Radius auf Vielfache von 25 runden
            curve := 25*((curve+12) div 25);

          if curve<>0 then
          begin
            curve := max(500,abs(curve))*sgn(curve);
            a := 25*180/pi/curve;
          end;
        end;

        if (trackcount<>0)and(curve<>0) then
          RoutePart.Add(CmdCurve(ZPosition,curve,round(cKurvenUeberhoehungFaktor*Track.Speedlimit*Track.Speedlimit/curve)))
        else
          RoutePart.Add(CmdCurve(ZPosition,0,0));

        // erzeuge Eigenschaften-Kommandos
//        TrackPropertiesCmd(Track,ZPosition,0,direction,RoutePart,prevpolestype);

        Pos1 := Track.P1;
        //if NextTrack=nil then
          Pos2 := Segments.GetConnection(Segments.count-1).P2;
//        else
  //        Pos2 := NextTrack.P1;


        // Startwinkel
        aa := -a{/2};
        a := aa;

        for k:=0 to Segments.count-1 do
        begin
          Track := Segments.GetConnection(k);
          plen := plen + Track.GetLength();
          // Fahrzeit
          sec := sec + (Track.getLength()/(Track.Speedlimit*1000))*3600;

          Track.z_temp := ZPosition+k*cMaxLenImprove;

          // Track-Eigenschaften, die es nur bei Primärtracks gibt
          // Track-Eigenschaften: Nebel
          if (PrevTrack=nil) or (PrevTrack.Fog<>Track.Fog) then
          begin
            if Track.Fog<>0 then
              RoutePart.add(floattostrpoint(ZPosition+k*cMaxLenImprove)+', .fog 25;'+inttostr(Track.fog+25)+';224;224;224')
            else
              RoutePart.add(floattostrpoint(ZPosition+k*cMaxLenImprove)+', .fog 0;0;0;0;0');
          end;

          // Track-Eigenschaften: Adhesion
          if (PrevTrack=nil) or (PrevTrack.Adhesion<>Track.Adhesion) then
          begin
            RoutePart.add(floattostrpoint(ZPosition+k*cMaxLenImprove)+', .adhesion '+inttostr(Track.Adhesion));
          end;

          // Track-Eigenschaften: Limit
          if (PrevTrack=nil) or (PrevTrack.Speedlimit<>Track.Speedlimit) then
          begin
            RoutePart.add(floattostrpoint(ZPosition+k*cMaxLenImprove)+', .limit '+inttostr(Track.speedlimit) + ';0;0');
          end;

          // Track-Eigenschaften: Hintergrund
          if (PrevTrack=nil) or (PrevTrack.Background<>Track.Background) then
          begin
            RoutePart.add(floattostrpoint(ZPosition)+', .back '+inttostr(GetBackgroundindex(Track.Background)));
          end;

          // Track-Eigenschaften: Grund
          if (PrevTrack=nil) or (PrevTrack.Ground<>Track.Ground) then
          begin
            RoutePart.add(floattostrpoint(ZPosition)+', .ground '+inttostr(GetGroundIndex( Track.Ground )));
          end;

          // Track-Eigenschaft: Wave
          if (Track.Wavefilename<>'') then
          begin
            RoutePart.add(floattostrpoint(ZPosition+k*cMaxLenImprove)+', .announce ..\object\'+subdir+'\sounds\'+Track.Wavefilename);
            AddObjectToFilelist('sounds',Track.Wavefilename);
          end;

          //STATIONSEXPORT
          for j1:=0 to GetfromProject.GetStationCount()-1 do
          begin
            if GetFromProject.GetStationByIndex(j1).TrackIDIsInStation(Track.ID) then
            begin
              // Fahrzeit berechnen
              CurrentTime := IncSecond(CurrentTime, int64(round(sec)) );
              sec := 90; // Standardaufschlag wegen Anfahren und Bremsen (TODO: dies sinnvoll berechnen)
              ArrivalTimeStr := floattostrPoint( HourOf(CurrentTime) + MinuteOf(CurrentTime)/100 );
              CurrentTime := IncMinute(CurrentTime); // TODO Haltezeit ist erstmal fest eine Minute, muss dem Fahrplan entnommen werden
              DepartTimeStr := floattostrPoint( HourOf(CurrentTime) + MinuteOf(CurrentTime)/100 );
              // bis ans Ende des Segments fahren
              RoutePart.Add(floattostrpoint(ZPosition)+', .Sta '
                 +GetFromProject.GetStationByIndex(j1).stationname
                 +';'+ArrivalTimeStr+';'+DepartTimeStr
                 +';1;-1;0;ATS;0;30;100');//TODO: Angaben konfigurierbar machen
              // .stop vorverlegen, damit man auch vor dem Strich halten kann 
              RoutePart.Add(floattostrpoint(ZPosition+15)+', .stop 0');
              // Stopschild
              if FreeObjID_Stopsign<>-1 then
                RoutePart.add(CmdFreeObj(ZPosition+15,0,FreeObjID_Stopsign,cStopsignXOffset,0,0))
              else
                RoutePart.add(CmdStop(ZPosition+15,1));
            end;
          end;

          // diesen Track in die Liste der exportierten aufnehmen (damit er nicht versehentlich nochmal exportiert wird, als Parallelgleis oder so)
          ExportedTracks.add(Track);
          PrevTrack := Track;
        end; // segments

        // es folgt das eigentliche Gleis
        if (curve=0)or((curve>FormOptions.MaxCurveSmooth)and FSmooth ) then
        begin
          RoutePart.Add(CmdRailType(ZPosition,0,GetTrackTypeIndex(track.texture,0),Track.height));
        end
        else
        begin
          RoutePart.Add(CmdRailType(ZPosition,0,GetTrackTypeIndex(track.texture,curve),Track.height));
        end;
        TrackPropertiesCmd(Track,ZPosition,0,direction,RoutePart,prevpolestype);

        //Track.z_temp := ZPosition;

        // **************FreeObjects*******************
        for ii:=0 to GetFromProject.Freeobjects.Count-1 do
        begin
          // noch nicht exportiert?
          if ExportedFreeObjects.IndexOf(GetFromProject.Freeobjects[ii])<0 then
          begin
            o := GetFromProject.Freeobjects[ii] as TRBObject;
//            sectrack := Segments.GetConnection(0);
            if IsPointInSegment(Pos1.point,Pos2.point,o.point,cSearchWidth,ao,bo) then
            begin
              ObZOffset := ao*Distance(Pos1.point,Pos2.point);
              ObXOffset := bo*cSearchWidth;
              if (ZPosition+ObZOffset>0) then
              begin
                // supress trains on this track
                if (o.Folder<>'trains')or(abs(ObXOffset)>cTrainSupressXOffset) then
                begin
                  // Winkel berechnen
                  oalpha := (angle(Pos1.point,Pos2.point)-90)
                          - o.angle;
                  {oalpha := Track.GetAngle(nil);
                  if direction=1 then
                    oalpha := oalpha - o.angle -90
                  else
                    oalpha := 180+oalpha - o.angle -90;  }
                  ;
                  RoutePart.Add(CmdFreeObj(zPosition+ObZOffset,
                                      0,GetFreeobjIndex(o.Folder,o.Objectfilename),
                                      ObXOffset,o.yoffset-track.height,oalpha));
                  ExportedFreeObjects.Add(o);
                end;
              end;
            end;

          end;
        end;

        // weiter geht es bei...
        ZPosition := ZPosition + 25;//plen;

        // selbsterklärend
        PrevTrack := Track;
      end;
//      inc(i,5*Direction);
      i := j;//+Direction;

      // bis nicht mehr fünf () Tracks gefunden wurden, dann ist Schluss
    until Segments.count < (25 div cMaxLenImprove);

    if assigned(DrawConnections) then DrawConnections(FPrimaryConnections);

    //----------------------------Sekundärgleise-----------------------------
    currentSecTrackNumber := 1;
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
    until found_unexported=false;    


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
  Segments.free;
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
    prevpolestype,curve,
    oldsectracknumber: integer;
    P,P1: TRBPoint;
    PriTrack,Track,PrevTrack: TRBConnection;
    to_be_exported: boolean;
    a,b,last_z,last_sec_z: double;
    PIntersect: TDoublePoint;
    last_conn, first_conn: boolean;

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
    RoutePart.Add(CmdSecondaryRailSegmentEnd(last_z,b,oldsectracknumber,Track.YPosition));
  end;
end;

begin
  // wurde dieser starttrack nicht schon exportiert?
  if exportedTracks.IndexOf(starttrack)>=0 then exit;

  SecondaryTracks := TRBConnectionlist.create;
  SecondaryTracks.OwnsObjects := false;
  connlist := TRBConnectionlist.create;
  connlist.OwnsObjects := false;
  // suche in die eine Richtung
  P := starttrack.P2;
  track := starttrack;
  prevpolestype := 999;
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
      // Schnittpunkt zwischen Senkrechter und SecondaryTrack suchen
      Track := nil;
      for j:=0 to SecondaryTracks.count-1 do
      begin
        PrevTrack := Track;
        Track := SecondaryTracks.GetConnection(j);
        directionSec := sgn(PriTrack.SkalarProduct(Track));
        // Weichenerkennung
        {if ((Track.P1=PriTrack.P1)
        or (Track.P1=PriTrack.P2)
        or (Track.P2=PriTrack.P1)
        or (Track.P2=PriTrack.P2))
//        and(last_conn or first_conn)
        then
        begin
          last_z := PriTrack.z_temp;
          if first_conn then
          begin
            RoutePart.Add( CmdSecondaryRailSegmentStart(last_z,0,currentSecTrackNumber,Track.YPosition,GetTrackTypeIndex(track.texture,0),track.id) );
//            prevpolestype := abs(Track.poles);
            TrackPropertiesCmd(Track,last_z,currentSecTrackNumber,directionSec,RoutePart,prevpolestype);
          end
          else
            RoutePart.Add( CmdSecondaryRailSegmentEnd(last_z,0,currentSecTrackNumber,Track.YPosition) );
          break;
        end
        else   }
       // if direction>0 then
        begin
          // eine Seite
          if Intersection( PriTrack.P1.point,  PriTrack.GetPerpendicular1(cSearchwidth),
            Track.P1.point,Track.P2.point, PIntersect ) then
          begin
            b := -direction*Distance( PriTrack.P1.point, PIntersect );
            if abs(b)<csearchWidth then
            begin
              // Gleis erzeugen
              last_z := PriTrack.z_temp;
              CheckSecTrackNumber();
              if (round(last_z) mod 25=0)and(FindInStringlist(RoutePart,CmdSecondaryRailSegmentCmdOnly(last_z,currentSecTrackNumber) )<0)
              and((last_z>0)or(b<>0)) then
              begin
                if FSmooth then ParallelTrack(b);
                // falls diese Tracknumber unzulässig ist, nächste nehmen
                Track.b_temp := b;
//                curve := Track.GetCurve(PrevTrack);
                curve := 0;
                if (curve=0)or((curve>FormOptions.MaxCurveSmooth)and FSmooth ) then
                begin
                  RoutePart.Add( CmdSecondaryRailSegmentStart(last_z,b,currentSecTrackNumber,Track.YPosition-PriTrack.Height,GetTrackTypeIndex(track.texture,0),track.id,first_conn) );
                end
                else
                begin
                  RoutePart.Add( CmdSecondaryRailSegmentStart(last_z,b,currentSecTrackNumber,Track.YPosition-PriTrack.Height,GetTrackTypeIndex(track.texture,curve),track.id,first_conn) );
                end;
                if first_conn then
                  TrackPropertiesCmd(Track,last_z,currentSecTrackNumber,directionSec*direction,RoutePart,prevpolestype)
                else
                begin
                  while(last_sec_z+25<=last_z) do
                  begin
                    TrackPropertiesCmd(Track,last_sec_z+25,currentSecTrackNumber,directionSec*direction,RoutePart,prevpolestype);
                    last_sec_z := last_sec_z + 25;
                  end;
                end;
                last_sec_z := last_z;
                first_conn := false;
              end;
              break;
            end;
          end
          else
          // andere Seite
          if Intersection( PriTrack.P1.point,  PriTrack.GetPerpendicular1(-cSearchwidth),
            Track.P1.point,Track.P2.point, PIntersect ) then
          begin
            b := direction*Distance( PriTrack.P1.point, PIntersect );
            if abs(b)<csearchWidth then
            begin
              // Gleis erzeugen
              last_z := PriTrack.z_temp;
              CheckSecTrackNumber();
              if (round(last_z) mod 25=0)and(FindInStringlist(RoutePart,CmdSecondaryRailSegmentCmdOnly(last_z,currentSecTrackNumber) )<0)
              and((last_z>0)or(b<>0)) then
              begin
                if FSmooth then ParallelTrack(b);
                Track.b_temp := b;
//                curve := Track.GetCurve(PrevTrack);
                curve := 0;
                if (curve=0)or((curve>FormOptions.MaxCurveSmooth)and FSmooth ) then
                begin
                  RoutePart.Add( CmdSecondaryRailSegmentStart(last_z,b,currentSecTrackNumber,Track.YPosition-PriTrack.Height,GetTrackTypeIndex(track.texture,0),track.id,first_conn) );
                end
                else
                begin
                  RoutePart.Add( CmdSecondaryRailSegmentStart(last_z,b,currentSecTrackNumber,Track.YPosition-PriTrack.Height,GetTrackTypeIndex(track.texture,curve),track.id,first_conn) );
                end;
//                RoutePart.Add( CmdSecondaryRailSegmentStart(last_z,b,currentSecTrackNumber,Track.YPosition,GetTrackTypeIndex(track.texture,0),track.id,first_conn) );
                if first_conn then
                  TrackPropertiesCmd(Track,last_z,currentSecTrackNumber,directionSec*direction,RoutePart,prevpolestype)
                else
                begin
                  while(last_sec_z+25 <= last_z) do
                  begin
                    TrackPropertiesCmd(Track,last_sec_z+25,currentSecTrackNumber,directionSec*direction,RoutePart,prevpolestype);
                    last_sec_z := last_sec_z + 25;
                  end;
                end;
                last_sec_z := last_z;
//                TrackPropertiesCmd(Track,last_z,currentSecTrackNumber,directionSec*direction,RoutePart,prevpolestype);
                first_conn := false;
              end;
              break;
            end;
          end;
        end;
        PrevTrack := Track;
      end;
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
    if last_z>0 then
    begin
      if directionsec=1 then
      begin
        SecSwitchCorrection(RoutePart,((round(last_z) div 25) * 25)+25,b);
        RoutePart.Add( CmdSecondaryRailSegmentEnd(((round(last_z) div 25) * 25)+25,b,currentSecTrackNumber,Track.YPosition) );
      end
      else
      begin
        SecSwitchCorrection(RoutePart,((round(last_z) div 25) * 25)+25,b);
        RoutePart.Add( CmdSecondaryRailSegmentEnd(((round(last_z) div 25) * 25)+25,b,currentSecTrackNumber,Track.YPosition) );
      end;

      inc(currentSecTrackNumber);
      if currentSecTrackNumber>cMaxSecTrackNumber then  currentSecTrackNumber := 1; // TODO
      if assigned(DrawConnections) then DrawConnections(SecondaryTracks);
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
  if (abs(dist)>=cParalleltrackdist-cParalleltrackdev)
  and(abs(dist)<=cParalleltrackdist+cParalleltrackdev) then
  begin
    dist := sgn(dist)*cParalleltrackdist;
  end;
end;

procedure TRBExport_Mod.ExportToCsv(Train, asubdir: String; RouteId:Integer);
var
 sl,trainsection: TStringList;
 i,j,direction: integer;
begin
  Statuslines.Add('Preparing');
  Application.ProcessMessages;

  badSecTrackNumbers := 0;
  FreeObjID_Stopsign := -1;
  subdir := asubdir;
  Filelist.clear();

  ExportFile.Clear();
  Credits.clear();
  
  // ermittle zu exportierende RouteDefinition
  RD := GetFromProject.Routes[RouteID] as TRBRoutedefinition;

  if RD.Count=0 then
  begin
    MessageDlg('This Route Definition does not contain any connections. '
       +'You can add them using the ''add to current connection'' command.', mtError, [mbCancel], 0);
    exit;
  end;

  // Export-Preprocessing
  if not GetFromProject.ExportPreprocess then
  begin
    MessageDlg('Error while preparing route.', mtError, [mbCancel], 0);
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
  ImproveConnections();

  // ordne die Einzelstücke in der aktuellen Route richtig herum (P1 der nächsten = P2 der vorigen)
  Statuslines.Add('Getting route');
  Application.ProcessMessages;

  // Suche Startpunkt und Richtung
  FindStations(direction);

  // setze strecke richtig zusammen
  SetRouteConnectionsOrientations(FPrimaryConnections,startindex,direction);

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
  ExportRailwaySection(Exportfile, RouteId, direction);

  if badSecTrackNumbers>0 then
     Statuslines.Add('secondary track overruns: ' + inttostr(badSecTrackNumbers));

  FormExport.ExportStatusProgress.Position:=96;    //Progress für Gauge im Exportformular

  ExportObjectSectionPass2(Header);

  // Header einfügen
  ReplacePlaceholder(Exportfile,objectdef_placeholder,Header);

  // erzeuge Train-Bereich // TODO: die richtigen Sounds zuordnen, daher erst hinterher!
  FormExport.ExportStatusProgress.Position:=98;      //Progress für Gauge im Exportformular
  trainsection := TStringlist.create;
  ExportTrainSection(Trainsection, Train);

  // Trainsection einfügen
  ReplacePlaceholder(Exportfile,traindef_placeholder,Trainsection);
  trainsection.free;

  FormExport.ExportStatusProgress.Position:=100;    //Progress für Gauge im Exportformular

  Statuslines.Add('FreeObj Count='+inttostr(FObjCount));

  Statuslines.Add('Completed.');


end;

// Funktion: TrackPropertiesCmd
// Autor   : up
// Datum   : 7.1.03
// Beschr. : erzeugt alle Track-Eigenschaften-Kommandos
procedure TRBExport_Mod.TrackPropertiesCmd(Track: TRBConnection; zposition: double; trackno,direction: integer; RoutePart: TStrings; var prevpolestype: integer);
var PolesType: integer;
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
  if Track.WallIDLeft>0 then
  begin
    // wallend löschen?
    if direction=1 then
    begin
      if RoutePart.indexof(CmdDikeEnd(ZPosition,trackno))>=0 then
        RoutePart.Delete(RoutePart.indexof(CmdDikeEnd(ZPosition,trackno)));
      RoutePart.Add(CmdDike(ZPosition,trackno,-1,Track.WallIDLeft));
      RoutePart.Add(CmdDikeEnd(ZPosition+25,trackno));
    end
    else
    begin
      if RoutePart.indexof(CmdWallEnd(ZPosition,trackno))>=0 then
        RoutePart.Delete(RoutePart.indexof(CmdWallEnd(ZPosition,trackno)));
      RoutePart.Add(CmdWall(ZPosition,trackno,1,Track.WallIDLeft));
      RoutePart.Add(CmdWallEnd(ZPosition+25,trackno));
    end
  end;
  if Track.WallIDRight>0 then
  begin
    if direction=1 then
    begin
      if RoutePart.indexof(CmdWallEnd(ZPosition,trackno))>=0 then
        RoutePart.Delete(RoutePart.indexof(CmdWallEnd(ZPosition,trackno)));
      RoutePart.Add(CmdWall(ZPosition,trackno,1,Track.WallIDRight));
      RoutePart.Add(CmdWallEnd(ZPosition+25,trackno));
    end
    else
    begin
      if RoutePart.indexof(CmdDikeEnd(ZPosition,trackno))>=0 then
        RoutePart.Delete(RoutePart.indexof(CmdDikeEnd(ZPosition,trackno)));
      RoutePart.Add(CmdDike(ZPosition,trackno,-1,Track.WallIDRight));
      RoutePart.Add(CmdDikeEnd(ZPosition+25,trackno));
    end;
  end;

  // Bahnsteig und Masten auf der gleichen Seite?
  if ((Track.PlatformPos=1)and(Track.Poles=1))or((Track.PlatformPos=2)and(Track.Poles=-1)) then
    PolesType:=2*sgn(Track.Poles) // langer Ausleger
  else
    PolesType:=track.poles; // kurzer Ausleger}

  // Oberleitung
  if (PrevPolesType<>PolesType)  then
  begin
    begin
      if direction=-1 then PolesType := -PolesType;
      // wenn rechts keine Schienen liegen, Masten rechts
      //if not TrackRightpresent then PoleSide := -1
      // wenn rechts keine Schienen liegen, Masten links
      //else if not TrackLeftpresent then PoleSide := 1
      //else
      // links und rechts liegen Schienen, TODO: Turmmast aufstellen
//            PoleSide := -1;
      if Track.Poles=0 then
        RoutePart.Add(CmdPoleEnd(ZPosition,trackno))
      else
        RoutePart.Add(CmdPoles(ZPosition,trackno,0,-sgn(PolesType),25,abs(Polestype)))
    end;
  end;
  PrevPolesType := PolesType;
end;

function TRBExport_Mod.CmdRailType(distance: double; tracknumber,texture: integer; height: double): string;
begin
  result := floattostrpoint(distance) + ', .railtype ' + inttostr(tracknumber) + ';' + inttostr(texture) + ' , .height ' + floattostrpoint(height);
end;

function TRBExport_Mod.CmdForm(distance: double; tracknumber,PlatformPos,roof,platformtype: integer): string;
begin
  result := floattostrpoint(distance)+ ', .form ' + inttostr(tracknumber) + ';'
          + PlatformPosChar(PlatformPos) + ';' + inttostr( GetRoofIndex( roof ) )
          +';'+inttostr( GetPlatformIndex( Platformtype ));
end;

function TRBExport_Mod.CmdPoles(distance: double; tracknumber,trackcount,side,interval,poletype: integer): string;
begin
  result := floattostrpoint(distance)+ ', .pole '+inttostr(tracknumber)
   +';'+inttostr(trackcount)+';'+inttostr(side)+';'+inttostr(interval)
   +';'+inttostr(GetPoleIndex( poletype) );
end;

function TRBExport_Mod.CmdPoleEnd(distance: double; tracknumber: integer): string;
begin
  result := floattostrpoint(distance)+ ', .poleend '+inttostr(tracknumber);
end;

// side= -1 für links, +1 für rechts
function TRBExport_Mod.CmdWall(distance: double; tracknumber,side,wallid: integer): string;
begin
  result := floattostrpoint(distance)+ ', .wall '+inttostr(Tracknumber)+';'
           +inttostr(side)+';'+inttostr( GetWallIndex( wallid ) );
end;

function TRBExport_Mod.CmdWallEnd(distance: double; tracknumber: integer): string;
begin
  result := floattostrpoint(distance)+ ', .wallend '+inttostr(Tracknumber);
end;

// side= -1 für links, +1 für rechts
function TRBExport_Mod.CmdDike(distance: double; tracknumber,side,wallid: integer): string;
begin
  result := floattostrpoint(distance)+ ', .dike '+inttostr(Tracknumber)+';'
           +inttostr(side)+';'+inttostr(GetWallIndex(wallid));
end;

function TRBExport_Mod.CmdDikeEnd(distance: double; tracknumber: integer): string;
begin
  result := floattostrpoint(distance)+ ', .dikeend '+inttostr(Tracknumber);
end;

function TRBExport_Mod.CmdCrack(distance: double; tracknumber1,tracknumber2,texture: integer): string;
begin
  result := floattostrpoint(distance)+', .crack ' + inttostr(tracknumber1) + ';' + inttostr(tracknumber2)+';'+inttostr(texture);
end;

function TRBExport_Mod.CmdCurve(distance,curve,railheight: double): string;
begin
  result := floattostrpoint(distance)+', .curve '+floattostrpoint(curve)+';'+floattostrpoint(railheight);
end;

function TRBExport_Mod.CmdFreeObj(distance: double; tracknumber,objid: integer; xoffset,height,angle: double): string;
begin
  result := floattostrPoint(distance)+', .freeobj ' + inttostr(tracknumber) + ';'
     + inttostr(objid)+';'+floattostrPoint(xoffset) + ';'+ floattostrPoint(height) + ';' + floattostrpoint(angle);
  inc(FObjCount);
end;

function TRBExport_Mod.CmdStop(distance: double; side: integer): string;
begin
  result := floattostrPoint(distance)+', .stop ' + inttostr(side);
end;

function TRBExport_Mod.CmdSecondaryRailSegmentStart(startdistance,startx: double; trackno: integer; height: double; texture,id: integer; switch_possible: boolean): string;
var _startx: double;
    i: integer;
begin
  if (abs(startx)<cSwitchdev)and switch_possible  then _startx := 0 else _startx := startx;
  result := floattostrpoint(startdistance)+', .rail '+inttostr(trackno)+';'+floattostrPoint(_startx) +';'+floattostr(height)+';'+inttostr(texture) + '    ;id=' + inttostr(id);
end;

function TRBExport_Mod.CmdSecondaryRailSegmentCmdOnly(startdistance: double; trackno: integer): string;
begin
  result := floattostrpoint(startdistance)+', .rail '+inttostr(trackno)+';';
end;

function TRBExport_Mod.CmdSecondaryRailSegmentEnd(enddistance,endx: double; trackno: integer; height: double): string;
var _endx: double;
begin
  if (abs(endx)<cSwitchdev) then _endx := 0 else _endx := endx;
  result := floattostrpoint(enddistance)+', .railend '+inttostr(trackno)+';'+floattostrPoint(_endx)
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
    if p1=nil then begin p1 := TRBPoint.create(c.P1.point); FPoints.add(p1); end;
    if p2=nil then begin p2 := TRBPoint.create(c.P2.point); FPoints.add(p2); end;
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
  repeat
    foundunimproved := false;
    for i:=0 to FConnections.count-1 do
    begin
      if (FConnections.GetConnection(i).id<>0) // bereits verbesserte haben id=0
      and(FConnections.GetConnection(i).GetLength() > cmaxlenimprove) then
      begin
        foundunimproved := true;
        ImproveConnection(FConnections.GetConnection(i));
        break; // da die Liste geändert wurde müssen wir wieder ganz von vorn beginnen
      end;
    end;
    inc(j);
    FormExport.ExportStatusProgress.Position:=30+(15*j) div FConnections.count;
  until foundunimproved=false;
end;

// eine Connection bezier-verbessern, so dass die Einzelconnections kürzer oder gleich cmaxlenimprove sind
procedure TRBExport_Mod.ImproveConnection(connstart: TRBConnection);
var point,Startpoint,Endpoint,Helppoint1,helppoint2: TRBPoint;
    P: TDoublePoint;
    a,anz: integer;
    i,id: integer;
    wave: string;
    l,{partlen,}mina: double;
    conn,conn2: TRBConnection;
    connlist: TRBConnectionlist;
    helppointsExist: boolean;
    primary: boolean;
    improvedpoints: TObjectlist;
begin
  connlist := TRBConnectionlist.Create;
  connlist.OwnsObjects := false;
  improvedpoints:= TObjectlist.Create;
  improvedpoints.OwnsObjects := false;
  // gehört dies zum Hauptgleis? (d.h. in der zu exportierenden RouteDefinition?)
  primary := RD.ContainsTrack(connstart.ID);
  id := 0;
  wave := connstart.Wavefilename;
  // ist an dieser Connection ein Bahnhof? Dann die ID merken und später im neuen Track setzen
  for i:=0 to GetfromProject.GetStationCount()-1 do
  begin
    if GetFromProject.GetStationByIndex(i).TrackIDIsInStation(connstart.ID) then
    begin
      // ID merken
      id := connstart.id;
    end
  end;

  // Länge jedes der neuen Abschnitte
  l := connstart.GetLength();
  anz := ceil(l/cMaxLenImprove)+1; // aufrunden

  FConnections.ImproveConnection(connstart,anz,improvedpoints);

  startpoint := connstart.P1;
  endpoint   := connstart.P2;
  //startpoint.hard := true;

  for i:=0 to improvedpoints.Count-1 do
  begin
      // neue Connection
    Conn := TRBConnection.Create(startpoint,improvedpoints[i] as TRBPoint);
    Conn.CopyProperties(connstart);                  //erhält keine ID!
    startpoint := improvedpoints[i] as TRBPoint;
    FPoints.Add(startPoint);
    if i=improvedpoints.Count-1 then
      Conn.id := id // ID nur <>0 an einem Bahnhof, damit die später wieder erkannt werden
    else
      Conn.id := 0;
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
  conn.id := 0;
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

// dreht und verschiebt Connections, so dass eine Art verkettete, lineare Liste entsteht
procedure TRBExport_Mod.SetRouteConnectionsOrientations(var connlist: TRBConnectionlist; _startindex: integer; var direction: integer);
var i,n,sdirection,end_countdown: integer;
    tmplist,tmpprimlist: TRBconnectionlist;
    P: TRBPoint;
    track: TRBConnection;
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
  sdirection := 1;
  repeat
    tmpprimlist.Clear();
    track := connlist.GetConnection(_startindex);
    tmpprimlist.AddConnection(Track);
    i := 0;
    repeat
      if sdirection>0 then
      begin
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
      end
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
      end;
    until (track=nil)or(end_countdown=-1);
    if end_countdown<>0 then break;
    if sdirection=1 then
      sdirection := -1
    else
      break;
  until track=nil;
  tmplist.free;
  direction := sdirection;
  // neue, sortierte Liste übernehmen
  connlist.free;
  connlist := tmpprimlist;

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
