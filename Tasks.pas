unit Tasks;

interface

Uses Classes, Graphics;

type
  TNamedObjectsStorage = class;
  TNamedObject = class
  private
    FOwner : TNamedObjectsStorage;
    FName : String;

    FUpdating : Boolean;
    FChanged : Boolean;

    procedure SetName(const value : String); virtual;
  protected
    procedure Changed;
  public
    property Name : String read FName write SetName;
    function ToString : String; virtual; abstract;
    constructor Create(const AName : String);

    procedure BeginUpdate;
    procedure EndUpdate;
  end;

  TCategory = class;
  TReminder = class;
  TPointerResolver = class;
  TTask = class(TNamedObject)
  private
    FTaskID : Integer;
    FDescription : String;
    FPriority : Integer;
    FColor : TColor;
    FComplete : Boolean;
    FCategories : Array of TCategory;
    FReminder : TReminder;
    FActiveNo : Integer;
    FTimeSpent : Double;
    FStartTime : TDateTime;
    FEndTime : TDateTime;

    procedure SetName(const value : String); override;
    procedure SetDescription(value : String);
    procedure SetPriority(value : Integer);
    procedure SetColor(value : TColor);
    procedure SetComplete(value : Boolean);
    procedure SetReminder(value : TReminder);
    procedure SetActiveNo(value : Integer);
    procedure SetTimeSpent(value : Double);
    procedure SetTimeSpentStr(value : String);
    function GetTimeSpentStr : String;
    procedure SetStartTime(value : TDateTime);
    procedure SetEndTime(value : TDateTime);
  public
    property TaskID : Integer read FTaskID;
    property Description : String read FDescription write SetDescription;
    property Priority : Integer read FPriority write SetPriority;
    property Color : TColor read FColor write SetColor;
    property Complete : Boolean read FComplete write SetComplete;
    property Reminder : TReminder read FReminder write SetReminder;
    property ActiveNo : Integer read FActiveNo write SetActiveNo;
    property StartTime : TDateTime read FStartTime write SetStartTime;
    property EndTime : TDateTime read FEndTime write SetEndTime;
    property TimeSpent : Double read FTimeSpent write SetTimeSpent;
    property TimeSpentAsString : String read GetTimeSpentStr write SetTimeSpentStr;

    constructor Create; overload;
    constructor FromString(const s : String; const Resolver : TPointerResolver);
    destructor Destroy; override;
    function ToString : String; override;

    function HasCategory(const Category : TCategory) : Boolean; overload;
    function HasCategory : Boolean; overload;
    function AddCategory(const Category : TCategory) : Boolean;
    function RemoveCategory(const Category : TCategory) : Boolean;
    procedure ClearCategories;
  end;

  TReminder = class(TNamedObject)
  private
    FTimeStamp : String;
    FSnoozeTime : TDateTime;
    FTask : TTask;

    FLastCheckTime : TDateTime;

    procedure SetTimeStamp(const value : String);
    procedure SetTask(const value : TTask);
    procedure SetSnoozeTime(const value : TDateTime);
  public
    property TimeStamp : String read FTimeStamp write SetTimeStamp;
    property SnoozeTime : TDateTime read FSnoozeTime write SetSnoozeTime;
    property Task : TTask read FTask write SetTask;

    procedure ValidateTimeStamp(const value : String);

    constructor Create; overload;
    constructor Create(const AName : String); overload;
    constructor FromString(const s : String; const Resolver : TPointerResolver);
    destructor Destroy; override;
    function ToString : String; override;

    function GetFireTime : TDateTime;
    function isFireTime : Boolean;
  end;

  TCategory = class(TNamedObject)
  private
    FParent : TCategory;
    FColor : TColor;
    FIndex : Integer;

    procedure SetColor(value : TColor);
    procedure SetParent(value : TCategory);
    procedure SetIndex(value : Integer);
  public
    property Parent : TCategory read FParent write SetParent;
    property Color : TColor read FColor write SetColor;
    property Index : Integer read FIndex write SetIndex;

    function HasParent(Category : TCategory) : Boolean;
    constructor Create(const AName : String; AParent : TCategory);
    constructor FromString(const s : String; const Resolver : TPointerResolver);
    function ToString : String; override;
  end;

  TChangedNotify = procedure(Sender : TObject; item : TNamedObject) of object;
  TNamedObjectsStorage = class
  private
    FSelections : TList;
    FItems : TList;

    FNextID : Integer;
    FFileName : String;

    function GetItem(index : Integer) : TNamedObject;
    function GetCount : Integer;
    procedure SetFileName(const value : String);

    procedure NotifyChange(item : TNamedObject);
  public
    property Items[index : Integer] : TNamedObject read GetItem; default;
    property Count : Integer read GetCount;

    property PersistentStorageFile : String read FFileName write SetFileName;
    function GetObject(const name : String) : TNamedObject;
    procedure Delete(item : TNamedObject);
    procedure Add(item : TNamedObject);

    function NextID : Integer;
    procedure LoadFromFile(const FileName : String);
    procedure SaveToFile(const FileName : String);

    constructor Create;
    destructor Destroy; override;
  end;

  TObjectsSelection = class
  protected
    FSelection : TList;
    FStorage : TNamedObjectsStorage;
    FCompare : TListSortCompare;

    FOnAdd : TChangedNotify;
    FOnDelete : TChangedNotify;
    FOnItemChange : TChangedNotify;
    procedure NotifyAdd(item : TNamedObject); virtual;
    procedure NotifyDelete(item : TNamedObject); virtual;
    procedure NotifyItemChange(item : TNamedObject); virtual;

    function GetItem(index : Integer) : TNamedObject; virtual;
    function GetCount : Integer; virtual;
  public
    property OnAdd : TChangedNotify read FOnAdd write FOnAdd;
    property OnDelete : TChangedNotify read FOnDelete write FOnDelete;
    property OnItemChange : TChangedNotify read FOnItemChange write FOnItemChange;
    property PermanentSortComparator : TListSortCompare read FCompare write FCompare;

    property Items[index : Integer] : TNamedObject read GetItem; default;
    property Count : Integer read GetCount;

    function IndexOf(const obj : TNamedObject) : Integer; virtual;
    procedure Select(const obj : TNamedObject); virtual;
    procedure ReSelectAll; virtual;
    procedure Release(const obj : TNamedObject); virtual;
    procedure Add(const obj : TNamedObject); virtual;
    procedure Delete(const obj : TNamedObject); virtual;
    procedure Sort(compare : TListSortCompare); virtual;
    procedure ClearSelection; virtual;
    function Belongs(const obj : TNamedObject) : Boolean; virtual; abstract;

    constructor Create(AStorage : TNamedObjectsStorage);
    destructor Destroy; override;
  end;

  TManualSelection = class(TObjectsSelection)
  public
    procedure Add(const obj : TNamedObject); override;
    function Belongs(const obj : TNamedObject) : Boolean; override;
  end;

  TCompleteSelection = class(TObjectsSelection)
  public
    function Belongs(const obj : TNamedObject) : Boolean; override;
  end;

  TSingletonSelection = class(TManualSelection)
  private
    function GetItem : TNamedObject; reintroduce;
    procedure SetItem(const value : TNamedObject);
  public
    property Item : TNamedObject read GetItem write SetItem;
    procedure Add(const obj : TNamedObject); override;
    procedure Select(const obj : TNamedObject); override;
  end;

  PTObject = ^TObject;
  TPointerResolver = class
  private
    FObjects : TStringList;
    FPointers : TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddObject(const s : String; const o : TObject);
    procedure AddPointer(const s : String; const p : PTObject);
    procedure Reconcile;
    class function PointerToStr(o : TObject) : String;
  end;

