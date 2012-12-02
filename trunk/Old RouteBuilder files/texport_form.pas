unit texport_form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uRBProject, ttrain, tRBExport,uEditorFrame;

type
  TFormExport = class(TForm)
    export_set_Trains: TComboBox;        
    export_set_Routes: TComboBox;
    Bevel1: TBevel;
    LabelRB: TLabel;
    Bevel2: TBevel;
    ExportBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
    ProjectToExport: TRBProject;
   end;
var
  FormExport: TFormExport;
  Export_Unit: TRBExport_Mod;

implementation

{$R *.dfm}

procedure TFormExport.FormCreate(Sender: TObject);
begin
export_set_Trains.Items:=FormTrain.TrainList.Items;

end;

procedure TFormExport.FormShow(Sender: TObject);
begin
ProjectToExport.GetRouteDefinitionsAsNames(export_set_Routes.Items);
end;

end.




