unit uRB3DObject;

interface

uses sysutils, classes, contnrs;

type
     TRGBColor = record
       isset: boolean;
       R,G,B,T: integer;
     end;

     TRB3DBitmapCoordinate = class(TObject)
     public
       i:integer;
       x,y,
       brightness: double;
     end;

     TRB3DBitmap = class(TObject)
     private
       coordinates: TObjectlist;
     public
       Filename: string;
       TransparentColor: TRGBColor;
       constructor Create;
       destructor Destroy;
       function GetCoordinateCount(): integer;
       function GetCoordinate(index: integer): TRB3DBitmapCoordinate;
       function AddCoordinate(i: integer; x,y,brightness: double): TRB3DBitmapCoordinate;
     end;

     TRB3DMeshPoint = class(TObject)
     public
       x,y,z: double;
       index: integer;
       constructor CreateFromCoord(_x,_y,_z: double; i: integer);
       procedure PutIntoArray(a: array of double);
       procedure Get(var _x,_y,_z: double);
       function GetIndex: integer;
     end;


     TRB3DMesh = class(TObject)
     private
       MeshPoints: TObjectlist;
     public
       constructor Create;
       destructor Destroy;
       function GetPointCount(): integer;
       function GetPoint(index: integer): TRB3DMeshPoint;
       procedure AddPoint(x,y,z: double; i: integer);
     end;


     TRB3DFace = class(TObject)
     private
       MeshPoints: TObjectlist; // nur Verweise auf MeshPoints
     public
       Color: TRGBColor;
       Bitmap: TRB3DBitmap; // oder nil
       Mesh: TRB3DMesh;
       engine_handle: Cardinal;
       constructor Create;
       destructor Destroy;
       function GetPointCount(): integer;
       function GetPoint(index: integer): TRB3DMeshPoint;
       function AddPoint(const p: TRB3DMeshPoint): boolean;
       function AddPointHead(const p: TRB3DMeshPoint): boolean;
       function GetBitmapCoord(index: integer; var x,y,b: double): boolean;
     end;

     TRB3DObject = class(TObject)
     protected
       Meshes,
       Faces: TObjectList;
       author,description,copyright,hash: string;
       SavePermission: boolean;
     public
       constructor Create;
       destructor Destroy;
       function Parse(sl: TStrings): boolean; virtual; abstract;
       function AddMesh(): TRB3DMesh;
       function GetMeshCount(): integer;
       function GetMesh(index: integer): TRB3DMesh;
       function AddFace(): TRB3DFace;
       function GetFaceCount(): integer;
       function GetFace(index: integer): TRB3DFace;
       function CheckHash(sl: TStrings; const _hash: string): boolean;
     end;

implementation

//------------------ TRB3DBitmap ----------------------------------

constructor TRB3DBitmap.Create;
begin
  coordinates := TObjectlist.Create();
  TransparentColor.isset := false;
end;

destructor TRB3DBitmap.Destroy;
begin
  coordinates.free;
end;

function TRB3DBitmap.GetCoordinateCount(): integer;
begin
  result := coordinates.count;
end;

function TRB3DBitmap.GetCoordinate(index: integer): TRB3DBitmapCoordinate;
begin
  if (index<0)or(index>=coordinates.count) then
    result := nil
  else
    result := coordinates.items[index] as TRB3DBitmapCoordinate;
end;

function TRB3DBitmap.AddCoordinate(i: integer; x,y,brightness: double): TRB3DBitmapCoordinate;
begin
  result := TRB3DBitmapCoordinate.Create();
  result.i := i;
  result.x := x;
  result.y := y;
  result.brightness := brightness;
  coordinates.add(result);
end;

//------------------ TRB3DMeshPoint -------------------------------

constructor TRB3DMeshPoint.CreateFromCoord(_x,_y,_z: double; i: integer);
begin
  Create;
  x := _x;
  y := _y;
  z := _z;
  index := i;
end;

procedure TRB3DMeshPoint.PutIntoArray(a: array of double);
begin
  a[0] := x;
  a[1] := y;
  a[2] := z;
end;

