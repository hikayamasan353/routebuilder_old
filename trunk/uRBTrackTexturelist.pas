unit uRBTrackTexturelist;

interface

uses forms,sysutils,classes,utools;

type
  TRBTrackTexturelist=class(TStringlist)
    public
    fn: string;
    constructor Create;
    procedure Save;
    function getIndexbyID(id:integer): integer;
    function getObjectfilenamebyID(id:integer): string;
    function getTrackObjectfilenamebyID(id:integer): string;
    function getCrackLObjectfilenamebyID(id:integer): string;
    function getCrackRObjectfilenamebyID(id:integer): string;
    function getIDByIndex(index: integer): integer;
  end;

implementation

constructor TRBTrackTexturelist.Create;
begin
  inherited create;
  fn := ExtractFilePath(Application.exename) + 'objects\tracks\trackid.dat';
  if not fileexists(fn) then exit;
  loadfromfile(fn);
end;

function TRBTrackTexturelist.getIndexbyID(id:integer): integer;
begin
  result := indexofname(inttostr(id));
end;

function TRBTrackTexturelist.getObjectfilenamebyID(id:integer): string;
begin
  // Format: tracktextur,cracktexturlinks,cracktexturrechts
  result := values[inttostr(id)];
end;

function TRBTrackTexturelist.getTrackObjectfilenamebyID(id:integer): string;
var s: string;
begin
  s := getObjectfilenamebyID(id);
  result := StrGetToken(s,',',1);
end;

function TRBTrackTexturelist.getCrackLObjectfilenamebyID(id:integer): string;
var s: string;
begin
  s := getObjectfilenamebyID(id);
  result := StrGetToken(s,',',2);
end;

function TRBTrackTexturelist.getCrackRObjectfilenamebyID(id:integer): string;
var s: string;
begin
  s := getObjectfilenamebyID(id);
  result := StrGetToken(s,',',3);
end;

function TRBTrackTexturelist.getIDByIndex(index: integer): integer;
begin
  result := strtointdef(names[index],0);
end;

procedure TRBTrackTexturelist.Save;
begin
  savetofile(fn);
end;


end.
