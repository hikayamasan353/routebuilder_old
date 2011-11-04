library RBAStationsigns;


uses
  SysUtils,
  Classes,
  Dialogs,
  controls,
  RBAddonInterface,
  RBAstationsignsGUI in 'RBAstationsignsGUI.pas' {FormStationsigns};

{$R *.res}



function RBAddonInit(_addonIn: PRBAddonIn; _addonOut: PRBAddonOut): boolean; stdcall; export;
begin
  // kopiere in
  AddonIn := _AddonIn^;
  // fülle out
  _addonOut^.AddonName := 'RBAStationSigns';
  _addonOut^.AddonAuthor:= 'Uwe Post';
  _addonOut^.AddonVersion := addinversion;
  _addonOut^.AddonCopyright := 'RouteBuilder Dev Team 2003';
  _addonOut^.AddonWebsite := 'http://routebuilder.bve-routes.com';
  _addonOut^.AddonEmail := '-';
  _addonOut^.AddonDescription := 'Create stations signs (Deutsche Bahnhofschilder)';
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
var form1: TFormStationSigns;
begin
  form1 := TFormStationSigns.create(nil);
  result := (form1.showmodal()=mrOK);
  //MessageDlg('nothing saved yet.', mtInformation, [mbOK], 0);
  form1.free;
  //
end;

exports  RBAddonRun,RBAddonInit;


begin
end.
