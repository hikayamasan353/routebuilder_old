unit uMoveEverything;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Math,
  uGlobalDef,uTools,
  uRBProject,
  uRBPoint,
  uRBObject,
  uRBConnection,
  uCurrentsituation;

type
  TFormMoveEverything = class(TForm)
    Button1: TButton;
    Button2: TButton;
    leX: TLabeledEdit;
    leY: TLabeledEdit;
    ProgressBar1: TProgressBar;
    cbSelArea: TCheckBox;
    leScale: TLabeledEdit;
    leVert: TLabeledEdit;
    cbAreaToCursor: TCheckBox;
    cbAbsolute: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbAreaToCursorClick(Sender: TObject);
    procedure cbSelAreaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    project: TRBProject;
  end;

var
  FormMoveEverything: TFormMoveEverything;

implementation

{$R *.dfm}

procedure TFormMoveEverything.FormShow(Sender: TObject);
begin
  ProgressBar1.Hide;
  leScale.Text := '1.0';
end;

procedure TFormMoveEverything.Button1Click(Sender: TObject);
var i: integer;
    xoff,yoff,scale,vert: double;
    conn: TRBConnection;
begin
  ProgressBar1.Show;
  Button1.Enabled := false;
  if cbAreaToCursor.Checked then
  begin
    scale := 1;
    vert  := 0;
    xoff := Currentsituation.Cursor.x - min(Currentsituation.SelArea1.x,Currentsituation.SelArea2.x);
    yoff := Currentsituation.Cursor.y - min(Currentsituation.SelArea1.y,Currentsituation.SelArea2.y);
  end
  else
  begin
    xoff := strtofloat1(leX.Text);
    yoff := strtofloat1(ley.Text);
    scale := strtofloat1(leScale.text);
    vert := strtofloat1(leVert.text);
  end;
  // connections (d.h. points)
  for i:=0 to project.Points.Count-1 do
  begin
    if (not cbSelArea.checked) or
    ( (cbSelArea.checked) and(isDoublePointInRect((project.Points[i] as TRBPoint).point,Currentsituation.SelArea1,Currentsituation.SelArea2))) then
    begin
      if cbAbsolute.Checked then
        (project.Points[i] as TRBPoint).move(xoff,yoff,vert-(project.Points[i] as TRBPoint).height)
      else
        (project.Points[i] as TRBPoint).move(xoff,yoff,vert);
      (project.Points[i] as TRBPoint).scale(scale);
    end;
    ProgressBar1.Position := (30*i) div project.Points.Count;
  end;
  // conns
 { for i:=0 to project.Connections.count-1 do
  begin
    conn := project.Connections[i] as TRBConnection;
    if (not cbSelArea.checked) or
    ( (cbSelArea.checked)
      and isDoublePointInRect(conn.p1.point,Currentsituation.SelArea1,Currentsituation.SelArea2)
      and isDoublePointInRect(conn.p2.point,Currentsituation.SelArea1,Currentsituation.SelArea2)
      ) then
    begin
      conn.Height := conn.Height + vert;
    end;
    ProgressBar1.Position := 30+ (30*i) div project.Points.Count;

  end;     }
  // freeobj.
  for i:=0 to project.Freeobjects.count-1 do
  begin
    if ((project.Freeobjects[i] as TRBObject).boundtoConnID)<=0 then
    begin
      if (not cbSelArea.checked) or
      ( (cbSelArea.checked) and(isDoublePointInRect((project.Freeobjects[i] as TRBObject).point,Currentsituation.SelArea1,Currentsituation.SelArea2))) then
      begin
        if cbAbsolute.Checked then
          (project.Freeobjects[i] as TRBObject).Move(xoff,yoff,vert-(project.Freeobjects[i] as TRBObject).yoffset)
        else
          (project.Freeobjects[i] as TRBObject).Move(xoff,yoff,vert);
        (project.Freeobjects[i] as TRBObject).Scale(scale);
      end;
    end;
    ProgressBar1.Position := 60+(40*i) div project.Points.Count;
  end;
  ProgressBar1.Position := 100;
  // move area coord
  if cbAreaToCursor.Checked then
  begin
    Currentsituation.SelArea1.x := Currentsituation.SelArea1.x + xoff;
    Currentsituation.SelArea2.x := Currentsituation.SelArea2.x + xoff;
    Currentsituation.SelArea1.y := Currentsituation.SelArea1.y + yoff;
    Currentsituation.SelArea2.y := Currentsituation.SelArea2.y + yoff;
  end;
  Button1.Enabled := true;
end;

procedure TFormMoveEverything.cbAreaToCursorClick(Sender: TObject);
begin
  if cbAreaToCursor.Checked then cbSelArea.Checked := true;
  leX.enabled := not cbAreaToCursor.Checked;
  leY.enabled := not cbAreaToCursor.Checked;
  leVert.enabled := not cbAreaToCursor.Checked;
  leScale.enabled := not cbAreaToCursor.Checked;
end;

procedure TFormMoveEverything.cbSelAreaClick(Sender: TObject);
begin
  if not cbSelArea.Checked then cbAreaToCursor.Checked := false;
end;

end.
