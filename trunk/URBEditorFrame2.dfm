object uEditorFrame2: TuEditorFrame2
  Left = 0
  Top = 0
  Width = 440
  Height = 348
  TabOrder = 0
  OnResize = FrameResize
  object Panel2: TPanel
    Left = 0
    Top = 307
    Width = 440
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 264
      Top = 13
      Width = 32
      Height = 13
      Caption = 'Label1'
    end
    object tbScale: TTrackBar
      Left = 16
      Top = 8
      Width = 217
      Height = 29
      Orientation = trHorizontal
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 0
      TickMarks = tmBottomRight
      TickStyle = tsAuto
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 440
    Height = 307
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    AutoSize = True
    TabOrder = 1
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 300
      Height = 163
      AutoSize = True
      Proportional = True
    end
  end
end
