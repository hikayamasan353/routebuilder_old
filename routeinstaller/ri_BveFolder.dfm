object RouteInstaller_BveFolder: TRouteInstaller_BveFolder
  Left = 396
  Top = 202
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Routeinstaller - BVE directory'
  ClientHeight = 277
  ClientWidth = 347
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelSelectDir: TLabel
    Left = 8
    Top = 8
    Width = 185
    Height = 13
    Caption = 'Please select your BVE Directory:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelSelectedDir: TLabel
    Left = 8
    Top = 24
    Width = 321
    Height = 13
    AutoSize = False
    Caption = 'C:\projects\up\RouteBuilder\routeinstaller'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object OKButton: TButton
    Left = 264
    Top = 248
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = OKButtonClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 48
    Width = 329
    Height = 193
    Caption = 'Change'
    TabOrder = 1
    object DirectoryBox1: TDirectoryListBox
      Left = 16
      Top = 40
      Width = 305
      Height = 137
      DirLabel = LabelSelectedDir
      ItemHeight = 16
      TabOrder = 0
    end
    object DriveBox1: TDriveComboBox
      Left = 48
      Top = 16
      Width = 121
      Height = 19
      DirList = DirectoryBox1
      TabOrder = 1
    end
  end
end
