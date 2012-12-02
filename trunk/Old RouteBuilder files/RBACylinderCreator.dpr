library RBACylinderCreator;


uses
  SysUtils,
  Classes,
  Dialogs,
  controls,
  RBAddonInterface,
  RBACylinderCreatorForm in 'RBACylinderCreatorForm.pas' {FormCC};

{$R *.res}



function RBAddonInit(_addonIn: PRBAddonIn; _addonOut: PRBAddonOut): boolean; stdcall; export;
begin
  // kopiere in
  AddonIn := _AddonIn^;
  // fülle out
  _addonOut^.AddonName := 'RBACylinderCreator';
  _addonOut^.AddonAuthor:= 'Uwe Post';
  _addonOut^.AddonVersion := addinversion;
  _addonOut^.AddonCopyright := 'RouteBuilder Dev Team 2003';
  _addonOut^.AddonWebsite := 'http://routebuilder.bve-routes.com';
  _addonOut^.AddonEmail := '-';
  _addonOut^.AddonDescription := 'Create cylinder objects';
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
var form1: TFormCC;
begin
  form1 := TFormCC.create(nil);
  result := (form1.showmodal()=mrOK);
  //MessageDlg('nothing saved yet.', mtInformation, [mbOK], 0);
  form1.free;
  //
end;

exports  RBAddonRun,RBAddonInit;


begin
end.

