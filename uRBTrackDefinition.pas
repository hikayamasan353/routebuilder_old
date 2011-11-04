unit uRBTrackDefinition;

interface

uses sysutils,classes,utools,uglobaldef;

type
     TRBTrackCurveDefinition=record
       maxcurve: integer;
       objectfilename: string;
     end;

     TRBTrackDefinition=class(TObject)
     private
       FCurveDefinitionCount: integer; // Anzahl Elemente des folgenden Arrays
       function SwitchPosToChar(p: TSwitchDirection): char;
     public
       objectfilename: string; // für gerades Gleis
       switchbasename: string; // Basisname für Weichen (z.B. switch_grey bei switch_greyLL.b3d)
       RunSoundIndex: integer; // Run-Index (0..7)
       CurveDefinition: array of TRBTrackCurveDefinition; // Definition der Kurvenstücke
       constructor Create;
       constructor CreateFromCommatext(const s: string);
       function GetAsCommatext: string;
       procedure AddCurveDefinition(tcd: TRBTrackCurveDefinition); overload;
       procedure DeleteCurveDefinition(index: integer);
       function GetObjectFilenameForCurve(curve: integer): string;
       function GetSwitchBasename(): string;
       function GetObjectFilenameForSwitch(const _dir,_set:  TSwitchDirection): string;
       procedure AddCurveDefinition(maxcurve: integer; const filename: string); overload;
       property CurveDefinitionCount: integer read FCurveDefinitionCount;
     end;


implementation

constructor TRBTrackDefinition.Create;
begin
  setlength(CurveDefinition,0);
  FCurveDefinitionCount := 0;
  RunSoundIndex := 0;
  objectfilename := '';
  switchbasename := '';
end;

// Funktion: CreateFromCommatext
// Autor   : up
// Datum   : 11.1.03
// Beschr. : erzeugt aus Commatext eine TrackDefinition.
// Format  : dateinameGeradeaus,RunIndex,MaxRadius,dateiNameDafür,MaxRadius,...
constructor TRBTrackDefinition.CreateFromCommatext(const s: string);
var i: integer;
    sl: TStringlist;
    s1: string;
begin
  sl := TStringlist.Create;
  sl.commatext := s;
  if sl.count<2 then begin sl.free; exit; end; // Fehler
  Create();
  objectfilename := StripQuotes( sl[0] );
  switchbasename := '';
  // weichenobjekt entnehmen
  if pos('|',objectfilename)>0 then
  begin
    s1 := objectfilename;
    objectfilename := StrGetToken(s1,'|',1);
    switchbasename := StrGetToken(s1,'|',2);
  end;
  RunSoundIndex := strtointdef(sl[1],0);
  FCurveDefinitionCount := (sl.count-2)div 2;
  setlength(curvedefinition,FCurveDefinitionCount);
  for i:=0 to FCurveDefinitionCount-1 do
  begin
    CurveDefinition[i].maxcurve := strtointdef(sl[i*2+2],0);
    CurveDefinition[i].objectfilename := StripQuotes( sl[i*2+2+1] );
  end;
  sl.free;
end;

procedure TRBTrackDefinition.AddCurveDefinition(maxcurve: integer; const filename: string);
var tcd: TRBTrackCurveDefinition;
begin
  tcd.maxcurve := maxcurve;
  tcd.objectfilename := filename;
  AddCurveDefinition(tcd);
end;

function TRBTrackDefinition.GetAsCommatext;
var i: integer;
begin
  result := '"'+objectfilename+'|'+ switchbasename +'",'+inttostr(RunSoundIndex);
  for i:=0 to FCurveDefinitionCount-1 do
  begin
    result := result + ','+inttostr(CurveDefinition[i].maxcurve)+',"'
             +curveDefinition[i].objectfilename+'"';
  end;
end;

procedure TRBTrackDefinition.AddCurveDefinition(tcd: TRBTrackCurveDefinition);
begin
  setlength(CurveDefinition,FCurveDefinitionCount+1);
  CurveDefinition[FCurveDefinitionCount] := tcd;
  inc(FCurveDefinitionCount);
end;

procedure TRBTrackDefinition.DeleteCurveDefinition(index: integer);
var i: integer;
begin
  for i:=index to FCurveDefinitionCount-2 do
  begin
    CurveDefinition[i] := CurveDefinition[i+1];
  end;
  setlength(CurveDefinition,FCurveDefinitionCount-1);
  dec(FCurveDefinitionCount);
end;

// Funktion: GetObjectFilenameForCurve
// Autor   : up
// Datum   : 11.1.03
// Beschr. : ermittelt zum gegebenen Radius passendes Gleisobjekt (einschl. das gerade)
// Falls diese TrackDefinition nur das gerade Gleis enthält, wird dieses zurückgegeben
function TRBTrackDefinition.GetObjectFilenameForCurve(curve: integer): string;
var i,index: integer;
begin
  index := -1;
  if curve=0 then
    result := objectfilename
  else
  if curve>0 then
  begin
    for i:=0 to FCurveDefinitionCount-1 do
    begin
      if (CurveDefinition[i].maxcurve>0)and(CurveDefinition[i].maxcurve>=curve) then
      begin
        if (index=-1)or(CurveDefinition[i].maxcurve<CurveDefinition[index].maxcurve) then
        begin
          // nimm diese Kurve
          index := i;
        end;
      end;
    end;
  end
  else
  begin
    for i:=0 to FCurveDefinitionCount-1 do
    begin
      if (CurveDefinition[i].maxcurve<0)and(CurveDefinition[i].maxcurve<=curve) then
      begin
        if (index=-1)or(CurveDefinition[i].maxcurve>CurveDefinition[index].maxcurve) then
        begin
          // nimm diese Kurve
          index := i;
        end;
      end;
    end;
  end;
  if index=-1 then
    result := objectfilename
  else
    result := curveDefinition[index].objectfilename;
end;

function TRBTrackDefinition.GetSwitchBasename:string;
begin
  result := switchbasename;
end;

function TRBTrackDefinition.SwitchPosToChar(p: TSwitchDirection): char;
begin
  if p=spLeft then result := 'L'
  else if p=spRight then result := 'R';
end;

function TRBTrackDefinition.GetObjectFilenameForSwitch(const _dir,_set:  TSwitchDirection): string;
begin
  result := switchbasename + SwitchPosToChar(_dir)+ SwitchPosToChar(_set)+'.b3d';
end;

end.
