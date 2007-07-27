program Reminder;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  Parse in 'Parse.pas',
  Func in 'Func.pas',
  Tasks in 'Tasks.pas',
  PopUp in 'PopUp.pas' {frmTaskPopup},
  TaskProp in 'TaskProp.pas' {frmTaskProperties},
  ReminderProp in 'ReminderProp.pas' {frmReminderProperties},
  Logging in 'Logging.pas' {frmLog},
  StrMan in 'StrMan.pas',
  TimeMap in 'TimeMap.pas',
  TimelineForm in 'TimelineForm.pas' {frmTimeline},
  TaskSwitch in 'TaskSwitch.pas',
  TimelineData in 'TimelineData.pas',
  TimeGraph in 'TimeGraph.pas',
  TaskSwitchFrame in 'TaskSwitchFrame.pas' {frmTaskSwitch: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmTaskProperties, frmTaskProperties);
  Application.CreateForm(TfrmReminderProperties, frmReminderProperties);
  Application.CreateForm(TfrmLog, frmLog);
  Application.Run;
end.
