/////////////////////////////////////////
///////--Simple engine by Chilly---//////
///////--http://delphigl.narod.ru--//////
/////////////////////////////////////////

program tree;

{$R *.RES}

uses
  Messages,
  Windows,
  OpenGL,
  var_proc,
  BMP;

procedure FractalTree( level:integer);
begin
 if (level = 7) then
       begin
         glPushMatrix();
           glRotatef((random/1)*180, 0, 1, 0);
           glCallList(STEM_AND_LEAVES);
         glPopMatrix();
       end
   else
      begin
    glCallList(STEM);
    glPushMatrix();
    glRotatef((random/1)*180, 0, 1, 0);
    glTranslatef(0, 1, 0);
    glScalef(0.7, 0.7, 0.7);

      glPushMatrix();
        glRotatef(110 + (random/1)*40, 0, 1, 0);
        glRotatef(30 + (random/1)*20, 0, 0, 1);
        FractalTree(level + 1);
      glPopMatrix();


      glPushMatrix();
        glRotatef(-130 + (random/1)*40, 0, 1, 0);
        glRotatef(30 + (random/1)*20, 0, 0, 1);
        FractalTree(level + 1);
      glPopMatrix();


      glPushMatrix();
        glRotatef(-20 + (random/1)*40, 0, 1, 0);
        glRotatef(30 + (random/1)*20, 0, 0, 1);
        FractalTree(level + 1);
      glPopMatrix();

    glPopMatrix();
  end;
  end;

procedure CreateTreeLists;
var i:integer;
begin
  cylquad:= gluNewQuadric();
  glNewList(STEM, GL_COMPILE);
  glPushMatrix();
   glenable(gl_texture_2d);
   glbindtexture(gl_texture_2d,stem_tex);
    glRotatef(-90, 1, 0, 0);
    gluQuadricTexture(cylquad, GL_TRUE);
    gluCylinder(cylquad, 0.1, 0.08, 1, 5, 1 );
  glPopMatrix();
  glEndList();

  glNewList(LEAF, GL_COMPILE); 
    glPushMatrix();

   glbindtexture(gl_texture_2d,leaf_tex);
   glBegin(GL_QUADS);
      glNormal3f(-0.1, 0, 0.25);
      gltexcoord2f(0,0);glVertex3f(0, 0, 0.1);
      gltexcoord2f(0,1);glVertex3f(0.25, 0.25, 0);
      gltexcoord2f(1,1);glVertex3f(0, 0.9, 0.1);
      gltexcoord2f(1,0);glVertex3f(-0.25, 0.25, 0);
    glEnd();
    glPopMatrix();
  glEndList();

  glNewList(STEM_AND_LEAVES, GL_COMPILE);
  glPushMatrix();
  glPushAttrib(GL_LIGHTING_BIT);
    glPushMatrix();
   glenable(gl_texture_2d);
   glbindtexture(gl_texture_2d,stem_tex);
    glRotatef(-90, 1, 0, 0);
    gluQuadricTexture(cylquad, GL_TRUE);
    gluCylinder(cylquad, 0.1, 0.02, 1.5, 3, 1 );
  glPopMatrix();
    glPushMatrix();
    for i:= 0 to 4 do
     begin
      //glcolor(0.23,0.001,0.04);
      glTranslatef(0, 0.333, 0);
      glRotatef(90, 0, 1, 0);
        glscalef(0.95,0.95,0.95);
      glPushMatrix();
        glRotatef(0, 0, 1, 0);
        glRotatef(50, 1, 0, 0);
        glCallList(LEAF);
      glPopMatrix();
      glPushMatrix();
        glRotatef(180, 0, 1, 0);
        glRotatef(60, 1, 0, 0);
        glCallList(LEAF);
      glPopMatrix();
    end;
  glPopAttrib();
  glPopMatrix();
  glPopMatrix();
  glEndList();
end;

   // scene's render
procedure Render;

begin
 glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
 glenable(GL_LIGHTING);
 glPushMatrix;
  glRotate(Yangle, 1, 0, 0);
  glRotate(Xangle, 0, 1, 0);
  glTranslatef(X, -0.25+Move , Z);
   // objects
    glPushMatrix;
      glCallList(8);
    glPopMatrix;
  glPopMatrix;

 SwapBuffers(DC);
end;

// obrabotka najatiy klavish
procedure ProcessKeys;
begin
 if Keys[VK_ESCAPE] then PostQuitMessage(0);

