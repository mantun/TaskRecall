unit TaskProp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Spin, ExtCtrls, Tasks;

type
  TfrmTaskProperties = class(TForm)
    eTaskName: TLabeledEdit;
    sePriority: TSpinEdit;
    lPriority: TLabel;
    mDescription: TMemo;
    lDescr: TLabel;
    btnApply: TSpeedButton;
    cbComplete: TCheckBox;
    btnDelete: TSpeedButton;
    eTimeSpent: TLabeledEdit;
    btnLog: TSpeedButton;
    eStartTime: TLabeledEdit;
    eEndTime: TLabeledEdit;
    cbColor: TColorBox;
    Label1: TLabel;
    mRemninderTimestamp: TMemo;
    Label2: TLabel;
    procedure TaskChange(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure btnReminderClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure cbCompleteClick(Sender: TObject);
    procedure sePriorityChange(Sender: TObject);
    procedure btnLogClick(Sender: TObject);
    procedure cbColorChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FCompleteModified : Boolean;
    FColorModified : Boolean;
    FTask : TSingletonSelection;
    procedure SetTask(const value : TTask);
    function GetTask : TTask;

    procedure OnDelete(Sender : TObject; item : TNamedObject);
    procedure OnAdd(Sender : TObject; item : TNamedObject);
    procedure OnChange(Sender : TObject; item : TNamedObject);
    procedure UpdateControls(task : TTask);
    procedure EnableControls(Enabled : Boolean);
  public
    property Task : TTask read GetTask write SetTask;
  end;

var
  frmTaskProperties: TfrmTaskProperties;

implementation

uses ReminderProp, Logging;

{$R *.dfm}

function GetTimeFromUserString(const s : string; BaseTime : TDateTime) : TDateTime;
var i, c : integer;
begin
  if s = '' then
    Result := 0
  else if (s[1] = '+') or (s[1] = '-') then begin
    i := 2;
    while (i <= Length(s)) and (s[i] in ['0'..'9']) do Inc(i);
    c := StrToInt(Copy(s, 1, i - 1));
    if (i > Length(s)) or (s[i] = 'm') then
      Result := BaseTime + c / (60 * 24)
    else if s[i] = 'h' then
      Result := BaseTime + c / 24
    else if s[i] = 'd' then
      Result := BaseTime + c
    else if s[i] = ':' then
      Result := BaseTime + StrToTime(Copy(s, 2, Length(s) - 1))
    else
      Result := BaseTime;
  end else begin
    Result := StrToDateTime(s);
    if Trunc(Result) = 0 then
      Result := Trunc(BaseTime) + Result;
  end;
end;

procedure TfrmTaskProperties.EnableControls(Enabled : Boolean);
begin
  eTaskName.Enabled := Enabled;
  sePriority.Enabled := Enabled;
  mDescription.Enabled := Enabled;
  mRemninderTimestamp.Enabled := Enabled;
  cbComplete.Enabled := Enabled;
  cbColor.Enabled := Enabled;
  eTimeSpent.Enabled := Enabled;
  eStartTime.Enabled := Enabled;
  eEndTime.Enabled := Enabled;
end;

procedure TfrmTaskProperties.UpdateControls(task : TTask);
begin
  if task.TaskID <> 0 then
    Caption := 'Task ' + IntToStr(task.TaskID)
  else
    Caption := 'New Task';
  if not eTaskName.Modified then
    eTaskName.Text := task.Name;
  if not sePriority.Modified then
    sePriority.Value := task.Priority;
  if not FColorModified then
    cbColor.Selected := task.Color;
  if not mDescription.Modified then
    mDescription.Lines.Text := task.Description;
  if not mDescription.Modified then
    mDescription.Lines.Text := task.Description;
  if not FCompleteModified then
    cbComplete.Checked := task.Complete;
  if not eTimeSpent.Modified then
    eTimeSpent.Text := task.TimeSpentAsString;
  if not eStartTime.Modified then begin
    if task.StartTime = 0 then
      eStartTime.Text := ''
    else
      eStartTime.Text := DateTimeToStr(task.StartTime);
  end;
  if not eEndTime.Modified then begin
    if task.EndTime = 0 then
      eEndTime.Text := ''
    else
      eEndTime.Text := DateTimeToStr(task.EndTime);
  end;
  if not mRemninderTimestamp.Modified then
    if task.Reminder <> nil then
      mRemninderTimestamp.Text := task.Reminder.TimeStamp;
  btnLog.Enabled := task.TaskID <> 0;
end;

procedure TfrmTaskProperties.OnDelete(Sender : TObject; item : TNamedObject);
begin
  Caption := 'Task Properties';
  eTaskName.Text := '';
  eTaskName.Modified := False;
  sePriority.Value := 0;
  sePriority.Modified := False;
  cbColor.Selected := clGray;
  FColorModified := False;
  mDescription.Lines.Clear;
  mDescription.Modified := False;
  cbComplete.Checked := False;
  FCompleteModified := False;
  eTimeSpent.Text := '';
  eTimeSpent.Modified := False;
  eStartTime.Text := '';
  eStartTime.Modified := False;
  eEndTime.Text := '';
  eEndTime.Modified := False;
  mRemninderTimestamp.Text := '';
  mRemninderTimestamp.Modified := false;
  EnableControls(False);
  btnApply.Enabled := False;
  btnDelete.Enabled := False;
  btnLog.Enabled := False;
end;

procedure TfrmTaskProperties.OnAdd(Sender : TObject; item : TNamedObject);
var task : TTask;
begin
  task := TTask(item);
  UpdateControls(task);
  EnableControls(True);
  btnApply.Enabled := False;
  btnDelete.Enabled := True;
end;

procedure TfrmTaskProperties.OnChange(Sender : TObject; item : TNamedObject);
begin
  UpdateControls(TTask(item));
end;

procedure TfrmTaskProperties.SetTask(const value : TTask);
begin
  if FTask.Item <> value then
    FTask.Item := value;
end;

function TfrmTaskProperties.GetTask : TTask;
begin
  Result := TTask(FTask.Item);
end;

procedure TfrmTaskProperties.TaskChange(Sender: TObject);
begin
  if FTask.Item <> nil then
    btnApply.Enabled := True;
end;

procedure TfrmTaskProperties.btnApplyClick(Sender: TObject);
var task : TTask;
begin
  if FTask.Item = nil then Exit;
  task := TTask(FTask.Item);
  task.BeginUpdate;
  try
    if eTaskName.Modified then begin
      task.Name := eTaskName.Text;
      eTaskName.Modified := False;
      if task.Reminder <> nil then
        task.Reminder.Name := task.Name;
    end;
    if sePriority.Modified then begin
      task.Priority := sePriority.Value;
      sePriority.Modified := False;
    end;
    if FColorModified then begin
      task.Color := cbColor.Selected;
      FColorModified := False;
    end;
    if mDescription.Modified then begin
      task.Description := mDescription.Lines.Text;
      mDescription.Modified := False;
    end;
    if eTimeSpent.Modified then begin
      task.TimeSpentAsString := eTimeSpent.Text;
      eTaskName.Modified := False;
    end;
    if eStartTime.Modified then begin
      task.StartTime := GetTimeFromUserString(eStartTime.Text, Now);
      eStartTime.Modified := False;
    end;
    if eEndTime.Modified then begin
      if task.StartTime <> 0 then
        task.EndTime := GetTimeFromUserString(eEndTime.Text, task.StartTime)
      else
        task.EndTime := GetTimeFromUserString(eEndTime.Text, Now);
      eEndTime.Modified := False;
    end;
    if FCompleteModified then begin
      if (task.EndTime = 0) and not task.Complete and cbComplete.Checked then
        task.EndTime := Now;
      task.Complete := cbComplete.Checked;
      FCompleteModified := False;
    end;
    if mRemninderTimestamp.Modified then begin
      if Trim(mRemninderTimestamp.Text) <> '' then begin
        if task.Reminder = nil then begin
          task.Reminder := TReminder.Create(task.Name);
          TaskStorage.Add(task.Reminder);
        end;
        task.Reminder.TimeStamp := mRemninderTimestamp.Text;
      end else
        if task.Reminder <> nil then
          TaskStorage.Delete(task.Reminder);
      mRemninderTimestamp.Modified := false;
    end;
  finally
    task.EndUpdate;
  end;
  btnApply.Enabled := False;
  btnLog.Enabled := task.TaskID <> 0;
  ModalResult := mrOK;
end;

procedure TfrmTaskProperties.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and btnApply.Enabled then
    btnApply.Click;
end;

procedure TfrmTaskProperties.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

procedure TfrmTaskProperties.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (Shift = [ssCtrl]) and btnApply.Enabled then begin
    btnApply.Click;
    Key := 0;
  end;
end;

procedure TfrmTaskProperties.FormCreate(Sender: TObject);
begin
  FTask := TSingletonSelection.Create(TaskStorage);
  FTask.OnAdd := OnAdd;
  FTask.OnItemChange := OnChange;
  FTask.OnDelete := OnDelete;
end;

procedure TfrmTaskProperties.btnReminderClick(Sender: TObject);
var task : TTask;
begin
  if FTask.Item = nil then Exit;
  task := TTask(FTask.Item);
  if task.Reminder = nil then begin
    task.Reminder := TReminder.Create(task.Name);
    frmReminderProperties.Selection.ClearSelection;
    frmReminderProperties.Selection.Add(task.Reminder);
  end;
  frmReminderProperties.Reminder := task.Reminder;
  if not frmReminderProperties.Visible then begin
    frmReminderProperties.Left := Left;
    frmReminderProperties.Top := Top + Height;
  end;
  frmReminderProperties.Show;
end;

procedure TfrmTaskProperties.btnDeleteClick(Sender: TObject);
begin
  if FTask.Item = nil then Exit;
  if fsModal in FormState then
    ModalResult := mrCancel
  else
    if MessageDlg('Delete task "' + FTask.Item.Name + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      FTask.Delete(FTask.Item);
end;

procedure TfrmTaskProperties.cbCompleteClick(Sender: TObject);
begin
  FCompleteModified := True;
  TaskChange(Sender);
end;

procedure TfrmTaskProperties.sePriorityChange(Sender: TObject);
begin
  sePriority.Modified := True;
  TaskChange(Sender);
end;

procedure TfrmTaskProperties.btnLogClick(Sender: TObject);
begin
  if FTask.Item <> nil then
    TfrmLog.LogEntry(TTask(FTask.Item));
end;

procedure TfrmTaskProperties.cbColorChange(Sender: TObject);
begin
  FColorModified := True;
  TaskChange(Sender);
end;

end.
