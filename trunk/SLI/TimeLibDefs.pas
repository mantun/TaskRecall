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
  b : IBoolResult;
  first : IResult;
  it : IListIterator;
begin
  if args.IsEmpty then
    Result := TTimeResult.Create(Now)
  else begin
    it := args.Iterator;
    first := Eval(it.Next);
    if not it.HasNext or not Supports(Eval(it.Next), ITimeResult, t) then
      Raise EFunctionException.Create(GetName + ' requires date and time arguments');
    if Supports(first, ITimeResult, d) then
      Result := TTimeResult.Create(Trunc(d.GetValue) + Frac(t.GetValue))
    else if Supports(first, IBoolResult, b) then
      if b.GetValue then
        Result := TTimeResult.Create(Date + Frac(t.GetValue))
      else
        Result := TTimeResult.Create(0)
    else
      Raise EFunctionException.Create(GetName + ' requires date and time arguments')
  end;
end;

type
  TTimeSequenceFunc = class(TTimeLibFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TTimeSequenceFunc.Apply(const args : ILinkedList) : IResult;
var
  it : IListIterator;
  tr : ITimeResult;
  t, nearest : TDateTime;
  InitT : Boolean;
begin
  if args.IsEmpty then
    raise EFunctionException.Create(GetName + ' requires time arguments');
  it := args.Iterator;
  InitT := False;
  t := 0;
  nearest := 0;
  while it.HasNext do begin
    if not Supports(Eval(it.Next), ITimeResult, tr) then
      raise EFunctionException.Create(GetName + ' requires time arguments');
    if not InitT then begin
      if Trunc(tr.GetValue) = 0 then t := Time
                                else t := Now;
      nearest := tr.GetValue;
      InitT := True;
    end;
    if Abs(t - nearest) > Abs(t - tr.GetValue) then
      nearest := tr.GetValue;
  end;
  Assert(InitT);
  Result := TTimeResult.Create(nearest);
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
  hr, mr, sr : IIntResult;
  m, s : Integer;
  it : IListIterator;
begin
  it := args.Iterator;
  if it.HasNext and Supports(Eval(it.Next), IIntResult, hr) then begin
    if it.HasNext and Supports(Eval(it.Next), IIntResult, mr) then
      m := mr.GetValue
    else
      m := 0;
    if it.HasNext and Supports(Eval(it.Next), IIntResult, sr) then
      s := sr.GetValue
    else
      s := 0;
    Result := TTimeResult.Create(EncodeTime(hr.GetValue, m, s, 0))
  end else
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
  dr, mr, yr : IIntResult;
  y : Integer;
  it : IListIterator;
begin
  it := args.Iterator;
  if it.HasNext and Supports(Eval(it.Next), IIntResult, dr) and
     it.HasNext and Supports(Eval(it.Next), IIntResult, mr) then begin
    if it.HasNext and Supports(Eval(it.Next), IIntResult, yr) then
      y := yr.GetValue
    else
      y := 0;
    Result := TTimeResult.Create(EncodeDate(y, mr.GetValue, dr.GetValue))
  end else
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
  AddFuncInternal(TTimeSequenceFunc.Create('seq'));

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
