program Lab8;

{$APPTYPE CONSOLE}
{$R *.res}

uses Windows,
  System.SysUtils,
  System.Math;

const
  MAX_LENGTH = 15;
  MAX_COUNT = 1000;
  WINDOW_LENGTH = 50;

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



function showGameInterface(lang: TLanguage; level: integer; originalString: string): string;
begin
  if lang = en then
    writeln('(LEVEL ', level, ') Try to repeat this phrase:')
  else
    writeln('(УРОВЕНЬ ', level, ') Попытайтесь повторить эту фразу:');
  writeln(originalString);
  readln(result);
  clearConsole();
end;



function spaceWork(str: string): string;
begin
  result := str;
  while (length(result) > 0) and (result[1] = ' ') do begin
    delete(result, 1, 1);
  end;
  while (length(result) > 0) and (result[length(result)] = ' ') do begin
    delete(result, length(result), 1);
  end;
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




function generateNextString(originalString: string; userString: string; dict: TDict; duplicateCount: integer): string;
var originalWords, userWords, answerArray: TWordsArray;
i, j, k: integer;
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
        for k := 1 to duplicateCount do begin
          answerArray[i] := answerArray[i] + originalWords[i, j];
        end;
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

var
  lang: TLanguage;
  gameClosed, gameEnd, win: boolean;
  level, duplicateCount: integer;
  originalString, userString: string;
  dict: TDict;

begin
  SetConsoleCP(1251);
  SetConsoleOutputCP(1251);
  randomize;
//  readLanguage();

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
//  writeln(generateNextString('True Word', 'Truu word', dict, 4));
//  s := spaceWork(' dasdasdas dfdsf ');
//  Readln;
  writeln('ТРЕНАЖОР ДЛЯ СЛЕПОЙ ПЕЧАТИ');
  writeln('Введите Enter, чтобы продолжить');
  readln;
  lang := readLanguage();
  if lang = en then
    dict := readDict('../../../dict-en.txt')
  else
    dict := readDict('../../../dict-ru.txt');
  clearConsole();
  gameClosed := false;
  level := 0;
  win := false;
  while not gameClosed do begin
    if win then begin
      inc(level);
    end else begin
      level := 1;
    end;
    originalString := generateString(20, dict);
    gameEnd := false;
    while not gameEnd do begin
      userString := showGameInterface(lang, level, originalString);
      userString := spaceWork(userString);
      if userString = '13' then begin
        gameClosed := true;
        gameEnd := true;
        if lang = en then
        begin
          writeln('The game is closed');
          writeln('Press Enter to continue');
        end
        else
        begin
          writeln('Игра закрыта');
          writeln('Введите Enter, чтобы продолжить');
        end;
      end
      else begin
        originalString := generateNextString(originalString, userString, dict, level * 2);
        if originalString = '' then begin
          gameEnd := true;
          win := true;
          if lang = en then
          begin
            writeln('You win the level!');
            writeln('Press Enter to continue');
          end
          else
          begin
            writeln('Вы выиграли в уровне!');
            writeln('Введите Enter, чтобы продолжить');
          end;
        end;
        if length(originalString) > WINDOW_LENGTH then begin
          gameEnd := true;
          win := false;
          if lang = en then
          begin
            writeln('You lost the level :(');
            writeln('Press Enter to continue');
          end
          else
          begin
            writeln('Вы проиграли в уровне :(');
            writeln('Введите Enter, чтобы продолжить');
          end;
        end;
      end;
    end;
    readln;
    clearConsole();
  end;

end.