procedure TRB3DMeshPoint.Get(var _x,_y,_z: double);
begin
  _x := x;
  _y := y;
  _z := z;
end;

function TRB3DMeshPoint.GetIndex: integer;
begin
  result := index;
end;

//------------------ TRB3DMesh ------------------------------------

constructor TRB3DMesh.Create;
begin
  MeshPoints := TObjectlist.Create();
end;

destructor TRB3DMesh.Destroy;
begin
  MeshPoints.free;
end;

function TRB3DMesh.GetPointCount(): integer;
begin
  result := MeshPoints.count;
end;

function TRB3DMesh.GetPoint(index: integer): TRB3DMeshPoint;
begin
  if (index<0)or(index>=MeshPoints.count) then
    result := nil
  else
    result := MeshPoints.items[index] as TRB3DMeshPoint;
end;

procedure TRB3DMesh.AddPoint(x,y,z: double; i: integer);
var p: TRB3DMeshPoint;
begin
  p := TRB3DMeshPoint.CreateFromCoord(x,y,z,i);
  MeshPoints.add(p);
end;

//------------------ TRB3DFace ------------------------------------

constructor TRB3DFace.Create;
begin
  MeshPoints := TObjectlist.Create();
  MeshPoints.ownsObjects := false;
end;

destructor TRB3DFace.Destroy;
begin
  MeshPoints.free;
end;

function TRB3DFace.GetPointCount(): integer;
begin
  result := MeshPoints.count;
end;

function TRB3DFace.GetPoint(index: integer): TRB3DMeshPoint;
begin
  if (index<0)or(index>=MeshPoints.count) then
    result := nil
  else
    result := MeshPoints.items[index] as TRB3DMeshPoint;
end;

function TRB3DFace.AddPoint(const p: TRB3DMeshPoint): boolean;
begin
  MeshPoints.add(p);
end;

function TRB3DFace.AddPointHead(const p: TRB3DMeshPoint): boolean;
begin
  MeshPoints.Insert(0,p);
end;

function TRB3DFace.GetBitmapCoord(index: integer; var x,y,b: double):boolean;
var coord: TRB3DBitmapCoordinate;
    j: integer;
begin
  result := false;
  if Bitmap=nil then exit;
    coord := Bitmap.GetCoordinate(index);
    if coord=nil then exit;
    x := coord.x;
    y := coord.y;
    b := coord.brightness;
    result := true;
{

  for j:=0 to MeshPoints.Count-1 do
  begin
    if index=(MeshPoints[j] as TRB3DMeshPoint).index then
    begin
      coord := Bitmap.GetCoordinate(j);
      if coord=nil then exit;
      x := coord.x;
      y := coord.y;
      b := coord.brightness;
      result := true;
      exit;
    end;
  end;           }
end;


//------------------ TRB3DObject ----------------------------------

constructor TRB3DObject.Create;
begin
  Meshes := TObjectlist.Create();
  Faces := TObjectlist.Create();
end;

destructor TRB3DObject.Destroy;
begin
  Meshes.free;
  Faces.free;
end;

function TRB3DObject.getMeshCount(): integer;
begin
  result := Meshes.Count;
end;

function TRB3DObject.GetMesh(index: integer): TRB3DMesh;
begin
  if (index>=getMeshCount)or(index<0) then
    result := nil
  else
    result := Meshes.items[index] as TRB3DMesh;
end;

function TRB3DObject.getFaceCount(): integer;
begin
  result := Faces.Count;
end;

function TRB3DObject.GetFace(index: integer): TRB3DFace;
begin
  if (index>=getFaceCount)or(index<0) then
    result := nil
  else
    result := Faces.items[index] as TRB3DFace;
end;


function TRB3DObject.AddFace(): TRB3DFace;
begin
  result := TRB3DFace.Create;
  Faces.add(result);
end;

function TRB3DObject.AddMesh(): TRB3DMesh;
begin
  result := TRB3DMesh.Create;
  Meshes.add(result);
end;

function TRB3DObject.CheckHash(sl: TStrings; const _hash: string): boolean;
begin
  // TODO
  result := true;
end;

end.
