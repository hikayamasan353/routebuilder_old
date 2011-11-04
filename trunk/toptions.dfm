object FormOptions: TFormOptions
  Left = 397
  Top = 243
  BorderStyle = bsDialog
  Caption = 'Route Builder- Options'
  ClientHeight = 335
  ClientWidth = 383
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShortCut = FormShortCut
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 294
    Width = 383
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Btn_Cancel: TButton
      Left = 198
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = Btn_CancelClick
    end
    object Btn_OK: TButton
      Left = 294
      Top = 11
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = Btn_OKClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 383
    Height = 294
    ActivePage = TabSheet3
    Align = alClient
    TabIndex = 2
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'General'
      object LabelBveDir: TLabel
        Left = 8
        Top = 32
        Width = 68
        Height = 13
        Caption = 'BVE directory:'
      end
      object Label7: TLabel
        Left = 8
        Top = 152
        Width = 89
        Height = 13
        Caption = 'Default Language:'
      end
      object Label8: TLabel
        Left = 8
        Top = 184
        Width = 99
        Height = 13
        Caption = 'Object Library folder'
      end
      object lDefTrain: TLabel
        Left = 8
        Top = 216
        Width = 62
        Height = 13
        Caption = 'Default Train'
      end
      object StructureViewer_Check: TCheckBox
        Left = 8
        Top = 88
        Width = 225
        Height = 17
        Caption = 'internal Objectpreview (not installed)'
        Enabled = False
        TabOrder = 0
        OnClick = StructureViewer_CheckClick
      end
      object BveFolderSearchButton: TButton
        Left = 274
        Top = 48
        Width = 55
        Height = 17
        Caption = 'browse...'
        TabOrder = 1
        OnClick = BveFolderSearchButtonClick
      end
      object AutoUpdate_Check: TCheckBox
        Left = 8
        Top = 120
        Width = 265
        Height = 17
        Caption = 'Automatically search for Updates'
        Enabled = False
        TabOrder = 2
        OnClick = AutoUpdate_CheckClick
      end
      object edDefLanguage: TEdit
        Left = 112
        Top = 149
        Width = 121
        Height = 21
        TabOrder = 3
        Text = 'english.lng'
      end
      object edObjFolder: TEdit
        Left = 112
        Top = 180
        Width = 121
        Height = 21
        TabOrder = 4
        Text = 'objects'
      end
      object bBrowseLanguageFile: TButton
        Left = 242
        Top = 151
        Width = 31
        Height = 17
        Caption = '...'
        TabOrder = 5
        OnClick = bBrowseLanguageFileClick
      end
      object BVE_Folder_Set: TEdit
        Left = 8
        Top = 48
        Width = 249
        Height = 21
        Enabled = False
        ReadOnly = True
        TabOrder = 6
      end
      object cbTrains: TComboBox
        Left = 112
        Top = 208
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 7
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Editor'
      ImageIndex = 1
      object Label4: TLabel
        Left = 8
        Top = 232
        Width = 136
        Height = 13
        Caption = 'Arrow Control step size (cm)'
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 120
        Width = 361
        Height = 97
        Caption = 'Copy track properties when adding connections'
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 56
          Width = 255
          Height = 13
          Caption = '(copies ground, background, track, poles, speedlimit)'
        end
        object CheckBoxCopyTrackPropLast: TCheckBox
          Left = 8
          Top = 16
          Width = 241
          Height = 17
          Caption = 'from last active connection'
          TabOrder = 0
          OnClick = CheckBoxCopyTrackPropLastClick
        end
        object CheckBoxCopyTrackPropClip: TCheckBox
          Left = 8
          Top = 35
          Width = 241
          Height = 17
          Caption = 'from clipboard'
          TabOrder = 1
          OnClick = CheckBoxCopyTrackPropClipClick
        end
        object bDefaultTrack: TButton
          Left = 248
          Top = 24
          Width = 99
          Height = 25
          Caption = 'Default Track...'
          TabOrder = 2
          OnClick = bDefaultTrackClick
        end
      end
      object cbFit4m: TCheckBox
        Left = 8
        Top = 16
        Width = 337
        Height = 17
        Caption = 
          'fit points to 4 or 15m distance for &parallel tracks (except in ' +
          'grids)'
        TabOrder = 1
      end
      object edArrowStepSize: TEdit
        Left = 152
        Top = 229
        Width = 41
        Height = 21
        TabOrder = 2
        Text = '10'
        OnChange = edArrowStepSizeChange
      end
      object cbNewConnFixed: TCheckBox
        Left = 8
        Top = 40
        Width = 313
        Height = 17
        Caption = 'new connections are fixed'
        TabOrder = 3
      end
      object cbTSOFrames: TCheckBox
        Left = 8
        Top = 63
        Width = 241
        Height = 17
        Caption = 'draw TSO and Walls as frames (CPU > 1 GHz)'
        TabOrder = 4
      end
      object cbShowSignalNames: TCheckBox
        Left = 8
        Top = 88
        Width = 241
        Height = 17
        Caption = 'show signal names'
        TabOrder = 5
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Export'
      ImageIndex = 2
      object Label2: TLabel
        Left = 8
        Top = 11
        Width = 149
        Height = 13
        Caption = 'Distance beyond last train stop'
      end
      object Label3: TLabel
        Left = 249
        Top = 11
        Width = 8
        Height = 13
        Caption = 'm'
      end
      object Label5: TLabel
        Left = 8
        Top = 43
        Width = 162
        Height = 13
        Caption = 'make curves straight if greater as'
      end
      object Label6: TLabel
        Left = 249
        Top = 43
        Width = 8
        Height = 13
        Caption = 'm'
      end
      object Label9: TLabel
        Left = 8
        Top = 75
        Width = 102
        Height = 13
        Caption = 'shortest curve radius'
      end
      object Label10: TLabel
        Left = 249
        Top = 75
        Width = 8
        Height = 13
        Caption = 'm'
      end
      object Label11: TLabel
        Left = 8
        Top = 104
        Width = 171
        Height = 13
        Caption = 'Curve banking factor (default 1.37)'
      end
      object edDistanceBeyondLast: TEdit
        Left = 200
        Top = 7
        Width = 41
        Height = 21
        TabOrder = 0
      end
      object edMaxCurveSmooth: TEdit
        Left = 200
        Top = 38
        Width = 41
        Height = 21
        TabOrder = 1
      end
      object edShortestCurve: TEdit
        Left = 200
        Top = 70
        Width = 41
        Height = 21
        TabOrder = 2
      end
      object cbCurvedSecondary: TCheckBox
        Left = 8
        Top = 128
        Width = 321
        Height = 17
        Caption = 'curved secondary tracks'
        TabOrder = 4
      end
      object cbExportPrimaryTrains: TCheckBox
        Left = 8
        Top = 152
        Width = 329
        Height = 17
        Caption = 'export trains standing on primary tracks'
        TabOrder = 5
      end
      object cbCatenaryPoles50: TCheckBox
        Left = 8
        Top = 176
        Width = 345
        Height = 17
        Caption = 'catenary poles distance 50m on straigt tracks (experimental)'
        TabOrder = 6
      end
      object edCurvebanking: TEdit
        Left = 200
        Top = 100
        Width = 41
        Height = 21
        TabOrder = 3
      end
      object cbAllowMultipleConnGrid: TCheckBox
        Left = 8
        Top = 224
        Width = 361
        Height = 17
        Caption = 
          'allow multiple connections per grid section (for crossings, expe' +
          'rimental)'
        TabOrder = 7
      end
      object cbElliptical: TCheckBox
        Left = 8
        Top = 200
        Width = 345
        Height = 17
        Caption = 'use hyperbolic curve interpolation instead of bezier'
        TabOrder = 8
      end
      object cbGroundless: TCheckBox
        Left = 200
        Top = 128
        Width = 145
        Height = 17
        Caption = 'groundless building'
        TabOrder = 9
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Language File|*.lng'
    Title = 'select language file'
    Left = 328
    Top = 72
  end
end
