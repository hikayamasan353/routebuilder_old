unit tWizard_CreateProject;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ShlObj, ComObj, ActiveX, ExtCtrls, StdCtrls, ComCtrls,
  ShellCtrls, uRBProject, Math, Shellapi, tOptions, utools,
  uCurrentSituation, uGridTracks;

type
  TCreateProj_Wizard = class(TForm)
    WizardLogo: TImage;
    BevelLine: TBevel;
    Next: TButton;
    Back: TButton;
    Cancel: TButton;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    LabelWelcome1: TLabel;
    LabelWelcome2: TLabel;
    LabelWelcome3: TLabel;
    TabSheet2: TTabSheet;
    LabelProjectdescription: TLabel;
    Proj_Description: TMemo;
    TabSheet4: TTabSheet;
    TabSheet3: TTabSheet;
    Proj_Homepage: TLabeledEdit;
    Proj_Name: TLabeledEdit;
    Proj_Author: TLabeledEdit;
    Proj_email: TLabeledEdit;
    LabelCredits: TLabel;
    Proj_Credits: TMemo;
    Proj_Logo: TLabeledEdit;
    SearchProjectLogo_Btn: TButton;
    OpenProjectLogo: TOpenDialog;
    leSubfolder: TLabeledEdit;
    cbCreateGridAndTrack: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure NextClick(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure SetProject(Sender: TObject);
    procedure TabSheet4Show(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure SearchProjectLogo_BtnClick(Sender: TObject);
    procedure OpenProjectLogoClose(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    RWFilePath: string;
    ObjDir: string;
  end;

var
 RWFile: TextFile;
  CreateProj_Wizard: TCreateProj_Wizard;
  Rueckgabe: string;
  ProjFile: TextFile;
  DevelopersID: Integer;
  DevelopersIDRandom: Integer;


implementation

uses tmain, uEditorFrame;



{$R *.dfm}

procedure TCreateProj_Wizard.NextClick(Sender: TObject);
begin
PageControl.ActivePageIndex := PageControl.ActivePageIndex+1; // Wenn auf Weiter geklickt, dann eine Seite weiter
end;

procedure TCreateProj_Wizard.BackClick(Sender: TObject);
begin
PageControl.ActivePageIndex := PageControl.ActivePageIndex-1; // Wenn auf Zurück geklicjt, dann eine Seite zurück
end;

procedure TCreateProj_Wizard.CancelClick(Sender: TObject);
begin
 if MessageDlg(lngmsg.getMsg('twizard_close'),mtConfirmation,[mbYes, mbNo], 0) = mrYes then begin
  Close;
 end;
end;

procedure TCreateProj_Wizard.Setproject(Sender: TObject);
begin;
//Abschliessen vom Wizard
if Proj_Name.Text='' then begin
 //Checkt ob Projektname vergeben wurde, wenn nich dann
 MessageDlg(lngmsg.GetMsg('twizard_no_prjname'),mtWarning,[mbOK], 0);
 Exit;
end;

if Proj_Author.Text='' then begin
 //Checkt ob Projektauthor vergeben wurde, wenn nich dann
 MessageDlg(lngmsg.GetMsg('twizard_no_name'),mtWarning,[mbOK], 0);
 Exit;
end;

try
 try
  // erstelle ein neues TRBProject-Objekt, gib, falls nötig, ein vorhandenes vorher frei.
  if FormMain.FrmEditor.CurrentProject<>nil then
   begin
   FormMain.FrmEditor.CurrentProject.free;
   FormMain.FrmEditor.CurrentProject := nil;
   FormMain.SetProjectLoaded(false);
  end;
 FormMain.FrmEditor.CurrentProject := TRBProject.Create();

 //Zuweisen von Eingaben an uRBProject
 FormMain.FrmEditor.CurrentProject.Projectname := Proj_Name.Text;
 FormMain.FrmEditor.CurrentProject.Author := Proj_Author.Text;
 FormMain.FrmEditor.CurrentProject.Description := Proj_Description.Text;
 FormMain.FrmEditor.CurrentProject.HomepageURL := Proj_Homepage.Text;
 FormMain.FrmEditor.CurrentProject.AuthorEmailAddress := Proj_email.Text;
 FormMain.FrmEditor.CurrentProject.LogoPath := Proj_Logo.Text;
 FormMain.FrmEditor.CurrentProject.DeveloperID := DevelopersIDRandom;
 FormMain.FrmEditor.CurrentProject.Credits:= Proj_Credits.Lines.GetText;
 FormMain.FrmEditor.CurrentProject.Routefilessubdir :=leSubfolder.Text;


 FormMain.SetProjectLoaded(true);
 // Editor anzeigen
 FormMain.FrmEditor.show;
 application.ProcessMessages;

 if cbCreateGridAndTrack.Checked then
 begin
   Currentsituation.Cursor.x := 200;
   Currentsituation.Cursor.y := 500;
   Currentsituation.Offset.x := 180;
   Currentsituation.Offset.y := 520;
   FormGridTracks.EditorFrame := FormMain.FrmEditor;
   formGridTracks.ToolButton8Click(self);
 end;

   finally
//Platzhalter für späteren Gebrauch:
//if Dlg_Preferences.UseDeveloperMod=True then begin
//if FormMain.FrmEditor.CurrentProject.Routefilesdir='Railway\Route' then ShellExecute(application.Handle,'open',PChar(RouteBuilder_Main.BVE_Folder+'\Bve.exe'),PChar('"'+RouteBuilder_Main.BVE_Folder+'\'+Proj_Routefiledir.Text+'\'+Proj_Routesubdir.Text+'\'+Proj_Routefile.Text+'.csv"'+' /d='+DevelopersID),PChar(RouteBuilder_Main.BVE_Folder),SW_SHOW);
//if FormMain.FrmEditor.CurrentProject.Routefilesdir='Railway' then ShellExecute(application.Handle,'open',PChar(RouteBuilder_Main.BVE_Folder+'\Bve.exe'),PChar('"'+RouteBuilder_Main.BVE_Folder+'\'+Proj_Routefiledir.Text+'\'+Proj_Routefile.Text+'.csv"'+' /d='+DevelopersID),PChar(RouteBuilder_Main.BVE_Folder),SW_SHOW);
//end;
   CreateProj_Wizard.Close;
   FormMain.FrmEditor.tbZoom.Position := 5;
//   FormMain.ActiveControl := FormMain.FrmEditor.EditDummy;
  end;
  except
   MessageDlg('Error creating the Project',mtError,[mbOK],0);
  end;
end;

procedure TCreateProj_Wizard.TabSheet4Show(Sender: TObject);
begin
Back.Visible:=True;
Next.Caption:='&Finish >';
Next.OnClick:=SetProject;  //Bei 4ter Seite wird auf SetProject weitergeleitet
end;

procedure TCreateProj_Wizard.FormShow(Sender: TObject);
begin
PageControl.ActivePage:=TabSheet1;
 Randomize;  // Init von Zufallsgenerator
   DevelopersID:=RandomRange(10000000,90000000); //Zufällige 8-Stellige Zahl, daraus EntwicklerID
end;

procedure TCreateProj_Wizard.TabSheet1Show(Sender: TObject);
begin
Back.Visible:=False;
Next.Caption:='&Next >';
Next.OnClick:=NextClick;
end;

procedure TCreateProj_Wizard.TabSheet2Show(Sender: TObject);
begin
Back.Visible:=True;
Next.Caption:='&Next >';
Next.OnClick:=NextClick;
end;

procedure TCreateProj_Wizard.TabSheet3Show(Sender: TObject);
begin
Back.Visible:=True;
Next.Caption:='&Next >';
Next.OnClick:=NextClick;
end;

procedure TCreateProj_Wizard.SearchProjectLogo_BtnClick(Sender: TObject);
begin
OpenProjectLogo.Execute; //LogoDialog bestimmen
end;

procedure TCreateProj_Wizard.OpenProjectLogoClose(Sender: TObject);
begin
Proj_Logo.Text:=OpenProjectLogo.FileName;
end;

procedure TCreateProj_Wizard.FormCreate(Sender: TObject);
begin
  Proj_Author.Text := GetCurrentUserName;
end;

end.
