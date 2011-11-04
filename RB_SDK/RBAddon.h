/* RBAddon.h */



#ifdef RBADDON_EXPORTS
#define RBADDON_API  extern "C" __declspec( dllexport )  
//__declspec(dllexport)
#else
#define RBADDON_API __declspec(dllimport)
#endif



#include "windows.h"

#include "RBAddonInterface.h"

// version of this Addon
#define ThisAddonVersionNumber "0.0"


class CRBAddon
{
	public:
	
		RBAddonIn m_AddonIn;
		CRBAddon();
		~CRBAddon();

		BOOL Run();

};


RBADDON_API BOOL RBAddonInit(PRBAddonIn _addonIn, PRBAddonOut _addonOut);

RBADDON_API BOOL RBAddonRun(void);



