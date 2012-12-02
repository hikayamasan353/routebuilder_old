library RBAStairBuilder;


uses
  SysUtils,
  Classes,
  Dialogs,
  controls,
  RBAddonInterface,
  stairbuilder1 in 'stairbuilder1.pas' {FormStairs};

{$R *.res}



function RBAddonInit(_addonIn: PRBAddonIn; _addonOut: PRBAddonOut): boolean; stdcall; export;
begin
  // kopiere in
  AddonIn := _AddonIn^;
  // fülle out
  _addonOut^.AddonName := 'RBAStairBuilder';
  _addonOut^.AddonAuthor:= 'Uwe Post';
  _addonOut^.AddonVersion := addinversion;
  _addonOut^.AddonWebsite := '-';
  _addonOut^.AddonEmail := '-';
  _addonOut^.AddonDescription := 'Create stair objects';
  // RB veraltete Version?
  if AddonIn.RBAddonInVersion<RBAddonVersionNumber then
  begin
    result := false;
  end
  else
  // Ende
    result := true;
end;

function RBAddonRun(): boolean; stdcall; export;
var form1: TFormStairs;
begin
  form1 := TFormStairs.create(nil);
  result := (form1.showmodal()=mrOK);
  //MessageDlg('nothing saved yet.', mtInformation, [mbOK], 0);
  form1.free;
  //
end;

exports  RBAddonRun,RBAddonInit;


begin
end.




