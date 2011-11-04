unit uRBTrain;

interface

uses sysutils, classes, uTools, toptions;

type
     TRBTrainAccelerationNotch = record
       NotchStep: integer; // 1...8
       MinAcceleration,
       MaxAcceleration: double; // km/h/s
       MinAttainableSpeed,
       MaxAttainableSpeed: double; // km/h
       AccelerationFade: double; //
     end;

     TRBTrain= class(TStringlist)
       public
       Name: string;
       function GetAccelerationNotch(notch: integer): TRBTrainAccelerationNotch;
       function GetHandlecount(): integer; //1 oder 2
       function GetPowerStepCount(): integer;
       function GetBrakeStepCount(): integer;
       function GetDeceleration(): double; // km/h/s
       function GetMotorUnitWeight(): double; // t
       function GetMotorUnitCount(): integer;
       function GetNonMotorUnitWeight(): double; // t
       function GetNonMotorUnitCount(): integer;
       function GetUnitLength(): double; // m
       function GetTotalUnitWeight(): double;
       function GetMaxSpeed(): integer;
       procedure Load(const _name:string);
     end;

implementation

function TRBTrain.GetDeceleration: double;
var i: integer;
begin
  i := indexof('#PERFORMANCE');
  if i<0 then
    i := indexof('#DECELERATION');
  if i<0 then
   result := 0
  else
  begin
    result := strtofloat1(strings[i+1]);
  end;
end;

function TRBTrain.GetMotorUnitWeight(): double; // t
var i: integer;
begin
  i := indexof('#CAR');
  if i<0 then
    result := 0
  else
    result := strtofloat1(strings[i+1]);
end;

function TRBTrain.GetMotorUnitCount(): integer;
var i: integer;
begin
  i := indexof('#CAR');
  if i<0 then
    result := 0
  else
    result := strtoint(strings[i+2]);
end;

function TRBTrain.GetNonMotorUnitWeight(): double; // t
var i: integer;
begin
  i := indexof('#CAR');
  if i<0 then
    result := 0
  else
    result := strtofloat1(strings[i+3]);
end;

function TRBTrain.GetNonMotorUnitCount(): integer;
var i: integer;
begin
  i := indexof('#CAR');
  if i<0 then
    result := 0
  else
    result := strtoint(strings[i+4]);
end;

function TRBTrain.GetUnitLength(): double;
var i: integer;
begin
  i := indexof('#CAR');
  if i<0 then
    result := 0
  else
    result := strtofloat1(strings[i+5]);
end;

function TRBTrain.GetAccelerationNotch(notch: integer): TRBTrainAccelerationNotch;
var i: integer;
begin
  i := indexof('#ACCELERATION');
  result.NotchStep := 0;
  if i>=0 then
  begin
    inc(i,notch);
    if(copy(strings[i],1,1)='#') then exit;
    result.NotchStep := notch;
    result.MinAcceleration := strtofloat1(StrGetToken(strings[i],',',1));
    result.MaxAcceleration := strtofloat1(StrGetToken(strings[i],',',2));
    result.MinAttainableSpeed := strtofloat1(StrGetToken(strings[i],',',3));
    result.MaxAttainableSpeed := strtofloat1(StrGetToken(strings[i],',',4));
    result.AccelerationFade := strtofloat1(StrGetToken(strings[i],',',5));
  end;

end;

function TRBTrain.GetHandlecount(): integer; // 1 oder 2
var i: integer;
begin
  i := indexof('#HANDLE');
  if i<0 then
    result := 0
  else
    result := 2-strtoint(strings[i+1]);
end;

function TRBTrain.GetPowerStepCount(): integer;
var i: integer;
begin
  i := indexof('#HANDLE');
  if i<0 then
    result := 0
  else
    result := strtoint(strings[i+2]);
end;

function TRBTrain.GetBrakeStepCount(): integer;
var i: integer;
begin
  i := indexof('#HANDLE');
  if i<0 then
    result := 0
  else
    result := strtoint(strings[i+3]);
end;

procedure TRBTrain.Load(const _name:string);
var p: string;
begin
  name := '';
  p := formoptions.BVE_Folder+'\train\'+_name+'\train.dat';
  if fileexists(p) then
  begin
    loadfromfile(p);
    name := _name;
  end;
end;

function TRBTrain.GetTotalUnitWeight(): double;
begin
  result := GetMotorUnitWeight*GetMotorUnitCount+GetNonMotorUnitWeight*GetNonMotorUnitCount;
end;

function TRBTrain.GetMaxSpeed(): integer;
var i,m: integer;
begin
  m:=0;
  for i:=1 to 8 do
  begin
    if round(GetAccelerationNotch(i).MaxAttainableSpeed)>m then
      m := round(GetAccelerationNotch(i).MaxAttainableSpeed)
  end;
  result := m;
end;

end.
