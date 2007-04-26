object frmMain: TfrmMain
  Left = 192
  Top = 114
  Width = 440
  Height = 352
  Caption = 'All reminders'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    432
    318)
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton: TSpeedButton
    Left = 400
    Top = 6
    Width = 23
    Height = 22
    Hint = 'Show active tasks...'
    Flat = True
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
      000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
      00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
      F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
      0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
      FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
      FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
      0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
      00333377737FFFFF773333303300000003333337337777777333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButtonClick
  end
  object Panel: TPanel
    Left = 0
    Top = 34
    Width = 432
    Height = 318
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter: TSplitter
      Left = 121
      Top = 0
      Width = 6
      Height = 318
    end
    object ListView: TListView
      Left = 127
      Top = 0
      Width = 305
      Height = 318
      Align = alClient
      Columns = <
        item
          Caption = 'Task'
          Width = 164
        end>
      DragMode = dmAutomatic
      HideSelection = False
      OwnerData = True
      RowSelect = True
      PopupMenu = pmTasks
      SortType = stData
      TabOrder = 0
      ViewStyle = vsList
      OnCustomDrawItem = ListViewCustomDrawItem
      OnData = ListViewData
      OnDblClick = ListViewDblClick
      OnEdited = ListViewEdited
      OnKeyDown = ListViewKeyDown
      OnSelectItem = ListViewSelectItem
    end
    object TreeView: TTreeView
      Left = 0
      Top = 0
      Width = 121
      Height = 318
      Align = alLeft
      DragMode = dmAutomatic
      HideSelection = False
      HotTrack = True
      Indent = 19
      PopupMenu = pmCategories
      TabOrder = 1
      OnChange = TreeViewChange
      OnDragDrop = TreeViewDragDrop
      OnDragOver = TreeViewDragOver
      OnEdited = TreeViewEdited
      OnEditing = TreeViewEditing
      OnKeyDown = TreeViewKeyDown
    end
  end
  object eQuickNewTask: TLabeledEdit
    Left = 88
    Top = 6
    Width = 81
    Height = 21
    BevelEdges = []
    BevelInner = bvNone
    EditLabel.Width = 83
    EditLabel.Height = 13
    EditLabel.Caption = '&Quick New Task:'
    LabelPosition = lpLeft
    TabOrder = 1
    OnKeyPress = eQuickNewTaskKeyPress
  end
  object eSearch: TLabeledEdit
    Left = 216
    Top = 6
    Width = 97
    Height = 21
    EditLabel.Width = 37
    EditLabel.Height = 13
    EditLabel.Caption = '&Search:'
    LabelPosition = lpLeft
    TabOrder = 2
    OnChange = eSearchChange
  end
  object cbCompleteTasks: TCheckBox
    Left = 320
    Top = 0
    Width = 65
    Height = 17
    Caption = '&Complete'
    TabOrder = 3
    OnClick = cbCompleteTasksClick
  end
  object cbIncompleteTasks: TCheckBox
    Left = 320
    Top = 16
    Width = 70
    Height = 17
    Caption = '&Incomplete'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = cbIncompleteTasksClick
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 8
    Top = 144
  end
  object ApplicationEvents: TApplicationEvents
    OnMinimize = ApplicationEventsMinimize
    Left = 40
    Top = 144
  end
  object XPManifest: TXPManifest
    Left = 72
    Top = 144
  end
  object ActionList: TActionList
    Left = 104
    Top = 144
    object acAddTask: TAction
      Category = 'Tasks'
      Caption = '&New Task...'
      OnExecute = acAddTaskExecute
    end
    object acChangeTask: TAction
      Category = 'Tasks'
      Caption = '&Task Details...'
      OnExecute = acChangeTaskExecute
    end
    object acRemoveTask: TAction
      Category = 'Tasks'
      Caption = '&Delete Task...'
      OnExecute = acRemoveTaskExecute
    end
    object acAddCategory: TAction
      Category = 'Categories'
      Caption = '&New Category'
      OnExecute = acAddCategoryExecute
    end
    object acDeleteCategory: TAction
      Category = 'Categories'
      Caption = '&Delete Category...'
      OnExecute = acDeleteCategoryExecute
    end
    object acAddChildCategory: TAction
      Category = 'Categories'
      Caption = 'New &Subcategory'
      OnExecute = acAddChildCategoryExecute
    end
    object acAddReminder: TAction
      Category = 'Reminders'
      Caption = '&New Reminder...'
      OnExecute = acAddReminderExecute
    end
    object acChangeReminder: TAction
      Category = 'Reminders'
      Caption = '&Reminder Details...'
      OnExecute = acChangeReminderExecute
    end
    object acRemoveReminder: TAction
      Category = 'Reminders'
      Caption = '&Delete Reminder...'
      OnExecute = acRemoveTaskExecute
    end
    object acAddToActiveTasks: TAction
      Category = 'Tasks'
      Caption = 'Add To &Active Tasks'
      OnExecute = acAddToActiveTasksExecute
    end
    object acLogEntry: TAction
      Category = 'Tasks'
      Caption = 'Task &Log...'
      OnExecute = acLogEntryExecute
    end
    object acShowTimeline: TAction
      Caption = 'Show Timeline'
      ShortCut = 16468
      OnExecute = acShowTimelineExecute
    end
  end
  object pmTasks: TPopupMenu
    Left = 136
    Top = 144
    object NewTask1: TMenuItem
      Action = acAddTask
    end
    object DeleteTask1: TMenuItem
      Action = acRemoveTask
    end
    object EditTask1: TMenuItem
      Action = acChangeTask
    end
    object AddToActiveTasks1: TMenuItem
      Action = acAddToActiveTasks
    end
    object askLog1: TMenuItem
      Action = acLogEntry
    end
  end
  object pmCategories: TPopupMenu
    OnPopup = pmCategoriesPopup
    Left = 168
    Top = 144
    object NewCategory1: TMenuItem
      Action = acAddCategory
    end
    object NewSubcategory1: TMenuItem
      Action = acAddChildCategory
    end
    object DeleteTask2: TMenuItem
      Action = acDeleteCategory
    end
  end
  object pmReminders: TPopupMenu
    Left = 200
    Top = 144
    object NewReminder1: TMenuItem
      Action = acAddReminder
    end
    object DeleteReminder1: TMenuItem
      Action = acRemoveReminder
    end
    object ReminderDetails1: TMenuItem
      Action = acChangeReminder
    end
  end
  object pmAll: TPopupMenu
    Left = 232
    Top = 144
    object NewTask2: TMenuItem
      Action = acAddTask
    end
    object DeleteTask3: TMenuItem
      Action = acRemoveTask
    end
    object askDetails1: TMenuItem
      Action = acChangeTask
    end
    object AddToActiveTasks2: TMenuItem
      Action = acAddToActiveTasks
    end
    object askLog2: TMenuItem
      Action = acLogEntry
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object NewReminder2: TMenuItem
      Action = acAddReminder
    end
    object DeleteReminder2: TMenuItem
      Action = acRemoveReminder
    end
    object ReminderDetails2: TMenuItem
      Action = acChangeReminder
    end
  end
end
