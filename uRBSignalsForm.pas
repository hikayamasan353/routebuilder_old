unit uRBSignalsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  uTools,
  tOptions,
  uRBProject,
  uCurrentSituation,
  uRBSignal;

type
  TFormSignals = class(TForm)
    lbSignals: TListBox;
    Panel1: TPanel;
    bApply: TButton;
    cbRelay: TCheckBox;
    leSignalName: TLabeledEdit;
    cbSignaltype: TComboBox;
    cbAspects: TComboBox;
    leXoffset: TLabeledEdit;
    leYoffset: TLabeledEdit;
    imSignalface: TImage;
    bMoveSignal: TButton;
    bDelete: TButton;
    lePostName: TLabeledEdit;
    bSelPostObj: TButton;
    bFind: TButton;
    procedure FormShow(Sender: TObject);
    procedure bApplyClick(Sender: TObject);
    procedure lbSignalsClick(Sender: TObject);
    procedure bMoveSignalClick(Sender: TObject);
    procedure bDeleteClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure bSelPostObjClick(Sender: TObject);
    procedure bFindClick(Sender: TObject);
  private
    { Private declarations }
    fSignal: TRBSignal;
  public
    { Public declarations }
    project : TRBProject;
    procedure SetSignal(aSignal: TRBSignal);
    procedure DoIt(aSignal: TRBSignal);
  end;

var
  FormSignals: TFormSignals;

implementation

uses uSelectObjectForm, tmain;

{$R *.dfm}

procedure TFormSignals.SetSignal(aSignal: TRBSignal);
begin
  fSignal := aSignal;
  leSignalName.Text := fSignal.Name;
  cbRelay.Checked := fSignal.Relay;
  cbSignaltype.ItemIndex := ord(fSignal.signaltype)-1;
  cbAspects.ItemIndex    := fSignal.Aspects-2;
  leXoffset.text := floattostrPoint(fSignal.xoffs);
  leYOffset.text := floattostrPoint(fSignal.yoffs);
  imSignalface.Picture.LoadFromFile(FormOptions.BVE_Folder+'\'+fSignal.GetSignalBitmap());
  lePostName.Text := fSignal.PostObjName;
end;

procedure TFormSignals.DoIt(aSignal: TRBSignal);
var i: integer;
begin
  SetSignal(aSignal);
  i := lbSignals.items.IndexOf(fSignal.name);
  lbSignals.ItemIndex := i;
  Show();
end;

procedure TFormSignals.FormShow(Sender: TObject);
var i: integer;
begin
  if project=nil then
  begin
    exit;
  end;
  lbSignals.Items.Clear;
  for i:=0 to project.Signals.count-1 do
  begin
    lbSignals.Items.add( (project.Signals[i] as TRBSignal).Name );
  end;
  panel1.visible := ( project.Signals.count>0 );
  

end;

procedure TFormSignals.bApplyClick(Sender: TObject);
begin
  fSignal.Name := leSignalName.text;
  fSignal.Relay := cbRelay.checked;
  fSignal.SignalType := TRBSignaltype(cbsignaltype.itemindex+1);
  fSignal.Aspects := cbAspects.itemindex+2;
  fSignal.xoffs := strtofloat1(leXoffset.text);
  fSignal.yoffs := strtofloat1(leYoffset.text);
  fSignal.PostObjName := lePostName.Text;
  imSignalface.Picture.LoadFromFile(FormOptions.BVE_Folder+'\'+fSignal.GetSignalBitmap());
  
end;

procedure TFormSignals.lbSignalsClick(Sender: TObject);
begin
  SetSignal(project.Signals[lbsignals.itemindex] as TRBSignal);

end;

procedure TFormSignals.bMoveSignalClick(Sender: TObject);
begin
  //
  if Currentsituation.CurrentConnection<>nil then
  begin
    fsignal.Connection := Currentsituation.CurrentConnection;
    fsignal.connectionid := Currentsituation.CurrentConnection.id;
  end;
end;

procedure TFormSignals.bDeleteClick(Sender: TObject);
begin
  if project= nil then exit;
  if project.DeleteSignalByName(leSignalname.text) then
  begin
    FormShow(self);
    if lbSignals.Items.Count>0 then
    begin
      lbSignals.ItemIndex := 0;
      lbSignalsClick(self);
    end
    else
      Panel1.Hide;
  end;
end;

procedure TFormSignals.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  if msg.CharCode=27 then close;
end;

procedure TFormSignals.bSelPostObjClick(Sender: TObject);
begin
  if formSelectObject.showModal()=mrOK then
  begin
    lepostName.text := formSelectObject.selected;
  end;
end;

procedure TFormSignals.bFindClick(Sender: TObject);
var id: integer;
begin
    id := fSignal.connectionid;
    if id=-1 then exit;
  // set current position to this track ID
    CurrentSituation.CurrentConnection := Project.FindConnectionByID( id );
    Currentsituation.Offset.x := CurrentSituation.CurrentConnection.P1.point.x;
    Currentsituation.Offset.y := CurrentSituation.CurrentConnection.P1.point.y;
    Currentsituation.cursor.x := round(Currentsituation.offset.x);
    Currentsituation.cursor.y := round(Currentsituation.offset.y);
    FormMain.FrmEditor.UpdateView;

end;

end.
