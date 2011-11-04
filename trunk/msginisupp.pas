unit MsgINISupp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  IniFiles, Dialogs, LngINISupp;

type
  TMsgINISupp = class(TComponent)
  private
    FFileName: TFileName;
    FLngINISupp: TLngINISupp;
    procedure SetFileName(const Value: TFileName);
    procedure SetLngINISupp(const Value: TLngINISupp);
    procedure CheckFile(FN: TFileName);
  protected
  public
    procedure Open;
    procedure Close;
    function GetMsg(MsgName: String):String;
//    procedure SetMsg(MsgName: String);
  published
    property FileName: TFileName read FFileName write SetFileName;
    property LngINISupp: TLngINISupp read FLngINISupp write SetLngINISupp;
  end;

var
  AppIniMsg: TIniFile;
  Values: TStrings;
  FNF: Bool = false;
  FNP: Bool = false;
  Opened: Bool = false;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('LangINISupport', [TMsgINISupp]);
end;

{ TMsgINISupp }

procedure TMsgINISupp.CheckFile(FN: TFileName);
var
 strm: TMemoryStream;
begin
  strm := TMemoryStream.Create;
  if FN = '' then
    begin
      ShowMessage('ERROR!!!' + #13#10 + 'File not preset!');
      FNP := true;
    end
  else
    begin
      try
        FNP := false;
        strm.LoadFromFile(FN);
       except
        ShowMessage('WARNING!!!' + #13#10 + ' Language File Not Found! Its now creating a new!');
        FNF := true;
      end;
    end;
  strm.Free;
end;

procedure TMsgINISupp.Open;
begin
  if ((FFileName = '') and (FLngINISupp <> nil)) then FFileName := FLngINISupp.FileName;
  CheckFile(FFileName);
  if FNP = true then abort;
  Values := TStringList.Create;
  Opened := true;
end;

procedure TMsgINISupp.Close;
begin
  FFileName := '';
  Opened := false;
end;

function TMsgINISupp.GetMsg(MsgName: String):String;
var
 FMsg, RMsg: String;
 p: Integer;
begin
  if Opened = false then Open;
  AppIniMsg := TIniFile.Create(FLngINISupp.FileName);
  FMsg := AppIniMsg.ReadString('Project_Messages', MsgName, 'ERROR');
  RMsg := '';
  p := pos('"', FMsg);
  if p <> 0 then
    begin
      while Length(FMsg) <> 0 do
        begin
          p := pos('"', FMsg);
          RMsg := RMsg + Copy(FMsg, 1, p - 1) + #13#10;
          Delete(FMsg, 1, p + 7);
        end;
      Result := RMsg;
    end
  else
    Result := FMsg;
  AppIniMsg.Free;
end;
{
procedure TMsgINISupp.SetMsg(MsgName: String);
begin
  CheckFile(FFileName);
  if Opened = false then Open;
end;
}
procedure TMsgINISupp.SetLngINISupp(const Value: TLngINISupp);
begin
  FLngINISupp := Value;
  FFileName := FLngINISupp.FileName;
end;

procedure TMsgINISupp.SetFileName(const Value: TFileName);
begin
  FFileName := ExtractFileDir(ParamStr(0)) + '\' + ExtractFileName(Value);
end;

end.
