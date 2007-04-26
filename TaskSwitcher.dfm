object frmTaskSwitcher: TfrmTaskSwitcher
  Left = 191
  Top = 466
  Width = 440
  Height = 163
  BorderStyle = bsSizeToolWin
  Caption = 'Active Tasks'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDragDrop = FormDragDrop
  OnDragOver = FormDragOver
  PixelsPerInch = 96
  TextHeight = 13
  object ListView: TListView
    Left = 0
    Top = 0
    Width = 432
    Height = 129
    Align = alClient
    Columns = <
      item
        Caption = '#'
        Width = 22
      end
      item
        Alignment = taRightJustify
        Caption = 'ID'
        Width = 40
      end
      item
        Caption = 'Name'
        Width = 300
      end
      item
        Caption = 'Time'
      end>
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu
    TabOrder = 0
    ViewStyle = vsReport
    OnCustomDrawItem = ListViewCustomDrawItem
    OnData = ListViewData
    OnDblClick = ListViewDblClick
    OnDragDrop = FormDragDrop
    OnDragOver = FormDragOver
    OnKeyDown = ListViewKeyDown
    OnSelectItem = ListViewSelectItem
  end
  object Timer: TTimer
    Interval = 60000
    OnTimer = TimerTimer
    Left = 40
    Top = 48
  end
  object PopupMenu: TPopupMenu
    Left = 72
    Top = 48
    object Activate1: TMenuItem
      Action = acActivate
    end
    object Deactivate1: TMenuItem
      Action = acDeactivate
    end
    object askProperties1: TMenuItem
      Action = acProperties
    end
    object DeactivateandComplete1: TMenuItem
      Action = acComplete
    end
    object LogEntry1: TMenuItem
      Action = acLog
    end
  end
  object ActionList: TActionList
    Left = 104
    Top = 48
    object acActivate: TAction
      Caption = '&Activate'
      Enabled = False
      OnExecute = acActivateExecute
    end
    object acDeactivate: TAction
      Caption = '&Deactivate'
      Enabled = False
      OnExecute = acDeactivateExecute
    end
    object acProperties: TAction
      Caption = 'Task &Properties'
      Enabled = False
      OnExecute = acPropertiesExecute
    end
    object acComplete: TAction
      Caption = 'Make &Completed'
      Enabled = False
      OnExecute = acCompleteExecute
    end
    object acLog: TAction
      Caption = '&Log Entry...'
      Enabled = False
      OnExecute = acLogExecute
    end
  end
end
