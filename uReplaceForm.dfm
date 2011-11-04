object FormReplace: TFormReplace
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Replace'
  ClientHeight = 295
  ClientWidth = 254
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShortCut = FormShortCut
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 19
    Top = 24
    Width = 58
    Height = 13
    Caption = 'Search type'
  end
  object Label3: TLabel
    Left = 20
    Top = 96
    Width = 50
    Height = 13
    Caption = 'replace by'
  end
  object cbSearchType: TComboBox
    Left = 88
    Top = 20
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbSearchTypeChange
    Items.Strings = (
      'Track'
      'Ground'
      'Platform'
      'Background'
      'Poles'
      'Wall left'
      'Wall right'
      'TSO left'
      'TSO right')
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 128
    Width = 217
    Height = 81
    Caption = 'Scope restriction'
    TabOrder = 1
    object cbRouteDefinition: TCheckBox
      Left = 8
      Top = 24
      Width = 153
      Height = 17
      Caption = 'current Route Definition'
      TabOrder = 0
    end
    object cbSelArea: TCheckBox
      Left = 8
      Top = 48
      Width = 153
      Height = 17
      Caption = 'selected &area'
      TabOrder = 1
    end
  end
  object bReplace: TButton
    Left = 160
    Top = 216
    Width = 75
    Height = 25
    Caption = '&Replace'
    Default = True
    TabOrder = 2
    OnClick = bReplaceClick
  end
  object bCancel: TButton
    Left = 16
    Top = 216
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Close'
    TabOrder = 3
    OnClick = bCancelClick
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 256
    Width = 225
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 4
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 276
    Width = 254
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object Label2: TCheckBox
    Left = 2
    Top = 55
    Width = 79
    Height = 17
    Caption = 'search for'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object edReplaceBy: TEdit
    Left = 88
    Top = 93
    Width = 129
    Height = 21
    TabOrder = 7
  end
  object bSelReplaceBy: TButton
    Left = 223
    Top = 93
    Width = 25
    Height = 21
    Caption = '...'
    TabOrder = 8
    OnClick = bSelReplaceByClick
  end
  object cbSearchfor: TComboBox
    Left = 88
    Top = 53
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 9
  end
  object cbReplaceBy: TComboBox
    Left = 88
    Top = 93
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 10
  end
end
