library RBASwitch;


uses
  SysUtils,
  Classes,
  Dialogs,
  RBAddonInterface,
  SwitchGUI in 'SwitchGUI.pas' {FormSwitch},
  bogen in 'BOGEN.PAS',
  DKWINIT in 'DKWINIT.PAS',
  DKW in 'DKW.PAS',
  ekreuz in 'EKREUZ.PAS',
  ekreuzw in 'EKREUZW.PAS',
  EK in 'EK.PAS',
  EKW in 'EKW.PAS',
  MIRROR in 'MIRROR.PAS',
  SWITCH1 in 'SWITCH1.PAS',
  BitmapSelector in 'BitmapSelector.pas' {FormBitmapSelector};

{$R *.res}

const versionnumber = '0.3';

var AddonIn: RBAddonIn;

function RBAddonInit(_addonIn: PRBAddonIn; _addonOut: PRBAddonOut): boolean; stdcall; export;
begin
  // kopiere in
  AddonIn := _AddonIn^;
  if AddonIn.RBAddonInVersion<2 then begin result := false; end;
  // fülle out
  _addonOut^.AddonName := 'RBASwitch';
  _addonOut^.AddonAuthor:= 'Ruediger Huelsmann, Uwe Post';
  _addonOut^.AddonVersion := versionnumber;
  _addonOut^.AddonWebsite := '-';
  _addonOut^.AddonEmail := '-';
  _addonOut^.AddonDescription := 'creating switch objects';
  _addonOut^.AddonCopyright := 'RouteBuilder Team and Ruediger Huelsmann 2003';
  // Ende
  result := true;
end;

function RBAddonRun(): boolean; stdcall; export;
var form: TformSwitch;
begin
  form := TFormSwitch.Create(nil);
  form.objectlibpath :=  AddonIn.RBAddonFunc(RBAGetObjectLibraryPath);
  form.caption := 'Switch for RouteBuilder|version ' + versionnumber;
  form.ShowModal();
  result := true;
end;

exports    RBAddonInit, RBAddonRun;

begin
end.
