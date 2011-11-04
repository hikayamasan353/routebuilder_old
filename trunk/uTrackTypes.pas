unit uTrackTypes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  uRBTrackDefinition, ImgList, uTools,
  uGlobalDef;

type
  TFormTrackTypes = class(TForm)
    PageControl1: TPageControl;
    TabSheet4: TTabSheet;
    Image2: TImage;
    Label5: TLabel;
    Label6: TLabel;
    lvTracktypes: TListView;
    leObjectName: TLabeledEdit;
    bSelectObjectfilenameStraight: TButton;
    cbRunSound: TComboBox;
    lvCurveTracks: TListView;
    leObjectfileCurved: TLabeledEdit;
    bSelectObjectfilenameCurved: TButton;
    leMaxCurveUse: TLabeledEdit;
    bDelCurveDef: TButton;
    bAddCurveDef: TButton;
    bDelTrackDef: TButton;
    bAddTrackDef: TButton;
    bSetCurveDef: TButton;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    ImageList1: TImageList;
    leSw1: TLabeledEdit;
    bSelectSwitchObject: TButton;
    bCurvesAuto: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvTracktypesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvCurveTracksSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure bSelectObjectfilenameStraightClick(Sender: TObject);
    procedure cbRunSoundChange(Sender: TObject);
    procedure bSelectObjectfilenameCurvedClick(Sender: TObject);
    procedure bAddCurveDefClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure bSetCurveDefClick(Sender: TObject);
    procedure bDelCurveDefClick(Sender: TObject);
    procedure bAddTrackDefClick(Sender: TObject);
    procedure bDelTrackDefClick(Sender: TObject);
    procedure bSelectSwitchObjectClick(Sender: TObject);
    procedure bCurvesAutoClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
  private
    { Private declarations }
    activeItem: TListItem;
    CurrentCurvetrackitem : TListItem;
    procedure CurveTracksToTrackTypes();
  public
    { Public declarations }
    TrackDefinitions: TStringlist;
    procedure SetActiveIcon();
    procedure GetTrackDefinitionObjectfilenames(sl: TStrings);
    function GetTrackDefinitionObject(tracktype,curve: integer): string;
    function GetTrackDefinitionSwitchObject(tracktype: integer; _dir,_set: TSwitchDirection): string;
    function GetTrackDefinitionSwitchBasefilename(tracktype: integer): string;
    function GetTrackDefinitionRunsound(const trackobject: string): integer;
    function FindTrackObjectInDefinitions(const trackobject: string): integer;
  end;

var
  FormTrackTypes: TFormTrackTypes;

implementation

uses uSelectObjectForm;

{$R *.dfm}

procedure TFormTrackTypes.FormCreate(Sender: TObject);
var fn: string;
begin
  TrackDefinitions := TStringlist.create;
  fn := extractfilepath(application.exename)+'\trackdef.dat';
  if not fileexists(fn) then
  begin
    TrackDefinitions.clear;
    TrackDefinitions.add('tracks\track0.b3d,2');
    TrackDefinitions.add('"tracks\brown.b3d",0,1000,"tracks\brown1000.b3d",500,"tracks\brown500.b3d",150,"tracks\brown150.b3d"'
      +',-1000,"tracks\brown-1000.b3d",-500,"tracks\brown-500.b3d",-150,"tracks\brown-150.b3d"');
    TrackDefinitions.add('"tracks\brown_overhead.b3d",2,1000,"tracks\brown1000_overhead.b3d",500,"tracks\brown500_overhead.b3d",150,"tracks\brown150_overhead.b3d"'
      +',-1000,"tracks\brown-1000_overhead.b3d",-500,"tracks\brown-500_overhead.b3d",-150,"tracks\brown-150_overhead.b3d"');
    TrackDefinitions.add('"tracks\grey.b3d",2,1000,"tracks\grey1000.b3d",500,"tracks\grey500.b3d",150,"tracks\grey150.b3d"'
      +',-1000,"tracks\grey-1000.b3d",-500,"tracks\grey-500.b3d",-150,"tracks\grey-150.b3d"');
    TrackDefinitions.add('"tracks\grey_overhead.b3d",2,1000,"tracks\grey1000_overhead.b3d",500,"tracks\grey500_overhead.b3d",150,"tracks\grey150_overhead.b3d"'
      +',-1000,"tracks\grey-1000_overhead.b3d",-500,"tracks\grey-500_overhead.b3d",-150,"tracks\grey-150_overhead.b3d"');
    TrackDefinitions.add('tracks\dark.b3d,3');
    TrackDefinitions.add('tracks\dark_overhead.b3d,3');
    TrackDefinitions.add('tracks\bridgetrack.b3d,6');
    TrackDefinitions.add('tracks\bridgetrack_overhead.b3d,6');
  end
  else
    TrackDefinitions.LoadFromFile(fn);

