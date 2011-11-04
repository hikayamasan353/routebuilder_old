unit uRBB3DObject;

interface

uses sysutils, classes, uRB3dObject, uTools;

type
     TRBB3DObject = class(TRB3DObject)
     private
       function ParseMeshSection(sl: TStrings): boolean;
       function ParseVertex(const s: string; mesh: TRB3DMesh): boolean;
       function ParseFace(const s: string; mesh: TRB3DMesh; rgb: TRGBColor; bitmap: TRB3DBitmap): boolean;
       function ParseColor(const s: string; var rgb: TRGBColor): boolean;
       function ParseLoadBitmap(const s: string; var Bitmap: TRB3DBitmap): boolean;
       function ParseCoordinates(const s: string; Bitmap: TRB3DBitmap): boolean;
       function ParseTransparency(const s: string; bitmap: TRB3DBitmap): boolean;
     public
       function LoadFromFileAndParse(const filename: string): boolean;
       function Parse(sl: TStrings): boolean; override;
       function CreateSyntax(sl: TStrings): boolean;
       function SaveToFile(const filename: string): boolean;
     end;


procedure CoordB3dToState(var ax,ay,az: double);
procedure CoordStateToB3d(var ax,ay,az: double);
procedure ColorB3dToState(var rgb: TRGBColor);


implementation


procedure CoordB3dToState(var ax,ay,az: double);
var x,y,z: double;
begin
  x := -az;
  y := ax;
  z := ay;
  ax := x;
  ay := y;
  az := z;
end;

procedure CoordStateToB3d(var ax,ay,az: double);
var x,y,z: double;
begin
  x := ay;
  y := az;
  z := -ax;
  ax := x;
  ay := y;
  az := z;
end;

procedure ColorB3dToState(var rgb: TRGBColor);
begin
  rgb.R := round(rgb.R / 2.56);
  rgb.G := round(rgb.G / 2.56);
  rgb.B := round(rgb.B / 2.56);
end;


function TRBB3DObject.ParseVertex(const s: string; mesh: TRB3DMesh): boolean;
var p: integer;
    r,v1,v2,v3: string;
    x,y,z: double;
begin
  p := pos('vertex',lowercase(s)) + length('vertex');
  r := copy(s,p,9999);
  x := strtofloat1(StrGetToken(r,',',1));
  y := strtofloat1(StrGetToken(r,',',2));
  z := strtofloat1(StrGetToken(r,',',3));
  CoordB3dToState(x,y,z);
  mesh.AddPoint(x,y,z,-1);
end;




function TRBB3DObject.ParseFace(const s: string; mesh: TRB3DMesh; rgb: TRGBColor; bitmap: TRB3DBitmap): boolean;
var p,i: integer;
    r,v: string;
    face: TRB3DFace;
    point: TRB3DMeshPoint;
    coord: TRB3DBitmapCoordinate;
    doubleface: boolean;
begin
  // face2?
  doubleface :=  pos('face2',lowercase(s))>0;

  if doubleface then
    p := pos('face2',lowercase(s)) + length('face2')
  else
    p := pos('face',lowercase(s)) + length('face');

  r := copy(s,p,9999);
  face := AddFace;
  face.Color := rgb;
  face.Bitmap := Bitmap;
  face.mesh := Mesh;
  for i:=1 to CountTokens(r,',') do
  begin
    v := StrGetToken(r,',',i);
    point := mesh.GetPoint( strtoint(v) );
    point.index := strtoint(v);
    face.AddPoint( point  );
  end;
  if doubleface then
  begin
    face := AddFace;
    face.Color := rgb;
    face.Bitmap := Bitmap;
    for i:=1 to CountTokens(r,',') do
    begin
      v := StrGetToken(r,',',i);
      point := mesh.GetPoint( strtoint(v) );
      point.index := strtoint(v);
      face.AddPointHead( point );
    end;
  end;
end;

function TRBB3DObject.ParseLoadBitmap(const s: string; var Bitmap: TRB3DBitmap): boolean;
var f: string;
begin
  f := StrGetToken(s,' ',2);
  // Erweiterung abschneiden
  f := copy(f,1,length(f)-length(ExtractFileExt(f)));
  Bitmap := TRB3DBitmap.Create();
  Bitmap.Filename := f;

