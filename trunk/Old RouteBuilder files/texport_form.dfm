object FormExport: TFormExport
  Left = 192
  Top = 107
  Width = 210
  Height = 137
  Caption = 'Export project...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 64
    Width = 57
    Height = 10
    Shape = bsBottomLine
  end
  object LabelRB: TLabel
    Left = 56
    Top = 64
    Width = 64
    Height = 13
    Caption = 'Route Builder'
    Enabled = False
  end
  object Bevel2: TBevel
    Left = 120
    Top = 64
    Width = 81
    Height = 9
    Shape = bsBottomLine
  end
  object export_set_Trains: TComboBox
    Left = 32
    Top = 40
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'Please select a Train'
  end
  object export_set_Routes: TComboBox
    Left = 32
    Top = 8
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'Please select a Route'
  end
  object ExportBtn: TButton
    Left = 48
    Top = 80
    Width = 105
    Height = 25
    Caption = 'Export'
    TabOrder = 2
  end
end
