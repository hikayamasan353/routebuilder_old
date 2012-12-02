unit uRBTrackObject;

interface

uses sysutils, classes, math, uRBObject, uTools;

type
  TRBTrackObject = class(TRBObject)
                    public
                     procedure MakePitchTrack(pitch: double);
                   end;

implementation

// pitch>0 -> aufwärts. pitch ist die Höhendifferenz auf 25 m
// Wichtig: Objekt darf noch nicht gepitched sein!
procedure TRBTrackObject.MakePitchTrack(pitch: double);
var rotatecommand: string;
    a: double;
    i,z: integer;
    remark: boolean;
begin
  remark := false;
  a := arcsin(pitch/25)*180/pi;
  rotatecommand := 'rotate 1,0,0,'+floattostrpoint(-a);
  FObjectfilename := '_pitch'+inttostr(round(a*100))+'_'+FObjectfilename;
  z:=0;
  i:=0;
  while i< count-1 do
  begin
    if (copy(strings[i],1,1)<>';')and not remark then
    begin
      self.insert(i,';pitched track dynamically created by RouteBuilder with height diff='+floattostrpoint(pitch));
      remark := true;
      inc(i);
    end;
    if pos('[meshbuilder]',lowercase(strings[i]))>0 then
    begin
      if z<>0 then
      begin
        self.Insert(i-1,rotatecommand);
        inc(i);
      end;
      z:=i;
    end;
    inc(i);
  end;
  if i>0 then self.Insert(i-1,rotatecommand);
  savetofile(ObjectBasePath+Ffolder+'\'+Fobjectfilename);
end;

end.
