unit BuiltinDefs;

interface

uses SysUtils, Lists, ResultDecl;

type
  TPredefinedFunc = class(TInterfacedObject, IFuncResult, IResult)
  private
    FName : String;
  protected
    function Eval(const r : IData) : IResult;
  public
    function ToString : String;
    function GetName : String;
    function Apply(const arguments : ILinkedList) : IResult; virtual; abstract;
    constructor Create(const AName : String);
  end;

implementation

uses Eval;

var
  FalseRes : IBoolResult;
  TrueRes : IBoolResult;

{ TPredefinedFunc }

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

constructor TPredefinedFunc.Create(const AName : String);
begin
  inherited Create;
  FName := AName;
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

procedure AddFuncInternal(func : IFuncResult);
begin
  Evaluator.AddDefinition(TDefinition.Create(func.GetName, func));
end;

initialization
  Evaluator.PushFrame;
  FalseRes := TBoolResult.Create(False);
  TrueRes := TBoolResult.Create(True);
  Evaluator.AddDefinition(TDefinition.Create('false', FalseRes));
  Evaluator.AddDefinition(TDefinition.Create('true', TrueRes));

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
finalization
  Evaluator.PopFrame;
end.
