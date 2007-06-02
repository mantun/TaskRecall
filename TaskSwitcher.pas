unit TaskSwitcher;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, Grids, ComCtrls, Tasks, ExtCtrls, ActnList, Menus, TaskSwitch;

type
  TActiveTasksSelection = class(TObjectsSelection)
    function Belongs(const obj : TNamedObject) : Boolean; override;
  end;
  TfrmTaskSwitcher = class(TForm)
    ListView: TListView;
    Timer: TTimer;
    PopupMenu: TPopupMenu;
    ActionList: TActionList;
    acActivate: TAction;
    acDeactivate: TAction;
    acProperties: TAction;
    Activate1: TMenuItem;
    Deactivate1: TMenuItem;
    askProperties1: TMenuItem;
    acComplete: TAction;
    DeactivateandComplete1: TMenuItem;
    acLog: TAction;
    LogEntry1: TMenuItem;
    procedure ListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewDblClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ListViewData(Sender: TObject; Item: TListItem);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acActivateExecute(Sender: TObject);
    procedure acDeactivateExecute(Sender: TObject);
    procedure acPropertiesExecute(Sender: TObject);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure acCompleteExecute(Sender: TObject);
    procedure acLogExecute(Sender: TObject);
  private
    FActiveTasks : TActiveTasksSelection;
    FActiveTask : Integer;
    FTaskSwitches : TTaskSwitches;

    LastCheckTime : TDateTime;

    procedure OnItemAdd(Sender : TObject; obj : TNamedObject);
    procedure OnItemDelete(Sender : TObject; obj : TNamedObject);
    procedure OnItemChange(Sender : TObject; obj : TNamedObject);

    procedure ShowTaskProperties(const task : TTask);

    procedure RegisterHotKeys;
    procedure UnregisterHotKeys;
    procedure KeyHookHandler(var msg : TMessage); message WM_HOTKEY;
  public
    property TaskSwitches : TTaskSwitches read FTaskSwitches;
    procedure AddTask(t : TTask);
  end;

var
  frmTaskSwitcher: TfrmTaskSwitcher;

implementation

uses TaskProp, Logging, Main;

{$R *.dfm}

const
  TaskSwitchFileName = 'data\TaskSwitches.txt';
  HK_SWITCH_TASK_BASE = 10;
  HK_LOG_ENTRY = 20;

function TActiveTasksSelection.Belongs(const obj : TNamedObject) : Boolean;
begin
  Result := (obj is TTask) and (TTask(obj).ActiveNo > 0);
end;

function CompareItems(Item1, Item2: Pointer) : Integer;
var
  t1, t2 : TTask;
begin
  t1 := TTask(Item1);
  t2 := TTask(Item2);
  if t1.ActiveNo > t2.ActiveNo then
    Result := 1
  else if t1.ActiveNo < t2.ActiveNo then
    Result := -1
  else
    Result := 0;
end;

procedure TfrmTaskSwitcher.AddTask(t : TTask);
var i, no : Integer;
begin
  if t.ActiveNo = 0 then begin
    no := 1;
    for i := 0 to FActiveTasks.Count - 1 do
      if TTask(FActiveTasks[i]).ActiveNo > no then
        Break
      else
        Inc(no);
    t.ActiveNo := no;
    if t.StartTime = 0 then
      t.StartTime := Now;
  end;
  FActiveTask := t.ActiveNo;
  ListView.Invalidate;
end;

procedure TfrmTaskSwitcher.KeyHookHandler(var msg : TMessage);
var
  i : Integer;
  task : TTask;
begin
  case msg.WParam of
    10..19 : begin
      FActiveTask := msg.WParam - 10;
      ListView.Invalidate;
    end;
    20 :
      for i := 0 to FActiveTasks.Count - 1 do begin
        task := TTask(FActiveTasks[i]);
        if task.ActiveNo = FActiveTask then
          TfrmLog.LogEntry(task);
      end;
  end;
