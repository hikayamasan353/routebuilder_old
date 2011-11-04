program restartupdate;

{$APPTYPE CONSOLE}

uses
  Windows, Messages, SysUtils, shellapi;

var W: HWnd;

begin

  WriteLn('-ROUTE BUILDER UPDATE-');
  WriteLn('');
  WriteLn('Closing Route Builder update program...');
  W := FindWindow(NIL,'Route Builder - check for updates...');
  if W<>0 then PostMessage(W, wm_close, 1, 1);
  WriteLn('Updating Route Builder update program...');
  WriteLn('Please wait...');
  repeat

  until not(fileexists('comp_patch00.exe') or fileexists('comp_patch01.exe') or fileexists('comp_patch02.exe') and fileexists('comp_patch03.exe') and fileexists('comp_patch04.exe') and fileexists('comp_patch05.exe') and fileexists('comp_patch06.exe') and fileexists('comp_patch07.exe') and fileexists('comp_patch08.exe') and fileexists('comp_patch09.exe') and fileexists('comp_patch10.exe'));

  WriteLn('Restarting Route Builder update program...');
  ShellExecute(Hwnd(nil),Pchar('open'),Pchar('update.exe'),Pchar('\runandfinish'),Pchar(ExtractFilePath(ParamStr(0))),SW_SHOW);

end.
