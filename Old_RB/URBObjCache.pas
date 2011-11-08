unit URBObjCache;

interface

uses sysutils, classes, uGlobalDef;

type TRBObjCache = class(TStringlist)
                         public
                         constructor Create;
                         destructor Destroy;
                         procedure AddObject(const s: string; obj: TObject);
                       end;

var RBObjCache: TRBObjCache;

implementation

constructor TRBObjCache.Create;
begin
  Duplicates := dupIgnore;
  Sorted := true;

end;



destructor TRBObjCache.Destroy;
var j: integer;
begin
  for j:=0 to count-1 do
  begin
    objects[j].free;
  end;
end;

procedure TRBObjCache.AddObject(const s: string; obj: TObject);
var sl: TStringlist;
begin
  sl := TStringlist.create;
  sl.assign( obj as TStringlist );
  inherited addObject(s,sl);
end;

initialization

RBObjCache := TRBObjCache.create;

finalization

RBObjCache.free;

end.
