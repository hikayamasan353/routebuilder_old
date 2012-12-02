unit uRouteDefinitionsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Buttons, ExtCtrls, ComCtrls,
  uRBRouteDefinition, uCurrentSituation, uRBproject, utools;

resourcestring
  cNewRouteDefinition = 'Route Definition';
  cClonedRouteDefinition = 'Copy of ';

type
  TFormRouteDefinitions = class(TForm)
    ListView1: TListView;
    Panel1: TPanel;
    bAddRoute: TSpeedButton;
    bDeleteRoute: TSpeedButton;
    bActivate: TSpeedButton;
    ImageList1: TImageList;
    bMerge: TSpeedButton;
    bClone: TSpeedButton;
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure bActivateClick(Sender: TObject);
    procedure bAddRouteClick(Sender: TObject);
    procedure bDeleteRouteClick(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1Edited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure ListView1Editing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure bMergeClick(Sender: TObject);
    procedure bCloneClick(Sender: TObject);
  private
    { Private declarations }
    CopyFrom: TRBRouteDefinition;
  public
    { Public declarations }
    CurrentProject : TRBProject;
  end;

var
  FormRouteDefinitions: TFormRouteDefinitions;

implementation

{$R *.dfm}

procedure TFormRouteDefinitions.FormShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  if Msg.CharCode=13 then bActivateClick(self);
  
end;

procedure TFormRouteDefinitions.bActivateClick(Sender: TObject);
var li: TListitem;
    i: integer;
begin
  li := Listview1.Selected;
  if li=nil then exit;
  // alle Einträge deselektieren
  for i:=0 to listview1.items.count-1 do
    Listview1.items[i].ImageIndex := -1;
  // gewählten Eintrag selektieren (ImageIndex 0)
  li.ImageIndex := 0;
  Currentsituation.CurrentRouteDefinition := TRBRouteDefinition(li.data);
  // Editor bitten, sich neu zu zeichnen
  CurrentSituation.PleaseUpdateView := true;
end;

procedure TFormRouteDefinitions.bAddRouteClick(Sender: TObject);
begin
  with Listview1.items.add do
  begin
    caption := cNewRouteDefinition;
    EditCaption();
  end;
end;

procedure TFormRouteDefinitions.bDeleteRouteClick(Sender: TObject);
begin
// todo: aus CurrentProject.Routes löschen und aus Listview löschen
end;

procedure TFormRouteDefinitions.ListView1Click(Sender: TObject);
begin
  bDeleteRoute.enabled := (Listview1.ItemIndex>=0);
  bActivate.enabled    := (Listview1.ItemIndex>=0);
  bClone.Enabled       := (Listview1.ItemIndex>=0);
end;

procedure TFormRouteDefinitions.FormShow(Sender: TObject);
var i: integer;
    RD: TRBRouteDefinition;
begin
  Listview1.items.clear;
  for i :=0 to CurrentProject.Routes.count-1 do
  begin
    RD := CurrentProject.Routes[i] as TRBRouteDefinition;
    with Listview1.items.Add do
    begin
      caption := RD.GetTitle();
      Data := pointer(RD);
      if RD.RouteDefinitionID=Currentsituation.CurrentRouteDefinitionID then
        imageindex := 0
      else
        imageindex := -1;
    end;
  end;
end;

procedure TFormRouteDefinitions.ListView1Edited(Sender: TObject;
  Item: TListItem; var S: String);
var id,i: integer;
    RD: TRBRouteDefinition;
begin
  if Item.caption = cNewRouteDefinition then
  begin
    // neue ID ermitteln
    id := CurrentProject.GetMaxRouteDefinitionID+1;
    RD := TRBRouteDefinition.Create;
    RD.RouteDefinitionID   := id;
    RD.RouteDefinitionname := S;
    S:= RD.GetTitle();
    CurrentProject.Routes.add(RD);
    ListView1.Selected := Item;
    Item.Data := pointer(RD);
    bActivateClick(self);
  end
  else
  if copy(Item.caption ,1,length(cClonedRouteDefinition))= cClonedRouteDefinition then
  begin
    // neue ID ermitteln
    id := CurrentProject.GetMaxRouteDefinitionID+1;
    RD := TRBRouteDefinition.Create;
    RD.RouteDefinitionID   := id;
    RD.RouteDefinitionname := S;
    if CopyFrom<>nil then
      RD.AddStrings(CopyFrom);
    S:= RD.GetTitle();
    CurrentProject.Routes.add(RD);
    ListView1.Selected := Item;
    Item.Data := pointer(RD);
    bActivateClick(self);
  end
  else
  begin
    // rename
    RD := CurrentProject.FindRouteDefinitionByID(TRBRouteDefinition(item.data).RouteDefinitionID );
    RD.RouteDefinitionname := S;
//    S := RD.GetTitle();
  end;
end;

procedure TFormRouteDefinitions.ListView1Editing(Sender: TObject;
  Item: TListItem; var AllowEdit: Boolean);
begin
  // todo: vorbereiten der Änderung des Namens
  //AllowEdit := false;
end;

procedure TFormRouteDefinitions.bMergeClick(Sender: TObject);
var id,i,sel1,sel2: integer;
    RD,RD1: TRBRouteDefinition;
    S : string;
begin
  sel1 := -1; sel2 := -1;
  for i:=0 to listview1.items.count-1 do
    if Listview1.items[i].ImageIndex = 0 then sel1 := i;
  sel2 := Listview1.Selected.Index;

  if (sel1=sel2)or(sel1=-1)or(sel2=-1) then
  begin
    MessageDlg(lngmsg.GetMsg('urdform_merge'), mtError, [mbCancel], 0);
    exit;
  end;
  // neue ID ermitteln
  id := CurrentProject.GetMaxRouteDefinitionID+1;
  RD := TRBRouteDefinition.Create;
  RD.RouteDefinitionID   := id;
  RD.RouteDefinitionname := 'merged routes';
  S:= RD.GetTitle();
  CurrentProject.Routes.add(RD);

  RD1 := CurrentProject.FindRouteDefinitionByID(TRBRouteDefinition(listview1.Items[sel1].data).RouteDefinitionID );

  for i:=0 to RD1.count-1 do
  begin
    RD.AddTrack(RD1.GetConnIDAt(i));
  end;

  RD1 := CurrentProject.FindRouteDefinitionByID(TRBRouteDefinition(listview1.Items[sel2].data).RouteDefinitionID );

  for i:=0 to RD1.count-1 do
  begin
    RD.AddTrack(RD1.GetConnIDAt(i));
  end;

  with Listview1.items.add do
  begin
    caption := S;
    data := pointer(RD);
    imageindex := -1;
  end;
end;

procedure TFormRouteDefinitions.bCloneClick(Sender: TObject);
begin
  with Listview1.items.add do
  begin
    caption := cClonedRouteDefinition + Listview1.selected.caption;
    copyfrom := Listview1.selected.data;
    EditCaption();
  end;
end;

end.
