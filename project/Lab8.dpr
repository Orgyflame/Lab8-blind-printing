program Lab8;

{$APPTYPE CONSOLE}

{$R *.res}

const MAX_LENGTH = 30;
MAX_COUNT = 1000;

type
TDictArray = array[1..MAX_LENGTH, 1..MAX_COUNT] of string;
TCountArray = array[1..MAX_LENGTH] of integer;

function readDict(filePath: string): TDictArray;
var dictArray: TDictArray;
countArray: TCountArray;
f: TextFile;
buffer: string;
begin
    AssignFile(f, filePath);
    reset(f);
    while (not EOF(f)) do begin
        Readln(f, buffer);
        inc(countArray[length(buffer)]);
        dictArray[length(buffer), countArray[length(buffer)]] := buffer;
    end;
    CloseFile(f);
    readDict := dictArray;
end;

begin

end.
