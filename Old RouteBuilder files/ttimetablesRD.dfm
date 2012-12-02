object FormTimetablesRD: TFormTimetablesRD
  Left = 192
  Top = 107
  Width = 275
  Height = 220
  BorderIcons = []
  Caption = 'Please select routedefinitions'
  Color = clBtnFace
  Constraints.MinHeight = 220
  Constraints.MinWidth = 275
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RDBox: TCheckListBox
    Left = 0
    Top = 0
    Width = 267
    Height = 158
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 158
    Width = 267
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      267
      35)
    object btnSelAll: TButton
      Left = 0
      Top = 8
      Width = 65
      Height = 25
      Caption = 'Select all'
      TabOrder = 0
      OnClick = btnSelAllClick
    end
    object btnSelNone: TButton
      Left = 80
      Top = 8
      Width = 65
      Height = 25
      Caption = 'Select none'
      TabOrder = 1
      OnClick = btnSelNoneClick
    end
    object btnSelOK: TButton
      Left = 208
      Top = 8
      Width = 57
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      TabOrder = 2
      OnClick = btnSelOKClick
    end
  end
end
