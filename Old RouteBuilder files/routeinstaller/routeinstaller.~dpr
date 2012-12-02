program routeinstaller;

uses
  Forms,
  SysUtils,
  dialogs,
  ri_main in 'ri_main.pas' {Routeinstaller_Main},
  ri_progress in 'ri_progress.pas' {RouteInstaller_Install},
  ri_wait in 'ri_wait.pas' {Routeinstaller_Wait},
  ri_BveFolder in 'ri_BveFolder.pas' {RouteInstaller_BveFolder};

{$R *.res}


begin
//  Application.Initialize;
  Application.Title := 'RouteInstaller: please wait...';
  if IsPackagedFile() then
  begin
    if debugmode then MessageDlg('package!', mtWarning, [mbOK], 0);
    Application.CreateForm(TRouteinstaller_Wait, Routeinstaller_Wait);
    Routeinstaller_Wait.Show;
    Application.ProcessMessages;
  end
  else
  begin
    if debugmode then MessageDlg('installer!', mtWarning, [mbOK], 0);
//    Application.CreateForm(TRouteInstaller_BveFolder, RouteInstaller_BveFolder);
    Application.CreateForm(TRouteinstaller_Main, Routeinstaller_Main);
//    Application.CreateForm(TRouteInstaller_Install, RouteInstaller_Install);
    Routeinstaller_Main.Show;
    Application.ProcessMessages;
  end;
  Application.Run;
end.