end;

procedure TfrmTaskSwitcher.RegisterHotKeys;
begin
  RegisterHotKey(Handle, HK_SWITCH_TASK_BASE + 0, MOD_WIN, ord('0'));
  RegisterHotKey(Handle, HK_SWITCH_TASK_BASE + 1, MOD_WIN, ord('1'));
  RegisterHotKey(Handle, HK_SWITCH_TASK_BASE + 2, MOD_WIN, ord('2'));
  RegisterHotKey(Handle, HK_SWITCH_TASK_BASE + 3, MOD_WIN, ord('3'));
  RegisterHotKey(Handle, HK_SWITCH_TASK_BASE + 4, MOD_WIN, ord('4'));
  RegisterHotKey(Handle, HK_SWITCH_TASK_BASE + 5, MOD_WIN, ord('5'));
  RegisterHotKey(Handle, HK_SWITCH_TASK_BASE + 6, MOD_WIN, ord('6'));
  RegisterHotKey(Handle, HK_SWITCH_TASK_BASE + 7, MOD_WIN, ord('7'));
  RegisterHotKey(Handle, HK_SWITCH_TASK_BASE + 8, MOD_WIN, ord('8'));
  RegisterHotKey(Handle, HK_SWITCH_TASK_BASE + 9, MOD_WIN, ord('9'));

  RegisterHotKey(Handle, HK_LOG_ENTRY, MOD_WIN, ord('G'));
end;

procedure TfrmTaskSwitcher.UnregisterHotKeys;
begin
  UnregisterHotKey(Handle, HK_SWITCH_TASK_BASE + 0);
  UnregisterHotKey(Handle, HK_SWITCH_TASK_BASE + 1);
  UnregisterHotKey(Handle, HK_SWITCH_TASK_BASE + 2);
  UnregisterHotKey(Handle, HK_SWITCH_TASK_BASE + 3);
  UnregisterHotKey(Handle, HK_SWITCH_TASK_BASE + 4);
  UnregisterHotKey(Handle, HK_SWITCH_TASK_BASE + 5);
  UnregisterHotKey(Handle, HK_SWITCH_TASK_BASE + 6);
  UnregisterHotKey(Handle, HK_SWITCH_TASK_BASE + 7);
  UnregisterHotKey(Handle, HK_SWITCH_TASK_BASE + 8);
  UnregisterHotKey(Handle, HK_SWITCH_TASK_BASE + 9);

  UnregisterHotKey(Handle, HK_LOG_ENTRY);
end;

procedure TfrmTaskSwitcher.ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if TTask(Item.Data).ActiveNo = FActiveTask then
    ListView.Canvas.Font.Style := [fsBold];
end;

procedure TfrmTaskSwitcher.ListViewDblClick(Sender: TObject);
begin
  acActivate.Execute;
end;

procedure TfrmTaskSwitcher.TimerTimer(Sender: TObject);
var
  i : Integer;
  task : TTask;
begin
  if FActiveTask <> 0 then begin
    for i := 0 to FActiveTasks.Count - 1 do begin
      task := TTask(FActiveTasks[i]);
      if task.ActiveNo = FActiveTask then begin
        task.TimeSpent := task.TimeSpent + (Now - LastCheckTime) * (24 * 60);
        FTaskSwitches.UpdateTaskSwitch(task);
        ListView.Invalidate;
        Break;
      end;
    end;
  end else
    FTaskSwitches.UpdateTaskSwitch(nil);
  LastCheckTime := Now;
end;

procedure TfrmTaskSwitcher.ListViewData(Sender: TObject; Item: TListItem);
var task : TTask;
begin
  task := TTask(FActiveTasks[Item.Index]);
  Item.Caption := IntToStr(task.ActiveNo);
  Item.Data := task;
  Item.SubItems.Add(IntToStr(task.TaskID));
  Item.SubItems.Add(task.Name);
  Item.SubItems.Add(task.TimeSpentAsString);
