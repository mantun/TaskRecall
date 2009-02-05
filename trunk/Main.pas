unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, ShellAPI, Tasks, AppEvnts, XPMan,
  ComCtrls, ActiveX, ImgList, Menus, ActnList, Buttons, TaskSwitchFrame,
  VirtualTrees;

const
  WM_TRAYICON = WM_USER + 1;

type
  TCategoryTaskSelection = class(TObjectsSelection)
  private
    FCategory : TCategory;
    FComplete : Boolean;
    FIncomplete : Boolean;
    FFilter : String;
    procedure SetCategory(const value : TCategory);
    procedure SetComplete(const value : Boolean);
    procedure SetIncomplete(const value : Boolean);
    procedure SetFilter (const value : String);
    function MatchFilter(const task : TTask) : Boolean;
    function MatchCategory(const task : TTask) : Boolean;
  public
    property Category : TCategory read FCategory write SetCategory;
    property ShowComplete : Boolean read FComplete write SetComplete;
    property ShowIncomplete : Boolean read FIncomplete write SetIncomplete;
    property FilterString : String read FFilter write SetFilter;
    function Belongs(const obj : TNamedObject) : Boolean; override;
  end;
  TReminderSelection = class(TObjectsSelection)
    function Belongs(const obj : TNamedObject) : Boolean; override;
  end;
  TCategorySelection = class(TObjectsSelection)
    function Belongs(const obj : TNamedObject) : Boolean; override;
  end;

  TfrmMain = class(TForm)
    Timer: TTimer;
    ApplicationEvents: TApplicationEvents;
    XPManifest: TXPManifest;
    ActionList: TActionList;
    acAddTask: TAction;
    acChangeTask: TAction;
    acRemoveTaskFromView: TAction;
    pmTasks: TPopupMenu;
    NewTask1: TMenuItem;
    EditTask1: TMenuItem;
    DeleteTask1: TMenuItem;
    acAddCategory: TAction;
    acDeleteCategory: TAction;
    pmCategories: TPopupMenu;
    NewCategory1: TMenuItem;
    DeleteTask2: TMenuItem;
    acAddChildCategory: TAction;
    NewSubcategory1: TMenuItem;
    acAddReminder: TAction;
    acChangeReminder: TAction;
    acRemoveReminder: TAction;
    pmReminders: TPopupMenu;
    NewReminder1: TMenuItem;
    ReminderDetails1: TMenuItem;
    DeleteReminder1: TMenuItem;
    acAddToActiveTasks: TAction;
    AddToActiveTasks1: TMenuItem;
    acLogEntry: TAction;
    askLog1: TMenuItem;
    acShowTimeline: TAction;
    PageControl: TPageControl;
    tsTasks: TTabSheet;
    tsReminders: TTabSheet;
    tsActiveTasks: TTabSheet;
    Panel1: TPanel;
    eQuickNewTask: TLabeledEdit;
    eSearch: TLabeledEdit;
    cbCompleteTasks: TCheckBox;
    cbIncompleteTasks: TCheckBox;
    Splitter: TSplitter;
    RemindersListView: TListView;
    frmTaskSwitch: TfrmTaskSwitch;
    CategoryTree: TVirtualStringTree;
    TasksView: TVirtualStringTree;
    acDeleteTask: TAction;
    acCategoryColor: TAction;
    ColorDialog: TColorDialog;
    SetColor1: TMenuItem;
    btnTimeline: TBitBtn;
    NewSubtask1: TMenuItem;
    acAddSubTask: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure acAddTaskExecute(Sender: TObject);
    procedure RemindersListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure acChangeTaskExecute(Sender: TObject);
    procedure acRemoveTaskFromViewExecute(Sender: TObject);
    procedure acRemoveReminderExecute(Sender: TObject);
    procedure eQuickNewTaskKeyPress(Sender: TObject; var Key: Char);
    procedure eSearchChange(Sender: TObject);
    procedure RemindersListViewDblClick(Sender: TObject);
    procedure RemindersListViewEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure acAddReminderExecute(Sender: TObject);
    procedure acChangeReminderExecute(Sender: TObject);
    procedure cbCompleteTasksClick(Sender: TObject);
    procedure cbIncompleteTasksClick(Sender: TObject);
    procedure RemindersListViewData(Sender: TObject; Item: TListItem);
    procedure acAddToActiveTasksExecute(Sender: TObject);
    procedure acLogEntryExecute(Sender: TObject);
    procedure acShowTimelineExecute(Sender: TObject);
    procedure CategoryTreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure CategoryTreeEditing(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure CategoryTreeNewText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure CategoryTreeDragOver(Sender: TBaseVirtualTree;
      Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
      Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure CategoryTreeDragDrop(Sender: TBaseVirtualTree;
      Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
      Shift: TShiftState; Pt: TPoint; var Effect: Integer;
      Mode: TDropMode);
    procedure CategoryTreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure CategoryTreeDragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure acAddCategoryExecute(Sender: TObject);
    procedure acAddChildCategoryExecute(Sender: TObject);
    procedure CategoryTreeEdited(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure acDeleteCategoryExecute(Sender: TObject);
    procedure TasksViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TasksViewDblClick(Sender: TObject);
    procedure TasksViewFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure TasksViewNewText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure TasksViewBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure TasksViewGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure TasksViewPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure acDeleteTaskExecute(Sender: TObject);
    procedure TasksViewCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure acCategoryColorExecute(Sender: TObject);
    procedure btnTimelineClick(Sender: TObject);
    procedure RemindersListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
  private
    TrayIconData : TNotifyIconData;

    TaskSelection : TCategoryTaskSelection;
    ReminderSelection : TReminderSelection;
    CategorySelection : TCategorySelection;

    FWindowsSessionEnds : Boolean;

    procedure TrayMessage(var Msg : TMessage); message WM_TRAYICON;
    procedure KeyHookHandler(var msg : TMessage); message WM_HOTKEY;
    procedure WMEndSession(var msg : TWMEndSession); message WM_ENDSESSION;
    procedure WMQueryEndSession(var msg : TWMQueryEndSession); message WM_QUERYENDSESSION;

    procedure OnTaskAdd(Sender : TObject; obj : TNamedObject);
    procedure OnTaskDelete(Sender : TObject; obj : TNamedObject);
    procedure OnTaskChange(Sender : TObject; obj : TNamedObject);
    procedure OnReminderAdd(Sender : TObject; obj : TNamedObject);
    procedure OnReminderDelete(Sender : TObject; obj : TNamedObject);
    procedure OnReminderChange(Sender : TObject; obj : TNamedObject);
    procedure OnCategoryAdd(Sender : TObject; obj : TNamedObject);
    procedure OnCategoryDelete(Sender : TObject; obj : TNamedObject);
    procedure OnCategoryChange(Sender : TObject; obj : TNamedObject);

    function cat(pnode : PVirtualNode) : TCategory;
    function FindCatNode(category : TCategory) : PVirtualNode;
    function AddCategoryToTree(CategoryTree : TVirtualStringTree; category : TCategory) : PVirtualNode;
    procedure AddSpecialCategories;
    procedure ReindexCategories;

    function tsk(pnode : PVirtualNode) : TTask;
    function FindTaskNode(task : TTask) : PVirtualNode;
  end;

var
  frmMain: TfrmMain;

implementation

uses Math, StrMan, Parse, TaskProp, PopUp, ReminderProp, Logging, TimeGraph,
  TimelineData, TimelineForm;

{$R *.dfm}

const
  HK_ACTIVATE = 1;

  CategoryAll = '(all)';
  CategoryNone = '(none)';

  ciName = 2;
  ciPriority = 1;
  ciID = 0;

type
  PCategory = ^TCategory;
  PTask = ^TTask;  

function TCategoryTaskSelection.Belongs(const obj : TNamedObject) : Boolean;
begin
  Result := (obj is TTask);
  Result := Result and (TTask(obj).Complete and FComplete or not TTask(obj).Complete and FIncomplete);
  Result := Result and (MatchCategory(TTask(obj)) or (TTask(obj).Parent <> nil) and MatchCategory(TTask(obj).Parent));
  Result := Result and MatchFilter(TTask(obj));
end;

function TCategoryTaskSelection.MatchFilter(const task : TTask) : Boolean;
begin
  Result := (FFilter = '')
         or (sm.Pos(FFilter, task.Name, True) > 0)
         or (sm.Pos(FFilter, task.Description, True) > 0)
         or (StrToIntDef(FFilter, 0) = task.TaskID);
end;

function TCategoryTaskSelection.MatchCategory(const task : TTask) : Boolean;
begin
  Result := (FCategory = nil)
         or (FCategory.Name = CategoryAll)
         or task.HasCategory(FCategory)
         or (FCategory.Name = CategoryNone) and not task.HasCategory;
end;

procedure TCategoryTaskSelection.SetCategory(const value : TCategory);
begin
  if FCategory <> value then begin
    FCategory := value;
    ReSelectAll;
  end;
end;

procedure TCategoryTaskSelection.SetComplete(const value : Boolean);
begin
  if FComplete <> value then begin
    FComplete := value;
    ReSelectAll;
  end;
end;

procedure TCategoryTaskSelection.SetIncomplete(const value : Boolean);
begin
  if FIncomplete <> value then begin
    FIncomplete := value;
    ReSelectAll;
  end;
end;

procedure TCategoryTaskSelection.SetFilter(const value : String);
begin
  if FFilter <> value then begin
    FFilter := value;
    ReSelectAll;
  end;
end;

function TReminderSelection.Belongs(const obj : TNamedObject) : Boolean;
begin
  Result := (obj is TReminder) and (TReminder(obj).Task = nil);
end;

function TCategorySelection.Belongs(const obj : TNamedObject) : Boolean;
begin
  Result := obj is TCategory;
end;

function CompareTasks(Item1, Item2: Pointer) : Integer;
var t1, t2 : TTask;
begin
  t1 := TTask(Item1);
  t2 := TTask(Item2);
  if t1.Complete > t2.Complete then
    Result := 1
  else if t1.Complete < t2.Complete then
    Result := -1
  else if t1.Priority < t2.Priority then
    Result := 1
  else if t1.Priority > t2.Priority then
    Result := -1
  else if t1.Name > t2.Name then
    Result := 1
  else if t1.Name < t2.Name then
    Result := -1
  else
    Result := 0;
end;

function CompareReminders(Item1, Item2: Pointer) : Integer;
var o1, o2 : TNamedObject;
begin
  o1 := TNamedObject(Item1);
  o2 := TNamedObject(Item2);
  if o1.Name > o2.Name then
    Result := 1
  else if o1.Name < o2.Name then
    Result := -1
  else
    Result := 0;
end;

function CompareCategories(Item1, Item2: Pointer) : Integer;
var c1, c2 : TCategory;
begin
  c1 := TCategory(Item1);
  c2 := TCategory(Item2);
  Result := sign(c1.Index - c2.Index);
end;

function TfrmMain.tsk(pnode : PVirtualNode) : TTask;
begin
  if pnode = nil then Result := nil
  else Result := PTask(TasksView.GetNodeData(pnode))^;
end;

function TfrmMain.FindTaskNode(task : TTask) : PVirtualNode;
begin
  Result := TasksView.GetFirst;
  while (Result <> nil) and (tsk(Result) <> task) do
    Result := TasksView.GetNext(Result);
end;

procedure TfrmMain.OnTaskAdd(Sender : TObject; obj : TNamedObject);
begin
  TasksView.AddChild(nil, obj);
  TasksView.Sort(nil, TasksView.Header.SortColumn, TasksView.Header.SortDirection);
end;

procedure TfrmMain.OnTaskDelete(Sender : TObject; obj : TNamedObject);
begin
  TasksView.DeleteNode(FindTaskNode(TTask(obj)));
  acChangeTask.Enabled := TaskSelection.Count > 1;
  acLogEntry.Enabled := TaskSelection.Count > 1;
  acAddToActiveTasks.Enabled := TaskSelection.Count > 1;
  acRemoveTaskFromView.Enabled := TaskSelection.Count > 1;
end;

procedure TfrmMain.OnTaskChange(Sender : TObject; obj : TNamedObject);
begin
  TasksView.Sort(nil, ciPriority, sdAscending, True);
  TasksView.Invalidate;
end;

procedure TfrmMain.OnReminderAdd(Sender : TObject; obj : TNamedObject);
begin
  RemindersListView.Items.Count := ReminderSelection.Count;
  RemindersListView.Invalidate;
end;

procedure TfrmMain.OnReminderDelete(Sender : TObject; obj : TNamedObject);
begin
  RemindersListView.Items.Count := ReminderSelection.Count - 1;
  RemindersListView.Invalidate;
  acChangeReminder.Enabled := ReminderSelection.Count > 1;
  acRemoveReminder.Enabled := ReminderSelection.Count > 1;
end;

procedure TfrmMain.OnReminderChange(Sender : TObject; obj : TNamedObject);
begin
  RemindersListView.Invalidate;
end;

function TfrmMain.cat(pnode : PVirtualNode) : TCategory;
begin
  if pnode = nil then Result := nil
  else Result := PCategory(CategoryTree.GetNodeData(pnode))^;
end;

function TfrmMain.FindCatNode(category : TCategory) : PVirtualNode;
begin
  Result := CategoryTree.GetFirst;
  while (Result <> nil) and (cat(Result) <> category) do
    Result := CategoryTree.GetNext(Result);
end;

function TfrmMain.AddCategoryToTree(CategoryTree : TVirtualStringTree; category : TCategory) : PVirtualNode;
var pnode : PVirtualNode;
begin
  Result := nil;
  if category = nil then Exit;
  if FindCatNode(category) <> nil then Exit;
  if category.Parent <> nil then begin
    pnode := FindCatNode(category.Parent);
    if pnode = nil then
      pnode := AddCategoryToTree(CategoryTree, category.Parent);
  end else
    pnode := nil;
  Result := CategoryTree.AddChild(pnode, category);
end;

procedure TfrmMain.OnCategoryAdd(Sender : TObject; obj : TNamedObject);
begin
  AddCategoryToTree(CategoryTree, TCategory(obj));
end;

procedure TfrmMain.OnCategoryDelete(Sender : TObject; obj : TNamedObject);
var
  pnode : PVirtualNode;
  i : Integer;
begin
  pnode := FindCatNode(TCategory(obj));
  if pnode <> nil then begin
    i := 0;
    while i < CategorySelection.Count do
      if TCategory(CategorySelection[i]).Parent = obj then
        CategorySelection.Delete(CategorySelection[i])
      else
        inc(i);
    CategoryTree.DeleteNode(pnode);
  end;
end;

procedure TfrmMain.OnCategoryChange(Sender : TObject; obj : TNamedObject);
begin
  CategoryTree.Invalidate;
end;

procedure TfrmMain.AddSpecialCategories;
var
  i : Integer;
  hasAll, hasNone : Boolean;
begin
  hasAll := False;
  hasNone := False;
  for i := 0 to CategorySelection.Count - 1 do begin
    if CategorySelection[i].Name = CategoryAll then hasAll := true;
    if CategorySelection[i].Name = CategoryNone then hasNone := true;
  end;
  if not hasAll then
    CategorySelection.Add(TCategory.Create(CategoryAll, nil));
  if not hasNone then
    CategorySelection.Add(TCategory.Create(CategoryNone, nil));
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ReminderSelection := TReminderSelection.Create(TaskStorage);
  ReminderSelection.OnAdd := OnReminderAdd;
  ReminderSelection.OnItemChange := OnReminderChange;
  ReminderSelection.OnDelete := OnReminderDelete;
  ReminderSelection.PermanentSortComparator := CompareReminders;
  ReminderSelection.ReSelectAll;
  TaskSelection := TCategoryTaskSelection.Create(TaskStorage);
  TaskSelection.OnAdd := OnTaskAdd;
  TaskSelection.OnItemChange := OnTaskChange;
  TaskSelection.OnDelete := OnTaskDelete;
  TaskSelection.PermanentSortComparator := CompareTasks;
  TaskSelection.ShowIncomplete := True;
  CategorySelection := TCategorySelection.Create(TaskStorage);
  CategorySelection.OnAdd := OnCategoryAdd;
  CategorySelection.OnItemChange := OnCategoryChange;
  CategorySelection.OnDelete := OnCategoryDelete;
  CategorySelection.PermanentSortComparator := CompareCategories;
  CategorySelection.ReSelectAll;
  AddSpecialCategories;
  CategoryTree.FocusedNode := CategoryTree.GetFirst;

  with TrayIconData do begin
    cbSize := SizeOf(TrayIconData);
    Wnd := Handle;
    uID := 0;
    uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
    uCallbackMessage := WM_TRAYICON;
    hIcon := Application.Icon.Handle;
    StrPCopy(szTip, Application.Title);
  end;
  Shell_NotifyIcon(NIM_ADD, @TrayIconData);
  RegisterHotKey(Handle, HK_ACTIVATE, MOD_WIN, ord('A'));
  frmTaskSwitch.RegisterHotKeys;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  CategorySelection.Free;
  CategorySelection := nil;
  TaskSelection.Free;
  TaskSelection := nil;
  ReminderSelection.Free;
  ReminderSelection := nil;
  Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
  UnregisterHotKey(Handle, HK_ACTIVATE);
  frmTaskSwitch.UnregisterHotKeys;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FWindowsSessionEnds or
              (MessageDlg('Exit?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TaskStorage.SaveToFile(TasksFileName);
end;

procedure TfrmMain.TimerTimer(Sender: TObject);
var i : Integer;
begin
  if TaskStorage = nil then Exit;
  for i := 0 to TaskStorage.Count - 1 do
    try
      if (TaskStorage[i] is TReminder) and TReminder(TaskStorage[i]).isFireTime then
        TfrmTaskPopup.PopUp(Application, TReminder(TaskStorage[i]));
    except
      if (TaskStorage[i] is TReminder) then
        TReminder(TaskStorage[i]).SnoozeTime := 1000000; // very far in the future
      raise;  
    end;
end;

procedure TfrmMain.ApplicationEventsMinimize(Sender: TObject);
begin
  Visible := False;
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TfrmMain.KeyHookHandler(var msg : TMessage);
begin
  if msg.WParam = HK_ACTIVATE then begin
    Application.Restore;
    if WindowState = wsMinimized then
      WindowState := wsNormal;
    Visible := True;
    SetForegroundWindow(Application.Handle);
  end;
end;

procedure TfrmMain.TrayMessage(var Msg : TMessage);
begin
  case Msg.lParam of
    WM_LBUTTONDOWN, WM_RBUTTONDOWN : begin
      Application.Restore;
      if WindowState = wsMinimized then
        WindowState := wsNormal;
      Visible := True;
      SetForegroundWindow(Application.Handle);
    end;
  end;
end;

procedure TfrmMain.WMQueryEndSession(var msg : TWMQueryEndSession);
begin
  // We do not use inherited here, because the default implementation of TForm
  // calls OnCloseQuery, and we ask the user for confirmation there - exactly
  // what we are trying to prevent
  msg.Result := Integer(True);
end;

procedure TfrmMain.WMEndSession(var msg : TWMEndSession);
begin
  inherited;
  if msg.EndSession then begin
    FWindowsSessionEnds := True;
  end;
end;

procedure TfrmMain.acAddTaskExecute(Sender: TObject);
var
  t : TTask;
  vis : Boolean;
  catname : String;
begin
  t := TTask.Create;
  if (CategoryTree.FocusedNode <> nil) then begin
    catname := cat(CategoryTree.FocusedNode).Name;
    if (catname <> CategoryAll) and (catname <> CategoryNone) Then
      t.AddCategory(cat(CategoryTree.FocusedNode));
  end;
  if (TasksView.FocusedNode <> nil) and ((Sender as TComponent).Tag <> 0) then
    t.Parent := tsk(TasksView.FocusedNode);
  frmTaskProperties.Task := t;
  vis := frmTaskProperties.Visible;
  frmTaskProperties.Hide;
  frmTaskProperties.Position := poOwnerFormCenter;
  if frmTaskProperties.ShowModal = mrOK then begin
    TaskSelection.Add(t);
  end else
    t.Free;
  if vis then
    acChangeTask.Execute;
end;

procedure TfrmMain.acChangeTaskExecute(Sender: TObject);
begin
  if not frmTaskProperties.Visible then begin
    frmTaskProperties.Left := Left + Width;
    frmTaskProperties.Top := Top;
  end;
  frmTaskProperties.Show;
end;

procedure TfrmMain.acRemoveTaskFromViewExecute(Sender: TObject);
var
  t : TTask;
  c : TCategory;
begin
  if TasksView.FocusedNode <> nil then begin
    t := tsk(TasksView.FocusedNode);
    c := cat(CategoryTree.FocusedNode);
    if (c <> nil) and (c.Name <> CategoryAll) and (c.Name <> CategoryNone) and t.HasCategory then
      t.RemoveCategory(c)
    else
      if MessageDlg('Delete task "' + t.Name + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        TaskSelection.Delete(t);
  end;
end;

procedure TfrmMain.acDeleteTaskExecute(Sender: TObject);
var t : TTask;
begin
  if TasksView.FocusedNode <> nil then begin
    t := tsk(TasksView.FocusedNode);
    if MessageDlg('Delete task "' + t.Name + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      TaskSelection.Delete(t);
  end;
end;

procedure TfrmMain.acAddReminderExecute(Sender: TObject);
var
  r : TReminder;
  vis : Boolean;
begin
  r := TReminder.Create;
  frmReminderProperties.Reminder := r;
  vis := frmTaskProperties.Visible;
  frmReminderProperties.Hide;
  frmReminderProperties.Position := poOwnerFormCenter;
  if frmReminderProperties.ShowModal = mrOK then begin
    TaskSelection.Add(r);
  end else
    r.Free;
  if vis then
    acChangeReminder.Execute;
end;

procedure TfrmMain.acChangeReminderExecute(Sender: TObject);
begin
  if not frmReminderProperties.Visible then begin
    frmReminderProperties.Left := Left + Width;
    frmReminderProperties.Top := Top + frmTaskProperties.Height;
  end;
  frmReminderProperties.Show;
end;

procedure TfrmMain.acRemoveReminderExecute(Sender: TObject);
var t : TNamedObject;
begin
  if RemindersListView.Selected <> nil then begin
    t := TNamedObject(RemindersListView.Selected.Data);
    if MessageDlg('Delete "' + t.Name + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      TaskSelection.Delete(t);
  end;
end;

procedure TfrmMain.RemindersListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if (RemindersListView.Selected <> nil) and (frmReminderProperties <> nil) then
    frmReminderProperties.Reminder := TReminder(RemindersListView.Selected.Data);

  acChangeReminder.Enabled := RemindersListView.Selected <> nil;
  acRemoveReminder.Enabled := acChangeReminder.Enabled;
end;

procedure TfrmMain.eQuickNewTaskKeyPress(Sender: TObject; var Key: Char);
var t : TTask;
begin
  if (Key = #13) and (eQuickNewTask.Text <> '') then begin
    t := TTask.Create;
    t.Name := eQuickNewTask.Text;
    TaskSelection.Add(t);
    frmTaskSwitch.AddTask(t);
    eQuickNewTask.Text := '';
  end;
end;

procedure TfrmMain.eSearchChange(Sender: TObject);
begin
  TaskSelection.FilterString := eSearch.Text;
end;

procedure TfrmMain.eSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then eSearch.Text := '';
end;

procedure TfrmMain.RemindersListViewDblClick(Sender: TObject);
begin
  if RemindersListView.Selected <> nil then
    acChangeReminder.Execute
  else
    acAddReminder.Execute;
end;

procedure TfrmMain.RemindersListViewEdited(Sender: TObject; Item: TListItem;
  var S: String);
begin
  TNamedObject(Item.Data).Name := S;
end;

procedure TfrmMain.cbCompleteTasksClick(Sender: TObject);
begin
  if not cbCompleteTasks.Checked and not cbIncompleteTasks.Checked then
    cbIncompleteTasks.Checked := True;
  TaskSelection.ShowComplete := cbCompleteTasks.Checked;
end;

procedure TfrmMain.cbIncompleteTasksClick(Sender: TObject);
begin
  if not cbCompleteTasks.Checked and not cbIncompleteTasks.Checked then
    cbCompleteTasks.Checked := True;
  TaskSelection.ShowIncomplete := cbIncompleteTasks.Checked;
end;

procedure TfrmMain.RemindersListViewData(Sender: TObject; Item: TListItem);
Var o : TNamedObject;
begin
  o := ReminderSelection.Items[Item.Index];
  Item.Caption := o.Name;
  Item.Data := o;
end;

procedure TfrmMain.acAddToActiveTasksExecute(Sender: TObject);
var task : TTask;
begin
  if TasksView.FocusedNode <> nil then begin
    task := tsk(TasksView.FocusedNode);
    frmTaskSwitch.AddTask(task);
  end;
end;

procedure TfrmMain.acLogEntryExecute(Sender: TObject);
var task : TTask;
begin
  if TasksView.FocusedNode <> nil then begin
    task := tsk(TasksView.FocusedNode);
    TfrmLog.LogEntry(task);
  end;
end;

procedure TfrmMain.acShowTimelineExecute(Sender: TObject);
var
  s : TManualSelection;
  i : Integer;
begin
  s := TManualSelection.Create(TaskStorage);
  for i := 0 to TaskSelection.Count - 1 do
    s.Select(TaskSelection[i]);
  TfrmTimeline.Create(Application, s).Show;
end;

procedure TfrmMain.CategoryTreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
  CellText := cat(Node).Name;
end;

procedure TfrmMain.CategoryTreeEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var name : String;
begin
  name := cat(Node).Name;
  Allowed := (name <> CategoryAll) and (name <> CategoryNone);
end;

procedure TfrmMain.CategoryTreeNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
begin
  cat(Node).Name := NewText;
end;

procedure TfrmMain.CategoryTreeDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var category : TCategory;
begin
  category := cat(CategoryTree.DropTargetNode);
  Accept := (Source = CategoryTree)
             and (category <> nil)
             and (category.Name <> CategoryAll)
             and (category.Name <> CategoryNone)
         or (Source = TasksView)
             and (category <> nil)
             and (category.Name <> CategoryAll)
             and (TasksView.FocusedNode <> nil);
end;

procedure TfrmMain.CategoryTreeDragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var name : String;
begin
  name := cat(Node).Name;
  Allowed := (name <> CategoryAll) and (name <> CategoryNone);
end;

procedure TfrmMain.ReindexCategories;
var
  pn : PVirtualNode;
  i : Integer;
begin
  pn := CategoryTree.GetFirst;
  i := 0;
  while pn <> nil do begin
    cat(pn).Index := i;
    pn := CategoryTree.GetNext(pn);
    Inc(i);
  end;
end;

procedure TfrmMain.CategoryTreeDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  AttachMode: TVTNodeAttachMode;
  movedcat, parent : TCategory;
  task : TTask;
  name : String;
begin
  if Source = CategoryTree then begin
    Effect := DROPEFFECT_MOVE;
    if CategoryTree.FocusedNode = Sender.DropTargetNode then exit;
    case Mode of
      dmAbove : begin
        AttachMode := amInsertBefore;
        parent := cat(Sender.DropTargetNode).Parent;
      end;
      dmOnNode : begin
        AttachMode := amAddChildLast;
        parent := cat(Sender.DropTargetNode);
      end;
      dmBelow : begin
        AttachMode := amInsertAfter;
        parent := cat(Sender.DropTargetNode).Parent;
      end;
      else exit;
    end;
    movedcat := cat(CategoryTree.FocusedNode);
    CategoryTree.MoveTo(CategoryTree.FocusedNode, Sender.DropTargetNode, AttachMode, False);
    movedcat.Parent := parent;
    ReindexCategories;
  end else if Source = TasksView then begin
    if TasksView.FocusedNode = nil then Exit;
    if Mode <> dmOnNode then Exit;
    name := cat(Sender.DropTargetNode).Name;
    if name = CategoryAll then Exit;
    if name = CategoryNone then
      tsk(TasksView.FocusedNode).ClearCategories
    else
      case Effect of
        DROPEFFECT_MOVE : begin
          task := tsk(TasksView.FocusedNode);
          task.AddCategory(cat(Sender.DropTargetNode));
          task.RemoveCategory(cat(Sender.FocusedNode));
          Effect := DROPEFFECT_COPY;
        end;
        DROPEFFECT_COPY : tsk(TasksView.FocusedNode).AddCategory(cat(Sender.DropTargetNode));
      end;
  end;
end;

procedure TfrmMain.CategoryTreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  TaskSelection.Category := cat(node);
end;

procedure TfrmMain.acAddCategoryExecute(Sender: TObject);
var c : TCategory;
begin
  c := TCategory.Create('New Category', cat(CategoryTree.FocusedNode).Parent);
  CategorySelection.Add(c);
  ReindexCategories;
  CategoryTree.EditNode(FindCatNode(c), -1);
end;

procedure TfrmMain.acAddChildCategoryExecute(Sender: TObject);
var c : TCategory;
begin
  c := TCategory.Create('New Category', cat(CategoryTree.FocusedNode));
  CategorySelection.Add(c);
  ReindexCategories;
  CategoryTree.EditNode(FindCatNode(c), -1);
end;

procedure TfrmMain.CategoryTreeEdited(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  CategoryTree.Selected[node] := True;
end;

procedure TfrmMain.acDeleteCategoryExecute(Sender: TObject);
var
  c : TCategory;
  i : Integer;
begin
  c := cat(CategoryTree.FocusedNode);
  if MessageDlg('Delete category "' + c.Name + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    for i := 0 to TaskStorage.Count - 1 do
      if TaskStorage[i] is TTask then
        TTask(TaskStorage[i]).RemoveCategory(c); 
    CategorySelection.Delete(c);
    ReindexCategories;
  end;
end;

procedure TfrmMain.TasksViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and not TasksView.IsEditing then
    if ssCtrl in Shift then
      acDeleteTask.Execute
    else
      acRemoveTaskFromView.Execute
  else if (Key = VK_F2) and (TasksView.FocusedNode <> nil) then
    TasksView.EditNode(TasksView.FocusedNode, ciName);
end;

procedure TfrmMain.TasksViewDblClick(Sender: TObject);
begin
  if TasksView.FocusedNode <> nil then
    acChangeTask.Execute
  else
    if CategoryTree.FocusedNode <> nil then
      acAddTask.Execute;
end;

procedure TfrmMain.TasksViewFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  if (TasksView.FocusedNode <> nil) and (frmTaskProperties <> nil) then
    frmTaskProperties.Task := tsk(TasksView.FocusedNode);

  acChangeTask.Enabled := TasksView.FocusedNode <> nil;
  acRemoveTaskFromView.Enabled := acChangeTask.Enabled;
  acAddToActiveTasks.Enabled := acChangeTask.Enabled and not tsk(TasksView.FocusedNode).Complete;
  acLogEntry.Enabled := acChangeTask.Enabled;
end;

procedure TfrmMain.TasksViewNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
begin
  case Column of
    ciName : tsk(node).Name := NewText;
  end;
end;

procedure TfrmMain.TasksViewBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
var p, sh : Integer;
begin
  case Column of
    ciPriority : begin
          p := tsk(Node).Priority;
          if p > 10 then p := 10;
          if p < -10 then p := -10;
          sh := $FF - $FF * abs(p) div 10;
          if p >= 0 then
            TargetCanvas.Brush.Color := RGB($FF, sh, sh)
          else
            TargetCanvas.Brush.Color := RGB(sh, $FF, sh);
          TargetCanvas.FillRect(CellRect);
        end;
    ciID : begin
          TargetCanvas.Brush.Color := tsk(Node).Color;
          TargetCanvas.FillRect(CellRect);
        end;
  end;
end;

procedure TfrmMain.TasksViewGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
  case Column of
    ciID : CellText := IntToStr(tsk(Node).TaskID);
    ciPriority : CellText := IntToStr(tsk(Node).Priority);
    ciName : CellText := tsk(Node).Name;
  end;
end;

procedure TfrmMain.TasksViewPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  case Column of
    ciID : TargetCanvas.Font.Color := GetContrastColor(tsk(Node).Color);
    ciName : if tsk(Node).Complete then begin
          TargetCanvas.Font.Color := $808080;
          TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsStrikeOut];
        end;
  end;
end;

procedure TfrmMain.TasksViewCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
begin
  Result := CompareTasks(tsk(Node1), tsk(Node2));
end;

procedure TfrmMain.acCategoryColorExecute(Sender: TObject);
begin
  if CategoryTree.FocusedNode <> nil then
    if ColorDialog.Execute then begin
      cat(CategoryTree.FocusedNode).Color := ColorDialog.Color;
      TasksView.Invalidate;
    end;
end;

procedure TfrmMain.btnTimelineClick(Sender: TObject);
begin
  acShowTimeline.Execute;
end;

procedure TfrmMain.RemindersListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and not RemindersListView.IsEditing then
    acRemoveReminder.Execute
  else if (Key = VK_F2) and (RemindersListView.Selected <> nil) then
    RemindersListView.Selected.EditCaption;
end;

end.
