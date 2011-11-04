unit ttrain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ShellCtrls, FileCtrl, Grids,uRBProject,
  ExtCtrls,
  uRBTrain;

type
  TFormTrain = class(TForm)
    TrainList: TListBox;
    Label1: TLabel;
    Image1: TImage;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure OK_BtnClick(Sender: TObject);
    procedure TrainListClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    Train: string;
  end;

var
  FormTrain: TFormTrain;
  Project_Unit:TRBProject;
implementation

uses toptions, taddons;

{$R *.dfm}

procedure TFormTrain.FormCreate(Sender: TObject);
var
F: TSearchRec;
begin
if Findfirst(FormOptions.BVE_Folder+'\Train\*.*',faDirectory,F)= 0 then
 begin
  repeat
   begin
   if (F.Attr=faDirectory) and (F.Name<>'.') and (F.Name<>'..') then TrainList.Items.Add(F.Name);
   end;
  until FindNext(F)<>0;
  FindClose(F);
 end;
 TrainList.ItemIndex := TrainList.Items.indexof( FormOptions.DefaultTrain );
end;


procedure TFormTrain.OK_BtnClick(Sender: TObject);
begin
Close;
end;

procedure TFormTrain.TrainListClick(Sender: TObject);
var s: string;
    train: TRBTrain;
    n: integer;
    acc: TRBTrainAccelerationNotch;
begin
  if TrainList.itemindex<0 then exit;
  s := FormOptions.BVE_Folder+'\Train\'+TrainList.Items[TrainList.itemindex];
  Image1.Picture.LoadFromFile(s+'\train.bmp');
  Memo1.Lines.LoadFromFile(s+'\train.txt');
  // additional info
  Memo1.lines.add('----------------------------------');
  Memo1.lines.add('Acceleration:');
  train := TRBTrain.Create();
  train.loadfromfile(s+'\train.dat');
  n := 1;
  repeat
    acc := train.GetAccelerationNotch(n);
    if acc.NotchStep<>0 then
    begin
      Memo1.lines.add(format('Notch %d: %f-%f km/h/s, %f-%f km/h',
        [acc.NotchStep,acc.MinAcceleration,
         acc.MaxAcceleration,
         acc.MinAttainableSpeed,
         acc.MaxAttainableSpeed]));
    end;
    inc(n);
  until acc.NotchStep = 0;
  Memo1.Lines.add(format('Power Handle: %d steps',[train.GetPowerStepCount()]));
  if train.GetHandlecount=2 then
    Memo1.Lines.add(format('Brake Handle: %d steps',[train.GetBrakeStepCount()]));
  Memo1.lines.add(format('Deceleration: %f km/h/s',[train.GetDeceleration()]));
  Memo1.lines.add(format('Motor Unit: %f t, %d unit(s)',[train.GetMotorUnitWeight(),train.GetMotorUnitCount()]));
  Memo1.lines.add(format('%d Coaches, %f t each, %f m long, total: %f t, %f m',
     [train.GetNonMotorUnitCount(),train.GetNonMotorUnitWeight(),
     train.GetUnitLength(),
     train.GetNonMotorUnitWeight()*train.GetNonMotorUnitCount(),
     train.GetUnitLength()*train.GetNonMotorUnitCount()]));

  train.free;
end;



end.
