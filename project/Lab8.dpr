program Lab8;

{$APPTYPE CONSOLE}
{$R *.res}

uses Windows;

const
  MAX_LENGTH = 15;
  MAX_COUNT = 1000;

type
  TDictArray = array [1 .. MAX_LENGTH, 1 .. MAX_COUNT] of string;
  TCountArray = array [1 .. MAX_LENGTH] of integer;

  TDict = record
  var
    words: TDictArray;
    count: TCountArray;
  end;

function min(a, b: integer): integer;
begin
  if a < b then
    result := a
  else
    result := b;
end;

function generateString(stringLength: integer; dict: TDict): string;
var
  wordLength: integer;
  word: string;
begin
  result := '';

  writeln(random(0));
  repeat

    repeat
      wordLength := random(min(MAX_LENGTH, stringLength - length(result) - 1)) + 1;
    until not(length(result) + 1 + wordLength + 1 = stringLength);


    word := dict.words[wordLength][random(dict.count[wordLength]) + 1];

    if length(result) = 0 then
      result := word
    else
      result := result + ' ' + word;
  until length(result) = stringLength;
end;

function readDict(filePath: string): TDict;
var
  f: TextFile;
  buffer: string;
  i: integer;
begin
  AssignFile(f, filePath);
  reset(f);

  for i := 1 to MAX_LENGTH do
     result.count[i] := 0;

  while (not EOF(f)) do
  begin
    buffer := '';
    Readln(f, buffer);
    buffer := UTF8Decode(buffer);

    inc(result.count[length(buffer)]);
    result.words[length(buffer), result.count[length(buffer)]] := buffer;
  end;

  CloseFile(f);
end;

var
  dict: TDict;
  i, j: integer;

begin
  SetConsoleCP(1251);
  SetConsoleOutputCP(1251);
  dict := readDict('../../../dict-en.txt');
  // 'C:\Универ\Lab8-blind-printing\dict-en.txt'
  for i := 1 to MAX_LENGTH do
  begin
//    if dict.count[i] = 0 then
//      writeln(i);

//    writeln(i);
//    for j := 1 to dict.count[i] do
//    begin
//      write(dict.words[i, j], ' ');
//    end;
//    writeln;

  writeln(generateString(i, dict));
  end;
  Readln;

end.
