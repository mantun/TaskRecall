unit Func;

interface

uses SysUtils, Parse;

type
  EFunctionException = class(Exception);

function perform(const name : String; const params : TResultArray) : TResult;

implementation

uses DateUtils;

const
  TrueRes : TResult = (ResType: rtBool; BoolValue: True);
  FalseRes : TResult = (ResType: rtBool; BoolValue: False);

type
  TFunc = function(const params : TResultArray) : TResult;
  TFuncDef = record
    Name : String;
    EntryPoint : TFunc;
  end;

Var
  Functions : Array Of TFuncDef;

procedure addFunc(f : TFunc; name : String);
begin
  SetLength(Functions, Length(Functions) + 1);
  Functions[High(Functions)].Name := Name;
  Functions[High(Functions)].EntryPoint := f;
end;

function perform(const name : String; const params : TResultArray) : TResult;
var i : Integer;
begin
  for i := Low(Functions) to High(Functions) do begin
    if Functions[i].Name = name then begin
      Result := Functions[i].EntryPoint(params);
      Exit;
    end;
  end;
  raise EFunctionException.Create('Unknown function: ' + name);
end;

function getBool(b : Boolean) : TResult;
begin
  if b then Result := TrueRes
       else Result := FalseRes;
end;

function getTimeParam(const params : TResultArray; const defaultValue : TDateTime) : TDateTime;
begin
  if (Length(params) = 0) or (params[0].ResType <> rtTime) then
    Result := DefaultValue
  else
    Result := params[0].TimeValue;
end;

{ Boolean Constants }

function fTrue(const params : TResultArray) : TResult;
begin
  Result := TrueRes;
end;

function fFalse(const params : TResultArray) : TResult;
begin
  Result := FalseRes;
end;

{ Time }

function fNow(const params : TResultArray) : TResult;
begin
  Result.ResType := rtTime;
  Result.TimeValue := Now;
end;

function fTime(const params : TResultArray) : TResult;
begin
  Result.ResType := rtTime;
  Result.TimeValue := Time;
end;

function fHour(const params : TResultArray) : TResult;
var h, m, s, ms : Word;
begin
  Result.ResType := rtInt;
  DecodeTime(getTimeParam(params, Time), h, m, s, ms);
  Result.IntValue := h;
end;

function fMinute(const params : TResultArray) : TResult;
var h, m, s, ms : Word;
begin
  Result.ResType := rtInt;
  DecodeTime(getTimeParam(params, Time), h, m, s, ms);
  Result.IntValue := m;
end;

function fSecond(const params : TResultArray) : TResult;
var h, m, s, ms : Word;
begin
  Result.ResType := rtInt;
  DecodeTime(getTimeParam(params, Time), h, m, s, ms);
  Result.IntValue := s;
end;

function fHourMinSec(const params : TResultArray) : TResult;
var h, m, s : Integer;
begin
  if (Length(params) = 0) then
    h := 0
  else if (params[0].ResType <> rtInt) then
    h := -1
  else
    h := params[0].IntValue;
  if (Length(params) < 2) then
    m := 0
  else if (params[1].ResType <> rtInt) then
    m := -1
  else
    m := params[1].IntValue;
  if (Length(params) < 3) then
    s := 0
  else if (params[2].ResType <> rtInt) then
    s:= -1
  else
    s := params[2].IntValue;
  Result.ResType := rtTime;
  Result.TimeValue := EncodeTime(h, m, s, 0);
end;

{ Date }

function fDate(const params : TResultArray) : TResult;
begin
  Result.ResType := rtTime;
  Result.TimeValue := Date;
end;

function fDay(const params : TResultArray) : TResult;
begin
  Result.ResType := rtInt;
  Result.IntValue := DayOfTheMonth(getTimeParam(params, Date));
end;

function fMonth(const params : TResultArray) : TResult;
var y, m, d : Word;
begin
  Result.ResType := rtInt;
  DecodeDate(getTimeParam(params, Date), y, m, d);
  Result.IntValue := m;
end;

function fYear(const params : TResultArray) : TResult;
var y, m, d : Word;
begin
  Result.ResType := rtInt;
  DecodeDate(getTimeParam(params, Date), y, m, d);
  Result.IntValue := y;
