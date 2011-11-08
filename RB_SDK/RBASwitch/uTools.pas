unit uTools;

interface

uses sysutils, classes, Types, uGlobalDef, math, msginisupp;

function StrGetToken (const SourceStr, StringSep: String; TokenNum: Integer): String;
procedure ConvertCoordPixelToWorld(pixel,windowcenter: TPoint; offset: TDoublePoint; zoom: double; var world: TDoublePoint);
procedure ConvertCoordWorldToPixel(world: TDoublepoint; windowcenter: TPoint; offset: TdoublePoint; zoom: double; var pixel: TPoint);
procedure ReplacePlaceholder(sl: TStringlist; placeholder: string; stringstoinsert: TStringlist);
function DoublePointToPoint(db: TDoublePoint):TPoint;
function floattostrPoint(a: double): string;
function StripQuotes(const str: string): string;
function Distance(const p1,p2: TDoublePoint): double;
function IntDistance(const p1,p2: TPoint): integer;
function Intersection(const a1,a2,b1,b2: TDoublePoint;var p: TDoublePoint): boolean;
procedure Perpendicular(const a1,a2: TDoublePoint;  f: double; var p: TDoublePoint);
function PlatformPosChar(t: integer): char;
function DoublePoint(x,y: double): TDoublePoint;
function Triangle(a,p1,p2: TDoublePoint): double;
function angle(p1,p2: TDoublePoint): double;
function strtofloat1(const s: string): double;
function IsPointInSegment(p1,p2,p3: TDoublePoint; l: double; var a,b: double): boolean;
function sgn(a: double): integer;
function strtobooldef(const s: string; def: boolean): boolean;
function booltoint(b: boolean): integer;
function inttobool(i: integer): boolean;
function FindInStringlist(sl: TStringlist; const str: string): integer;
function IsDoublePointInRect(p,r1,r2: TDoublePoint): boolean;

var lngmsg: TMsgINISupp;

implementation

function GetToken (const SourceStr, StringSep: PChar; Token: PChar; TokenNum: Integer): PChar;
var
   TokensFound: Word;
   SourcePos: PChar;
   TargetPos: PChar;
