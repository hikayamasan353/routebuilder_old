program B3DBuilder;



uses
  Forms,
  B3DBuilderMain in 'B3DBuilderMain.pas' {Form1},
  uTools in 'uTools.pas',
  uRBB3DObject in 'uRBB3DObject.pas',
  uRB3DPreviewForm in 'uRB3DPreviewForm.pas' {Form3DPreview},
  uRB3DObject in 'uRB3DObject.pas',
  uObjectsFrame in 'uObjectsFrame.pas' {FrmObjects: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