end;

function TRBB3DObject.ParseCoordinates(const s: string; Bitmap: TRB3DBitmap):boolean;
var p,i: integer;
    r: string;
    v1,v2,v3: string;
    b: double;
begin
  p := pos('coordinates',lowercase(s)) + length('coordinates');
  r := copy(s,p,9999);
  v1 := StrGetToken(r,',',1);
  v2 := StrGetToken(r,',',2);
  v3 := StrGetToken(r,',',3);
  b := 100; // Brightness
  Bitmap.AddCoordinate(strtointdef(v1,0),strtofloat1(v2),strtofloat1(v3),b);
end;

function TRBB3DObject.ParseColor(const s: string; var rgb: TRGBColor): boolean;
var p,i: integer;
    r: string;
    v1,v2,v3,v4: string;
begin
  p := pos('color',lowercase(s)) + length('color');
  r := copy(s,p,9999);
  v1 := StrGetToken(r,',',1);
  v2 := StrGetToken(r,',',2);
  v3 := StrGetToken(r,',',3);
  v4 := StrGetToken(r,',',4);
  rgb.R := strtointdef(v1,0);
  rgb.G := strtointdef(v2,0);
  rgb.B := strtointdef(v3,0);
  if v4<>'' then
     rgb.T := strtointdef(v4,0)
  else
     rgb.T := 0;
  ColorB3dToState(rgb);
end;


function TRBB3DObject.ParseTransparency(const s: string; bitmap: TRB3DBitmap): boolean;
var p,i: integer;
    r: string;
    v1,v2,v3,v4: string;
begin
  p := pos('transparent',lowercase(s)) + length('transparent');
  r := copy(s,p,9999);
  v1 := StrGetToken(r,',',1);
  v2 := StrGetToken(r,',',2);
  v3 := StrGetToken(r,',',3);
  bitmap.TransparentColor.R := strtointdef(v1,0);
  bitmap.TransparentColor.G := strtointdef(v2,0);
  bitmap.TransparentColor.B := strtointdef(v3,0);
  bitmap.TransparentColor.T := 0;
  bitmap.TransparentColor.isset := true;
end;




function TRBB3DObject.ParseMeshSection(sl: TStrings): boolean;
var i: integer;
    Mesh: TRB3DMesh;
    color: TRGBColor;
    Bitmap: TRB3DBitmap;
begin
  color.R := 100;
  color.G := 100;
  color.B := 100;
  color.T := 0;
  Bitmap := nil;
  Mesh := AddMesh();
  // color
  for i:=0 to sl.count-1 do
  begin
    if pos('color',lowercase(sl[i]))>0 then
      ParseColor(sl[i],color); // get color
  end;
  // vertex
  for i:=0 to sl.count-1 do
  begin
    if pos('vertex',lowercase(sl[i]))>0 then
      ParseVertex(sl[i],Mesh);
  end;
  // texture
  for i:=0 to sl.count-1 do
  begin
    if pos('load',lowercase(sl[i]))>0 then
      ParseLoadBitmap(sl[i],Bitmap);
  end;
  if Bitmap<>nil then
  begin
    // texture coord.
    for i:=0 to sl.count-1 do
    begin
      if pos('coordinates',lowercase(sl[i]))>0 then
        ParseCoordinates(sl[i],Bitmap);
    end;
    // transparency
    for i:=0 to sl.count-1 do
    begin
      if pos('transparent',lowercase(sl[i]))>0 then
        ParseTransparency(sl[i],Bitmap);
    end;
  end;
  // face/face2
  for i:=0 to sl.count-1 do
  begin
    if pos('face',lowercase(sl[i]))>0 then
      ParseFace(sl[i],Mesh,color,Bitmap);
  end;

end;




function TRBB3DObject.Parse(sl: TStrings): boolean;
var i,j,k: integer;
    ms: TStringlist;
