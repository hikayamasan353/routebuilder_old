object Routeinstaller_Main: TRouteinstaller_Main
  Left = 249
  Top = 200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Route Builder - Route Installer v1.1a'
  ClientHeight = 313
  ClientWidth = 490
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Route_Name: TLabel
    Left = 8
    Top = 8
    Width = 473
    Height = 23
    AutoSize = False
    Caption = '#ROUTE_NAME#'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Route_Image: TImage
    Left = 8
    Top = 40
    Width = 240
    Height = 160
    Center = True
    Stretch = True
  end
  object Route_Description: TLabel
    Left = 256
    Top = 40
    Width = 225
    Height = 97
    AutoSize = False
    Caption = '#ROUTE_DESCRIPTION#'
    Color = clCream
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    WordWrap = True
  end
  object Route_Author: TLabel
    Left = 256
    Top = 144
    Width = 225
    Height = 13
    AutoSize = False
    Caption = 'by #ROUTE_AUTHOR#'
    Color = clCream
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Route_Homepage: TLabel
    Left = 256
    Top = 160
    Width = 225
    Height = 13
    AutoSize = False
    Caption = '#ROUTE_HOMEPAGE#'
    Color = clCream
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Visible = False
    OnClick = Route_HomepageClick
    OnMouseEnter = Route_HomepageMouseEnter
    OnMouseLeave = Route_HomepageMouseLeave
  end
  object Label1: TLabel
    Left = 256
    Top = 184
    Width = 40
    Height = 13
    Caption = 'Credits'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Credits: TMemo
    Left = 256
    Top = 200
    Width = 225
    Height = 49
    BorderStyle = bsNone
    Color = clCream
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object SetupBox: TGroupBox
    Left = 24
    Top = 256
    Width = 457
    Height = 41
    Caption = ' Setup '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object BvePath_Label: TLabel
      Left = 8
      Top = 16
      Width = 48
      Height = 13
      Caption = 'Bve-Path:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object SpeedButton1: TSpeedButton
      Left = 304
      Top = 12
      Width = 25
      Height = 21
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton1Click
    end
    object BvePath_Edit: TEdit
      Left = 64
      Top = 16
      Width = 233
      Height = 17
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = 'c:\program files\bve'
    end
    object Button1: TButton
      Left = 368
      Top = 12
      Width = 75
      Height = 21
      Caption = 'Install now'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = InstallButtonClick
    end
  end
end