if Keys[VK_UP] then
  begin
    X := X - sin(Xangle*pi/180)*0.06;
    Z := Z + cos(Xangle*pi/180)*0.06;
    MovUgol :=MovUgol + 15;
    Move :=0.03*sin(MovUgol*pi/180);

  end;
  if Keys[VK_DOWN] then
  begin
    X := X + sin(Xangle*pi/180)*0.06;
    Z := Z - cos(Xangle*pi/180)*0.06;
    MovUgol :=MovUgol + 15;
    Move :=0.03*sin(MovUgol*pi/180);

  end;
  if Keys[VK_LEFT] then
  begin
    X := X + sin((Xangle+90)*pi/180)*0.06;
    Z := Z - cos((Xangle+90)*pi/180)*0.06;
  end;
  if Keys[VK_RIGHT] then
  begin
    X := X - sin((Xangle+90)*pi/180)*0.06;
    Z := Z + cos((Xangle+90)*pi/180)*0.06;
  end;
 if Keys[VK_Space] then
  begin
  randomize;
  koef:=random(3)/(random(33)+1);
  koef1:=random(3)/(random(33)+1);
  koef2:=random(3)/(random(33)+1);
  FractalTree( 1);
  CreateTreeLists;
 end;

end;

// полноэкранный режим
procedure ChangeToFullscreen;
var DeviceMode: TDevMode;
begin
 with DeviceMode do
  begin
   dmSize := SizeOf(DeviceMode);
   dmPelsWidth := SCREEN_WIDTH;
   dmPelsHeight := SCREEN_HEIGHT;
   dmBitsPerPel := SCREEN_BPP;
   dmFields := DM_PELSWIDTH or DM_PELSHEIGHT or DM_BITSPERPEL;
  end;
 ChangeDisplaySettings(DeviceMode, CDS_FULLSCREEN);
end;

// ‘ормат пиксела
procedure SetPixFormat(HDC: HDC);
var pfd: TPixelFormatDescriptor;
    nPixelFormat: Integer;
begin
 with pfd do
  begin
  nSize := SizeOf(TPixelFormatDescriptor); // размер структуры
   nVersion := 1;                           // номер версии
   dwFlags := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER; // множество битовых флагов, определ€ющих устройство и интерфейс													// Pass in the appropriate OpenGL flags
   iPixelType := PFD_TYPE_RGBA; // режим дл€ изображени€ цветов
   cColorBits := SCREEN_BPP;    // число битовых плоскостей в каждом буфере цвета
   cRedBits := 0;               // число битовых плоскостей красного в каждом буфере RGBA
   cRedShift := 0;              // смещение от начала числа битовых плоскостей красного в каждом буфере RGBA
   cGreenBits := 0;             // число битовых плоскостей зелЄного в каждом буфере RGBA
   cGreenShift := 0;            // смещение от начала числа битовых плоскостей зелЄного в каждом буфере RGBA
   cBlueBits := 0;              // число битовых плоскостей синего в каждом буфере RGBA
   cBlueShift := 0;             // смещение от начала числа битовых плоскостей синего в каждом буфере RGBA
   cAlphaBits := 0;             // число битовых плоскостей альфа в каждом буфере RGBA
   cAlphaShift := 0;            // смещение от начала числа битовых плоскостей альфа в каждом буфере RGBA
   cAccumBits := 0;             // общее число битовых плоскостей в буфере аккумул€тора
   cAccumRedBits := 0;          // число битовых плоскостей красного в буфере аккумул€тора
   cAccumGreenBits := 0;        // число битовых плоскостей зелЄного в буфере аккумул€тора
   cAccumBlueBits := 0;         // число битовых плоскостей синего в буфере аккумул€тора
   cAccumAlphaBits := 0;        // число битовых плоскостей альфа в буфере аккумул€тора
   cDepthBits := SCREEN_BPP;    // размер буфера глубины (ось z)
   cStencilBits := 0;           // размер буфера трафарета
   cAuxBuffers := 0;            // число вспомогательных буферов
   iLayerType := PFD_MAIN_PLANE;// тип плоскости
   bReserved := 0;              // число плоскостей переднего и заднего плана
   dwLayerMask := 0;            // игнорируетс€
   dwVisibleMask := 0;          // индекс или цвет прозрачности нижней плоскости
   dwDamageMask := 0;           // игнорируетс€

  end;

 nPixelFormat := ChoosePixelFormat(HDC, @pfd); // запрос системе - поддерживаетс€ ли выбранный формат пикселей
 SetPixelFormat(HDC, nPixelFormat, @pfd);      // устанавливаем формат пикселей в контексте устройства
end;

// Initialize OpenGL
procedure InitializeGL;
var i,j:integer;
begin
  DC := GetDC(Handle);
  SetPixFormat(DC);
  HRC := wglCreateContext(DC);
  ReleaseDC(Handle, DC);
  wglMakeCurrent(DC, HRC);
  glDepthFunc(GL_LEQUAL);
  glEnable(GL_DEPTH_TEST);
 // glEnable(GL_NORMALIZE);
 glclearcolor(1,1,1,0);
 // glEnable(GL_CULL_FACE);
 // glCullFace(GL_BACK);
  glenable(gl_color_material);
  glShadeModel(GL_SMOOTH);
  glenable(gl_light0);
  loadtexture('tex\leaf.bmp',leaf_tex);
  loadtexture('tex\stem.bmp',stem_tex);

  CreateTreeLists;
   glNewList(8, GL_COMPILE);
    randomize;

      FractalTree( 0);
  glEndList();
  xangle:=135;
  yangle:=-20;
  x:=5;
  z:=2;
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
end;

