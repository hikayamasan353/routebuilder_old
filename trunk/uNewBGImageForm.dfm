object FormNewBGImage: TFormNewBGImage
  Left = 273
  Top = 193
  BorderStyle = bsDialog
  Caption = 'Create new background map image'
  ClientHeight = 278
  ClientWidth = 253
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF002222
    22FF222A22222222222FF992A22222FFFFFFFF99AA222FF222299FF9A2A2FF22
    22AA99F2A2A4222AA2AA22FF2224222222AAAA2F222422AAAAAAAA2FF224A222
    A2122222F224A2A2AA22A2A2F224A1AAA2121A22F224A222AAAA222FF244A1AA
    AAA22A2F2242A222212122FF24422AA2AA2A2FF22422A2A212222F2244220000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    253
    278)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 50
    Height = 13
    Caption = 'Length (X)'
  end
  object Label2: TLabel
    Left = 16
    Top = 40
    Width = 47
    Height = 13
    Caption = 'height (Y)'
  end
  object Label3: TLabel
    Left = 168
    Top = 16
    Width = 13
    Height = 13
    Caption = 'km'
  end
  object Label4: TLabel
    Left = 168
    Top = 40
    Width = 13
    Height = 13
    Caption = 'km'
  end
  object Label5: TLabel
    Left = 16
    Top = 104
    Width = 50
    Height = 13
    Caption = 'Resolution'
  end
  object Label6: TLabel
    Left = 168
    Top = 104
    Width = 39
    Height = 13
    Caption = 'Pixel/km'
  end
  object lResult: TLabel
    Left = 80
    Top = 128
    Width = 27
    Height = 11
    Caption = 'lResult'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 16
    Top = 152
    Width = 42
    Height = 13
    Caption = 'Filename'
  end
  object bCreate: TButton
    Left = 170
    Top = 245
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Create'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = bCreateClick
  end
  object bCancel: TButton
    Left = 82
    Top = 245
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = bCancelClick
  end
  object edX: TEdit
    Left = 80
    Top = 12
    Width = 81
    Height = 21
    TabOrder = 2
    Text = '3'
    OnChange = EdResolutionChange
  end
  object EdY: TEdit
    Left = 80
    Top = 36
    Width = 81
    Height = 21
    TabOrder = 3
    Text = '20'
    OnChange = EdResolutionChange
  end
  object cbGrid: TCheckBox
    Left = 16
    Top = 72
    Width = 97
    Height = 17
    Caption = '&Grid'
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 4
  end
  object EdResolution: TEdit
    Left = 80
    Top = 100
    Width = 81
    Height = 21
    TabOrder = 5
    Text = '250'
    OnChange = EdResolutionChange
  end
  object edFilename: TEdit
    Left = 80
    Top = 149
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 6
  end
end
