unit TasksFileConvert;

interface

uses Classes;

procedure FromRevision(rev : Integer; const ObjID, ClassName : String; Body : TStringList);

implementation

uses Tasks;

type
  TConvertBodyProc = procedure(const ObjID, ClassName : String; Body : TStringList);

procedure FromRevision0(const ObjID, ClassName : String; Body : TStringList);
begin
  if ClassName = TTask.ClassName then begin
    Body.Insert(9, '""');
  end;
end;

const
  RevisionProcs : Array[0..TasksFileRevision - 1] of TConvertBodyProc = (
     FromRevision0
  );

procedure FromRevision(rev : Integer; const ObjID, ClassName : String; Body : TStringList);
var i : Integer;
begin
  for i := rev to TasksFileRevision - 1 do
    RevisionProcs[i](ObjID, ClassName, Body);
end;

end.
