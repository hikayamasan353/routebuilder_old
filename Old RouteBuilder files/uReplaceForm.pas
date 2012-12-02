unit uReplaceForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,
  uCurrentsituation,
  uRBConnection,
  uRBPoint,
  uRBRouteDefinition,
  uRBProject,
  uTrackProperties,
  uRBPlatformList,
  uRBGroundTexturelist,
  uRBBackgroundTexturelist,
  uRBCatenaryPolelist,
  uRBWallList,
  utools;

type
  TFormReplace = class(TForm)
    Label1: TLabel;
    cbSearchType: TComboBox;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    cbRouteDefinition: TCheckBox;
    cbSelArea: TCheckBox;
    bReplace: TButton;
    bCancel: TButton;
    ProgressBar1: TProgressBar;
    StatusBar1: TStatusBar;
    Label2: TCheckBox;
    edReplaceBy: TEdit;
    bSelReplaceBy: TButton;
    cbSearchfor: TComboBox;
    cbReplaceBy: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure cbSearchTypeChange(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure bReplaceClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure bSelReplaceByClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CurrentProject: TRBProject;
  end;

var
  FormReplace: TFormReplace;

implementation

uses uTrackTypes, uSelectObjectForm;

{$R *.dfm}

procedure TFormReplace.FormShow(Sender: TObject);
begin
  cbRouteDefinition.enabled := Currentsituation.CurrentRouteDefinition<>nil;
end;

procedure TFormReplace.cbSearchTypeChange(Sender: TObject);
var sl: TStringlist;
    i: integer;
    s: string;
begin
  cbSearchfor.Items.clear();
  cbReplaceby.Items.Clear();
  cbReplaceby.Hide;
  edReplaceBy.Show;
  bSelReplaceBy.Show;
  case cbSearchType.ItemIndex of
  0: // track
  begin
    FormTrackTypes.GetTrackDefinitionObjectfilenames(cbSearchfor.Items);
    FormTrackTypes.GetTrackDefinitionObjectfilenames(cbReplaceby.Items);
    cbReplaceby.Show;
    edReplaceBy.Hide;
    bSelReplaceBy.Hide;
  end;
  1: //Ground
  begin
    sl := TStringlist.create;
    sl.Duplicates := dupIgnore;
    for i:=0 to CurrentProject.Connections.count-1 do
    begin
      s := (CurrentProject.Connections[i] as TRBConnection).Ground;
      if sl.indexof(s)<0 then sl.Add(s);
    end;
    sl.sort;
    cbSearchfor.items.assign(sl);
    sl.free;
  end;
  2: //Platform
  begin
    sl := TStringlist.create;
    sl.Duplicates := dupIgnore;
    for i:=0 to CurrentProject.Connections.count-1 do
    begin
      s := (CurrentProject.Connections[i] as TRBConnection).PlatformType;
      if sl.indexof(s)<0 then sl.Add(s);
    end;
    sl.sort;
    cbSearchfor.items.assign(sl);
    sl.free;
  end;
  3: //Background
  begin
    sl := TStringlist.create;
    sl.Duplicates := dupIgnore;
    for i:=0 to CurrentProject.Connections.count-1 do
    begin
      s := (CurrentProject.Connections[i] as TRBConnection).background;
      if sl.indexof(s)<0 then sl.Add(s);
    end;
    sl.sort;
    cbSearchfor.items.assign(sl);
    sl.free;
  end;
  4: //Poles
  begin
    sl := TStringlist.create;
    sl.Duplicates := dupIgnore;
    for i:=0 to CurrentProject.Connections.count-1 do
    begin
      s := (CurrentProject.Connections[i] as TRBConnection).polestype;
      if sl.indexof(s)<0 then sl.Add(s);
    end;
    sl.sort;
    cbSearchfor.items.assign(sl);
    sl.free;

  end;
  5,6,7,8: //Wall
  begin
    sl := TStringlist.create;
    sl.Duplicates := dupIgnore;
    for i:=0 to CurrentProject.Connections.count-1 do
    begin
      s := (CurrentProject.Connections[i] as TRBConnection).WallLeft;
      s := (CurrentProject.Connections[i] as TRBConnection).WallRight;
      s := (CurrentProject.Connections[i] as TRBConnection).TSOLeft;
      s := (CurrentProject.Connections[i] as TRBConnection).TSORight;
      if sl.indexof(s)<0 then sl.Add(s);
    end;
    sl.sort;
    cbSearchfor.items.assign(sl);
    sl.free;

  end;
  end;
  cbSearchfor.ItemIndex := 0;
//  cbReplaceby.ItemIndex := 0;
end;



procedure TFormReplace.bCancelClick(Sender: TObject);
begin
  close;
end;

procedure TFormReplace.bReplaceClick(Sender: TObject);
var i,c: integer;
    doit,found: boolean;
    conn: TRBConnection;
begin
  if CurrentProject.Connections.Count=0 then
  begin
    StatusBar1.SimpleText := 'no connections in project';
    exit;
  end;
  ProgressBar1.Position := 0;
  StatusBar1.SimpleText := 'replacing...';
  c := 0;
  for i:=0 to CurrentProject.Connections.Count-1 do
  begin
    ProgressBar1.Position := (100*i) div (CurrentProject.Connections.Count);
    doit := true;
    conn := CurrentProject.Connections[i] as TRBConnection;
    // einschränken auf aktuelle RD?
    if (Currentsituation.CurrentRouteDefinition<>nil)
    and(cbRouteDefinition.Checked)
    and(not (CurrentProject.IsTrackInRouteDefinition(conn))) then doit := false;
    // einschränken auf selected area?
    if (cbSelArea.checked)
    and(( not IsDoublePointInRect(conn.P1.point,Currentsituation.SelArea1,Currentsituation.SelArea2))
    or(not IsDoublePointInRect(conn.P2.point,Currentsituation.SelArea1,Currentsituation.SelArea2))) then doit := false;

    if doit then
    begin
      if NOT Label2.Checked then
        found := true
      else
      begin
        found := false;
        case cbSearchType.ItemIndex of
        0: // track
        begin
          found := (conn.Texture=cbSearchfor.ItemIndex);
        end;
        1: //Ground
        begin
          found := (conn.Ground=cbSearchfor.Text);
        end;
        2: //Platform
        begin
          found := (conn.PlatformType=cbSearchfor.Text);
        end;
        3: //Background
        begin
          found := (conn.Background=cbSearchfor.Text);
        end;
        4: //Poles
        begin
          found := (conn.PolesType=cbSearchfor.Text);
        end;
        5: //Wall left
        begin
          found := (conn.WallLeft=cbSearchfor.Text);
        end;
        6: //Wall right
        begin
          found := (conn.WallRight=cbSearchfor.text);
        end;
        7: //TSO left
        begin
          found := (conn.TSOLeft=cbSearchfor.Text);
        end;
        8: //TSO right
        begin
          found := (conn.TSORight=cbSearchfor.text);
        end;
        end;
      end;


      if found then
      begin
        inc(c);
        case cbSearchType.ItemIndex of
        0: // track
        begin
          conn.Texture := cbReplaceby.ItemIndex;
        end;
        1: //Ground
        begin
          conn.Ground :=edReplaceby.Text
        end;
        2: //Platform
        begin
          conn.PlatformType := edReplaceby.text
        end;
        3: //Background
        begin
          conn.backGround := edReplaceby.text
        end;
        4: //Poles
        begin
          conn.PolesType := edReplaceby.Text
        end;
        5: //Wall left
        begin
          conn.WallLeft := edReplaceby.Text
        end;
        6: //Wall right
        begin
          conn.WallRight := edReplaceby.Text
        end;
        7: //TSO left
        begin
          conn.TSOLeft := edReplaceby.Text
        end;
        8: //TSO right
        begin
          conn.TSORight := edReplaceby.Text
        end;
        end; // case
      end;
    end;


  end;
  ProgressBar1.Position := 100;
  StatusBar1.SimpleText := 'completed. ' + inttostr(c) + ' connections replaced.';
end;

procedure TFormReplace.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  if msg.CharCode=27 then close;
end;

procedure TFormReplace.bSelReplaceByClick(Sender: TObject);
var s: string;
begin
  case cbSearchType.ItemIndex of
  1: //Ground
  begin
    FormSelectObject.SetFolder('grounds');
  end;
  2: //Platform
  begin
    FormSelectObject.SetFolder('platforms');
  end;
  3: //Background
  begin
    FormSelectObject.SetFolder('backgrounds');
  end;
  4: //Poles
  begin
    FormSelectObject.SetFolder('poles');
  end;
  5,6,7,8: //Walls
  begin
    FormSelectObject.SetFolder('walls');
  end;
  end;

  FormSelectObject.FolderChangeable := false;

  if FormSelectObject.ShowModal=mrOK then
  begin
    s := FormSelectObject.objfilename;
    case cbSearchType.ItemIndex of
    2: //Platform
    begin
      s:=StringReplace(s,'b3d','',[rfIgnoreCase]);
      s:=StringReplace(s,'csv','',[rfIgnoreCase]);
      s:=StringReplace(s,'CR.','',[rfIgnoreCase]);
      s:=StringReplace(s,'CL.','',[rfIgnoreCase]);
      s:=StringReplace(s,'R.','',[rfIgnoreCase]);
      s:=StringReplace(s,'L.','',[rfIgnoreCase]);
    end;
    5,6,7,8: //Walls
    begin
      s:=StringReplace(s,'b3d','',[rfIgnoreCase]);
      s:=StringReplace(s,'csv','',[rfIgnoreCase]);
      s:=StringReplace(s,'_l.','',[rfIgnoreCase]);
      s:=StringReplace(s,'_r.','',[rfIgnoreCase]);
    end;
    end;
    edReplaceBy.text := s;
  end;
end;

end.
