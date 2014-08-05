object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ForceForegroundWindow'
  ClientHeight = 224
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 71
    Height = 13
    Caption = 'Window name:'
  end
  object Button1: TButton
    Left = 202
    Top = 191
    Width = 75
    Height = 25
    Caption = 'Method 1'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 283
    Top = 191
    Width = 75
    Height = 25
    Caption = 'Method 2'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 364
    Top = 191
    Width = 75
    Height = 25
    Caption = 'Method 3'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 85
    Top = 8
    Width = 354
    Height = 21
    TabOrder = 0
  end
  object Button4: TButton
    Left = 85
    Top = 191
    Width = 75
    Height = 25
    Caption = 'Start Timer'
    TabOrder = 2
    OnClick = Button4Click
  end
  object ListBox1: TListBox
    Left = 85
    Top = 35
    Width = 354
    Height = 150
    ItemHeight = 13
    TabOrder = 1
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = Timer1Timer
  end
end
