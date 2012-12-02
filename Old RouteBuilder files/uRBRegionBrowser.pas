unit uRBRegionBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, FileCtrl,
  uCurrentSituation;

type
  TFormRegionBrowser = class(TForm)
    FileListBox1: TFileListBox;
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    Panel1: TPanel;
    bLoad: TButton;
    stRegionfilename: TStaticText;
    stComment: TStaticText;
    stAuthor: TStaticText;
    stFromProject: TStaticText;
    procedure FileListBox1Click(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure bLoadClick(Sender: TObject);
    procedure FileListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormRegionBrowser: TFormRegionBrowser;

implementation

{$R *.dfm}

procedure TFormRegionBrowser.FileListBox1Click(Sender: TObject);
var sl: TStringlist;
begin
  sl := TStringlist.create;
  sl.LoadFromFile(FileListBox1.FileName);
  stRegionfilename.Caption := ExtractFileName(FileListBox1.FileName);
  stComment.Caption := sl.Values['comment'];
  stAuthor.Caption := 'Author: '+sl.Values['author'];
  stFromproject.Caption := 'From project: '+sl.Values['fromprojectname'];
  sl.free;
end;

procedure TFormRegionBrowser.FormShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  if msg.CharCode=27 then modalResult := mrCancel;
end;

procedure TFormRegionBrowser.bLoadClick(Sender: TObject);
begin
  modalResult := mrOK;
end;

procedure TFormRegionBrowser.FileListBox1DblClick(Sender: TObject);
begin
  bLoadClick(self);
  Currentsituation.ignoreClick := true;
end;

end.
