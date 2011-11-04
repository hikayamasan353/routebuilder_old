unit tfahrplan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, StdCtrls, Buttons, ExtCtrls, ValEdit;

type
  TFormTimetable = class(TForm)
    StringGrid1: TStringGrid;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormTimetable: TFormTimetable;

implementation

{$R *.dfm}

procedure TFormTimetable.FormShow(Sender: TObject);
begin
StringGrid1.Cells[0,0]:='Station';
StringGrid1.Cells[1,0]:='Ankunft';
StringGrid1.Cells[2,0]:='Abfahrt';
StringGrid1.Cells[1,1]:=TimeToStr(StrToTime('0:00:00'));
StringGrid1.Cells[2,1]:=TimeToStr(StrToTime('0:00:00'));
end;

procedure TFormTimetable.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
case ACol of
1:begin
UpDown1.Visible:=True;
UpDown2.Visible:=False;
end;
2:begin
UpDown2.Visible:=True;
UpDown1.Visible:=False
end;

end;

case ARow of
1:begin
UpDown1.Top:=32;
UpDown2.Top:=32;
end;
2:begin
UpDown1.Top:=48;
UpDown2.Top:=48;
end;
end;
end;

procedure TFormTimetable.FormClick(Sender: TObject);
begin
UpDown1.Visible:=False;
UpDown2.Visible:=False;
end;

end.
