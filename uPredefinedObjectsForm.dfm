object FormPredefinedObjects: TFormPredefinedObjects
  Left = 378
  Top = 158
  BorderStyle = bsDialog
  Caption = 'Predefined Objects'
  ClientHeight = 294
  ClientWidth = 236
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnKeyPress = FormKeyPress
  OnShortCut = FormShortCut
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LPredefWhat: TLabel
    Left = 8
    Top = 8
    Width = 63
    Height = 13
    Caption = 'LPredefWhat'
  end
  object lbObj: TListBox
    Left = 8
    Top = 24
    Width = 217
    Height = 209
    ItemHeight = 13
    TabOrder = 0
    OnClick = lbObjClick
    OnKeyUp = lbObjKeyUp
  end
  object Button1: TButton
    Left = 156
    Top = 269
    Width = 69
    Height = 20
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object bAdd: TButton
    Left = 156
    Top = 245
    Width = 69
    Height = 20
    Caption = 'Add...'
    TabOrder = 2
    OnClick = bAddClick
  end
  object bDel: TButton
    Left = 10
    Top = 245
    Width = 69
    Height = 20
    Caption = '&Delete'
    Enabled = False
    TabOrder = 3
    OnClick = bDelClick
  end
  object Button2: TButton
    Left = 83
    Top = 269
    Width = 69
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object bMultiple: TButton
    Left = 83
    Top = 245
    Width = 69
    Height = 20
    Caption = 'Multiple...'
    Enabled = False
    TabOrder = 5
    OnClick = bMultipleClick
  end
  object bSingle: TButton
    Left = 10
    Top = 269
    Width = 69
    Height = 20
    Caption = 'Single'
    Enabled = False
    TabOrder = 6
    OnClick = bSingleClick
  end
end
