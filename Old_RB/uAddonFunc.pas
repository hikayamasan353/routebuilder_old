unit uAddonFunc;

interface

uses sysutils, classes,
     RBAddonInterface,
     uGlobaldef,
     forms,
     toptions,
     tmain,
     strutils;

function RBAddonFunction(const command:word ): pchar;   stdcall;
procedure InitRBAddonInRecord(var inrec:RBAddonIn); 

var RBAResultBuffer: string[255];

implementation

uses uRBProject;

// Funktion: RBAddonFunction
// Autor   : up
// Datum   : 6.1.03
// Beschr. : zentrale Addon-Funktion. Gibt Zeiger auf C-String zurück abh. von command.
// Hinweis : Der Zeiger, auf den result zeigt, muss auf reservierten Speicher zeigen.
// dazu dient der RBAResultBuffer in dieser Unit.
function RBAddonFunction(const command:word ): pchar; stdcall;
begin
  case command of
    RBAGetRBVersion:  result := pchar(VersionString+#0);
    RBAGetCurrentProjectName:
    begin
      RBAResultBuffer := FormMain.FrmEditor.CurrentProject.Projectname+#0;
      result := pchar(@RBAResultBuffer[1]);
    end;
    RBAGetCurrentProjectAuthor:
    begin
      RBAResultBuffer := FormMain.FrmEditor.CurrentProject.Author+#0;
      result := pchar(@RBAResultBuffer[1]);
    end;
    RBAGetObjectLibraryPath:
    begin
      RBAResultBuffer := extractfilepath(application.exename)+formoptions.objectfolder+'\' +#0;
      result := pchar(@RBAResultBuffer[1]);
    end;
    RBAGetRbDirectory:        //v 1.1
    begin
      RBAResultBuffer:=ExtractFilePath(ParamStr(0));
      result := pchar(@RBAResultBuffer[1]);
    end;
    RBAGetProjectVariables_email: //v 1.1
    begin
      RBAResultBuffer:=FormMain.FrmEditor.CurrentProject.AuthorEmailAddress+#0;
      result:=pchar(@RBAResultBuffer[1]);
    end;
    RBAGetProjectVariables_description:  //v 1.1
    begin
      RBAResultBuffer:=FormMain.FrmEditor.CurrentProject.description+#0;
      result:=pchar(@RBAResultBuffer[1]);
    end;
    RBAGetProjectVariables_credits: //v 1.1
    begin
      RBAResultBuffer:=FormMain.FrmEditor.CurrentProject.credits+#0;
      result:=pchar(@RBAResultBuffer[1]);
    end;
    RBAGetProjectVariables_homepage:  //v 1.1
    begin
      RBAResultBuffer:=FormMain.FrmEditor.CurrentProject.homepageURL+#0;
      result:=pchar(@RBAResultBuffer[1]);
    end;
    RBAGetProjectVariables_projectfile: //v 1.1
    begin
      RBAResultBuffer:=FormMain.FrmEditor.CurrentProject.Projectfilename+#0;
      result:=pchar(@RBAResultBuffer[1]);
    end;
    RBAGetProjectVariables_logo: //v 1.1
    begin
      RBAResultBuffer:=FormMain.FrmEditor.CurrentProject.LogoPath+#0;
      result:=pchar(@RBAResultBuffer[1]);
    end;
  end;
end;

// Funktion: InitRBAddonInRecord
// Autor   : up
// Datum   : 6.1.03
// Beschr. : initialisiert den in-Record, der allen Addons beim deren Initialisierung
// übergeben wird (bzw. ein Zeiger darauf)
procedure InitRBAddonInRecord(var inrec:RBAddonIn);
begin
  inrec.RBAddonInVersion := RBAddonVersionNumber;
  inrec.RBAddonFunc := @RBAddonFunction;
end;

end.
