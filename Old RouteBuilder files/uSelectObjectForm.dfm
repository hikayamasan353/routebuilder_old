object FormSelectObject: TFormSelectObject
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'FormSelectObject'
  ClientHeight = 395
  ClientWidth = 271
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShortCut = FormShortCut
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inline FrmObjects1: TFrmObjects
    Left = 0
    Top = 0
    Width = 271
    Height = 354
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    inherited Label1: TLabel
      Width = 271
    end
    inherited lvObjFolders: TListView
      Width = 271
    end
    inherited lvObjects: TListView
      Width = 271
      Height = 126
      OnDblClick = FrmObjects1lvObjectsDblClick
    end
    inherited Panel1: TPanel
      Top = 271
      Width = 271
      inherited lAutor: TLabel
        Width = 225
        Anchors = [akLeft, akTop, akRight]
      end
      inherited lBitmaps: TLabel
        Width = 219
        Anchors = [akLeft, akTop, akRight]
      end
      inherited lDescription: TLabel
        Width = 204
        Anchors = [akLeft, akTop, akRight]
      end
      inherited lCopyright: TLabel
        Width = 212
        Anchors = [akLeft, akTop, akRight]
      end
      inherited b3DPreview: TSpeedButton
        Left = 242
        Anchors = [akTop, akRight]
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 354
    Width = 271
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      271
      41)
    object Button1: TButton
      Left = 189
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 108
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
end