begin
   TokensFound := 0;
   if (StrLen (SourceStr) > 0) then
   begin
      Inc (TokensFound);
      SourcePos := SourceStr;
      TargetPos := Token;
      while ((TokensFound <= TokenNum) and (SourcePos^ <> #0)) do
      begin
         if (StrScan (StringSep, SourcePos^) <> Nil) then
            Inc (TokensFound)
         else
         begin
            if (TokensFound = TokenNum) then
            begin
               TargetPos^ := SourcePos^;
               Inc (TargetPos);
            end;
         end;
         Inc (SourcePos);
      end;
      TargetPos^ := #0;
   end
   else
      Token^ := #0;
   Result := Token;
end;

function StrGetToken (const SourceStr, StringSep: String; TokenNum: Integer): String;
begin
   SetLength (Result, Length (SourceStr) + 1);
   GetToken (PChar (SourceStr), PChar (StringSep), PChar (Result), TokenNum);
   SetLength (Result, StrLen (PChar (Result)));
end;

function StripQuotes(const str: string): string;
var i: integer;
    str_: string;
begin
  if length(str)<1 then begin result :=str; exit; end;
  str_ := str;
  i := 1;
  while (length(str_)>0) and(str_[1]='"') do
    str_ := copy(str_,2,maxint);
  if length(str_)<1 then begin result :=str_; exit; end;
  while str_[length(str_)]='"' do
    str_ := copy(str_,1,length(str_)-1);
  result := str_;
end;


// konvertiere Weltkoordinaten zu Pixelkoordinaten im Editorfenster
procedure ConvertCoordWorldToPixel(world: TDoublepoint; windowcenter: TPoint; offset: TdoublePoint; zoom: double; var pixel: TPoint);
begin
  pixel.X := round((world.x-offset.x) * zoom) + windowcenter.x;
  pixel.Y := round((-world.y+offset.y) * zoom) + windowcenter.y;
end;

procedure ConvertCoordPixelToWorld(pixel,windowcenter: TPoint; offset: TDoublePoint; zoom: double; var world: TDoublePoint);
begin
  world.x := (pixel.x-windowcenter.x)/zoom+offset.x;
  world.y := -((pixel.y-windowcenter.y)/zoom-offset.y);
end;

function DoublePointToPoint(db: TDoublePoint):TPoint;
begin
  result.x := round(db.x);
  result.y := round(db.y);
end;


function Distance(const p1,p2: TDoublePoint): double;
begin
  result := sqrt( sqr(p1.X-p2.x) + sqr(p1.y-p2.y) );
end;

function IntDistance(const p1,p2: TPoint): integer;
begin
  result := round(sqrt( sqr(p1.X-p2.x) + sqr(p1.y-p2.y) ));
end;

function PlatformPosChar(t: integer): char;
begin
  case t of
  0: result := '0';
  1: result := 'R';
  2: result := 'L';
  end;
end;

function DoublePoint(x,y: double): TDoublePoint;
begin
  result.x := x;
  Result.y := y;
end;

function floattostrPoint(a: double): string;
var OldDecimalSeparator: char;
begin
  OldDecimalSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  result := floattostrF(a,ffFixed,5,5);
  DecimalSeparator := OldDecimalSeparator;
end;

// berechne den Winkel zwischen |ap1| und |ap2|
function Triangle(a,p1,p2: TDoublePoint): double;
begin
  result := angle(a,p2)-angle(a,p1);
end;

// berechne den Winkel von |p1p2|
function angle(p1,p2: TDoublePoint): double;
var dx,dy: double;
begin
  dy := p2.Y-p1.y;
  dx := p2.x-p1.x;
  if dx=0 then
  begin
    if dy>0 then
      result := 90
    else
      result := -90;
  end
  else //if dx>0 then
    result := round(180*arctan2(dy,dx)/pi)
{  else // dx<0
  begin
      result := round(180*arctan2(dy,dx)/pi)
    else
      result := round(180*arctan2(dy,dx)/pi);
  end;}
end;

function strtofloat1(const s: string): double;
var OldDecimalSeparator: char;
begin
  if pos('.',s)>0 then
  begin
    OldDecimalSeparator := DecimalSeparator;
    DecimalSeparator := '.';
    try
    result := strtofloat(s);
    except
    result := 0;
    end;
    DecimalSeparator := OldDecimalSeparator;
  end
  else
    result := strtointdef(s,0);
end;

// Funktion: IsPointInSegment
// Autor   : up
// Datum   : 11.2002
// Beschr. : ermittelt, ob p3 im Abstand l von der Strecke p1p2 liegt oder näher.
// gibt in a und b folgendes zurück:
// a: Abstand der Senkrechten von p1 von 0 bis 1 (mit länge p1p2 multiplizieren, um wirkliche Länge zu erhalten)
// b: Länge der Senkrechten (d.h. Abstand von p1p2) von 0 bis 1 (mit l multiplizieren)
function IsPointInSegment(p1,p2,p3: TDoublePoint; l: double; var a,b: double): boolean;
var r,x1,x2,x3,y1,y2,y3,xv,yv: double;
begin
  result := false;
  r := Distance(p1,p2);
  if r=0 then exit;

  // Hilfsvariable
  x1 := p1.x;
  x2 := p2.x;
  x3 := p3.x;
  y1 := p1.y;
  y2 := p2.y;
  y3 := p3.y;

  xv :=   (y2-y1)*l/r; // vertikalvektor x-komp
  yv :=  -(x2-x1)*l/r; // vertikalvektor y-komp.

  // division by zero vermeiden durch sehr simplen workaround
  if xv=0 then xv := 0.00001;
  if yv=0 then yv := 0.00001;

  // Abstand in Richtung P1P2 (Bruchteil der Länge P1P2, also r)
  a := (yv*(x3-x1) - xv*(y3-y1))
     / (yv*(x2-x1) - xv*(y2-y1));

  // Abstand vertikal zu P1P2 (Bruchteil von l)
  b := (x3-x1-a*(x2-x1))/xv;

  result := (a>=0)and(a<=1.01)and(b>=-1)and(b<=1);

end;

function sgn(a: double): integer;
begin
  if a<0 then
    result := -1
  else
  if a>0 then
    result := 1
  else
    result := 0;
end;


function booltoint(b: boolean): integer;
begin
  if b then
    result :=1
  else                                               
    result :=0;
end;

function inttobool(i: integer): boolean;
begin
  result := (i>0);
end;

function strtobooldef(const s: string; def: boolean): boolean;
begin
  result := inttobool( strtointdef(s,booltoint(def)) );
end;

// Funktion: ReplacePlaceholder
// Autor   : up
// Datum   : 11.1.03
// Beschr. : ersetzt Zeile "placeholder" in sl durch stringstoinsert
procedure ReplacePlaceholder(sl: TStringlist; placeholder: string; stringstoinsert: TStringlist);
var i,j: integer;
begin
  i := sl.IndexOf(placeholder);
  if i>=0 then
  begin
    for j := 0 to stringstoinsert.count-1 do
    sl.insert(i+j,stringstoinsert[j]);
  end; // sonst schlecht!
  // entferne Platzhalter
  i := sl.IndexOf(placeholder);
  if i>=0 then
    sl.Delete(i);
end;
// berechne Schnittpunkt zwischen Strecken a1a2 und b1b2
function Intersection(const a1,a2,b1,b2: TDoublePoint;var p: TDoublePoint): boolean;
var i,j,n1,n2,z1,z2: double;
begin
  result := false;

  n1 := (b2.x-b1.x)*(b2.y-b1.y);
  n2 := (a2.x-a1.x)*(b2.y-b1.y)-(a2.y-a1.y)*(b2.x-b1.x);

  if n1*n2=0 then
  begin // b1b2 ist Horizontale. Spezialbehandlung.
    if (b1.y=b2.y) then
    begin
      if (a1.y>b1.y)and(a2.y>b1.y) then exit;
      if (a1.y<b1.y)and(a2.y<b1.y) then exit;
      if a2.y=a1.y then
      begin
        // auch a1a2 ist Horizontale.
        if a1.y<>b1.y then exit;
        // Die Horizontalen liegen auf einer Geraden.
        if (max(a1.x,a2.x)<b1.x)and(max(a1.x,a2.x)<b2.x) then exit;
        if (min(a1.x,a2.x)>b1.x)and(min(a1.x,a2.x)>b2.x) then exit;
        // Die Horizontalen überschneiden sich.
        p.y := a1.y;
        // nimm Schwerpunkt (was besseres fällt mir nicht ein, eigentlich müsste man
        // hier unendlich viele Punkte zurückgeben)
        p.x := (a1.x+a2.x+b1.x+b2.x)/4;
        result := true;
      end
      else
      begin
        i := (b1.y-a1.y)/(a2.y-a1.y);
        j := a1.x+i*(a2.x-a1.x);
        if (j>=b1.x)and(j<=b2.x) then
        begin
          p.x := j;
          p.y := b1.y;
          result := true;
        end;
      end;
    end
    else
    if (b1.x=b2.x) then
    begin
      // b1b2 ist Vertikale.Sonderbehandlung.
      if (a1.x>b1.x)and(a2.x>b1.x) then exit;
      if (a1.x<b1.x)and(a2.x<b1.x) then exit;
      if a2.x=a1.x then
      begin
        // auch a1a2 ist Vertikale
        if a1.x<>b1.x then exit;
        // Die Vertikalen liegen auf einer Geraden.
        if (max(a1.y,a2.y)<b1.y)and(max(a1.y,a2.y)<b2.y) then exit;
        if (min(a1.y,a2.y)>b1.y)and(min(a1.y,a2.y)>b2.y) then exit;
        // Die Vertikalen überschneiden sich.
        p.x := a1.x;
        // nimm Schwerpunkt (was besseres fällt mir nicht ein, eigentlich müsste man
        // hier unendlich viele Punkte zurückgeben)
        p.y := (a1.y+a2.y+b1.y+b2.y)/4;
        result := true;
      end
      else
      begin
        i := (b1.x-a1.x)/(a2.x-a1.x);
        j := a1.y+i*(a2.y-a1.y);
        if (j>=b1.y)and(j<=b2.y) then
        begin
          p.x := b1.x;
          p.y := j;
          result := true;
        end;
      end;
    end;

    exit;
  end;

  z1 := (b1.x-a1.x)*(b2.y-b1.y)-(b2.x-b1.x)*(b1.y-a1.y);
  z2 := (b2.x-b1.x)*(b2.y-b1.y);

  i := z1*z2/(n1*n2);

  if b2.x-b1.x<>0 then
    j := (i*(a2.x-a1.x)-(b1.x-a1.x))/(b2.x-b1.x)
  else if b2.y-b1.y<>0 then
    j := (i*(a2.y-a1.y)-(b1.y-a1.y))/(b2.y-b1.y)
  else
  begin
    //
    exit;
  end;

  if (i>=0)and(i<=1)and(j>=0)and(j<=1) then
  begin
    p.x := a1.x+i*(a2.x-a1.x);
    p.y := a1.y+i*(a2.y-a1.y);
    result := true;
  end;

end;

procedure Perpendicular(const a1,a2: TDoublePoint; f: double; var p: TDoublePoint);
begin
  p.x := a1.x- (a2.y-a1.y)*f;
  p.y := a1.y+ (a2.x-a1.x)*f;
end;

// Funktion: FindInStringlist
// Autor   : up
// Datum   : 12.1.03
// Beschr. : suche in Stringlist nach String, wobei nur bis zu dessen Länge überprüft wird
function FindInStringlist(sl: TStringlist; const str: string): integer;
var i: integer;
begin
  result := -1;
  for i:=0 to sl.count-1 do
  begin
    if copy(sl[i],1,length(str))=str then
    begin
      result := i;
      break;
    end;
  end;
end;

function IsDoublePointInRect(p,r1,r2: TDoublePoint): boolean;
begin
  result := (p.x >= min(r1.x,r2.x)) and (p.x<= max(r1.x,r2.x))
        and (p.y >= min(r1.y,r2.y)) and (p.y<= max(r1.y,r2.y));
end;

end.
