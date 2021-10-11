unit var_proc;
 ////////////////////////////////////////
///////------Tree by Chilly--------//////
///////--http://delphigl.narod.ru--//////
/////////////////////////////////////////
interface

uses opengl,windows;



const
  TITLE = 'OpenGL engine by Chilly - http://delphigl.narod.ru';
  SCREEN_WIDTH =1024 ;
  SCREEN_HEIGHT = 768;
  SCREEN_BPP = 32;
  FPS_TIMER = 500;
  FPS_INTERVAL = 1000;
  STEM_AND_LEAVES =5;STEM=6;LEAF=7;

var
  koef, koef1, koef2:real;
  kadr:integer;
  MouseSpeed : Integer = 7;
  Handle: hWnd;
  DC: HDC;
  HRC: HGLRC;
  Keys: array [0..255] of Boolean;
  stem_tex,leaf_tex:cardinal;
  X, Z : glFloat;
  mpos : TPoint;
  Xangle ,Yangle: glFloat;
  Move, MovUgol : glFloat;
  FPSCount : Integer = 0;
  ElapsedTime : Integer;
  cylquad: GLUquadricObj ;


  function  IntToStr(Num : Integer) : String;

implementation



function IntToStr(Num : Integer) : String;
begin
  Str(Num, result);
end;


end.




