object FormChangeProperty: TFormChangeProperty
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Change Track Properties'
  ClientHeight = 282
  ClientWidth = 201
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    201
    282)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 176
    Width = 173
    Height = 13
    Caption = '(leave empty to keep current value)'
  end
  object Button1: TButton
    Left = 118
    Top = 254
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Start'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object leFog: TLabeledEdit
    Left = 8
    Top = 32
    Width = 121
    Height = 21
    EditLabel.Width = 18
    EditLabel.Height = 13
    EditLabel.Caption = 'Fog'
    LabelPosition = lpAbove
    LabelSpacing = 3
    TabOrder = 1
  end
  object cbSelArea: TCheckBox
    Left = 8
    Top = 200
    Width = 145
    Height = 17
    Caption = '&only if in selected area'
    TabOrder = 2
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 224
    Width = 161
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 3
  end
  object leAdhesion: TLabeledEdit
    Left = 8
    Top = 72
    Width = 121
    Height = 21
    EditLabel.Width = 44
    EditLabel.Height = 13
    EditLabel.Caption = 'Adhesion'
    LabelPosition = lpAbove
    LabelSpacing = 3
    TabOrder = 4
  end
  object leAccuracy: TLabeledEdit
    Left = 8
    Top = 112
    Width = 121
    Height = 21
    EditLabel.Width = 44
    EditLabel.Height = 13
    EditLabel.Caption = 'Accuracy'
    LabelPosition = lpAbove
    LabelSpacing = 3
    TabOrder = 5
  end
  object leSpeedlimit: TLabeledEdit
    Left = 8
    Top = 152
    Width = 121
    Height = 21
    EditLabel.Width = 51
    EditLabel.Height = 13
    EditLabel.Caption = 'Speed limit'
    LabelPosition = lpAbove
    LabelSpacing = 3
    TabOrder = 6
  end
end
