object FormTrain: TFormTrain
  Left = 192
  Top = 107
  Width = 517
  Height = 376
  BorderIcons = [biSystemMenu]
  Caption = 'Route Builder - Browse Trains...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormCreate
  DesignSize = (
    509
    349)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 77
    Height = 13
    Caption = 'Installed Trains:'
  end
  object Image1: TImage
    Left = 192
    Top = 24
    Width = 310
    Height = 201
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object TrainList: TListBox
    Left = 8
    Top = 24
    Width = 177
    Height = 322
    Anchors = [akLeft, akTop, akBottom]
    Ctl3D = True
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 0
    OnClick = TrainListClick
  end
  object Memo1: TMemo
    Left = 192
    Top = 231
    Width = 309
    Height = 114
    Anchors = [akLeft, akRight, akBottom]
    Color = clSilver
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
