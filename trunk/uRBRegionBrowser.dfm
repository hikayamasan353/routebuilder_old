object FormRegionBrowser: TFormRegionBrowser
  Left = 192
  Top = 107
  Width = 380
  Height = 320
  BorderIcons = [biSystemMenu]
  Caption = 'Region Browser'
  Color = clBtnFace
  Constraints.MinHeight = 320
  Constraints.MinWidth = 380
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Trebuchet MS'
  Font.Style = []
  OldCreateOrder = False
  OnShortCut = FormShortCut
  DesignSize = (
    372
    293)
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 147
    Height = 293
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      147
      293)
    object FileListBox1: TFileListBox
      Left = 1
      Top = 125
      Width = 145
      Height = 169
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 16
      Mask = '*.rbr'
      TabOrder = 0
      OnClick = FileListBox1Click
      OnDblClick = FileListBox1DblClick
    end
    object DriveComboBox1: TDriveComboBox
      Left = 1
      Top = 2
      Width = 145
      Height = 22
      DirList = DirectoryListBox1
      TabOrder = 1
    end
    object DirectoryListBox1: TDirectoryListBox
      Left = 1
      Top = 26
      Width = 145
      Height = 97
      FileList = FileListBox1
      ItemHeight = 16
      TabOrder = 2
    end
  end
  object bLoad: TButton
    Left = 296
    Top = 260
    Width = 70
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Load'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = bLoadClick
  end
  object stRegionfilename: TStaticText
    Left = 160
    Top = 8
    Width = 4
    Height = 4
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Trebuchet MS'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object stComment: TStaticText
    Left = 160
    Top = 32
    Width = 204
    Height = 113
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    TabOrder = 3
  end
  object stAuthor: TStaticText
    Left = 160
    Top = 160
    Width = 4
    Height = 4
    TabOrder = 4
  end
  object stFromProject: TStaticText
    Left = 160
    Top = 192
    Width = 4
    Height = 4
    TabOrder = 5
  end
end
