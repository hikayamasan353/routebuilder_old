object FormProjectProperties: TFormProjectProperties
  Left = 373
  Top = 150
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Project Properties'
  ClientHeight = 390
  ClientWidth = 479
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShortCut = FormShortCut
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 349
    Width = 479
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      479
      41)
    object Button1: TButton
      Left = 389
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 308
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 479
    Height = 349
    ActivePage = TabSheet2
    Align = alClient
    TabIndex = 1
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Main'
      object leProjectname: TLabeledEdit
        Left = 8
        Top = 24
        Width = 177
        Height = 21
        EditLabel.Width = 63
        EditLabel.Height = 13
        EditLabel.Caption = 'Project name'
        LabelPosition = lpAbove
        LabelSpacing = 3
        TabOrder = 0
      end
      object leAuthor: TLabeledEdit
        Left = 8
        Top = 64
        Width = 177
        Height = 21
        EditLabel.Width = 95
        EditLabel.Height = 13
        EditLabel.Caption = 'Author (your name)'
        LabelPosition = lpAbove
        LabelSpacing = 3
        TabOrder = 1
      end
      object leEmail: TLabeledEdit
        Left = 8
        Top = 104
        Width = 177
        Height = 21
        EditLabel.Width = 101
        EditLabel.Height = 13
        EditLabel.Caption = 'Author Email address'
        LabelPosition = lpAbove
        LabelSpacing = 3
        TabOrder = 2
      end
      object leHomepage: TLabeledEdit
        Left = 8
        Top = 144
        Width = 177
        Height = 21
        EditLabel.Width = 207
        EditLabel.Height = 13
        EditLabel.Caption = 'Route or author homepage URL (http://...)'
        LabelPosition = lpAbove
        LabelSpacing = 3
        TabOrder = 3
      end
      object leSubDir: TLabeledEdit
        Left = 8
        Top = 200
        Width = 177
        Height = 21
        EditLabel.Width = 245
        EditLabel.Height = 13
        EditLabel.Caption = 'Subdirectory (for railway/route and railway/object)'
        LabelPosition = lpAbove
        LabelSpacing = 3
        TabOrder = 4
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Environment'
      ImageIndex = 1
      object lParallelDist: TLabel
        Left = 8
        Top = 56
        Width = 104
        Height = 13
        Caption = 'Parallel track distance'
      end
      object Label6m: TLabel
        Left = 184
        Top = 56
        Width = 8
        Height = 13
        Caption = 'm'
      end
      object lParallelDist2: TLabel
        Left = 8
        Top = 88
        Width = 95
        Height = 13
        Caption = '...at island platform'
      end
      object Label8m: TLabel
        Left = 184
        Top = 88
        Width = 8
        Height = 13
        Caption = 'm'
      end
      object lvmaxslow: TLabel
        Left = 264
        Top = 56
        Width = 93
        Height = 13
        Caption = 'Vmax at slow signal'
      end
      object lkmh: TLabel
        Left = 408
        Top = 56
        Width = 23
        Height = 13
        Caption = 'km/h'
      end
      object leGauge: TLabeledEdit
        Left = 8
        Top = 24
        Width = 121
        Height = 21
        EditLabel.Width = 148
        EditLabel.Height = 13
        EditLabel.Caption = 'Gauge (mm, i.e. 1435 or 1000)'
        LabelPosition = lpAbove
        LabelSpacing = 3
        TabOrder = 0
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 136
        Width = 457
        Height = 177
        Caption = '   Default Objects   '
        TabOrder = 1
        object Label4: TLabel
          Left = 16
          Top = 32
          Width = 45
          Height = 13
          Caption = 'Stop Sign'
        end
        object l1000mStationmarkerstop: TLabel
          Left = 16
          Top = 56
          Width = 138
          Height = 13
          Caption = '1000m Station Marker (Stop)'
        end
        object l1000mStationmarkerpass: TLabel
          Left = 16
          Top = 80
          Width = 138
          Height = 13
          Caption = '1000m Station Marker (Pass)'
        end
        object lSignalPost: TLabel
          Left = 16
          Top = 104
          Width = 52
          Height = 13
          Caption = 'Signal post'
        end
        object lSignalBack: TLabel
          Left = 16
          Top = 128
          Width = 53
          Height = 13
          Caption = 'Signal back'
        end
        object edDOStopsign: TEdit
          Left = 168
          Top = 29
          Width = 121
          Height = 21
          TabOrder = 0
        end
        object bDOSelectStopsign: TButton
          Left = 296
          Top = 29
          Width = 47
          Height = 21
          Caption = 'select...'
          TabOrder = 1
          OnClick = bDOSelectStopsignClick
        end
        object edStationmarkerStop: TEdit
          Left = 168
          Top = 53
          Width = 121
          Height = 21
          TabOrder = 2
        end
        object edStationmarkerPass: TEdit
          Left = 168
          Top = 77
          Width = 121
          Height = 21
          TabOrder = 3
        end
        object b1000mStationmarkerstop: TButton
          Left = 296
          Top = 53
          Width = 47
          Height = 21
          Caption = 'select...'
          TabOrder = 4
          OnClick = b1000mStationmarkerstopClick
        end
        object b1000mStationmarkerpass: TButton
          Left = 296
          Top = 77
          Width = 47
          Height = 21
          Caption = 'select...'
          TabOrder = 5
          OnClick = b1000mStationmarkerpassClick
        end
        object edSignalPost: TEdit
          Left = 168
          Top = 101
          Width = 121
          Height = 21
          TabOrder = 6
        end
        object bSignalpostselect: TButton
          Left = 296
          Top = 101
          Width = 47
          Height = 21
          Caption = 'select...'
          TabOrder = 7
          OnClick = bSignalpostselectClick
        end
        object edSignalBack: TEdit
          Left = 168
          Top = 125
          Width = 121
          Height = 21
          TabOrder = 8
        end
        object bSignalbackSelect: TButton
          Left = 296
          Top = 125
          Width = 47
          Height = 21
          Caption = 'select...'
          TabOrder = 9
          OnClick = bSignalbackSelectClick
        end
      end
      object edParallelDist: TEdit
        Left = 125
        Top = 52
        Width = 52
        Height = 21
        TabOrder = 2
      end
      object edParallelDist2: TEdit
        Left = 125
        Top = 84
        Width = 52
        Height = 21
        TabOrder = 3
      end
      object edVmaxSlowSignal: TEdit
        Left = 368
        Top = 52
        Width = 33
        Height = 21
        TabOrder = 4
        Text = '40'
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Presentation'
      ImageIndex = 2
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 53
        Height = 13
        Caption = 'Description'
      end
      object Label2: TLabel
        Left = 232
        Top = 8
        Width = 84
        Height = 13
        Caption = 'Additional Credits'
      end
      object Label3: TLabel
        Left = 8
        Top = 136
        Width = 92
        Height = 13
        Caption = 'Logo or screenshot'
      end
      object Image1: TImage
        Left = 8
        Top = 152
        Width = 240
        Height = 160
        Stretch = True
      end
      object lScreenshot: TLabel
        Left = 112
        Top = 136
        Width = 3
        Height = 13
      end
      object memoDescription: TMemo
        Left = 8
        Top = 24
        Width = 217
        Height = 100
        Lines.Strings = (
          'memoDescription')
        ScrollBars = ssVertical
        TabOrder = 0
        WantReturns = False
      end
      object memoCredits: TMemo
        Left = 232
        Top = 24
        Width = 233
        Height = 100
        Lines.Strings = (
          'memoDescription')
        ScrollBars = ssVertical
        TabOrder = 1
        WantReturns = False
      end
      object Button3: TButton
        Left = 256
        Top = 288
        Width = 75
        Height = 25
        Caption = 'Load...'
        TabOrder = 2
        OnClick = Button3Click
      end
    end
    object TabSheetMap: TTabSheet
      Caption = 'Map'
      ImageIndex = 3
      object LabelMap5: TLabel
        Left = 16
        Top = 64
        Width = 50
        Height = 13
        Caption = 'Resolution'
      end
      object LabelMap6: TLabel
        Left = 168
        Top = 64
        Width = 73
        Height = 13
        Caption = 'm are 100 pixel'
      end
      object LabelMap7: TLabel
        Left = 16
        Top = 32
        Width = 42
        Height = 13
        Caption = 'Filename'
      end
      object EdMapResolution: TEdit
        Left = 80
        Top = 60
        Width = 81
        Height = 21
        TabOrder = 0
        Text = '250'
      end
      object edMapFilename: TEdit
        Left = 80
        Top = 29
        Width = 225
        Height = 21
        Enabled = False
        TabOrder = 1
      end
      object bBrowseMap: TButton
        Left = 315
        Top = 30
        Width = 30
        Height = 19
        Caption = '...'
        TabOrder = 2
        OnClick = bBrowseMapClick
      end
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 8
    Top = 360
  end
  object OpenPictureDialog2: TOpenPictureDialog
    Filter = 'JPEG Image File (*.jpg)|*.jpg|Bitmaps (*.bmp)|*.bmp'
    Title = 'Background Overview Map'
    Left = 48
    Top = 360
  end
end