end;

procedure TFormTrackTypes.FormShow(Sender: TObject);
var i: integer;
    TD: TRBTrackDefinition;
begin
  // Track Def.
  bDelTrackDef.Enabled := false;
  lvTracktypes.items.clear;
  lvCurveTracks.items.clear;
  for i:=0 to TrackDefinitions.count-1 do
  begin
    TD := TRBTrackDefinition.CreateFromCommatext(TrackDefinitions[i]);
    with lvTracktypes.items.add do
    begin
      caption := inttostr(i);
      Data := pointer(TD.RunSoundIndex);
      subitems.add(TD.objectfilename);
      subitems.add(cbRunSound.Items[TD.RunSoundIndex]);
      subitems.add(TD.GetAsCommatext);
      subitems.add(TD.GetSwitchBasename());
      imageindex := -1;
      //subitems.add(inttostr(TD.CurveDefinitionCount));
    end;
    TD.free;
  end;
  CurrentCurvetrackitem := nil;
end;

procedure TFormTrackTypes.FormDestroy(Sender: TObject);
begin
  TrackDefinitions.Free;
end;

procedure TFormTrackTypes.lvTracktypesSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var i: integer;
    TD: TRBTrackDefinition;
begin
  //
  if selected then
  begin
    bDelTrackDef.Enabled := true;
    activeItem := item;
    leObjectName.Text := Item.SubItems[0];
    cbRunSound.ItemIndex := cbRunSound.items.IndexOf(Item.SubItems[1]);
    lvCurveTracks.Items.clear;
    leSw1.text := Item.Subitems[3];
    TD := TRBTrackDefinition.CreateFromCommatext(Item.SubItems[2]);
    for i:=0 to TD.CurveDefinitionCount-1 do
    begin
      with lvCurveTracks.items.add do
      begin
        caption := inttostr(TD.CurveDefinition[i].maxcurve);
        subitems.add(TD.CurveDefinition[i].objectfilename);
      end;
    end;
    TD.free;
    CurrentCurvetrackitem := nil;
  end
  else
  begin
    bDelTrackDef.Enabled := false;
    CurrentCurvetrackitem := nil;
  end;
  SetActiveIcon();
end;

procedure TFormTrackTypes.lvCurveTracksSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  CurrentCurvetrackitem := Item;
  if selected then
  begin
    leObjectfileCurved.Text := Item.subitems[0];
    leMaxCurveUse.text := Item.caption;
  end;
end;

procedure TFormTrackTypes.bSelectObjectfilenameStraightClick(
  Sender: TObject);
begin
  FormSelectObject.SetFolder('tracks');
  if FormSelectObject.ShowModal()=mrOK then
  begin
     leObjectname.Text := FormSelectObject.selected;
     if activeItem<>nil then
       activeItem.subitems[0] := leObjectname.Text;
  end;
end;

procedure TFormTrackTypes.cbRunSoundChange(Sender: TObject);
begin
  if activeItem<>nil then
    activeItem.subitems[1] := cbRunSound.Text;
end;

procedure TFormTrackTypes.bSelectObjectfilenameCurvedClick(
  Sender: TObject);
begin
  FormSelectObject.SetFolder('tracks');
  if FormSelectObject.ShowModal()=mrOK then
  begin
     leObjectfilecurved.Text := FormSelectObject.selected;


  end;
end;

procedure TFormTrackTypes.bAddCurveDefClick(Sender: TObject);
begin
  if activeItem<>nil then
  begin
    activeItem.SubItems[2] := activeItem.SubItems[2]+','+leMaxCurveUse.Text
        +',"'+leObjectfileCurved.Text+'"';
    lvTracktypesSelectItem(self,activeItem,true);
  end;
end;

procedure TFormTrackTypes.Button1Click(Sender: TObject);
var i,j: integer;
    TD: TRBTrackDefinition;
    sl: TStringlist;
