object FormSaveRegion: TFormSaveRegion
  Left = 197
  Top = 151
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Save Region as...'
  ClientHeight = 217
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Trebuchet MS'
  Font.Style = []
  OldCreateOrder = False
  OnShortCut = FormShortCut
  PixelsPerInch = 96
  TextHeight = 16
  object lComment: TLabel
    Left = 8
    Top = 8
    Width = 46
    Height = 16
    Caption = 'Comment'
  end
  object memoComment: TMemo
    Left = 8
    Top = 24
    Width = 305
    Height = 89
    ScrollBars = ssVertical
    TabOrder = 0
    WantReturns = False
  end
  object leAuthor: TLabeledEdit
    Left = 8
    Top = 144
    Width = 305
    Height = 24
    EditLabel.Width = 34
    EditLabel.Height = 16
    EditLabel.Caption = 'Author'
    LabelPosition = lpAbove
    LabelSpacing = 3
    TabOrder = 1
  end
  object Button1: TButton
    Left = 240
    Top = 184
    Width = 75
    Height = 25
    Caption = '&Save'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 152
    Top = 184
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
