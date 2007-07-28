unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, ShellAPI, Tasks, AppEvnts, XPMan,
  ComCtrls, ImgList, Menus, ActnList, Spin, Buttons, TaskSwitchFrame;

const
  WM_TRAYICON = WM_USER + 1;

type
  TCategorySelection = class(TObjectsSelection)
  private
    FNode : TTreeNode;
    FComplete : Boolean;
    FIncomplete : Boolean;
    procedure SetCategory(const value : TTreeNode);
    procedure SetComplete(const value : Boolean);
    procedure SetIncomplete(const value : Boolean);
  public
    property Category : TTreeNode read FNode write SetCategory;
    property ShowComplete : Boolean read FComplete write SetComplete;
    property ShowIncomplete : Boolean read FIncomplete write SetIncomplete;
    function Belongs(const obj : TNamedObject) : Boolean; override;
  end;
  TReminderSelection = class(TObjectsSelection)
    function Belongs(const obj : TNamedObject) : Boolean; override;
  end;

  TfrmMain = class(TForm)
    Timer: TTimer;
    ApplicationEvents: TApplicationEvents;
    XPManifest: TXPManifest;
    ActionList: TActionList;
    acAddTask: TAction;
    acChangeTask: TAction;
    acRemoveTask: TAction;
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
    TreeView: TTreeView;
    Splitter: TSplitter;
    TasksListView: TListView;
    RemindersListView: TListView;
    frmTaskSwitch: TfrmTaskSwitch;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure acAddTaskExecute(Sender: TObject);
    procedure acAddCategoryExecute(Sender: TObject);
    procedure acAddChildCategoryExecute(Sender: TObject);
    procedure acDeleteCategoryExecute(Sender: TObject);
    procedure TreeViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeViewDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TasksListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure RemindersListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure acChangeTaskExecute(Sender: TObject);
    procedure acRemoveTaskExecute(Sender: TObject);
    procedure acRemoveReminderExecute(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure eQuickNewTaskKeyPress(Sender: TObject; var Key: Char);
    procedure TasksListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RemindersListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TreeViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eSearchChange(Sender: TObject);
    procedure TasksListViewDblClick(Sender: TObject);
    procedure RemindersListViewDblClick(Sender: TObject);
    procedure TasksListViewEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure RemindersListViewEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure TasksListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure acAddReminderExecute(Sender: TObject);
    procedure acChangeReminderExecute(Sender: TObject);
    procedure pmCategoriesPopup(Sender: TObject);
    procedure cbCompleteTasksClick(Sender: TObject);
    procedure cbIncompleteTasksClick(Sender: TObject);
    procedure TasksListViewData(Sender: TObject; Item: TListItem);
    procedure RemindersListViewData(Sender: TObject; Item: TListItem);
    procedure TreeViewEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure TreeViewEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure acAddToActiveTasksExecute(Sender: TObject);
    procedure acLogEntryExecute(Sender: TObject);
    procedure acShowTimelineExecute(Sender: TObject);
  private
    TrayIconData : TNotifyIconData;

    TaskSelection : TCategorySelection;
    ReminderSelection : TReminderSelection;

    procedure LoadCategories;
    procedure AddCategory(const CatName : String);
    function MatchCategory(const node : TTreeNode; const obj : TNamedObject) : Boolean;

    procedure TrayMessage(var Msg : TMessage); message WM_TRAYICON;
    procedure KeyHookHandler(var msg : TMessage); message WM_HOTKEY;

    procedure OnTaskAdd(Sender : TObject; obj : TNamedObject);
    procedure OnTaskDelete(Sender : TObject; obj : TNamedObject);
    procedure OnTaskChange(Sender : TObject; obj : TNamedObject);
    procedure OnReminderAdd(Sender : TObject; obj : TNamedObject);
    procedure OnReminderDelete(Sender : TObject; obj : TNamedObject);
    procedure OnReminderChange(Sender : TObject; obj : TNamedObject);

    procedure SaveCategories;

  end;

var
  frmMain: TfrmMain;

implementation

uses Math, Parse, TaskProp, PopUp, ReminderProp, Logging,
  TimelineData, TimelineForm;

{$R *.dfm}

const
  HK_ACTIVATE = 1;
  CategoriesFileName = 'data\categories.txt';

  CategoryAll = '(all)';
  CategoryNone = '(none)';

function TCategorySelection.Belongs(const obj : TNamedObject) : Boolean;
begin
  Result := (obj is TTask) and (TTask(obj).Complete and FComplete or not TTask(obj).Complete and FIncomplete);
  Result := Result and frmMain.MatchCategory(FNode, obj);
end;

procedure TCategorySelection.SetCategory(const value : TTreeNode);
begin
  if FNode <> value then begin
    FNode := value;
    ReSelectAll;
  end;
end;

procedure TCategorySelection.SetComplete(const value : Boolean);
begin
  if FComplete <> value then begin
    FComplete := value;
    ReSelectAll;
  end;
end;

procedure TCategorySelection.SetIncomplete(const value : Boolean);
begin
  if FIncomplete <> value then begin
    FIncomplete := value;
    ReSelectAll;
  end;
end;

function TReminderSelection.Belongs(const obj : TNamedObject) : Boolean;
begin
  Result := (obj is TReminder) and (TReminder(obj).Task = nil);
end;

function CompareItems(Item1, Item2: Pointer) : Integer;
var
  o1, o2 : TNamedObject;
  t1, t2 : TTask;
begin
  o1 := TNamedObject(Item1);
  o2 := TNamedObject(Item2);
  if (o1 is TReminder) and (o2 is TTask) then
    Result := -1
  else if (o1 is TTask) and (o2 is TReminder) then
    Result := 1
  else if (o1 is TTask) and (o2 is TTask) then begin
    t1 := TTask(o1);
    t2 := TTask(o2);
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
  end else if (o1 is TReminder) and (o2 is TReminder) then begin
    if o1.Name > o2.Name then
      Result := 1
    else if o1.Name < o2.Name then
      Result := -1
    else
      Result := 0;
  end else
    Result := 0;
end;

procedure TfrmMain.OnTaskAdd(Sender : TObject; obj : TNamedObject);
begin
  TasksListView.Items.Count := TaskSelection.Count;
  TasksListView.Invalidate;
end;

procedure TfrmMain.OnTaskDelete(Sender : TObject; obj : TNamedObject);
begin
  TasksListView.Items.Count := TaskSelection.Count - 1;
  TasksListView.Invalidate;
  acChangeTask.Enabled := TaskSelection.Count > 1;
  acLogEntry.Enabled := TaskSelection.Count > 1;
  acAddToActiveTasks.Enabled := TaskSelection.Count > 1;
  acRemoveTask.Enabled := TaskSelection.Count > 1;
end;

procedure TfrmMain.OnTaskChange(Sender : TObject; obj : TNamedObject);
begin
  TasksListView.Invalidate;
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

function TfrmMain.MatchCategory(const node : TTreeNode; const obj : TNamedObject) : Boolean;
var i : Integer;
begin
  Result := node = nil;
  Result := Result or (node.Text = CategoryAll);
  Result := Result or (TTask(obj).Category = node.Text);
  Result := Result or (node.Text = CategoryNone) and (TTask(obj).Category = '');
  if not Result then
    for i := 0 to TreeView.Items.Count - 1 do
      if TreeView.Items[i].Parent = node then begin
        Result := MatchCategory(TreeView.Items[i], obj);
        if Result then Exit;
      end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ReminderSelection := TReminderSelection.Create(TaskStorage);
  ReminderSelection.OnAdd := OnReminderAdd;
  ReminderSelection.OnItemChange := OnReminderChange;
  ReminderSelection.OnDelete := OnReminderDelete;
  ReminderSelection.PermanentSortComparator := CompareItems;
  ReminderSelection.ReSelectAll;
  TaskSelection := TCategorySelection.Create(TaskStorage);
  TaskSelection.OnAdd := OnTaskAdd;
  TaskSelection.OnItemChange := OnTaskChange;
  TaskSelection.OnDelete := OnTaskDelete;
  TaskSelection.PermanentSortComparator := CompareItems;
  TaskSelection.ShowIncomplete := True;
  LoadCategories;
  TreeView.Selected := TreeView.Items[0];

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
  TaskSelection.Free;
  TaskSelection := nil;
  ReminderSelection.Free;
  ReminderSelection := nil;
  Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
  UnregisterHotKey(Handle, HK_ACTIVATE);
  frmTaskSwitch.UnregisterHotKeys;
end;

procedure TfrmMain.LoadCategories;
var i : Integer;
begin
  if FileExists(CategoriesFileName) then
    TreeView.LoadFromFile(CategoriesFileName);
  AddCategory(CategoryNone);
  AddCategory(CategoryAll);
  for i := 0 to TaskStorage.Count - 1 do
    if (TaskStorage[i] is TTask) and (TTask(TaskStorage[i]).Category <> '') then
      AddCategory(TTask(TaskStorage[i]).Category);
end;

procedure TfrmMain.AddCategory(const CatName : String);
Var i : Integer;
begin
  for i := 0 to TreeView.Items.Count - 1 do
    if TreeView.Items[i].Text = CatName then
      Exit;
  TreeView.Items.Add(nil, CatName);
end;

procedure TfrmMain.SaveCategories;
begin
  TreeView.SaveToFile(CategoriesFileName);
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := MessageDlg('Exit?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveCategories;
  TaskStorage.SaveToFile(TasksFileName);
end;

procedure TfrmMain.TimerTimer(Sender: TObject);
var i : Integer;
begin
  if TaskStorage = nil then Exit;
  for i := 0 to TaskStorage.Count - 1 do
    if (TaskStorage[i] is TReminder) and TReminder(TaskStorage[i]).isFireTime then
      TfrmTaskPopup.PopUp(Application, TReminder(TaskStorage[i]));
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

procedure TfrmMain.acAddTaskExecute(Sender: TObject);
var
  t : TTask;
  vis : Boolean;
begin
  t := TTask.Create;
  if (TreeView.Selected <> nil) and (TreeView.Selected.Text <> CategoryAll)
          and (TreeView.Selected.Text <> CategoryNone) Then
    t.Category := TreeView.Selected.Text;
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

procedure TfrmMain.acRemoveTaskExecute(Sender: TObject);
var t : TNamedObject;
begin
  if TasksListView.Selected <> nil then begin
    t := TNamedObject(TasksListView.Selected.Data);
    if MessageDlg('Delete "' + t.Name + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
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

procedure TfrmMain.acAddCategoryExecute(Sender: TObject);
var t : TTreeNode;
begin
  t := TreeView.Items.Add(nil, 'New Category');
  TreeView.Selected := t;
  if not t.EditText then
    TreeView.Items.Delete(t);
  SaveCategories;
end;

procedure TfrmMain.acAddChildCategoryExecute(Sender: TObject);
var t : TTreeNode;
begin
  if TreeView.Selected <> nil then begin
    t := TreeView.Items.AddChild(TreeView.Selected, 'New Subcategory');
    TreeView.Selected := t;
    if not t.EditText then
      TreeView.Items.Delete(t);
    SaveCategories;
  end;
end;

procedure TfrmMain.acDeleteCategoryExecute(Sender: TObject);
var i : Integer;
begin
  if (TreeView.Selected <> nil)
        and (TreeView.Selected.Text <> CategoryNone)
        and (TreeView.Selected.Text <> CategoryAll)
        and (MessageDlg('Delete category "' + TreeView.Selected.Text + '"?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
    for i := 0 to TaskStorage.Count - 1 do
      if (TaskStorage[i] is TTask) and (TreeView.Selected.Text = TTask(TaskStorage[i]).Category) then
        TTask(TaskStorage[i]).Category := '';
    TreeView.Items.Delete(TreeView.Selected);
    SaveCategories;
  end;
end;

procedure TfrmMain.TreeViewEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
var
  i : Integer;
begin
  for i := 0 to TaskStorage.Count - 1 do
    if (TaskStorage[i] is TTask) and (TTask(TaskStorage[i]).Category = Node.Text) then 
      TTask(TaskStorage[i]).Category := s;
  Node.Text := s;
  TaskSelection.ReSelectAll;
end;

procedure TfrmMain.TreeViewEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  AllowEdit := (Node.Text <> CategoryAll)
           and (Node.Text <> CategoryNone);
end;

procedure TfrmMain.TreeViewDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  AnItem : TTreeNode;
  AttachMode : TNodeAttachMode;
  HT : THitTests;
begin
  if Source = TreeView then begin
    if TreeView.Selected = nil then Exit;
    HT := TreeView.GetHitTestInfoAt(X, Y);
    AnItem := TreeView.GetNodeAt(X, Y);
    if (HT - [htOnItem, htOnIcon, htNowhere, htOnIndent] <> HT) then begin
      if (htOnItem in HT) or (htOnIcon in HT) then
        AttachMode := naAddChild
      else if htNowhere in HT then
        AttachMode := naAdd
      else if htOnIndent in HT then
        AttachMode := naInsert
      else
        AttachMode := naInsert;
      TreeView.Selected.MoveTo(AnItem, AttachMode);
      SaveCategories;
    end;
  end else if Source = TasksListView then begin
    if (TasksListView.Selected = nil) or not (TNamedObject(TasksListView.Selected.Data) is TTask) then Exit;
    AnItem := TreeView.GetNodeAt(X, Y);
    if AnItem = nil then Exit;
    if AnItem.Text = CategoryAll then Exit;
    if AnItem.Text = CategoryNone then
      TTask(TasksListView.Selected.Data).Category := ''
    else
      TTask(TasksListView.Selected.Data).Category := AnItem.Text;
  end;
end;

procedure TfrmMain.TreeViewDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var target : TTreeNode;
begin
  target := TreeView.GetNodeAt(X, Y);
  Accept := (Source = TreeView)
         or (Source = TasksListView)
             and (target <> nil)
             and (target.Text <> CategoryAll)
             and (TasksListView.Selected <> nil);
end;

procedure TfrmMain.TasksListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if (TasksListView.Selected <> nil) and (frmTaskProperties <> nil) then
    frmTaskProperties.Task := TTask(TasksListView.Selected.Data);

  acChangeTask.Enabled := TasksListView.Selected <> nil;
  acRemoveTask.Enabled := acChangeTask.Enabled;
  acAddToActiveTasks.Enabled := acChangeTask.Enabled and not TTask(TasksListView.Selected.Data).Complete;
  acLogEntry.Enabled := acChangeTask.Enabled;
end;

procedure TfrmMain.RemindersListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if (RemindersListView.Selected <> nil) and (frmReminderProperties <> nil) then
    frmReminderProperties.Reminder := TReminder(RemindersListView.Selected.Data);

  acChangeReminder.Enabled := RemindersListView.Selected <> nil;
  acRemoveReminder.Enabled := acChangeReminder.Enabled;
end;

procedure TfrmMain.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  TaskSelection.Category := Node;
end;

procedure TfrmMain.eQuickNewTaskKeyPress(Sender: TObject; var Key: Char);
var t : TTask;
begin
  if (Key = #13) and (eQuickNewTask.Text <> '') then begin
    t := TTask.Create;
    t.Name := eQuickNewTask.Text;
    t.Category := TaskSelection.Category.Text;
    TaskSelection.Add(t);
    eQuickNewTask.Text := '';
  end;
end;

procedure TfrmMain.TasksListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and not TasksListView.IsEditing then
    acRemoveTask.Execute
  else if (Key = VK_F2) and (TasksListView.Selected <> nil) then
    TasksListView.Selected.EditCaption;
end;

procedure TfrmMain.RemindersListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and not RemindersListView.IsEditing then
    acRemoveReminder.Execute
  else if (Key = VK_F2) and (RemindersListView.Selected <> nil) then
    RemindersListView.Selected.EditCaption;
end;

procedure TfrmMain.TreeViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and not TreeView.IsEditing then
    acDeleteCategory.Execute
  else if (Key = VK_F2) and (TreeView.Selected <> nil) then
    TreeView.Selected.EditText;
end;

procedure TfrmMain.eSearchChange(Sender: TObject);
begin
  ShowMessage('ne baca');
end;

procedure TfrmMain.TasksListViewDblClick(Sender: TObject);
begin
  if TasksListView.Selected <> nil then
    acChangeTask.Execute
  else
    if TreeView.Selected <> nil then
      acAddTask.Execute;
end;

procedure TfrmMain.RemindersListViewDblClick(Sender: TObject);
begin
  if RemindersListView.Selected <> nil then
    acChangeReminder.Execute
  else
    acAddReminder.Execute;
end;

procedure TfrmMain.TasksListViewEdited(Sender: TObject; Item: TListItem;
  var S: String);
begin
  TNamedObject(Item.Data).Name := S;
end;

procedure TfrmMain.RemindersListViewEdited(Sender: TObject; Item: TListItem;
  var S: String);
begin
  TNamedObject(Item.Data).Name := S;
end;

procedure TfrmMain.TasksListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var p, sh : Integer;
begin
  if TTask(Item.Data).Complete then begin
    Sender.Canvas.Font.Color := $808080;
    Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsStrikeOut];
  end else begin
    p := TTask(Item.Data).Priority;
    if p > 10 then p := 10;
    if p < -10 then p := -10;
    if p >= 0 then begin
      sh := $FF - $FF * p div 10;
      Sender.Canvas.Brush.Color := RGB($FF, sh, sh);
    end else begin
      sh := $FF * -p div 10;
      Sender.Canvas.Font.Color := RGB(0, 0, sh)
    end;
  end;
end;

procedure TfrmMain.pmCategoriesPopup(Sender: TObject);
begin
  acAddCategory.Enabled := TreeView.Selected <> nil;
  acAddChildCategory.Enabled := TreeView.Selected <> nil;
  acDeleteCategory.Enabled := (TreeView.Selected <> nil)
          and (TreeView.Selected.Text <> CategoryNone)
          and (TreeView.Selected.Text <> CategoryAll);
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

procedure TfrmMain.TasksListViewData(Sender: TObject; Item: TListItem);
Var o : TNamedObject;
begin
  o := TaskSelection.Items[Item.Index];
  Item.Caption := o.Name;
  Item.Data := o;
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
  if TasksListView.Selected <> nil then begin
    task := TTask(TasksListView.Selected.Data);
    frmTaskSwitch.AddTask(task);
  end;
end;

procedure TfrmMain.acLogEntryExecute(Sender: TObject);
var task : TTask;
begin
  if TasksListView.Selected <> nil then begin
    task := TTask(TasksListView.Selected.Data);
    TfrmLog.LogEntry(task);
  end;
end;

procedure TfrmMain.acShowTimelineExecute(Sender: TObject);
var s : TTaskSelection;
begin
  s := TTaskSelection.Create(TaskStorage);
  s.ReSelectAll;
  TfrmTimeline.Create(Application, s).Show;
end;

end.
