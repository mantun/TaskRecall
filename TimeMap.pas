unit TimeMap;

interface

uses SysUtils, Graphics, Types, Classes;

type
  TIntTime = Integer;
  TTickKind = (tkFree, tk15min, tk30min, tk1hour, tk1day, tk1week, tk1month, tk1year, tk5years, tk10years);
  TTick = class
    itPosition : TIntTime;
    Kind : TTickKind;
    function NextTick(kind : TTickKind) : TTick;
    constructor CreateNearest(base : TIntTime; stepKind : TTickKind);
    constructor Create(pos : TIntTime);
    class function GetKind(it : TIntTime) : TTickKind;
    class function ditGetApproxSize(kind : TTickKind) : TIntTime;
  end;

  TTimeMapping = class
  private
    FScale : Double;
    FitLeftTime : TIntTime;
    FpxMinTickWidth : Integer;
    procedure SetScale(value : Double);
    procedure SetLeftTime(value : TIntTime);
  public
    property Scale : Double read FScale write SetScale;
    property itBase : TIntTime read FitLeftTime write SetLeftTime;
    property pxMinTickWidth : Integer read FpxMinTickWidth write FpxMinTickWidth;
    function PXFromDT(dt : TDateTime) : Integer;
    function ITFromPX(px : Integer) : TIntTime;
    function DTFromPX(px : Integer) : TDateTime;
    function PXFromIT(it : TIntTime) : Integer;
    function DPXFromDIT(dit : TIntTime) : Integer;
    function DITFromDPX(dpx : TIntTime) : Integer;

    function GetFirstTick(out stepKind : TTickKind) : TTick;
    constructor Create;
  end;

  TTimeTrack = class;
  TTimeObject = class;
  TTimeline = class
  private
    FTimeTracks : TList;
    FMap : TTimeMapping;
    FRect : TRect;
    FCanvas : TCanvas;
    function GetTickLength(kind : TTickKind) : Integer;
    procedure DrawMissingText(kind : TTickKind; time : TIntTime; basex : Integer);
    procedure DrawTicks;
    procedure DrawTick(Tick : TTick);
  public
    property Map : TTimeMapping read FMap;
    property Rect : TRect read FRect write FRect;
    property Canvas : TCanvas read FCanvas;
    procedure Draw;
    procedure AddTimeTrack(track : TTimeTrack);
    function GetObjectAt(x, y : Integer) : TTimeObject;
    constructor Create(ACanvas : TCanvas; ARect : TRect);
    destructor Destroy; override;
  end;

  ITimeController = interface
    procedure SetTime(it : TIntTime);
    function GetTime : TIntTime;
    property Time : TIntTime read GetTime write SetTime;
  end;

  TTimeController = class(TInterfacedObject, ITimeController)
  protected
    procedure SetTime(it : TIntTime); virtual; abstract;
    function GetTime : TIntTime; virtual; abstract;
  public
    property Time : TIntTime read GetTime write SetTime;
  end;

  TTimeObject = class(TTimeController)
  protected
    FTimeline : TTimeline;
    function GetText : String; virtual;
    function GetFullText : String; virtual;
    procedure Draw(top : Integer); virtual;
    function Intersects(o : TTimeObject) : Boolean; virtual;
    function Contains(x, y : Integer) : Boolean; virtual;
    function GetColor : TColor; virtual;
  public
    property Text : String read GetText;
    property FullText : String read GetFullText; 
  end;

  TTimeSpanObject = class(TTimeObject)
  protected
    procedure SetTime(it : TIntTime); override;
    function GetTime : TIntTime; override;
    function GetLeft : ITimeController; virtual; abstract;
    function GetRight : ITimeController; virtual; abstract;
    procedure Draw(top : Integer); override;
    function Intersects(o : TTimeObject) : Boolean; override;
    function Contains(x, y : Integer) : Boolean; override;
  public
    property Left : ITimeController read GetLeft;
    property Right : ITimeController read GetRight;
  end;

  TTimeTrack = class
  private
    FTimeObjects : TList;
    FObjectRows : array of Integer;
    FTimeline : TTimeline;
    FMaxRow : Integer;
    function GetTimeObject(index : Integer) : TTimeObject;
    function GetObjectCount : Integer;
    procedure RepositionObjects;
  public
    property TimeObjects[index : Integer] : TTimeObject read GetTimeObject; default;
    property Count : Integer read GetObjectCount;

    constructor Create;
    destructor Destroy; override;

    function GetRowCount : Integer;
    procedure AddTimeObject(o : TTimeObject);
    procedure DeleteTimeObject(o : TTimeObject);
    procedure Draw(top : Integer);
    function GetObjectAt(x, y : Integer) : TTimeObject;
  end;

