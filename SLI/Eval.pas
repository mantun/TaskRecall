unit Eval;

interface

uses SysUtils, ResultDecl, Lists;

type
  TEvaluator = class
  private
    function Lookup(name : INameResult) : IResult;
  public
    function Evaluate(list : ILinkedList) : IResult; overload;
    function Evaluate(item : IResult) : IResult; overload;
  end;

var
  Evaluator : TEvaluator;

implementation

uses BuiltinDefs;

{ TEvaluator }

function TEvaluator.Evaluate(list : ILinkedList) : IResult;
var it : IListIterator;
begin
  it := list.Iterator;
  while it.HasNext do
    Result := Evaluate(IResult(it.Next));
end;

function TEvaluator.Evaluate(item : IResult) : IResult;
var
  listItem : IListResult;
  list : ILinkedList;
  h : IResult;
  name : INameResult;
  func : IFuncResult;
begin
  if Supports(item, IListResult, listItem) then begin
    list := listItem.GetValue;
    h := Evaluate(IResult(list.Head));
    if Supports(h, IFuncResult, func) then
      Result := func.Apply(list.Tail)
    else
      Result := item; // or raise exception? or evaluate the list?
  end else if Supports(item, INameResult, name) then
    Result := Lookup(name)
  else
    Result := item;
end;

function TEvaluator.Lookup(name : INameResult) : IResult;
var i : Integer;
begin
  for i := Low(BuiltinDefinitions) to High(BuiltinDefinitions) do begin
    if BuiltinDefinitions[i].name = name.GetValue then begin
      Result := BuiltinDefinitions[i].value;
      Exit;
    end;
  end;
  raise EFunctionException.Create('Undefined name: ' + name.GetValue);
end;

initialization
  Evaluator := TEvaluator.Create;
finalization
  Evaluator.Free;
  Evaluator := nil;
end.
