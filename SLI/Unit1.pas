unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Lists, Parse, Eval;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var st : ILinkedList;
begin
  st := Parser.Parse(memo1.text);
  memo2.Text := Evaluator.Evaluate(st).ToString;
end;

end.