function ITFromDT(dt : TDateTime) : TIntTime;
function DTFromIT(it : TIntTime) : TDateTime;

implementation

uses Math, TimeGraph;

function ITFromDT(dt : TDateTime) : TIntTime;
begin
  Result := Round(dt * 1440);
end;

function DTFromIT(it : TIntTime) : TDateTime;
begin
  Result := it / 1440;
end;

function TimeObjectCompare(Item1, Item2 : Pointer) : Integer;
var t1, t2 : TIntTime;
begin
  t1 := TTimeObject(Item1).Time;
  t2 := TTimeObject(Item2).Time;
  if t1 < t2 then
    Result := -1
  else if t1 > t2 then
    Result := 1
  else
    Result := 0;
end;

{ TTick }

function TTick.NextTick(kind : TTickKind) : TTick;
var
  d, m, y : Word;
  size : TIntTime;
begin
  Assert(GetKind(itPosition) <> tkFree, 'Gan''t get next tick of a free tick');
  case kind of
    tk15min,
    tk30min,
    tk1hour,
    tk1day : Result := TTick.Create(itPosition + ditGetApproxSize(kind));
    tk1week : begin
      size := ditGetApproxSize(tk1day);
      Result := TTick.CreateNearest(itPosition + size, kind);
    end;
    tk1month : begin
      DecodeDate(DTFromIT(itPosition), y, m, d);
        if m = 12 then begin
          m := 1;
          inc(y);
        end else
          inc(m);
      Result := TTick.Create(ITFromDT(EncodeDate(y, m, d)));
    end;
    tk1year : begin
      DecodeDate(DTFromIT(itPosition), y, m, d);
      inc(y);
      Result := TTick.Create(ITFromDT(EncodeDate(y, m, d)));
    end;
    tk5years : begin
      DecodeDate(DTFromIT(itPosition), y, m, d);
      inc(y, 5);
      Result := TTick.Create(ITFromDT(EncodeDate(y, m, d)));
    end;
    tk10years : begin
      DecodeDate(DTFromIT(itPosition), y, m, d);
      inc(y, 10);
      Result := TTick.Create(ITFromDT(EncodeDate(y, m, d)));
    end;
    else begin
      Assert(False);
      Result := nil;
    end;
  end;
end;

constructor TTick.CreateNearest(base : TIntTime; stepKind : TTickKind);
var
  size : TIntTime;
  d, m, y : Word;
begin
  case stepKind of
    tkFree : itPosition := base;
    tk15min,
    tk30min,
    tk1hour,
    tk1day : begin
      size := ditGetApproxSize(stepKind);
      itPosition := (base + size - 1) div size * size;
    end;
    tk1week : begin
      size := ditGetApproxSize(tk1day);
      itPosition := base div size * size + (9 - DayOfWeek(DTFromIT(base))) mod 7 * size; // as week
      DecodeDate(DTFromIT(base), y, m, d); // as month
      if (d <> 1) or (base mod size <> 0) then begin
        d := 1;
        if m = 12 then begin
          m := 1;
          inc(y);
        end else
          inc(m);
      end;
      itPosition := Min(itPosition, ITFromDT(EncodeDate(y, m, d)));
    end;
    tk1month : begin
      size := ditGetApproxSize(tk1day);
      DecodeDate(DTFromIT(base), y, m, d);
      if (d <> 1) or (base mod size <> 0) then begin
        d := 1;
        if m = 12 then begin
          m := 1;
          inc(y);
        end else
          inc(m);
      end;
      itPosition := ITFromDT(EncodeDate(y, m, d));
    end;
    tk1year : begin
      size := ditGetApproxSize(tk1day);
      DecodeDate(DTFromIT(base), y, m, d);
      if (d <> 1) or (m <> 1) or (base mod size <> 0) then begin
        d := 1;
        m := 1;
        inc(y);
      end;
      itPosition := ITFromDT(EncodeDate(y, m, d));
    end;
    tk5years : begin
      size := ditGetApproxSize(tk1day);
      DecodeDate(DTFromIT(base), y, m, d);
      if (d <> 1) or (m <> 1) or (y mod 5 <> 0) or (base mod size <> 0) then begin
        d := 1;
        m := 1;
        y := (y + 4) div 5 * 5;
      end;
      itPosition := ITFromDT(EncodeDate(y, m, d));
    end;
    tk10years : begin
      size := ditGetApproxSize(tk1day);
      DecodeDate(DTFromIT(base), y, m, d);
      if (d <> 1) or (m <> 1) or (y mod 10 <> 0) or (base mod size <> 0) then begin
        d := 1;
        m := 1;
        y := (y + 9) div 10 * 10;
      end;
      itPosition := ITFromDT(EncodeDate(y, m, d));
    end;
    else begin
      Assert(False);
      itPosition := base;
    end;
  end;
  Kind := GetKind(itPosition);
