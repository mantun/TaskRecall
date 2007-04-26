unit Parse;

interface

Uses SysUtils;

Type
  TToken = String[10];
  TTokenArray = array of TToken;

  EParseException = class(Exception);

  TResType = (rtInvalid, rtFunc, rtTime, rtInt, rtBool);
  TResult = record
  Case ResType : TResType Of
    rtFunc : (NameValue : String[7]);
    rtTime : (TimeValue : TDateTime);
    rtInt  : (IntValue  : Integer);
    rtBool : (BoolValue : Boolean);
  end;
  TResultArray = array of TResult;

  TParser = class
  private
    FTokens : TTokenArray;
    FPos : Integer;
    function getToken : TToken;
    function getNext : TToken;
    function tokenize(const s : String) : TTokenArray;
    function getSimpleResult : TResult;
    function getList : TResultArray;
    function eval : TResult;
  public
    function Evaluate(const s : String) : TResult;
  end;

var
  Parser : TParser;

implementation

uses Func;

function TParser.getToken : TToken;
begin
  if FPos < Length(FTokens) then begin
    result := FTokens[FPos];
  end else begin
    raise EParseException.Create('Unexpected end of stream');
  end;
end;

function TParser.getNext : TToken;
begin
  result := getToken;
  inc(FPos);
end;

function TParser.getSimpleResult : TResult;
var t : TToken;
begin
  t := getNext;
  if t = ')' then
    raise EParseException.Create('Operand expected')
  else if not (t[1] in ['0'..'9', '+', '-']) or (t = '+') or (t = '-') then begin
    Result.ResType := rtFunc;
    Result.NameValue := t;
  end else begin
    if pos(DateSeparator, t) > 0 then begin
      Result.ResType := rtTime;
      Result.TimeValue := StrToDateTime(t);
    end else if pos(TimeSeparator, t) > 0 then begin
      Result.ResType := rtTime;
      Result.TimeValue := StrToTime(t);
    end else begin
      Result.ResType := rtInt;
      Result.IntValue := StrToInt(t);
    end;
  end;
end;

function TParser.getList : TResultArray;
var t : TToken;
begin
  t := getToken;
  if t <> '(' then begin
    SetLength(Result, 1);
    Result[0] := getSimpleResult;
  end else begin
    getNext;
    repeat
      SetLength(Result, Length(Result) + 1);
      if getToken <> '(' then begin
        Result[High(Result)] := getSimpleResult;
      end else begin
        Result[High(Result)] := eval;
      end;
    until getToken = ')';
    getNext;
  end;
end;

function TParser.eval : TResult;
var list : TResultArray;
begin
  list := getList;
  if list[0].ResType = rtFunc then begin
    Result := perform(list[0].NameValue, copy(list, 1, Length(list) - 1));
  end else
    Result := list[0];
end;

function TParser.tokenize(const s : String) : TTokenArray;
var
  i : Integer;
  t : TToken;
begin
  SetLength(Result, 0);
  i := 1;
  while i <= Length(s) do begin
    while (i <= Length(s)) and (s[i] = ' ') do inc(i);
    if (i <= Length(s)) and (s[i] in ['(', ')']) then begin
      t := s[i];
      inc(i);
    end else begin
      t := '';
      while (i <= Length(s)) and not (s[i] in [' ', '(', ')']) do begin
        t := t + s[i];
        inc(i);
      end;
    end;
    SetLength(Result, Length(Result) + 1);
    Result[High(Result)] := t;
  end;
end;

function TParser.Evaluate(const s : String) : TResult;
begin
  FTokens := tokenize(s);
  FPos := 0;
  Result := eval;
end;

initialization
  Parser := TParser.Create;

finalization
  Parser.Free;
end.
