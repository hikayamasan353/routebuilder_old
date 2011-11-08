object FormTimetables: TFormTimetables
  Left = 271
  Top = 171
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Timetables'
  ClientHeight = 402
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Trebuchet MS'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object lSelectTimetable: TLabel
    Left = 0
    Top = 0
    Width = 84
    Height = 16
    Caption = 'Select timetable:'
  end
  object cbTimetable: TComboBox
    Left = 0
    Top = 16
    Width = 169
    Height = 24
    Style = csDropDownList
    Ctl3D = True
    Enabled = False
    ItemHeight = 16
    ParentCtl3D = False
    TabOrder = 0
    OnSelect = cbTimetableSelect
  end
  object Panel1: TPanel
    Left = 0
    Top = 48
    Width = 465
    Height = 353
    TabOrder = 1
    object gb1: TGroupBox
      Left = 16
      Top = 8
      Width = 433
      Height = 113
      Caption = 'Timetable'
      Enabled = False
      TabOrder = 0
      object lName: TLabel
        Left = 8
        Top = 16
        Width = 31
        Height = 16
        Caption = 'Name:'
      end
      object lTrain: TLabel
        Left = 296
        Top = 16
        Width = 30
        Height = 16
        Caption = 'Train:'
      end
      object lDepTime: TLabel
        Left = 160
        Top = 16
        Width = 81
        Height = 16
        Caption = 'Departure time:'
      end
      object lDistFromPreTrain: TLabel
        Left = 8
        Top = 64
        Width = 186
        Height = 16
        Caption = 'Distance from pre-train (in seconds):'
      end
      object edName: TEdit
        Left = 8
        Top = 32
        Width = 129
        Height = 24
        TabOrder = 0
        OnClick = edNameClick
        OnExit = edNameExit
      end
      object cbTrain: TComboBox
        Left = 296
        Top = 32
        Width = 129
        Height = 24
        Style = csDropDownList
        ItemHeight = 16
        TabOrder = 2
      end
      object edDepartureTime: TMaskEdit
        Left = 160
        Top = 32
        Width = 118
        Height = 24
        EditMask = '!90:00:00;1;_'
        MaxLength = 8
        TabOrder = 1
        Text = '  :  :  '
      end
      object edDistancePreTrain: TEdit
        Left = 8
        Top = 80
        Width = 129
        Height = 24
        TabOrder = 3
        OnClick = edNameClick
        OnExit = edNameExit
      end
    end
    object gb2: TGroupBox
      Left = 16
      Top = 128
      Width = 433
      Height = 217
      Caption = 'Stops'
      Enabled = False
      TabOrder = 1
      object lTTOK: TLabel
        Left = 306
        Top = 187
        Width = 15
        Height = 16
        Caption = 'OK'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Trebuchet MS'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object lstStations: TListBox
        Left = 8
        Top = 16
        Width = 129
        Height = 161
        ItemHeight = 16
        MultiSelect = True
        TabOrder = 0
        OnDblClick = btnAddClick
      end
      object btnAdd: TButton
        Left = 144
        Top = 80
        Width = 25
        Height = 25
        Caption = '->'
        TabOrder = 1
        OnClick = btnAddClick
      end
      object btnDelete: TButton
        Left = 144
        Top = 112
        Width = 25
        Height = 25
        Caption = 'x'
        TabOrder = 2
        OnClick = btnDeleteClick
      end
      object StopsEditor: TStringGrid
        Left = 176
        Top = 16
        Width = 225
        Height = 161
        ColCount = 2
        DefaultColWidth = 110
        DefaultRowHeight = 18
        Enabled = False
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goRowMoving, goEditing, goRowSelect]
        ScrollBars = ssVertical
        TabOrder = 3
        OnSelectCell = StopsEditorSelectCell
        ColWidths = (
          107
          110)
      end
      object btnRowDown: TButton
        Left = 408
        Top = 128
        Width = 19
        Height = 17
        Caption = '6'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Webdings'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = btnRowDownClick
      end
      object btnRowUp: TButton
        Left = 408
        Top = 104
        Width = 19
        Height = 17
        Caption = '5'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Webdings'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = btnRowUpClick
      end
      object btnEditRD: TButton
        Left = 8
        Top = 188
        Width = 129
        Height = 22
        Caption = 'Route Definitions...'
        TabOrder = 6
        OnClick = btnEditRDClick
      end
      object btnApply: TButton
        Left = 328
        Top = 184
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Apply'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Trebuchet MS'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        OnClick = btnApplyClick
      end
    end
  end
  object btnNewTimetable: TButton
    Left = 176
    Top = 16
    Width = 129
    Height = 21
    Caption = 'Create new timetable...'
    TabOrder = 2
    OnClick = btnNewTimetableClick
  end
  object btnDeleteTimetable: TButton
    Left = 320
    Top = 16
    Width = 129
    Height = 21
    Caption = 'Delete'
    Enabled = False
    TabOrder = 3
    OnClick = btnDeleteTimetableClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 4000
    OnTimer = Timer1Timer
    Left = 288
    Top = 312
  end
end
