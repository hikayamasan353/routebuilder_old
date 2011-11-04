/* RBAddonInterface.h */

#ifndef _RBAddonInterface__
#define _RBAddonInterface__

#define  RBAGetRBVersion 1
#define  RBAGetCurrentProjectName 2
#define  RBAGetCurrentProjectAuthor 3
#define  RBAGetCurrentLibraryPath 4
#define  RBAGetRbDirectory 5
#define  RBAGetProjectVariables_email  6;
#define  RBAGetProjectVariables_description 7;
#define  RBAGetProjectVariables_credits  8;
#define  RBAGetProjectVariables_homepage  9;
#define  RBAGetProjectVariables_projectfile  10;
#define  RBAGetProjectVariables_logo  11;


#define  RBAddonVersionNumber 2



typedef  const char * (_stdcall *RBAddonFuncType) ( const WORD AddonFunc);



typedef struct  { 
	WORD RBAddonInVersion;
	RBAddonFuncType RBAddonFunc;
} RBAddonIn;

typedef RBAddonIn *PRBAddonIn;

typedef struct  {
	char* AddonName;
	char* AddonAuthor;
	char* AddonVersion;
	char* AddonWebsite;
	char* AddonEmail;
	char* AddonDescription;
	char* AddonCopyright;
} RBAddonOut;

typedef RBAddonOut *PRBAddonOut;


#endif

