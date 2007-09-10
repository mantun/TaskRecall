unit TimeLibDefs;

interface

implementation

uses SysUtils, DateUtils, Lists, Eval, ResultDecl, BuiltinDefs;

type
  TTimeLibFunc = class(TPredefinedFunc)
  protected
    function GetTimeParam(const args : ILinkedList; const defaultValue : TDateTime) : TDateTime;
  end;

function TTimeLibFunc.GetTimeParam(const args : ILinkedList; const defaultValue : TDateTime) : TDateTime;
var t : ITimeResult;
begin
  if not args.IsEmpty and Supports(Eval(args.Head), ITimeResult, t) then
    Result := t.GetValue
  else
    Result := DefaultValue;
end;

{ Time }

type
  TNowFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TNowFunc.Apply(const args : ILinkedList) : IResult;
begin
  Result := TTimeResult.Create(Now);
end;

type
  TTimeStampFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TTimeStampFunc.Apply(const args : ILinkedList) : IResult;
var
  d, t : ITimeResult;
  it : IListIterator;
begin
  if args.IsEmpty then
    Result := TTimeResult.Create(Now)
  else begin
    it := args.Iterator;
    if Supports(Eval(it.Next), ITimeResult, d) and
       it.HasNext and Supports(Eval(it.Next), ITimeResult, t) then
      Result := TTimeResult.Create(Trunc(d.GetValue) + Frac(t.GetValue))
    else
      Raise EFunctionException.Create(GetName + ' requires date and time arguments');
  end;
end;

type
  TTimeFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TTimeFunc.Apply(const args : ILinkedList) : IResult;
begin
  Result := TTimeResult.Create(Frac(GetTimeParam(args, Time)));
end;

type
  THourFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function THourFunc.Apply(const args : ILinkedList) : IResult;
var h, m, s, ms : Word;
begin
  DecodeTime(GetTimeParam(args, Time), h, m, s, ms);
  Result := TIntResult.Create(h);
end;

type
  TMinuteFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TMinuteFunc.Apply(const args : ILinkedList) : IResult;
var h, m, s, ms : Word;
begin
  DecodeTime(GetTimeParam(args, Time), h, m, s, ms);
  Result := TIntResult.Create(m);
end;

type
  TSecondFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TSecondFunc.Apply(const args : ILinkedList) : IResult;
var h, m, s, ms : Word;
begin
  DecodeTime(GetTimeParam(args, Time), h, m, s, ms);
  Result := TIntResult.Create(s);
end;

type
  THourMinSecFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function THourMinSecFunc.Apply(const args : ILinkedList) : IResult;
var
  h, m, s : IIntResult;
  it : IListIterator;
begin
  it := args.Iterator;
  if it.HasNext and Supports(Eval(it.Next), IIntResult, h) and
     it.HasNext and Supports(Eval(it.Next), IIntResult, m) and
     it.HasNext and Supports(Eval(it.Next), IIntResult, s) then
    Result := TTimeResult.Create(EncodeTime(h.GetValue, m.GetValue, s.GetValue, 0))
  else
    raise EFunctionException.Create('Invalid time for ' + GetName);
end;

{ Date }

type
  TDateFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TDateFunc.Apply(const args : ILinkedList) : IResult;
begin
  Result := TTimeResult.Create(GetTimeParam(args, Date));
end;

type
  TDayFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TDayFunc.Apply(const args : ILinkedList) : IResult;
begin
  Result := TIntResult.Create(DayOfTheMonth(GetTimeParam(args, Date)));
end;

type
  TMonthFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TMonthFunc.Apply(const args : ILinkedList) : IResult;
var y, m, d : Word;
begin
  DecodeDate(GetTimeParam(args, Date), y, m, d);
  Result := TIntResult.Create(m);
end;

type
  TYearFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TYearFunc.Apply(const args : ILinkedList) : IResult;
var y, m, d : Word;
begin
  DecodeDate(GetTimeParam(args, Date), y, m, d);
  Result := TIntResult.Create(y);
end;

type
  TDayOfWeekFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TDayOfWeekFunc.Apply(const args : ILinkedList) : IResult;
begin
  Result := TIntResult.Create(DayOfTheWeek(GetTimeParam(args, Date)));
end;

type
  TDayOfYearFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TDayOfYearFunc.Apply(const args : ILinkedList) : IResult;
begin
  Result := TIntResult.Create(DayOfTheYear(GetTimeParam(args, Date)));
end;

type
  TDayMonthYearFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TDayMonthYearFunc.Apply(const args : ILinkedList) : IResult;
var
  d, m, y : IIntResult;
  it : IListIterator;
begin
  it := args.Iterator;
  if it.HasNext and Supports(Eval(it.Next), IIntResult, d) and
     it.HasNext and Supports(Eval(it.Next), IIntResult, m) and
     it.HasNext and Supports(Eval(it.Next), IIntResult, y) then
    Result := TTimeResult.Create(EncodeDate(y.GetValue, m.GetValue, d.GetValue))
  else
    Raise EFunctionException.Create('Invalid date for ' + GetName);
end;

procedure AddFuncInternal(func : IFuncResult);
begin
  Evaluator.AddDefinition(TDefinition.Create(func.GetName, func));
end;

initialization
  Evaluator.PushFrame;
  AddFuncInternal(TNowFunc.Create('now'));
  AddFuncInternal(TTimeStampFunc.Create('ts'));
  AddFuncInternal(TTimeFunc.Create('time'));
  AddFuncInternal(THourFunc.Create('hour'));
  AddFuncInternal(TMinuteFunc.Create('min'));
  AddFuncInternal(TSecondFunc.Create('sec'));
  AddFuncInternal(THourMinSecFunc.Create('hms'));

  AddFuncInternal(TDateFunc.Create('date'));
  AddFuncInternal(TDayFunc.Create('day'));
  AddFuncInternal(TMonthFunc.Create('month'));
  AddFuncInternal(TYearFunc.Create('year'));
  AddFuncInternal(TDayOfWeekFunc.Create('dow'));
  AddFuncInternal(TDayOfYearFunc.Create('doy'));
  AddFuncInternal(TDayMonthYearFunc.Create('dmy'));
finalization
  Evaluator.PopFrame;
end.
