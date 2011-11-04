object FormTimetable: TFormTimetable
  Left = 488
  Top = 249
  Width = 406
  Height = 298
  Caption = 'Route Builder- Fahrplanverwaltung'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClick = FormClick
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 8
    Top = 8
    Width = 385
    Height = 225
    ColCount = 3
    DefaultColWidth = 126
    DefaultRowHeight = 18
    RowCount = 3
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goRangeSelect, goEditing]
    ScrollBars = ssVertical
    TabOrder = 0
    OnSelectCell = StringGrid1SelectCell
    ColWidths = (
      126
      126
      126)
  end
  object UpDown1: TUpDown
    Left = 248
    Top = 32
    Width = 16
    Height = 16
    Min = 0
    Position = 0
    TabOrder = 1
    Visible = False
    Wrap = False
  end
  object UpDown2: TUpDown
    Left = 376
    Top = 32
    Width = 16
    Height = 16
    Min = 0
    Position = 0
    TabOrder = 2
    Visible = False
    Wrap = False
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 240
    Width = 105
    Height = 25
    Caption = 'calculate'
    TabOrder = 3
  end
  object BitBtn2: TBitBtn
    Left = 120
    Top = 240
    Width = 97
    Height = 25
    Caption = 'set start time...'
    TabOrder = 4
  end
end