// Finalize OpenGL
procedure FinalizeGL;
begin
gludeleteQuadric(cylquad);
gldeletelists(0,200);
wglDeleteContext(HRC);
wglMakeCurrent(0, 0);
ReleaseDC(Handle, DC);
DeleteDC(DC);
end;

// Setup a perspective
procedure SetPerspective(Width, Height: Integer);
begin
 glViewport(0, 0, Width, Height);
 glMatrixMode(GL_PROJECTION);
 glLoadIdentity;
gluperspective(60,Width/Height,0.01,50);

 glMatrixMode(GL_MODELVIEW);
 glLoadIdentity;
end;

// Windows"s procedures
function WindowProcedure(Window: hWnd; Message, wParam: Word; lParam: LongInt): LongInt; stdcall;
begin
 case Message of
  WM_SIZE:SetPerspective(LOWORD(lParam),HIWORD(lParam));
  WM_CLOSE: PostQuitMessage(0);
  WM_KEYDOWN:begin Keys[wParam] := True;end;
  WM_KEYUP:Keys[wParam] := False;
  WM_TIMER :
      begin
        if (wParam = FPS_TIMER)  then
        begin
          FPSCount :=Round(FPSCount * 1000/FPS_INTERVAL);

      //   GL_WRITE(inttostr(FPSCount),100,100);
          FPSCount := 0;
          Result := 0;
        end;
      end;

 else Result := DefWindowProc(Window, Message, wParam, lParam);
 end;
end;


procedure CreateTheWindow(Width, Height: Integer);
var WindowClass: TWndClass;
    hInstance: HINST;
    Style: Cardinal;
begin
 setpriorityclass(getcurrentprocess,high_priority_class);
 hInstance := GetModuleHandle(nil);
 ZeroMemory(@WindowClass, SizeOf(WindowClass));
 with WindowClass do
  begin
   Style := CS_HREDRAW or CS_VREDRAW or CS_OWNDC;
   lpfnWndProc := @WindowProcedure;
   cbClsExtra := 0;
   cbWndExtra := 0;
   hInstance := hInstance;
   hIcon := LoadIcon(0, IDI_APPLICATION);
   hCursor := LoadCursor(0, IDC_ARROW);
   hbrBackground := GetStockObject(WHITE_BRUSH);
   lpszMenuName := '';
   lpszClassName := TITLE;
  end;
 RegisterClass(WindowClass);

 Style := WS_POPUP or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;
 ChangeToFullscreen;
 SetCursorPos(SCREEN_WIDTH div 2, SCREEN_HEIGHT div 2);
 ShowCursor(FALSE);
 Handle := CreateWindowEx(WS_EX_APPWINDOW or WS_EX_WINDOWEDGE, TITLE, TITLE, Style, 0, 0, Width, Height, 0, 0, hInstance, nil);
 ShowWindow(Handle, SW_SHOW);
 SetTimer(handle, FPS_TIMER, FPS_INTERVAL, nil);
 InitializeGL;
 SetPerspective(WIDTH, HEIGHT);
end;

// Destroy the window
procedure DestroyTheWindow;
begin
 ChangeDisplaySettings(TDevMode(nil^), CDS_FULLSCREEN);
  ShowCursor(True);
FinalizeGL;
 DestroyWindow(Handle);
 UnRegisterClass(TITLE, hInstance);
end;

//main apllication loop
function WinMain(hInstance: HINST; hPrevInstance: HINST; lpCmdLine: PChar; nCmdShow: Integer): Integer; stdcall;
var Msg : TMsg;
    Finished : Boolean;
    DemoStart, LastTime : DWord;

begin
 Finished := False;
  DemoStart := GetTickCount();
 while not Finished do
  begin
   if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
    begin
     if Msg.Message = WM_QUIT then Finished := True
     else
      begin
       TranslateMessage(msg);
       DispatchMessage(msg);
      end;
    end
   else
    begin
     Inc(FPSCount);
      LastTime :=ElapsedTime;
      ElapsedTime :=GetTickCount() - DemoStart;
      ElapsedTime :=(LastTime + ElapsedTime) DIV 2;

     ProcessKeys;
      if GetForegroundWindow = handle then
      begin
        GetCursorPos(mpos);
        SetCursorPos(SCREEN_WIDTH div 2, SCREEN_HEIGHT div 2);
        Xangle := Xangle + (mpos.x - SCREEN_WIDTH div 2)/100 * MouseSpeed;
        Yangle := Yangle - (sCREEN_HEIGHT div 2 - mpos.y)/100 * MouseSpeed;
        if Yangle> 60 then Yangle :=60;
        if Yangle < -60 then Yangle :=-60;
      end;

     Render;
    end;
  end;

 Result := Msg.wParam;
end;

begin
 CreateTheWindow(SCREEN_WIDTH, SCREEN_HEIGHT);
 WinMain(hInstance, hPrevInst, CmdLine, CmdShow);
 DestroyTheWindow;

 end.

