program Lab8;

{$APPTYPE CONSOLE}
{$R *.res}

uses Windows,
  System.SysUtils,
  System.Math;

const
  MAX_LENGTH = 15;
  MAX_COUNT = 1000;

type
  TDictArray = array [1 .. MAX_LENGTH, 1 .. MAX_COUNT] of string;
  TCountArray = array [1 .. MAX_LENGTH] of integer;
  TWordsArray = array [1..MAX_LENGTH] of string;
  TLanguage = (en, ru);

  TDict = record
  var
    words: TDictArray;
    count: TCountArray;
  end;


procedure clearConsole;
var
  cursor: COORD;
  r: cardinal;
begin
  r := 300;
  cursor.X := 0;
  cursor.Y := 0;
  FillConsoleOutputCharacter(GetStdHandle(STD_OUTPUT_HANDLE), ' ', 80 * r, cursor, r);
  SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), cursor);
end;


function readLanguage(): TLanguage;
var
  chosen: boolean;
  lang: string;
begin
  chosen := false;
  while not chosen do begin
    clearConsole();
    writeln('Пожалуйста, выберите язык:');
    writeln('Please, choose language:');
    writeln('Русский - ru');
    writeln('English - en');
    readln(lang);
    if lang = 'en' then begin
     result := en;
     chosen := true;
    end
    else if lang = 'ru' then begin
      result := ru;
      chosen := true;
    end;
  end;
end;


function splitBy(str: string; separator: char): TWordsArray;
var
  state: boolean;
  i, wordsAmount: integer;
begin
  wordsAmount := 0;
  state := false;
  for i := 1 to length(str) do begin
    if (str[i] = separator) and (state = true) then begin
      state := false;   // Состояние "Поиск слова"
    end;
    if (str[i] <> separator) and (state = true) then begin
      insert(str[i], result[wordsAmount], length(result[wordsAmount]) + 1);
    end;
    if (str[i] <> separator) and (state = false) then begin
      state := true;  // Состояние "Запись слова"
      inc(wordsAmount);
      insert(str[i], result[wordsAmount], length(result[wordsAmount]) + 1);
    end;
  end;
end;




function joinBy(words: TWordsArray; separator: char): string;
var
  i: integer;
begin
  i := 1;
  while (i <= MAX_LENGTH) and (words[i] <> '') do begin
    result := result + words[i] + separator;
    inc(i);
  end;
end;




  /// Возвращает случайное слово из словаря длины <= maxLength,
  /// и при этом длина не может быть равна maxLength-1
function chooseRandomWord(maxLength: integer; dict: TDict): string;
var
  length: integer;
begin
  repeat
    length := random(min(MAX_LENGTH, maxLength)) + 1;
  until not(length + 1 = maxLength);

  result := dict.words[length][random(dict.count[length]) + 1];
end;




function generateString(stringLength: integer; dict: TDict): string;
var
  wordLength: integer;
  word: string;
begin
  result := chooseRandomWord(stringLength, dict);

  while result.length < stringLength do
  begin
    word := chooseRandomWord(stringLength - result.length - 1, dict);

    result := result + ' ' + word;
  end;
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




function generateNextString(originalString: string; userString: string; dict: TDict): string;
var originalWords, userWords, answerArray: TWordsArray;
i, j: integer;
equals, equalsAll: boolean;
begin
  originalWords := splitBy(originalString, ' ');
  userWords := splitBy(userString, ' ');
  equalsAll := true;
  i := 1;
  while (i <= MAX_LENGTH) and (originalWords[i] <> '') do begin
    equals := true;
    for j := 1 to length(originalWords[i]) do begin
      if (j > length(userWords[i])) or (userWords[i, j] <> originalWords[i, j]) then begin
        equals := false;
        answerArray[i] := answerArray[i] + originalWords[i, j] + originalWords[i, j];
      end else begin
        answerArray[i] := answerArray[i] + originalWords[i, j];
      end;
    end;
    if equals then begin
      answerArray[i] := generateString(length(originalWords[i]), dict);
    end else begin
      equalsAll := false;
    end;
    inc(i);
  end;
  if (equalsAll) and (originalString = userString) then begin
    if length(originalString) - 2 <= 0 then begin
      result := '';
    end else begin
      result := generateString(length(originalString) - 2, dict);
    end;
  end else begin
    result := joinBy(answerArray, ' ');
  end;
end;



//var
//  dict: TDict;
//  i, j: integer;
//  s: string;
//  words: TWordsArray;


begin
//  SetConsoleCP(1251);
//  SetConsoleOutputCP(1251);
//  randomize;
//  readLanguage();
//  dict := readDict('../../../dict-en.txt');
//  // 'C:\Универ\Lab8-blind-printing\dict-en.txt'
//  for i := 1 to 100 do
//  begin
//    // if dict.count[i] = 0 then
//    // writeln(i);
//
//    // writeln(i);
//    // for j := 1 to dict.count[i] do
//    // begin
//    // write(dict.words[i, j], ' ');
//    // end;
//    // writeln;
//
//    writeln(i, ': ', generateString(i, dict));
//  end;
////  words := splitBy(s, ':');
////  writeln(joinBy(words, ' '));
//  writeln(generateNextString('True Word', 'Truu word', dict));
//  Readln;
end.
