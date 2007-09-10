program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Lists in 'Lists.pas',
  Parse in 'Parse.pas',
  ResultDecl in 'ResultDecl.pas',
  Eval in 'Eval.pas',
  BuiltinDefs in 'BuiltinDefs.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
