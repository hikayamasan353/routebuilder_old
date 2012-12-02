unit uPredefinedObjectsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, utools, uRBObject;

type
  TFormPredefinedObjects = class(TForm)
    lbObj: TListBox;
    Button1: TButton;
    bAdd: TButton;
    LPredefWhat: TLabel;
    bDel: TButton;
    Button2: TButton;
    bMultiple: TButton;
    bSingle: TButton;
    procedure lbObjClick(Sender: TObject);
    procedure lbObjKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure bDelClick(Sender: TObject);
    procedure bAddClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure bSingleClick(Sender: TObject);
    procedure bMultipleClick(Sender: TObject);
  private
    { Private declarations }
    FFixedcount: integer;
    last_obj_id: string;
  public
    { Public declarations }
    DefFolder: string;
    function EditPredefinedObjects(const what: string; fixedcount: integer; obj: TStrings; const aFolder: string=''): boolean;
    function SelectObject(): string;
  end;

var
  FormPredefinedObjects: TFormPredefinedObjects;

implementation

uses uSelectObjectForm;

{$R *.dfm}

function TFormPredefinedObjects.EditPredefinedObjects(const what: string; fixedcount: integer; obj: TStrings; const aFolder: string): boolean;
var strich: boolean;
begin
  if aFolder='' then
    DefFolder := lowercase(what)
  else
    DefFolder := lowercase(aFolder);
  lbObj.Items.Clear();
  lbObj.Items.AddStrings(obj);
  LPredefWhat.caption := what;
  if lbObj.items.indexof('-')>=0 then
  begin
    strich := true;
    lbObj.items.Delete(lbObj.items.indexof('-'));
  end
  else
    strich := false;
  FFixedcount := fixedcount;
  if ShowModal=mrOK then
  begin
    obj.assign(lbObj.Items);
    if strich then obj.Add('-');
    result := true;
  end
  else
    result := false;
end;

procedure TFormPredefinedObjects.lbObjClick(Sender: TObject);
begin
  if lbObj.ItemIndex<0 then exit;
  bDel.Enabled := (lbObj.ItemIndex >= FFixedcount);
  bMultiple.Enabled := (lbObj.ItemIndex >= FFixedcount) and ((DefFolder='walls')or(DefFolder='grounds'));
  bSingle.enabled := (lbObj.ItemIndex >= FFixedcount) and (pos(',',lbObj.Items[lbObj.ItemIndex])>0);
end;

procedure TFormPredefinedObjects.lbObjKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  lbObjClick(self);
end;

procedure TFormPredefinedObjects.FormShow(Sender: TObject);
begin
  lbObjClick(self);
end;

procedure TFormPredefinedObjects.bDelClick(Sender: TObject);
begin
  if lbObj.ItemIndex>=0 then
    lbObj.DeleteSelected;
  lbObjClick(self);
end;

function TFormPredefinedObjects.SelectObject(): string;
var i: integer;
    os: string;
    o: TRBObject;
begin
  //
  FormSelectObject.SetFolder(DefFolder);
  FormSelectObject.FolderChangeable := false;
  if formSelectObject.ShowModal()=mrOK then
  begin
    os := lowercase(FormSelectObject.objfilename);
    o := TRBObject.Create(DefFolder,os);
    last_obj_id := o.getDefaultID;
    o.free;

    // bei platforms, roofs, walls das _l.b3d abschneiden
    if (DefFolder='walls') and (pos('_l.b3d',os)>0) then
      os := copy(os,1,pos('_l.b3d',os)-1);
    if (DefFolder='walls') and (pos('_r.b3d',os)>0) then
      os := copy(os,1,pos('_r.b3d',os)-1);
    if (DefFolder='platforms') then
    begin
      if(pos('cl.b3d',os)>0) then
        os := copy(os,1,pos('cl.b3d',os)-1);
      if(pos('cr.b3d',os)>0) then
        os := copy(os,1,pos('cr.b3d',os)-1);
      if(pos('l.b3d',os)>0) then
        os := copy(os,1,pos('l.b3d',os)-1);
      if(pos('r.b3d',os)>0) then
        os := copy(os,1,pos('r.b3d',os)-1);
    end;

    for i:=0 to lbObj.items.count-1 do
      if os = lowercase(lbObj.Items.Values[lbObj.Items.names[i]]) then
      begin
        MessageDlg(lngmsg.GetMsg('upredefobj_already'), mtError, [mbCancel], 0);
        exit;
      end;
  end
  else os := '';
  result := os;
end;

procedure TFormPredefinedObjects.bAddClick(Sender: TObject);
var os: string;
begin
  os := SelectObject();
  if os<>'' then
  begin
    // todo doppelte prüfen
    if last_obj_id='' then last_obj_id := inttostr(lbObj.Items.count+1);
    lbObj.items.add(last_obj_id+'='+os);
  end;

end;

procedure TFormPredefinedObjects.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key=#27 then
  begin
      modalResult := mrCancel;
  end;

end;

procedure TFormPredefinedObjects.FormShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  if Msg.CharCode=27 then close;
end;

procedure TFormPredefinedObjects.bSingleClick(Sender: TObject);
begin
  // make single
  MessageDlg('not yet implemented', mtWarning, [mbOK], 0);
end;

procedure TFormPredefinedObjects.bMultipleClick(Sender: TObject);
var os: string;
begin
  if lbObj.ItemIndex<0 then exit;
  os := SelectObject();
  if os<>'' then
    lbObj.items[lbObj.ItemIndex] := lbObj.items[lbObj.ItemIndex] + ','+os;
end;

end.
