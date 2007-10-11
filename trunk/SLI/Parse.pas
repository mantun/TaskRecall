unit Parse;

interface

Uses SysUtils, Lists, ResultDecl;

Type
  EParseException = class(Exception);
  IToken = IStringResult;
  TToken = TStringResult;

  TParser = class
  private
    FTokens : ILinkedList;
    FPos : IListIterator;
    FToken : IToken;
    function GetNext : IToken;
    function Tokenize(const s : String) : ILinkedList;
    function GetSimpleResult : IResult;
    function GetItem : IResult;
    function GetList : ILinkedList;
  public
    function Parse(const s : String) : ILinkedList;
  end;

var
  Parser : TParser;

implementation

{ TParser }

function TParser.GetNext : IToken;
begin
  if FPos.HasNext then begin
    FToken := FPos.Next as IToken;
    Result := FToken;
  end else
    raise EParseException.Create('Unexpected end of stream');
end;

function TParser.GetSimpleResult : IResult;
var
  t : String;
  k : Integer;
begin
  t := FToken.GetValue;
  if t = ')' then
    raise EParseException.Create('Operand expected')
  else if not (t[1] in ['0'..'9', '+', '-']) or (t = '+') or (t = '-') then
    Result := TStringResult.Create(t)
  else begin
    if pos(DateSeparator, t) > 0 then begin
      k := Pos(ListSeparator, t);
      if k > 0 then t[k] := ' ';
      Result := TTimeResult.Create(StrToDateTime(t))
    end else if pos(TimeSeparator, t) > 0 then
      Result := TTimeResult.Create(StrToTime(t))
    else
      Result := TIntResult.Create(StrToInt(t))
  end;
end;

function TParser.GetItem : IResult;
begin
  if FToken.GetValue <> '(' then
    Result := GetSimpleResult
  else
    Result := TListResult.Create(GetList);
end;

function TParser.GetList : ILinkedList;
begin
  Result := CreateList;
  GetNext;
  while FToken.GetValue <> ')' do begin
    Result.AddLast(GetItem);
    if FPos.HasNext then GetNext
                    else Break;
  end;
end;

function TParser.tokenize(const s : String) : ILinkedList;
var
  i : Integer;
  t : String;
begin
  Result := CreateList;
  i := 1;
  while i <= Length(s) do begin
    while (i <= Length(s)) and (s[i] in [' ', #9, #13, #10]) do inc(i);
    if i > Length(s) then break;
    if (i <= Length(s)) and (s[i] in ['(', ')']) then begin
      t := s[i];
      inc(i);
    end else begin
      t := '';
      while (i <= Length(s)) and not (s[i] in [' ', #9, #13, #10, '(', ')']) do begin
        t := t + s[i];
        inc(i);
      end;
    end;
    Result.AddLast(IStringResult(TToken.Create(t)));
  end;
end;

function TParser.Parse(const s : String) : ILinkedList;
begin
  FTokens := Tokenize(s);
  FPos := FTokens.Iterator;
  Result := GetList;
  FPos := nil;
  FTokens := nil;
end;

initialization
  Parser := TParser.Create;

finalization
  Parser.Free;
end.
