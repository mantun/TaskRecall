unit Logging;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Tasks, ActnList;

type
  TfrmLog = class(TForm)
    Memo: TMemo;
    FindDialog: TFindDialog;
    ActionList: TActionList;
    acFind: TAction;
    acFindNext: TAction;
    acFindPrev: TAction;
    acSave: TAction;
    acSelectAll: TAction;
    acUndo: TAction;
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acFindExecute(Sender: TObject);
    procedure FindDialogFind(Sender: TObject);
    procedure acFindNextExecute(Sender: TObject);
    procedure acFindPrevExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure MemoChange(Sender: TObject);
    procedure acSelectAllExecute(Sender: TObject);
    procedure acUndoExecute(Sender: TObject);
  private
    FTask : TSingletonSelection;
    FFileName : String;

    procedure OnItemAddOrChange(Sender : TObject; obj : TNamedObject);
    procedure OnItemDelete(Sender : TObject; obj : TNamedObject);
  protected
    procedure CreateParams(var Params: TCreateParams); Override;
  public
    procedure NewEntry;
    constructor Create(AOwner : TComponent; const task : TTask); reintroduce;

    class procedure LogEntry(task : TTask);
  end;

var
  frmLog: TfrmLog;

implementation

uses StrMan;

{$R *.dfm}

var
  LastW, LastH : Integer;
  InstanceList : TList;

function LogFileName(task : TTask) : String;
begin
  Result := 'data\task' + IntToStr(task.TaskID) + '.log';
end;

class procedure TfrmLog.LogEntry(task : TTask);
var
  i : Integer;
  found : Boolean;
  frm : TfrmLog;
begin
  found := False;
  for i := 0 to InstanceList.Count - 1 do begin
    frm := TfrmLog(InstanceList[i]);
    if frm.FTask.Item = task then begin
      frm.NewEntry;
      found := True;
    end;
  end;
  if not found then begin
    frm := TfrmLog.Create(Application, task);
    InstanceList.Add(frm);
    frm.NewEntry;
  end;
end;

constructor TfrmLog.Create(AOwner : TComponent; const task : TTask);
begin
  inherited Create(AOwner);
  FTask := TSingletonSelection.Create(TaskStorage);
  FTask.OnAdd := OnItemAddOrChange;
  FTask.OnItemChange := OnItemAddOrChange;
  FTask.OnDelete := OnItemDelete;
  FTask.Item := task;
  if (LastW <> 0) and (LastH <> 0) then
    SetBounds(Left, Top, LastW, LastH);
  FFileName := LogFileName(task);
  if FileExists(FFileName) then
    Memo.Lines.LoadFromFile(FFileName);
  Memo.Modified := False;
end;

procedure TfrmLog.NewEntry;
var m : boolean;
begin
  m := Memo.Modified;
  Memo.Lines.Add('');
  Memo.Lines.Add('.-=0=-.');
  Memo.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn', Now));
  Memo.Lines.Add('');
  Memo.Modified := m;
  if WindowState = wsMinimized then
    WindowState := wsNormal;
  Memo.SelStart := Memo.GetTextLen;
  Show;
  PostMessage(Memo.Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TfrmLog.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

procedure TfrmLog.OnItemAddOrChange(Sender : TObject; obj : TNamedObject);
var s : String;
begin
  if Memo.Modified then
    s := '* '
  else
    s := '';
  Caption := s + 'Log ' + IntToStr(TTask(obj).TaskID) + ' - ' + obj.Name;
end;

procedure TfrmLog.OnItemDelete(Sender : TObject; obj : TNamedObject);
begin
  Close;
end;

procedure TfrmLog.FormDestroy(Sender: TObject);
begin
  FTask.Free;
  FTask := nil;
end;

procedure TfrmLog.FormResize(Sender: TObject);
begin
  LastW := Width;
  LastH := Height;
end;

procedure TfrmLog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Memo.Modified then
    Memo.Lines.SaveToFile(FFileName);
  InstanceList.Remove(self);
  Action := caFree;
end;

procedure TfrmLog.acFindExecute(Sender: TObject);
begin
  FindDialog.Position := Point(Left + Width, Top);
  FindDialog.Execute;
end;

procedure TfrmLog.FindDialogFind(Sender: TObject);
begin
  FindDialog.CloseDialog;
  Memo.SelLength := 0;
  acFindNext.Execute;
end;

procedure TfrmLog.acFindNextExecute(Sender: TObject);
var k : Integer;
begin
  if FindDialog.FindText = '' then begin
    acFind.Execute;
    Exit;
  end;
  k := sm.Pos(FindDialog.FindText, Memo.Lines.Text, not (frMatchCase in FindDialog.Options), Memo.SelStart + Memo.SelLength);
  if k > 0 then begin
    Memo.SelStart := k - 1;
    Memo.SelLength := Length(FindDialog.FindText);
  end;
end;

procedure TfrmLog.acFindPrevExecute(Sender: TObject);
var k : Integer;
begin
  if FindDialog.FindText = '' then begin
    acFind.Execute;
    Exit;
  end;
  if frMatchCase in FindDialog.Options then
    k := sm.PosRev(FindDialog.FindText, Memo.Lines.Text, Memo.SelStart)
  else
    k := sm.PosRevIC(FindDialog.FindText, Memo.Lines.Text, Memo.SelStart);
  if k > 0 then begin
    Memo.SelStart := k - 1;
    Memo.SelLength := Length(FindDialog.FindText);
  end;
end;

procedure TfrmLog.acSaveExecute(Sender: TObject);
begin
  Memo.Lines.SaveToFile(FFileName);
  Memo.Modified := False;
  if Pos('* ', Caption) = 1 then
    Caption := Copy(Caption, 3, Length(Caption) - 2);
end;

procedure TfrmLog.MemoChange(Sender: TObject);
begin
  if Pos('* ', Caption) <> 1 then
    Caption := '* ' + Caption;
end;

procedure TfrmLog.acSelectAllExecute(Sender: TObject);
begin
  Memo.SelectAll;
end;

procedure TfrmLog.acUndoExecute(Sender: TObject);
begin
  Memo.Undo;
end;

initialization
  InstanceList := TList.Create;

finalization
  InstanceList.Free;
  InstanceList := nil;

end.
