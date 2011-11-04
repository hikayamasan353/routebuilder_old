unit ri_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ri_progress, Registry, Inifiles, Shellapi, jpeg,
  ri_bvefolder;

const magic_string = '$RBPKG$';
      debugmode=false;
      find_start = 790000;

type
  TRouteinstaller_Main = class(TForm)
    Route_Name: TLabel;
    Route_Image: TImage;
    Route_Description: TLabel;
    Route_Author: TLabel;
    SetupBox: TGroupBox;
    Route_Homepage: TLabel;
    BvePath_Label: TLabel;
    BvePath_Edit: TEdit;
    Credits: TMemo;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Route_HomepageMouseEnter(Sender: TObject);
    procedure Route_HomepageMouseLeave(Sender: TObject);
    procedure InstallButtonClick(Sender: TObject);
    function GetTempFolder: String;
    procedure FormShow(Sender: TObject);
    procedure Route_HomepageClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

function IsPackagedFile: boolean;

var
  Routeinstaller_Main: TRouteinstaller_Main;
  RouteIni:TInifile;
  RouteRegistry:TRegistry;
  RouteDescriptionFile,RouteCreditsFile:TextFile;
  ActDir:String;
  splitpos,sizepos: int64;

implementation



{$R *.dfm}

function IsPackagedFile: boolean;
var f: TFilestream;
    p: integer;
    f1: string;
    buf: PChar;
begin
//  f1 := ChangeFileExt(application.exename,'.tmp');
  f1 := application.exename;
  //CopyFile(pchar(Application.exename),pchar(f1),false);
  f := TFilestream.Create(f1,fmOpenRead or fmShareDenyNone);
  if debugmode then MessageDlg(f1, mtWarning, [mbOK], 0);
  p := find_start;//f.Size-3;
  result := false;
  GetMem(buf,f.size);
  f.Position := 0;
  f.Read(buf^,f.size);

  for p := find_start to f.size-length(magic_string) do
  begin
    if 0=StrLComp(buf+p,pchar(magic_string),length(magic_string)) then
    begin
      if debugmode then MessageDlg('magic string found', mtWarning, [mbOK], 0);
      splitpos := strtointdef(buf+p+length(magic_string),-1);
      if debugmode then MessageDlg('splitpos='+inttostr(splitpos), mtWarning, [mbOK], 0);
      result := true;
      break;
    end;
  end;

  f.free;

  FreeMem(buf);

//  DeleteFile(f1);
end;


procedure TRouteinstaller_Main.FormCreate(Sender: TObject);
var tmp,tmp2,imgpath:string;
begin
{TODO:
-Installer testen & fertigstellen
}


     //Aktuelles Verzeichnis
     ActDir:=ExtractFilePath(Application.ExeName);

     //MessageDlg(actdir, mtWarning, [mbOK], 0);

     //Registry öffnen, um Bve-Pfad zu erstellen/ermitteln
     RouteRegistry:=TRegistry.Create;
     RouteRegistry.RootKey:=HKEY_LOCAL_MACHINE;
     RouteRegistry.OpenKey('Software\Routebuilder',true);
     if RouteRegistry.ReadString('Bve Folder')<>'' then
       BvePath_Edit.Text:=RouteRegistry.ReadString('Bve Folder')
     else
     begin
       with TRouteInstaller_BveFolder.create(self) do
       begin
