unit uRBObject;

interface

uses sysutils, classes, uGlobaldef, uTools, uRBObjCache;

type

  TRBObject = class (TStringlist)
                   protected
                    FFolder: string;
                    FMaxCube: TDoubleCube;
                   public
                    point: TDoublePoint;
                    angle: integer;
                    yoffset: double;
                    boundtoConnID: integer;
                    locked: boolean;
                    FObjectfilename,
                    FileExtension: string;
                    constructor Create(const folder,objectfilename: string); overload;
                    constructor Create(const src: TRBObject); overload;
                    constructor Create(const folderandobjectfilename: string); overload;
                    constructor CreateFromString(const s: string);
                    function NightVersionAvailable: boolean;
                    function NightVersionObjectFilename(): string;
                    function GetAuthorName: string;
                    procedure AddAuthors(sl: TStringlist);
                    function GetDescription: string;
                    function GetCopyright: string;
                    function GetDefaultID(): string;
                    function GetType(): string;
                    procedure GetBitmaplist(bitmaps: TStringlist);
                    procedure CalcMaxCube();
                    function GetPath(): string;
                    function GetPathNightVersion(): string;
                    procedure Reload(force: boolean=true);
                    function GetAsString(): string;
                    property Folder: string read FFolder write FFolder;
                    property MaxCube: TDoubleCube read FMaxCube;
                    procedure MaxCubeRotated(var p1,p2,p3,p4: TDoublePoint; differentlength: integer=0);
                    property Objectfilename: string read FObjectfilename write FObjectfilename;
                    procedure Move(xoff,yoff,vert: double);
                    procedure Scale(f: double);
                    procedure SaveAsCSV();
                  end;

var
  ObjectBasePath: string;

implementation

constructor TRBObject.Create(const folder,objectfilename: string);
var s: string;
begin
  inherited create;
  angle := 0;
  yoffset := 0;
  locked := false;
  FFolder := folder;
  boundtoConnID := 0;
  FObjectfilename := Objectfilename;
  Reload(false);
end;

