unit Eval;

interface

uses SysUtils, ResultDecl, Lists;

type
  IDefinition = interface(IData)
    function GetName : String;
    function GetValue : IResult;
  end;

  TEvaluator = class
  private
    FFrames : ILinkedList;
    function Lookup(name : INameResult) : IResult;
  public
    procedure PushFrame;
    procedure PopFrame;
    procedure AddDefinition(def : IDefinition);
    function Evaluate(list : ILinkedList) : IResult; overload;
    function Evaluate(item : IResult) : IResult; overload;
    constructor Create;
  end;

  TDefinition = class(TInterfacedObject, IDefinition)
  private
    FName : String;
    FValue : IResult;
  public
    function GetName : String;
    function GetValue : IResult;
    constructor Create(AName : String; AValue : IResult);
  end;

var
  Evaluator : TEvaluator;

implementation

{ TEvaluator }

constructor TEvaluator.Create;
begin
  inherited;
  FFrames := CreateList;
end;

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
var
  itf, itd : IListIterator;
  def : IDefinition;
begin
  itf := FFrames.Iterator;
  while itf.HasNext do begin
    itd := ILinkedList(itf.Next).Iterator;
    while itd.HasNext do begin
      def := IDefinition(itd.Next);
      if def.GetName = name.GetValue then begin
        Result := def.GetValue;
        Exit;
      end;
    end;
  end;
  raise EFunctionException.Create('Undefined name: ' + name.GetValue);
end;

procedure TEvaluator.PushFrame;
begin
  FFrames.AddFirst(CreateList);
end;

procedure TEvaluator.PopFrame;
begin
  FFrames.Iterator.Remove;
end;

procedure TEvaluator.AddDefinition(def : IDefinition);
begin
  ILinkedList(FFrames.Head).AddFirst(def);
end;

{ TDefinition }

constructor TDefinition.Create(AName : String; AValue : IResult);
begin
  FName := AName;
  FValue := AValue;
end;

function TDefinition.GetName : String;
begin
  Result := FName;
end;

function TDefinition.GetValue : IResult;
begin
  Result := FValue;
end;

initialization
  Evaluator := TEvaluator.Create;
finalization
  Evaluator.Free;
  Evaluator := nil;
end.
