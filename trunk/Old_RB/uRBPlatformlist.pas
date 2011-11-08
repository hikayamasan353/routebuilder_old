unit uRBPlatformlist;

interface

uses forms,sysutils,classes,graphics, toptions;

type
  TRBPlatformlist=class(TStringlist)
    public
    fn: string;
    constructor Create;
    procedure Save;
    function getIndexbyID(id:integer): integer;
    function getObjectfilenamebyID(id:integer): string;
    function getIDByIndex(index: integer): integer;
  end;

implementation

constructor TRBPlatformlist.Create;
var i: integer;
begin
  inherited create;
  fn := ExtractFilePath(Application.exename) + formoptions.GetObjectFolder+'\platforms\platformid.dat';
  if not fileexists(fn) then exit;
  loadfromfile(fn);
  i := indexof('-');
  if i>=0 then delete(i);
end;

function TRBPlatformlist.getIndexbyID(id:integer): integer;
begin
  result := indexofname(inttostr(id));
end;

function TRBPlatformlist.getObjectfilenamebyID(id:integer): string;
begin
  result := values[inttostr(id)];
end;

function TRBPlatformlist.getIDByIndex(index: integer): integer;
begin
  if (index>=count)or(index<0) then
    result := 0
  else
    result := strtointdef(names[index],0);
end;

procedure TRBPlatformlist.Save;
begin
  savetofile(fn);
end;


end.
