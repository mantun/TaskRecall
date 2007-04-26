object frmLog: TfrmLog
  Left = 192
  Top = 114
  Width = 287
  Height = 302
  Caption = 'Log'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 0
    Top = 0
    Width = 279
    Height = 268
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    WantTabs = True
    OnChange = MemoChange
  end
  object FindDialog: TFindDialog
    Options = [frDown, frHideWholeWord, frHideUpDown]
    OnFind = FindDialogFind
    Left = 64
    Top = 64
  end
  object ActionList: TActionList
    Left = 96
    Top = 64
    object acFind: TAction
      Caption = 'Find'
      ShortCut = 16454
      OnExecute = acFindExecute
    end
    object acFindNext: TAction
      Caption = 'Find &Next'
      ShortCut = 114
      OnExecute = acFindNextExecute
    end
    object acFindPrev: TAction
      Caption = 'Find &Previous'
      ShortCut = 8306
      OnExecute = acFindPrevExecute
    end
    object acSave: TAction
      Caption = '&Save'
      ShortCut = 16467
      OnExecute = acSaveExecute
    end
    object acSelectAll: TAction
      Caption = 'Select &All'
      ShortCut = 16449
      OnExecute = acSelectAllExecute
    end
    object acUndo: TAction
      Caption = '&Undo'
      ShortCut = 32776
      OnExecute = acUndoExecute
    end
  end
end