end;

procedure TfrmTaskSwitcher.ShowTaskProperties(const task : TTask);
begin
  frmTaskProperties.Task := task;
  if not frmTaskProperties.Visible then begin
    frmTaskProperties.Left := frmMain.Left + frmMain.Width;
    frmTaskProperties.Top := frmMain.Top;
  end;
  frmTaskProperties.Show;
end;

procedure TfrmTaskSwitcher.FormCreate(Sender: TObject);
begin
  FActiveTasks := TActiveTasksSelection.Create(TaskStorage);
  FActiveTasks.PermanentSortComparator := CompareItems;
  FActiveTasks.OnAdd := OnItemAdd;
  FActiveTasks.OnDelete := OnItemDelete;
  FActiveTasks.OnItemChange := OnItemChange;
  LastCheckTime := Now;
  FTaskSwitches := TTaskSwitches.Create(TaskSwitchFileName);
  FActiveTasks.ReSelectAll;
  FActiveTask := 0;
  RegisterHotKeys;
end;

procedure TfrmTaskSwitcher.FormDestroy(Sender: TObject);
begin
  UnregisterHotKeys;
  FActiveTasks.Free;
end;

procedure TfrmTaskSwitcher.OnItemAdd(Sender : TObject; obj : TNamedObject);
begin
  ListView.Items.Count := FActiveTasks.Count;
  FActiveTask := TTask(obj).ActiveNo;
  ListView.Invalidate;
end;

procedure TfrmTaskSwitcher.OnItemDelete(Sender : TObject; obj : TNamedObject);
begin
  ListView.Items.Count := FActiveTasks.Count - 1;
  if TTask(obj).ActiveNo = FActiveTask then
    FActiveTask := 0;
  ListView.Invalidate;
end;

procedure TfrmTaskSwitcher.OnItemChange(Sender : TObject; obj : TNamedObject);
begin
  ListView.Invalidate;
end;

procedure TfrmTaskSwitcher.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and (ListView.Selected <> nil) then
    TTask(ListView.Selected.Data).ActiveNo := 0;
end;

procedure TfrmTaskSwitcher.acActivateExecute(Sender: TObject);
begin
  if ListView.Selected <> nil then begin
    FActiveTask := TTask(ListView.Selected.Data).ActiveNo;
    acActivate.Enabled := False;
    acDeactivate.Enabled := True;
    ListView.Invalidate;
  end;
end;

procedure TfrmTaskSwitcher.acDeactivateExecute(Sender: TObject);
begin
  FActiveTask := 0;
  acActivate.Enabled := ListView.Selected <> nil;
  acDeactivate.Enabled := False;
  ListView.Invalidate;
end;

procedure TfrmTaskSwitcher.acPropertiesExecute(Sender: TObject);
begin
  if ListView.Selected <> nil then
    ShowTaskProperties(TTask(ListView.Selected.Data));
end;

procedure TfrmTaskSwitcher.ListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  acActivate.Enabled := (ListView.Selected <> nil)
          and (FActiveTask <> TTask(ListView.Selected.Data).ActiveNo);
  acDeactivate.Enabled := not acActivate.Enabled;
  acProperties.Enabled := ListView.Selected <> nil;
  acLog.Enabled := ListView.Selected <> nil;
  acComplete.Enabled := ListView.Selected <> nil;
end;

procedure TfrmTaskSwitcher.acCompleteExecute(Sender: TObject);
var t : TTask;
begin
  if ListView.Selected <> nil then begin
    t := TTask(ListView.Selected.Data);
    t.Complete := True;
    if t.EndTime = 0 then
      t.EndTime := Now;
  end;
end;

procedure TfrmTaskSwitcher.acLogExecute(Sender: TObject);
begin
  if ListView.Selected <> nil then
    TfrmLog.LogEntry(TTask(ListView.Selected.Data));
end;

end.