end;

constructor TTick.Create(pos : TIntTime);
begin
  itPosition := pos;
  Kind := GetKind(itPosition);
end;

class function TTick.GetKind(it : TIntTime) : TTickKind;
var
  d, m, y : Word;
  dt : TDateTime;
begin
  dt := DTFromIT(it);
  DecodeDate(dt, y, m, d);
  { todo: optimize this }
  if (y mod 10 = 0) and (m = 1) and (d = 1) and (it mod 1440 = 0) then
    Result := tk10years
  else if (y mod 5 = 0) and (m = 1) and (d = 1) and (it mod 1440 = 0) then
    Result := tk5years
  else if (m = 1) and (d = 1) and (it mod 1440 = 0) then
    Result := tk1year
  else if (d = 1) and (it mod 1440 = 0) then
    Result := tk1month
  else if (DayOfWeek(dt) = 2) and (it mod 1440 = 0) then
    Result := tk1week
  else if (it mod 1440 = 0) then
    Result := tk1day
  else if (it mod 60 = 0) then
    Result := tk1hour
  else if (it mod 30 = 0) then
    Result := tk30min
  else if (it mod 15 = 0) then
    Result := tk15min
  else
    Result := tkFree;
end;

class function TTick.ditGetApproxSize(kind : TTickKind) : TIntTime;
begin
  case kind of
    tkFree    : Result := 1;
    tk15min   : Result := 15;
    tk30min   : Result := 30;
    tk1hour   : Result := 60;
    tk1day    : Result := 24 * 60;
    tk1week   : Result := 7 * 24 * 60;
    tk1month  : Result := Round(365.25 / 12 * 24 * 60);
    tk1year   : Result := Round(365.25 * 24 * 60);
    tk5years  : Result := Round(5 * 365.25 * 24 * 60);
    tk10years : Result := Round(10 * 365.25 * 24 * 60);
    else begin
      Assert(False);
      Result := 1;
    end;
  end;
end;

{ TTimeMapping }

constructor TTimeMapping.Create;
begin
  FScale := 100;
  FitLeftTime := ITFromDT(Now - 2 / 24);
end;

function TTimeMapping.PXFromDT(dt : TDateTime) : Integer;
begin
  Result := PXFromIT(ITFromDT(dt));
end;

function TTimeMapping.ITFromPX(px : Integer) : TIntTime;
begin
  Result := FitLeftTime + Round(px * FScale);
end;

function TTimeMapping.DTFromPX(px : Integer) : TDateTime;
begin
  Result := DTFromIT(ITFromPX(px));
end;

function TTimeMapping.PXFromIT(it : TIntTime) : Integer;
begin
  Result := Round((it - FitLeftTime) / FScale);
end;

function TTimeMapping.DPXFromDIT(dit : TIntTime) : Integer;
begin
  Result := Round(dit / FScale);
end;

function TTimeMapping.DITFromDPX(dpx : Integer) : TIntTime;
begin
  Result := Round(dpx * FScale);
end;

procedure TTimeMapping.SetScale(value : Double);
begin
  FScale := Max(0.05, Min(500000, value));
end;

procedure TTimeMapping.SetLeftTime(value : TIntTime);
begin
  FitLeftTime := Max(ITFromDT(EncodeDate(1, 1, 1)), Min(ITFromDT(EncodeDate(4000, 1, 1)), value));
end;

function TTimeMapping.GetFirstTick(out stepKind : TTickKind) : TTick;
var kind : TTickKind;
begin
  kind := Low(TTickKind);
  repeat
    Inc(kind);
  until (kind = High(TTickKind)) or (DPXFromDIT(TTick.ditGetApproxSize(kind)) > FpxMinTickWidth);
  stepKind := kind;
  Result := TTick.CreateNearest(FitLeftTime, kind);
