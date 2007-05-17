unit TimelineForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TimeMap, TimelineData, Tasks;

type
  TfrmTimeline = class(TForm)
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FTimeline : TTimeline;
    FSelection : TObjectsSelection;
    FLDown : Boolean;
    DownXPos : Integer;
    DownBase : TIntTime;
    FDataProvider : TTimelineDataProvider;
    FHintWindow : THintWindow;
    procedure OnDataChange(Sender : TObject);
  public
    constructor Create(AOwner : TComponent; ASelection : TObjectsSelection); reintroduce;
  end;

var
  frmTimeline: TfrmTimeline;

type
  TTaskSelection = class(TObjectsSelection)
    function Belongs(const obj : TNamedObject) : Boolean; override;
  end;

implementation

uses Math;

{$R *.dfm}

function TTaskSelection.Belongs(const obj : TNamedObject) : Boolean;
begin
  Result := (obj is TTask) and (TTask(obj).StartTime <> 0);
end;

constructor TfrmTimeline.Create(AOwner : TComponent; ASelection : TObjectsSelection);
begin
  inherited Create(AOwner);
  FSelection := ASelection;
  DoubleBuffered := True;
end;

procedure TfrmTimeline.OnDataChange(Sender : TObject);
begin
  Invalidate;
end;

procedure TfrmTimeline.FormPaint(Sender: TObject);
begin
  FTimeline.Draw;
end;

procedure TfrmTimeline.FormCreate(Sender: TObject);
begin
  FHintWindow := THintWindow.Create(Self);
  FTimeline := TTimeline.Create(Canvas, ClientRect);
  FTimeline.Map.Scale := 2;
  FDataProvider := TTimelineDataProvider.Create(FSelection, FTimeline);
  FDataProvider.OnChange := OnDataChange;
end;

procedure TfrmTimeline.FormDestroy(Sender: TObject);
begin
  FDataProvider.Free;
  FDataProvider := nil;
  FTimeline.Free;
  FTimeline := nil;
  FSelection.Free;
  FSelection := nil;
  FHintWindow.Free;
  FHintWindow := nil;
end;

procedure TfrmTimeline.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  clPos : TPoint;
  it : TIntTime;
  step : Double;
begin
  clPos := ScreenToClient(MousePos);
  it := FTimeline.Map.ITFromPX(clPos.X);
  if WheelDelta > 0 then
    if ssCtrl in Shift then step := 0.004
    else step := 0.001
  else
    if ssCtrl in Shift then step := 0.007
    else step := 0.0016;
  FTimeline.Map.Scale := Max(0.05, FTimeline.Map.Scale * (1 - step * WheelDelta));
  FTimeline.Map.itBase := FTimeline.Map.itBase + it - FTimeline.Map.ITFromPX(clPos.X);
  FTimeline.Map.pxMinTickWidth := 5;
  Invalidate;
end;

procedure TfrmTimeline.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FLDown := True;
  DownXPos := X;
  DownBase := FTimeline.Map.itBase;
end;

procedure TfrmTimeline.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  o : TTimeObject;
  p : TPoint;
  r : TRect;
  s : String;
begin
  if FLDown then begin
    FTimeline.Map.itBase := DownBase - FTimeline.Map.DITFromDPX(X - DownXPos);
    Invalidate;
  end;
  o := FTimeline.GetObjectAt(x, y);
  if o <> nil then begin
    p := ClientToScreen(Point(x, y));
    s := o.FullText;
    r := FHintWindow.CalcHintRect(400, s, nil);
    FHintWindow.ActivateHint(Rect(p.x, p.y + 25, p.x + r.Right, p.y + r.Bottom + 25), s)
  end else
    FHintWindow.ReleaseHandle;
end;

procedure TfrmTimeline.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FLDown := False;
end;

procedure TfrmTimeline.FormResize(Sender: TObject);
begin
  FTimeline.Rect := ClientRect;
  Invalidate;
end;

procedure TfrmTimeline.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
