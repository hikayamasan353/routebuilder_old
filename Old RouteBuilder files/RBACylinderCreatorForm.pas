unit RBACylinderCreatorForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, ExtDlgs,
  RBAddonInterface,
  CylinderCreator;

const addinversion = '1.0beta';  

type
  TFormCC = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Image1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    Label2: TLabel;
    leFaceCount: TLabeledEdit;
    leRadius: TLabeledEdit;
    Button2: TButton;
    leDestfilename: TLabeledEdit;
    SaveDialog1: TSaveDialog;
    bGo: TButton;
    StatusBar1: TStatusBar;
    leHeight: TLabeledEdit;
    lImgFilename: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure bGoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCC: TFormCC;

  AddonIn: RBAddonIn;

implementation

{$R *.dfm}

procedure TFormCC.Button2Click(Sender: TObject);
begin
  //
end;

procedure TFormCC.Button1Click(Sender: TObject);
begin
  //
  OpenpictureDialog1.InitialDir := AddonIn.RBAddonFunc(RBAGetObjectLibraryPath) + 'misc\';
  if OpenPictureDialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    lImgFilename.caption := ExtractFileName(OpenPictureDialog1.FileName);
  end;

end;

procedure TFormCC.bGoClick(Sender: TObject);
var cyl: TCylinderCreator;
    destpath: string;
begin
  cyl := TCylinderCreator.create;

  cyl.CreateCylinder(strtointdef(leFaceCount.text,8),strtointdef(leRadius.text,10),
  strtointdef(leHeight.Text,10),lImgFilename.caption);

  destpath := AddonIn.RBAddonFunc(RBAGetObjectLibraryPath) + 'misc\'+leDestfilename.text+'.b3d';

  cyl.savetofile(destpath);

  cyl.free;

  StatusBar1.SimpleText := 'saved to ' + destpath;
end;

procedure TFormCC.FormCreate(Sender: TObject);
begin
  statusbar1.SimpleText := 'Version ' + addinversion;
end;

end.
