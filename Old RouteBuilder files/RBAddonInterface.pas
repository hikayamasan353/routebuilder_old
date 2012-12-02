unit RBAddonInterface;

interface

const
   RBAGetRBVersion = 1;
   RBAGetCurrentProjectName = 2;
   RBAGetCurrentProjectAuthor = 3;
   RBAGetObjectLibraryPath = 4;
   RBAGetRbDirectory = 5;
   RBAGetProjectVariables_email = 6;
   RBAGetProjectVariables_description = 7;
   RBAGetProjectVariables_credits = 8;
   RBAGetProjectVariables_homepage = 9;
   RBAGetProjectVariables_projectfile = 10;
   RBAGetProjectVariables_logo = 11;

   RBAddonVersionNumber = 2;

type
   RBAddonFuncType= function(const what: Word ): pchar; stdcall;
   PRBAddonFuncType=^RBAddonFuncType;

   RBAddonIn=record
     RBAddonInVersion: word; // should be RBAddonVersionNumber, if not, this structure may have changed
     RBAddonFunc: RBAddonFuncType;
   end;
   PRBAddonIn=^RBAddonIn;

   RBAddonOut=record
     AddonName: PChar;
     AddonAuthor: PChar;
     AddonVersion: PChar;
     AddonWebsite: PChar;
     AddonEmail: PChar;
     AddonDescription: PChar;
     AddonCopyright: PChar;
   end;
   PRBAddonOut=^RBAddonOut;

implementation

end.
