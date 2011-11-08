program update;

uses
  Forms,
  update_main in 'update_main.pas' {UpdateWizard};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Update Wizard';
  Application.CreateForm(TUpdateWizard, UpdateWizard);
  Application.ProcessMessages;
  Application.Run;
end.
