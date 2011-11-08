unit uRBCatenaryPolelist;

interface

uses forms,sysutils,classes,toptions;

type
  TRBCatenaryPoleList=class(TStringlist)
    public
    fn: string;
    constructor Create;
    procedure Save;
    function getIndexbyID(id:integer): integer;
    function getObjectfilenamebyID(id:integer): string;
    function getIDByIndex(index: integer): integer;
  end;

implementation

constructor TRBCatenaryPoleList.Create;
var i: integer;
begin
  inherited create;
  fn := ExtractFilePath(Application.exename) + FormOptions.GetObjectFolder+'\poles\polesid.dat';
  if not fileexists(fn) then exit;
  loadfromfile(fn);
  i := indexof('-');
  if i>=0 then delete(i);
end;

function TRBCatenaryPoleList.getIndexbyID(id:integer): integer;
begin
  result := indexofname(inttostr(id));
end;

function TRBCatenaryPoleList.getObjectfilenamebyID(id:integer): string;
begin
  result := values[inttostr(id)];
end;

function TRBCatenaryPoleList.getIDByIndex(index: integer): integer;
begin
  if index=-1 then
    result := 0
  else
    result := strtointdef(names[index],0);
end;

procedure TRBCatenaryPoleList.Save;
begin
  savetofile(fn);
end;


end.
