unit TaskSwitch;

interface

uses Classes, TimeMap, Tasks;

type
  TTaskSwitchData = class
  private
    FitTimeStart : TIntTime;
    FitTimeEnd : TIntTime;
    FTaskID : Integer;
    function GetTimeAsString : String;
  public
    property itTimeStart : TIntTime read FitTimeStart write FitTimeStart;
    property itTimeEnd : TIntTime read FitTimeEnd write FitTimeEnd;
    property TaskID : Integer read FTaskID write FTaskID;
    property TimeAsString : String read GetTimeAsString;
    function ToString : String;
    constructor FromString(const s : String);
  end;

  TTaskSwitches = class;
  TOnAddSwitchEvent = procedure(sender : TTaskSwitches; switch : TTaskSwitchData) of object;
  TTaskSwitches = class
  private
    FSwitchData : TList;
    FLastSwitchData : TTaskSwitchData;
    FLastSwitchFilePos : LongInt;
    FFileName : String;
    FOnChange : TOnAddSwitchEvent;

    function GetTaskSwitchData(index : Integer) : TTaskSwitchData;
    function GetCount : Integer;

    procedure UpdateToFile(FLastSwitchData : TTaskSwitchData);
    procedure LoadAll;
  public
    property Switches[index : Integer] : TTaskSwitchData read GetTaskSwitchData; default;
    property Count : Integer read GetCount;
    property PersistentFileName : String read FFileName;
    property OnChange : TOnAddSwitchEvent read FOnChange write FOnChange;
    procedure UpdateTaskSwitch(task : TTask);
    constructor Create(const FileName : String);
    destructor Destroy; override;
  end;

implementation

uses SysUtils, Math, StrUtils;

{ TTaskSwitchData }

constructor TTaskSwitchData.FromString(const s : String);
var i1, i2 : Integer;
begin
  i1 := Pos(#9, s);
  TaskID := StrToInt(Copy(s, 1, i1 - 1));
  i2 := PosEx(#9, s, i1 + 1);
  itTimeStart := ITFromDT(StrToDateTime(Copy(s, i1 + 1, i2 - i1 - 1)));
  itTimeEnd := itTimeStart + StrToInt(Copy(s, i2 + 1, Length(s)));
end;

function TTaskSwitchData.ToString : String;
begin
  Result := IntToStr(TaskID) + #9 + DateTimeToStr(DTFromIT(itTimeStart)) + #9 + IntToStr(itTimeEnd - itTimeStart);
end;

function TTaskSwitchData.GetTimeAsString : String;
var
  t : TIntTime;
  h, m : Word;
  s : String;
begin
  t := FitTimeEnd - FitTimeStart;
  DivMod(t, 60, h, m);
  Result := IntToStr(h);
  if Length(Result) < 2 then
    Result := '0' + Result;
  s := IntToStr(m);
  if Length(s) < 2 then
    s := '0' + s;
  Result := Result + ':' + s;
end;

{ TTaskSwitches }

constructor TTaskSwitches.Create(const FileName : String);
begin
  FSwitchData := TList.Create;
  FFileName := FileName;
  LoadAll;
end;

destructor TTaskSwitches.Destroy;
var i : Integer;
begin
  for i := 0 to FSwitchData.Count - 1 do
    TObject(FSwitchData[i]).Free;
  FSwitchData.Free;
  inherited;
end;

procedure TTaskSwitches.UpdateTaskSwitch(task : TTask);
var sw : TTaskSwitchData;
begin
  if FLastSwitchData <> nil then begin
    FLastSwitchData.itTimeEnd := ITFromDT(Now);
    if FFileName <> '' then
      UpdateToFile(FLastSwitchData);
  end;
  if task = nil then
    FLastSwitchData := nil
  else
    if (FLastSwitchData = nil) or (task.TaskID <> FLastSwitchData.TaskID) then begin
      sw := TTaskSwitchData.Create;
      sw.itTimeStart := ITFromDT(Now);
      sw.itTimeEnd := sw.itTimeStart;
      sw.TaskID := task.TaskID;
      FSwitchData.Add(sw);
      FLastSwitchData := sw;
      FLastSwitchFilePos := -1;
      if Assigned(FOnChange) then
        FOnChange(self, sw);
    end;
end;

procedure TTaskSwitches.UpdateToFile;
var
  f : File;
  s : String;
begin
  AssignFile(f, FFileName);
  if FileExists(FFileName) then
    Reset(f, 1)
  else begin
    Rewrite(f, 1);
    FLastSwitchFilePos := 0;
  end;
  try
    if FLastSwitchFilePos = -1 then
      FLastSwitchFilePos := FileSize(f);
    Seek(f, FLastSwitchFilePos);
    s := FLastSwitchData.ToString + #13#10;
    BlockWrite(f, s[1], Length(s));
    Truncate(f);
  finally
    CloseFile(f);
  end;
end;

procedure TTaskSwitches.LoadAll;
var
  f : TextFile;
  s : String;
begin
  if not FileExists(FFileName) then
    Exit;
  AssignFile(f, FFileName);
  Reset(f);
  try
    while not EOF(f) do begin
      ReadLn(f, s);
      FSwitchData.Add(TTaskSwitchData.FromString(s));
    end;
  finally
    CloseFile(f);
  end;
end;

function TTaskSwitches.GetTaskSwitchData(index : Integer) : TTaskSwitchData;
begin
  Result := TTaskSwitchData(FSwitchData[index]);
end;

function TTaskSwitches.GetCount : Integer;
begin
  Result := FSwitchData.Count;
end;

end.