const
  TasksFileName = 'data\tasks.txt';
var
  TaskStorage : TNamedObjectsStorage;

implementation

Uses SysUtils, Parse;

const
  Quote = '"';
  
function Encode(const s : String) : String;
begin
  Result := s;
  Result := StringReplace(Result, Quote, Quote + Quote, [rfReplaceAll]);
  Result := StringReplace(Result, '\', '\\', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '\r', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '\n', [rfReplaceAll]);
  Result := Quote + Result + Quote;
end;

function Decode(const s : String) : String;
begin
  Result := s;
  if (Length(Result) > 0) and (Result[1] = Quote) then
    Result := Copy(Result, 2, Length(Result) - 1);
  if (Length(Result) > 0) and (Result[Length(Result)] = Quote) then
    Result := Copy(Result, 1, Length(Result) - 1);
  Result := StringReplace(Result, '\r', #13, [rfReplaceAll]);
  Result := StringReplace(Result, '\n', #10, [rfReplaceAll]);
  Result := StringReplace(Result, '\\', '\', [rfReplaceAll]);
  Result := StringReplace(Result, Quote + Quote, Quote, [rfReplaceAll]);
end;

{ TNamedObject }

constructor TNamedObject.Create(const AName : String);
begin
  Name := AName;
end;

procedure TNamedObject.SetName(const value : String);
begin
  if FName <> value then begin
    FName := value;
    Changed;
  end;
end;

procedure TNamedObject.Changed;
begin
  if FUpdating then
    FChanged := True
  else begin
    if FOwner <> nil then
      FOwner.NotifyChange(Self);
    FChanged := False;
  end;
end;

procedure TNamedObject.BeginUpdate;
begin
  FUpdating := True;
end;

procedure TNamedObject.EndUpdate;
begin
  FUpdating := False;
  if FChanged then
    Changed;
end;

{ TTask }

constructor TTask.Create;
begin
  Create('');
end;

destructor TTask.Destroy;
begin
  if FReminder <> nil then
    FReminder.FTask := nil;
  inherited;
end;

procedure TTask.SetName(const value : String);
begin
  inherited;
  if FReminder <> nil then
    FReminder.Name := FName;
end;

procedure TTask.SetDescription(value : String);
begin
  if FDescription <> value then begin
    FDescription := value;
    Changed;
  end;
end;

procedure TTask.SetPriority(value : Integer);
begin
  if FPriority <> value then begin
    FPriority := value;
    Changed;
  end;
end;

procedure TTask.SetColor(value : TColor);
begin
  if FColor <> value then begin
    FColor := value;
    Changed;
  end;
end;

procedure TTask.SetComplete(value : Boolean);
begin
  if FComplete <> value then begin
    FComplete := value;
    if FComplete then
      FActiveNo := 0;
    Changed;
  end;
end;

procedure TTask.SetReminder(value : TReminder);
begin
  if FReminder <> nil then
    FReminder.FTask := nil;
  FReminder := value;
  FReminder.FTask := self;
end;

procedure TTask.SetActiveNo(value : Integer);
begin
  if (FActiveNo <> value) and not FComplete then begin
    FActiveNo := value;
    Changed;
  end;
end;

procedure TTask.SetTimeSpent(value : Double);
begin
  if FTimeSpent <> value then begin
    FTimeSpent := value;
    Changed;
  end;
end;

procedure TTask.SetTimeSpentStr(value : String);
var h, m, k : Integer;
begin
  k := Pos(':', value);
  if k = 0 then
    raise EConvertError('''' + value + ''' is not a valid time');
  h := StrToInt(Copy(value, 1, k - 1));
  m := StrToInt(Copy(value, k + 1, Length(value) - k));
  TimeSpent := h * 60 + m;
end;

function TTask.GetTimeSpentStr : String;
var
  hours : Integer;
  s : String;
begin
  hours := Trunc(TimeSpent / 60);
  Result := IntToStr(hours);
  if Length(Result) < 2 then Result := '0' + Result;
  s := IntToStr(Round(TimeSpent - hours * 60));
  if Length(s) < 2 then s := '0' + s;
  Result := Result + ':' + s;
end;

procedure TTask.SetStartTime(value : TDateTime);
begin
  if FStartTime <> value then begin
    FStartTime := value;
    Changed;
  end;
end;

procedure TTask.SetEndTime(value : TDateTime);
begin
  if FEndTime <> value then begin
    FEndTime := value;
    Changed;
  end;
end;

constructor TTask.FromString(const s : String; const Resolver : TPointerResolver);
var
  sl : TStringList;
  ss : String;
  i : Integer;
begin
  sl := TStringList.Create;
  try
    sl.Text := s;
    FTaskID := StrToInt(sl[0]);
    FName := Decode(sl[1]);
    FDescription := Decode(sl[2]);
    FPriority := StrToInt(sl[3]);
    FComplete := StrToBool(sl[4]);
    Resolver.AddPointer(sl[5], @FReminder);
    FActiveNo := StrToInt(sl[6]);
    FTimeSpent := StrToFloat(sl[7]);
    ss := Decode(sl[8]);
    if ss <> '' then
      FStartTime := StrToDateTime(ss)
    else
      FStartTime := 0;
    ss := Decode(sl[9]);
    if ss <> '' then
      FEndTime := StrToDateTime(ss)
    else
      FEndTime := 0;
    SetLength(FCategories, StrToInt(sl[10]));
    for i := 0 to High(FCategories) do
      Resolver.AddPointer(sl[11 + i], @FCategories[i]);
  finally
    sl.Free;
  end;
end;

function TTask.ToString : String;
var
  sl : TStringList;
  ss : String;
  i : Integer;
begin
  sl := TStringList.Create;
  try
    sl.add(IntToStr(FTaskID));
    sl.add(Encode(FName));
    sl.add(Encode(FDescription));
    sl.add(IntToStr(FPriority));
    sl.add(BoolToStr(FComplete));
    sl.add(TPointerResolver.PointerToStr(FReminder));
    sl.add(IntToStr(FActiveNo));
    sl.add(FloatToStr(FTimeSpent));
    if FStartTime <> 0 then
      ss := DateTimeToStr(FStartTime)
    else
      ss := '';
    sl.add(Encode(ss));
    if FEndTime <> 0 then
      ss := DateTimeToStr(FEndTime)
    else
      ss := '';
    sl.add(Encode(ss));
    sl.add(IntToStr(Length(FCategories)));
    for i := 0 to High(FCategories) do
      sl.add(TPointerResolver.PointerToStr(FCategories[i]));
    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

function TTask.HasCategory(const Category : TCategory) : Boolean;
var i : Integer;
begin
  Result := False;
  for i := 0 To High(FCategories) do begin
    Result := FCategories[i].HasParent(Category);
    if Result then Exit;
  end;
end;

function TTask.HasCategory : Boolean;
begin
  Result := Length(FCategories) > 0;
end;

function TTask.AddCategory(const Category : TCategory) : Boolean;
var i : Integer;
begin
  Result := False;
  for i := 0 To High(FCategories) do
    if FCategories[i] = Category then Exit;
  SetLength(FCategories, Length(FCategories) + 1);
  FCategories[High(FCategories)] := Category;
  Changed;
  Result := True;
end;

function TTask.RemoveCategory(const Category : TCategory) : Boolean;
var i : Integer;
begin
  for i := 0 To High(FCategories) do
    if FCategories[i] = Category then begin
      if i < High(FCategories) then
        Move(FCategories[i + 1], FCategories[i], (High(FCategories) - i) * SizeOf(FCategories[i]));
      SetLength(FCategories, Length(FCategories) - 1);
      Result := True;
      Exit;
    end;
  Result := False;
end;

procedure TTask.ClearCategories;
begin
  if Length(FCategories) > 0 then begin
    SetLength(FCategories, 0);
    Changed;
  end;
end;

{ TReminder }

constructor TReminder.Create;
begin
  Create('');
end;

constructor TReminder.Create(const AName : String);
begin
  inherited;
  FTimeStamp := '';
  FSnoozeTime := 0;
  FLastCheckTime := 0;
end;

destructor TReminder.Destroy;
begin
  if FTask <> nil then
    FTask.FReminder := nil;
  inherited;
end;

procedure TReminder.ValidateTimeStamp(const value : String);
var r : TResult;
begin
  if value = '' then Exit;
  r := Parser.Evaluate(value);
  if (r.ResType <> rtTime) and ((FTask = nil) or (FTask.StartTime = 0) or (r.ResType <> rtInt)) then
    raise EParseException.Create('Timestamp expression must be of date/time type or integer type (if task start time is specified)');
end;

procedure TReminder.SetTimeStamp(const value : String);
begin
  ValidateTimeStamp(value);
  if FTimeStamp <> value then begin
    FTimeStamp := value;
    FSnoozeTime := 0;
    FLastCheckTime := 0;
    Changed;
  end;
end;

procedure TReminder.SetSnoozeTime(const value : TDateTime);
begin
  if FSnoozeTime <> value then begin
    FSnoozeTime := value;
    Changed;
  end;
end;

procedure TReminder.SetTask(const value : TTask);
begin
  if FTask <> nil then
    FTask.FReminder := nil;
  FTask := value;
  FTask.FReminder := self;
end;

function TReminder.GetFireTime : TDateTime;
var r : TResult;
begin
  if (FTask <> nil) and FTask.Complete then begin
    Result := 0;
    Exit;
  end;
  if FSnoozeTime <> 0 then begin
    Result := FSnoozeTime;
    Exit;
  end;
  Result := 0;
  if FTimeStamp <> '' then
    r := Parser.Evaluate(FTimeStamp)
  else
    r := Parser.Evaluate('+0');
  case r.ResType of
    rtTime : Result := r.TimeValue;
    rtInt  : if (FTask <> nil) and (FTask.StartTime <> 0) then Result := FTask.StartTime + r.IntValue / (24 * 60);
    else Assert(False);
  end;
end;

function TReminder.isFireTime : Boolean;
var t, f : TDateTime;
begin
  if (FTask <> nil) and FTask.Complete then begin
    Result := False;
    Exit;
  end;
  t := Now;
  f := GetFireTime;
  Result := (t > f) and (f > FLastCheckTime) and (FLastCheckTime <> 0);
  FLastCheckTime := t;
end;

constructor TReminder.FromString(const s : String; const Resolver : TPointerResolver);
var
  sl : TStringList;
  ss : String;
begin
  sl := TStringList.Create;
  try
    sl.Text := s;
    FName := Decode(sl[0]);
    FTimeStamp := Decode(sl[1]);
    ss := Decode(sl[2]);
    if ss <> '' then
      FSnoozeTime := StrToDateTime(ss)
    else
      FSnoozeTime := 0;
    ss := Decode(sl[3]);
    if ss <> '' then
      FLastCheckTime := StrToDateTime(ss)
    else
      FLastCheckTime := 0;
    Resolver.AddPointer(sl[4], @FTask);
  finally
    sl.Free;
  end;
end;

function TReminder.ToString : String;
var
  sl : TStringList;
  ss : String;
begin
  sl := TStringList.Create;
  try
    sl.Add(Encode(FName));
    sl.Add(Encode(FTimeStamp));
    if FSnoozeTime <> 0 then
      ss := DateTimeToStr(FSnoozeTime)
    else
      ss := '';
    sl.Add(Encode(ss));
    if FLastCheckTime <> 0 then
      ss := DateTimeToStr(FLastCheckTime)
    else
      ss := '';
    sl.Add(Encode(ss));
    sl.Add(TPointerResolver.PointerToStr(FTask));
    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

{ TCategory }

constructor TCategory.Create(const AName : String; AParent : TCategory);
begin
  inherited Create(AName);
  FParent := AParent;
  FColor := clSilver;
end;

procedure TCategory.SetColor(value : TColor);
begin
  if FColor <> value then begin
    FColor := value;
    Changed;
  end;
end;

procedure TCategory.SetParent(value : TCategory);
begin
  if FParent.HasParent(self) then
    raise Exception.Create('Circular parent references are not allowed');
  if FParent <> value then begin
    FParent := value;
    Changed;
  end;
end;

procedure TCategory.SetIndex(value : Integer);
begin
  if FIndex <> value then begin
    FIndex := value;
    Changed;
  end;
end;

function TCategory.HasParent(Category : TCategory) : Boolean;
var own : TCategory;
begin
  own := Self;
  while own <> nil do begin
    if own = Category then begin
      Result := True;
      Exit;
    end;
    own := own.Parent;
  end;
  Result := False;
end;

constructor TCategory.FromString(const s : String; const Resolver : TPointerResolver);
var sl : TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Text := s;
    FName := Decode(sl[0]);
    FColor := StrToInt('$' + sl[1]);
    FIndex := StrToInt(sl[2]);
    Resolver.AddPointer(sl[3], @FParent);
  finally
    sl.Free;
  end;
end;

function TCategory.ToString : String;
var sl : TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Add(Encode(FName));
    sl.Add(IntToHex(FColor, 6));
    sl.Add(IntToStr(FIndex));
    sl.Add(TPointerResolver.PointerToStr(FParent));
    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

{ TNamedObjectsStorage }

constructor TNamedObjectsStorage.Create;
begin
  inherited;
  FItems := TList.Create;
  FSelections := TList.Create;
end;

destructor TNamedObjectsStorage.Destroy;
begin
  FSelections.Free;
  FSelections := nil;
  FItems.Free;
  FItems := nil;
  inherited;
end;

function TNamedObjectsStorage.GetItem(index : Integer) : TNamedObject;
begin
  Result := TNamedObject(FItems[index]);
end;

function TNamedObjectsStorage.GetCount : Integer;
begin
  Result := FItems.Count;
end;

function TNamedObjectsStorage.GetObject(const name : String) : TNamedObject;
var i : Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if Items[i].Name = name then begin
      Result := FItems[i];
    end;
end;

procedure TNamedObjectsStorage.SetFileName(const value : String);
begin
  if FFileName <> value then begin
    FFileName := value;
    if FFileName <> '' then
      LoadFromFile(FFileName); 
  end;
end;

procedure TNamedObjectsStorage.Delete(item : TNamedObject);
var i : Integer;
begin
  if (item is TTask) and (TTask(item).Reminder <> nil) then
    Delete(TTask(item).Reminder);
  for i := 0 to FSelections.Count - 1 do
    TObjectsSelection(FSelections[i]).NotifyDelete(item);
  FItems.Remove(item);
  if item.FOwner = self then
    item.Free;
  if FFileName <> '' then
    SaveToFile(FFileName);
end;

procedure TNamedObjectsStorage.Add(item : TNamedObject);
var i : Integer;
begin
  item.FOwner := self;
  if (item is TTask) and (TTask(item).FTaskID = 0) then
    TTask(item).FTaskID := NextID;
  FItems.Add(item);
  for i := 0 to FSelections.Count - 1 do
    TObjectsSelection(FSelections[i]).NotifyAdd(item);
  if FFileName <> '' then
    SaveToFile(FFileName);
end;

procedure TNamedObjectsStorage.NotifyChange(item : TNamedObject);
var i : Integer;
begin
  for i := 0 to FSelections.Count - 1 do
    TObjectsSelection(FSelections[i]).NotifyItemChange(item);
  if FFileName <> '' then
    SaveToFile(FFileName);
end;

function TNamedObjectsStorage.NextID : Integer;
begin
  Result := FNextID;
  Inc(FNextID);
end;

procedure TNamedObjectsStorage.LoadFromFile(const FileName : String);
var
  s, ClassName, ObjID : String;
  sl : TStringList;
  Resolver : TPointerResolver;
  t : TextFile;
  o : TNamedObject;
begin
  AssignFile(t, FileName);
  Reset(t);
  ReadLn(t, FNextID);
  ReadLn(t);
  sl := TStringList.Create;
  Resolver := TPointerResolver.Create;
  try
    while not EOF(t) do begin
      sl.Clear;
      ReadLn(t, ObjID);
      ReadLn(t, ClassName);
      repeat
        ReadLn(t, s);
        sl.Add(s);
      until s = '';
      if ClassName = TTask.ClassName then
        o := TTask.FromString(sl.Text, Resolver)
      else if ClassName = TReminder.ClassName then
        o := TReminder.FromString(sl.Text, Resolver)
      else if ClassName = TCategory.ClassName then
        o := TCategory.FromString(sl.Text, Resolver)
      else begin
        raise Exception.Create('Unknown class');
        o := nil;
      end;
      Resolver.AddObject(ObjID, o);
      o.FOwner := Self;
      FItems.Add(o);
    end;
    Resolver.Reconcile;
  finally
    sl.Free;
    Resolver.Free;
    CloseFile(t);
  end;
end;

procedure TNamedObjectsStorage.SaveToFile(const FileName : String);
var
  t : TextFile;
  i : Integer;
begin
  AssignFile(t, FileName + '.new');
  Rewrite(t);
  WriteLn(t, FNextID);
  WriteLn(t);
  try
    for i := 0 to Count - 1 do begin
      WriteLn(t, TPointerResolver.PointerToStr(Items[i]));
      WriteLn(t, Items[i].ClassName);
      WriteLn(t, Items[i].ToString);
    end;
  finally
    CloseFile(t);
  end;
  DeleteFile(FileName);
  RenameFile(FileName + '.new', FileName);
end;

{ TObjectsSelection }

constructor TObjectsSelection.Create(AStorage : TNamedObjectsStorage);
begin
  FStorage := AStorage;
  FStorage.FSelections.Add(self);
  FSelection := TList.Create;
end;

destructor TObjectsSelection.Destroy;
begin
  FStorage.FSelections.Remove(self);
  FStorage := nil;
  FSelection.Free;
  FSelection := nil;
  inherited;
end;

procedure TObjectsSelection.NotifyAdd(item : TNamedObject);
begin
  if (FSelection.IndexOf(item) < 0) and Belongs(item) then
    Select(item);
end;

procedure TObjectsSelection.NotifyDelete(item : TNamedObject);
begin
  if FSelection.IndexOf(item) >= 0 then
    Release(item);
end;

procedure TObjectsSelection.NotifyItemChange(item : TNamedObject);
begin
  if (FSelection.IndexOf(item) < 0) and Belongs(item) then
    Select(item)
  else if (FSelection.IndexOf(item) >= 0) and not Belongs(item) then
    Release(item)
  else if (FSelection.IndexOf(item) >= 0) then begin
    if Assigned(FCompare) then
      FSelection.Sort(FCompare);
    if Assigned(FOnItemChange) then
      FOnItemChange(self, item);
  end;
end;

procedure TObjectsSelection.Select(const obj : TNamedObject);
begin
  if FSelection.IndexOf(obj) >= 0 then
    Exit;
  FSelection.Add(obj);
  if Assigned(FCompare) then
    FSelection.Sort(FCompare);
  if Assigned(FOnAdd) then
    FOnAdd(self, obj);
end;

procedure TObjectsSelection.Release(const obj : TNamedObject);
begin
  if FSelection.IndexOf(obj) < 0 then
    Exit;
  if Assigned(FOnDelete) then
    FOnDelete(self, obj);
  FSelection.Remove(obj);
end;

procedure TObjectsSelection.ReSelectAll;
var
  i : Integer;
  l : TList;
begin
  ClearSelection;
  if not Assigned(FCompare) then begin
    for i := 0 to FStorage.Count - 1 do
      if Belongs(FStorage[i]) then
        Select(FStorage[i]);
  end else begin
    l := TList.Create;
    try
      for i := 0 to FStorage.Count - 1 do
        if Belongs(FStorage[i]) then
          l.Add(FStorage[i]);
      l.Sort(FCompare);
      for i := 0 to l.Count - 1 do
        Select(l[i]);
    finally
      l.Free;
    end;
  end;
end;

procedure TObjectsSelection.Add(const obj : TNamedObject);
begin
  FStorage.Add(obj);
end;

procedure TObjectsSelection.Delete(const obj : TNamedObject);
begin
  FStorage.Delete(obj);
end;

procedure TObjectsSelection.ClearSelection;
begin
  while Count > 0 do
    Release(Items[0]);
end;

procedure TObjectsSelection.Sort(compare : TListSortCompare);
begin
  FSelection.Sort(compare);
end;

function TObjectsSelection.GetItem(index : Integer) : TNamedObject;
begin
  Result := TNamedObject(FSelection[index]);
end;

function TObjectsSelection.GetCount : Integer;
begin
  Result := FSelection.Count;
end;

function TObjectsSelection.IndexOf(const obj : TNamedObject) : Integer;
begin
  Result := FSelection.IndexOf(obj);
end;

{ TManualSelection }

function TManualSelection.Belongs(const obj : TNamedObject) : Boolean;
begin
  Result := FSelection.IndexOf(obj) >= 0; // tautology
end;

procedure TManualSelection.Add(const obj : TNamedObject);
begin
  inherited;
  if not Belongs(obj) then
    Select(obj);
end;

{ TCompleteSelection }

function TCompleteSelection.Belongs(const obj : TNamedObject) : Boolean;
begin
  Result := True;
end;

{ TSingletonSelection }

procedure TSingletonSelection.Add(const obj : TNamedObject);
begin
  if FSelection.Count = 0 then
    inherited
  else
    raise Exception.Create('You cannot add through singleton selection');
end;

procedure TSingletonSelection.Select(const obj : TNamedObject);
begin
  if FSelection.Count = 0 then
    inherited
  else
    raise Exception.Create('You cannot select more than one item in singleton selection');
end;

function TSingletonSelection.GetItem : TNamedObject;
begin
  if FSelection.Count > 0 then
    Result := FSelection[0]
  else
    Result := nil;
end;

procedure TSingletonSelection.SetItem(const value : TNamedObject);
begin
  if FSelection.Count > 0 then begin
    Release(FSelection[0]);
  end;
  if value <> nil then
    Select(value);
end;

{ TPointerResolver }

constructor TPointerResolver.Create;
begin
  FObjects := TStringList.Create;
  FObjects.AddObject(PointerToStr(nil), nil);
  FPointers := TStringList.Create;
end;

destructor TPointerResolver.Destroy;
begin
  FPointers.Free;
  FObjects.Free;
  inherited;
end;

procedure TPointerResolver.AddObject(const s : String; const o : TObject);
begin
  FObjects.AddObject(s, o);
end;

procedure TPointerResolver.AddPointer(const s : String; const p : PTObject);
begin
  FPointers.AddObject(s, TObject(p));
end;

procedure TPointerResolver.Reconcile;
var
  i, ip : Integer;
  p : Pointer;
  o : TObject;
begin
  for i := 0 to FPointers.Count - 1 do begin
    ip := FObjects.IndexOf(FPointers[i]);
    if ip < 0 then
      raise Exception.Create('Unable to reconcile pointers');
    p := FPointers.Objects[i];
    o := FObjects.Objects[ip];
    PTObject(p)^ := o;
  end;
end;

class function TPointerResolver.PointerToStr(o : TObject) : String;
begin
  Result := IntToHex(Integer(o), 8);
end;

procedure FreeStorage;
var i : Integer;
begin
  for i := 0 to TaskStorage.Count - 1 do
    TaskStorage[i].Free;
  TaskStorage.Free;
  TaskStorage := nil;
end;

initialization
  TaskStorage := TNamedObjectsStorage.Create;
  TaskStorage.PersistentStorageFile := TasksFileName;
finalization
  FreeStorage;
end.