//         LabelSelectedDir.caption := BvePath_edit.text;
         if ShowModal()=mrOK then
         begin
           BvePath_Edit.Text:= LabelSelectedDir.caption;
         end;
         free;
       end;
     end;

     //Ini öfnnen
     if fileexists(ActDir+'route.ini') then
       RouteIni:=TInifile.Create(ActDir+'route.ini')
     else
     begin
       MessageDlg('Problems during reading ini file ' + ActDir+'route.ini.'
       +' The program won''t continue.',mtError,[mbOk],0);
       Application.Terminate;
     end;

     //Beschreibung öffnen
     if fileexists(ActDir+'description.dat') then
     begin
       with TStringlist.create do
       begin
         loadfromfile(ActDir+'description.dat');
         tmp := text;
         free;
       end;
     end
     else
     begin
       MessageDlg('Problems during reading description file ' + ActDir+'description.dat.'
       +' The program won''t continue.',mtError,[mbOk],0);
       Application.Terminate;
     end;


     if fileexists(ActDir+'credits.dat') then
     begin
       with TStringlist.create do
       begin
         loadfromfile(ActDir+'credits.dat');
         tmp2 := text;
         Credits.Lines.text := tmp2;
         free;
       end;
     end
     else
     begin
       MessageDlg('Problems during reading credits file ' + ActDir+'credits.dat.'
       +' The program won''t continue.',mtError,[mbOk],0);
       Application.Terminate;
     end;



     //Werte zuweisen
     Route_Name.Caption:=RouteIni.ReadString('Route','Name','Unknown route');
//     if not fileexists(ActDir+'noscreen.bmp') then

     imgpath := ActDir+'\'+extractfilename(RouteIni.ReadString('Route','Image','noscreen.bmp'));
     if fileexists(imgpath) then
       Route_Image.Picture.LoadFromFile(imgpath);
  //   else
    //   Route_Image.Picture.Bitmap.LoadFromFile(ActDir+'noscreen.bmp');




     Route_Description.Caption:=tmp;

     Route_Author.Caption:='by '+RouteIni.ReadString('Route','Author','Unknown');
     if RouteIni.ReadString('Route','Homepage','Unknown')<>'' then  Route_Homepage.Visible:=True; Route_Homepage.Caption:=RouteIni.ReadString('Route','Homepage','Unknown');


end;

procedure TRouteinstaller_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
RouteIni.Free;
RouteRegistry.Free;
//Routeinstaller_Install.CloseProgram;
end;

procedure TRouteinstaller_Main.Route_HomepageMouseEnter(Sender: TObject);
begin
Route_Homepage.Cursor:=crHandPoint;
Route_Homepage.Font.Style:=[fsUnderline];
end;

procedure TRouteinstaller_Main.Route_HomepageMouseLeave(Sender: TObject);
begin
Route_Homepage.Cursor:=crArrow;
Route_Homepage.Font.Style:=[];
end;

procedure TRouteinstaller_Main.InstallButtonClick(Sender: TObject);
begin

//Angegebenen Bve-Pfad in Registry schreiben
RouteRegistry.WriteString('Bve Folder',BvePath_Edit.Text);

with TRouteInstaller_Install.create(self) do
begin
 BVEFolder := BvePath_Edit.Text;
 Show;
 Application.ProcessMessages;
end;
 

//RouteInstaller_Install.CopyFiles;

end;

                
function TRouteinstaller_Main.GetTempFolder: String;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
//Funktion zum ermitteln des Tempörären Verzeichnisses
  GetTempPath(MAX_PATH, Buffer);
  Result := Buffer;
end;



procedure TRouteinstaller_Main.FormShow(Sender: TObject);
begin
  if not fileexists(BvePath_Edit.Text+'\bve.exe') then
    SpeedButton1Click(self);
  FocusControl(Button1);
end;

procedure TRouteinstaller_Main.Route_HomepageClick(Sender: TObject);
begin
ShellExecute(Handle,'open',PChar(Route_Homepage.Caption),nil,nil,SW_NORMAL);
end;

procedure TRouteinstaller_Main.SpeedButton1Click(Sender: TObject);
begin
 with TRouteInstaller_BveFolder.create(self) do
 begin
   LabelSelectedDir.caption := BvePath_edit.text;
   if ShowModal()=mrOK then
   begin
     BvePath_Edit.Text:= LabelSelectedDir.caption;
   end;
   free;
 end;
end;

end.
