; -- RB - SETUP Vollversion--
; geschrieben von Uwe Post 2002-3

[Setup]
MinVersion=4,4
AppName=RouteBuilder 1.4.2
Outputbasefilename=routebuilder14-setup
;compresslevel=9
AppVerName=RouteBuilder 1.4
AppId=routebuilder1
AppCopyright=Copyright © 2002-2005 Uwe Post, Thomas Tschofenig
;MessagesFile=compiler:German-2.isl
AdminPrivilegesRequired=no
;AlwaysCreateUninstallIcon=yes
AlwaysUsePersonalGroup=yes
AppMutex=RB1
AppPublisher=Uwe Post
AppPublisherURL=http://routebuilder.bve-routes.com/
AppVersion=1.4.2 (2005-06-05)
ChangesAssociations=yes
CreateAppDir=yes
;nur Vollversion ==>
CreateUninstallRegKey=yes	
DefaultGroupName=RouteBuilder for BVE
DisableStartupPrompt=yes
DirExistsWarning=yes
;in Update eine andere ==>
;InfoAfterFile=readme.txt
;nur in der Vollversion ==>
AlwaysRestart=no
WizardImageFile=rb14.bmp
WizardStyle=modern
UninstallStyle=modern
Uninstallable=yes
DefaultDirName={pf}\RouteBuilder

[Run]
Filename: "{app}\rb1.exe"; Description: "Run RouteBuilder now"; Flags: postinstall

[Tasks]
Name: desktopicon; Description: "Add Desktop Icon"; GroupDescription: "Options"
Name: associate; Description: "link .RBP files to RouteBuilder"; GroupDescription: "Options";

[Dirs]
Name: {app}\addons
Name: {app}\projects
Name: {app}\packages
Name: {app}\routeinstaller
Name: {app}\regions

[Files]
;main files
Source: "rb1.exe"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "delzip179.dll"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "RouteBuilder Manual.pdf"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "tutorial1.rbp"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "tutorial2.rbp"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "tutorial3.rbp"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "howto*.rbp"; DestDir: "{app}\projects"; CopyMode: alwaysoverwrite
Source: "regions\*.rbr"; DestDir: "{app}\regions"; CopyMode: alwaysoverwrite
Source: "inet_update.cfg"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "tr_straight.bmp"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "default.lru"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "trackdef.dat"; DestDir: "{app}"; CopyMode: onlyifdoesntexist
Source: "license.txt"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "english.lng"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "deutsch.lng"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "italiano.lng"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "tchinese.lng"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "japanese.lng"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "french.lng"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "cymraeg.lng"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "dutch.lng"; DestDir: "{app}"; CopyMode: alwaysoverwrite
;Source: "README-beta.txt"; DestDir: "{app}"; CopyMode: alwaysoverwrite
;DLLs
Source: "vcl60.bpl"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "vclx60.bpl"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "rtl60.bpl"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "vclshlctrls60.bpl"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "vclsmp60.bpl"; DestDir: "{app}"; CopyMode: alwaysoverwrite

;routeinstaller
Source: "routeinstaller\routeinstaller.exe"; DestDir: "{app}\routeinstaller"; CopyMode: alwaysoverwrite

;update
Source: "update.exe"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "restartupdate.exe"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "update_settings.dat"; DestDir: "{app}"; CopyMode: alwaysoverwrite

;addons
Source: "addons\rbaswitch.dll"; DestDir: "{app}\addons"; CopyMode: alwaysoverwrite
Source: "addons\rbastationsigns.dll"; DestDir: "{app}\addons"; CopyMode: alwaysoverwrite
Source: "addons\rbacylindercreator.dll"; DestDir: "{app}\addons"; CopyMode: alwaysoverwrite

;3D  (->app Verz., wegen erford. Admin.Rechte nicht nach win\sys)
Source: "3dstate3.dll"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "3d\floor.wld"; DestDir: "{app}\3d"; CopyMode: alwaysoverwrite
Source: "3d\bitmaps\grass3.bmp"; DestDir: "{app}\3d\bitmaps"; CopyMode: alwaysoverwrite


;object library
Source: "lib\backgrounds\*"; DestDir: "{app}\lib\backgrounds"; CopyMode: onlyifdoesntexist
Source: "lib\bridges\*"; DestDir: "{app}\lib\bridges"; CopyMode: alwaysoverwrite
Source: "lib\buildings\*"; DestDir: "{app}\lib\buildings"; CopyMode: alwaysoverwrite
Source: "lib\fences\*"; DestDir: "{app}\lib\fences"; CopyMode: alwaysoverwrite
Source: "lib\grounds\*"; DestDir: "{app}\lib\grounds"; CopyMode: onlyifdoesntexist
Source: "lib\misc\*"; DestDir: "{app}\lib\misc"; CopyMode: alwaysoverwrite
Source: "lib\plants\*"; DestDir: "{app}\lib\plants"; CopyMode: alwaysoverwrite
Source: "lib\platforms\*"; DestDir: "{app}\lib\platforms"; CopyMode: onlyifdoesntexist
Source: "lib\poles\*"; DestDir: "{app}\lib\poles"; CopyMode: alwaysoverwrite
Source: "lib\roads\*"; DestDir: "{app}\lib\roads"; CopyMode: alwaysoverwrite
Source: "lib\signals\*"; DestDir: "{app}\lib\signals"; CopyMode: alwaysoverwrite
Source: "lib\signs\*"; DestDir: "{app}\lib\signs"; CopyMode: alwaysoverwrite
Source: "lib\tracks\*"; DestDir: "{app}\lib\tracks"; CopyMode: onlyifdoesntexist
Source: "lib\trains\*"; DestDir: "{app}\lib\trains"; CopyMode: alwaysoverwrite
Source: "lib\tunnels\*"; DestDir: "{app}\lib\tunnels"; CopyMode: alwaysoverwrite
Source: "lib\walls\*"; DestDir: "{app}\lib\walls"; CopyMode: onlyifdoesntexist




[Registry] 

Root: HKCR; SubKey: .rbp; ValueType: STRING; ValueData: RouteBuilder project; Flags: uninsdeletevalue; Tasks: associate
Root: HKCR; SubKey: RouteBuilder project; ValueType: STRING; ValueData: RouteBuilder project; Flags: uninsdeletevalue; Tasks: associate
Root: HKCR; SubKey: RouteBuilder project\Shell; ValueType: NONE; Flags: uninsdeletevalue; Tasks: associate
Root: HKCR; SubKey: RouteBuilder project\Shell\Open; ValueType: NONE; Flags: uninsdeletevalue; Tasks: associate
Root: HKCR; SubKey: RouteBuilder project\Shell\Open\Command; ValueType: STRING; ValueData: "{app}\rb1.exe ""%1"""; Flags: uninsdeletevalue; Tasks: associate
Root: HKCR; SubKey: RouteBuilder project\DefaultIcon; ValueType: STRING; ValueData: {app}\rb1.exe,0; Flags: uninsdeletevalue; Tasks: associate


[Icons]
Name: "{group}\RouteBuilder"; Filename: "{app}\rb1.exe"; WorkingDir: "{app}"; Comment: "RouteBuilder"
Name: "{userdesktop}\RouteBuilder"; Filename: "{app}\rb1.exe"; Tasks: desktopicon


