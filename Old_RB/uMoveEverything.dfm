object FormMoveEverything: TFormMoveEverything
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Move'
  ClientHeight = 281
  ClientWidth = 222
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    222
    281)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 96
    Top = 250
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Start'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 250
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object leX: TLabeledEdit
    Left = 8
    Top = 24
    Width = 121
    Height = 21
    EditLabel.Width = 58
    EditLabel.Height = 13
    EditLabel.Caption = 'x-offset (m)'
    TabOrder = 2
  end
  object leY: TLabeledEdit
    Left = 8
    Top = 64
    Width = 121
    Height = 21
    EditLabel.Width = 58
    EditLabel.Height = 13
    EditLabel.Caption = 'y-offset (m)'
    TabOrder = 3
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 226
    Width = 161
    Height = 16
    Anchors = [akLeft, akBottom]
    TabOrder = 4
  end
  object cbSelArea: TCheckBox
    Left = 8
    Top = 168
    Width = 145
    Height = 17
    Caption = '&only if in selected area'
    TabOrder = 5
    OnClick = cbSelAreaClick
  end
  object leScale: TLabeledEdit
    Left = 8
    Top = 144
    Width = 121
    Height = 21
    EditLabel.Width = 25
    EditLabel.Height = 13
    EditLabel.Caption = 'Scale'
    TabOrder = 6
  end
  object leVert: TLabeledEdit
    Left = 8
    Top = 104
    Width = 121
    Height = 21
    EditLabel.Width = 86
    EditLabel.Height = 13
    EditLabel.Caption = 'vertical offset (m)'
    TabOrder = 7
  end
  object cbAreaToCursor: TCheckBox
    Left = 8
    Top = 190
    Width = 97
    Height = 17
    Caption = 'area to &cursor'
    TabOrder = 8
    OnClick = cbAreaToCursorClick
  end
  object cbAbsolute: TCheckBox
    Left = 136
    Top = 104
    Width = 73
    Height = 17
    Caption = 'absolute'
    TabOrder = 9
  end
end
