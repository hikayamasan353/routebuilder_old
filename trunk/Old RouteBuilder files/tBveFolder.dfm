object FormSetBveFolder: TFormSetBveFolder
  Left = 365
  Top = 197
  Width = 355
  Height = 304
  Caption = 'Preferences - BVE directory'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object LabelSelectDir: TLabel
    Left = 88
    Top = 8
    Width = 159
    Height = 13
    Caption = 'Please select your BVE Directory:'
  end
  object LabelSelectedDir: TLabel
    Left = 8
    Top = 24
    Width = 321
    Height = 13
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ShellTreeView1: TShellTreeView
    Left = 8
    Top = 48
    Width = 329
    Height = 193
    ObjectTypes = [otFolders]
    Root = 'rfMyComputer'
    UseShellImages = True
    AutoRefresh = True
    Ctl3d = False
    Indent = 19
    ParentColor = False
    ParentCtl3d = False
    RightClickSelect = True
    ShowRoot = False
    TabOrder = 0
    OnChange = ShellTreeView1Change
  end
  object OKButton: TButton
    Left = 264
    Top = 248
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = OKButtonClick
  end
end