begin
  sl := TStringlist.create;
  TrackDefinitions.clear;
  for i:=0 to lvTracktypes.items.count-1 do
  begin
    TD := TRBTrackDefinition.create;
    TD.objectfilename := lvTracktypes.items[i].subitems[0];
    TD.switchbasename := lvTracktypes.items[i].subitems[3];
    TD.RunSoundIndex  := integer(lvTracktypes.Items[i].data);
    sl.commatext := lvTracktypes.items[i].subitems[2];
    // lösche erste beiden Einträge
    if sl.count>0 then sl.Delete(0);
    if sl.count>0 then sl.Delete(0);
    for j:=0 to (sl.count div 2)-1 do
    begin
      TD.AddCurveDefinition(strtointdef(sl[j*2],0),sl[j*2+1]);
    end;
    TrackDefinitions.Add(TD.GetAsCommatext);
  end;
  sl.free;

  TrackDefinitions.SaveToFile(extractfilepath(application.exename)+'\trackdef.dat');
  modalResult := mrOK;
end;

procedure TFormTrackTypes.Button2Click(Sender: TObject);
begin
  modalResult := mrCancel;
end;

procedure TFormTrackTypes.GetTrackDefinitionObjectfilenames(sl: TStrings);
var i: integer;
    TD: TRBTrackDefinition;
begin
  sl.clear;
  for i:=0 to TrackDefinitions.Count-1 do
  begin
    TD := TRBTrackDefinition.CreateFromCommatext(TrackDefinitions[i]);
    sl.add(inttostr(i)+'='+TD.objectfilename);
    TD.free;
  end;
end;




function TFormTrackTypes.GetTrackDefinitionObject(tracktype,curve: integer): string;
var TD: TRBTrackDefinition;
begin
  result := '';
  if tracktype>=TrackDefinitions.count then exit;
  TD := TRBTrackDefinition.CreateFromCommatext(TrackDefinitions[tracktype]);
  result := TD.GetObjectFilenameForCurve(curve);
  TD.free;
end;



function TFormTrackTypes.GetTrackDefinitionSwitchObject(tracktype: integer; _dir,_set: TSwitchDirection): string;
var TD: TRBTrackDefinition;
begin
  result := '';
  if tracktype>=TrackDefinitions.count then exit;
  TD := TRBTrackDefinition.CreateFromCommatext(TrackDefinitions[tracktype]);
  result := TD.GetObjectFilenameForSwitch(_dir,_set);
  TD.free;
end;

function TFormTrackTypes.GetTrackDefinitionSwitchBasefilename(tracktype: integer): string;
var TD: TRBTrackDefinition;
begin
  result := '';
  if tracktype>=TrackDefinitions.count then exit;
  TD := TRBTrackDefinition.CreateFromCommatext(TrackDefinitions[tracktype]);
  result := TD.GetSwitchBasename;
  TD.free;
end;

function TFormTrackTypes.GetTrackDefinitionRunsound(const trackobject: string): integer;
var TD: TRBTrackDefinition;
    tracktype: integer;
begin
  result := 0;
  tracktype := FindTrackObjectInDefinitions(trackobject);
  if tracktype<0 then exit;
  TD := TRBTrackDefinition.CreateFromCommatext(TrackDefinitions[tracktype]);
  result :=  TD.RunSoundIndex;
  TD.free;
end;

function TFormTrackTypes.FindTrackObjectInDefinitions(const trackobject: string): integer;
var i,j: integer;
    TD: TRBTrackDefinition;
begin
  for i:=0 to TrackDefinitions.count-1 do
  begin
    TD := TRBTrackDefinition.CreateFromCommatext(TrackDefinitions[i]);
    if ansilowercase(TD.objectfilename)=ansilowercase(trackobject) then
    begin
      result := i;
      TD.free;
      exit;
    end;
    for j:=0 to TD.CurveDefinitionCount-1 do
    begin
      if ansilowercase(TD.CurveDefinition[j].objectfilename)=ansilowercase(trackobject) then
      begin
        result := i;
        TD.free;
        exit;
      end;
    end;
    TD.free;
  end;
end;

procedure TFormTrackTypes.bSetCurveDefClick(Sender: TObject);
begin
  //
  if CurrentCurvetrackitem<>nil then
  begin
    CurrentCurvetrackitem.Caption := leMaxCurveUse.text;
    CurrentCurvetrackitem.SubItems[0] := leObjectfileCurved.text;
    CurveTracksToTrackTypes;
  end;
