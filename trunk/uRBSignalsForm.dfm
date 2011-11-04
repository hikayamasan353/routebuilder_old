object FormSignals: TFormSignals
  Left = 174
  Top = 117
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 308
  ClientWidth = 435
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Trebuchet MS'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShortCut = FormShortCut
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object lbSignals: TListBox
    Left = 0
    Top = 0
    Width = 121
    Height = 308
    Align = alLeft
    ItemHeight = 16
    TabOrder = 0
    OnClick = lbSignalsClick
  end
  object Panel1: TPanel
    Left = 121
    Top = 0
    Width = 314
    Height = 308
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      314
      308)
    object imSignalface: TImage
      Left = 200
      Top = 16
      Width = 105
      Height = 153
    end
    object bApply: TButton
      Left = 224
      Top = 276
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Apply'
      Default = True
      TabOrder = 0
      OnClick = bApplyClick
    end
    object cbRelay: TCheckBox
      Left = 8
      Top = 56
      Width = 97
      Height = 17
      Caption = 'Relay'
      TabOrder = 1
    end
    object leSignalName: TLabeledEdit
      Left = 8
      Top = 24
      Width = 121
      Height = 24
      EditLabel.Width = 58
      EditLabel.Height = 16
      EditLabel.Caption = 'Signal Name'
      LabelPosition = lpAbove
      LabelSpacing = 3
      TabOrder = 2
    end
    object cbSignaltype: TComboBox
      Left = 8
      Top = 88
      Width = 145
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 3
      Items.Strings = (
        'Home'
        'Block'
        'Exit')
    end
    object cbAspects: TComboBox
      Left = 8
      Top = 128
      Width = 145
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 4
      Text = '2 aspects'
      Items.Strings = (
        '2 aspects'
        '3 aspects'
        '4 aspects'
        '5 aspects')
    end
    object leXoffset: TLabeledEdit
      Left = 8
      Top = 236
      Width = 121
      Height = 24
      Anchors = [akLeft, akBottom]
      EditLabel.Width = 152
      EditLabel.Height = 16
      EditLabel.Caption = 'x offset (m from track center)'
      LabelPosition = lpAbove
      LabelSpacing = 3
      TabOrder = 5
    end
    object leYoffset: TLabeledEdit
      Left = 8
      Top = 276
      Width = 121
      Height = 24
      Anchors = [akLeft, akBottom]
      EditLabel.Width = 58
      EditLabel.Height = 16
      EditLabel.Caption = 'y offset (m)'
      LabelPosition = lpAbove
      LabelSpacing = 3
      TabOrder = 6
    end
    object bMoveSignal: TButton
      Left = 224
      Top = 244
      Width = 75
      Height = 25
      Hint = 'moves signal to active connection'
      Anchors = [akLeft, akBottom]
      Caption = '&Move'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = bMoveSignalClick
    end
    object bDelete: TButton
      Left = 144
      Top = 275
      Width = 75
      Height = 25
      Anchors = [akLeft]
      Caption = '&Delete'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 8
      OnClick = bDeleteClick
    end
    object lePostName: TLabeledEdit
      Left = 8
      Top = 196
      Width = 121
      Height = 24
      Anchors = [akLeft, akBottom]
      EditLabel.Width = 201
      EditLabel.Height = 16
      EditLabel.Caption = 'signal post object name (empty=default)'
      LabelPosition = lpAbove
      LabelSpacing = 3
      TabOrder = 9
    end
    object bSelPostObj: TButton
      Left = 136
      Top = 197
      Width = 33
      Height = 22
      Caption = '...'
      TabOrder = 10
      OnClick = bSelPostObjClick
    end
    object bFind: TButton
      Left = 144
      Top = 244
      Width = 75
      Height = 25
      Hint = 'moves signal to active connection'
      Anchors = [akLeft, akBottom]
      Caption = '&Find'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
      OnClick = bFindClick
    end
  end
end
