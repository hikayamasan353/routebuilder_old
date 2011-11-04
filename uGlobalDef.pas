unit uGlobalDef;

interface

uses graphics;

const
      PixelPerMeter= 10; // Zoomfaktor. 10 Pixel sind 1 Meter, die theoretische Auflösung beträgt 0,1 Meter.
      MinCurve = 100;
      CurveRadStep = 20;
      VersionString  = '1.5.1 (2009-03-07)';
      ProgramName = 'RouteBuilder';
      HomepageURL  = 'http://routebuilder.bve-routes.com/';
      Homepage2URL  = 'http://routebuilder.bve-tools.com/';
      Homepage3URL  = 'http://routebuilder.bve-tools.com/';
      HomepageFURL  = 'http://980.rapidforum.com/area=25&order=u&search=';
      Licensefilename = 'license.txt';
      StructureViewerName = 'strview.exe';
      ScrollBoxCursorYOffset = 250;
      ScrollBoxCursorXOffset = 250;
      MinVertSpaceAboveCursor= 100;
      DefaultSwitchRadius    = 180;
      EditorScrollBarSmallStep = 1; // in m
      EditorScrollBarBigStep   = 25; // in m
      cConnBorderWidth         = 1;
      ExportAfterEndStation    = 500;
      TrackSegmentLength       = 0.4;  // in m
      PlatformDistance         = 1.8 ; // in m
      PlatformWidth            = 5.2 ; // in m
      WallDistance             = 2.5 ; // in m
      PoleLineLen              = 2.5 ; // in m
      cMaxLenImprove           = 5;//5; // Connection-Länge, ab der bezier-Verbesserung vorgenommen wird
      cBezierFactor            = 21; // 22;
      cBezierFactorScr         = 17; // 22;
      cBezierHelpPointDistance = 0.01;
      cParalleltrackdist       = 4.0; // Abstand Parallelgleis
      cParalleltrackPlatformdist=15.0; // Abstand Parallelgleis Bahnsteige
      cParalleltrackdev        = 1.0; // war 0.5 // in m, maximale Abstandsvariation für Erkennung eines Parallelgleises
      cSwitchdev               = 1.5; // in m, Abstand, unterhalb dessen eine Weiche erzeugt wird
      cSwitchdevsec            = 3; // in m, Abstand, unterhalb dessen eine Weiche erzeugt wird bei Sekundärgleisen/weichen
      cSearchWidth             = 100; // Breite (nach links und rechts) für die Suche nach Nebengleisen und Objekten
      cTrainSupressXOffset     = 3;   // Breite, innerhalb derer trains-Freeobjekte auf dem Hauptgleis unterdrückt werden
      cPerpendicularSearchDist = 0.025; // (war 0.2) Entfernung von Anfang/Ende der Connection, wo die Senkrechte gesetzt wird, um Paralleltracks zu suchen
      cKurvenueberhoehungfaktorDef =  1.37;
      cHyperbolCurveConst      = 6.5;

      cMaxGridSize             = 100;

      cMaxLoopClickOnlyCounter = 3;

      RailGaugePix = 16; // eigentlich 14,35. Spurweite in Pixeln. Gerade wegen Symmetrie.
      CrossTieLength=RailGaugePix+4; //Schwellenlänge
      TrackWidth   = 21; // Gesamtbreite des Schienenkörpers (=Schwellenlänge)
      TrackXOffset = 70;
      TrackComponentWidth =TrackWidth+TrackXOffset*2;
      TrackLengthDef=250; // Standardlänge eines Gleisstücks (=25m)
      HotspotXOffset=10; // Abstand linke Kante - Gleismitte-Pixel
      cStopsignXOffset=0.95*cParalleltrackdist/2; // Abstand des Halt-Schildes von Gleismitte
      cSwitchCurveAngle = 156.583; // Abzweigwinkel bei einer Weiche, NEIN, Radius!!!
      cUseCache = true;

      cMaxSecTrackNumber=15;  // höchste Nummer eines Sekundärtracks

      crTurnCursor = 501;

      TrackColor = $008080FF;//clWhite;
      TrackColorMap = clBlack;
      TrackColorRoute = clGreen;
      TrackColorStation = clBlue;
      TrackColorCurrent = clPurple;
      TrackColorError = clRed;
      TrackColorCatenary = $00C08000;
      TrackColorTrack = $008080FF;
      TrackColorGridRoot = $00208020;
      GridColor = $0040e040;
      CrossTieColor          = clMaroon; // Schwellenfarbe
      CrossTieColorSel       = $003040e0; // Schwellenfarbe der aktuellen Route
      TrackColorPlatform = $00aaaaaa;
      TrackColorRoof = $00666666;
      SelAreaColor = clAqua;
      FreeObjTouchedColor = $000080FF;
      FreeObjSelectColor = $002210FC;
      FreeObjColor = clYellow;

      cmaxUndoCount = 100; // Anzahl Undo-Schritte

      objectdef_placeholder = '###objectdef_placeholder###';
      traindef_placeholder  = '###traindef_placeholder###';

type
      TDoublePoint = record
                        x,y: double;
                     end;
      TDoubleRect  = record
                       left,right,top,bottom: double;
                     end;
      TDoubleCube  = record
                       x1,x2,y1,y2,z1,z2: double;
                     end;
      TPDoubleCube = ^TDoubleCube;

      TGetIntProc = procedure(i: integer) of object;

      TPropertiestopaste = (ptpAll,ptpEditor,ptpGround,ptpBackground,ptpSpeedlimit,
              ptpPoles,ptpTrack,ptpWalls,ptpFog,ptpAccuracy,ptpHeight,ptpAdhesion,ptpTSO);
      TSwitchDirection = (spLeft,spRight);
      TConnectionSpecial = (csStraight,csCurve,csFixed,
           csSwitchLeftUpStraight,csSwitchLeftUpCurve,
           csSwitchRightUpStraight,csSwitchRightUpCurve,
           csFixedCurveLeft,csFixedCurveRight
           );

      TRBAction = (rbaNone,rbaMovePoint,rbaAddPoint,rbaDeletePoint,
                   rbaMoveObject,rbaAddObject,rbaDeleteObject,
                   rbaAddConnection,rbaDeleteConnection,
                   rbaChangeConnectionP1,rbaChangeConnectionP2);

      TRBActionItem = record
                        action: TRBAction;
                        obj1,obj2: TObject;
                        p: TDoublePoint;
                        more_Actions: integer;
                      end;
      TUpdateFuncType = procedure (sender: TObject; repaint: boolean) of object;

implementation

end.
