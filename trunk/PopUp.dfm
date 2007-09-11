object frmTaskPopup: TfrmTaskPopup
  Left = 192
  Top = 114
  Width = 305
  Height = 143
  ActiveControl = cbSnoozeTime
  Caption = 'Task Activated'
  Color = clBtnFace
  Constraints.MinHeight = 140
  Constraints.MinWidth = 305
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClick = FormClick
  OnClose = FormClose
  OnDestroy = FormDestroy
  DesignSize = (
    297
    109)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 46
    Width = 42
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Sn&ooze :'
    FocusControl = cbSnoozeTime
    OnClick = FormClick
  end
  object Label2: TLabel
    Left = 172
    Top = 47
    Width = 6
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '&d'
    FocusControl = seDays
    OnClick = FormClick
  end
  object Label3: TLabel
    Left = 230
    Top = 47
    Width = 6
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '&h'
    FocusControl = seHours
    OnClick = FormClick
  end
  object Label4: TLabel
    Left = 284
    Top = 47
    Width = 8
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '&m'
    FocusControl = seMinutes
    OnClick = FormClick
  end
  object mText: TMemo
    Left = 8
    Top = 8
    Width = 201
    Height = 27
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsNone
    Color = clBtnFace
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 0
    OnClick = FormClick
  end
  object cbSnoozeTime: TComboBox
    Left = 56
    Top = 42
    Width = 65
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemHeight = 13
    ItemIndex = 1
    TabOrder = 3
    Text = '5 min'
    OnChange = cbSnoozeTimeChange
    OnClick = FormClick
    Items.Strings = (
      '1 min'
      '5 min'
      '10 min'
      '15 min'
      '20 min'
      '30 min'
      '45 min'
      '1 hour'
      '2 hours'
      '3 hours'
      '8 hours'
      '12 hours'
      '1 day'
      '2 days'
      '3 days'
      '7 days')
  end
  object seDays: TSpinEdit
    Left = 128
    Top = 42
    Width = 41
    Height = 22
    Anchors = [akLeft, akBottom]
    MaxValue = 0
    MinValue = 0
    TabOrder = 4
    Value = 0
    OnClick = FormClick
  end
  object seHours: TSpinEdit
    Left = 184
    Top = 42
    Width = 41
    Height = 22
    Anchors = [akLeft, akBottom]
    MaxValue = 0
    MinValue = 0
    TabOrder = 5
    Value = 0
    OnClick = FormClick
  end
  object seMinutes: TSpinEdit
    Left = 240
    Top = 42
    Width = 41
    Height = 22
    Anchors = [akLeft, akBottom]
    MaxValue = 0
    MinValue = 0
    TabOrder = 6
    Value = 5
    OnClick = FormClick
  end
  object btnDismiss: TBitBtn
    Left = 8
    Top = 74
    Width = 113
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Dismiss'
    TabOrder = 7
    OnClick = btnDismissClick
    Kind = bkOK
  end
  object btnSnooze: TBitBtn
    Left = 128
    Top = 74
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Snooze'
    TabOrder = 8
    OnClick = btnSnoozeClick
    Kind = bkRetry
  end
  object cbComplete: TCheckBox
    Left = 216
    Top = 4
    Width = 73
    Height = 17
    Caption = '&Completed'
    TabOrder = 1
    OnClick = FormClick
  end
  object btnDelete: TBitBtn
    Left = 264
    Top = 74
    Width = 25
    Height = 25
    Anchors = [akLeft, akBottom]
    ModalResult = 1
    TabOrder = 10
    OnClick = btnDeleteClick
    Glyph.Data = {
      06030000424D060300000000000036000000280000000F0000000F0000000100
      180000000000D002000000000000000000000000000000000000FFFFFFFFFFFF
      F1F1F1CFCFCFAFAFAFA2A2A2A1A1A1A5A5A5B4B4B4CACACAE0E0E0F3F3F3FDFD
      FDFFFFFFFFFFFF000000FFFFFFF9F9F9D2D2D0BDBDAFB1B1A1ADAD9CADAD9C8F
      8F846D6D6B737373919191BBBBBBE4E4E4FBFBFBFFFFFF000000FFFFFFF0F0EC
      FAF9DBFFF2CDFFEBC3FFE6BDFFEAC2FFF2CDFFFAD8C5C5AE7D7D75707070ADAD
      ADEAEAEAFFFFFF000000FFFFFFEDE9DCFFFCDAFFE5BCFFDDB0FFD7A841B341FF
      F5E2FFF5E2FFFCEAFFFDDB99998A7B7B7BD2D2D2FDFDFD000000FDFDFDE8C599
      F9E3B3FFF7D3FFE0B4FFD4A341B34101990101990121A621CFECC2FFFFDE6767
      67BDBDBDF6F6F6000000F4F4F4F5C38CF7BF82F9CF99FCE7BCFFF4CE41B34101
      990151B951EFF9E841B341FDE9C588887FB0B0B0F0F0F0000000F0E6DBFDC993
      FDC993FDC993FDC993FEDCB841B34141B34121A621DEEFD18FD28CCED6A08E84
      77A2A2A2EAEAEA000000F0DAC2FFD3A2FFD3A2FFD3A2FFD3A2FFE7CC81CB7DFE
      F8E071C67141B34141B341DFE3BBAA9D87959595E3E3E3000000F2DABCFFDFB3
      FFDFB3FFDFB3FFDFB3FFE4BD51B95181CC7E81CC8101990141B341FFE7C6BCAC
      938A8A8ADEDEDE000000FCE6C1FFEFC9FFEFC9FFEFC9FFEFC9FFEFC9DFEAC421
      A62101990101990141B341FFF3D6D2C8AD808080D8D8D8000000FFF2CDFFFFDE
      FFFFDEFFFFDEFFFFDEFFFFDEFFFFDEEFF9DABFE6B5CFECC341B341FFFFE4DBDB
      C0757575D3D3D3000000FFF2CDFFFFDEFFFFDEFFFFDEFFFFDEFFFBD9FCEDC3F9
      E2B3FAE4B6FDF2CBFFFFDFFFFFDEFFFFDE717171D1D1D1000000FDEAD1FFD9AD
      FFD9ADFFD9ADEDD0A5ECB673EFB56FF0B673F3BA7AF5BC7EF9C890FDE9BFFFFF
      DE757575D3D3D3000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBF0E3F4
      D1A7F4BF84F8C184F9C389FBC68FFEDEB09E9E9EE1E1E1000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFBF7F8D7B2F9C895FECA95F8CE
      A5E1E1E1F7F7F7000000}
  end
  object btnProperties: TBitBtn
    Left = 232
    Top = 74
    Width = 25
    Height = 25
    Anchors = [akLeft, akBottom]
    ModalResult = 1
    TabOrder = 9
    OnClick = btnPropertiesClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
      FCFCFCE0E0E0B7B7B7ADADADBABABAC8C8C8D2D2D2DBDBDBE1E1E1E9E9E9F3F3
      F3FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFF1F1F1CEC3C0A4A49E84848070706E6C
      6C6C767676848484929292A4A4A4C8C8C8F0F0F0FFFFFFFFFFFFFFFFFFFFFFFF
      C07878CECAB6F2F4E9F2F4E9F3F5EBF4F5ECC9CAC4C1C1BDA5A6A39393929999
      99E2E2E2FFFFFFFFFFFFFFFFFFFFFFFFC07878D4CCBCF2F4E97F7F7EBDBDBBF4
      F6ECF7F8F1FAFBF7FDFDFCFFFFFF717171DDDDDDFFFFFFFFFFFFFFFFFFFFFFFF
      C07878D9CEC1F2F4E9F2F4E9F2F4E9F4F6ECF7F8F1FAFBF7FDFDFCFFFFFF7171
      71DDDDDDFFFFFFFFFFFFFFFFFFFFFFFFC07878D8CABFF2F4E97F7F7E7F7F7E7F
      7F7E7F7F7EBDBDBBFFFFFFFFFFFF717171DDDDDDFFFFFFFFFFFFFFFFFFFFFFFF
      C07878D4CDBEF2F4E9F2F4E9F2F4E9F4F6ECF7F8F1FAFBF7FDFDFCFFFFFF7171
      71DDDDDDFFFFFFFFFFFFFFFFFFFFFFFFC07878D1D0BEF2F4E97F7F7E7F7F7E7F
      7F7E7F7F7EBDBDBBFFFFFFFFFFFF717171DDDDDDFFFFFFFFFFFFFFFFFFFFFFFF
      C07878D5CDBFF2F4E9F2F4E9F2F4E9F4F6ECF7F8F1FAFBF7FDFDFCFFFFFF7171
      71DDDDDDFFFFFFFFFFFFFFFFFFFFFFFFC07878D5CEBFF2F4E97F7F7E7F7F7E7F
      7F7EBDBDBBFAFBF7FDFDFCFFFFFF717171DDDDDDFFFFFFFFFFFFFFFFFFFFFFFF
      C07878D6CFC1F2F4E9F2F4E9F2F4E9F4F6ECF7F8F1FAFBF7FDFDFCFFFFFF7171
      71DDDDDDFFFFFFFFFFFFFFFFFFFFFFFFC07878D0CDBBF2F4E9F2F4E9F2F4E9F4
      F6ECF7F8F1FAFBF7FDFDFCFFFFFF717171DDDDDDFFFFFFFFFFFFFFFFFFFFFFFF
      C07878E2C6C4426986F2F4E9426986F4F6EC426986FAFBF7426986FFFFFF7171
      71DEDEDEFFFFFFFFFFFFFFFFFFFFFFFFE7CDCDC17878C17878316B9091AABC6F
      798DD3B6B96F90A9BAB4BE5D829DA8A8A8E8E8E8FFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFF4F9CBE4BBFD4316B903E86A54BBFD4637E944BBFD46D6E845D829DDDDD
      DDF8F8F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDF
      ECF2DDEAF0DBE8EEBBD5E1E9EFF3FCFCFCFFFFFFFFFFFFFFFFFF}
  end
  object cbActive: TCheckBox
    Left = 216
    Top = 24
    Width = 73
    Height = 17
    Caption = '&Activate'
    TabOrder = 2
    OnClick = FormClick
  end
  object TimerPop: TTimer
    Interval = 30
    OnTimer = TimerPopTimer
    Left = 16
    Top = 56
  end
  object TimerFlash: TTimer
    Interval = 30000
    OnTimer = TimerFlashTimer
    Left = 48
    Top = 56
  end
end
