unit Lists;

interface

uses SysUtils;

type
  EListError = class(Exception);
  IData = interface end;
  IListIterator = interface
    function HasNext : Boolean;
    function Next : IData;
  end;

  ILinkedList = interface
    procedure AddFirst(data : IData);
    procedure AddLast(data : IData);

    function Head : IData;
    function Tail : ILinkedList;
    function IsEmpty : Boolean;
    function Iterator : IListIterator;
  end;

function CreateList : ILinkedList;

implementation

type
  PNode = ^TNode;
  PPNode = ^PNode;
  TNode = record
    Next : PNode;
    Data : IData;
  end;

  TLinkedList = class(TInterfacedObject, ILinkedList)
  private
    FOwner : ILinkedList;
    FHead : PNode;
    FLast : PNode;
    constructor CreateFromTail(AOwner : TLinkedList);
  public
    procedure AddFirst(data : IData);
    procedure AddLast(data : IData);
    function Head : IData;
    function Tail : ILinkedList;
    function IsEmpty : Boolean;
    function Iterator : IListIterator;

    destructor Destroy; override;
  end;

  TListIterator = class(TInterfacedObject, IListIterator)
  private
    FOwner : ILinkedList;
    FCurrent : PNode;
    FPCurrent : PPNode;
    FFetched : Boolean;
    constructor Create(AOwner : TLinkedList);
  public
    function HasNext : Boolean;
    function Next : IData;
    procedure Remove;
  end;

{ TLinkedList }

constructor TLinkedList.CreateFromTail(AOwner : TLinkedList);
begin
  inherited Create;
  FOwner := AOwner;
  if AOwner.FHead <> nil then
    FHead := AOwner.FHead^.Next;
  if FHead <> nil then
    FLast := AOwner.FLast;
end;

destructor TLinkedList.Destroy;
var n, p : PNode;
begin
  if FOwner <> nil then begin
    n := FHead;
    while n <> nil do begin
      p := n^.Next;
      Dispose(n);
      n := p;
    end;
  end;
end;

procedure TLinkedList.AddFirst(data : IData);
var n : PNode;
begin
  New(n);
  n^.Data := data;
  n^.Next := FHead;
  FHead := n;
end;

procedure TLinkedList.AddLast(data : IData);
var n : PNode;
begin
  New(n);
  n^.Data := data;
  n^.Next := nil;
  if FLast = nil then begin
    FHead := n;
    FLast := n;
  end else begin
    FLast^.Next := n;
    FLast := n;
  end;
end;

function TLinkedList.Head : IData;
begin
  if FHead <> nil then
    Result := FHead^.Data
  else
    Result := nil;
end;

function TLinkedList.Tail : ILinkedList;
begin
  Result := TLinkedList.CreateFromTail(self)
end;

function TLinkedList.IsEmpty : Boolean;
begin
  Result := FHead = nil;
end;

function TLinkedList.Iterator : IListIterator;
begin
  Result := TListIterator.Create(self);
end;

{ TListIterator }

constructor TListIterator.Create(AOwner : TLinkedList);
begin
  FOwner := AOwner;
  FCurrent := AOwner.FHead;
  FPCurrent := @AOwner.FHead;
  FFetched := True;
end;

function TListIterator.HasNext : Boolean;
begin
  Result := (FCurrent <> nil) and (FFetched or (FCurrent^.Next <> nil));
end;

function TListIterator.Next : IData;
const ErrStr = 'Iterator cannot move past the last element. Use HasNext to check.';
begin
  if FFetched then begin
    if FCurrent = nil then raise EListError.Create(ErrStr);
    FFetched := False
  end else begin
    if not HasNext then raise EListError.Create(ErrStr);
    FPCurrent := @(FCurrent^.Next);
    FCurrent := FCurrent^.Next;
  end;
  Result := FCurrent^.Data;
end;

procedure TListIterator.Remove;
begin
  if FCurrent = nil then
    raise EListError.Create('Attempt to remove past the end of the list.');
  FPCurrent^ := FCurrent^.Next;
  Dispose(FCurrent);
  FCurrent := FPCurrent^;
  FFetched := True;
end;

{ Factory }

function CreateList : ILinkedList;
begin
  Result := TLinkedList.Create;
end;

end.
