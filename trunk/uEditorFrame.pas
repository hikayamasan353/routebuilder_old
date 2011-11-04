unit uEditorFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, jpeg, math, ContNrs,
  ComCtrls, ToolWin, ImgList, Menus,
  uRBPoint, uRBConnection, uRBWallList,
  tOptions,
  uRBProject,
  uRBObject,
  uRBStation,
  uTrackProperties,
  uGlobalDef,
  uCurrentSituation,
  uRouteDefinitionsForm,
  uStationsForm,
  uRBMiniMap,
  uBGMapForm,
  uRBSignal,
  uRBSignalsForm,
  uNewBGImageForm,
  uPointHeightForm,
  uRBConnectionlist,
  uRBGrid,
  uTools, RsRuler, DXDraws;


resourcestring
  RadiusRouteTypeFlat = 'flat land (>500m)';
  RadiusRouteTypeHills = 'hills (>300m)';
  RadiusRouteTypeMountains = 'mountains (>180m)';
  RadiusRouteTypeTram = 'tram (<180m)';

const cMinTrackLength = 25;

type
  TFrmEditor = class(TFrame)
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    PopupMenu1: TPopupMenu;
    properties1: TMenuItem;
    copyproperties1: TMenuItem;
    pasteproperties1: TMenuItem;
    Timer1: TTimer;
    N3: TMenuItem;
    PopupMenuaddtocurrentroute: TMenuItem;
    PopupMenudeletefromcurrentroute: TMenuItem;
    ToolBar3: TToolBar;
    ToolButton5: TToolButton;
    tbObjects: TToolButton;
    tbTrains: TToolButton;
    PanelMainEditor: TPanel;
    BgImageEditor: TImage;
    ScrollBarHor: TScrollBar;
    ScrollBarVert: TScrollBar;
    PBCursor: TPaintBox;
    bStations: TToolButton;
    PanMap: TPanel;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    PanelMapBottom: TPanel;
    Splitter1: TSplitter;
    CoolBar1: TCoolBar;
    tbMapZoom: TTrackBar;
    ToolBar4: TToolBar;
    ImageList2: TImageList;
    tbBGImage: TToolButton;
    EdMapCoord: TEdit;
    PaintBox1: TPaintBox;
    PanMainBottom: TPanel;
    tbZoom: TTrackBar;
    lZoom: TLabel;
    Label1: TLabel;
    cbGotoStation: TComboBox;
    Label3: TLabel;
    lCursorpos: TLabel;
    CoolBar2: TCoolBar;
    tbNewPoint: TToolButton;
    tbMap1: TToolButton;
    N5: TMenuItem;
    addpoint1: TMenuItem;
    tbConnectPoints: TToolButton;
    connectpoints1: TMenuItem;
    deletepoint1: TMenuItem;
    deleteconnection1: TMenuItem;
    addnewpointandconnect1: TMenuItem;
    tbAddAndConnect: TToolButton;
    addtocurrentrouteuntilswitch1: TMenuItem;
    pastepropertiestocurrentroute1: TMenuItem;
    ProgressBar1: TProgressBar;
    lCurrentProgress: TLabel;
    tbProperties: TToolButton;
    pastepropertiesuntilswitch1: TMenuItem;
    lThisTrack: TLabel;
    addselectedobject1: TMenuItem;
    tbDelPoint: TToolButton;
    tbAddObj: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    tbDelObj: TToolButton;
    tbObjProperties: TToolButton;
    N4: TMenuItem;
    objectproperties1: TMenuItem;
    deleteobject1: TMenuItem;
    allproperties1: TMenuItem;
    groundonly1: TMenuItem;
    backgroundonly1: TMenuItem;
    speedlimit1: TMenuItem;
    poles1: TMenuItem;
    allproperties2: TMenuItem;
    ground1: TMenuItem;
    background1: TMenuItem;
    speedlimit2: TMenuItem;
    poles2: TMenuItem;
    allproperties3: TMenuItem;
    ground2: TMenuItem;
    background2: TMenuItem;
    speedlimit3: TMenuItem;
    poles3: TMenuItem;
    tracktype1: TMenuItem;
    tracktype2: TMenuItem;
    tracktype3: TMenuItem;
    lPDist: TLabel;
    cloneobject1: TMenuItem;
    tbImproveConnection: TToolButton;
    lLeft: TLabel;
    lRight: TLabel;
    lDown: TLabel;
    lUp: TLabel;
    specialtrack1: TMenuItem;
    curve1: TMenuItem;
    straight1: TMenuItem;
    fixed1: TMenuItem;
    ToolButton1: TToolButton;
    tbSel1: TToolButton;
    tbSel2: TToolButton;
    N2: TMenuItem;
    SelectionAreaPoint11: TMenuItem;
    SelectionAreaPoint21: TMenuItem;
    turntrack1: TMenuItem;
    cbTrackType: TComboBoxEx;
    ImageListTrackTypes: TImageList;
    make25mlong1: TMenuItem;
    ToolButton2: TToolButton;
    tbGrids: TToolButton;
    RsRulerTop: TRsRuler;
    RsRulerLeft: TRsRuler;
    RsRulerCorner1: TRsRulerCorner;
    PanelTop: TPanel;
    PanelLeft: TPanel;
    addtogrid1: TMenuItem;
    deletefromgrid1: TMenuItem;
    tbTracks: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    tb3DWorld: TToolButton;
    tbSignals: TToolButton;
    height1: TMenuItem;
    accuracy1: TMenuItem;
    fog1: TMenuItem;
    adhesion1: TMenuItem;
    SO1: TMenuItem;
    walls1: TMenuItem;
    SO2: TMenuItem;
    walls2: TMenuItem;
    SO3: TMenuItem;
    walls3: TMenuItem;
    tbPointHeight: TTrackBar;
    lPointHeight: TLabel;
    EditDummy: TEdit;
    smoothslope1: TMenuItem;
    procedure PBCursorPaint(Sender: TObject);
    procedure ScrollBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure properties1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PopupMenuchangeswitchposition1Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure PopupMenuaddtocurrentrouteClick(Sender: TObject);
    procedure PopupMenudeletefromcurrentrouteClick(Sender: TObject);
    procedure tbObjectsClick(Sender: TObject);
    procedure tbTrainsClick(Sender: TObject);
    procedure PBCursorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PBCursorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bStationsClick(Sender: TObject);
    procedure setminimapbackgroundimage1Click(Sender: TObject);
    procedure tbZoomChange(Sender: TObject);
    procedure tbMapClick(Sender: TObject);
    procedure tbMapZoomChange(Sender: TObject);
    procedure SetMap();
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure ScrollBox1Resize(Sender: TObject);
    procedure tbNewPointClick(Sender: TObject);
    procedure connectpoints1Click(Sender: TObject);
    procedure tbImproveConnectionClick(Sender: TObject);
    procedure addpoint1Click(Sender: TObject);
    procedure addnewpointandconnect1Click(Sender: TObject);
    procedure tbAddAndConnectClick(Sender: TObject);
    procedure tbImproveClick(Sender: TObject);
    procedure deletepoint1Click(Sender: TObject);
    procedure deleteconnection1Click(Sender: TObject);
    procedure addtocurrentrouteuntilswitch1Click(Sender: TObject);
    procedure copyproperties1Click(Sender: TObject);
    procedure pasteproperties1Click(Sender: TObject);
    procedure pastepropertiestocurrentroute1Click(Sender: TObject);
    procedure cbGotoStationChange(Sender: TObject);
    procedure pastepropertiesuntilswitch1Click(Sender: TObject);
    procedure addselectedobject1Click(Sender: TObject);
    procedure tbDelPointClick(Sender: TObject);
    procedure tbAddObjClick(Sender: TObject);
    procedure straight1Click(Sender: TObject);
    procedure curve1Click(Sender: TObject);
    procedure deleteobject1Click(Sender: TObject);
    procedure objectproperties1Click(Sender: TObject);
    procedure PBCursorDblClick(Sender: TObject);
    procedure ground1Click(Sender: TObject);
    procedure allproperties3Click(Sender: TObject);
    procedure ground2Click(Sender: TObject);
    procedure background2Click(Sender: TObject);
    procedure speedlimit3Click(Sender: TObject);
    procedure poles3Click(Sender: TObject);
    procedure tracktype1Click(Sender: TObject);
    procedure allproperties1Click(Sender: TObject);
    procedure groundonly1Click(Sender: TObject);
    procedure backgroundonly1Click(Sender: TObject);
    procedure speedlimit1Click(Sender: TObject);
    procedure poles1Click(Sender: TObject);
    procedure tracktype2Click(Sender: TObject);
    procedure allproperties2Click(Sender: TObject);
    procedure background1Click(Sender: TObject);
    procedure speedlimit2Click(Sender: TObject);
    procedure poles2Click(Sender: TObject);
    procedure tracktype3Click(Sender: TObject);
    procedure cloneobject1Click(Sender: TObject);
    procedure lDownClick(Sender: TObject);
    procedure lUpClick(Sender: TObject);
    procedure lLeftClick(Sender: TObject);
    procedure lRightClick(Sender: TObject);
    procedure fixed1Click(Sender: TObject);
    procedure SelectionAreaPoint11Click(Sender: TObject);
    procedure SelectionAreaPoint21Click(Sender: TObject);
    procedure tbTrackTypeSwitchStraightClick(Sender: TObject);
    procedure tbTrackTypeSwitchCurvedClick(Sender: TObject);
    procedure turntrack1Click(Sender: TObject);
    procedure cbTrackTypeChange(Sender: TObject);
    procedure make25mlong1Click(Sender: TObject);
    procedure tbGridsClick(Sender: TObject);
    procedure ScrollBarVertScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure ScrollBarHorScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure addtogrid1Click(Sender: TObject);
    procedure deletefromgrid1Click(Sender: TObject);
    procedure tbTracksClick(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure tb3DWorldClick(Sender: TObject);
    procedure tbSignalsClick(Sender: TObject);
    procedure height1Click(Sender: TObject);
    procedure accuracy1Click(Sender: TObject);
    procedure fog1Click(Sender: TObject);
    procedure adhesion1Click(Sender: TObject);
    procedure SO1Click(Sender: TObject);
    procedure walls1Click(Sender: TObject);
    procedure SO2Click(Sender: TObject);
    procedure walls2Click(Sender: TObject);
    procedure SO3Click(Sender: TObject);
    procedure walls3Click(Sender: TObject);
    procedure tbPointHeightChange(Sender: TObject);
    procedure lPointHeightClick(Sender: TObject);
    procedure smoothslope1Click(Sender: TObject);
  private
    { Private declarations }
    dragging,wasdragging,ClickOnly: boolean;
    draggingPoint: TRBPoint;
    draggingObject: TRBObject;
    objhotoffx,
    objhotoffy,
    oldx,oldy,
    oldalpha,
    turnalpha,
    ClickOnlyCounter: integer;
    newpoint: TDoublePoint;
    PropertiesToPaste: TPropertiestopaste;
    TrackPropertiesCopy: TRBConnection;
    procedure FitPoint();
    procedure ConnMinLength();
    procedure SetScrollbars();
  public
    { Public declarations }
    CurrentProject: TRBProject;
    ArrowStepSize : double;
    MouseOverEffectCanvas: TCanvas;
//    CursorXPosition: double; // in m
//    CursorZPosition: double; // in m
    ScrollboxXOffset: integer; // in Pixeln. Differenz zwischen Pixelsystem und Bildschirmsystem
    ScrollboxYOffset: integer;
    MapScale: TJPEGScale;
    UndoAction: array of TRBActionItem;
    UndoCount: integer;
    procedure SetTrackTypeButtons();
    procedure AddUndoAction(Aaction: TRBAction; Aobj1,Aobj2: TObject; Apoint: TDoublePoint; AMore: integer=0);
    procedure Undo();
    procedure PaintPoint(canvas: TCanvas; p: TRBPoint);
    procedure PaintPoints(canvas: TCanvas);
    procedure PaintFreeObjects(canvas: TCanvas);
    procedure PaintObject(canvas: TCanvas; o: TRBObject; frameColor: TColor=FreeObjColor; differentLength: integer=0; delframe: boolean=false);
    procedure PaintTSO(canvas: TCanvas; conn: TRBConnection; walllist: TRBWallList);
    procedure paintSelArea(canvas: TCanvas);
    procedure PaintBlackArea(can: TCanvas);
    procedure PaintOneSegment(canvas: TCanvas; IsInCurrentRouteDefinition, IsCurrentConnection, IsInStation, HasPlatform, DrawCrossTies: boolean; segx,segy: integer; len,sina,cosa: double);
    procedure PaintConnections(canvas: TCanvas);
    procedure PaintConnectionsSolid(surface: TDirectDrawSurface);
    procedure PaintGridItemOutline(canvas: TCanvas; grid: TRBGrid; x,z: integer; rootpoint,gridconst: TDoublePoint);
    procedure PaintActiveGridItem(canvas: TCanvas);
    procedure PaintConnection(canvas: TCanvas; conn: TRBConnection; p1,p2: TPoint; IsInCurrentRouteDefinition: boolean; length: double=0; walllist: TRBWallList=nil);
    procedure PaintConnectionSolid(surface: TDirectDrawSurface; conn: TRBConnection; p1,p2: TPoint; IsInCurrentRouteDefinition: boolean; length: double=0; walllist: TRBWallList=nil);
    procedure PaintCursor(canvas: TCanvas);
    procedure UpdateView(sender: TObject=nil; repaint: boolean=true);
    procedure MapToWorld(x,y: integer; var pworld: TDoublePoint);
    procedure LoadProject(const fn: string);
    procedure ImproveConnection(l:double; anz: integer);
    procedure SetProgress(min,max,value: integer);
    procedure ApplyConnAppearance(conn: TRBConnection);
  end;



implementation

uses uObjectsForm, ttrain, uFreeObjectPropertiesForm, uRBGridsForm,
  uGridTracks, ttimetable, uRB3DPreviewForm, tmain;

{$R *.dfm}

procedure TFrmEditor.LoadProject(const fn: string);
begin
  Screen.Cursor := crHourglass;
  CurrentProject.LoadFromFile(fn,PanelMainEditor);
  Screen.Cursor := crDefault;
  tbMapZoom.Position := tbMapZoom.Max;
  tbZoom.position := tbZoom.Min;
  PanMap.visible := (CurrentProject.BackgroundMapfilename<>'')and(fileexists(CurrentProject.BackgroundMapfilename));
  if PanMap.Visible then SetMap();
  TrackPropertiesCopy := nil;
  Currentsituation.CurrentGrid:=nil;
  Currentsituation.CurrentPoint := nil;
  Currentsituation.CurrentConnection := nil;
  updateview();
  if cbGotoStation.Items.count>0 then
  begin
    cbGotoStation.ItemIndex := 0;
    cbGotoStationChange(self);
  end;
  SetLength( UndoAction,0);
  UndoCount := 0;
end;

procedure TFrmEditor.PaintBlackArea(can: TCanvas);
var pix: TPoint;
    p0: TDoublePoint;
    re: TRect;
begin
  with can Do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clBlack;
    p0.x := 0;
    p0.Y := 0;
    ConvertCoordWorldToPixel(p0,
       point(PBCursor.Width div 2,PBCursor.height div 2),
       Currentsituation.Offset,
       Currentsituation.Zoom,pix);
    // left black
    re.left := 0;
    re.top := 0;
    re.Right := pix.X;
    re.bottom := PBCursor.Height;
    if pix.X>0 then FillRect(re);
    // bottom black
    re.left := 0;
    re.top := pix.Y;
    re.Right := PBCursor.width;
    re.bottom := PBCursor.Height;
    if (pix.y>0)and(pix.y<PBCursor.height) then FillRect(re);
  end;
end;


// Funktion: PBCursorPaint
// Autor   : u
// Datum   :
// Beschr. : zeichnet das Sichtfenster.
procedure TFrmEditor.PBCursorPaint(Sender: TObject);
begin
  // Done by DirectX!

  exit;

  PaintBlackArea(PBCursor.Canvas);
  paintConnections(PBCursor.Canvas);
  paintPoints(PBCursor.Canvas);
  paintFreeObjects(PBCursor.Canvas);
  paintSelArea(PBCursor.Canvas);
  paintCursor(PBCursor.Canvas);
  paintActiveGridItem(PBCursor.Canvas);
  // Cursorkreuz
  {with PBCursor.Canvas Do
  begin
    Pen.width := 1;
    Pen.color := clWhite;
    MoveTo(0,PBCursor.Height div 2);
    Lineto(ClientWidth-1,PBCursor.Height div 2);
    MoveTo(PBCursor.Width div 2,0);
    LineTo(PBCursor.Width div 2,ClientHeight-1);
  end;      }
end;

procedure TFrmEditor.PaintOneSegment(canvas: TCanvas; IsInCurrentRouteDefinition, IsCurrentConnection, IsInStation, HasPlatform, DrawCrossTies: boolean; segx,segy: integer; len,sina,cosa: double);
var xs,ys: integer;
    scale: double;
begin
  scale :=  CurrentSituation.zoom / PixelPerMeter;
  with Canvas do
  begin
    if DrawCrossTies then
    begin
      // Schwellen
      Pen.Color := CrossTieColor; // braun
      Pen.Width := 2;
      MoveTo(round(segx-CrossTieLength*scale*cosa/2),round(segy-CrossTieLength*scale*sina/2));
      LineTo(round(segx+CrossTieLength*scale*cosa/2),round(segy+CrossTieLength*scale*sina/2));
    end;
    // Schienen
    if IsCurrentConnection then
      Pen.Color := TrackColorCurrent
    else if IsInStation then
      Pen.Color := trackcolorStation
    else if IsInCurrentRouteDefinition then
      Pen.Color := TrackColorRoute
    else
      Pen.Color := TrackColorTrack;
    Pen.width := 1;
    Pen.Style := psSolid;
    // links
    xs := round(segx-RailGaugePix*scale*cosa/2 - scale*len*sina/2 );
    ys := round(segy-RailGaugePix*scale*sina/2 + scale*len*cosa/2 );
    MoveTo(xs,ys);
    xs := round(segx-RailGaugePix*scale*cosa/2 + len*scale*sina/2 );
    ys := round(segy-RailGaugePix*scale*sina/2 - len*scale*cosa/2 );
    LineTo(xs,ys);
    // rechts
    xs := round(segx+RailGaugePix*scale*cosa/2 - len*scale*sina/2 );
    ys := round(segy+RailGaugePix*scale*sina/2 + len*scale*cosa/2 );
    MoveTo(xs,ys);
    xs := round(segx+RailGaugePix*scale*cosa/2 + len*scale*sina/2 );
    ys := round(segy+RailGaugePix*scale*sina/2 - len*scale*cosa/2 );
    LineTo(xs,ys);
  end;
end;

procedure TFrmEditor.PaintGridItemOutline(canvas: TCanvas; grid: TRBGrid; x,z: integer; rootpoint,gridconst: TDoublePoint);
var gp: TDoublePoint;
    pp1,pp2: TPoint;
begin
  with Canvas do
  begin
    gp := grid.GetGridPoint(x-0.5,z+1,rootpoint,gridconst);
    ConvertCoordWorldToPixel(gp,
     point(PBCursor.Width div 2,PBCursor.height div 2),
     Currentsituation.Offset,
     Currentsituation.Zoom,pp1);
    moveto(pp1.x,pp1.y);
    gp := grid.GetGridPoint(x-0.5,z,rootpoint,gridconst);
    ConvertCoordWorldToPixel(gp,
     point(PBCursor.Width div 2,PBCursor.height div 2),
     Currentsituation.Offset,
     Currentsituation.Zoom,pp1);
    lineto(pp1.x,pp1.Y);
    gp := grid.GetGridPoint(x+0.5,z,rootpoint,gridconst);
    ConvertCoordWorldToPixel(gp,
     point(PBCursor.Width div 2,PBCursor.height div 2),
     Currentsituation.Offset,
     Currentsituation.Zoom,pp2);
    lineto(pp2.x,pp2.y);
    gp := grid.GetGridPoint(x+0.5,z+1,rootpoint,gridconst);
    ConvertCoordWorldToPixel(gp,
     point(PBCursor.Width div 2,PBCursor.height div 2),
     Currentsituation.Offset,
     Currentsituation.Zoom,pp2);
    lineto(pp2.x,pp2.y);
//    lineto(pp1.x,pp1.y);
  end;
end;

procedure TFrmEditor.PaintConnection(canvas: TCanvas; conn: TRBConnection; p1,p2: TPoint; IsInCurrentRouteDefinition: boolean; length: double; walllist: TRBWallList);
var ps,pp1,pp2,pp3,pp4,p3,p4: TPoint;
    c,l,sina,cosa,scale,a,dxfak: double;
    j,len,seganz,xs,ys,x,z: integer;
    points: array[0..3] of TPoint;
    grid: TRBGrid;
    griditem: TRBGridItem;
    signal: TRBSignal;
    Gridconst,gp,v1,v2: TDoublepoint;
    root: TRBConnection;

     procedure SwitchExtraDraw(canvas: TCanvas);
     begin
        if conn.special in [csSwitchLeftUpCurve,csSwitchRightUpCurve,
                            csSwitchLeftUpStraight,csSwitchRightUpStraight] then
        begin
          // up-Weichen (p1 ist definiert als unterer Punkt)
          // ermitteln von p3 - gemeinsamer Punkt
          p3 := p1;
          p4 := p2;
          // ermitteln von p4 - abzweigender Punkt
          len := Intdistance(p1,p2);
          if len=0 then exit;
          // rechts
          if conn.special in [csSwitchRightupStraight,
                              csSwitchLeftupCurve] then
            a := (-4.6+conn.GetAngle(nil))
          else
            a := (4.6+conn.GetAngle(nil));
          cosa := cos(a*pi/180);
          sina := sin(a*pi/180);

          p4.x := round(p3.x+CurrentSituation.zoom*cosa*25);
          p4.y := round(p3.y-CurrentSituation.zoom*sina*25);

          canvas.Pen.width := 1;
          canvas.Pen.style := psDot;
          canvas.MoveTo(p3.x,p3.y);
          canvas.LineTo(p4.x,p4.y);
        end;
    end;

    procedure CalcCurveCenter(right: boolean; _p1,_p2: TPoint; var _p3: TPoint);
    var _v1: TPoint;
    begin
      // Kurve
      // Mittelpunkt
      _v1.x := _p2.x-_p1.x;
      _v1.y := _p2.y-_p1.y;
      if right then
      begin
        _p3.x := round((_v1.X / 2 + _v1.y / 50) + _p1.x);
        _p3.y := round((_v1.y / 2 - _v1.x / 50) + _p1.y);
      end
      else
      begin
        _p3.x := round((_v1.X / 2 - _v1.y / 50) + _p1.x);
        _p3.y := round((_v1.y / 2 + _v1.x / 50) + _p1.y);
      end;
    end;

begin
  with canvas do
  begin
    if length=0 then
      l := conn.GetLength()
    else
      l := length;

   if l=0 then exit;

    if FormOptions.GetTSOAsFrames then
    begin
      // Paint TSO
      PaintTSO(canvas,conn,walllist);
    end
    else
    begin
      // Wand links
      if (conn.WallLeft<>'')or(conn.TSOLeft<>'') then
      begin
        pp1.x := p1.X + round(WallDistance*(p2.y-p1.y)/l);
        pp2.x := p2.X + round(WallDistance*(p2.y-p1.y)/l);
        pp1.y := p1.y - round(WallDistance*(p2.x-p1.x)/l);
        pp2.y := p2.y - round(WallDistance*(p2.x-p1.x)/l);
        Pen.width := 3;
        Pen.Color := clSilver;
        MoveTo(pp1.x,pp1.y);
        LineTo(pp2.x,pp2.y);
      end;
      // Wand rechts
      if (conn.WallRight<>'')or(conn.TSORight<>'') then
      begin
        pp1.x := p1.X - round(WallDistance*(p2.y-p1.y)/l);
        pp2.x := p2.X - round(WallDistance*(p2.y-p1.y)/l);
        pp1.y := p1.y + round(WallDistance*(p2.x-p1.x)/l);
        pp2.y := p2.y + round(WallDistance*(p2.x-p1.x)/l);
        Pen.width := 3;
        Pen.Color := clSilver;
        MoveTo(pp1.x,pp1.y);
        LineTo(pp2.x,pp2.y);
      end;
    end;

    // grid
    grid := CurrentProject.GetConnectionParentGrid(conn.id);
  //    if Currentsituation.Zoom<7 then
    begin
      Pen.style := psSolid;

      if CurrentProject.GetStationByTrackID(conn.id)<>nil then
        Pen.Color := TrackColorStation
      else
      if Currentsituation.CurrentConnection=conn then
        Pen.color := TrackColorCurrent
      else
      if IsInCurrentRouteDefinition then
        Pen.color := TrackColorRoute
      else
      if (grid<>nil)and(grid.RootConnection=conn.id) then
        Pen.color := TrackColorGridRoot
      else
        Pen.color := TrackColor;
      if not (conn.special in [csStraight,csCurve]) then
        Pen.width := 3
      else
        Pen.width := 1;
//      if CurrentSituation.Zoom<FormOptions.GetMinZoomSolid() then
//      begin
        MoveTo(p1.x,p1.y);
        if not (conn.special in [csStraight,csFixed,csSwitchLeftUpStraight,csSwitchRightUpStraight]) then
        begin
          CalcCurveCenter(conn.special in [csFixedCurveRight,csSwitchRightUpCurve],p1,p2,p3);
          LineTo(p3.x,p3.y);
        end;
        LineTo(p2.x,p2.y);
        // Weichen-Zeichnung
        SwitchExtraDraw(canvas);
//      end;
      {else
      begin

        // 2 Schienen
        len := Intdistance(p1,p2);
        if len=0 then exit;

        sina := (p2.X-p1.x)/len;
        cosa := (p1.Y-p2.y)/len;
        scale :=  CurrentSituation.zoom / PixelPerMeter;
        // links
        pp1.x := round(p1.x-RailGaugePix*scale*cosa/2);
        pp1.y := round(p1.y-RailGaugePix*scale*sina/2);
        pp2.x := round(p2.x-RailGaugePix*scale*cosa/2);
        pp2.y := round(p2.y-RailGaugePix*scale*sina/2);
        MoveTo(pp1.x,pp1.y);
        if not (conn.special in [csStraight,csFixed,csSwitchLeftUpStraight,csSwitchRightUpStraight]) then
        begin
          CalcCurveCenter(conn.special in [csFixedCurveRight,csSwitchRightUpCurve],pp1,pp2,pp3);
          LineTo(pp3.x,pp3.y);
        end;
        LineTo(pp2.x,pp2.y);
        // rechts
        pp1.x := round(p1.x+RailGaugePix*scale*cosa/2 );
        pp1.y := round(p1.y+RailGaugePix*scale*sina/2 );
        pp2.x := round(p2.x+RailGaugePix*scale*cosa/2 );
        pp2.y := round(p2.y+RailGaugePix*scale*sina/2 );
        MoveTo(pp1.x,pp1.y);
        if not (conn.special in [csStraight,csFixed,csSwitchLeftUpStraight,csSwitchRightUpStraight]) then
        begin
          CalcCurveCenter(conn.special in [csFixedCurveRight,csSwitchRightUpCurve],pp1,pp2,pp3);
          LineTo(pp3.x,pp3.y);
        end;
        LineTo(pp2.x,pp2.y);
        SwitchExtraDraw(canvas);
      end;
             }
     if grid<>nil then
      begin
        Pen.Color := GridColor;
        Pen.Width := 1;
        Pen.style := psSolid;
        griditem := grid.GetGridItemByID(conn.id);
        root := CurrentProject.FindConnectionByID(grid.RootConnection);
        Gridconst.x := cParalleltrackdist;
        Gridconst.y := 25;   // z
        PaintGridItemOutline(canvas,grid,griditem.x,griditem.z,root.P1.point,gridconst);

      end;
    end ;

    // Oberleitungsmasten
    if conn.PolesType<>'' then
    begin
      len := Intdistance(p1,p2);
      seganz := round(len / (cMaxLenImprove *Currentsituation.Zoom));
      for j := 0 to seganz-1 do
      begin
        c := j / seganz;
        ps.x := p1.x+ round(c*(p2.x-p1.x));
        ps.y := p1.y+ round(c*(p2.Y-p1.y));
        pp1 := ps;
        if conn.PolesPos>0 then
        begin
          pp2.x := ps.X - round(PoleLineLen*(p2.y-p1.y)/l);
          pp2.y := ps.y + round(PoleLineLen*(p2.x-p1.x)/l);
        end
        else
        begin
          pp2.x := ps.X + round(PoleLineLen*(p2.y-p1.y)/l);
          pp2.y := ps.y - round(PoleLineLen*(p2.x-p1.x)/l);
        end;
        Pen.width := 1;
        Pen.Color := TrackColorCatenary;
        MoveTo(pp1.x,pp1.y);
        LineTo(pp2.x,pp2.y);
      end;
    end;
    // Bahnsteig
    if conn.PlatformPos<>0 then
    begin
      if conn.PlatformPos=1 then // rechts
      begin
        pp1.x := p1.X - round(PlatformDistance*(p2.y-p1.y)/l);
        pp2.x := p2.X - round(PlatformDistance*(p2.y-p1.y)/l);
        pp3.x := p1.X - round((PlatformDistance+PlatformWidth)*(p2.y-p1.y)/l);
        pp4.x := p2.X - round((PlatformDistance+PlatformWidth)*(p2.y-p1.y)/l);
        pp1.y := p1.y + round(PlatformDistance*(p2.x-p1.x)/l);
        pp2.y := p2.y + round(PlatformDistance*(p2.x-p1.x)/l);
        pp3.y := p1.y + round((PlatformDistance+PlatformWidth)*(p2.x-p1.x)/l);
        pp4.y := p2.y + round((PlatformDistance+PlatformWidth)*(p2.x-p1.x)/l);
      end;
      if conn.PlatformPos=2 then // links
      begin
        pp1.x := p1.X + round(PlatformDistance*(p2.y-p1.y)/l);
        pp2.x := p2.X + round(PlatformDistance*(p2.y-p1.y)/l);
        pp3.x := p1.X + round((PlatformDistance+PlatformWidth)*(p2.y-p1.y)/l);
        pp4.x := p2.X + round((PlatformDistance+PlatformWidth)*(p2.y-p1.y)/l);
        pp1.y := p1.y - round(PlatformDistance*(p2.x-p1.x)/l);
        pp2.y := p2.y - round(PlatformDistance*(p2.x-p1.x)/l);
        pp3.y := p1.y - round((PlatformDistance+PlatformWidth)*(p2.x-p1.x)/l);
        pp4.y := p2.y - round((PlatformDistance+PlatformWidth)*(p2.x-p1.x)/l);
      end;

      Pen.width := 1;
      if conn.RoofType<>'' then
      begin
        Pen.Color := TrackColorRoof;
        Brush.Color := TrackColorRoof;
      end
      else
      begin
        Pen.Color := TrackColorPlatform;
        Brush.Color := TrackColorPlatform;
      end;
      points[0] := pp1;
      points[1] := pp2;
      points[2] := pp4;
      points[3] := pp3;
      Polygon(points);
    end;          
    // Signale
    if(FormOptions.GetShowSignalNames) then
    begin
      Brush.Style := bsClear;
      if Currentsituation.CurrentConnection=conn then
        Font.color := TrackColorCurrent
      else
        Font.color := TrackColor;
      for j:=0 to CurrentProject.Signals.Count-1 do
      begin
        Signal:=(CurrentProject.Signals[j] as TRBSignal);
        if Signal.connectionid = conn.id then
        begin
          if Signal.Direction=1 then
          begin
            TextOut(p1.x,p1.y,Signal.Name);
          end
          else
          begin
            TextOut(p2.x,p2.y,Signal.Name);
          end
        end;
      end;
    end;

  end;
end;


procedure TFrmEditor.PaintConnectionSolid(surface: TDirectDrawSurface; conn: TRBConnection; p1,p2: TPoint; IsInCurrentRouteDefinition: boolean; length: double; walllist: TRBWallList);
var ps,pp1,pp2,pp3,pp4,p3,p4: TPoint;
    c,l,sina,cosa,scale,a,dxfak: double;
    j,len,seganz,xs,ys,x,z: integer;
    points: array[0..3] of TPoint;
    grid: TRBGrid;
    griditem: TRBGridItem;
    signal: TRBSignal;
    Gridconst,gp,v1,v2: TDoublepoint;
    root: TRBConnection;



    procedure CalcCurveCenter(right: boolean; _p1,_p2: TPoint; var _p3: TPoint);
    var _v1: TPoint;
    begin
      // Kurve
      // Mittelpunkt
      _v1.x := _p2.x-_p1.x;
      _v1.y := _p2.y-_p1.y;
      if right then
      begin
        _p3.x := round((_v1.X / 2 + _v1.y / 50) + _p1.x);
        _p3.y := round((_v1.y / 2 - _v1.x / 50) + _p1.y);
      end
      else
      begin
        _p3.x := round((_v1.X / 2 - _v1.y / 50) + _p1.x);
        _p3.y := round((_v1.y / 2 + _v1.x / 50) + _p1.y);
      end;
    end;

begin


  if length=0 then
      l := conn.GetLength()
  else
      l := length;

  if l=0 then exit;

  // grid
  grid := CurrentProject.GetConnectionParentGrid(conn.id);
  if grid=nil then exit;

    if currentSituation.Zoom=10 then
      dxfak := 1.25
    else
    if currentSituation.Zoom=9 then
      dxfak := 1.125
    else
    if currentSituation.Zoom=8 then
      dxfak := 1
    else
    if currentSituation.Zoom=7 then
      dxfak := 0.875
    else
    if currentSituation.Zoom=6 then
      dxfak := 0.75
    else
    if currentSituation.Zoom=5 then
      dxfak := 0.625
    else
    if currentSituation.Zoom=4 then
      dxfak := 0.5;

    // 2 Schienen
    len := Intdistance(p1,p2);
    if len=0 then exit;
    // DX-Drawing
   FormMain.DXDraw1.Surface.DrawRotate(p1.x,p1.y,
     round(FormMain.FTrackSurface.Width*dxfak),round(FormMain.FTrackSurface.Height*dxfak),
     FormMain.FTrackSurface.ClientRect,
     FormMain.FTrackSurface,
     0.5,0,false,
     round(-(conn.getAngle(nil)+90)*256/360));
   {FormMain.DXDraw1.Surface.DrawRotate(p2.x,p2.y,
     round(FormMain.FTrackSurface.Width*dxfak),round(FormMain.FTrackSurface.Height*dxfak),
     FormMain.FTrackSurface.ClientRect,
     FormMain.FTrackSurface,
     0.5,0,false,
     round(-(conn.getAngle(nil)+270)*256/360));
   CalcCurveCenter(conn.special in [csFixedCurveRight,csSwitchRightUpCurve],p1,p2,p3);
   FormMain.DXDraw1.Surface.DrawRotate(p3.x,p3.y,
     round(FormMain.FTrackSurface.Width*dxfak),round(FormMain.FTrackSurface.Height*dxfak),
     FormMain.FTrackSurface.ClientRect,
     FormMain.FTrackSurface,
     0.5,0,false,
     round(-(conn.getAngle(nil)+90)*256/360)); }


end;

procedure TFrmEditor.PaintActiveGridItem(canvas: TCanvas);
var gridconst: TDoublePoint;
    root: TRBConnection;
begin
  if Currentsituation.CurrentGrid=nil then exit;
  root := CurrentProject.FindConnectionByID(Currentsituation.Currentgrid.RootConnection);
  if root=nil then exit;
  Gridconst.x := cParalleltrackdist;
  Gridconst.y := 25;   // z
  PaintGridItemOutline(canvas,CurrentSituation.CurrentGrid,CurrentSituation.CurrentGridX,
       CurrentSituation.CurrentGridZ,root.P1.point,gridconst);
end;

procedure TFrmEditor.PaintConnectionsSolid(surface: TDirectDrawSurface);
var
    i,j,seganz,len: integer;
    alpha,sina,cosa,c,l: extended;
    p1,p2,p_i1,p_i2: TPoint;
    conn: TRBConnection;
    IsInCurrentRouteDefinition,
    drawCurved,
    IsCurrentConnection: boolean;
    curvedconn: TRBConnectionlist;
    ImprovedPoints: TObjectlist;
    walllist: TRBWalllist;
begin
  walllist := TRBWalllist.Create();
  ImprovedPoints := TObjectlist.create;
  try
    // connections
    for i:=0 to CurrentProject.connections.count-1 do
    begin
      conn := CurrentProject.connections[i] as TRBconnection;
      IsCurrentConnection := (Currentsituation.CurrentConnection = conn);
      IsInCurrentRouteDefinition := CurrentSituation.CurrentRouteDefinitionContainsTrack(conn.ID);
      ConvertCoordWorldToPixel(conn.P1.point,
       point(PBCursor.Width div 2,PBCursor.height div 2),
       Currentsituation.Offset,
       Currentsituation.Zoom,p1);
      ConvertCoordWorldToPixel(conn.P2.point,
       point(PBCursor.Width div 2,PBCursor.height div 2),
       Currentsituation.Offset,
       Currentsituation.Zoom,p2);

      // ist mindestens einer der Punkte im canvas?
      if (InRange(p1.X,0,width) and InRange(p1.y,0,height))
       or(InRange(p2.X,0,width) and InRange(p2.y,0,height)) then
      begin
        drawCurved := conn.curved;
        if drawCurved then
        begin
          if CurrentProject.connections.ImproveConnection(conn,ceil(conn.GetLength()/cMaxLenImprove),improvedpoints)=0 then
            drawCurved := false;
        end;
        if drawCurved then
        begin
          p_i1 := p1;
          for j:=0 to improvedpoints.Count do
          begin
            if j=improvedpoints.count then
              p_i2 := p2
            else
              ConvertCoordWorldToPixel((improvedpoints[j] as TRBPoint).point,
               point(PBCursor.Width div 2,PBCursor.height div 2),
               Currentsituation.Offset,
               Currentsituation.Zoom,p_i2);

            PaintConnectionSolid(surface,conn,p_i1,p_i2,IsInCurrentRouteDefinition,cMaxLenImprove,walllist);
            p_i1 := p_i2;
          end;
        end
        else
          PaintConnectionSolid(surface,conn,p1,p2,IsInCurrentRouteDefinition,0,walllist);
      end;

  end;
  finally
  improvedpoints.free;
  walllist.free;
  end;
end;


procedure TFrmEditor.PaintConnections(canvas: TCanvas);
var
    i,j,seganz,len: integer;
    alpha,sina,cosa,c,l: extended;
    p1,p2,p_i1,p_i2: TPoint;
    conn: TRBConnection;
    IsInCurrentRouteDefinition,
    drawCurved,
    IsCurrentConnection: boolean;
    curvedconn: TRBConnectionlist;
    ImprovedPoints: TObjectlist;
    walllist: TRBWalllist;
begin
  walllist := TRBWalllist.Create();
  ImprovedPoints := TObjectlist.create;
  try
  with canvas do
  begin
    // connections
    for i:=0 to CurrentProject.connections.count-1 do
    begin
      conn := CurrentProject.connections[i] as TRBconnection;
      IsCurrentConnection := (Currentsituation.CurrentConnection = conn);
      IsInCurrentRouteDefinition := CurrentSituation.CurrentRouteDefinitionContainsTrack(conn.ID);
      ConvertCoordWorldToPixel(conn.P1.point,
       point(PBCursor.Width div 2,PBCursor.height div 2),
       Currentsituation.Offset,
       Currentsituation.Zoom,p1);
      ConvertCoordWorldToPixel(conn.P2.point,
       point(PBCursor.Width div 2,PBCursor.height div 2),
       Currentsituation.Offset,
       Currentsituation.Zoom,p2);

      // ist mindestens einer der Punkte im canvas?
      if (InRange(p1.X,0,width) and InRange(p1.y,0,height))
       or(InRange(p2.X,0,width) and InRange(p2.y,0,height)) then
      begin
        drawCurved := conn.curved;
        if drawCurved then
        begin
          if CurrentProject.connections.ImproveConnection(conn,ceil(conn.GetLength()/cMaxLenImprove),improvedpoints)=0 then
            drawCurved := false;
        end;
        if drawCurved then
        begin
          p_i1 := p1;
          for j:=0 to improvedpoints.Count do
          begin
            if j=improvedpoints.count then
              p_i2 := p2
            else
              ConvertCoordWorldToPixel((improvedpoints[j] as TRBPoint).point,
               point(PBCursor.Width div 2,PBCursor.height div 2),
               Currentsituation.Offset,
               Currentsituation.Zoom,p_i2);

            PaintConnection(canvas,conn,p_i1,p_i2,IsInCurrentRouteDefinition,cMaxLenImprove,walllist);
            p_i1 := p_i2;
          end;
        end
        else
          PaintConnection(canvas,conn,p1,p2,IsInCurrentRouteDefinition,0,walllist);
      end;
    end;
  end;
  finally
  improvedpoints.free;
  walllist.free;
  end;
end;

procedure TFrmEditor.PaintCursor(canvas: TCanvas);
var c: TPoint;
begin
  with canvas do
  begin
    ConvertCoordWorldToPixel(Currentsituation.Cursor,
           point(PBCursor.Width div 2,PBCursor.height div 2),
           Currentsituation.Offset,
           Currentsituation.Zoom,c);
    Pen.Width := 1;
    Pen.Style := psSolid;
    Pen.Color := clWhite;
    MoveTo(c.X-5,c.Y);
    LineTo(c.X+5,c.y);
    MoveTo(c.x,c.y-5);
    LineTo(c.x,c.Y+5);
  end;
end;

procedure TFrmEditor.paintSelArea(canvas: TCanvas);
var    sel1,sel2: TPoint;
begin
  with canvas do
  begin
    ConvertCoordWorldToPixel(Currentsituation.SelArea1,
           point(PBCursor.Width div 2,PBCursor.height div 2),
           Currentsituation.Offset,
           Currentsituation.Zoom,sel1);
    ConvertCoordWorldToPixel(Currentsituation.SelArea2,
           point(PBCursor.Width div 2,PBCursor.height div 2),
           Currentsituation.Offset,
           Currentsituation.Zoom,sel2);
    Pen.Width := 1;
    Pen.Style := psDot;
    Pen.Color := SelAreaColor;
    Brush.Style := bsClear;

    Rectangle(sel1.X,sel1.Y,sel2.x,sel2.y);

  end;
end;


procedure TFrmEditor.PaintPoint(canvas: TCanvas; p: TRBPoint);
var    pix: TPoint;
begin
  with canvas do
  begin
    ConvertCoordWorldToPixel(p.point,
       point(PBCursor.Width div 2,PBCursor.height div 2),
       Currentsituation.Offset,
       Currentsituation.Zoom,pix);
    // aktiv?
    if Currentsituation.CurrentPoint=p then
    begin
      Brush.style := bsSolid;
      Brush.color := TrackColorCurrent;
      Pen.Style := psClear;
      Ellipse(pix.x-5,pix.y-5,pix.x+5,pix.Y+5);
    end
    else
    // berührt?
    if Currentsituation.CurrentPointTouched=p then
    begin
      Brush.style := bsSolid;
      Pen.Style := psClear;
      Brush.color := clRed;
      Ellipse(pix.x-5,pix.y-5,pix.x+5,pix.Y+5);
    end
    else
    begin
      // Kreisscheibe
      Brush.Color := $00000040;
      Brush.Style := bsSolid;
      Pen.Style := psClear;
      Ellipse(pix.x-5,pix.y-5,pix.x+5,pix.Y+5);
    end;
  end;
end;

procedure TFrmEditor.paintPoints(canvas: TCanvas);
var
    i: integer;
    p:   TRBPoint;
begin
    // points
    for i:=0 to CurrentProject.Points.count-1 do
    begin
      p := CurrentProject.points[i] as TRBPoint;
      if not p.secondary then
        PaintPoint(canvas,p);
    end;
end;

procedure TFrmEditor.SetTrackTypeButtons;
begin
  if (Currentsituation.CurrentConnection<>nil) then
  begin
    cbTrackType.ItemIndex := ord(CurrentSituation.CurrentConnection.special);
    cbTrackType.Enabled := true;
//   setfocusedControl(tbZoom);
  end
  else
  begin
    cbTrackType.Enabled := false;
  end;


end;

procedure TFrmEditor.UpdateView(sender: TObject; repaint: boolean);
var i: integer;
    p: TPoint;
    station: TRBStation;
begin
  if currentproject=nil then exit;
  if repaint then
    PanelMainEditor.Repaint;
  lCursorpos.caption := format('%.2f/%.2f',[Currentsituation.cursor.X,Currentsituation.cursor.Y]);
  lPDist.caption := 'P<->P: ';
  if (Currentsituation.CurrentPoint<>nil)
  and(Currentsituation.CurrentPointTouched<>nil) then
    lPDist.caption := lPDist.caption
        + floattostrPoint( Distance(Currentsituation.CurrentPoint.point,Currentsituation.CurrentPointTouched.point) ) + ' m';
  // zeichne Minimap
  if repaint then Paintbox1.Repaint;

  //  ScrollBarVert.Position
  lZoom.caption := floattostr(Currentsituation.zoom) + ' px/m';
  tbZoom.Min := 1;
  tbZoom.Max := pixelpermeter;
  tbZoom.Position := trunc(Currentsituation.zoom);
  //
  if repaint then
  begin
    FormMain.PaintDX();
    PBCursorPaint(self);
    SetScrollbars();
  end;

  // Rulers
  RsRulerLeft.scale  := 100*round(currentsituation.zoom);
  RsRulerTop.scale   := 100*round(currentsituation.zoom);
  RsRulerLeft.Offset := Currentsituation.Offset.Y-(PBCursor.height div 2)/currentsituation.zoom;
  RsRulerTop.Offset  := Currentsituation.Offset.X-(PBCursor.width div 2)/currentsituation.zoom;

  // enable/disable von Menüpunkten
  tbConnectPoints.Enabled := (Currentsituation.CurrentPoint<>nil)
                         and (Currentsituation.CurrentPointTouched<>nil)
                         and (Currentsituation.CurrentPointTouched<>Currentsituation.CurrentPoint);

  connectpoints1.enabled := tbConnectPoints.Enabled;

  SetTrackTypeButtons();

  turntrack1.Enabled := (Currentsituation.CurrentConnection<>nil);
  copyproperties1.Enabled := (Currentsituation.CurrentConnection<>nil);
  pasteproperties1.Enabled := (TrackPropertiesCopy<>nil);
  pastepropertiestocurrentroute1.Enabled := (TrackPropertiesCopy<>nil)and(Currentsituation.CurrentRouteDefinition<>nil);
  pastepropertiesuntilswitch1.Enabled := (TrackPropertiesCopy<>nil);
  tbAddAndConnect.enabled := (Currentsituation.CurrentPoint<>nil);
  tbDelPoint.enabled := (Currentsituation.CurrentPoint<>nil);
  deletepoint1.enabled := (Currentsituation.CurrentPoint<>nil);
  PopupMenuaddtocurrentroute.enabled := (currentsituation.CurrentConnection<>nil)and(Currentsituation.CurrentRouteDefinitionID<>0);
  PopupMenudeletefromcurrentroute.Enabled := (currentsituation.CurrentConnection<>nil)and(Currentsituation.CurrentRouteDefinitionID<>0);
  addtocurrentrouteuntilswitch1.Enabled := (Currentsituation.CurrentPoint<>nil)and(currentsituation.CurrentConnection<>nil)and(Currentsituation.CurrentRouteDefinitionID<>0);
  addnewpointandconnect1.enabled := (Currentsituation.CurrentPoint<>nil);
  deletepoint1.Enabled := (currentsituation.currentpoint<>nil);
  deleteconnection1.Enabled := (currentsituation.CurrentConnection<>nil);
  tbImproveConnection.Enabled := (currentsituation.CurrentConnection<>nil);
  addtogrid1.enabled := (currentsituation.CurrentConnection<>nil);
  deletefromgrid1.enabled := (currentsituation.CurrentConnection<>nil);
  tbProperties.Enabled := (currentsituation.CurrentConnection<>nil);
  addselectedobject1.enabled := (FormObjects.FrmObjects1.lvObjFolders.selected<>nil)
                            and (FormObjects.FrmObjects1.lvObjects.selected<>nil);
  tbAddObj.enabled := addselectedobject1.enabled;
  tbDelObj.enabled := (Currentsituation.CurrentObject<>nil);
  tbObjProperties.enabled := (Currentsituation.CurrentObject<>nil);
  make25mlong1.Enabled := (currentsituation.CurrentConnection<>nil);
  tbSignals.Enabled := (CurrentProject <>nil) and(CurrentProject.Signals.count<>0);

  // Eintragen der Bahnhöfe in Bahnhöfe-Combobox
  cbGotoStation.Items.Clear();
  i:=0;
  repeat
    station := CurrentProject.GetStationByIndex(i);
    if station<>nil then
      cbGotoStation.Items.Add(station.StationName);
    inc(i);
  until (station=nil);

  // Track-Eigenschaften
  if CurrentSituation.CurrentConnection<>nil then
  begin
    lThistrack.caption := 'this track: id=' + inttostr(CurrentSituation.CurrentConnection.id)
     + ' len='+floattostr(CurrentSituation.CurrentConnection.GetLength())
     + ' alpha='+floattostr(CurrentSituation.CurrentConnection.GetAngle(nil))
     ;
  end;

  if FormGridTracks<>nil then
  begin
    FormGridTracks.EditorFrame := self;
    FormGridTracks.CurrentProject := CurrentProject;
  end;

  

end;


procedure TFrmEditor.ScrollBox1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var pixoffs: TPoint;
    p,p1,p2,p3,p4,op1,op2,pBackup: TDoublePoint;
    px: TRBPoint;
    o,otouched: TRBObject;
    a,b,ow,ox2: double;
    cube: TDoubleCube;
    inseg: boolean;
    pix1,pix2,pix3,pix4: TPoint;
    rect: TRect;
    i,xmin,xmax,ymin,ymax,old_alpha: integer;
    NearPointExists,
    NearObjectExists: boolean;
begin
  wasdragging := false;
  if dragging then
  begin
    wasdragging := true;
    // Aktuelle Position in Pixel umrechnen
    ConvertCoordWorldToPixel(CurrentSituation.Offset,
                        point(PBCursor.width div 2,PBCursor.Height div 2),
                        CurrentSituation.Offset,
                        CurrentSituation.zoom,pixoffs);
    pixoffs.X := pixoffs.X - (x-oldx);
    pixoffs.Y := pixoffs.Y - (y-oldy);
    ConvertCoordPixelToWorld(pixoffs,
                        point(PBCursor.width div 2,PBCursor.Height div 2),
                        CurrentSituation.Offset,
                        CurrentSituation.Zoom,p);
    CurrentSituation.Offset.x := p.x;
    CurrentSituation.Offset.y := p.y;
    UpdateView;
    oldx := x;
    oldy := y;
  end;
  // folgendes nur wenn nicht gerade ein Punkt oder ein Objekt verschoben wird
  if (draggingPoint=nil)and(DraggingObject=nil) then
  begin
    // suche nach Point in der Nähe
    NearPointExists := false;
    ConvertCoordPixelToWorld(point(x,y),
                          point(PBCursor.width div 2,PBCursor.Height div 2),
                          CurrentSituation.Offset,
                          CurrentSituation.Zoom,p);
    for i:=0 to CurrentProject.points.count-1 do
    begin
      if (CurrentProject.points[i] as TRBPoint).isNear(p,tbZoom.position)
      and (Currentsituation.CurrentPoint<>CurrentProject.points[i]) then
      begin
        if Currentsituation.CurrentPointTouched <> CurrentProject.points[i] then
        begin
          // merken, welcher punkt berührt ist
          px := Currentsituation.CurrentPointTouched;
          // neuen setzen
          Currentsituation.CurrentPointTouched := CurrentProject.points[i] as TRBPoint;
          // falls vorher anderer punkt berührt, diesen übermalen
          if px<>nil then
            PaintPoint(MouseOverEffectCanvas,px);
          // malen
          PaintPoint(MouseOverEffectCanvas,Currentsituation.CurrentPointTouched);
          UpdateView(self,false);
        end;
        NearPointExists := true;
      end;
    end;
    // keinem Punkt nahe?
    if not NearPointExists then
    begin
      // nur zeigen wenns vorher anders war
      if Currentsituation.CurrentPointTouched <> nil then
      begin
        // merken, welcher punkt berührt ist
        px := Currentsituation.CurrentPointTouched;
        // berührten Punkt zurücksetzen (sonst zeichnet PaintPoint ihn berührt)
        Currentsituation.CurrentPointTouched := nil;
        // gemerkten Punkt zeichnen
        PaintPoint(MouseOverEffectCanvas,px);
        UpdateView(self,false);
//        UpdateView;
      end;
    end;
  end
  else
  begin
    dec(ClickOnlyCounter);
    if ClickOnlyCounter<=0 then
      ClickOnly := false;
  end;

  if DraggingObject=nil then
  begin
    // ein Objekt berührt?
    NearObjectExists := false;
    otouched := Currentsituation.CurrentObjectTouched;
    ConvertCoordPixelToWorld(point(x,y),
                          point(PBCursor.width div 2,PBCursor.Height div 2),
                          CurrentSituation.Offset,
                          CurrentSituation.Zoom,p);
    for i:=0 to CurrentProject.FreeObjects.count-1 do
    begin
      o := CurrentProject.Freeobjects[i] as TRBObject;
      o.MaxCubeRotated(op1,op2,p3,p4);
      op1.x := op1.x+o.point.x;
      op1.y := op1.y+o.point.y;
      op2.x := op2.x+o.point.x;
      op2.y := op2.y+o.point.y;
      p4.x := p4.x+o.point.x;
      p4.y := p4.y+o.point.y;
      ow := distance(op1,p4);

      inseg := IsPointInSegment(op1,op2,p,ow,a,b);

      b := -b;
      if (b>=0)and(b<=1)and(a<=1)and(a>=0) then
      begin

        if  (Currentsituation.CurrentObjectTouched<>o) then
        begin
          otouched := o;
        end;
        NearObjectExists := true;
      end;
    end;
    if NearObjectExists then
    begin
      if otouched<>Currentsituation.CurrentObjectTouched then
      begin
        // zuletzt berührtes objekt merken
        o := Currentsituation.CurrentObjectTouched;
        // berührtes objekt setzen
        Currentsituation.CurrentObjectTouched := otouched;
        // war vorher ein objekt berührt, dann gelb zeichnen
        IF o<>nil then
          PaintObject(MouseOverEffectCanvas,o,FreeObjColor);
        // zeichnen (orange)
        PaintObject(MouseOverEffectCanvas,otouched,FreeObjTouchedColor);
        // in statusbereich namen ausgeben
        lThisTrack.caption := 'FreeObj='+otouched.GetPath();
        UpdateView(self,false);
        //UpdateView();
      end;
    end;
    if not NearObjectExists then
    begin
      if Currentsituation.CurrentObjectTouched<>nil then
      begin
        // backup des berührten Objekts
        otouched := Currentsituation.CurrentObjectTouched;
        // kein berührtes objekt
        Currentsituation.CurrentObjectTouched := nil;
        // objekt übermalen (gelb)
        PaintObject(MouseOverEffectCanvas,OTouched,FreeObjColor);
        //
        lThisTrack.caption := '';
        UpdateView(self,false);
        //UpdateView();
      end;
    end;
  end // if draggingPoint=nil
  else
  begin
    dec(ClickOnlyCounter);
    if ClickOnlyCounter<=0 then
      ClickOnly := false;

    if ssalt in Shift then
    begin
      // drehen
      oldalpha := draggingobject.angle;
      draggingobject.angle := turnalpha;
      PaintObject(MouseOverEffectCanvas,draggingobject,FreeObjSelectColor,0,true);
      inc(turnalpha,(x-oldx)-(y-oldy));
      draggingobject.angle := turnalpha;
      PaintObject(MouseOverEffectCanvas,draggingobject,FreeObjSelectColor,0,true);
      oldx := x; oldy := y;
      draggingobject.angle := oldalpha;
      lthistrack.caption := 'alpha='+inttostr(turnalpha) + 'deg';
    end
    else
    begin
      // schieben
      // an der alten Stelle löschen
      pBackup := draggingobject.point;
      ConvertCoordPixelToWorld(point(oldx+objhotoffx,oldy+objhotoffy),
                          point(PBCursor.width div 2,PBCursor.Height div 2),
                          CurrentSituation.Offset,
                          CurrentSituation.Zoom,p);
      draggingobject.point := p;
      PaintObject(MouseOverEffectCanvas,draggingobject,FreeObjSelectColor,0,true);
      // an neuer Stelle zeichnen
      ConvertCoordPixelToWorld(point(x+objhotoffx,y+objhotoffy),
                          point(PBCursor.width div 2,PBCursor.Height div 2),
                          CurrentSituation.Offset,
                          CurrentSituation.Zoom,p);
      draggingobject.point := p;
      PaintObject(MouseOverEffectCanvas,draggingobject,FreeObjSelectColor,0,true);
      draggingobject.point := pBackup;
      oldx := x; oldy := y;
    end;
  end;

end;

// Funktion    : Timer1Timer
// Datum       : 14.7.02
// Autor       : up
// Beschreibung: Update-Funktion für Anzeigen, zur Vermeidung von Callbacks
procedure TFrmEditor.Timer1Timer(Sender: TObject);
var Radius: integer;
    ActiveConnectableExists: boolean;
begin
  // möchte irgendjemand, dass neu gezeichnet wird?
  if CurrentSituation.PleaseUpdateView then
  begin
    CurrentSituation.PleaseUpdateView := false;
    UpdateView();
  end;
  Paintbox1.Left := -Scrollbox1.HorzScrollBar.ScrollPos;
  Paintbox1.Top  := -ScrollBox1.VertScrollBar.ScrollPos;
  CurrentSituation.ignoreClick := false;
end;

procedure TFrmEditor.properties1Click(Sender: TObject);
begin
  if CurrentSituation.CurrentConnection=nil then exit;
  FormTrackProperties.Track := CurrentSituation.CurrentConnection as TRBConnection;
  FormTrackProperties.CurrentProject := CurrentProject;
  FormTrackProperties.UpdateFunc := UpdateView;
  FormTrackProperties.show();
end;

procedure TFrmEditor.PopupMenu1Popup(Sender: TObject);
begin
  // Im Popupmenü "add and connect track" enablen, wenn ein Track existiert
//  addandconnecttrack1.enabled := (CurrentSituation.CurrentConnectable<>nil);
end;

procedure TFrmEditor.PopupMenuchangeswitchposition1Click(Sender: TObject);
begin
{
  (CurrentSituation.CurrentConnectable as TRBSwitch).PositionCurve :=
    not (CurrentSituation.CurrentConnectable as TRBSwitch).PositionCurve;
  (CurrentSituation.CurrentConnectable as TRBSwitch).repaint;

  // merken, ob der nächste Track an den geraden oder abzweigenden Track kommt
  if (CurrentSituation.CurrentConnectable as TRBSwitch).PositionCurve then
    CurrentSituation.CurrentConnection := 1
  else
    CurrentSituation.CurrentConnection := 0;}
end;

procedure TFrmEditor.ToolButton1Click(Sender: TObject);
begin
  FormRouteDefinitions.CurrentProject := CurrentProject;
  if FormRouteDefinitions.Visible then
    FormRouteDefinitions.Hide()
  else
    FormRouteDefinitions.Show();
end;

procedure TFrmEditor.PopupMenuaddtocurrentrouteClick(Sender: TObject);
begin
// wir gehen davon aus, dass eine aktuelle RouteDefinition existiert, da
// im Menü dieser Punkt sonst disabled wäre
  Currentsituation.CurrentRouteDefinition.AddTrack( (Currentsituation.CurrentConnection as TRBConnection).ID );
  UpdateView;

end;

procedure TFrmEditor.PopupMenudeletefromcurrentrouteClick(Sender: TObject);
begin
  //
  Currentsituation.CurrentRouteDefinition.DeleteTrack( (Currentsituation.CurrentConnection as TRBConnection).ID );
  UpdateView;
end;

procedure TFrmEditor.tbObjectsClick(Sender: TObject);
begin
  formobjects.CurrentProject := CurrentProject;
  formobjects.show;
end;

procedure TFrmEditor.tbTrainsClick(Sender: TObject);
begin
  FormTrain.show;
end;

procedure TFrmEditor.PBCursorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var NearPointExists: boolean;
    p: TDoublePoint;
    i: integer;
    p1: TPoint;
begin
  wasdragging := false;
  draggingPoint := nil;
  draggingObject := nil;
  ConvertCoordPixelToWorld(point(x,y),point(PBCursor.width div 2,PBCursor.Height div 2),
                        CurrentSituation.Offset,
                        CurrentSituation.Zoom,newpoint);

  if ssCtrl in Shift then
    Currentsituation.CurrentObjectTouched := nil;

  if ssShift in Shift then
  begin
    dragging := true;
    Screen.Cursor := crSizeAll;
    oldx:=x;
    oldy:=y;
  end
  else
  begin
    // Punkt verschieben?
    if Button = mbLeft then
    begin
      NearPointExists := false;
      ConvertCoordPixelToWorld(point(x,y),
                            point(PBCursor.width div 2,PBCursor.Height div 2),
                            CurrentSituation.Offset,
                            CurrentSituation.Zoom,p);
      for i:=0 to CurrentProject.points.count-1 do
      begin
        if (CurrentProject.points[i] as TRBPoint).isNear(p,tbZoom.position) then
        begin
          draggingPoint := CurrentProject.points[i] as TRBPoint;
          break;
        end;
      end;
      // Objekt?
      if (Currentsituation.CurrentObjectTouched<>nil)and(not (ssCtrl in Shift)) then
      begin
        draggingObject := CurrentSituation.CurrentObjectTouched;
        ConvertCoordWorldToPixel(draggingObject.point,point(PBCursor.width div 2,PBCursor.Height div 2),
           CurrentSituation.Offset,CurrentSituation.zoom,p1);
        objhotoffx := p1.x-x;
        objhotoffy := p1.y-y;
        oldx:=x;
        oldy:=y;
        turnalpha := draggingObject.angle;
      end;
      if (draggingPoint<>nil)or(draggingObject<>nil) then
      begin
        Screen.cursor := crDrag;
        ClickOnly := true;
        ClickOnlyCounter := 3;
      end;
    end;
  end;

end;

procedure TFrmEditor.PBCursorMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var p: TDoublePoint;
    i: integer;
    dist,g,mindist: integer;
    conn,bestconn,root: TRBConnection;
    a,b,bestb: double;
    sta: TRBStation;
begin
  if CurrentSituation.ignoreClick then
  begin
    CurrentSituation.ignoreclick:=false;
    exit;
  end;
  dragging := false;
  Screen.Cursor := crDefault;
  FormMain.ActiveControl := FormMain.FrmEditor.PanelMainEditor;

  if ssCtrl in Shift then
  begin
    if ssShift in Shift then
    begin
      // add point and conn.
      if currentsituation.CurrentPoint<>nil then
      begin
        addnewpointandconnect1Click(self);
      end;
      exit;
    end
    else
    begin
      // add point
//      addpoint1Click(self);
    end;
    //exit;
  end;
  if ssAlt in Shift then
  begin
    if Currentsituation.CurrentPointTouched<>nil then
    begin
      currentproject.DeletePoint(Currentsituation.CurrentPointTouched);
      Currentsituation.CurrentPointTouched := nil;
    end;
  end;
  ConvertCoordPixelToWorld(point(x,y),
                          point(PBCursor.width div 2,PBCursor.Height div 2),
                          CurrentSituation.Offset,
                          CurrentSituation.Zoom,p);
  if (p.x>0)and(p.y>0) then
    CurrentSituation.cursor := p;
  if (draggingPoint<>nil) then
  begin
    if not ClickOnly then
    begin
      // Point verschoben?
      AddUndoAction(rbaMovePoint,draggingPoint,nil,draggingPoint.point);
      draggingPoint.point := p;
      if Currentsituation.CurrentPointTouched<>nil then
        Currentsituation.CurrentPointTouched := nil;
    end;
    Currentsituation.CurrentPoint := draggingPoint;
    tbPointHeight.Position        := round(draggingPoint.height*1000);
    lPointHeight.Caption          := 'point h='+inttostr(tbPointHeight.Position)+'mm';
    draggingObject := nil;
    // grid? sonst fit
    if not CurrentProject.SnapPointToGrid(draggingPoint) then
    begin
      if FormOptions.UseFit4m then FitPoint();
      if FormOptions.UseMinLength then ConnMinLength();
    end;
    draggingPoint:=nil;
    updateView();
    exit;
  end;

  if (draggingObject<>nil) then
  begin
    if (not ClickOnly)and(draggingObject.locked=false) then
    begin
      ConvertCoordPixelToWorld(point(x+objhotoffx,y+objhotoffy),
                          point(PBCursor.width div 2,PBCursor.Height div 2),
                          CurrentSituation.Offset,
                          CurrentSituation.Zoom,p);
      if draggingObject.angle<>turnalpha then
      begin
//        AddUndoAction(rbaTurnObject,draggingObject,nil,draggingObject.point);
        draggingObject.angle := turnalpha;
      end
      else
      begin
        AddUndoAction(rbaMoveObject,draggingObject,nil,draggingObject.point);
        draggingObject.point := p;
      end;
      if CurrentSituation.CurrentObjectTouched<>nil then CurrentSituation.CurrentObjectTouched := nil;
    end;
    CurrentSituation.CurrentObject := draggingObject;
    draggingObject := nil;
    updateView();
    Exit;
  end;

  // einen Point angeklickt?
  if (Currentsituation.CurrentPointTouched<>nil)and(Button=mbLeft) then
  begin
    Currentsituation.CurrentPoint := Currentsituation.CurrentPointTouched;
    Currentsituation.CurrentPointTouched := nil;
//    tbPointAngle.position := Currentsituation.CurrentPoint.angle;
    UpdateView();
    exit;
  end;
  if ssCtrl in Shift then
    Currentsituation.CurrentObjectTouched := nil;
  // ein Objekt angeklickt?
  if (CurrentSituation.CurrentObjectTouched<>nil)and(Button=mbLeft) then
  begin
    CurrentSituation.CurrentObject := CurrentSituation.CurrentObjectTouched;
    CurrentSituation.CurrentObjectTouched := nil;
    UpdateView();
    exit;
  end;
  // eine Connection angeklickt?
  if Button=mbLeft then
  begin
    // in ein Grid geklickt?
    g:=10;
    CurrentSituation.CurrentGrid := CurrentProject.GetNearestGrid(p);
    if CurrentSituation.CurrentGrid<>nil then
    begin
      g := round(CurrentProject.ParallelTrackDist);
      root := CurrentProject.FindConnectionByID(CurrentSituation.CurrentGrid.RootConnection);
      if not CurrentSituation.CurrentGrid.GetXZofPoint(p,root.P1.point,CurrentSituation.CurrentGridX,Currentsituation.CurrentGridZ) then
      begin
        Currentsituation.CurrentGridZ := 0;
        Currentsituation.CurrentGridX := 0;
      end;
    end;
    // Connection angeklickt?
    mindist := maxint;
    bestb := maxint;
    bestconn := nil;
    for i:=0 to CurrentProject.Connections.count-1 do
    begin
      conn := CurrentProject.Connections[i] as TRBConnection;
      if CurrentProject.IsPointInSegment(conn.P1.point,conn.P2.point,p,g,a,b) then
      begin
        if abs(b)<bestb then
        begin
          bestb := abs(b);
          bestconn := conn;
        end;
      end;
    end;
    if bestconn<>nil then
    begin
      CurrentSituation.CurrentConnection := bestconn;
      Currentsituation.CurrentPoint := bestconn.P1;
      UpdateView();
      if FormTrackProperties.Visible and (bestconn<>FormTrackProperties.Track) then
      begin
        FormTrackProperties.Track := bestconn;
        FormTrackProperties.FormShow(self);
      end;

      // Bahnhof?
      sta := CurrentProject.GetStationByTrackID(bestconn.id);
      if sta<>nil then cbGotoStation.ItemIndex := cbGotoStation.Items.IndexOf(sta.StationName);
      exit;
    end;
  // debug output für grid click
//    lThisTrack.Caption := inttostr(Currentsituation.CurrentGridX)+'/'+inttostr(Currentsituation.CurrentGridZ);
  end;
  if (mbLeft = button) and not wasdragging then
  begin
    CurrentSituation.CurrentConnection := nil;
    CurrentSituation.CurrentPoint := nil;
    CurrentSituation.CurrentObject := nil;
    UpdateView();
  end;
end;



procedure TFrmEditor.bStationsClick(Sender: TObject);
begin
  FormStations.CurrentProject := CurrentProject;
  FormStations.Show();
end;

procedure TFrmEditor.setminimapbackgroundimage1Click(Sender: TObject);
begin
  FormBGMap.edfilename.text := CurrentProject.BackgroundMapfilename;
  FormBGMap.EdScale.text    := inttostr(CurrentProject.BackgroundMapScale);

  if FormBGMap.ShowModal()=mrOK then
  begin
    CurrentProject.BackgroundMapfilename := FormBGMap.edfilename.text;
    CurrentProject.BackgroundMapScale    := strtointdef(FormBGMap.EdScale.Text,1);
  end;
end;



procedure TFrmEditor.tbZoomChange(Sender: TObject);
begin
  Currentsituation.Zoom := tbZoom.position;
  UpdateView();
end;

procedure TFrmEditor.tbMapClick(Sender: TObject);
begin
  if (PanMap.visible=false)and((Currentproject.BackgroundMapfilename='')or(not fileexists(Currentproject.BackgroundMapfilename)))then
  begin
    if MessageDlg(lngmsg.getMsg( 'ufrmeditor_nobgmap'), mtConfirmation, [mbYes,mbNo], 0)=mrYes then
    begin
      with TFormNewBGImage.Create(self) do
      begin
        if Currentproject.BackgroundMapScale<>0 then
          EdResolution.text := inttostr(Currentproject.BackgroundMapScale);
        Project := CurrentProject;
        if ShowModal()<>mrOK then exit;
      end;
    end
    else exit;
  end;
  PanMap.Visible := not PanMap.Visible;
  MapScale := jsEighth;
  tbMapZoom.Position := 4;
  SetMap();
end;

procedure TFrmEditor.SetMap();
begin
  if PanMap.Visible and (CurrentProject<>nil) then
  begin
    if fileexists(CurrentProject.BackgroundMapfilename) then
    begin
      Image1.Picture.LoadFromFile(CurrentProject.BackgroundMapfilename);
      TJPEGImage(Image1.Picture.Graphic).Scale := MapScale;
      Scrollbox1.HorzScrollBar.Range := Image1.Picture.Width;
      Scrollbox1.vertScrollBar.Range := Image1.Picture.Height;
      Paintbox1.Left := 0;
      Paintbox1.Top  := 0;
      Paintbox1.Width := Image1.Picture.Width;
      Paintbox1.Height := Image1.Picture.Height;
    end;
  end;
end;

procedure TFrmEditor.tbMapZoomChange(Sender: TObject);
begin
  //
  case tbMapzoom.position of
  1: begin
       MapScale := jsFullsize;
       tbMapZoom.Hint := '1:1';
     end;
  2: begin
       MapScale := jsHalf;
       tbMapZoom.Hint := '1:2';
     end;
  3: begin
       MapScale := jsQuarter;
       tbMapZoom.Hint := '1:4';
     end;
  4: begin
       MapScale := jsEighth;
       tbMapZoom.Hint := '1:8';
     end;
  end;
  SetMap();
end;

procedure TFrmEditor.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var pworld: TDoublePoint;
begin
  MapToWorld(x,Image1.height-y,pworld);
  CurrentSituation.Offset := pworld;
//  Currentsituation.Offset.X := strtointdef(EdXOffset.text,0);
//  Currentsituation.Offset.Y := strtointdef(EdYOffset.text,0);
  if mbLeft=Button then
  begin
    if Currentsituation.Offset.X>0 then
      Currentsituation.cursor.x := round(Currentsituation.Offset.X);
    if Currentsituation.Offset.Y>0 then
      Currentsituation.cursor.y := round(Currentsituation.offset.y);

    if ssCtrl in Shift then
    begin
      if ssShift in Shift then
      begin
        tbAddAndConnectClick(self);
      end
      else
      begin
        tbNewPointClick(self);
      end;
    end;
  end;
  UpdateView();
end;

procedure TFrmEditor.Image1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var p: TDoublePoint;
begin
  MapToWorld(x,Image1.height-y,p);
  EdMapcoord.text := {inttostr(x)+'/'+inttostr(y) + ' ' +} inttostr(round(p.x) div 1000)
     + '/' + inttostr(round(p.y) div 1000) + 'km';
end;

procedure TFrmEditor.MapToWorld(x,y: integer; var pworld: TDoublePoint);
var fak: double;
begin
  // 100 pixel are CurrentProject.BackgroundMapScale meters
  if CurrentProject=nil then exit;
  fak := CurrentProject.BackgroundMapScale*power(2,tbMapzoom.position-1)/100;
  pworld.x := x*fak;
  pworld.y := y*fak;
end;

procedure TFrmEditor.PaintBox1Paint(Sender: TObject);
var Minimap: TRBMinimap;
    x,y: Integer;
    farpoint: TDoublePoint;
begin
//  Paintbox1.Canvas.Brush.Style := bsVertical;
//  Paintbox1.Canvas.FillRect(Paintbox1.ClientRect);
  // Minimap
  Minimap := TRBMinimap.Create;
  Minimap.ShowPoints := false; // TODO: eventuell zuschaltbar
  Minimap.CurrentProject := CurrentProject;
//  Minimap.CalculateBoundingRect(CurrentProject.Tracks);
  x := Image1.Width;
  y := Image1.Height;
  MapToWorld(x,y,farpoint);
  Minimap.boundingRect.Bottom:= 0;
  Minimap.boundingRect.Left  := 0;
  Minimap.boundingRect.Top   := round(farpoint.y);
  Minimap.boundingRect.right := round(farpoint.x);

  Minimap.MiniRect := Paintbox1.ClientRect;
  Minimap.DrawMap(Paintbox1.Canvas,CurrentProject.connections,CurrentProject.Points);
  Minimap.Free;

end;

procedure TFrmEditor.ScrollBox1Resize(Sender: TObject);
begin

      Paintbox1.Width := Image1.Picture.Width;
      Paintbox1.Height := Image1.Picture.Height;

end;

procedure TFrmEditor.tbNewPointClick(Sender: TObject);
var RBP: TRBPoint;
begin
  RBP := TRBPoint.Create(Currentsituation.cursor,tbPointHeight.Position/1000);
  CurrentProject.AddPoint(RBP);
  Currentsituation.CurrentPoint := RBP;
  AddUndoAction(rbaAddPoint,RBP,nil,RBP.point);
  if FormOptions.UseFit4m then FitPoint();
  UpdateView();
end;

procedure TFrmEditor.connectpoints1Click(Sender: TObject);
var conn: TRBConnection;
begin
  conn := TRBConnection.Create(Currentsituation.CurrentPoint,Currentsituation.CurrentPointTouched);
  CurrentProject.AddConnection(conn);
  AddUndoAction(rbaAddConnection,conn,nil,conn.p1.point);
  ApplyConnAppearance(conn);
  CurrentSituation.CurrentConnection := conn;
  if FormOptions.NewConnFixed then
    conn.special := csFixed;
  if FormTrackProperties.Visible and (conn<>FormTrackProperties.Track) then
  begin
    FormTrackProperties.Track := conn;
    FormTrackProperties.FormShow(self);
  end;
  UpdateView();
end;

// Funktion:  ApplyConnAppearance
// Autor   : up
// Datum   : 17.2.03
// Beschr. : setzt abh. von aktuellen Optionen Aussehen dieser conn.
procedure TFrmEditor.ApplyConnAppearance(conn: TRBConnection);
begin
  if FormOptions.CopyTrackPropLast and (Currentsituation.CurrentConnection<>nil) then
  begin
    conn.CopyProperties(CurrentSituation.CurrentConnection,ptpGround);
    conn.CopyProperties(CurrentSituation.CurrentConnection,ptpBackGround);
    conn.CopyProperties(CurrentSituation.CurrentConnection,ptpSpeedlimit);
    conn.CopyProperties(CurrentSituation.CurrentConnection,ptpPoles);
    conn.CopyProperties(CurrentSituation.CurrentConnection,ptpTrack);
  end
  else
  if FormOptions.CopyTrackPropClip and (TrackPropertiesCopy<>nil) then
  begin
    conn.CopyProperties(TrackPropertiesCopy,ptpGround);
    conn.CopyProperties(TrackPropertiesCopy,ptpBackGround);
    conn.CopyProperties(TrackPropertiesCopy,ptpSpeedlimit);
    conn.CopyProperties(TrackPropertiesCopy,ptpPoles);
    conn.CopyProperties(TrackPropertiesCopy,ptpTrack);
  end
  else
  begin
    conn.CopyProperties(FormOptions.DefaultTrack,ptpEditor);
  end;

end;

procedure TFrmEditor.tbImproveConnectionClick(Sender: TObject);
var Point,Startpoint: TRBPoint;
    Conn: TRBConnection;
    P: TdoublePoint;
    a,anz: integer;
    i,j: integer;
    l,h,partlen: double;
begin
  if Currentsituation.CurrentConnection=nil then exit;

  P.x := (Currentsituation.CurrentConnection.P1.point.x+Currentsituation.CurrentConnection.P2.point.x)/2;
  P.y := (Currentsituation.CurrentConnection.P1.point.y+Currentsituation.CurrentConnection.P2.point.y)/2;
  h :=  (Currentsituation.CurrentConnection.P1.height+Currentsituation.CurrentConnection.P2.height)/2;
  Point := TRBPoint.Create(P);
  Point.height := h;
  conn := TRBConnection.Create(Currentsituation.CurrentConnection);
  conn.P1 := Point;
  conn.P2 := Currentsituation.CurrentConnection.P2;
  // Die folgende Änderung im Undo-Puffer speichern
  // verursacht av
  AddUndoAction(rbaChangeConnectionP2,Currentsituation.CurrentConnection,nil,Currentsituation.CurrentConnection.p2.point);
  Currentsituation.CurrentConnection.P2 := Point;
  CurrentProject.AddPoint(point);
  AddUndoAction(rbaAddPoint,point,nil,point.point);
  CurrentProject.AddConnection(conn);
  AddUndoAction(rbaAddConnection,conn,nil,conn.P1.point);
  CurrentProject.AddToSameRouteDefinitionAs(conn,Currentsituation.CurrentConnection);
  UpdateView();
end;

procedure TFrmEditor.addpoint1Click(Sender: TObject);
begin
  if(newpoint.x>0)and(newpoint.y>0) then
  begin
    Currentsituation.cursor := newpoint;
    tbNewPointClick(self);
  end;
end;

procedure TFrmEditor.addnewpointandconnect1Click(Sender: TObject);
var p1: TRBPoint;
    conn: TRBConnection;
    l,anz: integer;
begin
  if currentsituation.CurrentPoint=nil then exit;
  P1 := currentsituation.CurrentPoint;
  addpoint1click(self);
  Conn := TRBConnection.Create(P1,Currentsituation.CurrentPoint);
  CurrentProject.AddConnection(conn);
  ApplyConnAppearance(conn);
  Currentsituation.Currentconnection := conn;
  AddUndoAction(rbaAddConnection,conn,nil,conn.P1.point,1); // zusätzliche Aktion (addpoint) auch rückgängig machen, daher die 1
  if FormOptions.UseMinLength then
  begin
    ConnMinLength();
  end;
  if FormOptions.NewConnFixed then
    conn.special := csFixed;
  if FormTrackProperties.Visible and (conn<>FormTrackProperties.Track) then
  begin
    FormTrackProperties.Track := conn;
    FormTrackProperties.FormShow(self);
  end;
  UpdateView();
end;

procedure TFrmEditor.tbAddAndConnectClick(Sender: TObject);
begin
  newpoint := Currentsituation.cursor;
  addnewpointandconnect1Click(self);
end;

procedure TFrmEditor.tbImproveClick(Sender: TObject);
var l: double;
begin
  if Currentsituation.CurrentConnection=nil then exit;
  // Länge des Abschnitts (Luftlinie)
  l := distance(Currentsituation.CurrentConnection.P1.point,Currentsituation.CurrentConnection.P2.point);
  // Anzahl der neuen Abschnitte (Einzelabschnitte sind min. 25 m lang)
  ImproveConnection(l,2);
end;



procedure TFrmEditor.ImproveConnection(l: double; anz: integer);
var Point,Startpoint,Endpoint,Helppoint1,helppoint2: TRBPoint;
    Conn: TRBConnection;
    P: TDoublePoint;
    a: integer;
    i: integer;
    partlen,h: double;
    connlist: TObjectlist;
begin
  connlist := TObjectlist.Create;
  connlist.OwnsObjects := false;
  // Länge jedes der neuen Abschnitte
  partlen := l/anz;
  startpoint := Currentsituation.CurrentConnection.P1;
  endpoint := Currentsituation.CurrentConnection.P2;
  // Hilfspunkt 1
  CurrentProject.FindConnectionsAtPoint(startpoint,connlist,CurrentSituation.CurrentConnection);
  if connlist.count=0 then
  begin
    MessageDlg(lngmsg.GetMsg( 'ufrmeditor_nopts'), mtError, [mbCancel], 0);
    exit; // geht nicht
  end;
  conn := connlist[0] as TRBConnection;
  if conn.P1=startpoint then Helppoint1 := conn.p2 else Helppoint1 := conn.P1;
  connlist.clear();
  // Hilfspunkt 2
  CurrentProject.FindConnectionsAtPoint(endpoint,connlist,CurrentSituation.CurrentConnection);
  if connlist.count=0 then
  begin
    MessageDlg(lngmsg.GetMsg( 'ufrmeditor_nopts'), mtError, [mbCancel], 0);
    exit; // geht nicht
  end;
  conn := connlist[0] as TRBConnection;
  if conn.P1=endpoint then Helppoint2 := conn.p2 else Helppoint2 := conn.P1;
  connlist.clear();


  // zusätzliche Punkte
  for i:=1 to anz-1 do
  begin
    TRBPoint.BezierValue(Currentsituation.CurrentConnection.P1,
                Currentsituation.CurrentConnection.P2,
                Helppoint1, Helppoint2,
                i*partlen/l,cBezierFactorScr/l,p,h);
    // neuer sekundärer Point
    Point := TRBPoint.Create(p,h);
    CurrentProject.AddPoint(Point);
    // neue Connection
    Conn := TRBConnection.Create(startpoint,Point);
    Conn.CopyProperties(Currentsituation.CurrentConnection);
    startpoint := point;
    CurrentProject.AddConnection(conn);
    // falls in einer oder mehreren RouteDefinitions diese auch hinzufügen
    CurrentProject.AddToSameRouteDefinitionAs(conn,Currentsituation.CurrentConnection);
  end;
  // Verbindung zum letzten Punkt
  Conn := TRBConnection.Create(Point,Currentsituation.CurrentConnection.P2);
  Conn.CopyProperties(Currentsituation.CurrentConnection);
  CurrentProject.AddConnection(conn);
  // falls in einer oder mehreren RouteDefinitions diese auch hinzufügen
  CurrentProject.AddToSameRouteDefinitionAs(conn,Currentsituation.CurrentConnection);

  // alte löschen
  CurrentProject.DeletefromAllRouteDefinitions(Currentsituation.CurrentConnection);
  CurrentProject.DeleteConnection(Currentsituation.CurrentConnection);
  Currentsituation.CurrentConnection := nil;
  UpdateView();
  connlist.Free;
end;


procedure TFrmEditor.deletepoint1Click(Sender: TObject);
begin
  tbDelPointClick(sender);
end;

procedure TFrmEditor.deleteconnection1Click(Sender: TObject);
var conn: TRBConnection;
begin
  if currentsituation.CurrentConnection<>nil then
  begin
    // physikalische Kopie erstellen und in der Aktion merken
    conn := TRBConnection.Create(currentsituation.CurrentConnection);
    AddUndoAction(rbaDeleteConnection,conn,nil,conn.p1.point);
    // löschen
    Currentproject.DeleteConnection(currentsituation.CurrentConnection);
    currentsituation.CurrentConnection := nil;
    UpdateView();
  end;
end;

procedure TFrmEditor.addtocurrentrouteuntilswitch1Click(Sender: TObject);
var i: integer;
    connlist: TObjectlist;
    conn: TRBConnection;
begin
  if Currentsituation.CurrentPoint=nil then exit;
  if Currentsituation.CurrentConnection=nil then exit;
  if (Currentsituation.CurrentConnection.P1<>Currentsituation.CurrentPoint)
  and(Currentsituation.CurrentConnection.P2<>Currentsituation.CurrentPoint) then exit;

  // aktuelle Connection schonmal hinzufügen
  CurrentProject.AddTrackToCurrentRouteDefinition(Currentsituation.CurrentConnection);

  // los gehts
  connlist := TObjectlist.create();
  connlist.OwnsObjects := false;
  while CurrentProject.FindConnectionsAtPoint(Currentsituation.CurrentPoint,connlist)=2 do
  begin
    // lösche aktuelle connection aus der Liste
    if connlist[0]=Currentsituation.CurrentConnection then connlist.delete(0)
    else connlist.delete(1);
    // connlist[0] ist jetzt die übrige connection
    conn := connlist[0] as TRBConnection;

    // tu es
    // TODO: hier callback für andere Zwecke!
    CurrentProject.AddTrackToCurrentRouteDefinition(conn);

    Currentsituation.CurrentConnection := conn;
    // nächster Punkt
    if conn.P1=Currentsituation.CurrentPoint then
      Currentsituation.CurrentPoint :=conn.P2
    else
      Currentsituation.CurrentPoint :=conn.P1;
  end;
  connlist.free;
  UpdateView();
end;

procedure TFrmEditor.copyproperties1Click(Sender: TObject);
begin
  if TrackPropertiesCopy=nil then TrackPropertiesCopy := TRBConnection.create(nil,nil);
  TrackPropertiesCopy.CopyProperties(Currentsituation.CurrentConnection);
  UpdateView();
end;

procedure TFrmEditor.pasteproperties1Click(Sender: TObject);
begin
  if TrackPropertiesCopy<>nil then
  begin
    Currentsituation.CurrentConnection.CopyProperties(TrackPropertiesCopy,PropertiesToPaste);
    if FormTrackProperties.Visible and (Currentsituation.CurrentConnection=FormTrackProperties.Track) then
    begin
      FormTrackProperties.FormShow(self);
    end;
  end;
  UpdateView();
end;

procedure TFrmEditor.pastepropertiestocurrentroute1Click(Sender: TObject);
var i: integer;
    conn: TRBConnection;
begin
  if TrackPropertiesCopy<>nil then
  begin
    if Currentsituation.CurrentRouteDefinition= nil then exit;
    Screen.Cursor := crHourGlass;
    for i:=0 to Currentsituation.CurrentRouteDefinition.count-1 do
    begin
      conn := CurrentProject.FindConnectionByID(Currentsituation.CurrentRouteDefinition.GetConnIDAt(i));
      if conn<>nil then
        conn.CopyProperties(TrackPropertiesCopy,PropertiesToPaste);
      SetProgress(0,Currentsituation.CurrentRouteDefinition.count-1,i);
    end;
    Screen.Cursor := crArrow;
  end;
  UpdateView();
end;

procedure TFrmEditor.SetProgress(min,max,value: integer);
begin
  ProgressBar1.Min := min;
  ProgressBar1.Max := max;
  ProgressBar1.Position := value;
  if max=min then exit;
  lCurrentProgress.caption := inttostr((100*value) div (max-min)) + '%';
end;


procedure TFrmEditor.cbGotoStationChange(Sender: TObject);
var station: TRBStation;
    sl: TStringlist;
begin
  station := Currentproject.GetStationByIndex(cbGotoStation.itemindex);
  sl := Tstringlist.create;
  station.GetPlatformNumbers(sl);
  if sl.count>0 then
  begin
    CurrentSituation.CurrentConnection := CurrentProject.FindConnectionByID( station.GetTrackIDByPlatformNumber(sl[0]) );
    if CurrentSituation.CurrentConnection=nil then
    begin
      MessageDlg('Unexpected error: station refers to non existing connection id. '+#13+#10+'Deleting.', mtError, [mbOK], 0);
      station.DeletePlatform(sl[0]);
    end
    else
    begin
      Currentsituation.Offset.x := CurrentSituation.CurrentConnection.P1.point.x;
      Currentsituation.Offset.y := CurrentSituation.CurrentConnection.P1.point.y;
      Currentsituation.cursor.x := round(Currentsituation.offset.x);
      Currentsituation.cursor.y := round(Currentsituation.offset.y);
    end;
    UpdateView;
  end;
  sl.Free;
end;

procedure TFrmEditor.pastepropertiesuntilswitch1Click(Sender: TObject);
var i: integer;
    connlist: TObjectlist;
    conn: TRBConnection;
begin
  if Currentsituation.CurrentPoint=nil then exit;
  if Currentsituation.CurrentConnection=nil then exit;
  if (Currentsituation.CurrentConnection.P1<>Currentsituation.CurrentPoint)
  and(Currentsituation.CurrentConnection.P2<>Currentsituation.CurrentPoint) then exit;

  // aktuelle Connection
  Currentsituation.CurrentConnection.CopyProperties(TrackPropertiesCopy,PropertiesToPaste);

  // los gehts
  connlist := TObjectlist.create();
  connlist.OwnsObjects := false;
  while CurrentProject.FindConnectionsAtPoint(Currentsituation.CurrentPoint,connlist)=2 do
  begin
    // lösche aktuelle connection aus der Liste
    if connlist[0]=Currentsituation.CurrentConnection then connlist.delete(0)
    else connlist.delete(1);
    // connlist[0] ist jetzt die übrige connection
    conn := connlist[0] as TRBConnection;

    // tu es
    conn.CopyProperties(TrackPropertiesCopy,PropertiesToPaste);
    
    Currentsituation.CurrentConnection := conn;
    // nächster Punkt
    if conn.P1=Currentsituation.CurrentPoint then
      Currentsituation.CurrentPoint :=conn.P2
    else
      Currentsituation.CurrentPoint :=conn.P1;
  end;
  connlist.free;
  UpdateView();
end;

procedure TFrmEditor.PaintTSO(canvas: TCanvas; conn: TRBConnection; walllist: TRBWallList);
var TSOleft,TSOright,WallLeft,WallRight: TRBObject;
 function CutToComma(const s: string):string;
 begin
   if pos(',',s)>0 then
     result := copy(s,1,pos(',',s)-1)
   else
     result := s;
 end;
begin

  TSOLeft := nil;
  TSORight := nil;
  WallLeft := nil;
  WallRight := nil;

  // create dummy objects
  if conn.TSOLeft<>'' then
    TSOLeft   := TRBObject.Create('walls',CutToComma(conn.TSOLeft)+'_l.b3d');
  if conn.TSORight<>'' then
    TSORight  := TRBObject.Create('walls',CutToComma(conn.TSORight)+'_r.b3d');
  if conn.WallLeft<>'' then
    WallLeft  := TRBObject.Create('walls',CutToComma(conn.WallLeft)+'_l.b3d');
  if conn.WallRight<>'' then
    WallRight := TRBObject.Create('walls',CutToComma(conn.WallRight)+'_r.b3d');

  if TSOLeft<>nil then
  begin
    // positioned and rotated
    TSOLeft.point := conn.P1.point;
    TSOLeft.angle := round(conn.GetAngle(nil))-90;
    // draw
    PaintObject(canvas,TSOLeft,clGray,round(conn.GetLength));
    TSOLeft.free;
  end;

  if TSORight<>nil then
  begin
    // positioned and rotated
    TSORight.point := conn.P1.point;
    TSORight.angle := round(conn.GetAngle(nil))-90;
    // draw
    PaintObject(canvas,TSORight,clGray,round(conn.GetLength));
    TSORight.free;
  end;

  if WallLeft<>nil then
  begin
    // positioned and rotated
    WallLeft.point := conn.P1.point;
    WallLeft.angle := round(conn.GetAngle(nil))-90;
    // draw
    PaintObject(canvas,WallLeft,clGray,round(conn.GetLength));
    WallLeft.free;
  end;

  if WallRight<>nil then
  begin
    // positioned and rotated
    WallRight.point := conn.P1.point;
    WallRight.angle := round(conn.GetAngle(nil))-90;
    // draw
    PaintObject(canvas,WallRight,clGray,round(conn.GetLength));
    WallRight.free;
  end;

end;

procedure TFrmEditor.PaintObject(canvas: TCanvas; o: TRBObject; frameColor: TColor; differentLength: integer; delframe: boolean);
var cube: TDoubleCube;
    p1,p2,p3,p4: TDoublePoint;
    pix1,pix2,pix3,pix4: TPoint;
    conn: TRBConnection;
begin
  //
  with canvas do
  begin
    // points
    if o.boundtoConnID>0 then
    begin
      conn := CurrentProject.FindConnectionByID(o.boundtoConnID);
//      o.angle := round(o.angle + conn.GetAngle(nil));
      o.MaxCubeRotated(p1,p2,p3,p4,differentlength);
//      o.angle := round(o.angle - conn.GetAngle(nil));
      p1.x := p1.x + conn.P1.point.x + o.point.x;
      p2.x := p2.x + conn.P1.point.x + o.point.x;
      p3.x := p3.x + conn.P1.point.x + o.point.x;
      p4.x := p4.x + conn.P1.point.x + o.point.x;
      p1.y := p1.y + conn.P1.point.y + o.point.y;
      p2.y := p2.y + conn.P1.point.y + o.point.y;
      p3.y := p3.y + conn.P1.point.y + o.point.y;
      p4.y := p4.y + conn.P1.point.y + o.point.y;
      // TODO Rotate p1,p2,p3,4 around conn.P1.point by conn.angle
      turn(conn.p1.point,p1,90-conn.GetAngle(nil));
      turn(conn.p1.point,p2,90-conn.GetAngle(nil));
      turn(conn.p1.point,p3,90-conn.GetAngle(nil));
      turn(conn.p1.point,p4,90-conn.GetAngle(nil));
    end
    else
    begin
      conn := nil;
      o.MaxCubeRotated(p1,p2,p3,p4,differentlength);
      p1.x := p1.x + o.point.x;
      p2.x := p2.x + o.point.x;
      p3.x := p3.x + o.point.x;
      p4.x := p4.x + o.point.x;
      p1.y := p1.y + o.point.y;
      p2.y := p2.y + o.point.y;
      p3.y := p3.y + o.point.y;
      p4.y := p4.y + o.point.y;
    end;
    ConvertCoordWorldToPixel(p1,
         point(PBCursor.Width div 2,PBCursor.height div 2),
         Currentsituation.Offset,
         Currentsituation.Zoom,pix1);
    ConvertCoordWorldToPixel(p2,
         point(PBCursor.Width div 2,PBCursor.height div 2),
         Currentsituation.Offset,
         Currentsituation.Zoom,pix2);
    ConvertCoordWorldToPixel(p3,
         point(PBCursor.Width div 2,PBCursor.height div 2),
         Currentsituation.Offset,
         Currentsituation.Zoom,pix3);
    ConvertCoordWorldToPixel(p4,
         point(PBCursor.Width div 2,PBCursor.height div 2),
         Currentsituation.Offset,
         Currentsituation.Zoom,pix4);
    // TODO: checken ob alle pix1...4 im aktuellen Rechteck liegen
    if ptinrect(canvas.ClipRect,pix1)
    or ptinrect(canvas.ClipRect,pix2)
    or ptinrect(canvas.ClipRect,pix3)
    or ptinrect(canvas.ClipRect,pix4) then
    begin
      MoveTo(pix1.x,pix1.y);
      if o=Currentsituation.CurrentObjectTouched then
        Pen.Color := FreeObjTouchedColor
      else if o=Currentsituation.CurrentObject then
        Pen.Color := FreeObjSelectColor
      else
        Pen.Color := frameColor;
      Pen.Width := 1;
      if o.locked then
        Pen.Style := psDot
      else
        Pen.Style := psSolid;
      if delframe then
        Pen.Mode := pmXor
      else
        Pen.Mode := pmCopy;
      LineTo(pix2.X,pix2.y);
      LineTo(pix3.X,pix3.y);
      LineTo(pix4.X,pix4.y);
      LineTo(pix1.X,pix1.y);
    {  if not delframe then
      begin
        if (o=Currentsituation.CurrentObjectTouched) or (o=Currentsituation.CurrentObject) then
        begin
          Font := self.Font;
          Font.color := Pen.Color;
          Brush.Style := bsClear;
          TextOut(pix2.X,pix2.y,o.GetPath());
        end;
      end;   }
    end;
  end;
end;

// Funktion: PaintFreeObjects
// Autor   : up
// Datum   : 5.12.02
// Beschr. : zeichnet die FreeObjects
procedure TFrmEditor.PaintFreeObjects(canvas: TCanvas);
var i: integer;
begin
  for i:=0 to CurrentProject.FreeObjects.count-1 do
  begin
    PaintObject(canvas, CurrentProject.Freeobjects[i] as TRBObject);
  end;
end;

procedure TFrmEditor.addselectedobject1Click(Sender: TObject);
var o: TRBObject;
begin
//
  Currentsituation.cursor := newpoint;

  if (FormObjects.FrmObjects1.lvObjFolders.selected=nil)
  or (FormObjects.FrmObjects1.lvObjects.selected=nil) then exit;

  o := TRBObject.Create(FormObjects.FrmObjects1.lvObjFolders.selected.caption,FormObjects.FrmObjects1.lvObjects.selected.caption);
  o.point := CurrentSituation.Cursor;
  o.angle := 0;
  AddUndoAction(rbaAddObject,o,nil,o.point);
  CurrentProject.AddObject(o);
  UpdateView();
end;

procedure TFrmEditor.tbDelPointClick(Sender: TObject);
var p,p1,p2: TRBPoint;
    connlist: TObjectlist;
    pointlist: TObjectlist;
    conn: TRBConnection;
    i,z: integer;
begin
  //
  z := 0; // zählt zum Point-Löschen gehörende Undo-Schritte
  if Currentsituation.CurrentPoint<>nil then
  begin
    connlist := TObjectlist.Create();
    connlist.OwnsObjects := false;
    // suche Connections die diesen Punkt berühren
    p := Currentsituation.CurrentPoint;
    CurrentProject.FindConnectionsAtPoint(p,connlist);
    CurrentSituation.CurrentConnection := nil;
    if connlist.count>0 then
    begin
      if connlist.count=1 then
      begin
        conn := TRBConnection.create(connlist[0] as TRBConnection);
        if not CurrentProject.DeleteConnection(connlist[0] as TRBConnection) then exit;
        AddUndoAction(rbaDeleteConnection,conn,nil,conn.p1.point);
        inc(z);
      end
      else if connlist.count=2 then
      begin
        // eine der beiden muss gelöscht werden, die andere zum freien Punkt führen
        // ermittle die Punkte
        if (connlist[0] as TRBConnection).P1=p then
          P1 := (connlist[0] as TRBConnection).P2
        else
          P1 := (connlist[0] as TRBConnection).P1;
        if (connlist[1] as TRBConnection).P1=p then
          P2 := (connlist[1] as TRBConnection).P2
        else
          P2 := (connlist[1] as TRBConnection).P1;
        // lösche eine connection
        conn := TRBConnection.create(connlist[1] as TRBConnection);
        if not CurrentProject.DeleteConnection(connlist[1] as TRBConnection) then
        begin
          Updateview();
          exit;
        end;
        AddUndoAction(rbaDeleteConnection,conn,nil,conn.p1.point);
        inc(z);
        // lass die andere von P1 nach P2 laufen
        conn := connlist[0] as TRBConnection;
        AddUndoAction(rbaChangeConnectionP1,conn,conn.P1,conn.P1.point);
        AddUndoAction(rbaChangeConnectionP2,conn,conn.P2,conn.P2.point);
        inc(z,2);
        conn.P1 := P1;
        conn.P2 := P2;
        CurrentSituation.CurrentConnection := conn;
      end;

    end;

    AddUndoAction(rbaDeletePoint,p,nil,p.point,z);

    // lösche Punkt
    CurrentProject.DeletePoint(p);

    connlist.free;

    Currentsituation.CurrentPoint := nil;

    UpdateView();
  end;
end;

procedure TFrmEditor.tbAddObjClick(Sender: TObject);
begin
  addselectedobject1Click(sender);
end;

procedure TFrmEditor.straight1Click(Sender: TObject);
begin
  if CurrentSituation.CurrentConnection=nil then exit;
  CurrentSituation.CurrentConnection.special := csStraight;
  UpdateView();
end;

procedure TFrmEditor.curve1Click(Sender: TObject);
begin
  if CurrentSituation.CurrentConnection=nil then exit;
  CurrentSituation.CurrentConnection.special := csCurve;
  UpdateView();
end;

procedure TFrmEditor.deleteobject1Click(Sender: TObject);
var o: TRBObject;
begin
  if Currentsituation.CurrentObject<>nil then
  begin
    // erstelle physikalische Kopie des Objekts, damit es vollständig wiederhergestellt werden kann.
    o := TRBObject.Create(Currentsituation.CurrentObject);
    AddUndoAction(rbaDeleteObject,o,nil,Currentsituation.CurrentObject.point);
    // löschen
    CurrentProject.DeleteObject(Currentsituation.CurrentObject);
    Currentsituation.CurrentObject := nil;
    Currentsituation.CurrentObjectTouched := nil;
    UpdateView();
  end;
end;

procedure TFrmEditor.objectproperties1Click(Sender: TObject);
begin
  if Currentsituation.CurrentObject<>nil then
  begin
    FormFreeObjProperties.freeobj := Currentsituation.CurrentObject;
    if FormFreeObjProperties.showModal()=mrOK then
      UpdateView();
  end;
end;

procedure TFrmEditor.PBCursorDblClick(Sender: TObject);
begin
  if (CurrentSituation.CurrentConnection<>nil)and(Currentsituation.CurrentObjectTouched=nil) then
  begin
    FormTrackProperties.CurrentProject := CurrentProject;
    FormTrackProperties.UpdateFunc := UpdateView;
    FormTrackProperties.Track := CurrentSituation.CurrentConnection as TRBConnection;
    FormTrackProperties.FormShow(self);
    FormTrackProperties.show();
    wasdragging := true;
  end
  else
  if Currentsituation.CurrentObject<>nil then
  begin
    FormFreeObjProperties.freeobj := Currentsituation.CurrentObject;
    if FormFreeObjProperties.showModal()=mrOK then
    begin
      Currentsituation.CurrentObject.Reload();
      UpdateView();
    end;
    wasdragging := false;
    DraggingObject := nil;
    Currentsituation.CurrentObjectTouched := nil;
  end;


end;

procedure TFrmEditor.ground1Click(Sender: TObject);
begin
  Propertiestopaste := ptpGround;
  pastepropertiesuntilswitch1Click(sender);
end;

procedure TFrmEditor.allproperties3Click(Sender: TObject);
begin
  Propertiestopaste := ptpAll;
  pasteproperties1Click(sender);
end;

procedure TFrmEditor.ground2Click(Sender: TObject);
begin
  Propertiestopaste := ptpGround;
  pasteproperties1Click(sender);
end;

procedure TFrmEditor.background2Click(Sender: TObject);
begin
  Propertiestopaste := ptpBackground;
  pasteproperties1Click(sender);
end;

procedure TFrmEditor.speedlimit3Click(Sender: TObject);
begin
  Propertiestopaste := ptpSpeedlimit;
  pasteproperties1Click(sender);
end;

procedure TFrmEditor.poles3Click(Sender: TObject);
begin
  Propertiestopaste := ptpPoles;
  pasteproperties1Click(sender);
end;

procedure TFrmEditor.tracktype1Click(Sender: TObject);
begin
  Propertiestopaste := ptpTrack;
  pasteproperties1Click(sender);
end;

procedure TFrmEditor.allproperties1Click(Sender: TObject);
begin
  Propertiestopaste := ptpEditor;
  pastepropertiestocurrentroute1Click(sender);
end;

procedure TFrmEditor.groundonly1Click(Sender: TObject);
begin
  Propertiestopaste := ptpGround;
  pastepropertiestocurrentroute1Click(sender);
end;

procedure TFrmEditor.backgroundonly1Click(Sender: TObject);
begin
  Propertiestopaste := ptpBackground;
  pastepropertiestocurrentroute1Click(sender);
end;

procedure TFrmEditor.speedlimit1Click(Sender: TObject);
begin
  Propertiestopaste := ptpSpeedlimit;
  pastepropertiestocurrentroute1Click(sender);
end;

procedure TFrmEditor.poles1Click(Sender: TObject);
begin
  Propertiestopaste := ptpPoles;
  pastepropertiestocurrentroute1Click(sender);
end;

procedure TFrmEditor.tracktype2Click(Sender: TObject);
begin
  Propertiestopaste := ptpTrack;
  pastepropertiestocurrentroute1Click(sender);
end;

procedure TFrmEditor.allproperties2Click(Sender: TObject);
begin
  Propertiestopaste := ptpEditor;
  pastepropertiesuntilswitch1Click(sender);
end;

procedure TFrmEditor.background1Click(Sender: TObject);
begin
  Propertiestopaste := ptpBackground;
  pastepropertiesuntilswitch1Click(sender);
end;

procedure TFrmEditor.speedlimit2Click(Sender: TObject);
begin
  Propertiestopaste := ptpSpeedlimit;
  pastepropertiesuntilswitch1Click(sender);
end;

procedure TFrmEditor.poles2Click(Sender: TObject);
begin
  Propertiestopaste := ptpPoles;
  pastepropertiesuntilswitch1Click(sender);
end;

procedure TFrmEditor.tracktype3Click(Sender: TObject);
begin
  Propertiestopaste := ptpTrack;
  pastepropertiesuntilswitch1Click(sender);
end;

procedure TFrmEditor.cloneobject1Click(Sender: TObject);
var o: TRBObject;
begin
  if Currentsituation.CurrentObject<>nil then
  begin
    Currentsituation.cursor := newpoint;
    o := TRBObject.Create(Currentsituation.CurrentObject);
    o.point := CurrentSituation.Cursor;
    CurrentProject.AddObject(o);
    UpdateView();
  end;
end;



// FitPoint: verschiebt den aktuellen Punkt falls nötig für korrekten Parallelgleisabstand
procedure TFrmEditor.FitPoint;
var np: TRBPoint;
    i,j: integer;
    dist,a,b,dista: double;
    newdist: double;
    parallelConn: TRBConnection;

begin
  // suche Punkt in der Nähe (cParalleltrackdist+-cParalleltrackdev)
  for i:=0 to CurrentProject.Points.count-1 do
  begin
    if CurrentProject.Points[i]<>Currentsituation.CurrentPoint then
    begin
      dist := Distance((CurrentProject.Points[i] as TRBPoint).point,Currentsituation.CurrentPoint.point);
      dista := 0;
      if ((dist>=CurrentProject.ParallelTrackDist-cParalleltrackdev)
      and (dist<CurrentProject.ParallelTrackDist+cParalleltrackdev)) then dista := cParalleltrackdist;
      //if ((dist>=CurrentProject.ParallelTrackDistPlatf-cParalleltrackdev)
      //and (dist<CurrentProject.ParallelTrackDistPlatf+cParalleltrackdev)) then dista := cParalleltrackPlatformdist;
      if dista<>0 then
      begin
        // Position korrigieren
        // suche Parallel-Connection
        for j:=0 to CurrentProject.Connections.count-1 do
        begin
          if ((CurrentProject.Connections[j] as TRBConnection).P1=CurrentProject.Points[i] as TRBPoint) then
          begin
            parallelConn := CurrentProject.Connections[j] as TRBConnection;
            IsPointInSegment(parallelConn.P1.point,parallelConn.P2.point,Currentsituation.CurrentPoint.point,dista+cParalleltrackdev,a,b);
//            if angle(parallelConn.P2.point,parallelConn.P1.point) > angle(parallelConn.P2.point,Currentsituation.CurrentPoint.point) then
              newdist := -sgn(b)*dista;
//            else
  //            newdist := cParalleltrackdist;
            Currentsituation.CurrentPoint.point := parallelConn.GetPerpendicular1(newdist);
            break;
          end;
          if ((CurrentProject.Connections[j] as TRBConnection).P2=CurrentProject.Points[i] as TRBPoint) then
          begin
            parallelConn := CurrentProject.Connections[j] as TRBConnection;
            IsPointInSegment(parallelConn.P2.point,parallelConn.P1.point,Currentsituation.CurrentPoint.point,dista+cParalleltrackdev,a,b);
//            if angle(parallelConn.P1.point,parallelConn.P2.point) > angle(parallelConn.P1.point,Currentsituation.CurrentPoint.point) then
              newdist := -sgn(b)*dista;
//            else
  //            newdist := -cParalleltrackdist;
            Currentsituation.CurrentPoint.point := parallelConn.GetPerpendicular2(newdist);
            break;
          end;
        end;
        if dista = CurrentProject.ParallelTrackDist then exit;
      end;
    end;
  end;

end;

procedure TFrmEditor.ConnMinLength();
begin
  if Currentsituation.CurrentConnection=nil then exit;
  if Currentsituation.CurrentConnection.GetLength()<25 then
  begin
    Currentsituation.CurrentPoint.point :=
      Currentsituation.CurrentConnection.GetPointBetween(25/Currentsituation.CurrentConnection.GetLength());
  end;
end;

procedure TFrmEditor.lDownClick(Sender: TObject);
begin
  // down
  if Currentsituation.CurrentPoint<>nil then
  begin
    Currentsituation.CurrentPoint.point.y := Currentsituation.CurrentPoint.point.y - ArrowStepSize;
    updateView();
    exit;
  end;
  if Currentsituation.CurrentObject<>nil then
  begin
    Currentsituation.CurrentObject.point.y := Currentsituation.CurrentObject.point.y - ArrowStepSize;
    updateView();
    exit;
  end;
end;

procedure TFrmEditor.lUpClick(Sender: TObject);
begin
 // up
 if Currentsituation.CurrentPoint<>nil then
  begin
    Currentsituation.CurrentPoint.point.y := Currentsituation.CurrentPoint.point.y + ArrowStepSize;
    updateView();
    exit;
  end;
  if Currentsituation.CurrentObject<>nil then
  begin
    Currentsituation.CurrentObject.point.y := Currentsituation.CurrentObject.point.y + ArrowStepSize;
    updateView();
    exit;
  end;
end;

procedure TFrmEditor.lLeftClick(Sender: TObject);
begin
  // left
  if Currentsituation.CurrentPoint<>nil then
  begin
    Currentsituation.CurrentPoint.point.x := Currentsituation.CurrentPoint.point.x - ArrowStepSize;
    updateView();
    exit;
  end;
  if Currentsituation.CurrentObject<>nil then
  begin
    Currentsituation.CurrentObject.point.x := Currentsituation.CurrentObject.point.x - ArrowStepSize;
    updateView();
    exit;
  end;
end;

procedure TFrmEditor.lRightClick(Sender: TObject);
begin
  // right
  if Currentsituation.CurrentPoint<>nil then
  begin
    Currentsituation.CurrentPoint.point.x := Currentsituation.CurrentPoint.point.x + ArrowStepSize;
    updateView();
    exit;
  end;
  if Currentsituation.CurrentObject<>nil then
  begin
    Currentsituation.CurrentObject.point.x := Currentsituation.CurrentObject.point.x + ArrowStepSize;
    updateView();
    exit;
  end;
end;

procedure TFrmEditor.fixed1Click(Sender: TObject);
begin
  if CurrentSituation.CurrentConnection=nil then exit;
  CurrentSituation.CurrentConnection.special := csFixed;
  UpdateView();
end;

procedure TFrmEditor.SelectionAreaPoint11Click(Sender: TObject);
begin
  CurrentSituation.SelArea1 := Currentsituation.Cursor;
  UpdateView();
end;

procedure TFrmEditor.SelectionAreaPoint21Click(Sender: TObject);
begin
  CurrentSituation.SelArea2 := Currentsituation.Cursor;
  UpdateView();
end;

procedure TFrmEditor.tbTrackTypeSwitchStraightClick(Sender: TObject);
begin
  if CurrentSituation.CurrentConnection=nil then exit;
//  CurrentSituation.CurrentConnection.special := csSwitchStraight;
  UpdateView();
end;

procedure TFrmEditor.tbTrackTypeSwitchCurvedClick(Sender: TObject);
begin
  if CurrentSituation.CurrentConnection=nil then exit;
//  CurrentSituation.CurrentConnection.special := csSwitchCurve;
  UpdateView();
end;



procedure TFrmEditor.turntrack1Click(Sender: TObject);
var p: TRBPoint;
begin
  if Currentsituation.CurrentConnection<>nil then
  begin
    p := Currentsituation.CurrentConnection.P1;
    Currentsituation.CurrentConnection.P1 := Currentsituation.CurrentConnection.P2;
    Currentsituation.CurrentConnection.P2 := p;
    UpdateView();
  end;
end;

procedure TFrmEditor.cbTrackTypeChange(Sender: TObject);
begin
  if CurrentSituation.CurrentConnection=nil then exit;
  CurrentSituation.CurrentConnection.special := TConnectionSpecial( cbTrackType.ItemIndex );
  UpdateView();
end;

procedure TFrmEditor.make25mlong1Click(Sender: TObject);
begin
  //
  if CurrentSituation.CurrentConnection=nil then exit;
//  if Currentsituation.CurrentPoint=nil then exit;
  Currentsituation.CurrentConnection.P2.point :=
      Currentsituation.CurrentConnection.GetPointBetween(25/Currentsituation.CurrentConnection.GetLength());

  UpdateView();
end;

procedure TFrmEditor.tbGridsClick(Sender: TObject);
begin
  formGrids.project := CurrentProject;
  formGrids.Show;
end;

procedure TFrmEditor.SetScrollBars();
var m: TRBMinimap;
    pos: integer;
begin
  if CurrentProject=nil then exit;
  if CurrentProject.Connections.Count=0 then exit;
  if (ScrollBarVert.Visible=false)or(ScrollBarHor.Visible=false) then exit;
  m := TRBMinimap.create;
  m.CalculateBoundingRect( CurrentProject.Connections );
  try
  pos := m.boundingRect.Top-(round(Currentsituation.Offset.y+PBCursor.Height/Currentsituation.zoom/2)-m.boundingRect.Bottom);
  if (pos<m.boundingRect.Bottom)or(pos>m.boundingRect.Top)  then pos := (m.boundingRect.Bottom+m.boundingRect.Top)div 2;
  ScrollBarVert.SetParams(pos,
     m.boundingRect.Bottom,m.boundingRect.Top);
  ScrollBarVert.PageSize := round(PBCursor.Height/Currentsituation.zoom);
  ScrollBarVert.LargeChange := ScrollBarVert.PageSize;
  ScrollBarVert.SmallChange := ScrollBarVert.PageSize div 10;
  except
   on E: EInvalidOperation do ScrollBarVert.hide;
  end;

  try
  pos := round(Currentsituation.Offset.x-PBCursor.Width/Currentsituation.zoom/2);
  if (pos<m.boundingRect.Left)or(pos>m.boundingRect.Right)   then pos := (m.boundingRect.Left+m.boundingRect.Right)div 2;
  ScrollBarHor.SetParams(pos,
    m.boundingRect.Left,m.boundingRect.Right);
  ScrollBarHor.PageSize    := round(PBCursor.Width/Currentsituation.zoom);
  ScrollBarHor.LargeChange := ScrollBarHor.PageSize;
  ScrollBarHor.SmallChange := ScrollBarHor.PageSize div 10;
  except
  on E: EInvalidOperation do ScrollBarHor.hide;
  end;

  m.free;
end;

procedure TFrmEditor.ScrollBarVertScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  CurrentSituation.Offset.y := ScrollBarVert.Max-(ScrollPos-ScrollBarVert.Min) - ScrollBarVert.LargeChange div 2;
  UpdateView;
end;

procedure TFrmEditor.ScrollBarHorScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  CurrentSituation.Offset.x := ScrollPos+ScrollBarHor.PageSize div 2;
  UpdateView;
end;

procedure TFrmEditor.addtogrid1Click(Sender: TObject);
var grid: TRBGrid;
    conn,root: TRBConnection;
    x,z,_x,_z: integer;
    bestdist,d,maxdist: double;
    p1,p2, GridConst : TDoublepoint;
    found: boolean;
begin
  conn := Currentsituation.CurrentConnection;
  if conn=nil then exit;
  grid := CurrentSituation.CurrentGrid;
  if grid=nil then
    grid := CurrentProject.GetNearestGrid(conn.P1.point);
  if grid=nil then
    MessageDlg('No grid found.', mtError, [mbCancel], 0)
  else
  begin
     root := CurrentProject.FindConnectionByID(grid.RootConnection);
     found := grid.GetXZofPoint(conn.GetPointBetween(0.5),root.P1.point,_x,_z);
     if found then
     begin
       if not grid.IsConnInGrid(conn.id) then
       begin
         // einsetzen
         grid.AddConnection(conn.id,_x,_z);
         CurrentProject.SnapToGrid(conn,grid);
         if conn.special in [csStraight,csCurve] then conn.special := csFixed;
       end;
     end
     else
     begin
       MessageDlg('No grid slot found.', mtError, [mbCancel], 0);
     end;
     // Positionskorrektur abh. von Conn. Typ
     // TODO
     UpdateView();
  end;

end;

procedure TFrmEditor.deletefromgrid1Click(Sender: TObject);
var grid: TRBGrid;
    conn: TRBConnection;
begin
  conn := Currentsituation.Currentconnection;
  if conn=nil then exit;
  grid := CurrentProject.GetConnectionParentGrid(conn.id);
  if grid<>nil then
  begin
    grid.DeleteConnection(conn.id);
    UpdateView();
  end;
end;

procedure TFrmEditor.tbTracksClick(Sender: TObject);
begin
  FormGridTracks.EditorFrame := self;
  FormGridTracks.CurrentProject := CurrentProject;
  FormGridTracks.Show();
end;

procedure TFrmEditor.ToolButton6Click(Sender: TObject);
begin
//
  if CurrentProject<>nil then
  begin
    FormTimetables.currentProject := CurrentProject;
    FormTimetables.Show();
  end;
end;

procedure TFrmEditor.tb3DWorldClick(Sender: TObject);
begin
  if CurrentProject=nil then exit;
  Form3DPreview.project := CurrentProject;
  Form3DPreview.PreviewWorld(Currentsituation.Cursor);
end;

// Funktion: AddUndoAction
// Autor   : u
// Datum   : 3.11.03
// Beschr. : speichert eine Aktion im Undo-Puffer, bis er voll ist (cmaxUndoCount)
procedure TFrmEditor.AddUndoAction(Aaction: TRBAction; Aobj1,Aobj2: TObject; Apoint: TDoublePoint; AMore: integer);
var a: TRBActionItem;
    j: integer;
begin
  a.action := Aaction;
  a.obj1   := Aobj1;
  a.obj2   := Aobj2;
  a.p      := Apoint;
  a.more_Actions := AMore;
  // if count reaches max undo steps, delete oldest
  if undoCount >= cmaxUndoCount then
  begin
    // delete UndoAction[0], move Rest, dec(UndoCount);
    for j:=1 to undoCount do
    begin
      UndoAction[j-1] := UndoAction[j];
    end;
    dec(UndoCount);
    //setlength(UndoAction,UndoCount); // nicht nötig
  end;
  inc(UndoCount);
  setlength(UndoAction,UndoCount);
  UndoAction[UndoCount-1] := a;
end;

// Funktion: Undo
// Autor   : u
// Datum   : 3.11.03
// Beschr. : führt einen Undo-Schritt aus.
procedure TFrmEditor.Undo();
var a: TRBActionItem;
    p: TRBPoint;
    conn: TRBConnection;
    obj: TRBObject;
    j: integer;
begin
  // kein Undo-Eintrag vorhanden? Raus
  if UndoCount=0 then exit;

  // letzten Undo-Eintrag nehmen (LIFO=last in, first out)
  a := UndoAction[UndoCount-1];

  // Eintrag entfernen
  dec(UndoCount);
  setlength(UndoAction,UndoCount);

  // abhängig von der Action das Gegenteil tun, als wiederherstellen. Mit anderen Worten: Undo.
  case a.action of
    rbaNone: exit;
    rbaMovePoint:
     begin
      (a.obj1 as TRBPoint).point := a.p;
     end;
    rbaAddPoint:
     begin
      if(Currentsituation.CurrentPoint=a.obj1 as TRBPoint) then
        Currentsituation.CurrentPoint := nil;
      CurrentProject.DeletePoint(a.obj1 as TRBPoint);
     end;
    rbaDeletePoint:
     begin
      p := TRBPoint.Create(a.p);
      CurrentProject.AddPoint(p);
     end;
    rbaMoveObject:
     begin
      (a.obj1 as TRBObject).point := a.p;
     end;
    rbaAddObject:
     begin
      If(currentSituation.CurrentObject=a.obj1 as TRBObject) then
        currentSituation.CurrentObject := nil;
      CurrentProject.DeleteObject(a.obj1 as TRBObject);
     end;
    rbaDeleteObject:
     begin
      // Wichtig: Bei der Action muss eine physikalische Kopie des Objekts dranhängen!
      // Daher hier kein Create oder dergleichen
      (a.obj1 as TRBObject).point := a.p;
      CurrentProject.AddObject(a.obj1 as TRBObject);
     end;
    rbaAddConnection:
     begin
      if CurrentSituation.CurrentConnection=a.obj1 as TRBConnection then
        CurrentSituation.CurrentConnection := nil;
      CurrentProject.DeleteConnection(a.obj1 as TRBConnection);
     end;
    rbaDeleteConnection:
     begin
      // Wichtig: Bei der Action muss eine physikalische Kopie des Objekts dranhängen!
      // Daher hier kein Create oder dergleichen
      // TODO: Was passiert, wenn die Points gar nicht mehr existieren?
      CurrentProject.AddConnection(a.obj1 as TRBConnection);
      // TODO: Connection könnte in Grid und/oder RD(s) gewesen sein. Weitere Aktionen dafür einführen!
     end;
    rbaChangeConnectionP1:
     begin
      (a.obj1 as TRBConnection).P1 := (a.obj2 as TRBPoint);
     end;
    rbaChangeConnectionP2:
     begin
      (a.obj1 as TRBConnection).P2 := (a.obj2 as TRBPoint);
     end;
  end;
  // Rekursion, falls Mehrfachaktion
  if a.more_Actions>0 then
  begin
    for j :=1 to a.more_Actions do
      Undo();
  end
  else
    UpdateView();
end;


procedure TFrmEditor.tbSignalsClick(Sender: TObject);
begin
  //
  FormSignals.project := CurrentProject;
  if CurrentProject.Signals.count<>0 then
    FormSignals.Show;
end;

procedure TFrmEditor.height1Click(Sender: TObject);
begin
  Propertiestopaste := ptpHeight;
  pastepropertiesuntilswitch1Click(sender);

end;

procedure TFrmEditor.accuracy1Click(Sender: TObject);
begin
  Propertiestopaste := ptpAccuracy;
  pastepropertiesuntilswitch1Click(sender);

end;

procedure TFrmEditor.fog1Click(Sender: TObject);
begin
  Propertiestopaste := ptpFog;
  pastepropertiesuntilswitch1Click(sender);

end;

procedure TFrmEditor.adhesion1Click(Sender: TObject);
begin
  Propertiestopaste := ptpAdhesion;
  pastepropertiesuntilswitch1Click(sender);
end;

procedure TFrmEditor.SO1Click(Sender: TObject);
begin
  Propertiestopaste := ptpTSO;
  pasteproperties1Click(sender);
end;

procedure TFrmEditor.walls1Click(Sender: TObject);
begin
  Propertiestopaste := ptpWalls;
  pasteproperties1Click(sender);
end;

procedure TFrmEditor.SO2Click(Sender: TObject);
begin
  Propertiestopaste := ptpTSO;
  pastepropertiestocurrentroute1Click(sender);
end;

procedure TFrmEditor.walls2Click(Sender: TObject);
begin
  Propertiestopaste := ptpTSO;
  pastepropertiestocurrentroute1Click (sender);
end;

procedure TFrmEditor.SO3Click(Sender: TObject);
begin
  Propertiestopaste := ptpTSO;
  pastepropertiesuntilswitch1Click(sender);
end;

procedure TFrmEditor.walls3Click(Sender: TObject);
begin
  Propertiestopaste := ptpWalls;
  pastepropertiesuntilswitch1Click(sender);
end;

procedure TFrmEditor.tbPointHeightChange(Sender: TObject);
begin
  if Currentsituation.CurrentPoint<>nil then
  begin
    lPointHeight.Caption          := 'point h='+inttostr(tbPointHeight.Position)+'mm';
    Currentsituation.CurrentPoint.height := tbPointHeight.Position/1000;
  end;
end;

procedure TFrmEditor.lPointHeightClick(Sender: TObject);
begin
  tbPointHeight.Position := FormPointHeight.DoModal(tbPointHeight.Position);
  tbPointHeightChange(self);
end;

procedure TFrmEditor.smoothslope1Click(Sender: TObject);
var i: integer;
    connlist: TObjectlist;
    conn: TRBConnection;
begin
 { if Currentsituation.CurrentPoint=nil then exit;
  if Currentsituation.CurrentConnection=nil then exit;
  if (Currentsituation.CurrentConnection.P1<>Currentsituation.CurrentPoint)
  and(Currentsituation.CurrentConnection.P2<>Currentsituation.CurrentPoint) then exit;

  // aktuelle Connection


  // los gehts
  connlist := TObjectlist.create();
  connlist.OwnsObjects := false;
  while CurrentProject.FindConnectionsAtPoint(Currentsituation.CurrentPoint,connlist)=2 do
  begin
    // lösche aktuelle connection aus der Liste
    if connlist[0]=Currentsituation.CurrentConnection then connlist.delete(0)
    else connlist.delete(1);
    // connlist[0] ist jetzt die übrige connection
    conn := connlist[0] as TRBConnection;

    // tu es
//    conn.CopyProperties(TrackPropertiesCopy,PropertiesToPaste);
    
    Currentsituation.CurrentConnection := conn;
    // nächster Punkt
    if conn.P1=Currentsituation.CurrentPoint then
      Currentsituation.CurrentPoint :=conn.P2
    else
      Currentsituation.CurrentPoint :=conn.P1;
  end;
  connlist.free;
  UpdateView();  }
end;

end.
