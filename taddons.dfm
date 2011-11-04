object FormAddons: TFormAddons
  Left = 388
  Top = 212
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderStyle = bsDialog
  Caption = 'Route Builder - Addons'
  ClientHeight = 175
  ClientWidth = 402
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object AddonList: TListBox
    Left = 8
    Top = 8
    Width = 241
    Height = 161
    Ctl3D = False
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 0
    OnClick = AddonListClick
    OnDblClick = AddonStartClick
  end
  object AddonListGrpBox: TGroupBox
    Left = 264
    Top = 32
    Width = 121
    Height = 97
    Caption = 'Addonmenu'
    TabOrder = 1
    object AddonInformations: TButton
      Left = 16
      Top = 56
      Width = 89
      Height = 25
      Caption = 'Info'
      Enabled = False
      TabOrder = 0
      OnClick = AddonInformationsClick
    end
    object AddonStart: TButton
      Left = 24
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Run'
      Enabled = False
      TabOrder = 1
      OnClick = AddonStartClick
    end
  end
  object AddonInformationsGrpBox: TGroupBox
    Left = 8
    Top = 184
    Width = 353
    Height = 153
    Caption = 'Addondetails'
    TabOrder = 2
    object Addon_Inf_Name: TLabel
      Left = 8
      Top = 24
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object Addon_Inf_Author: TLabel
      Left = 8
      Top = 40
      Width = 37
      Height = 13
      Caption = 'Author:'
    end
    object Addon_Inf_Version: TLabel
      Left = 8
      Top = 56
      Width = 39
      Height = 13
      Caption = 'Version:'
    end
    object Addon_Inf_Website: TLabel
      Left = 8
      Top = 128
      Width = 43
      Height = 13
      Caption = 'Website:'
    end
    object Addon_inf_email: TLabel
      Left = 8
      Top = 112
      Width = 67
      Height = 13
      Caption = 'E-mail adress:'
    end
    object Addon_Inf_Copyright: TLabel
      Left = 8
      Top = 72
      Width = 51
      Height = 13
      Caption = 'Copyright:'
    end
    object Addon_Inf_Description: TLabel
      Left = 8
      Top = 96
      Width = 57
      Height = 13
      Caption = 'Description:'
    end
  end
end
