unit uRBWallList;

interface

uses forms,sysutils,classes,graphics,toptions;

type
  TRBWalllist=class(TStringlist)
    public
    fn: string;
    constructor Create;
    procedure Save;
    function getIndexbyID(id:integer): integer;
    function getObjectfilenamebyID(id:integer): string;
    function getIDByIndex(index: integer): integer;
  end;

implementation

constructor TRBWalllist.Create;
var i: integer;
begin
  inherited create;
  fn := ExtractFilePath(Application.exename) + formoptions.Getobjectfolder+'\walls\wallid.dat';
  if not fileexists(fn) then exit;
  loadfromfile(fn);
  i := indexof('-');
  if i>=0 then delete(i);
  
end;

function TRBWalllist.getIndexbyID(id:integer): integer;
begin
  result := indexofname(inttostr(id));
end;

function TRBWalllist.getObjectfilenamebyID(id:integer): string;
begin
  result := values[inttostr(id)];
end;

function TRBWalllist.getIDByIndex(index: integer): integer;
begin
  if (index>=count)or(index<0) then
    result := 0
  else
    result := strtointdef(names[index],0);
end;

procedure TRBWalllist.Save;
begin
  savetofile(fn);
end;


end.
