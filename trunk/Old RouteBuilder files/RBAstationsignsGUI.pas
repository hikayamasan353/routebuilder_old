unit RBAstationsignsGUI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  RBAddonInterface;

const addinversion = '1.5';

type
  TFormStationsigns = class(TForm)
    Button1: TButton;
    edBfName: TEdit;
    Label1: TLabel;
    cbStyle: TComboBox;
    Label2: TLabel;
    lInfo: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Memo1: TMemo;
    cbCaps: TCheckBox;
    Label5: TLabel;
    cbCentered: TCheckBox;
    FontDialog1: TFontDialog;
    Label6: TLabel;
    EdFontface: TEdit;
    bChangefont: TButton;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EdWidth: TEdit;
    ColorDialog1: TColorDialog;
    cbBgColor: TPanel;
    cbFrame: TPanel;
    cbFont: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo2: TMemo;
    procedure edBfNameChange(Sender: TObject);
    procedure cbStyleChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure bChangefontClick(Sender: TObject);
    procedure cbStyleClick(Sender: TObject);
    procedure cbBgColorClick(Sender: TObject);
  private
    { Private declarations }
    destpath: string;
  public
    { Public declarations }
  end;

var
  FormStationsigns: TFormStationsigns;
  AddonIn: RBAddonIn;

implementation

{$R *.dfm}

procedure TFormStationsigns.edBfNameChange(Sender: TObject);
begin
//  lBfName.caption := edBfName.text;
  cbStyleChange(self);
end;

procedure TFormStationsigns.cbStyleChange(Sender: TObject);
var w: integer;
    size: Tsize;
    str: string;
begin
  // Epoche IV
{  if cbStyle.ItemIndex=0 then
  begin
    lBfName.Font.name := 'Futura Md BT';
    lBfName.Font.color := clBlack;
    lBfName.Alignment := taCenter;
    shBack.Pen.Width := 1;
    shBack.Pen.color := clBlack;
    shBack.Brush.Color := clWhite;
    lBfName.caption := ansiuppercase(edBfName.text);
  end;
  // Epoche IV/V
  if cbStyle.ItemIndex=1 then
  begin
    lBfName.Font.name := 'Futura Md BT';
    lBfName.Font.color := clBlack;
    lBfName.Alignment := taCenter;
    shBack.Pen.Width := 3;
    shBack.Pen.color := $00CC6040;
    shBack.Brush.Color := clWhite;
    lBfName.caption := ansiuppercase(edBfName.text);
  end;
  // Epoche V
  if cbStyle.ItemIndex=2 then
  begin
    lBfName.Font.name := 'Futura Md BT';
    lBfName.Font.color := clWhite;
    lBfName.Alignment := taLeftJustify;
    shBack.Pen.Width := 0;
    shBack.Brush.Color := clNavy;
    lBfName.caption := edBfName.text;
  end;      }

  if cbCaps.Checked then
    str := ansiuppercase(edBfName.text)
  else
    str := edBfName.text;

  // Image draw
  with Image1.Picture.Bitmap.Canvas do
  begin
    font.Name := EdFontface.text;
    font.Size := 20;
    font.Color := cbFont.color;
    brush.Color := cbBgColor.color;
    brush.Style := bsSolid;
    pen.Style := psclear;
    Rectangle(0,0,Image1.Picture.width+5,Image1.Picture.height+5);
    copymode := cmSrcCopy;//  cmSrcPaint;
    GetTextExtentPoint(Image1.Picture.Bitmap.Canvas.Handle,pchar(str),
        length(str),size);
    if cbCentered.checked then
      TextOut((Image1.Picture.width-size.cx) div 2,0,str)
    else
      TextOut(5,0,str);
    pen.Color := cbFrame.color;
    pen.width := strtointdef(EdWidth.text,0);
    if pen.width>0 then
    begin
      pen.style := psSolid;
      brush.style := bsClear;
      Rectangle(0,0,Image1.Picture.width,Image1.Picture.height);
    end;
  end;


end;

procedure TFormStationsigns.FormCreate(Sender: TObject);
begin
//  Image1.Picture := TPicture.Create;

  cbStyleChange(self);
  lInfo.Caption := 'Version '+addinversion+' by Uwe Post (up@bve-routes.com) - routebuilder.bve-routes.com';



end;

procedure TFormStationsigns.Button1Click(Sender: TObject);
var s: string;
    sl: TStringlist;
    b3d: TStrings;
begin
  // get destpath
  destpath := AddonIn.RBAddonFunc(RBAGetObjectLibraryPath)+'signs\';
//  extractfilepath(application.exename)+'..\objects\signs\';
  s := 'stationsign_'+AnsiLowerCase(StringReplace(  edbfname.text,' ','_',[rfReplaceAll]));
  image1.Picture.SaveToFile(destpath+s+'.bmp');

  case PageControl1.ActivePageIndex of
  0: b3d := memo1.lines;
  1: b3d := memo2.lines;
  end;

  sl := TStringlist.create;
  sl.addstrings(b3d);
  sl.text := StringReplace(sl.text,'$s',edbfname.text,[rfReplaceAll]);
  sl.text := StringReplace(sl.text,'$n',s,[rfReplaceAll]);
  sl.savetofile(destpath+s+'.b3d');
  sl.free;

  lInfo.caption := 'SAVED';
end;

procedure TFormStationsigns.bChangefontClick(Sender: TObject);
begin
  FontDialog1.Font.Name := EdFontface.Text;
  if Fontdialog1.Execute then
  begin
    EdFontface.Text := FontDialog1.Font.Name;
    cbStyleChange(self);
  end;
end;

procedure TFormStationsigns.cbStyleClick(Sender: TObject);
begin
  //
 // Epoche IV
  if cbStyle.ItemIndex=0 then
  begin
    EdFontface.text := 'Futura Md BT';
    cbFont.color := clBlack;
    cbCentered.checked := true;
    edWidth.text := '1';
    cbFrame.color := clBlack;
    cbBgColor.color := clWhite;
    cbCaps.Checked := true;
  end;
  // Epoche IV/V
  if cbStyle.ItemIndex=1 then
  begin
    EdFontface.text := 'Futura Md BT';
    cbFont.color := clBlack;
    cbCentered.checked := true;
    edWidth.text := '5';
    cbFrame.color := $00CC6040;
    cbBgColor.color := clWhite;
    cbCaps.Checked := true;
  end;
  // Epoche V
  if cbStyle.ItemIndex=2 then
  begin
    EdFontface.text := 'Futura Md BT';
    cbFont.color := clWhite;
    cbCentered.checked := false;
    edWidth.text := '0';
    cbFrame.color := clWhite;
    cbBgColor.color := clNavy;
    cbCaps.Checked := false;
  end;
  cbStyleChange(self);
end;

procedure TFormStationsigns.cbBgColorClick(Sender: TObject);
begin
  ColorDialog1.Color := (sender as TPanel).Color;
  if ColorDialog1.execute then
  begin
    (sender as TPanel).Color := ColorDialog1.Color;
  end;
end;

end.
