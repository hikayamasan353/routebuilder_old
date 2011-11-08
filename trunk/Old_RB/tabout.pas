unit tabout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Shellapi,
  uGlobalDef;

type
  TFormAbout = class(TForm)
    PlanelRB: TPanel;
    LabelCreators: TLabel;
    LabelVersion: TLabel;
    Image1: TImage;
    Image2: TImage;
    Adress_Website: TLabel;
    LabelWebsite: TLabel;
    ThanksBox: TGroupBox;
    Memo1: TMemo;
    GroupBox1: TGroupBox;
    Memo2: TMemo;
    Button1: TButton;
    Memo3: TMemo;
    procedure Adress_WebsiteMouseLeave(Sender: TObject);
    procedure Adress_WebsiteClick(Sender: TObject);
    procedure Adress_WebsiteMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormAbout: TFormAbout;

implementation

uses tmain;

{$R *.dfm}

procedure TFormAbout.Adress_WebsiteMouseLeave(Sender: TObject);
begin
Adress_Website.Font.Color:=clBlue;
end;

procedure TFormAbout.Adress_WebsiteClick(Sender: TObject);
begin
ShellExecute(Application.Handle,'open',PChar(HomepageURL),nil,PChar(HomepageURL),sw_ShowNormal);
end;

procedure TFormAbout.Adress_WebsiteMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
Adress_Website.Font.Color:=clRed;
end;

procedure TFormAbout.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TFormAbout.FormShow(Sender: TObject);
begin
  LabelVersion.Caption := VersionString;
  // die URL kann zentral in uGlobalDef geändert werden, daher wird das Label hier gesetzt:
  Adress_Website.Caption := HomepageURL;

  // language contributors
  Memo1.lines.assign(FormMain.LngINISupp1.GetCredits);
  Memo1.lines.insert(0,'Language Files:');

  if fileexists(extractfilepath(application.exename)+Licensefilename) then
  begin
    Memo2.lines.LoadFromFile(extractfilepath(application.exename)+Licensefilename);
  end
    else Memo2.lines.Text := 'THE LICENSE FILE IS MISSING!!!!';
end;

end.
