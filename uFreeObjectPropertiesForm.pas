unit uFreeObjectPropertiesForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  uRBObject, utools,
  uGlobalDef,
  uCurrentSituation,
  uSelectObjectForm, Buttons;

type
  TFormFreeObjProperties = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    lObjectpath: TLabel;
    Label2: TLabel;
    edVOffset: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edRotation: TEdit;
    Label5: TLabel;
    bChange: TButton;
    Label6: TLabel;
    Label7: TLabel;
    edY: TEdit;
    edX: TEdit;
    lMaxCube: TLabel;
    b3DPreview: TSpeedButton;
    cbLocked: TCheckBox;
    bBind: TButton;
    bUnbind: TButton;
    stBoundto: TStaticText;
    lBoundTo: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure bChangeClick(Sender: TObject);
    procedure b3DPreviewClick(Sender: TObject);
    procedure bBindClick(Sender: TObject);
    procedure bUnbindClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    freeobj: TRBObject;
    changed: boolean;
  end;

var
  FormFreeObjProperties: TFormFreeObjProperties;

implementation

uses toptions, uRB3DPreviewForm;

{$R *.dfm}

procedure TFormFreeObjProperties.Button2Click(Sender: TObject);
begin
  //
  freeobj.angle := strtointdef(edRotation.text,0);
  freeobj.yoffset:=strtofloat1(edVOffset.text);
  freeobj.point.x:=strtofloat1(edX.text);
  freeobj.point.y:=strtofloat1(edY.text);
  freeobj.locked :=cbLocked.checked;
  if changed then
  begin
    freeobj.Folder := strgettoken( lObjectpath.caption,'\',1);
    freeobj.Objectfilename := strgettoken( lObjectpath.caption,'\',2);
    freeobj.CalcMaxCube();
  end;
  modalResult := mrOK;
end;

procedure TFormFreeObjProperties.Button1Click(Sender: TObject);
begin
  modalResult := mrCancel;
end;

procedure TFormFreeObjProperties.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key=#27 then
  begin
      modalResult := mrCancel;
  end;

end;

procedure TFormFreeObjProperties.FormShow(Sender: TObject);
var p1,p2,p3,p4: TDoublepoint;
begin
  lObjectpath.caption := freeobj.GetPath();
  edVOffset.text      := floattostrpoint(freeobj.yoffset);
  edRotation.text     := inttostr(freeobj.angle);
  edX.text            := floattostrpoint(freeobj.point.x);
  edY.text            := floattostrpoint(freeobj.point.y);
  cbLocked.Checked    := freeobj.locked;
  freeobj.MaxCubeRotated(p1,p2,p3,p4);
  lMaxCube.caption := floattostr(p1.x)+'/'+floattostr(p1.y)
    +' '+floattostr(p2.x)+'/'+floattostr(p2.y)
    +' '+floattostr(p3.x)+'/'+floattostr(p3.y)
    +' '+floattostr(p4.x)+'/'+floattostr(p4.y);
  if freeobj.boundtoConnID>0 then
  begin
    stBoundto.Caption := inttostr(freeobj.boundtoConnID);
    bUnbind.Enabled := true;
  end
  else
  begin
    stBoundto.Caption := '-';
    bUnbind.Enabled := false;
  end;
  bBind.Enabled := (currentSituation.CurrentConnection<>nil);
end;

procedure TFormFreeObjProperties.bChangeClick(Sender: TObject);
begin
  if FormSelectObject.ShowModal()=mrOK then
  begin
    lObjectpath.Caption := FormSelectObject.selected;
    changed := true;
  end;
end;

procedure TFormFreeObjProperties.b3DPreviewClick(Sender: TObject);
var filename: string;
begin
  filename := extractfilepath(application.exename)+ FormOptions.ObjectFolder+ '\' + lObjectpath.caption;
  Form3DPreview.Show();
  Form3DPreview.SetObject(filename);
end;


procedure TFormFreeObjProperties.bBindClick(Sender: TObject);
begin
  if freeobj.boundtoConnID=0 then
  begin
    freeobj.point.x := 0;
    freeobj.point.y := 0;
  end;
  freeobj.boundtoConnID := Currentsituation.CurrentConnection.id;
  FormShow(self);
end;

procedure TFormFreeObjProperties.bUnbindClick(Sender: TObject);
begin
  freeobj.point.x := Currentsituation.Cursor.x;
  freeobj.point.y := Currentsituation.Cursor.y;
  freeobj.boundtoConnID := 0;
  FormShow(self);
end;

end.
