unit uRBGroundTexturelist;

interface

uses forms,sysutils,classes,toptions;

type
  TRBGroundTexturelist=class(TStringlist)
    public
    fn: string;
    constructor Create;
    procedure Save;
    function getIndexbyID(id:integer): integer;
    function getObjectfilenamebyID(id:integer): string;
    function getIDByIndex(index: integer): integer;
  end;

implementation

constructor TRBGroundTexturelist.Create;
begin
  inherited create;
  fn := ExtractFilePath(Application.exename) + FormOptions.GetObjectFolder+'\grounds\groundid.dat';
  if not fileexists(fn) then exit;
  loadfromfile(fn);
end;

function TRBGroundTexturelist.getIndexbyID(id:integer): integer;
begin
  result := indexofname(inttostr(id));
end;

function TRBGroundTexturelist.getObjectfilenamebyID(id:integer): string;
begin
  result := values[inttostr(id)];
end;

function TRBGroundTexturelist.getIDByIndex(index: integer): integer;
begin
  if index<0 then
    result := 0
  else
    result := strtointdef(names[index],0);
end;

procedure TRBGroundTexturelist.Save;
begin
  savetofile(fn);
end;


end.
