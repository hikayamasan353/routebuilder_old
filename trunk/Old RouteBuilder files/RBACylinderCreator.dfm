object Form1: TForm1
  Left = 192
  Top = 107
  Width = 364
  Height = 377
  Caption = 'b3d cylinder creator'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Trebuchet MS'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 321
    Height = 16
    Caption = 'Image (height and width have to be 16, 32, 64, 128, 256, 512...)'
  end
  object Image1: TImage
    Left = 8
    Top = 24
    Width = 257
    Height = 121
  end
  object Label2: TLabel
    Left = 8
    Top = 160
    Width = 79
    Height = 16
    Caption = 'Object settings'
  end
  object Button1: TButton
    Left = 272
    Top = 120
    Width = 75
    Height = 25
    Caption = 'load...'
    TabOrder = 0
    OnClick = Button1Click
  end
  object LabeledEdit1: TLabeledEdit
    Left = 8
    Top = 200
    Width = 121
    Height = 24
    EditLabel.Width = 173
    EditLabel.Height = 16
    EditLabel.Caption = 'face count (the more the rounder)'
    LabelPosition = lpAbove
    LabelSpacing = 3
    TabOrder = 1
  end
  object LabeledEdit2: TLabeledEdit
    Left = 8
    Top = 248
    Width = 121
    Height = 24
    EditLabel.Width = 50
    EditLabel.Height = 16
    EditLabel.Caption = 'radius (m)'
    LabelPosition = lpAbove
    LabelSpacing = 3
    TabOrder = 2
  end
  object Button2: TButton
    Left = 135
    Top = 296
    Width = 50
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = Button2Click
  end
  object LabeledEdit3: TLabeledEdit
    Left = 8
    Top = 296
    Width = 121
    Height = 24
    EditLabel.Width = 163
    EditLabel.Height = 16
    EditLabel.Caption = 'Destination filename (I add .b3d)'
    LabelPosition = lpAbove
    LabelSpacing = 3
    TabOrder = 4
  end
  object Button3: TButton
    Left = 256
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Go!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Trebuchet MS'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = Button3Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 331
    Width = 356
    Height = 19
    Panels = <>
    SimplePanel = False
    SizeGrip = False
  end
  object LabeledEdit4: TLabeledEdit
    Left = 136
    Top = 248
    Width = 121
    Height = 24
    EditLabel.Width = 52
    EditLabel.Height = 16
    EditLabel.Caption = 'Height (m)'
    LabelPosition = lpAbove
    LabelSpacing = 3
    TabOrder = 7
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 320
    Top = 88
  end
  object SaveDialog1: TSaveDialog
    Left = 192
    Top = 296
  end
end
