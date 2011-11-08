unit SwitchGUI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls,
  switch1, bogen, Buttons,
  BitmapSelector, Menus, LngINISupp;

type
  TFormSwitch = class(TForm)
    Panel1: TPanel;
    Button2: TButton;
    Button1: TButton;
    PageControl1: TPageControl;
    tsSwitches: TTabSheet;
    tsCurves: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label1: TLabel;
    EdLength: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    EdLeftXOffset: TEdit;
    Label4: TLabel;
    EdRightXOffset: TEdit;
    Label6: TLabel;
    cbGuardrails: TCheckBox;
    rbleft: TRadioButton;
    rbRight: TRadioButton;
    Label7: TLabel;
    cbOverheadLeft: TCheckBox;
    cbOverheadRight: TCheckBox;
    Label9: TLabel;
    edFilename: TEdit;
    lPostfix: TLabel;
    lStatus: TLabel;
    ImTex3: TImage;
    Label10: TLabel;
    Label5: TLabel;
    ImTex1: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ImTex2: TImage;
    Label11: TLabel;
    Label13: TLabel;
    edRadius: TEdit;
    Label12: TLabel;
    edCurveFilename: TEdit;
    lCurvePostfix: TLabel;
    Label15: TLabel;
    cbOverheadWire: TCheckBox;
    TabSheet1: TTabSheet;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label8: TLabel;
    edWireheight1: TEdit;
    edWireheight2: TEdit;
    Label18: TLabel;
    edTrackWidth: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bLeftClick(Sender: TObject);
    procedure bRightClick(Sender: TObject);
    procedure rbleftClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImTex1Click(Sender: TObject);
    procedure ImTex2Click(Sender: TObject);
    procedure ImTex3Click(Sender: TObject);
    procedure changeValue(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    objectlibpath,
    tex1,tex2,tex3: string;
  end;

var
  FormSwitch: TFormSwitch;

implementation

{$R *.dfm}

function strtofloat1(const s: string): double;
var OldDecimalSeparator: char;
begin
  if pos('.',s)>0 then
  begin
    OldDecimalSeparator := DecimalSeparator;
    DecimalSeparator := '.';
    try
    result := strtofloat(s);
    except
    result := 0;
    end;
    DecimalSeparator := OldDecimalSeparator;
  end
  else
    result := strtointdef(s,0);
end;

procedure TFormSwitch.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TFormSwitch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormSwitch.Button1Click(Sender: TObject);
begin
 lstatus.caption := 'working...';
 // action!

 // switch?
 if PageControl1.ActivePage = tsSwitches then
 begin
   // Werte übernehmen in switch-Variablen
   laenge := strtofloat1(edlength.text);
   textur1 := tex1;
   textur2 := tex2;
   textur3 := tex3;
   xdev2  := strtofloat1(EdRightXOffset.text);
   xdev1  := strtofloat1(EdLeftXOffset.text);
   GleisBreite := strtofloat1(edTrackWidth.text);
   if rbleft.Checked then
     richtung := 'l'
   else
     richtung := 'r';
   if cbguardrails.checked then
     radlenk := 'j'
   else
     radlenk := 'n';
   if cbOverheadRight.checked then
     oberrjn := 'j'
   else
     oberrjn := 'n';
   if cbOverheadLeft.checked then
     oberljn := 'j'
   else
     oberljn := 'n';
   oberfahr := strtofloat1( edWireheight1.text );
   obertrag := strtofloat1( edWireheight2.text );
   switch1.filename:=objectlibpath + 'tracks\switch_' + edfilename.text + lPostfix.caption;
   herz := 2;
   berechnen;
   schreiben1;
   schreiben2;
   lstatus.caption := 'switch created';
 end;
 // curve?
 if PageControl1.ActivePage = tsCurves then
 begin
   // Werte übernehmen in switch-Variablen
   laenge := strtofloat1(edlength.text);
   radius := strtointdef(edRadius.text,0);
   GleisBreite := strtofloat1(edTrackWidth.text);
   texturc1 := tex1;
   texturc2 := tex2;

   if cbOverheadWire.checked then
     oberjn := 'j'
   else
     oberjn := 'n';

   oberfahr := strtofloat1( edWireheight1.text );
   obertrag := strtofloat1( edWireheight2.text );
   filename:=objectlibpath + 'tracks\' + edCurvefilename.text + lCurvePostfix.caption;
   if radius=0 then radius:=9999999;
   curve;
   lstatus.caption := 'curve created';
 end;
end;

procedure TFormSwitch.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := tsSwitches;
  tex1 := 'schotter1.bmp';
  tex2 := 'schwellen1.bmp';
  tex3 := 'weiche1b.bmp';
end;

procedure TFormSwitch.bLeftClick(Sender: TObject);
begin
  EdLeftXOffset.text := '-2.0';
  EdRightXOffset.text := '0.0';
end;

procedure TFormSwitch.bRightClick(Sender: TObject);
begin
  EdLeftXOffset.text := '0.0';
  EdRightXOffset.text := '2.0';
end;



procedure TFormSwitch.rbleftClick(Sender: TObject);
var postfix: string;
begin
  //
  if (strtofloat1(EdLeftXOffset.text)=0) then
     postfix := 'R'
  else if (strtofloat1(EdRightXOffset.text)=0) then
     postfix := 'L'
  else
     postfix := 'S';
  if rbLeft.Checked then
     postfix := postfix + 'L';
  if rbRight.Checked then
     postfix := postfix + 'R';
  if (cbOverheadLeft.checked)or(cbOverheadRight.Checked) then
     postfix := postfix + '_overhead';
  lPostfix.Caption := postfix + '.b3d';
end;

procedure TFormSwitch.FormShow(Sender: TObject);
begin
  rbleftClick(self);
  ImTex1.Picture.LoadFromFile(objectlibpath+'tracks\'+tex1);
  ImTex2.Picture.LoadFromFile(objectlibpath+'tracks\'+tex2);
  ImTex3.Picture.LoadFromFile(objectlibpath+'tracks\'+tex3);
end;

procedure TFormSwitch.ImTex1Click(Sender: TObject);
var bitmapsel: TFormBitmapSelector;
begin
  bitmapsel := TFormBitmapSelector.Create(self);
  bitmapsel.Directory := objectlibpath+'tracks\';
  bitmapsel.Filename  := tex1;
  bitmapsel.Caption   := 'Select Switch Texture 1';
  if bitmapsel.ShowModal=mrOK then
  begin
    tex1 := bitmapsel.Filename;
    ImTex1.Picture.LoadFromFile(objectlibpath+'tracks\'+tex1);
  end;
end;

procedure TFormSwitch.ImTex2Click(Sender: TObject);
var bitmapsel: TFormBitmapSelector;
begin
  bitmapsel := TFormBitmapSelector.Create(self);
  bitmapsel.Directory := objectlibpath+'tracks\';
  bitmapsel.Filename  := tex2;
  bitmapsel.Caption   := 'Select Switch Texture 2';
  if bitmapsel.ShowModal=mrOK then
  begin
    tex2 := bitmapsel.Filename;
    ImTex2.Picture.LoadFromFile(objectlibpath+'tracks\'+tex2);
  end;

end;

procedure TFormSwitch.ImTex3Click(Sender: TObject);
var bitmapsel: TFormBitmapSelector;
begin
  bitmapsel := TFormBitmapSelector.Create(self);
  bitmapsel.Directory := objectlibpath+'tracks\';
  bitmapsel.Filename  := tex3;
  bitmapsel.Caption   := 'Select Switch Texture 3';
  if bitmapsel.ShowModal=mrOK then
  begin
    tex3 := bitmapsel.Filename;
    ImTex3.Picture.LoadFromFile(objectlibpath+'tracks\'+tex3);
  end;

end;

procedure TFormSwitch.changeValue(Sender: TObject);
begin
  //
  if strtointdef(edRadius.text,0)=0 then
    lCurvePostfix.caption := ''
  else
    lCurvePostfix.caption := edRadius.text;
  if cbOverheadWire.checked then
    lCurvePostfix.caption := lCurvePostfix.caption +'_overhead';
  lCurvePostfix.caption := lCurvePostfix.caption +'.b3d';    
end;

end.
