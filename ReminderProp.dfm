object frmReminderProperties: TfrmReminderProperties
  Left = 570
  Top = 305
  Width = 378
  Height = 183
  BorderStyle = bsSizeToolWin
  Caption = 'Reminder Properties'
  Color = clBtnFace
  Constraints.MinHeight = 120
  Constraints.MinWidth = 378
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  DesignSize = (
    370
    149)
  PixelsPerInch = 96
  TextHeight = 13
  object btnApply: TSpeedButton
    Left = 304
    Top = 16
    Width = 25
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      36060000424D3606000000000000360000002800000020000000100000000100
      18000000000000060000C40E0000C40E00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000317A362D75320000000000000000000000000000000000
      000000000000000000000000000000000000000000000000009A9A9A95959500
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000039854037833D317B372E76330000000000000000000000000000
      00000000000000000000000000000000000000000000A4A4A4A2A2A29B9B9B96
      9696000000000000000000000000000000000000000000000000000000000000
      000000429249408E4754A35C4F9F57327C382E77340000000000000000000000
      00000000000000000000000000000000000000B0B0B0ACACACC1C1C1BDBDBD9C
      9C9C979797000000000000000000000000000000000000000000000000000000
      4B9E53499A515BAC6477CA8274C87E51A059337D392F78350000000000000000
      00000000000000000000000000000000BBBBBBB7B7B7CACACAE8E8E8E5E5E5BE
      BEBE9D9D9D98989800000000000000000000000000000000000000000053A95C
      51A65A63B56D7ECE897BCC8776CA8176C98152A25A347E3A3079350000000000
      00000000000000000000000000C5C5C5C2C2C2D3D3D3EDEDEDEBEBEBE7E7E7E7
      E7E7C0C0C09E9E9E9999990000000000000000000000000000005AB46559B063
      6BBD7684D2907AC98560B26A63B46D78C98378CB8253A35C347F3A317A360000
      00000000000000000000CFCFCFCCCCCCDBDBDBF2F2F2E8E8E8D0D0D0D2D2D2E7
      E7E7E8E8E8C1C1C19E9E9E9A9A9A0000000000000000000000005EB9695BB566
      79C98680CE8D51A65A4DA156499C515CAD677CCC8679CB8554A45D35803B317B
      37000000000000000000D3D3D3D0D0D0E8E8E8EEEEEEC2C2C2BDBDBDB9B9B9CB
      CBCBEAEAEAE9E9E9C2C2C29F9F9F9B9B9B0000000000000000000000005FBA6A
      5CB6666DC07955AC5F0000000000004A9D525EAE687DCD897CCD8756A55F3681
      3C327C38000000000000000000D4D4D4D0D0D0DEDEDEC8C8C8000000000000BA
      BABACCCCCCECECECEBEBEBC4C4C4A0A0A09C9C9C000000000000000000000000
      5FBB6A5CB7670000000000000000000000004B9E535FAF697FCE8A7ECE8957A6
      6037823D337D39000000000000000000D5D5D5D1D1D100000000000000000000
      0000BBBBBBCDCDCDEDEDEDEDEDEDC5C5C5A1A1A19D9D9D000000000000000000
      0000000000000000000000000000000000000000004B9F5460B06A81CF8D7FCF
      8B58A761398540347E3A00000000000000000000000000000000000000000000
      0000000000BBBBBBCECECEEFEFEFEEEEEEC6C6C6A4A4A49E9E9E000000000000
      0000000000000000000000000000000000000000000000004CA05562B26C82D1
      8F7AC88557A66038843F00000000000000000000000000000000000000000000
      0000000000000000BCBCBCD0D0D0F1F1F1E8E8E8C5C5C5A3A3A3000000000000
      0000000000000000000000000000000000000000000000000000004DA15663B3
      6D5FAF6941914900000000000000000000000000000000000000000000000000
      0000000000000000000000BDBDBDD1D1D1CDCDCDAFAFAF000000000000000000
      0000000000000000000000000000000000000000000000000000000000004EA2
      574A9D5200000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BEBEBEBABABA000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000}
    NumGlyphs = 2
    OnClick = btnApplyClick
  end
  object btnDelete: TSpeedButton
    Left = 338
    Top = 16
    Width = 23
    Height = 22
    Hint = 'Delete Reminder...'
    Anchors = [akTop, akRight]
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      20000000000000040000C40E0000C40E00000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001E6DA3031D669D7C1D61
      98E91C5AABF50547B5F60442BCFE0345B9E30345B87AFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001F73A7821E71A7FF2B8BBDFF277D
      CEFF2565C9FF2177E6FF0579EAFF0164DDFF044DBDFC0345B87AFFFFFF00FFFF
      FF00FFFFFF00FFFFFF00207AAD471F79ADFF3098C6FF4BC8E3FF47C5E7FF074F
      BBFF639DF4FF187FFFFF0076F8FF0076EEFF0368E1FF0345B9E4FFFFFF00FFFF
      FF00FFFFFF00207FB2AE2F8EBDFF388CBAFF2B78AFFF4297C6FF0C5B95FF0442
      BCFFAECDFEFFFFFFFFFFFFFFFFFFFFFFFFFF187FEFFF0442BCFEFFFFFF00FFFF
      FF002186BAD931A0C8FF579EC8FF73BDDEFF82DEF6FF59B4DAFF0D5D91FF064C
      BAFF8DB5F6FF4D92FFFF1177FFFF2186FFFF408AEBFF0344B9DEFFFFFF00218E
      C2C632A7CFFF7ADDF2FF2E77AFFF8CE0F6FF78D0EDFF2C8AB8FF1E8DC9FF2289
      DBFF3774D1FF8DB5F7FFB8D6FEFF72A8F5FF2D6BCBFC0443BA6D2294C99A3CB4
      DAFF7CD9EEFF4FAED4FF3881B4FF4092BDFF218BBCFF2EACDFFF30B9EEFF2192
      D2FF1F7DD1FF1459C5FF0442BCFF0446B8EA0345B978FFFFFF0024A0D2E569DD
      F2FF82DDF2FF2CA4CAFF2AAAD0FF36A9D5FF36A9DCFF36B8E9FF2491CBFF2390
      CEFF24A6E3FF45BAEBFF3CACE1FF1F74A9ACFFFFFF00FFFFFF0025ADD7BC55D2
      EBFF9DE8F9FF78E1F6FF61D8F6FF52D3F7FF41C1EAFF31AADBFF2B9FD6FF2697
      D1FF27A7E0FF2BAFE9FF46B6E6FF207AB0E2FFFFFF00FFFFFF0026B4DB2526B7
      DDE626B3DAFE7ED3EBFFCBF0FBFF84DDF5FF47C6EBFF3EBDE9FF37B5E5FF2DA6
      DCFF2CACE3FF2BB0E9FF48B9E8FF2285BFF9FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0026B7DD1926B7DDBB58CBE6FFA9E0F3FFA2E3F8FF4ACBF1FF41C4EFFF3ABD
      ECFF33B8EBFF2EB4EAFF49BCEAFF248ECCFBFFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0026B7DD5339BFE0FF8AD6EBFFB6EAFAFF56CEF1FF42C3
      EEFF2BAFE9FF37B0E8FF43B8E8FF2082B6D8FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0026B7DD2526B6DBF76DCFE9FFBCEAF8FFB9E9
      F9FF71CCF0FF41B3EAFF3098D4FF207FB27FFFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0026B7DD9926B3DAE226AF
      D7F125ADD5FD35B6E2FF218FC6FE2C8DC6FF207CADB3FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0026B2DA1526B2
      D82A26B3DA1025B2D88332B4E0FF44B5EBFF2183B7FBFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0026B3DAB425ADD5FB2295C8AFFFFFFF00}
    ParentShowHint = False
    ShowHint = True
    OnClick = btnDeleteClick
  end
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 80
    Height = 13
    Caption = '&Time Expression:'
    FocusControl = mTimeStamp
  end
  object eName: TLabeledEdit
    Left = 8
    Top = 16
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 28
    EditLabel.Height = 13
    EditLabel.Caption = '&Name'
    TabOrder = 0
    OnChange = ReminderChange
    OnKeyPress = EditKeyPress
  end
  object mTimeStamp: TMemo
    Left = 8
    Top = 56
    Width = 353
    Height = 89
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Lucida Console'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    OnChange = ReminderChange
  end
end