begin
  // Header
  author := sl.Values[';author'];
  description := sl.Values[';description'];
  copyright := sl.Values[';copyright'];
  hash := sl.Values[';hash'];

  // TODO
  // Prüfen des hash, ob er zum author passt.
  // ansonsten darf das Objekt nicht gespeichert werden 
  SavePermission := CheckHash(sl,hash);

  // erstmal eventuelle Reste beseitigen
  Meshes.Clear;
  Faces.Clear;

  ms := TStringlist.Create;

  j := -1;
  // suche MeshBuilder-Sections
  for i:=0 to sl.count-1 do
  begin
    if pos('[meshbuilder]',lowercase(sl[i]))>0 then
    begin
      if j>=0 then
      begin
        ms.Clear;
        for k:=j to i-1 do
          ms.add(sl[k]);
        ParseMeshSection(ms);
      end;
      j := i;
    end;

  end;
  if j>-1 then
  begin
    ms.Clear;
    for k:=j to i-1 do
          ms.add(sl[k]);
    ParseMeshSection(ms);
  end;

  ms.free;

end;

function TRBB3DObject.LoadFromFileAndParse(const filename: string): boolean;
var sl: TStringlist;
begin
  if not fileexists(filename) then result := false
  else
  begin
    sl := TStringlist.create;
    sl.loadfromfile(filename);
    result := parse(sl);
    sl.free;
  end;
end;

function TRBB3DObject.CreateSyntax(sl: TStrings): boolean;
var i,j,k: integer;
    s: string;
    p: TRB3DMeshPoint;
    f,f2: TRB3DFace;
    c: TRB3DBitmapCoordinate;
    x,y,z: double;
begin
  sl.clear;

  // author and description information
  sl.add(';editor=B3DBuilder');
  sl.add(';author='+author);
  sl.add(';description='+description);
  sl.add(';hash=$HASH$');
  sl.add(';copyright='+copyright);

  // 3d information
  for i:=0 to GetMeshCount-1 do
  begin
    sl.add('[meshbuilder]');
    for j:=0 to GetMesh(i).GetPointCount-1 do
    begin
      p := GetMesh(i).GetPoint(j);
      x:=p.x; y:=p.y; z:=p.z;
      CoordStateToB3d(x,y,z);
      s := 'Vertex ' + floattostrpoint(x) + ',' + floattostrpoint(y) + ',' + floattostrpoint(z);
      sl.add(s);
    end;
    f2:=nil;
    for j:=0 to GetFaceCount-1 do
    begin
      f := GetFace(j);
      if f.Mesh=GetMesh(i) then
      begin
        f2 := f;
        s := 'Face ';
        for k:=0 to f.GetPointCount-1 do
        begin
          p := f.GetPoint(k);
          s := s+ inttostr(p.index);
          if k<>f.GetPointCount-1 then
            s := s+',';
        end;
        sl.add(s);
      end;
    end;
    if f2<>nil then
    begin
      if(f2.Bitmap=nil) then
      begin
        s := 'Color '+inttostr(f2.Color.R)+','+inttostr(f2.Color.G)+','+inttostr(f2.Color.B);
        sl.add(s);
      end
      else
      begin
        sl.add('[texture]');
        sl.add('Load '+f2.Bitmap.Filename+'.bmp');
        for j:=0 to f2.Bitmap.GetCoordinateCount-1 do
        begin
          c := f2.Bitmap.GetCoordinate(j);
          s := 'Coordinates '+inttostr(c.i)+','+floattostrpoint(c.x)+','+floattostrpoint(c.y);
          sl.add(s);
        end;
        if f2.Bitmap.TransparentColor.isset then
        begin
          s := 'Transparent '+inttostr(f2.Bitmap.TransparentColor.R)+','+inttostr(f2.Bitmap.TransparentColor.G)+','
               +inttostr(f2.Bitmap.TransparentColor.B);
          sl.add(s);
        end;

      end;
    end;
  end;
  // TODO
  // calculate Hash
  // replace $HASH$ by Hash
  result := true;
end;


function TRBB3DObject.SaveToFile(const filename: string): boolean;
var sl: TStringlist;
begin
    if not SavePermission then begin result :=false; exit; end;
    sl := TStringlist.create;
    result := CreateSyntax(sl);
    sl.savetofile(filename);
    sl.free;
end;

end.
