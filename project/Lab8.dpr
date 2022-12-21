program Lab8;

{$APPTYPE CONSOLE}

{$R *.res}

uses Windows;

const MAX_LENGTH = 30;
MAX_COUNT = 1000;

type
TDictArray = array[1..MAX_LENGTH, 1..MAX_COUNT] of string;
TCountArray = array[1..MAX_LENGTH] of integer;
TDict = record
  var
  words: TDictArray;
  count: TCountArray;
end;

function readDict(filePath: string): TDict;
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
        dictArray[length(buffer), countArray[length(buffer)]] := UTF8Decode(buffer);
    end;
    CloseFile(f);
    result.words := dictArray;
    result.count := countArray;
end;

//var dict: TDict;
//i, j: integer;

begin
//    SetConsoleCP(1251);
//    SetConsoleOutputCP(1251);
//    dict := readDict('../../../dict-en.txt');  // 'C:\Универ\Lab8-blind-printing\dict-en.txt'
//    for i := 1 to MAX_LENGTH do begin
//        writeln(i);
//        for j := 1 to dict.count[i] do begin
//            write(dict.words[i, j], ' ');
//        end;
//        writeln;
//    end;
//    readln;
end.
