unit uNewBGImageForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  uRBProject, ExtCtrls, jpeg;

type
  TFormNewBGImage = class(TForm)
    bCreate: TButton;
    bCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    edX: TEdit;
    EdY: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    cbGrid: TCheckBox;
    Label5: TLabel;
    EdResolution: TEdit;
    Label6: TLabel;
    lResult: TLabel;
    Label7: TLabel;
    edFilename: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EdResolutionChange(Sender: TObject);
    procedure bCreateClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Project: TRBProject;
  end;

var
  FormNewBGImage: TFormNewBGImage;

implementation

{$R *.dfm}

procedure TFormNewBGImage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormNewBGImage.EdResolutionChange(Sender: TObject);
var x,y,c: integer;
begin
  x := strtointdef(edX.text,0);
  y := strtointdef(edY.text,0);
  c := strtointdef(EdResolution.text,0);
  bCreate.Enabled := not( (x=0) or(y=0) or(c=0) );
  //
  c := x*y*c*c;
  lResult.caption := inttostr(c) + ' Pixel = ' + inttostr((c*3) div 1024) + ' KBytes in memory';
end;

procedure TFormNewBGImage.bCreateClick(Sender: TObject);
var x,y,c,j: integer;
    bm: TBitmap;
    jp: TJPEGImage;
begin
  x := strtointdef(edX.text,0);
  y := strtointdef(edY.text,0);
  c := strtointdef(EdResolution.text,0);
  Screen.Cursor := crHourGlass;
  bm := TBitmap.Create;
  bm.Width := x*c;
  bm.Height := y*c;
  with bm.Canvas do
  begin
    brush.Style := bsSolid;
    brush.Color := clGreen;
    Rectangle(0,0,x*c-1,y*c-1);
    if cbGrid.Checked then
    begin
      pen.width := 1;
      pen.Color := clSilver;
      // 100m Grid
      pen.Style := psDot;
      for j:=0 to x*10 do
      begin
        moveto(j*c div 10,0); LineTo(j*c div 10,y*c);
      end;
      for j:=0 to y*10 do
      begin
        moveto(0,j*c div 10); LineTo(x*c,j*c div 10);
      end;
      // km Grid
      pen.Style := psSolid;
      for j:=0 to x do
      begin
        moveto(j*c,0); LineTo(j*c,y*c);
      end;
      for j:=0 to y do
      begin
        moveto(0,j*c); LineTo(x*c,j*c);
      end;
    end;
  end;
  jp := TJPEGImage.Create;
  try
    with jp do
    begin
      compressionQuality := 80;
      Assign(bm);
      SaveToFile(extractfilepath(Project.Projectfilename) + edFilename.text );
    end;
  finally
    jp.Free;
  end;
  Project.BackgroundMapfilename := extractfilepath(Project.Projectfilename) + edFilename.text;
  Project.BackgroundMapScale := c;
  bm.free;
  Screen.Cursor := crDefault;
  modalResult := mrOK;
end;

procedure TFormNewBGImage.FormShow(Sender: TObject);
begin
  //
  edFilename.text := Project.Projectname + ' Background.jpg';
end;

procedure TFormNewBGImage.bCancelClick(Sender: TObject);
begin
close;  
end;

end.
