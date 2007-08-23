object frmMain: TfrmMain
  Left = 193
  Top = 115
  Width = 612
  Height = 348
  ActiveControl = eQuickNewTask
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
    604
    314)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 606
    Height = 316
    ActivePage = tsTasks
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabHeight = 30
    TabOrder = 0
    TabWidth = 120
    object tsTasks: TTabSheet
      Caption = 'Tasks'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      object Splitter: TSplitter
        Left = 121
        Top = 36
        Width = 6
        Height = 240
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 598
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
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
          TabOrder = 0
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
          TabOrder = 1
          OnChange = eSearchChange
        end
        object cbCompleteTasks: TCheckBox
          Left = 320
          Top = 0
          Width = 65
          Height = 17
          Caption = '&Complete'
          TabOrder = 2
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
          TabOrder = 3
          OnClick = cbIncompleteTasksClick
        end
      end
      object CategoryTree: TVirtualStringTree
        Left = 0
        Top = 36
        Width = 121
        Height = 240
        Align = alLeft
        DragOperations = [doMove]
        DragType = dtVCL
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.MainColumn = -1
        Header.Options = [hoColumnResize, hoDrag]
        NodeDataSize = 4
        PopupMenu = pmCategories
        TabOrder = 1
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.SelectionOptions = [toRightClickSelect]
        OnDragAllowed = CategoryTreeDragAllowed
        OnDragOver = CategoryTreeDragOver
        OnDragDrop = CategoryTreeDragDrop
        OnEdited = CategoryTreeEdited
        OnEditing = CategoryTreeEditing
        OnFocusChanged = CategoryTreeFocusChanged
        OnGetText = CategoryTreeGetText
        OnNewText = CategoryTreeNewText
        Columns = <>
      end
      object TasksView: TVirtualStringTree
        Left = 127
        Top = 36
        Width = 471
        Height = 240
        Align = alClient
        DragMode = dmAutomatic
        Header.AutoSizeIndex = 2
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.MainColumn = 2
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Header.SortColumn = 1
        Header.Style = hsXPStyle
        NodeDataSize = 4
        PopupMenu = pmTasks
        TabOrder = 2
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toShowDropmark, toThemeAware, toUseBlendedImages]
        OnBeforeCellPaint = TasksViewBeforeCellPaint
        OnCompareNodes = TasksViewCompareNodes
        OnDblClick = TasksViewDblClick
        OnFocusChanged = TasksViewFocusChanged
        OnGetText = TasksViewGetText
        OnPaintText = TasksViewPaintText
        OnKeyDown = TasksViewKeyDown
        OnNewText = TasksViewNewText
        Columns = <
          item
            Alignment = taRightJustify
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coFixed]
            Position = 0
            WideText = 'ID'
          end
          item
            Alignment = taRightJustify
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coFixed]
            Position = 1
            WideText = 'Priority'
          end
          item
            Position = 2
            Width = 367
            WideText = 'Name'
          end>
      end
    end
    object tsReminders: TTabSheet
      Caption = 'Reminders'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      object RemindersListView: TListView
        Left = 0
        Top = 0
        Width = 598
        Height = 276
        Align = alClient
        Columns = <>
        HideSelection = False
        OwnerData = True
        PopupMenu = pmReminders
        SortType = stData
        TabOrder = 0
        ViewStyle = vsList
        OnData = RemindersListViewData
        OnDblClick = RemindersListViewDblClick
        OnEdited = RemindersListViewEdited
        OnSelectItem = RemindersListViewSelectItem
      end
    end
    object tsActiveTasks: TTabSheet
      Caption = 'Active Tasks'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImageIndex = 2
      ParentFont = False
      inline frmTaskSwitch: TfrmTaskSwitch
        Left = 0
        Top = 0
        Width = 598
        Height = 276
        Align = alClient
        TabOrder = 0
        inherited ListView: TListView
          Width = 598
          Height = 276
        end
      end
    end
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
    object acRemoveTaskFromView: TAction
      Category = 'Tasks'
      Caption = '&Remove Task from view'
      OnExecute = acRemoveTaskFromViewExecute
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
      Enabled = False
      OnExecute = acChangeReminderExecute
    end
    object acRemoveReminder: TAction
      Category = 'Reminders'
      Caption = '&Delete Reminder...'
      Enabled = False
      OnExecute = acRemoveReminderExecute
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
    object acDeleteTask: TAction
      Category = 'Tasks'
      Caption = 'Delete Task...'
      OnExecute = acDeleteTaskExecute
    end
    object acCategoryColor: TAction
      Category = 'Categories'
      Caption = 'Set &Color...'
      OnExecute = acCategoryColorExecute
    end
  end
  object pmTasks: TPopupMenu
    Left = 136
    Top = 144
    object NewTask1: TMenuItem
      Action = acAddTask
    end
    object DeleteTask1: TMenuItem
      Action = acRemoveTaskFromView
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
    object SetColor1: TMenuItem
      Action = acCategoryColor
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
  object ColorDialog: TColorDialog
    Left = 232
    Top = 144
  end
end
