object frmTaskPopup: TfrmTaskPopup
  Left = 192
  Top = 114
  ActiveControl = cbSnoozeTime
  BorderStyle = bsNone
  Caption = 'Task Activated'
  ClientHeight = 109
  ClientWidth = 297
  Color = clGradientActiveCaption
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
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 297
    Height = 109
    Align = alClient
  end
  object Label1: TLabel
    Left = 8
    Top = 54
    Width = 42
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Sn&ooze :'
    FocusControl = cbSnoozeTime
    OnClick = FormClick
  end
  object Label2: TLabel
    Left = 172
    Top = 55
    Width = 6
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '&d'
    FocusControl = seDays
    OnClick = FormClick
  end
  object Label3: TLabel
    Left = 230
    Top = 55
    Width = 6
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '&h'
    FocusControl = seHours
    OnClick = FormClick
  end
  object Label4: TLabel
    Left = 284
    Top = 55
    Width = 8
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '&m'
    FocusControl = seMinutes
    OnClick = FormClick
  end
  object btnSnooze: TSpeedButton
    Left = 128
    Top = 82
    Width = 97
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = '&Snooze'
    Flat = True
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      20000000000000040000C40E0000C40E00000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0039864003347E3A78FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF004191499C3B8842D2FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004EA3579066B06EFF61AA68FF3D8B44FF37833EFF327B
      37FF2C7432EA276D2CB7236627701F61231DFFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF005BB4658473BD7CFF96D19FFF94CF9CFF8FCD96FF8ACA91FF85C7
      8BFF7ABE81FF65AD6CFF4B9251FF246829B020632439FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0060BC6C8A79C483FF9ED7A7FF9BD4A4FF97D29FFF92CF9AFF8DCC
      95FF88CA90FF7AC282FF7EC485FF5DA463FF266B2AB02265251DFFFFFF00FFFF
      FF00FFFFFF00FFFFFF0062BE6D937BC785FF77C281FF54AB5EFF4EA357FF499B
      51FF63AC6BFF83C38BFF87C98FFF82C689FF509756FF276D2C70FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0063C06E9F5FBB6AD2FFFFFF00FFFFFF00FFFF
      FF004B9E538D45964DE186C68EFF88C98FFF6FB376FF2E7633B745964D613F8E
      466139864061347E3A612E76336167C6730364C2707BFFFFFF00FFFFFF00FFFF
      FF00FFFFFF004DA1558347994FED419149F63B8842F835803CE84DA155E84799
      4FF8419149F63B8842ED35803C83FFFFFF00FFFFFF00FFFFFF00FFFFFF001E5F
      217B1B5B1E0354AB5E614EA35761499B516143934B613D8B446154AB5EB780C3
      89FF8DCC95FF83C48AFF3D8B44E137833E8DFFFFFF00FFFFFF00FFFFFF002366
      27D21F61239FFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005BB4657075BF
      7EFF98D2A1FF94CF9CFF86C78DFF5EA765FF398640FF347E3AFF2E7633FF4990
      4FFF458B4AFF20632493FFFFFF00FFFFFF00FFFFFF00FFFFFF0060BC6C1D5CB6
      67B085C98EFF9BD4A4FF8FCE98FF92CF9AFF8DCC95FF88CA90FF83C68BFF7EC4
      85FF79C17FFF478D4CFF2265258AFFFFFF00FFFFFF00FFFFFF00FFFFFF0062BE
      6D395EB968B079C383FF89CA92FF94D09CFF95D19EFF90CF99FF8CCB94FF87C9
      8FFF80C487FF4E9554FF276D2C84FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0063C06E1D5FBB6A705BB465B756AD5FEA50A65AFF4B9E53FF45964DFF60A8
      68FF5BA262FF347E3A90FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004799
      4FD24191499CFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004EA3
      5778499B5103FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
    OnClick = btnSnoozeClick
  end
  object btnDismiss: TSpeedButton
    Left = 8
    Top = 82
    Width = 113
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = '&Dismiss'
    Flat = True
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      20000000000000040000C40E0000C40E00000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00317A360A2D753207FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF003985400A37833DFF317B37FB2E763307FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004292490A408E47FF54A35CFF4F9F57FF327C38FE2E773408FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004B9E530A499A51FF5BAC64FF77CA82FF74C87EFF51A059FF337D39FE2F78
      3508FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0053A9
      5C0A51A65AFF63B56DFF7ECE89FF7BCC87FF76CA81FF76C981FF52A25AFF347E
      3AFE30793508FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005AB4650959B0
      63FF6BBD76FF84D290FF7AC985FF60B26AFF63B46DFF78C983FF78CB82FF53A3
      5CFF347F3AFD317A3608FFFFFF00FFFFFF00FFFFFF00FFFFFF005EB969465BB5
      66E479C986FF80CE8DFF51A65AFC4DA1566F499C518B5CAD67FF7CCC86FF79CB
      85FF54A45DFF35803BFC317B3708FFFFFF00FFFFFF00FFFFFF00FFFFFF005FBA
      6A3C5CB666E66DC079FF55AC5F6FFFFFFF00FFFFFF004A9D52915EAE68FF7DCD
      89FF7CCD87FF56A55FFF36813CFC327C3808FFFFFF00FFFFFF00FFFFFF00FFFF
      FF005FBB6A435CB76765FFFFFF00FFFFFF00FFFFFF00FFFFFF004B9E53915FAF
      69FF7FCE8AFF7ECE89FF57A660FF37823DFC337D3908FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004B9F
      549160B06AFF81CF8DFF7FCF8BFF58A761FF398540FF347E3A08FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004CA0559162B26CFF82D18FFF7AC885FF57A660FF38843F7BFFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004DA1569163B36DFF5FAF69FF41914979FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004EA257914A9D527FFFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
    OnClick = btnDismissClick
  end
  object btnProperties: TSpeedButton
    Left = 232
    Top = 82
    Width = 23
    Height = 22
    Hint = 'Properties...'
    Anchors = [akLeft, akBottom]
    Flat = True
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      20000000000000040000C40E0000C40E00000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00113D55F7285F87FB4988BDFB428DBCC12D77B322FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF002B6583FB94C7F9FF91C9F9FF4185C9FF1C64AAF32E79
      B92FFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A97151A9C38E
      68FFC08B66FFBE8864FF4389AAFFE0F2FFFF549AD8FF1A7ABEFF4998C5FF4081
      B6FF99796BFFAB7554FFA97353FFA97151FFA97151A9FFFFFF00C8926CFFE6E5
      E5FFE5E5E5FFE5E5E6FF97B5C9FF7AB6D5FF90B7D1FF55C9E4FF5BDFF5FF78D0
      EDFF4F9BDBFFCFD9E3FFE5E6E6FFE6E5E6FFA97251FFFFFFFF00CA946EFFE7E7
      E7FFE8E7E7FFE7E7E7FFE7E7E7FFA4C6D7FF75B8D6FFC2F6FDFF63DFF7FF5DE2
      F8FF79D3F0FF4A99DCFFE6F1FAFFE7E7E7FFAA7353FFFFFFFF00CC976FFFE9E9
      E9FFD28358FFD28358FFD28358FFE9E9E9FF89AEBFFF77CBE7FFC7F7FDFF5EDC
      F5FF5AE1F7FF7BD4F1FF4C9ADEFFC4D7E7FFAC7554FFFFFFFF00D19C73FFECEC
      ECFFECECEBFFECECEBFFECECECFFECEBECFFC3C3C3FF95BDCAFF79D3EEFFC7F7
      FDFF5FDCF5FF5BE2F7FF7AD6F2FF50A0E0FF9C7E6EFFFFFFFF00D49E75FFEFEE
      EEFFEFEFEFFFEFEEEEFFEFEEEEFFEEEFEEFFEEEEEEFFEEEFEFFFB5DEEBFF7DD4
      EEFFC4F6FDFF6CDDF6FF6DCAEDFF63A3D7FF6399C9FF5192CA26D5A076FFF1F1
      F0FFF1F0F1FFF0F1F1FFF1F0F1FFF1F1F1FFC3C3C3FFFFFFFFFFFFFFFFFFB5E6
      F5FF81D6EEFFB2E3F9FF8BC0E7FFAED3F6FFC4E0FCFF669FD3F7D8A279FFF2F2
      F2FFD28358FFD28358FFD28358FFF2F2F3FFC3C3C3FFFFFFFFFFFFFFFFFFFFFF
      FFFFB1E6F5FF77BEE7FFB4D2F0FFE5F3FFFFACD2EFFF488CC7E8D9A379FFF5F5
      F5FFF5F5F4FFF4F5F4FFF4F4F4FFF5F5F4FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3
      C3FFC3C3C3FF94BDCCFF58A5D8FF85B1DBFF469DD0FF2B95D15EDBA47AFFF6F6
      F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
      F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFBD8763FFFFFFFF00DCA77BFFDCA7
      7BFFDCA77BFFDCA77BFFDCA77BFFDCA77BFFDCA77BFFDCA77BFFDCA77BFFDCA7
      7BFFDCA77BFFDCA77BFFDCA77BFFDCA77BFFC08B66FFFFFFFF00DDAC85FDE8B9
      92FFE8B992FFE8B992FFE8B992FFE8B992FFE8B992FFE8B992FFE8B992FFE8B9
      92FFE8B992FFE8B992FFE8B992FFE8B992FFC1906FFDFFFFFF00A971516BDDB1
      8DF4DCA77BFFDCA67AFFDAA47AFFD8A279FFD5A076FFD49E75FFD29D73FFCF9A
      72FFCE9970FFCB966FFFC9946CFFC49A7AF4A971516BFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
    ParentShowHint = False
    ShowHint = True
    OnClick = btnPropertiesClick
  end
  object btnDelete: TSpeedButton
    Left = 264
    Top = 82
    Width = 23
    Height = 22
    Hint = 'Delete...'
    Anchors = [akLeft, akBottom]
    Flat = True
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
  object Shape1: TShape
    Left = 1
    Top = 1
    Width = 295
    Height = 8
    Anchors = [akLeft, akTop, akRight]
    Brush.Color = clActiveCaption
    Pen.Color = clHotLight
  end
  object mText: TMemo
    Left = 8
    Top = 16
    Width = 201
    Height = 27
    Alignment = taCenter
    Anchors = [akLeft, akRight, akBottom]
    BorderStyle = bsNone
    Ctl3D = False
    ParentColor = True
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 0
    OnClick = FormClick
  end
  object cbSnoozeTime: TComboBox
    Left = 56
    Top = 50
    Width = 65
    Height = 21
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemHeight = 13
    ItemIndex = 1
    ParentColor = True
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
    Top = 50
    Width = 41
    Height = 22
    Anchors = [akLeft, akBottom]
    MaxValue = 0
    MinValue = 0
    ParentColor = True
    TabOrder = 4
    Value = 0
    OnClick = FormClick
  end
  object seHours: TSpinEdit
    Left = 184
    Top = 50
    Width = 41
    Height = 22
    Anchors = [akLeft, akBottom]
    MaxValue = 0
    MinValue = 0
    ParentColor = True
    TabOrder = 5
    Value = 0
    OnClick = FormClick
  end
  object seMinutes: TSpinEdit
    Left = 240
    Top = 50
    Width = 41
    Height = 22
    Anchors = [akLeft, akBottom]
    MaxValue = 0
    MinValue = 0
    ParentColor = True
    TabOrder = 6
    Value = 5
    OnClick = FormClick
  end
  object cbComplete: TCheckBox
    Left = 216
    Top = 12
    Width = 73
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = '&Completed'
    TabOrder = 1
    OnClick = FormClick
  end
  object cbActive: TCheckBox
    Left = 216
    Top = 32
    Width = 73
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = '&Activate'
    TabOrder = 2
    OnClick = FormClick
  end
  object TimerPop: TTimer
    Interval = 30
    OnTimer = TimerPopTimer
    Left = 16
    Top = 16
  end
  object TimerFlash: TTimer
    Interval = 30000
    OnTimer = TimerFlashTimer
    Left = 48
    Top = 16
  end
end