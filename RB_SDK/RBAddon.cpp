// RBAddon.cpp : main DLL code
//

#include "stdafx.h"
#include "RBAddon.h"

#include <string>

RBAddonIn AddonIn;
CRBAddon * pAddon;


BOOL APIENTRY DllMain( HANDLE hModule, 
                       DWORD  ul_reason_for_call, 
                       LPVOID lpReserved
					 )
{
    switch (ul_reason_for_call)
	{
		case DLL_PROCESS_ATTACH:
		case DLL_THREAD_ATTACH:
			pAddon = 0;
		case DLL_THREAD_DETACH:
		case DLL_PROCESS_DETACH:
			if (pAddon != 0) 
				delete pAddon;
			break;
    }
    return TRUE;
}




RBADDON_API BOOL RBAddonInit(PRBAddonIn _addonIn, PRBAddonOut _addonOut)
{

	pAddon = new CRBAddon;
	
	try
	{
		// copy AddonIn structure to object
		memcpy(&(pAddon->m_AddonIn),_addonIn,sizeof(RBAddonIn));

		if(_addonIn->RBAddonInVersion < RBAddonVersionNumber)
			return false;

		// fill AddonOut structure
		_addonOut->AddonName = "RBADummy C++";
		_addonOut->AddonAuthor = "Uwe Post";
		_addonOut->AddonCopyright = "RouteBuilder Development Team";
		_addonOut->AddonDescription = "Sample RB Addon developed in C/C++";
		_addonOut->AddonVersion = ThisAddonVersionNumber;
		_addonOut->AddonEmail = "not given";
		_addonOut->AddonWebsite = "none";
	}
	catch(...)
	{
		return false;
	}

	return true;

}

RBADDON_API BOOL RBAddonRun(void)
{
	if (pAddon != 0)
		return pAddon->Run();
	else
		return false;
}



//-------------------------------------------
// implementation of the CRBAddon class
//-------------------------------------------

// constructor, called once when RB initializes the Addon
CRBAddon::CRBAddon()
{;
}

// destructor, called when Addon is unloaded because RB terminates
CRBAddon::~CRBAddon()
{;
}

// main function, called when User executes Addon.
BOOL CRBAddon::Run()
{
	// example usage of RB Addon Interface callback

	// obtain current object library path
	// this has to be done here and not in initialization because it can change
	const char * path = m_AddonIn.RBAddonFunc(RBAGetCurrentLibraryPath);
	
	std::string s_ObjectlibraryPath;

	s_ObjectlibraryPath = std::string(path);

	s_ObjectlibraryPath = "The current Object Library Path is: " + s_ObjectlibraryPath;

	MessageBox(0,s_ObjectlibraryPath.c_str() ,"RBAddon Sample in C++",MB_ICONINFORMATION | MB_OK);
	return true;
}