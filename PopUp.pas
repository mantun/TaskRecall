unit PopUp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Spin, Tasks, ExtCtrls;

type
  TPopState = (psShowing, psWaiting, psHiding, psEnd);
  TfrmTaskPopup = class(TForm)
    mText: TMemo;
    cbSnoozeTime: TComboBox;
    Label1: TLabel;
    seDays: TSpinEdit;
    seHours: TSpinEdit;
    seMinutes: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    TimerPop: TTimer;
    TimerFlash: TTimer;
    cbComplete: TCheckBox;
    cbActive: TCheckBox;
    btnDismiss: TSpeedButton;
    Bevel1: TBevel;
    btnSnooze: TSpeedButton;
    btnProperties: TSpeedButton;
    btnDelete: TSpeedButton;
    Shape1: TShape;
    procedure cbSnoozeTimeChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSnoozeClick(Sender: TObject);
    procedure btnDismissClick(Sender: TObject);
    procedure TimerPopTimer(Sender: TObject);
    procedure TimerFlashTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnPropertiesClick(Sender: TObject);
    procedure cbCompleteClick(Sender: TObject);
    procedure cbActiveClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FReminder : TSingletonSelection;
    FPopState : TPopState;
    FPopStateTime : TDateTime;
    procedure OnDelete(Sender : TObject; item : TNamedObject);
    procedure WMNCHitTest(var msg: TWMNCHitTest); message WM_NCHITTEST;
  protected
    procedure CreateParams(var Params: TCreateParams); Override;
  public
    constructor PopUp(AOwner : TComponent; Reminder : TReminder);
  end;

var
  frmTaskPopup: TfrmTaskPopup;

implementation

uses TaskProp, ReminderProp, Types, Main;

{$R *.dfm}

constructor TfrmTaskPopup.PopUp(AOwner : TComponent; Reminder : TReminder);
begin
  Create(AOwner);
  FReminder := TSingletonSelection.Create(TaskStorage);
  FReminder.OnDelete := OnDelete;
  FReminder.Item := Reminder;
  mText.Text := Reminder.Name;
  if Reminder.Task <> nil then
    cbComplete.Checked := Reminder.Task.Complete
  else begin
    cbComplete.Enabled := False;
    cbActive.Enabled := False;
  end;
  Caption := DateTimeToStr(Reminder.GetFireTime);
  Left := Screen.WorkAreaRect.Right - Width - 10;
  Top := Screen.WorkAreaRect.Bottom - Height - 10;
  AlphaBlend := True;
  AlphaBlendValue := 0;
  FPopState := psShowing; 
  Show;
end;

procedure TfrmTaskPopup.OnDelete(Sender : TObject; item : TNamedObject);
begin
  Close;
end;

procedure TfrmTaskPopup.WMNCHitTest(var msg: TWMNCHitTest);
const HT_CAPTION = 2;
var pt : TPoint;
begin
  pt.Y := msg.YPos;
  if ScreenToClient(pt).Y <= 9 then
    msg.Result := HT_CAPTION
  else
    inherited;
end;

procedure TfrmTaskPopup.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW or WS_EX_TOPMOST;
  Params.WndParent := GetDesktopWindow;
end;

procedure TfrmTaskPopup.cbSnoozeTimeChange(Sender: TObject);
begin
  if Pos('hour', cbSnoozeTime.Text) > 0 then begin
    seDays.Value := 0;
    seHours.Value := StrToInt(Trim(Copy(cbSnoozeTime.Text, 1, 2)));
    seMinutes.Value := 0;
  end else if Pos('min', cbSnoozeTime.Text) > 0 then begin
    seDays.Value := 0;
    seHours.Value := 0;
    seMinutes.Value := StrToInt(Trim(Copy(cbSnoozeTime.Text, 1, 2)));
  end else if Pos('day', cbSnoozeTime.Text) > 0 then begin
    seDays.Value := StrToInt(Trim(Copy(cbSnoozeTime.Text, 1, 2)));
    seHours.Value := 0;
    seMinutes.Value := 0;
  end;
