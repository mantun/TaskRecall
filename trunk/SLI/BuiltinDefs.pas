unit BuiltinDefs;

interface

uses SysUtils, Lists, ResultDecl;

type
  EFunctionException = class(Exception);

  IFuncResult = interface(IResult)
    ['{0804CB08-0CDA-4032-90CA-783D532F4857}']
    function GetName : String;
    function Apply(const arguments : ILinkedList) : IResult;
  end;

  TPredefinedFunc = class(TInterfacedObject, IFuncResult, IResult)
  private
    FName : String;
    function Eval(const r : IData) : IResult;
    function GetTimeParam(const args : ILinkedList; const defaultValue : TDateTime) : TDateTime;
  protected
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    function ToString : String;
    function GetName : String;
    function Apply(const arguments : ILinkedList) : IResult; virtual; abstract;
    constructor Create(const AName : String);
  end;

  TDefinition = record
    name : String;
    value : IResult;
  end;

var
  BuiltinDefinitions : Array Of TDefinition;

implementation

uses DateUtils, Func;

var
  FalseRes : IBoolResult;
  TrueRes : IBoolResult;

{ TPredefinedFunc }

function TPredefinedFunc._AddRef: Integer;
begin
  Result := -1;
end;

function TPredefinedFunc._Release: Integer;
begin
  Result := -1;
end;

function TPredefinedFunc.ToString : String;
begin
  Result := 'Function ' + GetName;
end;

function TPredefinedFunc.GetName : String;
begin
  Result := FName;
end;

function TPredefinedFunc.Eval(const r : IData) : IResult;
begin
  Result := Evaluator.Evaluate(IResult(r));
end;

function TPredefinedFunc.GetTimeParam(const args : ILinkedList; const defaultValue : TDateTime) : TDateTime;
var t : ITimeResult;
begin
  if not args.IsEmpty and Supports(Eval(args.Head), ITimeResult, t) then
    Result := t.GetValue
  else
    Result := DefaultValue;
end;

constructor TPredefinedFunc.Create(const AName : String);
begin
  inherited Create;
  FName := AName;
end;

{ Time }

type
  TNowFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TNowFunc.Apply(const args : ILinkedList) : IResult;
begin
  Result := TTimeResult.Create(Now);
end;

type
  TTimeStampFunc = class(TPredefinedFunc)
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
  TTimeFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TTimeFunc.Apply(const args : ILinkedList) : IResult;
begin
  Result := TTimeResult.Create(Frac(GetTimeParam(args, Time)));
end;

type
  THourFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function THourFunc.Apply(const args : ILinkedList) : IResult;
var h, m, s, ms : Word;
begin
  DecodeTime(GetTimeParam(args, Time), h, m, s, ms);
  Result := TIntResult.Create(h);
end;

type
  TMinuteFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TMinuteFunc.Apply(const args : ILinkedList) : IResult;
var h, m, s, ms : Word;
begin
  DecodeTime(GetTimeParam(args, Time), h, m, s, ms);
  Result := TIntResult.Create(m);
end;

type
  TSecondFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TSecondFunc.Apply(const args : ILinkedList) : IResult;
var h, m, s, ms : Word;
begin
  DecodeTime(GetTimeParam(args, Time), h, m, s, ms);
  Result := TIntResult.Create(s);
end;

type
  THourMinSecFunc = class(TPredefinedFunc)
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
  TDateFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TDateFunc.Apply(const args : ILinkedList) : IResult;
begin
  Result := TTimeResult.Create(GetTimeParam(args, Date));
end;

type
  TDayFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TDayFunc.Apply(const args : ILinkedList) : IResult;
begin
  Result := TIntResult.Create(DayOfTheMonth(GetTimeParam(args, Date)));
end;

type
  TMonthFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TMonthFunc.Apply(const args : ILinkedList) : IResult;
var y, m, d : Word;
begin
  DecodeDate(GetTimeParam(args, Date), y, m, d);
  Result := TIntResult.Create(m);
end;

type
  TYearFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TYearFunc.Apply(const args : ILinkedList) : IResult;
var y, m, d : Word;
begin
  DecodeDate(GetTimeParam(args, Date), y, m, d);
  Result := TIntResult.Create(y);
end;

type
  TDayOfWeekFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TDayOfWeekFunc.Apply(const args : ILinkedList) : IResult;
begin
  Result := TIntResult.Create(DayOfTheWeek(GetTimeParam(args, Date)));
