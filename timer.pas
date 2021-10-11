//------------------------------------------------------------------
//    ‘айл:     timer.pas
//    ќписание: –еализаци€ простого высокоточного таймера
//------------------------------------------------------------------
unit timer;

interface

function Timer_Create(): boolean;

implementation

uses
  windows;

type
  PLARGE_INTEGER = ^LARGE_INTEGER;

var
  g_freq:     extended;
  g_oldcount: LARGE_INTEGER;

// здесь переобъ€влены две функции из Win32 API в правильном виде
function QueryPerformanceFrequency( lpFrequency: PLARGE_INTEGER ): BOOL; stdcall;
  external kernel32 name 'QueryPerformanceFrequency';
function QueryPerformanceCounter( lpPerformanceCount: PLARGE_INTEGER ): BOOL; stdcall;
  external kernel32 name 'QueryPerformanceCounter';




//------------------------------------------------------------------
// инициализирует таймер
//------------------------------------------------------------------
function Timer_Create(): boolean;
var
  frequency: LARGE_INTEGER;
begin
  if QueryPerformanceFrequency( @frequency ) = BOOL(FALSE) then
     result := false
  else
     result := true;

  g_freq := 1000 / frequency.QuadPart; // корректируем дл€ миллисекунд
  QueryPerformanceCounter( @g_oldcount );
end;





end.
