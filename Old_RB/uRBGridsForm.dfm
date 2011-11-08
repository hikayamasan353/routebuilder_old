object FormGrids: TFormGrids
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Layout support grids'
  ClientHeight = 224
  ClientWidth = 251
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
    0000000000002222222222222222002000000000200000200000000020000020
    0000000020002222222222222222002000000000200000200000000020000020
    0000000020002222222222222222002000000000200000200000000020000020
    000000002000222222222222222200000000000000000000000000000000FFFF
    000000000000DFF70000DFF70000DFF7000000000000DFF70000DFF70000DFF7
    000000000000DFF70000DFF70000DFF7000000000000FFFF0000FFFF0000}
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 161
    Width = 43
    Height = 13
    Caption = 'Angle ('#176')'
  end
  object Label1: TLabel
    Left = 8
    Top = 129
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object lGridInfo: TLabel
    Left = 8
    Top = 104
    Width = 12
    Height = 13
    Caption = '...'
  end
  object lbGrids: TListBox
    Left = 8
    Top = 8
    Width = 233
    Height = 89
    ItemHeight = 13
    TabOrder = 0
    OnClick = lbGridsClick
  end
  object bNewGrid: TButton
    Left = 8
    Top = 192
    Width = 75
    Height = 25
    Caption = 'New'
    TabOrder = 1
    OnClick = bNewGridClick
  end
  object edDegrees: TEdit
    Left = 64
    Top = 160
    Width = 49
    Height = 21
    TabOrder = 2
    Text = '0'
    OnChange = edDegreesChange
  end
  object edGridname: TEdit
    Left = 64
    Top = 128
    Width = 121
    Height = 21
    TabOrder = 3
    OnChange = edGridnameChange
  end
  object bApply: TButton
    Left = 168
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Set'
    Enabled = False
    TabOrder = 4
    OnClick = bApplyClick
  end
  object bDeleteGrid: TButton
    Left = 88
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Delete'
    Enabled = False
    TabOrder = 5
    OnClick = bDeleteGridClick
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 208
    Top = 136
  end
end