constructor TRBObject.Create(const folderandobjectfilename: string);
var s: string;
begin
  inherited create;
  angle := 0;
  yoffset := 0;
  locked := false;
  FObjectfilename:='';
  s := ObjectBasePath + folderandobjectfilename;
  FFolder := strgettoken(folderandobjectfilename,'\',1);
  FObjectfilename := strgettoken(folderandobjectfilename,'\',2);
  ReLoad(false);
end;

constructor TRBObject.Create(const src: TRBObject);
begin
  Create(src.Folder,src.Objectfilename);
  angle := src.angle;
  yoffset := src.yoffset;
  CalcMaxCube();
end;

// Funktion: CreateFromString
// Autor   : up
// Datum   : 5.12.02
// Beschr. : erzeugt aus Kommastring ein Objekt. Format: folder,object.b3d,x,y,a,h,locked
constructor TRBObject.CreateFromString(const s: string);
var f,o: string;
    x,y,a,h: double;
begin
  f := StripQuotes(StrGetToken(s,',',1));
  o := StripQuotes(StrGetToken(s,',',2));
  x := strtofloat1(StrGetToken(s,',',3));
  y := strtofloat1(StrGetToken(s,',',4));
  a := strtofloat1(StrGetToken(s,',',5));
  h := strtofloat1(StrGetToken(s,',',6));
  if (f='')and(o='') then
  begin
    f := 'misc';
    o := 'kuh1.b3d';
  end;
  create(f,o);
  locked := boolean(strtointdef(StrGetToken(s,',',7),0));
  boundtoConnID := strtointdef(StrGetToken(s,',',8),0);
  point := doublepoint(x,y);
  angle := round(a);
  yoffset := h;
end;


procedure  TRBObject.Reload(force: boolean);
var s: string;
    j: integer;
begin
  s :=  Ffolder+'\'+Fobjectfilename;
  FileExtension := lowercase( ExtractFileExt(  FObjectfilename ) );
  // cache?
  j := RBObjCache.IndexOf(s);
  if (j>=0) and not force and cUseCache then
  begin
    clear;
    AddStrings( RBObjCache.objects[j] as TStringlist );
  end
  else
  begin
    if not fileexists(ObjectBasePath +s) then
    begin
      exit;
    end;
    loadfromfile(ObjectBasePath +s);
    if force then
    begin
      if (RBObjCache.IndexOf(s)>0) then RBObjCache.Delete(RBObjCache.IndexOf(s));
    end;
    if cUseCache and (j<0) then RBObjCache.AddObject(s,self);
  end;
  CalcMaxCube();
end;

function TRBObject.GetAsString: string;
begin
  result := '"'+FFolder+'","'+FObjectfilename+'",'
     +floattostrpoint(point.x)+','+floattostrPoint(point.y)+','
     +floattostrpoint(angle)+','+floattostrpoint(yoffset)+','
     +inttostr(integer(locked))+','+inttostr(boundtoConnID);
end;

function TRBObject.GetAuthorName: string;
begin
  result := values[';author'];
end;
function TRBObject.GetDescription: string;
begin
  result := values[';description'];
end;
function TRBObject.GetCopyright: string;
begin
  result := values[';copyright'];
end;
function TRBObject.GetDefaultID: string;
begin
  result := values[';id'];
end;
function TRBObject.GetType: string;
begin
  result := values[';type'];
end;

procedure TRBObject.GetBitmaplist(bitmaps: TStringlist);
var i: integer;
begin
  bitmaps.clear;
  bitmaps.Sorted := true;
  bitmaps.Duplicates := dupIgnore;
  for i:=0 to count-1 do
  begin
    if FileExtension='.b3d' then
    begin
      if lowercase(copy(strings[i],1,4))='load' then
      begin
        bitmaps.add(StrGetToken(strings[i],' ',2));
      end;
    end
    else if FileExtension='.csv' then
    begin
      if lowercase(copy(strings[i],1,11))='loadtexture' then
      begin
        bitmaps.add(StrGetToken(strings[i],',',2));
      end;
    end;
  end;
end;

// TODO: translate etc. einbauen
procedure TRBObject.CalcMaxCube();
var i,p: integer;
    x,y,z: double;
    ks: string;
    coord: array[0..2] of double;
begin
  FMaxCube.x1 := -999;
  FMaxCube.y1 := -999;
  FMaxCube.z1 := -999;
  FMaxCube.x2 := 999;
  FMaxCube.y2 := 999;
  FMaxCube.z2 := 999;
  for i:=0 to count-1 do
  begin
    if FileExtension='.b3d' then
    begin
      if StrLIComp('vertex',pchar(strings[i]),6)=0 then
      with FMaxCube do
      begin
        ParseCommaSeparated(strings[i],7,3,coord);
        if coord[0]<x2 then x2 := coord[0];
        if coord[0]>x1 then x1 := coord[0];
        if coord[1]<y2 then y2 := coord[1];
        if coord[1]>y1 then y1 := coord[1];
        if coord[2]<z2 then z2 := coord[2];
        if coord[2]>z1 then z1 := coord[2];
      end;
    end
    else if FileExtension='.csv' then
    begin
      if StrLIComp('addvertex',pchar(strings[i]),9)=0 then
      with FMaxCube do
      begin
        p := pos(',',strings[i])+1;
        ParseCommaSeparated(strings[i],p,3,coord);
        if coord[0]<x2 then x2 := coord[0];
        if coord[0]>x1 then x1 := coord[0];
        if coord[1]<y2 then y2 := coord[1];
        if coord[1]>y1 then y1 := coord[1];
        if coord[2]<z2 then z2 := coord[2];
        if coord[2]>z1 then z1 := coord[2];
      end;
    end;
  end;
  with FMaxCube do
  begin
    if abs(FMaxCube.x1-FMaxCube.x2)<1 then
     FMaxCube.x2 := FMaxCube.x1-1;
    if abs(FMaxCube.z1-FMaxCube.z2)<1 then
     FMaxCube.z2 := FMaxCube.z1-1;
  end;

end;



function TRBObject.GetPath: string;
begin
  result := FFolder+'\'+FObjectfilename;
end;

function TRBObject.GetPathNightVersion: string;
begin
  if NightVersionAvailable then
    result := FFolder+'\'+NightVersionObjectFilename
  else
    result := GetPath;
end;


procedure TRBObject.MaxCubeRotated(var p1,p2,p3,p4: TDoublePoint; differentlength: integer);
var matrix: array[1..2,1..2] of double;
begin
  if differentlength<>0 then
  begin
    FMaxCube.z1 := 0;
    FMaxCube.z2 := differentLength;
  end;
  matrix[1,1] := cos(pi*(angle)/180);
  matrix[2,2] := matrix[1,1];
  matrix[2,1] := sin(pi*(angle)/180);
  matrix[1,2] := -matrix[2,1];
  p1.x := FMaxCube.x1*matrix[1,1]+FMaxCube.z1*matrix[1,2];
  p2.x := FMaxCube.x2*matrix[1,1]+FMaxCube.z1*matrix[1,2];
  p3.x := FMaxCube.x2*matrix[1,1]+FMaxCube.z2*matrix[1,2];
  p4.x := FMaxCube.x1*matrix[1,1]+FMaxCube.z2*matrix[1,2];
  p1.y := FMaxCube.x1*matrix[2,1]+FMaxCube.z1*matrix[2,2];
  p2.y := FMaxCube.x2*matrix[2,1]+FMaxCube.z1*matrix[2,2];
  p3.y := FMaxCube.x2*matrix[2,1]+FMaxCube.z2*matrix[2,2];
  p4.y := FMaxCube.x1*matrix[2,1]+FMaxCube.z2*matrix[2,2];
end;

procedure TRBObject.AddAuthors(sl: TStringlist);
var s,a: string;
    i: integer;
begin
  s := GetAuthorName();
  i := 1;
  repeat
    a := StripQuotes(StrGetToken(s,',',i));
    if (a<>'') and (sl.IndexOf(a)<0) then sl.Add(a);
    inc(i);
  until a='';
end;

// Funktion: Move
// Autor   : up
// Datum   : 11.1.03
// Beschr. : verschiebt den Ursprung des Objekts (nicht das Objekt in sich!). 
procedure TRBObject.Move(xoff,yoff,vert: double);
begin
  point.x := point.x + xoff;
  point.y := point.y + yoff;
  yoffset := yoffset + vert;
end;

procedure TRBObject.Scale(f: double);
begin
  point.x := point.x * f;
  point.y := point.y * f;
end;

function TRBObject.NightVersionObjectFilename(): string;
begin
  result :=  StringReplace(lowercase(objectfilename),FileExtension,'_night'+FileExtension,[rfReplaceall]);
end;

function TRBObject.NightVersionAvailable: boolean;
var s: string;
begin
  s := ObjectBasePath + folder+'\'+NightVersionObjectFilename;
  result :=  fileexists(s);
end;

procedure TRBObject.SaveAsCSV;
var sl2: TStringlist;
    i: integer;
    s : string;
begin
  sl2 := TStringlist.create;
  for i:=0 to count-1 do
  begin
    s := StringReplace(strings[i],'[meshbuilder]','createmeshbuilder,',[rfIgnoreCase]);
    s := StringReplace(s,'vertex','addvertex,',[rfIgnoreCase]);
    s := StringReplace(s,'face','addface,',[rfIgnoreCase]);
    s := StringReplace(s,'[texture]','',[rfIgnoreCase]);
    s := StringReplace(s,'load','loadtexture,',[rfIgnoreCase]);
    s := StringReplace(s,'color','setcolor,',[rfIgnoreCase]);
    s := StringReplace(s,'coordinates','SetTextureCoordinates,',[rfIgnoreCase]);
    s := StringReplace(s,'transparent','SetDecalTransparentColor,',[rfIgnoreCase]);
    sl2.add(s);
  end;
  sl2.savetofile( ObjectBasePath + folder+'\'+StringReplace(lowercase(objectfilename),FileExtension,'.csv',[rfReplaceall]) );
  sl2.Free;
end;

end.
