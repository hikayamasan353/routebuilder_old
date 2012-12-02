object FormFreeObjProperties: TFormFreeObjProperties
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Object Properties'
  ClientHeight = 331
  ClientWidth = 283
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
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000FFF0BBB0FFF00000FFF0BBB0FFF00000FFF0BBB0FFF00000FF
    F0BBB0FFF00000FFF00000FFF00000FFFFFFFFFFF000000FFFFFFFFF00000BB0
    FFFFFFF0BB0000BB0FFFFF0BB000000BB0FFF0BB00000000BB0F0BB090000000
    0BB0BB009000000000BBB00090000000000B0000000000000000000000008003
    0000800300008003000080030000800300008003000080030000000100000001
    000080030000C0030000E0030000F0030000F8230000FC630000FEFF0000}
  OldCreateOrder = False
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 36
    Height = 13
    Caption = 'Object:'
  end
  object lObjectpath: TLabel
    Left = 86
    Top = 16
    Width = 187
    Height = 49
    AutoSize = False
    Caption = ')objectpath('
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 8
    Top = 144
    Width = 67
    Height = 13
    Caption = 'vertical offset'
  end
  object Label3: TLabel
    Left = 160
    Top = 144
    Width = 8
    Height = 13
    Caption = 'm'
  end
  object Label4: TLabel
    Left = 8
    Top = 176
    Width = 67
    Height = 13
    Caption = 'rotation angle'
  end
  object Label5: TLabel
    Left = 160
    Top = 176
    Width = 5
    Height = 13
    Caption = #176
  end
  object Label6: TLabel
    Left = 8
    Top = 112
    Width = 6
    Height = 13
    Caption = 'Y'
  end
  object Label7: TLabel
    Left = 8
    Top = 80
    Width = 6
    Height = 13
    Caption = 'X'
  end
  object lMaxCube: TLabel
    Left = 8
    Top = 208
    Width = 145
    Height = 81
    AutoSize = False
    WordWrap = True
  end
  object b3DPreview: TSpeedButton
    Left = 0
    Top = 296
    Width = 20
    Height = 20
    Hint = '3D Preview'
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000130B0000130B00000000000000000000F8FBFEF6F9FF
      F5F8FEF4F6FEF0F4FDEBF1FDECF1FDE9EDFCE6E9FBE1E6F9DEE4F7E0E4F8E2E6
      F9E4E8F8E6EDF9EDF3FCF2F7FEEFF4FEEFF4FEEFF1FFE9EDFDE2E9FBDCE2F5D7
      DCF2D2D7F0CCD4F0CBD3EFCCD3F1D0D5F3D5DAF4D9E0F6DEE6F6E9EEFDE6ECFB
      E6ECFBE0E6F9D7DFF4CBD6EBCED8F0C7D2EDC0CCE9BAC6E5BAC6E5B8C2EAB6C1
      E8C1CAEDCDD5F5D7DFFBD9DFF7D3D9F1C8CEE6C3CAE3C6CEE3C3CBDAB7C1C8A4
      B1BA95A3B096A3B29BA9B6AAB6CEAAB7D5A9B7D8A8B5D7B1BDDFC6CDF0C0C7E5
      C2C8E0C9CDDFCCD2D38C9382717B5D6B745A687057676E5765725B979F94BFC3
      CCB2B9CA9EAABF91A3BDADB8DCC3CBDED9DBE4DEE0E1878F755C673B5A6A3F5E
      6D515B6D555F6E49636D395C674E9EA5A1BAC1CFAAB4C991A0BDA8B5CCC7CFD7
      DEDFE1C0BEAE58622E59672C5D6B464B56483B49434D5D4259602B525A38656C
      5CAEB7C3A7B4CB7F92AE8795A4B1BBC2CED1D191917447501D53613351593F37
      342A2F2E2C2D372B42533948562B4B563B939A9E99A7BA6D829F455358818C88
      ABAFA17475543F3C2B4F5733CFD2BB827E732E2C2928302B46544148552C3F48
      2E667373697C956F88B337485A37454F5D6664575D47343627454D2B73786844
      4C422D2E2A313A323C4939393F2E374647556F89728BB7839ECF8CA0C66B7DA1
      41516C2C37402A2F353232322E362C313D35323C37323E3937464A4D5C6C5F77
      927C94BD899FCF869DCBAFBDEAA9B5E39CA8C88B9CB5717F9A58647A51607450
      62785A6D866277977991B38098BC859AC0889BC6899DC98EA2CBA1B4DCA4B3E1
      B2C0E9BEC7E7C3CFE5BDC9E1B6C2DCA8B7D3A1B2D094A8C892A5C88FA2C68BA1
      C48AA1C393A8CAACBDDD889BC38C9EC890A2CC9DADD2A6B6D7A8B9DBA3B2D39F
      AED098A8CA8FA6C791A5C895A5C899A9C9A4B5D2B5C5E0C4D1EBACBCDDA1B0D3
      9AAACD91A3C78FA1C68EA0C58EA2C18FA3C292A6C59AACC9A7B5D2B2BEDCBEC8
      E4C7D3ECCED9EFD9E3F5CED9F3C9D6F0C5D2ECC1CDEBBECAE8BECAE8BFCBE8BB
      C8E5BECBE8C3D0E9C9D4ECCFD7F0D6DDF3DBE3F6E0E9F8EAF0FB}
    ParentShowHint = False
    ShowHint = True
    Visible = False
    OnClick = b3DPreviewClick
  end
  object lBoundTo: TLabel
    Left = 176
    Top = 200
    Width = 73
    Height = 13
    Caption = 'bound to conn:'
  end
  object Button1: TButton
    Left = 112
    Top = 296
    Width = 67
    Height = 25
    Caption = '&Cancel'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 184
    Top = 296
    Width = 67
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = Button2Click
  end
  object edVOffset: TEdit
    Left = 85
    Top = 141
    Width = 68
    Height = 21
    TabOrder = 2
  end
  object edRotation: TEdit
    Left = 85
    Top = 173
    Width = 68
    Height = 21
    TabOrder = 3
  end
  object bChange: TButton
    Left = 216
    Top = 72
    Width = 65
    Height = 17
    Caption = 'change...'
    TabOrder = 4
    OnClick = bChangeClick
  end
  object edY: TEdit
    Left = 85
    Top = 109
    Width = 68
    Height = 21
    TabOrder = 5
  end
  object edX: TEdit
    Left = 85
    Top = 77
    Width = 68
    Height = 21
    TabOrder = 6
  end
  object cbLocked: TCheckBox
    Left = 28
    Top = 299
    Width = 81
    Height = 17
    Caption = '&locked'
    TabOrder = 7
  end
  object bBind: TButton
    Left = 176
    Top = 224
    Width = 41
    Height = 25
    Hint = 'binds object to active connection'
    Caption = 'bind'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = bBindClick
  end
  object bUnbind: TButton
    Left = 224
    Top = 224
    Width = 41
    Height = 25
    Hint = 'unbind from connection'
    Caption = 'unbind'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = bUnbindClick
  end
  object stBoundto: TStaticText
    Left = 256
    Top = 200
    Width = 15
    Height = 17
    Caption = 'ID'
    TabOrder = 10
  end
end
