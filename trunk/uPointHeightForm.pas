unit uPointHeightForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,utools;

type
  TFormPointHeight = class(TForm)
    Button1: TButton;
    Button2: TButton;
    leFontHeight: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function DoModal(h: integer): integer;
  end;

var
  FormPointHeight: TFormPointHeight;

implementation

{$R *.dfm}

function TFormPointHeight.DoModal(h: integer): integer;
begin
  result := h;
  leFontHeight.Text := inttostr(h);
  if ShowModal=mrOK then
  begin
    result := strtoint(leFontHeight.text);
  end;
end;

procedure TFormPointHeight.Button1Click(Sender: TObject);
begin
  modalResult := mrOK;
end;

procedure TFormPointHeight.Button2Click(Sender: TObject);
begin
  modalResult := mrCancel;
end;

end.
