unit TimelineData;

interface

Uses SysUtils, Classes, Tasks, TaskSwitch, TimeMap;

type
  TTrackKind = (tkTasks, tkSwitches, tkLog);
  TVisibleTracks = Set of TTrackKind;
  TTimelineDataProvider = class
  private
    FVisibleTracks : TVisibleTracks;
    FSelection : TObjectsSelection;
    FTimeline : TTimeline;
    FTaskTrack : TTimeTrack;
    FSwitchTrack : TTimeTrack;
    FLogTrack : TTimeTrack;
    FOnChange : TNotifyEvent;
    procedure LoadAllData;
    procedure ReleaseTrack(var track : TTimeTrack);
    procedure OnDelete(Sender : TObject; item : TNamedObject);
    procedure OnChangeItem(Sender : TObject; item : TNamedObject);
    procedure OnAdd(Sender : TObject; item : TNamedObject);
    procedure AddTaskSwitches(task : TTask);
    procedure AddTask(task : TTask);
    procedure OnAddSwitch(sender : TTaskSwitches; switch : TTaskSwitchData);
  public
    property VisibleTracks : TVisibleTracks read FVisibleTracks write FVisibleTracks;
    property OnChange : TNotifyEvent read FOnChange write FOnChange;
    constructor Create(ASelection : TObjectsSelection; Timeline : TTimeline);
    destructor Destroy; override;
  end;

implementation

uses Graphics, TaskSwitcher, TimeGraph;

type
  TTaskSwitch = class(TTimeSpanObject)
  private
    FData : TTaskSwitchData;
    FTask : TTask;
  protected
    function GetText : String; override;
    function GetFullText : String; override;
    function GetLeft : ITimeController; override;
    function GetRight : ITimeController; override;
    function GetColor : TColor; override;
  public
    property Data : TTaskSwitchData read FData;
    constructor Create(AData : TTaskSwitchData; ATask : TTask);
  end;

  TTaskTimeObject = class(TTimeSpanObject)
  private
    FTask : TTask;
  protected
    function GetLeft : ITimeController; override;
    function GetRight : ITimeController; override;
    function GetText : String; override;
    function GetFullText : String; override;
    function GetColor : TColor; override;
  public
    constructor Create(ATask : TTask);
  end;

type
  TTempReadOnlyTimeController = class(TInterfacedObject, ITimeController)
    fit : TIntTime;
    function GetTime : TIntTime;
    procedure SetTime(it : TIntTime); virtual; abstract; // Abstract Error here if invoked!
  end;
function TTempReadOnlyTimeController.GetTime : TIntTime;
begin
  Result := fit;
end;

function MersenneTwist(i : LongWord) : Integer;
asm
  mov edx, eax
  mov ecx, eax
  shr ecx, 11
  xor eax, ecx

  mov ecx, edx
  shl ecx, 7
  and ecx, $9d2c5680
  xor eax, ecx

  mov ecx, edx
  shl ecx, 15
  and ecx, $efc60000
  xor eax, ecx

  mov ecx, edx
  shr ecx, 18
  xor eax, ecx
end;

function TaskIDToColor(id : Integer) : TColor;
begin
  Result := ColorPalette[MersenneTwist(MersenneTwist(MersenneTwist(id))) mod Length(ColorPalette)];
end;

{ TTaskSwitch }

constructor TTaskSwitch.Create(AData : TTaskSwitchData; ATask : TTask);
begin
  FData := AData;
  FTask := ATask;
end;

function TTaskSwitch.GetLeft : ITimeController;
var c : TTempReadOnlyTimeController;
begin
  c := TTempReadOnlyTimeController.Create();
  c.fit := FData.itTimeStart;
  Result := c;
end;

function TTaskSwitch.GetRight : ITimeController;
var c : TTempReadOnlyTimeController;
begin
  c := TTempReadOnlyTimeController.Create;
  c.fit := FData.itTimeEnd;
  Result := c;
end;

function TTaskSwitch.GetText : String;
begin
  Result := '';
end;

function TTaskSwitch.GetFullText : String;
begin
  Result := IntToStr(FTask.TaskID) + ': ' + FTask.Name + #13#10 + FData.TimeAsString;
end;

function TTaskSwitch.GetColor : TColor;
begin
  Result := TaskIDToColor(FData.TaskID);
end;

{ TTaskTimeObject }

constructor TTaskTimeObject.Create(ATask : TTask);
begin
  FTask := ATask;
end;

function TTaskTimeObject.GetLeft : ITimeController;
var c : TTempReadOnlyTimeController;
begin
  c := TTempReadOnlyTimeController.Create;
  c.fit := ITFromDT(FTask.StartTime);
  Result := c;
