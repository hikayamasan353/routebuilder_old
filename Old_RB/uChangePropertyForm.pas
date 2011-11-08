unit uChangePropertyForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  uGlobalDef,uTools,
  uCurrentSituation,
  uRBConnection, uRBProject;

type
  TFormChangeProperty = class(TForm)
    Button1: TButton;
    leFog: TLabeledEdit;
    cbSelArea: TCheckBox;
    ProgressBar1: TProgressBar;
    leAdhesion: TLabeledEdit;
    leAccuracy: TLabeledEdit;
    leSpeedlimit: TLabeledEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    project: TRBProject;
  end;

var
  FormChangeProperty: TFormChangeProperty;

implementation

{$R *.dfm}

procedure TFormChangeProperty.Button1Click(Sender: TObject);
var i: integer;
    conn: TRBConnection;
    fog,adhesion,accuracy,speedlimit: integer;
begin
  ProgressBar1.Show;
  Button1.Enabled := false;
  fog := strtointdef(leFog.text,-1);
  adhesion := strtointdef(leAdhesion.Text,-1);
  accuracy := strtointdef(leAccuracy.text,-1);
  speedlimit := strtointdef(leSpeedlimit.text,-1);


  // conns
  for i:=0 to project.Connections.count-1 do
  begin
    conn := project.Connections[i] as TRBConnection;
    if (not cbSelArea.checked) or
    ( (cbSelArea.checked)
      and isDoublePointInRect(conn.p1.point,Currentsituation.SelArea1,Currentsituation.SelArea2)
      and isDoublePointInRect(conn.p2.point,Currentsituation.SelArea1,Currentsituation.SelArea2)
      ) then
    begin
      if fog<>-1 then conn.fog := fog;
      if adhesion<>-1 then conn.adhesion := adhesion;
      if accuracy<>-1 then conn.accuracy := accuracy;
      if speedlimit<>-1 then conn.speedlimit := speedlimit;
    end;
    ProgressBar1.Position :=  (100*i) div project.Points.Count;

  end;


  ProgressBar1.Position := 100;
  Button1.Enabled := true;
end;

end.
