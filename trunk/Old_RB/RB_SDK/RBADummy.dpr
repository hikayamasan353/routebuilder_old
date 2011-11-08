library RBADummy;


uses
  SysUtils,
  Classes,
  Dialogs,
  RBAddonInterface;

{$R *.res}

var AddonIn: RBAddonIn;

function RBAddonInit(_addonIn: PRBAddonIn; _addonOut: PRBAddonOut): boolean; stdcall; export;
begin
  // copy of in record
  AddonIn := _AddonIn^;
  // fill out record
  _addonOut^.AddonName := 'RBADummy';
  _addonOut^.AddonAuthor:= 'RouteBuilder Team';
  _addonOut^.AddonVersion := '1.0';
  _addonOut^.AddonWebsite := '-';
  _addonOut^.AddonEmail := '-';
  _addonOut^.AddonDescription := 'dummy RouteBuilder addon';
  _addonOut^.AddonCopyright := 'RouteBuilder Team 2003';
  // done
  result := true;
end;

function RBAddonRun(): boolean; stdcall; export;
begin
  MessageDlg('this addin does nothing but getting the library path from RB: '
   + AddonIn.RBAddonFunc(RBAGetObjectLibraryPath), mtInformation, [mbOK], 0);

  result := true;
end;

exports    RBAddonInit, RBAddonRun;

begin
end.
