unit ResultDecl;

interface

Uses SysUtils, Lists;

type
  EFunctionException = class(Exception);
  EEvaluationException = class(Exception);
  IResult = interface(IData)
    ['{A040AE41-C5E5-4CCB-8C54-31822220DCBB}']
    function ToString : String;
  end;
  IComparable = interface(IResult)
    ['{7F15F761-2A2C-4325-B6EF-083A17445369}']
    function CompareTo(other : IResult) : Integer;
  end;
  IStringResult = interface(IResult)
    ['{77A81FEE-2853-48F7-846A-8CA4478F7CFA}']
    function GetValue : String;
  end;
  ITimeResult = interface(IResult)
    ['{615A7D84-2514-4C2E-BCFA-71B31944F074}']
    function GetValue : TDateTime;
  end;
  IIntResult = interface(IResult)
    ['{02639282-AEDB-43CD-B03B-9FEDE7EEE878}']
    function GetValue : Integer;
  end;
  IBoolResult = interface(IResult)
    ['{C85A4B12-B56F-43FB-9E46-6D78A46C107B}']
    function GetValue : Boolean;
  end;
  IListResult = interface(IResult)
    ['{7B90DFA0-16C7-4244-8014-9E94F29BB76A}']
    function GetValue : ILinkedList;
  end;
  IFuncResult = interface(IResult)
    ['{0804CB08-0CDA-4032-90CA-783D532F4857}']
    function GetName : String;
    function Apply(const arguments : ILinkedList) : IResult;
  end;
  // IStringResult could be used for string literals (later)
  // so we make dedicated result type for names
  INameResult = IStringResult;

  TStringResult = class(TInterfacedObject, IStringResult, IComparable, IResult)
  private
    FValue : String;
  public
    function GetValue : String;
    function ToString : String;
    function CompareTo(other : IResult) : Integer;
    constructor Create(value : String);
  end;
  TTimeResult = class(TInterfacedObject, ITimeResult, IComparable, IResult)
  private
    FValue : TDateTime;
  public
    function GetValue : TDateTime;
    function ToString : String;
    function CompareTo(other : IResult) : Integer;
    constructor Create(value : TDateTime);
  end;
  TIntResult = class(TInterfacedObject, IIntResult, IComparable, IResult)
  private
    FValue : Integer;
  public
    function GetValue : Integer;
    function ToString : String;
    function CompareTo(other : IResult) : Integer;
    constructor Create(value : Integer);
  end;
  TBoolResult = class(TInterfacedObject, IBoolResult, IComparable, IResult)
  private
    FValue : Boolean;
  public
    function GetValue : Boolean;
    function ToString : String;
    function CompareTo(other : IResult) : Integer;
    constructor Create(value : Boolean);
  end;
  TListResult = class(TInterfacedObject, IListResult, IResult)
  private
    FValue : ILinkedList;
  public
    function GetValue : ILinkedList;
    function ToString : String;
    constructor Create(value : ILinkedList);
  end;
  TNameResult = TStringResult;

implementation

uses Math;

{ TStringResult }

function TStringResult.GetValue : String;
begin
  Result := FValue;
end;

function TStringResult.ToString : String;
begin
  Result := FValue;
end;

function TStringResult.CompareTo(other : IResult) : Integer;
var
  sr : IStringResult;
  s : String;
begin
  if Supports(other, IStringResult, sr) then begin
    s := sr.GetValue;
    if FValue > s then Result := 1
    else if FValue < s then Result := -1
    else Result := 0;
  end else
    raise EEvaluationException(FValue + ' and ' + sr.ToString + ' are not comparable');
end;

constructor TStringResult.Create(value : String);
begin
  FValue := value;
end;

{ TTimeResult }

function TTimeResult.GetValue : TDateTime;
begin
  Result := FValue;
end;

function TTimeResult.ToString : String;
begin
  if Trunc(FValue) = 0 then
    Result := TimeToStr(FValue)
  else
    Result := DateTimeToStr(FValue);
end;

function TTimeResult.CompareTo(other : IResult) : Integer;
var o : ITimeResult;
begin
  if Supports(other, ITimeResult, o) then
    Result := sign(FValue - o.GetValue)
  else
    raise EEvaluationException(ToString + ' and ' + o.ToString + ' are not comparable');
end;

constructor TTimeResult.Create(value : TDateTime);
begin
  FValue := value;
end;

{ TIntResult }

function TIntResult.GetValue : Integer;
begin
  Result := FValue;
end;

function TIntResult.ToString : String;
begin
  Result := IntToStr(FValue);
end;

function TIntResult.CompareTo(other : IResult) : Integer;
var o : IIntResult;
begin
  if Supports(other, IIntResult, o) then
    Result := sign(FValue - o.GetValue)
  else
    raise EEvaluationException(ToString + ' and ' + o.ToString + ' are not comparable');
end;

constructor TIntResult.Create(value : Integer);
begin
  FValue := value;
end;

{ TBoolResult }

function TBoolResult.GetValue : Boolean;
begin
  Result := FValue;
end;

function TBoolResult.ToString : String;
begin
  Result := BoolToStr(FValue, True);
end;

function TBoolResult.CompareTo(other : IResult) : Integer;
var o : IBoolResult;
begin
  if Supports(other, IBoolResult, o) then begin
    Result := sign(ord(FValue) - ord(o.GetValue))
  end else
    raise EEvaluationException(ToString + ' and ' + o.ToString + ' are not comparable');
end;

constructor TBoolResult.Create(value : Boolean);
begin
  FValue := value;
end;

{ TListResult }

function TListResult.GetValue : ILinkedList;
begin
  Result := FValue;
end;

function TListResult.ToString : String;
var it : IListIterator;
begin
  if FValue = nil then Result := 'nil'
  else begin
    it := FValue.Iterator;
    Result := '(';
    while it.HasNext do
      Result := Result + IResult(it.Next).ToString + ' ';
    if Length(Result) > 1 then
      Result[Length(Result)] := ')';
  end;
end;

constructor TListResult.Create(value : ILinkedList);
begin
  FValue := value;
end;

end.