end;

procedure TFormTrackTypes.bDelCurveDefClick(Sender: TObject);
begin
  if lvCurveTracks.selected<>nil then
  begin
    lvCurveTracks.DeleteSelected;
    CurveTracksToTrackTypes();
  end;
end;

procedure TFormTrackTypes.bAddTrackDefClick(Sender: TObject);
begin
  if (leObjectName.text='')or(cbRunSound.Text='') then exit;
  with lvTracktypes.items.add do
  begin
    caption := inttostr(lvTracktypes.items.count-1);
    subitems.add(leObjectName.text);
    subitems.add(cbRunSound.Text);
    Data := pointer(cbRunSound.ItemIndex);
    subitems.add('"'+leObjectName.text+'",'+cbRunSound.Text);
    subitems.add(leSW1.text);
  end;
  activeItem := lvTracktypes.items[lvTracktypes.items.count-1];
  SetActiveIcon();  
end;

procedure TFormTrackTypes.bDelTrackDefClick(Sender: TObject);
begin
  if lvTracktypes.Selected<>nil then
  begin
    lvTracktypes.DeleteSelected;
    activeItem := nil;
    SetActiveIcon();
  end;
end;

procedure TFormTrackTypes.SetActiveIcon;
var i:integer;
begin
  for i:=0 to lvTracktypes.items.count-1 do
  begin
    if lvTracktypes.items[i]=activeItem then
      lvTracktypes.items[i].ImageIndex := 0
    else
      lvTracktypes.items[i].ImageIndex := -1;
  end;
end;

procedure TFormTrackTypes.CurveTracksToTrackTypes;
var i: integer;
begin
  if (activeItem<>nil) then
  begin
    activeItem.SubItems[2] := '"'+activeItem.SubItems[0]+'",'+inttostr(cbRunSound.ItemIndex);
    for i:=0 to lvCurveTracks.Items.count-1 do
    begin
       activeItem.SubItems[2] :=activeItem.SubItems[2]
         + ','+lvCurveTracks.Items[i].caption + ',"' + lvCurveTracks.Items[i].subitems[0]+'"';
    end;
  end;


end;

procedure TFormTrackTypes.bSelectSwitchObjectClick(Sender: TObject);
begin
  FormSelectObject.SetFolder('tracks');
  if FormSelectObject.ShowModal()=mrOK then
  begin
     leSw1.Text := FormSelectObject.selected;
     // abschneiden der Endung (xx.b3d)
     leSw1.Text := copy(leSw1.Text,1,length(leSw1.Text)-6);

     if activeItem<>nil then
       activeItem.subitems[3] := leSw1.Text;
  end;
end;

procedure TFormTrackTypes.bCurvesAutoClick(Sender: TObject);
var i,j:integer;
    radien: array of double;
    s: string;
    r: double;

function ExtractRadiusFromFilename(const fn: string): double;
var j,k: integer;
    f: string;
begin
  k := pos('.',fn);
  if k>0 then f := copy(fn,1,k-1) else f := fn;
  k := pos('_overhead',f);
  if k>0 then f := copy(f,1,k-1);
  j := length(f);
  while pos(f[j],'1234567890-')>0 do dec(j);
  f := copy(f,j+1,999);
  result := strtofloat1(f);
end;

begin
  setlength(radien,lvCurveTracks.Items.Count);
  for i:=0 to lvCurveTracks.Items.Count-1 do
  begin
    s := lvCurveTracks.Items[i].SubItems[0];
    r := ExtractRadiusFromFilename(s);
    radien[i] := r;
  end;
  // suche für jeden Radius den betragsmäßig nächst höheren
  for i:=0 to lvCurveTracks.Items.Count-1 do
  if radien[i]<>0 then
  begin
    r:=2000;
    for j:=0 to lvCurveTracks.Items.Count-1 do
    begin
      if (abs(radien[j])>abs(radien[i])) and (sgn(radien[j])=sgn(radien[i])) then
      begin
        if r-abs(radien[i]) > abs(radien[j])-abs(radien[i]) then
        begin
          r := abs(radien[j]);
        end;
      end;
    end;
    r := sgn(radien[i])*(r + abs(radien[i]))/2;
    lvCurveTracks.items[i].Caption := inttostr(round(r));
    CurveTracksToTrackTypes;
  end;
end;

procedure TFormTrackTypes.FormShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  if msg.CharCode=27 then close;
end;

end.
