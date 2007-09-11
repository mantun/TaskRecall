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
    function ToString : String; virtual;
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
  Result := Evaluator.Evaluate(r as IResult);
end;

constructor TPredefinedFunc.Create(const AName : String);
begin
  inherited Create;
  FName := AName;
end;

{ TUserDefinedFunc }

type
  TUserDefinedFunc = class(TPredefinedFunc)
  private
    FFormalArgs : ILinkedList;
    FBody : ILinkedList;
  public
    function ToString : String; override;
    function Apply(const args : ILinkedList) : IResult; override;
    constructor Create(const AFormalArgs : ILinkedList; const ABody : ILinkedList);
  end;

constructor TUserDefinedFunc.Create(const AFormalArgs : ILinkedList; const ABody : ILinkedList);
begin
  inherited Create(IntToHex(Cardinal(Self), 8));
  FFormalArgs := AFormalArgs;
  FBody := ABody;
end;

function TUserDefinedFunc.ToString : String;
begin
  Result := 'Defined function ' + FName;
end;

function TUserDefinedFunc.Apply(const args : ILinkedList) : IResult;
var itfa, itaa : IListIterator;
begin
  Evaluator.PushFrame;
  try
    // bind arguments
    itfa := FFormalArgs.Iterator;
    itaa := args.Iterator;
    while itfa.HasNext and itaa.HasNext do
      Evaluator.AddDefinition(TDefinition.Create(
              (itfa.Next as INameResult).GetValue, Eval(itaa.Next)));
    if itfa.HasNext then
      raise EFunctionException.Create(GetName + ' not enough actual arguments');
    if itaa.HasNext then
      raise EFunctionException.Create(GetName + ' too many actual arguments');
    // eval
    Result := Evaluator.Evaluate(FBody);
  finally
    Evaluator.PopFrame;
  end;
end;

{ TDefineFunc }

type
  TDefineFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;

function TDefineFunc.Apply(const args : ILinkedList) : IResult;
var
  it : IListIterator;
  n : INameResult;
begin
  it := args.Iterator;
  if it.HasNext and Supports(it.Next, INameResult, n) and it.HasNext then begin
    Result := Eval(it.Next);
    Evaluator.AddDefinition(TDefinition.Create(n.GetValue, Result));
  end else
    raise EFunctionException.Create(GetName + ' requires a name argument and a value argument');
end;

{ TLambdaFunc }

type
  TLambdaFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;

function TLambdaFunc.Apply(const args : ILinkedList) : IResult;
var
  it, itfa : IListIterator;
  fa : IListResult;
begin
  it := args.Iterator;
  if it.HasNext and Supports(it.Next, IListResult, fa) and it.HasNext then begin
    itfa := fa.GetValue.Iterator;
    while itfa.HasNext do
      if not Supports(itfa.Next, INameResult) then
        raise EFunctionException.Create(GetName + ': formal arguments must be list of names');
    Result := TUserDefinedFunc.Create(fa.GetValue, args.Tail);
  end else
    raise EFunctionException.Create(GetName + ' requires formal arguments list and body');
end;

{ Lists }

type
  TListFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TListFunc.Apply(const args : ILinkedList) : IResult;
begin
  Result := TListResult.Create(args);
end;

type
  THeadFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function THeadFunc.Apply(const args : ILinkedList) : IResult;
var list : IListResult;
begin
  if not args.IsEmpty and Supports(Eval(args.Head), IListResult, list)
      and not list.GetValue.IsEmpty then
    Result := list.GetValue.Head as IResult
  else
    raise EFunctionException.Create(GetName + ' requires a non-empty list');
end;

type
  TTailFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TTailFunc.Apply(const args : ILinkedList) : IResult;
var list : IListResult;
begin
  if not args.IsEmpty and Supports(Eval(args.Head), IListResult, list)
      and not list.GetValue.IsEmpty then
    Result := TListResult.Create(list.GetValue.Tail)
  else
    raise EFunctionException.Create(GetName + ' requires a non-empty list');
end;

type
  TEmptyFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TEmptyFunc.Apply(const args : ILinkedList) : IResult;
var list : IListResult;
begin
  if not args.IsEmpty and Supports(Eval(args.Head), IListResult, list) then
    if list.GetValue.IsEmpty then Result := TrueRes
                             else Result := FalseRes
  else
    raise EFunctionException.Create(GetName + ' requires a list');
