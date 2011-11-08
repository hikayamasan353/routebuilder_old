program updater;

uses
  Forms,
  updater_main in 'updater_main.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Route Builder updater';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
