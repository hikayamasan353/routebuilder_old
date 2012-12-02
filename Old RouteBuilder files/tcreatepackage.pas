unit tcreatepackage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,
  uRBProject, FileCtrl;

type
  TFormCreatePackage = class(TForm)
    GroupBox1: TGroupBox;
    CreatePackage: TButton;
    ObjDirEdit: TLabeledEdit;
    RouteDirEdit: TLabeledEdit;
    ListBox1: TListBox;
    lStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CreatePackageClick(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure MakeFilelist(list: TStringlist; const path,prefix: string);
  public
    ObjectFileList: TStringList;
    RouteFileList: TStringList;
    ProjectToExport: TRBProject;
    id: integer;
    outputdir: string;
  end;

var
  FormCreatePackage: TFormCreatePackage;

implementation

uses tPackager, toptions;

{$R *.dfm}

procedure TFormCreatePackage.FormCreate(Sender: TObject);
begin
  outputdir:='';
  id:=0;
  Routefilelist := TStringlist.create;
  ObjectFileList := TStringlist.create;
end;

procedure TFormCreatePackage.CreatePackageClick(Sender: TObject);

begin
  if SelectDirectory('Select output directory...','',outputdir) then begin
  CreatePackage.Enabled := false;
  Screen.Cursor := crHourglass;
  ObjectFileList.clear();
  RouteFileList.clear();
  MakeFileList(ObjectFileList,FormOptions.BVE_Folder+'\railway\object\'+ ObjDirEdit.text,'');
  MakeFileList(RouteFileList,FormOptions.BVE_Folder+'\railway\route\'+RouteDirEdit.text,'');

  Listbox1.Items.AddStrings(ObjectFileList);
  Listbox1.Items.AddStrings(RouteFileList);

  FormPackage.ObjectFileList.assign(ObjectFileList);
  FormPackage.RouteFileList.assign(RouteFileList);
  FormPackage.ProjectModule := ProjectToExport;
  FormPackage.RouteSubDir   := RouteDirEdit.Text; 

  FormPackage.Show;
  FormPackage.CreatePackage(//leRoutefilename.text,
     ProjectToExport.Projectname,
     ProjectToExport.LogoPath,ProjectToExport.Author,
     ProjectToExport.HomepageURL,ProjectToExport.Description,
     ExtractFilePath(Application.ExeName),ProjectToExport.Credits,0,0);
  FormPackage.close;
  Screen.Cursor := crDefault;
  CreatePackage.Enabled := true;

  Close();
  end;
end;

procedure TFormCreatePackage.MakeFilelist(list: TStringlist; const path,prefix: string);
var
  sr: TSearchRec;
begin
  if FindFirst(path+'\*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if (sr.Attr and faDirectory) = 0 then
      begin
        if prefix<>'' then
          list.add(prefix+'\'+sr.name)
        else
          list.add(sr.name);
        lstatus.Caption := path+'\'+sr.name;
      end
      else
      begin
        if sr.name[1]<>'.' then
          MakeFilelist(list,path+'\'+sr.name,sr.name);
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;

end;

end.