end;

function fDayOfWeek(const params : TResultArray) : TResult;
begin
  Result.ResType := rtInt;
  Result.IntValue := DayOfTheWeek(getTimeParam(params, Date));
end;

function fDayOfYear(const params : TResultArray) : TResult;
begin
  Result.ResType := rtInt;
  Result.IntValue := DayOfTheYear(getTimeParam(params, Date));
end;

function fDayMonthYear(const params : TResultArray) : TResult;
begin
  if (Length(params) < 3) or (params[0].ResType <> rtInt) or
     (params[1].ResType <> rtInt) or (params[2].ResType <> rtInt) then
    Raise EFunctionException.Create('dmy requires three integer arguments');
  Result.ResType := rtTime;
  Result.TimeValue := EncodeDate(params[2].IntValue, params[1].IntValue, params[0].IntValue);
end;

{ Comparison }

function fEqual(const params : TResultArray) : TResult;
var i : Integer;
begin
  if Length(params) < 2 then
    Result := TrueRes
  else begin
    for i := 1 to High(params) do
      if not CompareMem(@params[0], @params[i], SizeOf(params[0])) then begin
        Result := FalseRes;
        Exit;
      end;
    Result := TrueRes;
  end;
end;

function fGreaterOrEqual(const params : TResultArray) : TResult;
begin
  if (Length(params) < 2) or (params[0].ResType <> params[1].ResType) then
    Result := FalseRes
  else
    case params[0].ResType of
      rtTime : Result := getBool(params[0].TimeValue >= params[1].TimeValue);
      rtInt : Result := getBool(params[0].IntValue >= params[1].IntValue);
      rtBool : Result := getBool(params[0].BoolValue >= params[1].BoolValue);
      else Result := FalseRes;
    end;
end;

function fLessOrEqual(const params : TResultArray) : TResult;
begin
  if (Length(params) < 2) or (params[0].ResType <> params[1].ResType) then
    Result := FalseRes
  else
    case params[0].ResType of
      rtTime : Result := getBool(params[0].TimeValue <= params[1].TimeValue);
      rtInt : Result := getBool(params[0].IntValue <= params[1].IntValue);
      rtBool : Result := getBool(params[0].BoolValue <= params[1].BoolValue);
      else Result := FalseRes;
    end;
end;

function fIn(const params : TResultArray) : TResult;
var i : Integer;
begin
  if Length(params) >= 2 then
    for i := 1 to High(params) do
      if CompareMem(@params[0], @params[i], SizeOf(params[0])) then begin
        Result := TrueRes;
        Exit;
      end;
  Result := FalseRes;
end;

function fBetween(const params : TResultArray) : TResult;
begin
  if Length(params) < 3 then
    raise EFunctionException.Create('between requires 3 arguments');
  if (params[0].ResType <> params[1].ResType) or (params[0].ResType <> params[2].ResType) then
    raise EFunctionException.Create('between requires arguments of the same type');
  case params[0].ResType of
    rtTime : Result := getBool((params[0].TimeValue >= params[1].TimeValue) and (params[0].TimeValue <= params[2].TimeValue));
    rtInt : Result := getBool((params[0].IntValue >= params[1].IntValue) and (params[0].IntValue <= params[2].IntValue));
    rtBool : Result := TrueRes;
    else Result := FalseRes;
  end;
end;

function fIf(const params : TResultArray) : TResult;
begin
  if Length(params) < 3 then
    raise EFunctionException.Create('if requires 3 arguments');
  if params[0].ResType <> rtBool then
    raise EFunctionException.Create('if requires boolean as first argument');
  if params[0].BoolValue then
    Result := params[1]
  else
    Result := params[2];
end;

function fAnd(const params : TResultArray) : TResult;
var i : Integer;
begin
  if Length(params) = 0 then
    Result := FalseRes
  else begin
    for i := Low(params) to High(params) do begin
      if params[i].ResType <> rtBool then
        raise EFunctionException.Create('and requires boolean arguments: ' + IntToStr(i));
      if not params[i].BoolValue then begin
        Result := FalseRes;
        Exit;
      end;
    end;
    Result := TrueRes;
  end;