end;

function TTaskTimeObject.GetRight : ITimeController;
var c : TTempReadOnlyTimeController;
begin
  c := TTempReadOnlyTimeController.Create;
  c.fit := ITFromDT(FTask.EndTime);
  Result := c;
end;

function TTaskTimeObject.GetText : String;
begin
  Result := IntToStr(FTask.TaskID) + ': ' + FTask.Name;
end;

function TTaskTimeObject.GetFullText : String;
begin
  Result := GetText;
end;

function TTaskTimeObject.GetColor : TColor;
begin
  Result := TaskIDToColor(FTask.TaskID);
end;

{ TTimelineDataProvider }

constructor TTimelineDataProvider.Create(ASelection : TObjectsSelection; Timeline : TTimeline);
begin
  FSelection := ASelection;
  FSelection.OnAdd := OnAdd;
  FSelection.OnDelete := OnDelete;
  FSelection.OnItemChange := OnChangeItem;
  FTimeline := Timeline;
  frmTaskSwitcher.TaskSwitches.OnChange := OnAddSwitch;
  LoadAllData;
end;

destructor TTimelineDataProvider.Destroy;
begin
  FSelection.OnAdd := nil;
  FSelection.OnDelete := nil;
  FSelection.OnItemChange := nil;
  frmTaskSwitcher.TaskSwitches.OnChange := nil;
  ReleaseTrack(FTaskTrack);
  ReleaseTrack(FSwitchTrack);
  ReleaseTrack(FLogTrack);
end;

procedure TTimelineDataProvider.ReleaseTrack(var track : TTimeTrack);
var i : Integer;
begin
  if track = nil then Exit;
  for i := 0 to track.Count - 1 do
    track[i].Free;
  track.Free;
  track := nil;
end;

procedure TTimelineDataProvider.LoadAllData;
var
  i : Integer;
begin
  FTaskTrack := TTimeTrack.Create;
  FTimeline.AddTimeTrack(FTaskTrack);
  for i := 0 to FSelection.Count - 1 do
    AddTask(FSelection[i] as TTask);

  FSwitchTrack := TTimeTrack.Create;
  FTimeline.AddTimeTrack(FSwitchTrack);
  for i := 0 to FSelection.Count - 1 do
    AddTaskSwitches(FSelection[i] as TTask);
end;

procedure TTimelineDataProvider.AddTaskSwitches(task : TTask);
var i : Integer;
begin
  for i := 0 to frmTaskSwitcher.TaskSwitches.Count - 1 do
    if frmTaskSwitcher.TaskSwitches[i].TaskID = task.TaskID then
      FSwitchTrack.AddTimeObject(TTaskSwitch.Create(frmTaskSwitcher.TaskSwitches[i], task));
end;

procedure TTimelineDataProvider.AddTask(task : TTask);
begin
  if (task.StartTime <> 0) then
    FTaskTrack.AddTimeObject(TTaskTimeObject.Create(task));
end;

procedure TTimelineDataProvider.OnAddSwitch(sender : TTaskSwitches; switch : TTaskSwitchData);
var
  i : Integer;
  task : TTask;
begin
  for i := 0 to FSelection.Count - 1 do begin
    task := FSelection[i] as TTask;
    if task.TaskID = switch.TaskID then begin
      FSwitchTrack.AddTimeObject(TTaskSwitch.Create(switch, task));
      if Assigned(FOnChange) then
        FOnChange(Self);
      Exit;
    end;
  end;
end;

procedure TTimelineDataProvider.OnDelete(Sender : TObject; item : TNamedObject);
var
  i : Integer;
  task : TTask;
begin
  task := item as TTask;
  if FTaskTrack <> nil then
    for i := FTaskTrack.Count - 1 downto 0 do
      if TTaskTimeObject(FTaskTrack[i]).FTask = task then
        FTaskTrack.DeleteTimeObject(FTaskTrack[i]);
  if FSwitchTrack <> nil then
    for i := FSwitchTrack.Count - 1 downto 0 do
      if TTaskSwitch(FSwitchTrack[i]).FTask = task then
        FSwitchTrack.DeleteTimeObject(FSwitchTrack[i]);
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TTimelineDataProvider.OnChangeItem(Sender : TObject; item : TNamedObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TTimelineDataProvider.OnAdd(Sender : TObject; item : TNamedObject);
begin
  if FTaskTrack <> nil then
    AddTask(item as TTask);
  if FSwitchTrack <> nil then
    AddTaskSwitches(item as TTask);
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

end.