end;

{ TTimeline }

constructor TTimeline.Create(ACanvas : TCanvas; ARect : TRect);
begin
  FMap := TTimeMapping.Create;
  FCanvas := ACanvas;
  FRect := ARect;
  FTimeTracks := TList.Create;
end;

destructor TTimeline.Destroy;
begin
  FTimeTracks.Free;
  FMap.Free;
  inherited;
end;

procedure TTimeline.AddTimeTrack(track : TTimeTrack);
begin
  track.FTimeline := Self;
  FTimeTracks.Add(track);
end;

function TTimeline.GetTickLength(kind : TTickKind) : Integer;
begin
  case kind of
    tkFree : Result := FRect.Bottom - FRect.Top;
    tk15min : Result := FRect.Bottom - FRect.Top - 70;
    tk30min : Result := FRect.Bottom - FRect.Top - 60;
    tk1hour : Result := FRect.Bottom - FRect.Top - 50;
    tk1day,
    tk1week : Result := FRect.Bottom - FRect.Top - 35;
    tk1month : Result := FRect.Bottom - FRect.Top - 20;
    tk1year,
    tk5years,
    tk10years : Result := FRect.Bottom - FRect.Top - 5;
    else begin
      Assert(False);
      Result := FRect.Bottom - FRect.Top;
    end;
  end;
end;

procedure TTimeline.DrawMissingText(kind : TTickKind; time : TIntTime; basex : Integer);
var textx, texty, len : Integer;
begin
  len := GetTickLength(kind);
  textx := basex + 1;
  texty := FRect.Top + len - 10;
  case kind of
    tkFree : ;
    tk15min,
    tk30min : ;
    tk1hour : FCanvas.TextOut(textx, texty, FormatDateTime('hh:nn', DTFromIT(time)));
    tk1day,
    tk1week : FCanvas.TextOut(textx, texty, FormatDateTime('d (ddd)', DTFromIT(time)));
    tk1month : FCanvas.TextOut(textx, texty, FormatDateTime('mmm', DTFromIT(time)));
    tk1year,
    tk5years,
    tk10years : FCanvas.TextOut(textx, texty, FormatDateTime('yyyy', DTFromIT(time)));
    else Assert(False);
  end;
end;

procedure TTimeline.DrawTick(Tick : TTick);
var
  len, x, y, textx, texty : Integer;
  fadeCoeff : Double;
  cl : TColor;
begin
  case Tick.Kind of
    tkFree : FCanvas.Pen.Color := clFreeTick;
    tk15min,
    tk30min,
    tk1hour,
    tk1day,
    tk1week,
    tk1month,
    tk1year,
    tk5years,
    tk10years : begin
      fadeCoeff := Min(1, (FMap.DPXFromDIT(TTick.ditGetApproxSize(Tick.Kind)) - FMap.pxMinTickWidth) / 800);
      if fadeCoeff < 1 then
        fadeCoeff := 1 - Sqr(1 - fadeCoeff);
      cl := BlendColor(clBackground, clSolidTick, fadeCoeff);
      FCanvas.Pen.Color := cl;
    end;
    else Assert(False);
  end;
  len := GetTickLength(Tick.Kind);
  x := FRect.Left + FMap.PXFromIT(Tick.itPosition);
  y := FRect.Top;
  FCanvas.MoveTo(x, y);
  FCanvas.LineTo(x, y + len);
  FCanvas.Font.Color := FCanvas.Pen.Color;
  FCanvas.Brush.Color := clBackground;
  FCanvas.Brush.Style := bsSolid;
  textx := x + 1;
  texty := y + len - 10;
  case Tick.Kind of
    tkFree : ;
    tk15min,
    tk30min : ;
    tk1hour : FCanvas.TextOut(textx, texty, FormatDateTime('hh:nn', DTFromIT(Tick.itPosition)));
    tk1day,
    tk1week : FCanvas.TextOut(textx, texty, FormatDateTime('d (ddd)', DTFromIT(Tick.itPosition)));
    tk1month : begin
      len := GetTickLength(tk1day);
      FCanvas.TextOut(textx, y + len - 10, FormatDateTime('d (ddd)', DTFromIT(Tick.itPosition)));
      FCanvas.TextOut(textx, texty, FormatDateTime('mmm', DTFromIT(Tick.itPosition)));
    end;
    tk1year,
    tk5years,
    tk10years : FCanvas.TextOut(textx, texty, FormatDateTime('yyyy', DTFromIT(Tick.itPosition)));
    else Assert(False);
  end;
