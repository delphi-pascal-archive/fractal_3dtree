//------------------------------------------------------------------
//    ����:     timer.pas
//    ��������: ���������� �������� ������������� �������
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

// ����� ������������� ��� ������� �� Win32 API � ���������� ����
function QueryPerformanceFrequency( lpFrequency: PLARGE_INTEGER ): BOOL; stdcall;
  external kernel32 name 'QueryPerformanceFrequency';
function QueryPerformanceCounter( lpPerformanceCount: PLARGE_INTEGER ): BOOL; stdcall;
  external kernel32 name 'QueryPerformanceCounter';




//------------------------------------------------------------------
// �������������� ������
//------------------------------------------------------------------
function Timer_Create(): boolean;
var
  frequency: LARGE_INTEGER;
begin
  if QueryPerformanceFrequency( @frequency ) = BOOL(FALSE) then
     result := false
  else
     result := true;

  g_freq := 1000 / frequency.QuadPart; // ������������ ��� �����������
  QueryPerformanceCounter( @g_oldcount );
end;





end.