end;

procedure TfrmTaskPopup.FormClose(Sender: TObject; var Action: TCloseAction);
var r : TReminder;
begin
  if (ModalResult <> mrRetry) and (FReminder.Item <> nil) then begin
    r := TReminder(FReminder.Item);
    if r.SnoozeTime <> 0 then
      r.SnoozeTime := 0;
  end;
  Action := caFree;
end;

procedure TfrmTaskPopup.btnSnoozeClick(Sender: TObject);
begin
  if (FReminder.Item <> nil) then
    TReminder(FReminder.Item).SnoozeTime := Now + seDays.Value + seHours.Value / 24 + seMinutes.Value / (24 * 60);
  ModalResult := mrRetry;  
  Close;
end;

procedure TfrmTaskPopup.btnDismissClick(Sender: TObject);
var task : TTask;
begin
  task := TReminder(FReminder.Item).Task;
  if task <> nil then begin
    task.Complete := cbComplete.Checked;
    if task.Complete and (task.EndTime = 0) then
      task.EndTime := Now;
    if cbActive.Checked then
      frmMain.frmTaskSwitch.AddTask(task)
  end;
  ModalResult := mrOK;
  Close;
end;

procedure TfrmTaskPopup.TimerPopTimer(Sender: TObject);
begin
  case FPopState of
    psShowing : begin
      if AlphaBlendValue = 255 then begin
        FPopState := psWaiting;
        FPopStateTime := Now;
      end else
        AlphaBlendValue := AlphaBlendValue + 5;
    end;
    psWaiting :
      if Now - FPopStateTime > 20 / (60 * 60 * 24) then
        FPopState := psHiding;
    psHiding : begin
      if AlphaBlendValue = 0 then begin
        FPopState := psEnd;
        FormStyle := fsNormal;
        SendToBack;
        AlphaBlend := False;
      end else
        AlphaBlendValue := AlphaBlendValue - 5;
    end;
    psEnd : begin
      AlphaBlend := False;
      TimerPop.Enabled := False;
    end;
  end;
end;

procedure TfrmTaskPopup.TimerFlashTimer(Sender: TObject);
begin
  FlashWindow(Handle, True);
end;

procedure TfrmTaskPopup.FormDestroy(Sender: TObject);
begin
  FReminder.Free;
  FReminder := nil;
end;

procedure TfrmTaskPopup.btnDeleteClick(Sender: TObject);
begin
  Hide;
  if MessageDlg('Delete reminder "' + FReminder.Item.Name + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    FReminder.Delete(FReminder.Item);
  ModalResult := mrOK;
  Close;
end;

procedure TfrmTaskPopup.btnPropertiesClick(Sender: TObject);
begin
  if FReminder.Item <> nil then begin
    if TReminder(FReminder.Item).Task <> nil then begin
      frmTaskProperties.Task := TReminder(FReminder.Item).Task;
      frmTaskProperties.Show;
    end else begin
      frmReminderProperties.Reminder := TReminder(FReminder.Item);
      frmReminderProperties.Show;
    end;
  end;
  ModalResult := mrOK;
  Close;
end;

procedure TfrmTaskPopup.cbCompleteClick(Sender: TObject);
begin
  cbActive.Checked := cbActive.Checked and not cbComplete.Checked;
end;

procedure TfrmTaskPopup.cbActiveClick(Sender: TObject);
begin
  cbComplete.Checked := cbComplete.Checked and not cbActive.Checked;
end;

procedure TfrmTaskPopup.FormClick(Sender: TObject);
begin
  FPopState := psEnd;
end;

procedure TfrmTaskPopup.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then btnDismiss.Click;
  if Key = #27 then btnSnooze.Click;
end;

end.