end;

procedure TTimeline.DrawTicks;
var
  t, tnew : TTick;
  stepKind, maxKind : TTickKind;
  startPos : TIntTime;
begin
  t := FMap.GetFirstTick(stepKind);
  startPos := t.itPosition;
  maxKind := tkFree;
  while FMap.PXFromIT(t.itPosition) < FRect.Right - FRect.Left do begin
    if maxKind < t.Kind then
       maxKind := t.Kind;
    DrawTick(t);
    tnew := t.NextTick(stepKind);
    t.Free;
    t := tnew;
  end;
  t.Free;
  t := TTick.Create(ITFromDT(Now));
  t.Kind := tkFree;
  DrawTick(t);
  t.Free;
  FCanvas.Font.Color := clSolidTick;
  FCanvas.Brush.Style := bsSolid;
  if maxKind < tk1hour then
    DrawMissingText(tk1hour, startPos, FRect.Left);
  if maxKind < tk1day then
    DrawMissingText(tk1day, startPos, FRect.Left);
  if maxKind < tk1month then
    DrawMissingText(tk1month, startPos, FRect.Left);
  if maxKind < tk1year then
    DrawMissingText(tk1year, startPos, FRect.Left);
end;

procedure TTimeline.Draw;
var
  i, top : Integer;
  cl : TColor;
begin
  DrawTicks;
  top := FRect.Top;
  cl := BlendColor(clBackground, clSolidTick, 0.1);
  for i := 0 to FTimeTracks.Count - 1 do begin
    TTimeTrack(FTimeTracks[i]).Draw(top);
    top := top + TTimeTrack(FTimeTracks[i]).GetRowCount * TimeRowHeight;
    if i < FTimeTracks.Count - 1 then begin
      FCanvas.Pen.Color := cl;
      FCanvas.MoveTo(FRect.Left, top - 1);
      FCanvas.LineTo(FRect.Right, top - 1);
    end;
  end;
end;

function TTimeline.GetObjectAt(x, y : Integer) : TTimeObject;
var i, trackTop, trackBottom : Integer;
begin
  trackTop := FRect.Top;
  for i := 0 to FTimeTracks.Count - 1 do begin
    trackBottom := trackTop + TTimeTrack(FTimeTracks[i]).GetRowCount * TimeRowHeight;
    if (y >= trackTop) and (y < trackBottom) then begin
      Result := TTimeTrack(FTimeTracks[i]).GetObjectAt(x, y - trackTop);
      Exit;
    end;
    trackTop := trackBottom;
  end;
  Result := nil;
end;

{ TTimeTrack }

constructor TTimeTrack.Create;
begin
  FTimeObjects := TList.Create;
end;

destructor TTimeTrack.Destroy;
begin
  FTimeObjects.Free;
  inherited;
end;

function TTimeTrack.GetRowCount : Integer;
begin
  Result := FMaxRow + 1;
end;

function TTimeTrack.GetObjectCount : Integer;
begin
  Result := FTimeObjects.Count;
end;

function TTimeTrack.GetTimeObject(index : Integer) : TTimeObject;
begin
  Result := TTimeObject(FTimeObjects[index]);
end;

procedure TTimeTrack.AddTimeObject(o : TTimeObject);
begin
  o.FTimeline := FTimeline;
  FTimeObjects.Add(o);
  FTimeObjects.Sort(TimeObjectCompare);
  RepositionObjects;
end;

procedure TTimeTrack.DeleteTimeObject(o : TTimeObject);
begin
  FTimeObjects.Remove(o);
  RepositionObjects;
end;

procedure TTimeTrack.RepositionObjects;
var
  i, j, row : Integer;
  ok : Boolean;
  obj : TTimeObject;
begin
  SetLength(FObjectRows, FTimeObjects.Count);
  FMaxRow := 0;
  for i := 0 to FTimeObjects.Count - 1 do begin
    obj := TTimeObject(FTimeObjects[i]);
    row := 0;
    repeat
      ok := True;
      for j := 0 to i - 1 do begin
        if (FObjectRows[j] = row) and obj.Intersects(FTimeObjects[j]) then begin
          Inc(row);
          ok := False;
          Break;
        end;
      end;
    until ok;
    FObjectRows[i] := row;
    if FMaxRow < row then
      FMaxRow := row;
  end;
