object FormSwitch: TFormSwitch
  Left = 393
  Top = 166
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Switch for Windows - RB Addin version'
  ClientHeight = 371
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 330
    Width = 321
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object lStatus: TLabel
      Left = 104
      Top = 16
      Width = 121
      Height = 14
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'lStatus'
      Font.Style = []
      ParentFont = False
    end
    object Button2: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 238
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Create'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 321
    Height = 330
    ActivePage = tsCurves
    Align = alClient
    TabIndex = 1
    TabOrder = 1
    object tsSwitches: TTabSheet
      Caption = 'Switches'
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 52
        Height = 13
        Caption = 'Length (m)'
      end
      object Label2: TLabel
        Left = 16
        Top = 48
        Width = 50
        Height = 13
        Caption = 'X-Offsets:'
      end
      object Label3: TLabel
        Left = 16
        Top = 72
        Width = 74
        Height = 13
        Caption = 'Left Branch (m)'
      end
      object Label4: TLabel
        Left = 16
        Top = 104
        Width = 80
        Height = 13
        Caption = 'Right Branch (m)'
      end
      object Label6: TLabel
        Left = 16
        Top = 144
        Width = 71
        Height = 13
        Caption = 'Switch position'
      end
      object Label7: TLabel
        Left = 16
        Top = 192
        Width = 48
        Height = 13
        Caption = 'Overhead'
      end
      object Label9: TLabel
        Left = 16
        Top = 264
        Width = 85
        Height = 13
        Caption = 'Filename: switch_'
      end
      object lPostfix: TLabel
        Left = 184
        Top = 264
        Width = 22
        Height = 13
        Caption = '.b3d'
      end
      object ImTex3: TImage
        Left = 184
        Top = 88
        Width = 128
        Height = 32
        OnClick = ImTex3Click
      end
      object Label10: TLabel
        Left = 184
        Top = 8
        Width = 51
        Height = 13
        Caption = 'Texture 1:'
      end
      object Label5: TLabel
        Left = 247
        Top = 8
        Width = 51
        Height = 13
        Caption = 'Texture 2:'
      end
      object ImTex1: TImage
        Left = 185
        Top = 24
        Width = 32
        Height = 32
        OnClick = ImTex1Click
      end
      object SpeedButton1: TSpeedButton
        Left = 104
        Top = 40
        Width = 23
        Height = 22
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFF1FF1F
          FFFFFFFFFFF1FF1FFFFFFFFFFFF1FF1FFFFFFFFFFF11F11FFFFFFFFFFF11F11F
          FFFFFFFFFF11F11FFFFFFFFFF1F11F1FFFFFFFFFF1F11F1FFFFFFFFFF1F11F1F
          FFFFFFFF1FF1FF1FFFFFFFFF1FF1FF1FFFFFFFFF1FF1FF1FFFFFFFF1FF11FF1F
          FFFFFFF1FF11FF1FFFFFFFF1FF11FF1FFFFFFF1FF1F1FF1FFFFF}
        OnClick = bLeftClick
      end
      object SpeedButton2: TSpeedButton
        Left = 128
        Top = 40
        Width = 23
        Height = 22
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFF1FF1FFF
          FFFFFFFFF1FF1FFFFFFFFFFFF1FF1FFFFFFFFFFFF11F11FFFFFFFFFFF11F11FF
          FFFFFFFFF11F11FFFFFFFFFFF1F11F1FFFFFFFFFF1F11F1FFFFFFFFFF1F11F1F
          FFFFFFFFF1FF1FF1FFFFFFFFF1FF1FF1FFFFFFFFF1FF1FF1FFFFFFFFF1FF11FF
          1FFFFFFFF1FF11FF1FFFFFFFF1FF11FF1FFFFFFFF1FF1F1FF1FF}
        OnClick = bRightClick
      end
      object ImTex2: TImage
        Left = 247
        Top = 24
        Width = 64
        Height = 32
        OnClick = ImTex2Click
      end
      object Label11: TLabel
        Left = 184
        Top = 72
        Width = 51
        Height = 13
        Caption = 'Texture 3:'
      end
      object EdLength: TEdit
        Left = 104
        Top = 13
        Width = 49
        Height = 21
        Enabled = False
        ReadOnly = True
        TabOrder = 0
        Text = '25'
      end
      object EdLeftXOffset: TEdit
        Left = 104
        Top = 69
        Width = 41
        Height = 21
        Enabled = False
        ReadOnly = True
        TabOrder = 1
        Text = '0'
        OnChange = rbleftClick
      end
      object EdRightXOffset: TEdit
        Left = 104
        Top = 101
        Width = 41
        Height = 21
        Enabled = False
        ReadOnly = True
        TabOrder = 2
        Text = '2'
        OnChange = rbleftClick
      end
      object cbGuardrails: TCheckBox
        Left = 105
        Top = 168
        Width = 128
        Height = 17
        Caption = 'create guard rails'
        TabOrder = 3
      end
      object rbleft: TRadioButton
        Left = 104
        Top = 144
        Width = 57
        Height = 17
        Caption = 'left'
        TabOrder = 4
        OnClick = rbleftClick
      end
      object rbRight: TRadioButton
        Left = 152
        Top = 144
        Width = 49
        Height = 17
        Caption = 'right'
        Checked = True
        TabOrder = 5
        TabStop = True
        OnClick = rbleftClick
      end
      object cbOverheadLeft: TCheckBox
        Left = 105
        Top = 190
        Width = 48
        Height = 17
        Caption = 'left'
        TabOrder = 6
        OnClick = rbleftClick
      end
      object cbOverheadRight: TCheckBox
        Left = 177
        Top = 190
        Width = 48
        Height = 17
        Caption = 'right'
        TabOrder = 7
        OnClick = rbleftClick
      end
      object edFilename: TEdit
        Left = 104
        Top = 261
        Width = 73
        Height = 21
        TabOrder = 8
        Text = 'brown'
      end
    end
    object tsCurves: TTabSheet
      Caption = 'Curves'
      ImageIndex = 1
      OnShow = changeValue
      object Label13: TLabel
        Left = 16
        Top = 48
        Width = 167
        Height = 13
        Caption = 'Radius (m) negative for left curves'
      end
      object Label12: TLabel
        Left = 16
        Top = 264
        Width = 46
        Height = 13
        Caption = 'Filename:'
      end
      object lCurvePostfix: TLabel
        Left = 184
        Top = 264
        Width = 22
        Height = 13
        Caption = '.b3d'
      end
      object Label15: TLabel
        Left = 16
        Top = 80
        Width = 249
        Height = 41
        AutoSize = False
        Caption = 
          'Set textures 1 and 2, length and overhead wire height settings o' +
          'n the first tab.'
        WordWrap = True
      end
      object Label8: TLabel
        Left = 16
        Top = 224
        Width = 79
        Height = 13
        Caption = 'Wire heights (m)'
      end
      object Label18: TLabel
        Left = 16
        Top = 176
        Width = 74
        Height = 13
        Caption = 'Track width (m)'
      end
      object edRadius: TEdit
        Left = 216
        Top = 45
        Width = 49
        Height = 21
        TabOrder = 0
        Text = '1000'
        OnChange = changeValue
      end
      object edCurveFilename: TEdit
        Left = 104
        Top = 261
        Width = 73
        Height = 21
        TabOrder = 5
        Text = 'brown'
      end
      object cbOverheadWire: TCheckBox
        Left = 17
        Top = 126
        Width = 136
        Height = 17
        Caption = 'Overhead wire'
        TabOrder = 2
        OnClick = changeValue
      end
      object edWireheight1: TEdit
        Left = 104
        Top = 221
        Width = 33
        Height = 21
        TabOrder = 3
        Text = '6.0'
        OnChange = rbleftClick
      end
      object edWireheight2: TEdit
        Left = 160
        Top = 221
        Width = 33
        Height = 21
        TabOrder = 4
        Text = '7.0'
        OnChange = rbleftClick
      end
      object edTrackWidth: TEdit
        Left = 104
        Top = 173
        Width = 33
        Height = 21
        TabOrder = 1
        Text = '5.6'
        OnChange = rbleftClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Crossings'
      ImageIndex = 2
      TabVisible = False
    end
    object TabSheet4: TTabSheet
      Caption = 'Slip switches'
      ImageIndex = 3
      TabVisible = False
    end
    object TabSheet1: TTabSheet
      Caption = 'About'
      ImageIndex = 4
      object Label14: TLabel
        Left = 8
        Top = 40
        Width = 113
        Height = 13
        Caption = 'Switch for Windows 0.2'
      end
      object Label16: TLabel
        Left = 8
        Top = 64
        Width = 159
        Height = 13
        Caption = 'By R'#252'diger H'#252'lsmann && Uwe Post'
      end
      object Label17: TLabel
        Left = 8
        Top = 88
        Width = 77
        Height = 13
        Caption = 'www.bvesim.de'
      end
    end
  end
end
