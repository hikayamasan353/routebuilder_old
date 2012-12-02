/* RBAddonInterface */



#define RBAGetRBVersion  1
#define RBAGetCurrentProjectName 2
#define RBAGetCurrentProjectAuthor 3
#define RBAGetObjectLibraryPath  4

#define RBAddonVersionNumber 1

typedef  function(WORD w ) *char RBAddonFuncType;

typedef   *RBAddonFuncType PRBAddonFuncType;

typedef struct
{
     WORD RBAddonInVersion; /* should be RBAddonVersionNumber, if not, this structure may have changed */
     RBAddonFuncType RBAddonFunc;
} RBAddonIn;
  
typedef  *RBAddonIn PRBAddonIn;

typedef struct
{   
     char *AddonName;
     char *AddonAuthor;
     char *AddonVersion;
     char *AddonWebsite;
     char *AddonEmail;
     char *AddonDescription;
     char *AddonCopyright;
} RBAddonOut;

typedef  *RBAddonOut PRBAddonOut;