end;

procedure TTimeTrack.Draw(top : Integer);
var i : Integer;
begin
  for i := 0 to FTimeObjects.Count - 1 do
    TTimeObject(FTimeObjects[i]).Draw(top + FObjectRows[i] * TimeRowHeight);
end;

function TTimeTrack.GetObjectAt(x, y : Integer) : TTimeObject;
var i : Integer;
begin
  for i := 0 to FTimeObjects.Count - 1 do
    if TTimeObject(FTimeObjects[i]).Contains(x, y - FObjectRows[i] * TimeRowHeight) then begin
      Result := TTimeObject(FTimeObjects[i]);
      Exit;
    end;
  Result := nil;
end;

{ TTimeObject }

function TTimeObject.GetText : String;
begin
  Result := '';
end;

function TTimeObject.GetFullText : String;
begin
  Result := '';
end;

procedure TTimeObject.Draw(top : Integer);
var
  it : TIntTime;
  x, y : Integer;
  c : TColor;
  s : String;
begin
  it := Time;
  x := FTimeline.Map.PXFromIT(it);
  y := top + 2;
  c := GetColor;
  s := GetText;
  DrawTimeObject(FTimeline.Canvas, x, y, c, s);
end;

function TTimeObject.Intersects(o : TTimeObject) : Boolean;
var it : TIntTime;
begin
  it := Time;
  if o is TTimeSpanObject then
    Result := (it >= TTimeSpanObject(o).Left.Time) and (it < TTimeSpanObject(o).Right.Time)
  else
    Result := it = o.Time;
end;

function TTimeObject.Contains(x, y : Integer) : Boolean;
begin
  Result := (x = FTimeline.Map.PXFromIT(Time)) and (y >= 2) and (y <= TimeObjectHeight + 2);
end;

function TTimeObject.GetColor;
begin
  Result := clLime;
end;

{ TTimeSpanObject }

procedure TTimeSpanObject.SetTime(it : TIntTime);
var diff : TIntTime;
begin
  diff := it - Left.Time;
  Left.Time := it;
  Right.Time := Right.Time + diff;
end;

function TTimeSpanObject.GetTime : TIntTime;
begin
  Result := Left.Time;
end;

procedure TTimeSpanObject.Draw(top : Integer);
var
  it1, it2 : TIntTime;
  x1, x2, y : Integer;
  c : TColor;
  s : String;
begin
  it1 := Left.Time;
  x1 := FTimeline.Map.PXFromIT(it1);
  it2 := Right.Time;
  if it2 <> 0 then
    x2 := FTimeline.Map.PXFromIT(it2)
  else
    x2 := x1;
  y := top + 2;
  c := GetColor;
  s := GetText;
  DrawSpanObject(FTimeline.Canvas, x1, x2, y, c, s);
end;

function TTimeSpanObject.Intersects(o : TTimeObject) : Boolean;
var itLeft, itRight, itOtherLeft, itOtherRight, itOther : TIntTime;
begin
  itLeft := Left.Time;
  itRight := Right.Time;
  if itRight = 0 then
    itRight := itLeft + 24 * 60;
  if o is TTimeSpanObject then begin
    itOtherLeft := TTimeSpanObject(o).Left.Time;
    itOtherRight := TTimeSpanObject(o).Right.Time;
    if itOtherRight = 0 then
      itOtherRight := itOtherLeft + 24 * 60;
    Result := (itLeft >= itOtherLeft) and (itLeft < itOtherRight)
           or (itRight > itOtherLeft) and (itRight <= itOtherRight)
           or (itOtherLeft >= itLeft) and (itOtherLeft < itRight);
  end else begin
    itOther := o.Time;
    Result := (itOther >= itLeft) and (itOther <= itRight);
  end;
end;

function TTimeSpanObject.Contains(x, y : Integer) : Boolean;
var
  x1, x2 : Integer;
  it2 : TIntTime;
begin
  x1 := FTimeline.Map.PXFromIT(Left.Time);
  it2 := Right.Time;
  if it2 <> 0 then
    x2 := FTimeline.Map.PXFromIT(it2)
  else
    x2 := x1;
  Result := (x >= x1) and (x <= x2) and (y >= 2) and (y <= TimeObjectHeight + 2);
end;

initialization
  clBackground := ColorToRGB(clBtnFace);
end.