end;

type
  TDayOfYearFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TDayOfYearFunc.Apply(const args : ILinkedList) : IResult;
begin
  Result := TIntResult.Create(DayOfTheYear(GetTimeParam(args, Date)));
end;

type
  TDayMonthYearFunc = class(TPredefinedFunc)
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

{ Comparison }

type
  TEqualFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TEqualFunc.Apply(const args : ILinkedList) : IResult;
var
  it : IListIterator;
  o : IComparable;
begin
  it := args.Iterator;
  Result := TrueRes;
  if it.HasNext and Supports(it.Next, IComparable, o) then
    while it.HasNext do begin
      if o.CompareTo(IResult(it.Next)) <> 0 then begin
        Result := FalseRes;
        Exit;
      end;
    end;
end;

type
  TGreaterOrEqualFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TGreaterOrEqualFunc.Apply(const args : ILinkedList) : IResult;
var
  o : IComparable;
  it : IListIterator;
begin
  it := args.Iterator;
  if it.HasNext and Supports(it.Next, IComparable, o) and it.HasNext and
     (o.CompareTo(IResult(it.Next)) >= 0) then
    Result := TrueRes
  else
    Result := FalseRes;
end;

type
  TLessOrEqualFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TLessOrEqualFunc.Apply(const args : ILinkedList) : IResult;
var
  o : IComparable;
  it : IListIterator;
begin
  it := args.Iterator;
  if it.HasNext and Supports(it.Next, IComparable, o) and it.HasNext and
     (o.CompareTo(IResult(it.Next)) <= 0) then
    Result := TrueRes
  else
    Result := FalseRes;
end;

type
  TInFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TInFunc.Apply(const args : ILinkedList) : IResult;
var
  it : IListIterator;
  o : IComparable;
begin
  it := args.Iterator;
  Result := FalseRes;
  if it.HasNext and Supports(it.Next, IComparable, o) then
    while it.HasNext do begin
      if o.CompareTo(IResult(it.Next)) = 0 then begin
        Result := TrueRes;
        Exit;
      end;
    end;
end;

type
  TBetweenFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TBetweenFunc.Apply(const args : ILinkedList) : IResult;
var
  o : IComparable;
  it : IListIterator;
begin
  it := args.Iterator;
  if it.HasNext and Supports(it.Next, IComparable, o) and
     it.HasNext and (o.CompareTo(IResult(it.Next)) >= 0) and
     it.HasNext and (o.CompareTo(IResult(it.Next)) <= 0) then
    Result := TrueRes
  else
    Result := FalseRes;
end;

{ Boolean }

type
  TIfFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TIfFunc.Apply(const args : ILinkedList) : IResult;
var
  c : IBoolResult;
  r1, r2 : IResult;
  it : IListIterator;
begin
  it := args.Iterator;
  if it.HasNext and Supports(Eval(it.Next), IBoolResult, c) then begin
    if it.HasNext then r1 := IResult(it.Next)
    else Raise EFunctionException.Create('Missing then caluse in ' + GetName);
    if it.HasNext then r2 := IResult(it.Next)
    else Raise EFunctionException.Create('Missing else caluse in ' + GetName);
    if c.GetValue then Result := r1
                  else Result := r2
  end else
    Raise EFunctionException.Create('Invalid condition in ' + GetName);
end;

type
  TAndFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TAndFunc.Apply(const args : ILinkedList) : IResult;
var
  it : IListIterator;
  b : IBoolResult;
begin
  if not it.HasNext then
    Result := FalseRes
  else begin
    while it.HasNext do begin
      if not Supports(Eval(it.Next), IBoolResult, b) then
        raise EFunctionException.Create(GetName + ' requires all boolean arguments');
      if not b.GetValue then begin
        Result := FalseRes;
        Exit;
      end;
    end;
    Result := TrueRes;
  end;
end;

type
  TOrFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TOrFunc.Apply(const args : ILinkedList) : IResult;
var
  it : IListIterator;
  b : IBoolResult;
begin
  while it.HasNext do begin
    if not Supports(Eval(it.Next), IBoolResult, b) then
      raise EFunctionException.Create(GetName + ' requires all boolean arguments');
    if b.GetValue then begin
      Result := TrueRes;
      Exit;
    end;
  end;
  Result := FalseRes;
end;

type
  TNotFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TNotFunc.Apply(const args : ILinkedList) : IResult;
var
  it : IListIterator;
  b : IBoolResult;