end;

type
  TConsFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TConsFunc.Apply(const args : ILinkedList) : IResult;
var
  it : IListIterator;
  head, tail : IResult;
  ListTail : IListResult;
  NewList : ILinkedList;
begin
  it := args.Iterator;
  if it.HasNext then begin
    head := Eval(it.Next) as IResult;
    if it.HasNext then begin
      tail := Eval(it.Next) as IResult;
      if Supports(tail, IListResult, ListTail) then begin
        ListTail.GetValue.AddFirst(head);
        Result := ListTail;
      end else begin
        NewList := CreateList;
        NewList.AddFirst(tail);
        NewList.AddFirst(head);
        Result := TListResult.Create(NewList);
      end;
      Exit;
    end;
  end;
  raise EFunctionException.Create(GetName + ' requires 2 arguments');
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
  if it.HasNext and Supports(Eval(it.Next), IComparable, o) then
    while it.HasNext do begin
      if o.CompareTo(Eval(it.Next)) <> 0 then begin
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
  if it.HasNext and Supports(Eval(it.Next), IComparable, o) and it.HasNext and
     (o.CompareTo(Eval(it.Next)) >= 0) then
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
  if it.HasNext and Supports(Eval(it.Next), IComparable, o) and it.HasNext and
     (o.CompareTo(Eval(it.Next)) <= 0) then
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
  if it.HasNext and Supports(Eval(it.Next), IComparable, o) then
    while it.HasNext do begin
      if o.CompareTo(Eval(it.Next)) = 0 then begin
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
  if it.HasNext and Supports(Eval(it.Next), IComparable, o) and
     it.HasNext and (o.CompareTo(Eval(it.Next) as IResult) >= 0) and
     it.HasNext and (o.CompareTo(Eval(it.Next) as IResult) <= 0) then
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
  r1, r2 : IData;
  it : IListIterator;
begin
  it := args.Iterator;
  if it.HasNext and Supports(Eval(it.Next), IBoolResult, c) then begin
    if it.HasNext then r1 := it.Next
    else Raise EFunctionException.Create('Missing then caluse in ' + GetName);
    if it.HasNext then r2 := it.Next
    else Raise EFunctionException.Create('Missing else caluse in ' + GetName);
    if c.GetValue then Result := Eval(r1)
                  else Result := Eval(r2);
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
  it := args.Iterator;
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
  it := args.Iterator;
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
  it := args.Iterator;
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
  it := args.Iterator;
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
  prod := 1;
  it := args.Iterator;
  while it.HasNext do begin
    if not Supports(Eval(it.Next), IIntResult, i) then
      raise EFunctionException.Create(GetName + ' requires integer arguments');
    prod := prod * i.GetValue;
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
  it := args.Iterator;
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
  it := args.Iterator;
  if it.HasNext and Supports(Eval(it.Next), IIntResult, i1) and
     it.HasNext and Supports(Eval(it.Next), IIntResult, i2) then
    Result := TIntResult.Create(i1.GetValue mod i2.GetValue)
  else
    raise EFunctionException.Create(GetName + ' requires 2 integer arguments');
end;

type
  TAbsFunc = class(TPredefinedFunc)
    function Apply(const args : ILinkedList) : IResult; override;
  end;
function TAbsFunc.Apply(const args : ILinkedList) : IResult;
var
  it : IListIterator;
  i : IIntResult;
begin
  it := args.Iterator;
  if it.HasNext and Supports(Eval(it.Next), IIntResult, i) then
    Result := TIntResult.Create(Abs(i.GetValue))
  else
    raise EFunctionException.Create(GetName + ' requires an integer argument');
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

  AddFuncInternal(TDefineFunc.Create('define'));
  AddFuncInternal(TLambdaFunc.Create('lambda'));

  AddFuncInternal(TListFunc.Create('list'));
  AddFuncInternal(THeadFunc.Create('head'));
  AddFuncInternal(TTailFunc.Create('tail'));
  AddFuncInternal(TEmptyFunc.Create('empty?'));
  AddFuncInternal(TConsFunc.Create('cons'));

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
  AddFuncInternal(TAbsFunc.Create('abs'));
finalization
  Evaluator.PopFrame;
end.
