unit uRBSaveRegionForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormSaveRegion = class(TForm)
    lComment: TLabel;
    memoComment: TMemo;
    leAuthor: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSaveRegion: TFormSaveRegion;

implementation

{$R *.dfm}

procedure TFormSaveRegion.FormShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  if msg.CharCode=27 then close;
end;

end.
