unit uwelcome;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TFormWelcome = class(TForm)
    Image1: TImage;
    Bevel1: TBevel;
    Label2: TLabel;
    bNew: TButton;
    bOpen: TButton;
    Panel1: TPanel;
    ListView1: TListView;
    Label1: TLabel;
    Image2: TImage;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure bNewClick(Sender: TObject);
    procedure bOpenClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure ListView1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    todo: string;
  end;

var
  FormWelcome: TFormWelcome;

implementation

{$R *.dfm}

procedure TFormWelcome.FormCreate(Sender: TObject);
begin
  todo:='';
end;

procedure TFormWelcome.bNewClick(Sender: TObject);
begin
  todo := 'new';
  modalResult := mrOK;
end;

procedure TFormWelcome.bOpenClick(Sender: TObject);
begin
  todo := 'open';
  modalResult := mrOK;
end;

procedure TFormWelcome.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then modalResult := mrCancel;
end;

procedure TFormWelcome.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  if msg.CharCode=27 then
  begin
    modalresult := mrcancel;
    handled := true;
  end;
end;

procedure TFormWelcome.ListView1DblClick(Sender: TObject);
begin
  if ListView1.Selected<>nil then
  begin
    todo := ListView1.Selected.caption;
    modalResult := mrOK;
  end;
end;

procedure TFormWelcome.FormShow(Sender: TObject);
begin
  if ListView1.Items.Count>0 then
    ListView1.Items[0].Selected := true;
  FocusControl(ListView1);
end;

end.
