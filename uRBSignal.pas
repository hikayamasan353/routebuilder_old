unit uRBSignal;

interface

uses sysutils, classes, uTools, uGlobalDef,
     uRBConnection;

  type

  TRBSignalType = (stHome=1,stBlock=2,stExit=3);
  TRBSignal  = class
                  public
                    Connection: TRBConnection;
                    connectionid: integer;
                    Direction: integer; // (+1/-1)
                    SignalType: TRBSignalType;
                    Name: string;
                    xoffs,yoffs: double;
                    PostObjName: string; // Name des Pfosten-b3d-Objekts (muss im signals-Ordner sein), Standardwert
                    Relay: boolean; // Vorsignal j/n
                    Aspects: integer; // (2=Hp0/Hp2, 3=Hp0/Hp1)
                    constructor Create;
                    constructor CreateFromString(const s: string);
                    function GetAsString: string;
                    function GetSignalBitmap: string; // Dateiname signalxx.bmp
                    function GetCode: integer;
                end;

function GetSignalBitmap(relay: boolean; signalType: TRBSignalType): string;

implementation

function GetSignalBitmap(relay: boolean; signalType: TRBSignalType): string;
var sig: TRBSignal;
begin
  sig := TRBSignal.Create;
  sig.Relay := relay;
  sig.SignalType := signalType;
  result := sig.GetSignalBitmap;
  sig.free;
end;

constructor TRBSignal.Create;
begin
  connection := nil;
  Direction := 1;
  SignalType := stBlock;
  Name := 'S';
  xoffs := 2; yoffs := 5;
  PostObjName := 'signals\signal_post.b3d';
  relay := false;
  Aspects := 2;
end;

// wichtig: setzt nicht die connection. Dies muss das aufrufende Modul
// mit signal.connectin := project.findconnectionbyid(signal.connectionID) machen,
// weil diese Unit TRBProject nicht kennt.
constructor TRBSignal.CreateFromString(const s: string);
begin
  // Format: "name",connid,dir,type,xoffs,yoffs,"postobj",relay,asp
  connection := nil;
  name := StripQuotes( StrGetToken(s,',',1) );
  connectionid := strtointdef(StrGetToken(s,',',2),-1);
  direction := strtointdef(StrGetToken(s,',',3),1);
  signaltype := TRBSignaltype(strtointdef(StrGetToken(s,',',4),1));
  xoffs := strtofloat1(StrGetToken(s,',',5));
  yoffs := strtofloat1(StrGetToken(s,',',6));
  PostObjName := StripQuotes( StrGetToken(s,',',7) );
  relay := boolean(strtointdef(StrGetToken(s,',',8),0));
  aspects := strtointdef(StrGetToken(s,',',9),2);
end;

function TRBSignal.GetAsString: string;
begin
  result := format('"%s",%d,%d,%d,%s,%s,"%s",%d,%d',
     [name,connection.id,direction,ord(signalType),floattostrpoint(xoffs),
      floattostrpoint(yoffs),postobjname,integer(relay),aspects]);
end;

function TRBSignal.GetSignalBitmap: string;
begin
  if relay then
  begin
    result := 'relay0.bmp';
  end
  else
  begin
    if (signaltype=stExit) then result := 'signal12.bmp'
    else
    if (signaltype=stHome) then result := 'signal5.bmp'
    else
    if (signaltype=stBlock) then result := 'signal2.bmp'
    else result := 'signal2.bmp';
  end;
end;

function TRBSignal.GetCode: integer;
begin
  result := 0;
  if signaltype=stExit then result :=1
  else
  if signaltype=stHome then result :=3
  else
  if signaltype=stBlock then result :=2;
end;

end.
