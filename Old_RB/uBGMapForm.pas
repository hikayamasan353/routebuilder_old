unit uBGMapForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, ExtCtrls, StdCtrls, jpeg;

type
  TFormBGMap = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    Button2: TButton;
    edfilename: TEdit;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    Label1: TLabel;
    EdScale: TEdit;
    Label2: TLabel;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormBGMap: TFormBGMap;

implementation

{$R *.dfm}

procedure TFormBGMap.Button1Click(Sender: TObject);
begin
  OpenPictureDialog1.FileName := edfilename.text;
  if OpenPictureDialog1.execute then
  begin
      edfilename.text := OpenPictureDialog1.FileName;
      OnShow(self);
  end;
end;

procedure TFormBGMap.Button2Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFormBGMap.Button3Click(Sender: TObject);
begin
  modalResult := mrCancel;
end;

procedure TFormBGMap.FormShow(Sender: TObject);
begin
    if fileexists(edfilename.text) then
    begin
      Image1.Picture.LoadFromFile(edfilename.text);
      TJPEGImage(Image1.Picture.Graphic).Scale := jsEighth;
      Scrollbox1.HorzScrollBar.Range := Image1.Picture.Width;
      Scrollbox1.vertScrollBar.Range := Image1.Picture.Height;
    end;
end;

end.
