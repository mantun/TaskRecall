program Reminder;

uses
  FastMM4,
  Forms,
  Tasks in 'Tasks.pas',
  Main in 'Main.pas' {frmMain},
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
  TaskSwitchFrame in 'TaskSwitchFrame.pas' {frmTaskSwitch: TFrame},
  Lists in 'SLI\Lists.pas',
  ResultDecl in 'SLI\ResultDecl.pas',
  Parse in 'SLI\Parse.pas',
  Eval in 'SLI\Eval.pas',
  BuiltinDefs in 'SLI\BuiltinDefs.pas',
  TimeLibDefs in 'SLI\TimeLibDefs.pas';

{$R *.res}

begin
  Application.Initialize;
  TaskStorage.PersistentStorageFile := TasksFileName;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmTaskProperties, frmTaskProperties);
  Application.CreateForm(TfrmReminderProperties, frmReminderProperties);
  Application.CreateForm(TfrmLog, frmLog);
  Application.Run;
end.