begin
  if it.HasNext and Supports(Eval(it.Next), IBoolResult, b) then begin
    if b.GetValue then Result := FalseRes
                  else Result := TrueRes;
  end else
    raise EFunctionException.Create(GetName + ' requires one boolean argument');
end;

{ Arithmetic }

type
  TPlusFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TPlusFunc.Apply(const args : ILinkedList) : IResult;
var
  sum : Integer;
  it : IListIterator;
  i : IIntResult;
begin
  sum := 0;
  it := args.Iterator;
  while it.HasNext do begin
    if not Supports(Eval(it.Next), IIntResult, i) then
      raise EFunctionException.Create(GetName + ' requires integer arguments');
    sum := sum + i.GetValue;
  end;
  Result := TIntResult.Create(sum);
end;

type
  TMinusFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TMinusFunc.Apply(const args : ILinkedList) : IResult;
var
  it : IListIterator;
  i1, i2 : IIntResult;
begin
  if it.HasNext and Supports(Eval(it.Next), IIntResult, i1) and
     it.HasNext and Supports(Eval(it.Next), IIntResult, i2) then
    Result := TIntResult.Create(i1.GetValue - i2.GetValue)
  else
    raise EFunctionException.Create(GetName + ' requires 2 integer arguments');
end;

type
  TMultiplyFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TMultiplyFunc.Apply(const args : ILinkedList) : IResult;
var
  prod : Integer;
  it : IListIterator;
  i : IIntResult;
begin
  prod := 0;
  it := args.Iterator;
  while it.HasNext do begin
    if not Supports(Eval(it.Next), IIntResult, i) then
      raise EFunctionException.Create(GetName + ' requires integer arguments');
    prod := prod + i.GetValue;
  end;
  Result := TIntResult.Create(prod);
end;

type
  TDivideFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TDivideFunc.Apply(const args : ILinkedList) : IResult;
var
  it : IListIterator;
  i1, i2 : IIntResult;
begin
  if it.HasNext and Supports(Eval(it.Next), IIntResult, i1) and
     it.HasNext and Supports(Eval(it.Next), IIntResult, i2) then
    Result := TIntResult.Create(i1.GetValue div i2.GetValue)
  else
    raise EFunctionException.Create(GetName + ' requires 2 integer arguments');
end;

type
  TModuloFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TModuloFunc.Apply(const args : ILinkedList) : IResult;
var
  it : IListIterator;
  i1, i2 : IIntResult;
begin
  if it.HasNext and Supports(Eval(it.Next), IIntResult, i1) and
     it.HasNext and Supports(Eval(it.Next), IIntResult, i2) then
    Result := TIntResult.Create(i1.GetValue div i2.GetValue)
  else
    raise EFunctionException.Create(GetName + ' requires 2 integer arguments');
end;

procedure AddFuncInternal(f : TPredefinedFunc);
begin
  SetLength(BuiltinDefinitions, Length(BuiltinDefinitions) + 1);
  BuiltinDefinitions[High(BuiltinDefinitions)].name := f.GetName;
  BuiltinDefinitions[High(BuiltinDefinitions)].value := f;
end;

initialization
  FalseRes := TBoolResult.Create(False);
  TrueRes := TBoolResult.Create(True);
  SetLength(BuiltinDefinitions, 2);
  BuiltinDefinitions[0].name := 'false';
  BuiltinDefinitions[0].value := FalseRes;
  BuiltinDefinitions[1].name := 'true';
  BuiltinDefinitions[1].value := TrueRes;

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

  AddFuncInternal(TEqualFunc.Create('='));
  AddFuncInternal(TInFunc.Create('in'));
  AddFuncInternal(TBetweenFunc.Create('between'));
  AddFuncInternal(TGreaterOrEqualFunc.Create('>='));
  AddFuncInternal(TLessOrEqualFunc.Create('<='));

  AddFuncInternal(TIfFunc.Create('if'));
  AddFuncInternal(TAndFunc.Create('and'));
  AddFuncInternal(TOrFunc.Create('or'));
  AddFuncInternal(TNotFunc.Create('not'));

  AddFuncInternal(TPlusFunc.Create('+'));
  AddFuncInternal(TMinusFunc.Create('-'));
  AddFuncInternal(TMultiplyFunc.Create('*'));
  AddFuncInternal(TDivideFunc.Create('/'));
  AddFuncInternal(TModuloFunc.Create('%'));
end.