end;

function fOr_(const params : TResultArray) : TResult;
var i : Integer;
begin
  if Length(params) = 0 then
    Result := FalseRes
  else begin
    for i := Low(params) to High(params) do begin
      if params[i].ResType <> rtBool then
        raise EFunctionException.Create('or requires boolean arguments: ' + IntToStr(i));
      if params[i].BoolValue then begin
        Result := TrueRes;
        Exit;
      end;
    end;
    Result := FalseRes;
  end;
end;

function fNot(const params : TResultArray) : TResult;
begin
  if Length(params) < 1 then
    raise EFunctionException.Create('not requires 1 argument');
  if params[0].ResType <> rtBool then
    raise EFunctionException.Create('not requires boolean argument');
  if params[0].BoolValue then
    Result := FalseRes
  else
    Result := TrueRes;
end;

{ Arithmetic }

function fPlus(const params : TResultArray) : TResult;
var i : Integer;
begin
  Result.ResType := rtInt;
  Result.IntValue := 0;
  for i := Low(params) to High(params) do begin
    if params[i].ResType <> rtInt then
      raise EFunctionException.Create('+ requires integer arguments: ' + IntToStr(i));
    Result.IntValue := Result.IntValue + params[i].IntValue;
  end;
end;

function fMinus(const params : TResultArray) : TResult;
begin
  if (Length(params) <> 2) or (params[0].ResType <> rtInt) or (params[1].ResType <> rtInt) then
    raise EFunctionException.Create('- requires 2 integer arguments: ');
  Result.ResType := rtInt;
  Result.IntValue := params[0].IntValue - params[1].IntValue;
end;

function fMultiply(const params : TResultArray) : TResult;
var i : Integer;
begin
  Result.ResType := rtInt;
  Result.IntValue := 1;
  for i := Low(params) to High(params) do begin
    if params[i].ResType <> rtInt then
      raise EFunctionException.Create('- requires integer arguments: ' + IntToStr(i));
    Result.IntValue := Result.IntValue * params[i].IntValue;
  end;
end;

function fDivide(const params : TResultArray) : TResult;
begin
  if (Length(params) <> 2) or (params[0].ResType <> rtInt) or (params[1].ResType <> rtInt) then
    raise EFunctionException.Create('/ requires 2 integer arguments: ');
  Result.ResType := rtInt;
  Result.IntValue := params[0].IntValue div params[1].IntValue;
end;

function fModulo(const params : TResultArray) : TResult;
begin
  if (Length(params) <> 2) or (params[0].ResType <> rtInt) or (params[1].ResType <> rtInt) then
    raise EFunctionException.Create('% requires 2 integer arguments: ');
  Result.ResType := rtInt;
  Result.IntValue := params[0].IntValue mod params[1].IntValue;
end;

initialization
  addFunc(@fTrue, 'true');
  addFunc(@fFalse, 'false');

  addFunc(@fNow, 'now');
  addFunc(@fTime, 'time');
  addFunc(@fHour, 'hour');
  addFunc(@fMinute, 'min');
  addFunc(@fSecond, 'sec');
  addFunc(@fHourMinSec, 'hms');

  addFunc(@fDate, 'date');
  addFunc(@fDay, 'day');
  addFunc(@fMonth, 'month');
  addFunc(@fYear, 'year');
  addFunc(@fDayOfWeek, 'dow');
  addFunc(@fDayOfYear, 'doy');

  addFunc(@fEqual, '=');
  addFunc(@fIn, 'in');
  addFunc(@fBetween, 'between');
  addFunc(@fGreaterOrEqual, '>=');
  addFunc(@fLessOrEqual, '<=');

  addFunc(@fIf, 'if');
  addFunc(@fAnd, 'and');
  addFunc(@fOr_, 'or');
  addFunc(@fNot, 'not');

  addFunc(@fPlus, '+');
  addFunc(@fMinus, '-');
  addFunc(@fMultiply, '*');
  addFunc(@fDivide, '/');
  addFunc(@fModulo, '%');
end.
