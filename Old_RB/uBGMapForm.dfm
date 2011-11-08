object FormBGMap: TFormBGMap
  Left = 192
  Top = 107
  Width = 421
  Height = 407
  BorderIcons = [biSystemMenu]
  Caption = 'Background Image for Minimap'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 413
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      413
      65)
    object Label1: TLabel
      Left = 8
      Top = 36
      Width = 97
      Height = 13
      Caption = 'Scale: 100 Pixel are '
    end
    object Label2: TLabel
      Left = 168
      Top = 36
      Width = 31
      Height = 13
      Caption = 'meters'
    end
    object Button1: TButton
      Left = 329
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Browse...'
      TabOrder = 0
      OnClick = Button1Click
    end
    object edfilename: TEdit
      Left = 8
      Top = 8
      Width = 314
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object EdScale: TEdit
      Left = 107
      Top = 33
      Width = 57
      Height = 21
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 339
    Width = 413
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      413
      41)
    object Button2: TButton
      Left = 329
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 241
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 1
      TabOrder = 1
      OnClick = Button3Click
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 65
    Width = 413
    Height = 274
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    AutoSize = True
    TabOrder = 2
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 300
      Height = 163
      AutoSize = True
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 248
    Top = 16
  end
end
