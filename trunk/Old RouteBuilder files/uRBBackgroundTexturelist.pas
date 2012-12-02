unit uRBBackgroundTexturelist;

interface

uses forms,sysutils,classes,graphics,toptions;

type
  TRBBackgroundTexturelist=class(TStringlist)
    public
    fn: string;
    constructor Create;
    procedure Save;
    function getIndexbyID(id:integer): integer;
    function getObjectfilenamebyID(id:integer): string;
    function getIDByIndex(index: integer): integer;
    procedure setImageByIndex(index: integer; img: TPicture);
  end;

implementation

constructor TRBBackgroundTexturelist.Create;
begin
  inherited create;
  fn := ExtractFilePath(Application.exename) + FormOptions.GetObjectFolder+ '\backgrounds\bgroundid.dat';
  if not fileexists(fn) then exit;
  loadfromfile(fn);
end;

function TRBBackgroundTexturelist.getIndexbyID(id:integer): integer;
begin
  result := indexofname(inttostr(id));
end;

function TRBBackgroundTexturelist.getObjectfilenamebyID(id:integer): string;
begin
  result := values[inttostr(id)];
end;

function TRBBackgroundTexturelist.getIDByIndex(index: integer): integer;
begin
  result := strtointdef(names[index],0);
end;

procedure TRBBackgroundTexturelist.Save;
begin
  savetofile(fn);
end;

procedure TRBBackgroundTexturelist.setImageByIndex(index: integer; img: TPicture);
var fn: string;
begin
  fn := getObjectfilenamebyID(getIDbyIndex(index));
  fn := ExtractFilePath(Application.exename) + FormOptions.GetObjectFolder+'\backgrounds\' + fn;
  if fileexists(fn) then
    img.LoadFromFile(fn);
end;
end.
