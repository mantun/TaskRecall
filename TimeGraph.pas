unit TimeGraph;

interface

uses Graphics, Types;

const
  ColorPalette : array[0..35] of TColor = (
    $FF0000, $FF7F00, $FEFF00, $7FFF00,
    $00FF00, $00FF7F, $00FFFE, $007FFF,
    $0000FF, $7F00FF, $FF00FE, $FF007F,

    $FF4C4C, $FEA54C, $FEFE4C, $A5FE4C,
    $4CFE4C, $4CFEA5, $4CFEFE, $4CA5FE,
    $4C4CFE, $A54CFE, $FE4CFE, $FE4CA5,

    $FF9999, $FFCC99, $FEFF99, $CCFF99,
    $99FF99, $99FFCC, $99FFFE, $99CCFF,
    $9999FF, $CB99FF, $FF99FE, $FF99CB
  );

const
  TimeObjectHeight = 15;
  TimeRowHeight = 20;
  clFreeTick : TColor = clRed;
  clSolidTick : TColor = clBlack;
  clTimeObjectText : TColor = clBlack;
var
  clBackground : TColor;

function BlendColor(c1, c2 : TColor; alpha : Double) : TColor;
function GetContrastColor(c : TColor) : TColor;
procedure DrawSpanObject(Canvas : TCanvas; x1, x2, y : Integer; color : TColor; text : String);
procedure DrawTimeObject(Canvas : TCanvas; x, y : Integer; color : TColor; text : String);

implementation

uses Math;

function BlendColor(c1, c2 : TColor; alpha : Double) : TColor;
var r1, g1, b1, r2, g2, b2 : Byte;
begin
  r1 := c1 and $FF;
  g1 := (c1 shr 8) and $FF;
  b1 := (c1 shr 16) and $FF;
  r2 := c2 and $FF;
  g2 := (c2 shr 8) and $FF;
  b2 := (c2 shr 16) and $FF;

  Result := Round(r1 * (1 - alpha) + r2 * alpha)
         or Round(g1 * (1 - alpha) + g2 * alpha) shl 8
         or Round(b1 * (1 - alpha) + b2 * alpha) shl 16;
end;

function GetContrastColor(c : TColor) : TColor;
var
  r, g, b, len : Double;
begin
  r := c and $FF / $FF;
  g := (c shr 8) and $FF / $FF;
  b := (c shr 16) and $FF / $FF;
  len := sqrt(r * r + g * g + b * b);
  if len <= 1 then
    Result := clWhite
  else
    Result := clBlack;
end;

function GetGradient(c1, c2 : TColor) : TBitmap;
type
  PRGBQuadArray = ^LongWord;
var
  r1, g1, b1, r2, g2, b2 : Byte;
  rd, gd, bd : Integer;
  i : Integer;
  row : PRGBQuadArray;
begin
  r1 := c1 and $FF;
  g1 := (c1 shr 8) and $FF;
  b1 := (c1 shr 16) and $FF;
  r2 := c2 and $FF;
  g2 := (c2 shr 8) and $FF;
  b2 := (c2 shr 16) and $FF;
  rd := r2 - r1;
  gd := g2 - g1;
  bd := b2 - b1;
  Result := TBitmap.Create;
  Result.Height := 1;
  Result.Width := 255;
  Result.PixelFormat := pf32bit;
  row := PRGBQuadArray(Result.ScanLine[0]);
  for i := 0 to 255 do begin
    row^ := (r1 + i * rd shr 8) shl 16
         or (g1 + i * gd shr 8) shl 8
         or (b1 + i * bd shr 8);
    inc(row);
  end;
end;

procedure DrawSpanObject(Canvas : TCanvas; x1, x2, y : Integer; color : TColor; text : String);
var
  textW : Integer;
  textRect : TRect;
  gradient : TBitmap;
begin
  if x2 = x1 + 1 then // aviod ugly forms
    x2 := x1;
  if text <> '' then begin
    textW := Canvas.TextWidth(text);
    if textW > x2 - x1 then begin
      textRect := Rect(Max(x2 - 10, (x1 + x2) div 2), y, x1 + textW + 4, y + TimeObjectHeight);
      gradient := GetGradient(BlendColor(color, clBackground, 0.5), clBackground);
      Canvas.StretchDraw(textRect, gradient);
      gradient.Free;
    end;
  end;
  Canvas.Pen.Color := BlendColor(color, clBlack, 0.3);
  Canvas.Brush.Color := color;
  Canvas.Brush.Style := bsSolid;
  Canvas.RoundRect(x1, y, x2 + 1, y + TimeObjectHeight, 10, 10);
  if text <> '' then begin
    Canvas.Font.Color := GetContrastColor(color);
    Canvas.Brush.Style := bsClear;
    Canvas.TextOut(x1 + 2, y + 1, text);
  end;
end;

procedure DrawTimeObject(Canvas : TCanvas; x, y : Integer; color : TColor; text : String);
begin
  Canvas.Pen.Color := color;
  Canvas.Brush.Color := color;
  Canvas.Brush.Style := bsSolid;
  Canvas.Rectangle(x - 1, y, x + 2, y + TimeObjectHeight);
  if text <> '' then begin
    Canvas.Brush.Style := bsClear;
    Canvas.Font.Color := GetContrastColor(color);
    Canvas.TextOut(x + 3, y + 1, text);
  end;
end;

end.
