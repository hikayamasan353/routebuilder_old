object FormStations: TFormStations
  Left = 206
  Top = 118
  BorderStyle = bsToolWindow
  Caption = 'Stations'
  ClientHeight = 349
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000008888888898000000000000000000000000000000000000000
    0000000000000008988888888000000888888889800000000000000000000000
    0000000000000000000000000000000898888888800000088888888980000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    0000E0070000800300007FFC0000C0030000A00500006006000000000000FFFF
    000000000000A0050000C0030000E0070000FFEF0000001F0000FFFF0000}
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 3
    Width = 39
    Height = 13
    Caption = 'Stations'
  end
  object lbStations: TListBox
    Left = 2
    Top = 17
    Width = 132
    Height = 328
    ItemHeight = 13
    TabOrder = 0
    OnClick = lbStationsClick
  end
  object GroupBox1: TGroupBox
    Left = 136
    Top = 16
    Width = 281
    Height = 329
    Caption = 'Station settings'
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 16
      Width = 27
      Height = 13
      Caption = 'Name'
    end
    object lMinStopTime: TLabel
      Left = 8
      Top = 64
      Width = 121
      Height = 13
      Caption = 'Minimal stopping duration'
    end
    object Label5: TLabel
      Left = 63
      Top = 84
      Width = 16
      Height = 13
      Caption = 'sec'
    end
    object lPeople: TLabel
      Left = 140
      Top = 64
      Width = 32
      Height = 13
      Caption = 'People'
    end
    object lPeopleNum: TLabel
      Left = 259
      Top = 79
      Width = 6
      Height = 13
      Caption = '0'
    end
    object lSounds: TLabel
      Left = 8
      Top = 112
      Width = 35
      Height = 13
      Caption = 'Sounds'
    end
    object lArrival: TLabel
      Left = 8
      Top = 132
      Width = 31
      Height = 13
      Caption = 'Arrival'
    end
    object lDeparture: TLabel
      Left = 8
      Top = 156
      Width = 49
      Height = 13
      Caption = 'Departure'
    end
    object edStationname: TEdit
      Left = 8
      Top = 32
      Width = 129
      Height = 21
      TabOrder = 0
    end
    object bAddStation: TButton
      Left = 10
      Top = 296
      Width = 33
      Height = 21
      Caption = 'Add'
      TabOrder = 9
      OnClick = bAddStationClick
    end
    object bSetStation: TButton
      Left = 48
      Top = 296
      Width = 34
      Height = 21
      Caption = 'Set'
      Default = True
      TabOrder = 10
      OnClick = bSetStationClick
    end
    object bDeleteStation: TButton
      Left = 88
      Top = 296
      Width = 43
      Height = 21
      Caption = 'Delete'
      TabOrder = 11
      OnClick = bDeleteStationClick
    end
    object edMinStopTime: TEdit
      Left = 8
      Top = 80
      Width = 49
      Height = 21
      TabOrder = 2
    end
    object tbPeople: TTrackBar
      Left = 140
      Top = 80
      Width = 117
      Height = 16
      Max = 250
      Orientation = trHorizontal
      PageSize = 10
      Frequency = 10
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 3
      ThumbLength = 10
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = tbPeopleChange
    end
    object edArrival: TEdit
      Left = 64
      Top = 128
      Width = 153
      Height = 21
      TabOrder = 4
    end
    object Panel1: TPanel
      Left = 8
      Top = 176
      Width = 241
      Height = 113
      TabOrder = 8
      object Label3: TLabel
        Left = 10
        Top = 8
        Width = 137
        Height = 13
        Caption = 'This station'#39's platform tracks'
      end
      object Label4: TLabel
        Left = 114
        Top = 31
        Width = 87
        Height = 26
        Caption = 'Add current track as platform no'
        WordWrap = True
      end
      object lbPlatformtracks: TListBox
        Left = 10
        Top = 24
        Width = 97
        Height = 81
        ItemHeight = 13
        TabOrder = 0
        OnClick = lbPlatformtracksClick
      end
      object edPlatformNo: TEdit
        Left = 114
        Top = 60
        Width = 65
        Height = 21
        TabOrder = 1
      end
      object bgo: TButton
        Left = 114
        Top = 84
        Width = 34
        Height = 21
        Caption = 'Add'
        TabOrder = 2
        OnClick = bgoClick
      end
      object bPlatformSet: TButton
        Left = 152
        Top = 84
        Width = 34
        Height = 21
        Caption = 'Set'
        TabOrder = 3
        OnClick = bPlatformSetClick
      end
      object bDeletePlatformTrack: TButton
        Left = 192
        Top = 60
        Width = 43
        Height = 21
        Caption = 'Delete'
        TabOrder = 4
        OnClick = bDeletePlatformTrackClick
      end
      object bFind: TButton
        Left = 192
        Top = 84
        Width = 43
        Height = 21
        Caption = 'Find'
        TabOrder = 5
        OnClick = bFindClick
      end
    end
    object edDeparture: TEdit
      Left = 64
      Top = 152
      Width = 153
      Height = 21
      TabOrder = 6
    end
    object bTestArrival: TButton
      Left = 222
      Top = 128
      Width = 35
      Height = 21
      Caption = 'Test'
      TabOrder = 5
      OnClick = bTestArrivalClick
    end
    object bTestDeparture: TButton
      Left = 222
      Top = 152
      Width = 35
      Height = 21
      Caption = 'Test'
      TabOrder = 7
      OnClick = bTestDepartureClick
    end
    object cbStopOpposite: TCheckBox
      Left = 144
      Top = 34
      Width = 129
      Height = 17
      Caption = 'Stopsign opposite side'
      TabOrder = 1
    end
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 368
    Top = 312
  end
  object Wave1: TWave
    Left = 336
    Top = 312
  end
end
