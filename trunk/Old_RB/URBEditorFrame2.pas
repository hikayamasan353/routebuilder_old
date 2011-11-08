unit URBEditorFrame2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,
  uRBProject, ComCtrls;


type
  TuEditorFrame2 = class(TFrame)
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    tbScale: TTrackBar;
    Label1: TLabel;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    BGImagefilename: string;
    CurrentProject: TRBProject;
    procedure LoadProject(const filename: string);
  end;

implementation

{$R *.dfm}

procedure TuEditorFrame2.FrameResize(Sender: TObject);
begin
    if fileexists(BGImagefilename) then
    begin
      Image1.Picture.LoadFromFile(BGImagefilename);
      Scrollbox1.HorzScrollBar.Range := Image1.Picture.Width;
      Scrollbox1.vertScrollBar.Range := Image1.Picture.Height;
    end;
end;

procedure TuEditorFrame2.LoadProject(const filename: string);
begin
  CurrentProject.LoadFromFile(filename,nil);
  BGImagefilename := CurrentProject.BackgroundMapfilename;
  FrameResize(self);
end;

end.
