unit URBObjSizeCache;

interface

uses sysutils, classes, uGlobalDef;

type TRBObjSizeCache = class(TStringlist)
                         public
                         procedure AddObjSize(const objfilename: string; cube: TDoubleCube);
                         function GetObjSize(const objfilename: string; var cube: TDoubleCube): boolean;
                         constructor Create;
                         destructor Destroy;
                       end;

var RBObjSizeCache: TRBObjSizeCache;

implementation

constructor TRBObjSizeCache.Create;
begin
  Duplicates := dupIgnore;
  Sorted := true;

end;

procedure TRBObjSizeCache.AddObjSize(const objfilename: string; cube: TDoubleCube);
var c: TPDoubleCube;
begin
  //if indexof(objfilename)>=0 then delete(indexof(objfilename));
  new( c );
  system.move(cube,c^,sizeof(TDoubleCube));
  addobject(objfilename,TObject(c));
end;

destructor TRBObjSizeCache.Destroy;
var i: integer;
begin
  for i:=0 to count-1 do
  begin
    dispose(pointer(objects[i]));
  end;
end;

function TRBObjSizeCache.GetObjSize(const objfilename: string; var cube: TDoubleCube): boolean;
var j: integer;
begin
  j := indexof(objfilename);
  if j<0 then
    result := false
  else
  begin
    system.move(TPDoubleCube(objects[j])^,cube,sizeof(TDoubleCube));
    result := true;
  end;
end;

initialization

RBObjSizeCache := TRBObjSizeCache.create;

finalization

RBObjSizeCache.free;

end.
