unit ReminderProp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Tasks;

type
  TfrmReminderProperties = class(TForm)
    eName: TLabeledEdit;
    btnApply: TSpeedButton;
    btnDelete: TSpeedButton;
    mTimeStamp: TMemo;
    Label1: TLabel;
    procedure ReminderChange(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FReminder : TSingletonSelection;
    procedure SetReminder(const value : TReminder);
    function GetReminder : TReminder;

    procedure OnDelete(Sender : TObject; item : TNamedObject);
    procedure OnAddOrChange(Sender : TObject; item : TNamedObject);
    procedure EnableControls(Enabled : Boolean);
  public
    property Reminder : TReminder read GetReminder write SetReminder;
  end;

var
  frmReminderProperties: TfrmReminderProperties;

implementation

{$R *.dfm}

procedure TfrmReminderProperties.EnableControls(Enabled : Boolean);
begin
  eName.Enabled := Enabled and (FReminder.Item <> nil) and (TReminder(FReminder.Item).Task = nil);
  mTimeStamp.Enabled := Enabled;
end;

procedure TfrmReminderProperties.OnDelete(Sender : TObject; item : TNamedObject);
begin
  eName.Text := '';
  mTimeStamp.Text := '';
  EnableControls(False);
  btnApply.Enabled := False;
  btnDelete.Enabled := False;
end;

procedure TfrmReminderProperties.OnAddOrChange(Sender : TObject; item : TNamedObject);
var Reminder : TReminder;
begin
  Reminder := TReminder(item);
  if not eName.Modified then
    eName.Text := Reminder.Name;
  if not mTimeStamp.Modified then
    mTimeStamp.Text := Reminder.TimeStamp;
  EnableControls(True);
  btnApply.Enabled := eName.Modified or mTimeStamp.Modified;
  btnDelete.Enabled := True;
end;

procedure TfrmReminderProperties.SetReminder(const value : TReminder);
begin
  if FReminder.Item <> value then
    FReminder.Item := value;
end;

function TfrmReminderProperties.GetReminder : TReminder;
begin
  Result := TReminder(FReminder.Item);
end;

procedure TfrmReminderProperties.ReminderChange(Sender: TObject);
begin
  if FReminder.Item <> nil then
    btnApply.Enabled := True;
end;

procedure TfrmReminderProperties.btnApplyClick(Sender: TObject);
var
  Reminder : TReminder;
begin
  if FReminder.Item = nil then Exit;
  Reminder := TReminder(FReminder.Item);
  Reminder.ValidateTimeStamp(mTimeStamp.Text);
  if eName.Modified then begin
    Reminder.Name := eName.Text;
    eName.Modified := False;
  end;
  if mTimeStamp.Modified then begin
    Reminder.TimeStamp := mTimeStamp.Text;
    mTimeStamp.Modified := False;
  end;
  btnApply.Enabled := False;
  ModalResult := mrOK;
end;

procedure TfrmReminderProperties.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
  if Key = #10 then Key := #0;
end;

procedure TfrmReminderProperties.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN)
      and ((Shift = [ssCtrl]) or (ActiveControl <> mTimeStamp))
      and btnApply.Enabled then begin
    btnApply.Click;
    Key := 0;
  end;
end;

procedure TfrmReminderProperties.FormCreate(Sender: TObject);
begin
  FReminder := TSingletonSelection.Create(TaskStorage);
  FReminder.OnAdd := OnAddOrChange;
  FReminder.OnItemChange := OnAddOrChange;
  FReminder.OnDelete := OnDelete;
end;

procedure TfrmReminderProperties.btnDeleteClick(Sender: TObject);
begin
  if FReminder.Item = nil then Exit;
  if fsModal in FormState then
    ModalResult := mrCancel
  else
    if MessageDlg('Delete reminder "' + FReminder.Item.Name + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      FReminder.Delete(FReminder.Item);
end;

procedure TfrmReminderProperties.FormDestroy(Sender: TObject);
begin
  FReminder.Free;
  FReminder := nil;
end;

end.
