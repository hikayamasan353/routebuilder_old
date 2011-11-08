object FrmEditor: TFrmEditor
  Left = 0
  Top = 0
  Width = 691
  Height = 480
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 152
    Top = 27
    Width = 4
    Height = 453
  end
  object PanelMainEditor: TPanel
    Left = 156
    Top = 27
    Width = 535
    Height = 453
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    Color = 16384
    TabOrder = 0
    object BgImageEditor: TImage
      Left = 25
      Top = 23
      Width = 496
      Height = 381
      Align = alClient
      Transparent = True
    end
    object PBCursor: TPaintBox
      Left = 25
      Top = 23
      Width = 496
      Height = 381
      Hint = 
        'hold shift to drag viewport. hold ctrl to set point, ctrl+shift ' +
        'to add point and connect'
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      PopupMenu = PopupMenu1
      ShowHint = False
    end
    object ScrollBarVert: TScrollBar
      Left = 521
      Top = 23
      Width = 13
      Height = 381
      Align = alRight
      Kind = sbVertical
      LargeChange = 10
      PageSize = 10
      TabOrder = 0
      TabStop = False
      OnScroll = ScrollBarVertScroll
    end
    object PanMainBottom: TPanel
      Left = 1
      Top = 417
      Width = 533
      Height = 35
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object lZoom: TLabel
        Left = 7
        Top = 21
        Width = 28
        Height = 13
        Caption = 'lZoom'
        Color = 2232572
        ParentColor = False
        Transparent = True
      end
      object Label1: TLabel
        Left = 91
        Top = 1
        Width = 48
        Height = 11
        Caption = 'goto station'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 184
        Top = 0
        Width = 58
        Height = 11
        Caption = 'cursor pos (m)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lCursorpos: TLabel
        Left = 184
        Top = 14
        Width = 14
        Height = 13
        Caption = 'X='
      end
      object lCurrentProgress: TLabel
        Left = 480
        Top = 12
        Width = 18
        Height = 11
        Caption = '0 %'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lThisTrack: TLabel
        Left = 384
        Top = 0
        Width = 37
        Height = 11
        Caption = 'this track'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lPDist: TLabel
        Left = 504
        Top = 11
        Width = 12
        Height = 13
        Caption = '...'
      end
      object lLeft: TLabel
        Left = 268
        Top = 12
        Width = 12
        Height = 12
        Caption = #231
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
        OnClick = lLeftClick
      end
      object lRight: TLabel
        Left = 282
        Top = 12
        Width = 12
        Height = 12
        Caption = #232
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
        OnClick = lRightClick
      end
      object lDown: TLabel
        Left = 276
        Top = 21
        Width = 10
        Height = 12
        Caption = #234
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
        OnClick = lDownClick
      end
      object lUp: TLabel
        Left = 276
        Top = 3
        Width = 10
        Height = 12
        Caption = #233
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
        OnClick = lUpClick
      end
      object lPointHeight: TLabel
        Left = 303
        Top = 22
        Width = 6
        Height = 13
        Caption = '0'
        Color = 2232572
        ParentColor = False
        Transparent = True
        OnClick = lPointHeightClick
      end
      object tbZoom: TTrackBar
        Left = 0
        Top = 1
        Width = 86
        Height = 21
        TabOrder = 1
        ThumbLength = 15
        OnChange = tbZoomChange
      end
      object cbGotoStation: TComboBox
        Left = 91
        Top = 12
        Width = 92
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 2
        Text = 'Start Station'
        OnChange = cbGotoStationChange
        Items.Strings = (
          'Start Station')
      end
      object ProgressBar1: TProgressBar
        Left = 384
        Top = 14
        Width = 65
        Height = 11
        TabOrder = 3
      end
      object tbPointHeight: TTrackBar
        Left = 296
        Top = 1
        Width = 86
        Height = 21
        Max = 20000
        Min = -20000
        PageSize = 100
        Frequency = 5000
        TabOrder = 4
        ThumbLength = 15
        OnChange = tbPointHeightChange
      end
      object EditDummy: TEdit
        Left = 248
        Top = 8
        Width = 17
        Height = 21
        TabOrder = 0
        Visible = False
      end
    end
    object ScrollBarHor: TScrollBar
      Left = 1
      Top = 404
      Width = 533
      Height = 13
      Align = alBottom
      LargeChange = 10
      PageSize = 10
      TabOrder = 2
      TabStop = False
      OnScroll = ScrollBarHorScroll
    end
    object PanelTop: TPanel
      Left = 1
      Top = 1
      Width = 533
      Height = 22
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      object RsRulerCorner1: TRsRulerCorner
        Left = 0
        Top = 0
        Width = 24
        Height = 22
        Hint = 'meter'
        Units = ruMeter
        Flat = True
        ScaleColor = clSilver
        TickColor = clWindowText
        Align = alLeft
        Position = cpLeftTop
        Color = clGreen
      end
      object RsRulerTop: TRsRuler
        Left = 24
        Top = 0
        Width = 509
        Height = 22
        Units = ruPixel
        Flat = True
        ScaleColor = clSilver
        TickColor = clWindowText
        Direction = rdTop
        ScaleDir = rsdNormal
        Scale = 100
        HairLine = False
        HairLinePos = -1
        HairLineStyle = hlsLine
        ShowMinus = True
        Align = alClient
        Color = clGreen
      end
    end
    object PanelLeft: TPanel
      Left = 1
      Top = 23
      Width = 24
      Height = 381
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 4
      object RsRulerLeft: TRsRuler
        Left = 0
        Top = 0
        Width = 24
        Height = 381
        Units = ruPixel
        Flat = True
        ScaleColor = clSilver
        TickColor = clWindowText
        Direction = rdLeft
        ScaleDir = rsdReverse
        Scale = 100
        HairLine = False
        HairLinePos = -1
        HairLineStyle = hlsLine
        ShowMinus = True
        Align = alClient
        Color = clGreen
      end
    end
  end
  object PanMap: TPanel
    Left = 0
    Top = 27
    Width = 152
    Height = 453
    Align = alLeft
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object ScrollBox1: TScrollBox
      Left = 1
      Top = 1
      Width = 150
      Height = 417
      HorzScrollBar.Tracking = True
      VertScrollBar.Tracking = True
      Align = alClient
      AutoSize = True
      Color = 16384
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 64
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      OnResize = ScrollBox1Resize
      DesignSize = (
        146
        413)
      object Image1: TImage
        Left = 0
        Top = 0
        Width = 300
        Height = 163
        AutoSize = True
      end
      object PaintBox1: TPaintBox
        Left = 0
        Top = 12
        Width = 137
        Height = 177
        Hint = 
          'click to set cursor. Ctl+Click to add point. Shift+Ctrl+click to' +
          ' add point and connect.'
        Anchors = []
        Color = 2517556
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        OnMouseMove = Image1MouseMove
        OnMouseUp = Image1MouseUp
        OnPaint = PaintBox1Paint
      end
    end
    object PanelMapBottom: TPanel
      Left = 1
      Top = 418
      Width = 150
      Height = 34
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object CoolBar1: TCoolBar
        Left = 0
        Top = 0
        Width = 150
        Height = 34
        Align = alClient
        AutoSize = True
        Bands = <
          item
            Break = False
            Control = tbMapZoom
            ImageIndex = -1
            Width = 62
          end
          item
            Break = False
            Control = EdMapCoord
            ImageIndex = -1
            MinHeight = 20
            Width = 43
          end
          item
            Break = False
            Control = ToolBar4
            ImageIndex = -1
            Width = 37
          end>
        object tbMapZoom: TTrackBar
          Left = 9
          Top = 0
          Width = 49
          Height = 25
          Hint = '1:1'
          Max = 4
          Min = 1
          ParentShowHint = False
          Position = 1
          ShowHint = True
          TabOrder = 0
          ThumbLength = 15
          OnChange = tbMapZoomChange
        end
        object ToolBar4: TToolBar
          Left = 118
          Top = 0
          Width = 24
          Height = 25
          Caption = 'ToolBar4'
          EdgeBorders = []
          Flat = True
          Images = ImageList2
          TabOrder = 1
          object tbBGImage: TToolButton
            Left = 0
            Top = 0
            Hint = 'change Map Background Image'
            Caption = 'tbBGImage'
            ImageIndex = 0
            ParentShowHint = False
            ShowHint = True
            OnClick = setminimapbackgroundimage1Click
          end
        end
        object EdMapCoord: TEdit
          Left = 73
          Top = 2
          Width = 30
          Height = 20
          BorderStyle = bsNone
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
        end
      end
    end
  end
  object CoolBar2: TCoolBar
    Left = 0
    Top = 0
    Width = 691
    Height = 27
    Bands = <
      item
        Break = False
        Control = ToolBar3
        ImageIndex = -1
        MinHeight = 22
        Width = 193
      end
      item
        Break = False
        Control = ToolBar1
        ImageIndex = -1
        MinHeight = 22
        Width = 492
      end>
    object ToolBar3: TToolBar
      Left = 9
      Top = 0
      Width = 180
      Height = 22
      AutoSize = True
      Caption = 'ToolBar1'
      EdgeBorders = []
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = ImageList1
      TabOrder = 0
      Wrapable = False
      object ToolButton5: TToolButton
        Left = 0
        Top = 0
        Hint = 'Route definitions...'
        Caption = 'ToolButton1'
        ImageIndex = 7
        ParentShowHint = False
        ShowHint = True
        OnClick = ToolButton1Click
      end
      object tbObjects: TToolButton
        Left = 23
        Top = 0
        Hint = 'objects'
        Caption = 'tbObjects'
        ImageIndex = 8
        ParentShowHint = False
        ShowHint = True
        OnClick = tbObjectsClick
      end
      object tbTrains: TToolButton
        Left = 46
        Top = 0
        Hint = 'trains'
        Caption = 'tbTrains'
        ImageIndex = 9
        ParentShowHint = False
        ShowHint = True
        OnClick = tbTrainsClick
      end
      object bStations: TToolButton
        Left = 69
        Top = 0
        Hint = 'stations'
        Caption = 'bStations'
        ImageIndex = 10
        ParentShowHint = False
        ShowHint = True
        OnClick = bStationsClick
      end
      object tbMap1: TToolButton
        Left = 92
        Top = 0
        Hint = 'Show/hide Map'
        Caption = 'tbMap1'
        ImageIndex = 11
        ParentShowHint = False
        ShowHint = True
        OnClick = tbMapClick
      end
      object tbTracks: TToolButton
        Left = 115
        Top = 0
        Hint = 'Grid Tracks'
        Caption = 'tbTracks'
        ImageIndex = 6
        ParentShowHint = False
        ShowHint = True
        OnClick = tbTracksClick
      end
      object ToolButton6: TToolButton
        Left = 138
        Top = 0
        Caption = 'ToolButton6'
        ImageIndex = 28
        OnClick = ToolButton6Click
      end
      object tbSignals: TToolButton
        Left = 161
        Top = 0
        Hint = 'Show Signals'
        Caption = 'tbSignals'
        ImageIndex = 30
        ParentShowHint = False
        ShowHint = True
        OnClick = tbSignalsClick
      end
    end
    object ToolBar1: TToolBar
      Left = 204
      Top = 0
      Width = 479
      Height = 22
      AutoSize = True
      Caption = 'ToolBar1'
      EdgeBorders = []
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = ImageList1
      TabOrder = 1
      Wrapable = False
      object tbNewPoint: TToolButton
        Left = 0
        Top = 0
        Caption = 'tbNewPoint'
        ImageIndex = 12
        OnClick = tbNewPointClick
      end
      object tbConnectPoints: TToolButton
        Left = 23
        Top = 0
        Hint = 'connect points'
        Caption = 'tbConnectPoints'
        Enabled = False
        ImageIndex = 13
        ParentShowHint = False
        ShowHint = True
        OnClick = connectpoints1Click
      end
      object tbAddAndConnect: TToolButton
        Left = 46
        Top = 0
        Hint = 'add and connect'
        Caption = 'tbAddAndConnect'
        ImageIndex = 15
        ParentShowHint = False
        ShowHint = True
        OnClick = tbAddAndConnectClick
      end
      object ToolButton4: TToolButton
        Left = 69
        Top = 0
        Width = 8
        Caption = 'ToolButton4'
        ImageIndex = 19
        Style = tbsSeparator
      end
      object cbTrackType: TComboBoxEx
        Left = 77
        Top = 0
        Width = 68
        Height = 22
        Hint = 'select special track type'
        ItemsEx = <
          item
            Caption = 'straight'
            ImageIndex = 0
            SelectedImageIndex = 0
          end
          item
            Caption = 'curved'
            ImageIndex = 1
            SelectedImageIndex = 1
          end
          item
            Caption = 'fixed'
            ImageIndex = 2
            SelectedImageIndex = 2
          end
          item
            Caption = 'switch'
            ImageIndex = 3
            SelectedImageIndex = 3
          end
          item
            Caption = 'switch'
            ImageIndex = 4
            SelectedImageIndex = 4
          end
          item
            Caption = 'switch'
            ImageIndex = 7
            SelectedImageIndex = 7
          end
          item
            Caption = 'switch'
            ImageIndex = 8
            SelectedImageIndex = 8
          end
          item
            Caption = 'curve'
            ImageIndex = 9
            SelectedImageIndex = 9
          end
          item
            Caption = 'curve'
            ImageIndex = 10
            SelectedImageIndex = 10
          end>
        Style = csExDropDownList
        Color = clGreen
        ItemHeight = 16
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = cbTrackTypeChange
        Images = ImageListTrackTypes
        DropDownCount = 11
      end
      object ToolButton3: TToolButton
        Left = 145
        Top = 0
        Width = 8
        Caption = 'ToolButton3'
        ImageIndex = 19
        Style = tbsSeparator
      end
      object tbProperties: TToolButton
        Left = 153
        Top = 0
        Hint = 'Track Properties'
        Caption = 'tbProperties'
        ImageIndex = 4
        ParentShowHint = False
        ShowHint = True
        OnClick = properties1Click
      end
      object tbDelPoint: TToolButton
        Left = 176
        Top = 0
        Hint = 'delete point and close route'
        Caption = 'tbDelPoint'
        ImageIndex = 17
        ParentShowHint = False
        ShowHint = True
        OnClick = tbDelPointClick
      end
      object tbImproveConnection: TToolButton
        Left = 199
        Top = 0
        Hint = 'add point in between'
        Caption = 'tbImproveConnection'
        ImageIndex = 14
        ParentShowHint = False
        ShowHint = True
        OnClick = tbImproveConnectionClick
      end
      object tbAddObj: TToolButton
        Left = 222
        Top = 0
        Hint = 'add selected object'
        Caption = 'tbAddObj'
        ImageIndex = 18
        ParentShowHint = False
        ShowHint = True
        OnClick = tbAddObjClick
      end
      object tbDelObj: TToolButton
        Left = 245
        Top = 0
        Hint = 'Delete Object'
        Caption = 'tbDelObj'
        ImageIndex = 21
        ParentShowHint = False
        ShowHint = True
        OnClick = deleteobject1Click
      end
      object tbObjProperties: TToolButton
        Left = 268
        Top = 0
        Hint = 'Object Properties'
        Caption = 'tbObjProperties'
        ImageIndex = 22
        ParentShowHint = False
        ShowHint = True
        OnClick = objectproperties1Click
      end
      object ToolButton1: TToolButton
        Left = 291
        Top = 0
        Width = 8
        Caption = 'ToolButton1'
        ImageIndex = 23
        Style = tbsSeparator
      end
      object tbSel1: TToolButton
        Left = 299
        Top = 0
        Caption = 'tbSel1'
        ImageIndex = 24
        OnClick = SelectionAreaPoint11Click
      end
      object tbSel2: TToolButton
        Left = 322
        Top = 0
        Caption = 'tbSel2'
        ImageIndex = 25
        OnClick = SelectionAreaPoint21Click
      end
      object ToolButton2: TToolButton
        Left = 345
        Top = 0
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 26
        Style = tbsSeparator
      end
      object tbGrids: TToolButton
        Left = 353
        Top = 0
        Hint = 'Manage Grids'
        Caption = 'Grids'
        ImageIndex = 1
        ParentShowHint = False
        ShowHint = True
        OnClick = tbGridsClick
      end
      object ToolButton7: TToolButton
        Left = 376
        Top = 0
        Width = 8
        Caption = 'ToolButton7'
        ImageIndex = 2
        Style = tbsSeparator
      end
      object tb3DWorld: TToolButton
        Left = 384
        Top = 0
        Hint = '3D World Preview'
        Caption = 'tb3DWorld'
        ImageIndex = 29
        ParentShowHint = False
        ShowHint = True
        Visible = False
        OnClick = tb3DWorldClick
      end
    end
  end
  object ImageList1: TImageList
    Left = 280
    Top = 56
    Bitmap = {
      494C01011F002200040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000009000000001002000000000000090
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000052434D0052435000514352005245
      55005246590052475C0052485F00534A6500534B6A00534C6C00524C6B005148
      61004F4355004D4251004B3F4B004A3E49000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000052434F0052445200524555005247
      590052485D00524A6200534B6700534D6D00534F740053507A0053517A005351
      7A00514C6D0050455A004F4354004F4250000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000005244510052455400524658005248
      5D00524A6300534C6A00534E71005350780053548300545A930054599100545C
      99005461AA005360AA00504A6B004F4457000000000000000000000000000000
      000000000000000000000000000000FF000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF000000
      00000000000000000000FFFFFF0000000000524553005246560052485B005249
      6100524C6800524F710052527C005460A1005576D5005585F0005587F2005588
      F6005585F400557FF2005479EB005472E0000000000000000000000000000000
      0000000000000000000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000524655005247590052495F00524B
      6500524E6E0052517A005469B2005485ED005491F800549DFD0054A3FF0054A1
      FF005497FD00548DF9005483F100547CE8000000000000000000000000000000
      0000000000000000000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00000000005247590052495E00524A6300524D
      6B0052517500546DB7005489ED005495F70054A7FE0055BBFF0055CAFF0055C4
      FF0054B1FF00549DFC00548EF5005484EA000000000000000000000000000000
      000000000000000000000000000000FF000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000051496000524C67005468A700536F
      B8005371BE005488E5005490EF00549FFA0054BAFF0056E1FF0058F9FF0057F2
      FF0055CFFF0054ADFE005498F700548AEB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF000000
      00000000000000000000FFFFFF0000000000525882005366A1005371BA005376
      C400537DD1005386DE005493EE0054A7FA0055C8FF0058F5FF00BDFFFF0087FF
      FF0056E6FF0055BAFF00549FF800548FEB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000005369A400536CAC005371B5005376
      BF00537DCC005387DA005494E90054A8F80056C8FF0059F2FF0078FFFF0069FF
      FF0057E6FF0055BDFE0054A2F5005491E8000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF000000
      00000000000000000000FFFFFF000000000053689F00536CA6005370AF005376
      B900537CC5005386D3005492E30054A3F30055BDFD0057DDFF005AF3FF0059EF
      FF0057D4FF0055B6FB00549FF1005490E2000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000052679900526BA000536FA8005374
      B200537ABD005382CB00548DDA00549BE80055ADF60057C1FD0057CFFF0057CE
      FF0056BDFC0055AAF5005499E800548CDA000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000005266940052699A00526DA1005371
      AB005377B500537EC0005487CE005492DC00559EE80056AAF20056B2F70056B1
      F70055A9F200559EE9005492DD005488D0000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      00008000000080000000800000000000000052648E0052679400526A9B00526F
      A2005373AC00537AB6005481C1005489CD005491D9005599E100559EE600559E
      E6005599E2005492D900548AD0005382C5000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000005262890052658E0052689500526B
      9B005270A3005375AC00537BB5005481BE005487C700548BCF00558FD200558F
      D300548CD0005488C9005482C200537DB9000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000526083005263880052668E005268
      9300526C9A005370A2005375A9005379B100547DB8005481BD005483C0005483
      C1005482BE00547EBA00537BB4005377AE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000515E7E0051608300516387005265
      8D0052689200526B9800526F9F005373A4005376AA005378AE00537AB100537A
      B1005379B0005377AC005375A8005371A3000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF00000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF000000000000FFFF
      000000000000FFFF000000000000FFFF000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF000000000000FFFF000000000000FFFF00000000
      0000FFFF000000000000FFFF0000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF0000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF0000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF0000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF0000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FF
      FF0000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000FF000000
      FF00000000000000000000000000000000000000000080000000FF000000FF00
      0000FF00000080000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000FF000000
      FF00FFFFFF000000000000000000000000000000000080000000FF00000000FF
      FF00FF000000800000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000080000000FF00000000FF
      FF00FF000000800000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000080000000FF000000FF00
      0000FF000000800000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000FFFF000000000000000000000000000000
      000000FFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000FFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00000000000000000000FFFF00000000000000
      00000000000000FFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF000000FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000FFFF0000FFFF0080808000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000FFFF0000FFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000FFFF00000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      000000000000000000000000FF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF000000000000FFFF0000FFFF000000000080808000C0C0C000000000000000
      0000C0C0C00000000000C0C0C000FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF000000000000FFFF0000FFFF00000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000FF000000FF0000FFFF0000FFFF0000000000FFFFFF000000
      000000FFFF0000FFFF00000000000000FF0080808000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000FFFFFF0000FFFF0000000000FFFFFF000000
      000000FFFF0000FFFF00000000000000FF000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000FF00000000000000000000FFFF0000FFFF000000000000FF
      FF0000FFFF0000000000000000000000FF0080808000C0C0C00000000000C0C0
      C0000000000000000000C0C0C000FFFFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000000000000000000000FF000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      00000000FF000000FF0000000000000000000000000000FFFF0000FFFF0000FF
      FF000000000000000000000000000000FF0080808000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000FFFFFF000000000000FFFF0000FFFF0000FF
      FF000000000000000000000000000000FF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF00000000000000000000000000000000000000000000FFFF000000
      00000000000000000000000000000000000080808000C0C0C000000000000000
      0000C0C0C00000000000C0C0C000FFFFFF00000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF000000FF000000FF00000000000000000000000000000000000000FF000000
      FF00000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000FF000000FF000000FF000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000FFFFFF00000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FF
      FF0000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000FFFFFF00000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      00000000FF00FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00000000000000FF000000FF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000FF000000FF000000FF000000
      FF00FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000FFFF000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000FFFF0000FFFF000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000000000000000000000000000FF000000FF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF000000000000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000000000000000FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF0000000000000000000000FF000000FF0000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000FFFFFF000000
      000000FFFF0000FFFF00000000000000FF000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      FF000000FF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF0000000000000000000000FF000000FF000000FF00000000000000
      00000000FF0000000000000000000000000000000000000000000000000000FF
      000000FF000000000000000000000000000000FFFF0000FFFF000000000000FF
      FF0000FFFF0000000000000000000000FF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF000000000000000000FFFF
      FF00000000000000000000000000000000000000FF000000FF00000000000000
      FF000000FF0000000000000000000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF000000000000000000000000000000FF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF000000000000000000FFFF
      FF0000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000FF000000FF000000FF
      000000FF000000FF000000FF000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000000000000000FF00FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000FF000000FF000000FF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      FF000000FF000000FF00000000000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000FF000000FF000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000FFFFFF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000FFFFFF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF0000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00000000000000000000000000FFFFFF00000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000FF000000FF000000FF000000FF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF00FFFFFF0000000000FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000FFFFFF0000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF00000000000000000000000000000000000000000000000000FFFF
      FF0000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF0000FFFF00000000000000000000000000000000000000FF00FFFF
      FF000000000000000000FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000080800000FFFF000080800000000000000000000000FF000000FF000000
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF00000000000000000000FF
      FF0000FFFF000080800000FFFF0000FFFF00000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000080800000FFFF00008080000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000800000C0C0C000008000000000
      00000080000000800000C0C0C00000800000008000000080000000800000C0C0
      C000008000000080000000800000008000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000FFFF0000FFFF0000FFFF0000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      FF00C0C0C00000000000000000000000000000800000C0C0C000008000000000
      00000000000000800000C0C0C00000800000008000000080000000800000C0C0
      C000008000000080000000800000008000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000FFFF0000FFFF0000FFFF0000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000008080
      8000808080000000000080808000808080000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C000C0C0C000C0C0C0000000
      FF000000FF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000FFFF0000FFFF0000FFFF0000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000800000C0C0C000008000000000
      FF000000FF0000800000C0C0C00000800000008000000080000000800000C0C0
      C000008000000080000000800000008000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000FFFF0000FFFF0000FFFF0000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000080000000
      8000000080000000800000008000000080000000800000000000000080000000
      8000000080000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000800000C0C0C000008000000080
      00000000000000000000C0C0C00000800000008000000080000000800000C0C0
      C000008000000080000000800000008000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000008000000080000000
      8000000080000000800000008000000080000000800000000000000080000000
      800000008000000080000000000000000000000000000000000000000000C0C0
      C0000000FF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00000000000000000000000000000800000C0C0C000008000000080
      00000000000000000000C0C0C00000800000008000000080000000800000C0C0
      C000008000000080000000800000008000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000008000000080000000
      8000000080000000800000008000000080000000800000000000000080000000
      800000008000000080000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      FF00C0C0C00000000000000000000000000000800000C0C0C000008000000080
      000000000000000000000000000000800000008000000080000000800000C0C0
      C00000800000008000000080000000800000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF0000000000000080000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000FFFF0000FFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000FFFF0000FFFF0000000000000000000000000000000000000080000000
      8000000080000000800000008000000080000000800000000000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000800000C0C0C000008000000080
      00000080000000000000C0C0C00000000000008000000080000000800000C0C0
      C00000800000008000000080000000800000000000000000000000FFFF0000FF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000800000C0C0C000008000000080
      000000800000000000000000000000000000000000000080000000800000C0C0
      C0000080000000800000008000000080000000000000000000000000000000FF
      FF0000FFFF0000000000FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C0000000FF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00000000000000000000000000000800000C0C0C000008000000080
      000000800000008000000000000000800000000000000000000000800000C0C0
      C000008000000080000000800000008000000000000000000000000000000000
      000000FFFF0000FFFF0000000000FFFFFF000000000000FFFF0000FFFF000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      FF00C0C0C00000000000000000000000000000800000C0C0C000008000000080
      00000080000000800000C0C0C00000000000008000000000000000000000C0C0
      C000008000000080000000800000008000000000000000000000000000000000
      00000000000000FFFF0000FFFF000000000000FFFF0000FFFF00000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C0000000000000000000C0C0C000000000000000
      FF000000FF00C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000800000C0C0C000008000000080
      00000080000000800000C0C0C000008000000000000000000000008000000000
      FF000000FF000080000000800000008000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000800000C0C0C000008000000080
      00000080000000800000C0C0C000008000000000FF000000FF0000800000C0C0
      C000000000000000000000800000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000800000C0C0C000008000000080
      00000080000000800000C0C0C000008000000000FF000000FF0000000000C0C0
      C000008000000000000000000000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000080000000800000FF000000FF
      000000FF000000FF000000FF0000000080000000800000FF000000FF000000FF
      000000FF000000FF000000008000000080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000800000008000000000000000
      000000FF000000000000000000000000800000008000000000000000000000FF
      0000000000000000000000008000000080000000000000000000000080000000
      00000000000000FF000000000000000000000000800000000000000000000000
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000000000000000
      000000FF000000000000000000000080800000808000000000000000000000FF
      0000000000000000000000808000008080000000000000000000000080000000
      0000000000000000800000000000000000000000800000000000000000000000
      8000000000000000000000000000000000000000000000000000C0C0C0000000
      00000000000000000000FFFFFF00C0C0C0000000800000000000000000000000
      0000000000000000000000000000000000000000000000FF000000FF000000FF
      000000FF000000FF000000FF0000C0C0C0000000800000000000000000000000
      0000000000000000000000000000000000000080800000808000000000000000
      000000FF000000000000000000000080800000808000000000000000000000FF
      0000000000000000000000808000008080000000000000000000000080000000
      00000000000000FF000000000000000000000000800000000000000000000000
      8000000000000000000000000000000000000000000000000000FFFFFF00C0C0
      C000000080000000800000008000FFFFFF00C0C0C00000008000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF0000FF
      000000FF00000000800000008000FFFFFF00C0C0C00000008000000000000000
      0000000000000000000000000000000000000080800000808000000000000000
      000000FF000000000000000000000080800000808000008080000000000000FF
      0000000000000000000000808000008080000000000000000000000080000000
      0000000000000000800000000000000000000000800000000000000000000000
      800000000000000000000000000000000000000000000000000000008000FFFF
      FF00C0C0C000000080000000800000008000FFFFFF00C0C0C000000000000000
      00000000000000000000000000000000000000000000000000000000800000FF
      000000FF0000000080000000800000008000FFFFFF00C0C0C000000000000000
      0000000000000000000000000000000000000080800000808000000000000000
      000000FF000000000000000000000080800000808000008080000000000000FF
      0000000000000000000000808000008080000000000000000000000080000000
      00000000000000FF000000008000000000000000800000008000000000000000
      8000000000000000000000000000000000000000000000000000000000000000
      8000FFFFFF00C0C0C000000000000000000000000000FFFFFF00C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000FFFFFF00C0C0C000000000000000000000000000FFFFFF00C0C0C0000000
      0000000000000000000000000000000000000080800000808000000000000000
      000000FF000000000000000000000080800000808000008080000000000000FF
      0000000000000000000000808000008080000000000000000000000080000000
      0000000000000000800000FF0000000000000000800000008000000000000000
      8000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00C0C0
      C000000080000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00C0C0C0000000000000000000FFFFFF00FFFFFF00C0C0
      C000000080000000000000000000000000000080800000808000000000000000
      000000FF000000000000000000000080800000808000008080000000000000FF
      0000000000000000000000808000008080000000000000000000000080000000
      0000000000000000800000000000000080000000800000000000000080000000
      8000000000000000000000000000000000000000000080808000C0C0C0000000
      000000000000C0C0C00000000000C0C0C000FFFFFF000000800000008000FFFF
      FF00C0C0C0000000800000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00C0C0C00000008000FFFFFF0000008000FFFF
      FF00C0C0C0000000800000000000000000000080800000808000000000000000
      000000FF000000000000000000000080800000808000008080000080800000FF
      0000000000000000000000808000008080000000000000000000000080000000
      000000000000000080000000000000FF00000000800000000000000000000000
      8000000000000000000000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF0000008000000080000000
      8000FFFFFF00C0C0C00000000000000000000000000000000000000000000000
      000000008000FFFFFF0000008000FFFFFF00C0C0C000FFFFFF00000080000000
      8000FFFFFF00C0C0C00000000000000000000080800000808000000000000000
      000000FF000000000000000000000080800000808000008080000080800000FF
      0000000000000000000000808000008080000000000000000000000080000000
      00000000800000000000000000000000000000FF000000000000000000000000
      8000000000000000000000000000000000000000000080808000C0C0C0000000
      0000C0C0C0000000000000000000C0C0C000FFFFFF00C0C0C000000000000000
      000000000000FFFFFF00C0C0C000000000000000000000000000000000000000
      000000008000FFFFFF000000800000008000FFFFFF00FFFFFF00000000000000
      000000000000FFFFFF00C0C0C000000000000080800000808000000000000000
      000000FF000000000000000000000080800000808000008080000080800000FF
      0000000000000000000000808000008080000000000000000000000080000000
      0000000080000000000000000000000000000000800000000000000000000000
      8000000000000000000000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00C0C0C0000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      000000000000FFFFFF00000000000000000000000000FFFFFF00C0C0C0000000
      00000000000000000000FFFFFF00000080000080800000808000000000000000
      000000FF000000000000000000000080800000808000008080000080800000FF
      0000000000000000000000808000008080000000000000000000000080000000
      80000000000000000000000000000000000000FF000000000000000000000000
      0000000080000000000000000000000000000000000080808000C0C0C0000000
      000000000000C0C0C00000000000C0C0C000FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00000000000000000000000000FFFFFF00FFFFFF00C0C0
      C000000080000000800000008000FFFFFF000080800000808000000000000000
      000000FF00000000000000000000008080000080800000000000008080000080
      8000000000000000000000808000008080000000000000000000000080000000
      0000000000000000000000000000000000000000800000000000000000000000
      0000000080000000000000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000008000FFFFFF00000080000000800000008000FFFFFF0000008000FFFF
      FF00C0C0C0000000800000008000000080000080800000808000000000000000
      000000FF00000000000000000000008080000080800000000000008080000080
      8000000000000000000000808000008080000000000000000000000080000000
      00000000000000000000000000000000000000FF000000000000000000000000
      0000000000000000800000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000008000FFFFFF00000080000000800000008000FFFFFF00000080000000
      8000FFFFFF00000000000000000000000000000080000000800000FF000000FF
      000000FF000000FF000000FF0000000080000000800000FF0000008080000000
      80000000800000FF000000008000000080000000000000000000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000800000008000000000000000
      000000FF00000000000000000000000080000000800000000000000000000000
      8000000080000000000000008000000080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000FFFFFF00C0C0
      C000000000000000000000000000FFFFFF0000008000000080000000800000FF
      000000FF00000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000008000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00C0C0C000000000000000000000000000C0C0C000000080000000800000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000800000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00C0C0C0000000800000008000FFFFFF0000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000800000000000000000000000000000000000000000000000000000FFFF
      FF00C0C0C0000000800000000000000000000000000000000000000000000000
      000000008000FFFFFF00C0C0C000000080000000000000FF000000FF000000FF
      000000FF000000FF000000FF0000C0C0C0000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000800000000000000000000000000000C0C0C00000008000000080000000
      8000FFFFFF00C0C0C00000008000000000000000000000000000000000000000
      00000000000000008000FFFFFF00C0C0C0000000000000000000FFFFFF0000FF
      000000FF00000000800000008000FFFFFF00C0C0C00000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      000000800000008000000080000000800000FFFFFF00C0C0C000000080000000
      800000008000FFFFFF00C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000000000000000800000FF
      000000FF0000000080000000800000008000FFFFFF00C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000080000000000000000000000000000000008000FFFFFF00C0C0C0000000
      00000000000000000000FFFFFF00C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000FFFFFF00C0C0C000000000000000000000000000FFFFFF00C0C0C0000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000000000000000000000000000000000000000000FFFFFF00C0C0
      C000000000000000000000000000FFFFFF00C0C0C00000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00C0C0C000000000000000000000000000FFFFFF00C0C0
      C000000080000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000800000000000000000000000000000000000000000000000000000FFFF
      FF00C0C0C000000080000000800000008000FFFFFF00C0C0C000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00C0C0C000000080000000800000008000FFFF
      FF00C0C0C0000000800000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000008000000000000000000000000000000000
      8000FFFFFF00C0C0C000000080000000800000008000FFFFFF00C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000FFFFFF00C0C0C00000008000000080000000
      8000FFFFFF00C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000000000000000000000000000000000000000000000000000000
      000000008000FFFFFF00C0C0C000000000000000000000000000FFFFFF00C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000008000FFFFFF00C0C0C000000000000000
      000000000000FFFFFF00C0C0C000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00C0C0C000000000000000000000000000FFFF
      FF00C0C0C0000000800000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00C0C0C0000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00C0C0C00000008000000080000000
      8000FFFFFF00C0C0C00000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000008000000000000000000000000000000000
      000000000000000000000000000000008000FFFFFF00C0C0C000000080000000
      800000008000FFFFFF00C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000008000FFFFFF00C0C0C0000000
      00000000000000000000FFFFFF00C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C0C0
      C000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000900000000100010000000000800400000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFF0000F81F000080000000F00F0000
      80000000F00F000080000000F00F000080000000F00F000080000000F00F0000
      80000000F00F000080000000F00F000080000000F00F000080000000F00F0000
      80000000F00F000080000000F00F000080000000F00F000080000000F00F0000
      FFFF0000F00F0000FFFF0000F81F0000FFFFFFFFFCFFFCFFF7FFFFFFFCFFFCFF
      FFFFFFFFFCFFFCFFF7FFFF83FCFFFCFFFFFFFF83FCFFFCFFF7FFAA83FCFFFCFF
      FFFFFF83FCFFFC7FF7FFFF83FC7FFC3FFFFFFFFFFC7FFC3FC1FFFFEFFC7FFD3F
      C1FFFFFFFC7FFD1FC155FFEFFCBFFD9FC1FFFFFFFCBFFD8FC1FFFFEFFCBFFD8F
      FFFFFFFFFCCFFCCFFFFFFFEFFCCFFCCFFFFFF000F000FFFFCFFFF000F000CF83
      CFFFF000F000C783EFFFF000F000E383EFFFE000E000F183EFFFE000E000F9BB
      EFFFF0000000F8BBF7FF78000000FC47F7FF38000000FE3FF7FFBA000000FF1F
      FBFF93040004FF9FFDFFC78C008CFF8FFE3FE3DF00DFFFC7FFC3C9FF00FFFFE3
      FFF31C7FFFFFFFF3FFFFBF7FFFFFFFFFFFE1FB7FF000FFFFFFC1F77FF000CFFF
      FFB3F77FF000CFFFFF3BF2FFF000F7FFFC97E1FFE000FBFFFB07C1FFE000FDFF
      E70FD3FFF000FDFFC39FBBFFF800FEFFC33FB673FC00FF7FC4FFB637E600FFBF
      BBFF6F27E704FFBFBBFF6F8F818CFFDF97FFDF8781DFFFEF0FFFDE23E7FFFFF3
      0FFFBCF9E7FFFFF39FFFBFFFFFFFFFFFFFFFFFFFFFFFFEEFFFFFFFF3FFF3FEEF
      FE7FFFC1FF81FDDFF00FFFA1FE71FDDFE007FF73FDF3FDBFE007FEF7F9E7FBBF
      E007FDEFF09FFBBFC003FBDFE07FF97FC003F7BFE9FFF0FFE007EF7FDDFFF0FF
      E007DEFFDDFFF9FFE003CDFFCBFFFFFFF00183FF87FFFFFFFE6087FF87FFFFFF
      FFF1CFFFCFFFFFFFFFFBFFFFFFFFFFFF8003FFFFFFFF000080038497E0070000
      8003000780030000800380037FFC00008003C003C003000080038003A0050000
      800380036006000000018003000000000001C01FFFFF00008003E79F00000000
      C003FF83A0050000E003FFFFC0030000F003FFFFE0070000F823FFFFFFEF0000
      FC63FFFF001F0000FEFFFFFFFFFF0000FFFFE7FF0000FFFFFFFFE7FF366CDB6F
      FDFF81FF366CDB6FDC7F807F366CDB6FC03FC03F362CDB6FC03FC03F362CD92F
      E39FE39F362CD92F8047F987362CDA4F8003F803360CDA6F8003F003360CD76F
      8039F039360CD76F801DFB9C360CCF77805FFB80364CDF77807FF000364CDF7B
      807FF0070000DFFFFFFFFFFF3664FFFFFFFFFFFFFF8E03FFFFFF0000FFE707FF
      FE3FDFF7EFF001FFFC3FDFF7E3F0807FFC7FDFF701F8C03FF87F000001FEC03F
      F8FFDFF71CFFE39FC0FFDFF7CE3FF9C7C1FFDFF7E01FFC03C07F0000E01FFC03
      C0FFDFF7F1CFFE39C1FFDFF7FCE3FF9DC3FFDFF7FE01FFDFC7FF0000FE01FFFF
      CFFFFFFFFF1CFFFFFFFFFFFFFFCEFFFF00000000000000000000000000000000
      000000000000}
  end
  object PopupMenu1: TPopupMenu
    Images = ImageList1
    OnPopup = PopupMenu1Popup
    Left = 488
    Top = 120
    object addpoint1: TMenuItem
      Caption = 'add new &point'
      ImageIndex = 12
      OnClick = addpoint1Click
    end
    object deletepoint1: TMenuItem
      Caption = '&delete point and close route'
      ImageIndex = 17
      OnClick = deletepoint1Click
    end
    object connectpoints1: TMenuItem
      Caption = '&connect points'
      ImageIndex = 13
      OnClick = connectpoints1Click
    end
    object deleteconnection1: TMenuItem
      Caption = 'delete connection'
      OnClick = deleteconnection1Click
    end
    object addnewpointandconnect1: TMenuItem
      Caption = 'add new point and connect'
      OnClick = addnewpointandconnect1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object properties1: TMenuItem
      Caption = '&track properties...'
      OnClick = properties1Click
    end
    object specialtrack1: TMenuItem
      Caption = '&special track'
      object curve1: TMenuItem
        Caption = 'curve'
        ImageIndex = 20
        OnClick = curve1Click
      end
      object straight1: TMenuItem
        Caption = 'straight'
        ImageIndex = 19
        OnClick = straight1Click
      end
      object fixed1: TMenuItem
        Caption = 'fixed'
        ImageIndex = 23
        OnClick = fixed1Click
      end
    end
    object make25mlong1: TMenuItem
      Caption = 'make &25m long'
      OnClick = make25mlong1Click
    end
    object turntrack1: TMenuItem
      Caption = '&turn track'
      OnClick = turntrack1Click
    end
    object smoothslope1: TMenuItem
      Caption = 'smooth slope'
      OnClick = smoothslope1Click
    end
    object copyproperties1: TMenuItem
      Caption = '&copy properties'
      Enabled = False
      OnClick = copyproperties1Click
    end
    object pasteproperties1: TMenuItem
      Caption = '&paste properties'
      Enabled = False
      object allproperties3: TMenuItem
        Caption = 'all properties'
        ShortCut = 16470
        OnClick = allproperties3Click
      end
      object ground2: TMenuItem
        Caption = 'ground'
        OnClick = ground2Click
      end
      object background2: TMenuItem
        Caption = 'background'
        OnClick = background2Click
      end
      object speedlimit3: TMenuItem
        Caption = 'speed limit'
        OnClick = speedlimit3Click
      end
      object poles3: TMenuItem
        Caption = 'poles'
        OnClick = poles3Click
      end
      object tracktype1: TMenuItem
        Caption = 'track type'
        OnClick = tracktype1Click
      end
      object SO1: TMenuItem
        Caption = 'TSO'
        OnClick = SO1Click
      end
      object walls1: TMenuItem
        Caption = 'walls'
        OnClick = walls1Click
      end
    end
    object pastepropertiestocurrentroute1: TMenuItem
      Caption = 'paste properties to current route'
      object allproperties1: TMenuItem
        Caption = 'all properties'
        OnClick = allproperties1Click
      end
      object groundonly1: TMenuItem
        Caption = 'ground'
        OnClick = groundonly1Click
      end
      object backgroundonly1: TMenuItem
        Caption = 'background'
        OnClick = backgroundonly1Click
      end
      object speedlimit1: TMenuItem
        Caption = 'speedlimit'
        OnClick = speedlimit1Click
      end
      object poles1: TMenuItem
        Caption = 'poles'
        OnClick = poles1Click
      end
      object tracktype2: TMenuItem
        Caption = 'track type'
        OnClick = tracktype2Click
      end
      object SO2: TMenuItem
        Caption = 'TSO'
        OnClick = SO2Click
      end
      object walls2: TMenuItem
        Caption = 'walls'
        OnClick = walls2Click
      end
    end
    object pastepropertiesuntilswitch1: TMenuItem
      Caption = 'paste properties until switch'
      object allproperties2: TMenuItem
        Caption = 'all properties'
        OnClick = allproperties2Click
      end
      object ground1: TMenuItem
        Caption = 'ground'
        OnClick = ground1Click
      end
      object background1: TMenuItem
        Caption = 'background'
        OnClick = background1Click
      end
      object speedlimit2: TMenuItem
        Caption = 'speed limit'
        OnClick = speedlimit2Click
      end
      object poles2: TMenuItem
        Caption = 'poles'
        OnClick = poles2Click
      end
      object tracktype3: TMenuItem
        Caption = 'track type'
        OnClick = tracktype3Click
      end
      object height1: TMenuItem
        Caption = 'height'
        OnClick = height1Click
      end
      object accuracy1: TMenuItem
        Caption = 'accuracy'
        OnClick = accuracy1Click
      end
      object fog1: TMenuItem
        Caption = 'fog'
        OnClick = fog1Click
      end
      object adhesion1: TMenuItem
        Caption = 'adhesion'
        OnClick = adhesion1Click
      end
      object SO3: TMenuItem
        Caption = 'TSO'
        OnClick = SO3Click
      end
      object walls3: TMenuItem
        Caption = 'walls'
        OnClick = walls3Click
      end
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object addselectedobject1: TMenuItem
      Caption = 'add &object from browser'
      ImageIndex = 18
      OnClick = addselectedobject1Click
    end
    object deleteobject1: TMenuItem
      Caption = 'delete object'
      ImageIndex = 21
      OnClick = deleteobject1Click
    end
    object cloneobject1: TMenuItem
      Caption = 'clone object'
      OnClick = cloneobject1Click
    end
    object objectproperties1: TMenuItem
      Caption = 'object properties...'
      ImageIndex = 22
      OnClick = objectproperties1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object PopupMenuaddtocurrentroute: TMenuItem
      Caption = 'add to current route'
      OnClick = PopupMenuaddtocurrentrouteClick
    end
    object addtocurrentrouteuntilswitch1: TMenuItem
      Caption = 'add to current route until switch'
      OnClick = addtocurrentrouteuntilswitch1Click
    end
    object PopupMenudeletefromcurrentroute: TMenuItem
      Caption = 'delete from current route'
      OnClick = PopupMenudeletefromcurrentrouteClick
    end
    object addtogrid1: TMenuItem
      Caption = 'add to grid'
      OnClick = addtogrid1Click
    end
    object deletefromgrid1: TMenuItem
      Caption = 'delete from grid'
      OnClick = deletefromgrid1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object SelectionAreaPoint11: TMenuItem
      Caption = 'selection area point 1'
      ImageIndex = 24
      OnClick = SelectionAreaPoint11Click
    end
    object SelectionAreaPoint21: TMenuItem
      Caption = 'selection area point 2'
      ImageIndex = 25
      OnClick = SelectionAreaPoint21Click
    end
  end
  object Timer1: TTimer
    Interval = 250
    OnTimer = Timer1Timer
    Left = 216
    Top = 64
  end
  object ImageList2: TImageList
    Left = 208
    Top = 352
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF000000
      0000008080000080800000808000008080000080800000808000008080000080
      8000008080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF00000000000080800000808000008080000080800000808000008080000080
      8000008080000080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      FFFF000000000000001F000000000000000F0000000000000007000000000000
      000300000000000000010000000000000001000000000000001F000000000000
      001F000000000000001F0000000000008FF1000000000000FFF9000000000000
      FF75000000000000FF8F00000000000000000000000000000000000000000000
      000000000000}
  end
  object ImageListTrackTypes: TImageList
    Left = 192
    Top = 40
    Bitmap = {
      494C01010B000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF0000000000000000000000FF000000
      FF000000000000000000000000000000000000000000000000000000FF000000
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF0000000000000000000000FF000000
      FF000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF0000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF0000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000080000000FF000000FF00
      0000FF0000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00FFFFFF000000000000000000000000000000000080000000FF00000000FF
      FF00FF0000008000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000080000000FF00000000FF
      FF00FF0000008000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000080000000FF000000FF00
      0000FF0000008000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00000000000000000000FFFF00000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000FFFF00000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000FF000000FF00000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FCFFFF3FFCFF0000FCFFFF3FFCFF0000
      FCFFFF3FFCFF0000FCFFFF3FFCFF0000FCFFFF3FFCFF0000FCFFFF3FFCFF0000
      FC7FFE7FFE7F0000FC3FFE7FFE7F0000FC3FFC7FFE3F0000FD3FFCFFFF3F0000
      FD1FF8FFFF1F0000FD9FF9FFFF9F0000FD8FF1FFFF8F0000FD8FE3FFFFC70000
      FCCFC7FFFFE30000FCCFCFFFFFF30000FF3FF33FF33FFCFFFF3FF33FF33FFCFF
      FF3FFD3FF1BFFCFFFF3FFD3FF1BFFCFFFF3FFD3FF9BFFCFFFF3FFE3FF8BFFCFF
      FE3FFE3FFCBFFCFFFC3FFE3FFC3FFC7FFC3FFE3FFC3FFC7FFCBFFF3FFE3FFC7F
      F8BFFF3FFF3FFC7FF9BFFF3FFF3FFCBFF1BFFF3FFF3FFCBFF1BFFF3FFF3FFCBF
      F33FFF3FFF3FFCCFF33FFF3FFF3FFCCFFFFFFFFFFFFFFF3FCFFFCFFFCF83FF3F
      CFFFCFFFC783FF3FF7FFEFFFE383FF3FFBFFEFFFF183FF3FFDFFEFFFF9BBFF3F
      FDFFEFFFF8BBFF3FFEFFF7FFFC47FE3FFF7FF7FFFE3FFE3FFFBFF7FFFF1FFE3F
      FFBFFBFFFF9FFE3FFFDFFDFFFF8FFD3FFFEFFE3FFFC7FD3FFFF3FFC3FFE3FD3F
      FFF3FFF3FFF3F33FFFFFFFFFFFFFF33F00000000000000000000000000000000
      000000000000}
  end
end
