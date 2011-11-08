//--------------------------------------------------------------------------------------------------------//
{
TBrowseFolder Component

Written by Todd Fast
Copyright © 1996-97 by Pencilneck Software. All rights reserved.
Version 1.0, lego 9-25-96
Version 2.0, lego 5-7-97
Version 2.1, lego 5-12-97
Version 2.2, lego 6-19-97


Description:

	Native Delphi component that encapsulates the SHBrowseForFolder interface, which allows
	Win32 users to select a directory using the standard shell dialog. In addition,
	TBrowseFolder allows the developer to add a custom button to the dialog. This feature
	allows you to extend the features of the shell and is found exclusively in this component.

Author:

	Todd Fast
	Please reach me at one of the following addresses if you have any questions, comments, or
	contributions.

	tfast@eden.com
	pencilneck@hotmail.com
	http://www.eden.com/~tfast/pencilneck.html


Constributors:

	Alin Flaider
	aflaidar@datalog.ro
	7-4-97 - Multiple instance update

	Ahto Tanner
	ahto@moonsoftware.ee
	http://www.moonsoftware.ee
	5-6-97 - Property editor and choice enhancement update
	6-19-97 - Support for custom button type (check box)

Distribution:

	This component is freeware.  As such, Pencilneck Software gives no warranty	to its accuracy,
	fitness for any particular use, effects of use, or reliability.  This	component may not be
	distributed as a part of another component package without Pencilneck	Software's written
	consent.  It may be freely distributed, although it must be distributed with all original
	files in their original format intact.  If you use this component in your software, please
	include an acknowledgment that portions are copyrighted by Pencilneck Software.  Please
	contact the author, Todd Fast, at one of the above addresses with questions, comments,
	bug-reports or any updates you make to the component.


Comments:

	This component wraps a few of the Win32 shell functions to display the Windows standard
	folder browse dialog. I originally hacked this component together over the course of a
	couple of evenings based on Microsoft's sketchy documentation and some of their C
	header files, and with some contributions and some free	time, have since improved it to
	be the most flexible component of its type available.


Hints:

	- The SetStatusText, SetSelectionPIDL, SetSelectionPath, and EnableOK methods ecapsulate
	the messages you can send to the browse dialog while it is active (see the Microsoft
	docs on SHBrowseFolder for more information.) Use these functions from within the
	TBrowseFolder event handlers to make changes to the browse dialog instead of using
	SendMessage (although that would be perfectly acceptable, and this file defines all the
	constants you would need.)

	- TUse the SHGetFileInfo function to retrieve extended information about the selected folder.
	You can also use the ImageIndex and DisplayName properties of the component for additional
	information.

	- TFor more information, lookup SHBrowseForFolder, BROWSEINFO, and BrowseCallbackProc in the
	Win32 online help.

	- TBeware! The Microsoft documentation on these functions shipped with Delphi is not entirely
	accurate. In most cases, they've reversed the location of certain parameters sent to the
	callback function or of messages you can send to the browse dialog. Compare my implementation
	below with the documentation for more information.
}
//--------------------------------------------------------------------------------------------------------//


// Note: Comment this line if you are using Delphi 2
{$DEFINE DELPHI3}

unit BrowseFolder1;

interface

uses
{$IFDEF DELPHI3}
  Windows, Messages, Classes, Forms, Dialogs, SysUtils, ActiveX, Shlobj, FileCtrl, Controls, Graphics, ShellAPI;
{$ELSE}
  Windows, Messages, Classes, Forms, Dialogs, SysUtils, Ole2, Shlobj, FileCtrl, Controls, Graphics, ShellAPI;
{$ENDIF}

type
	TBrowseInfoFlags=(bfFileSysDirsOnly,bfDontGoBelowDomain,bfStatusText,bfFileSysAncestors,bfBrowseForComputer,bfBrowseForPrinter);
  TBrowseInfoFlagSet=set of TBrowseInfoFlags;

  TCustomButtonType=(btPushButton, btCheckBox);

	TSHFolders=(foDesktop,foDesktopExpanded,foPrograms,foControlPanel,foPrinters,foPersonal,foFavorites,foStartup,foRecent,
		foSendto,foRecycleBin,foStartMenu,foDesktopDirectory,foMyComputer,foNetwork,foNetworkNeighborhood,
		foFonts,foTemplates);

const
	NUMBER_OF_BROWSE_INFO_FLAGS=6;
	BROWSE_FLAG_ARRAY: array[TBrowseInfoFlags] of Integer=
		(BIF_RETURNONLYFSDIRS,BIF_DONTGOBELOWDOMAIN,BIF_STATUSTEXT,BIF_RETURNFSANCESTORS,
		BIF_BROWSEFORCOMPUTER,BIF_BROWSEFORPRINTER);

	SH_FOLDERS_ARRAY: array[TSHFolders] of Integer=
		(CSIDL_DESKTOP,-1 {foDesktopExpanded, which is not a flag supported by the shell},
		CSIDL_PROGRAMS,CSIDL_CONTROLS,CSIDL_PRINTERS,CSIDL_PERSONAL,CSIDL_FAVORITES,
		CSIDL_STARTUP,CSIDL_RECENT,CSIDL_SENDTO,CSIDL_BITBUCKET,CSIDL_STARTMENU,CSIDL_DESKTOPDIRECTORY,
		CSIDL_DRIVES,CSIDL_NETWORK,CSIDL_NETHOOD,CSIDL_FONTS,CSIDL_TEMPLATES);

type
	TBrowseFolder=class;

	{Browser notification events}
  TBrowserInitializedEvent=procedure(Sender: TBrowseFolder; DialogHandle: HWND) of object;
  TSelectionChangedEvent=procedure(Sender: TBrowseFolder; DialogHandle: HWND; const ItemIDList: PItemIDList; const Directory: String) of object;
  TCustomButtonClickEvent=procedure(Sender: TBrowseFolder; DialogHandle: HWND) of object;

	{TBrowseFolder}
  TBrowseFolder = class(TComponent)
  private
		FDialogHandle: HWnd;
		FCustomButtonHandle: HWnd;
		FTitle: String;
		FParentHandle: HWnd; // Added by Atoh Tanner
		FDisplayName: String;
		FImageIndex: Integer;
		FDirectory: String;
		FSelectedDirectory: String;
		FFlags: TBrowseInfoFlagSet;
		FShowPathInStatusArea: Boolean;
		FRootFolder: TSHFolders;
		FCustomButtonVisible: Boolean;
		FCustomButtonEnabled: Boolean;
		FCustomButtonCaption: String;
		FCustomButtonWidth: Integer;
    FCustomButtonType: TCustomButtonType;
    FCustomButtonChecked: Boolean;
		FSyncCustomButton: Boolean;
		FOnInitialized: TBrowserInitializedEvent;
		FOnSelectionChanged: TSelectionChangedEvent;
		FOnCustomButtonClick: TCustomButtonClickEvent;
		procedure SetCustomButtonCaption(Value: String);
		procedure SetCustomButtonEnabled(Value: Boolean);
		procedure SetCustomButtonWidth(Value: Integer);
		procedure SetSelectedDirectory(Value: String);
  public
		constructor Create(AOwner: TComponent); override;
		function Execute: Boolean;
		procedure SetStatusText(const Hwnd: HWND; const StatusText: String);
		procedure SetSelectionPIDL(const Hwnd: HWND; const ItemIDList: PItemIDList);
		procedure SetSelectionPath(const Hwnd: HWND; const Path: String);
    procedure EnableOK(const Hwnd: HWND; const Value: Boolean);
		property DisplayName: String read FDisplayName;
		property ImageIndex: Integer read FImageIndex;
		property ParentHandle: HWnd read FParentHandle write FParentHandle; // Added by Atoh Tanner
		property DialogHandle: HWnd read FDialogHandle write FDialogHandle;
		property CustomButtonHandle: HWnd read FCustomButtonHandle write FCustomButtonHandle;
		property SelectedDirectory: String read FSelectedDirectory write SetSelectedDirectory;
  published
		property Directory: String read FDirectory write FDirectory;
		property Title: String read FTitle write FTitle;
		property Flags: TBrowseInfoFlagSet read FFlags write FFlags;
		property ShowPathInStatusArea: Boolean read FShowPathInStatusArea write FShowPathInStatusArea;
		property RootFolder: TSHFolders read FRootFolder write FRootFolder default foDesktopExpanded;
		property CustomButtonVisible: Boolean read FCustomButtonVisible write FCustomButtonVisible default FALSE;
		property CustomButtonEnabled: Boolean read FCustomButtonEnabled write SetCustomButtonEnabled default TRUE;
		property CustomButtonCaption: String read FCustomButtonCaption write SetCustomButtonCaption;
		property CustomButtonWidth: Integer read FCustomButtonWidth write SetCustomButtonWidth default 75;
    property CustomButtonType: TCustomButtonType read FCustomButtonType write FCustomButtonType default btPushButton;
    property CustomButtonChecked: Boolean read FCustomButtonChecked write FCustomButtonChecked default FALSE;
		property SyncCustomButton: Boolean read FSyncCustomButton write FSyncCustomButton;
		property OnInitialized: TBrowserInitializedEvent read FOnInitialized write FOnInitialized;
		property OnSelectionChanged: TSelectionChangedEvent read FOnSelectionChanged write FOnSelectionChanged;
		property OnCustomButtonClick: TCustomButtonClickEvent read FOnCustomButtonClick write FOnCustomButtonClick;
  end;

{Utility functions}
function CompressString(const Path, Separator, Replacement: String; MaxLength: Integer): String;
function BreakApart(const theString, Separator: String; var Tokens: TStringList): Integer;
procedure GetIDListFromPath(Path: String; var ItemIDList: PItemIDList);

{Callback procedure; must be declared with stdcall since Windows will be calling it}
procedure BrowserCallbackProc(HWindow: HWND; uMsg: Integer; lParameter: LPARAM; lpBrowseFolder: LPARAM); stdcall;

{Custom window procedure that we use to replace the default dialog window procedure.  This
lets us intercept window messages that otherwise we would never be able to capture, like
WM_COMMAND.}
function CustomWndProc(HWindow: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;

{Note: The following function is alluded to in the Shlobj.pas file, but no record of it exists.
Instead, I use the CoTaskMemFree call to free any pidl's.  From what I can tell, this should be
an equivalent call, since the Windows docs say that some of the task allocator API's are just
quick calls to the OLE2 functions.  This should be one of them.}
// function SHFree(ItemIDList: PItemIDList): HRESULT; external 'SHELL32.dll' name 'SHFree';

procedure Register;

implementation

//uses DsgnIntf;

	{Design-time testing by Double-clicking or from popup menu take Test}
	{Added by Ahto Tanner}

const
	CUSTOM_BUTTON_ID=255;
	MAX_PATH_DISPLAY_LENGTH=35;




//--------------------------------------------------------------------------------------------------------//
procedure Register;
begin
  RegisterComponents('Dialogs', [TBrowseFolder]);
end;







// Utility functions
//--------------------------------------------------------------------------------------------------------//
{Compresses a string by replacing one or more components with the replacement string}
function CompressString(const Path, Separator, Replacement: String; MaxLength: Integer): String;
var
	Tokens: TStringList;

	function BuildPath(const Components: TStringList): String;
	var
		i: Integer;
	begin
		for i:=0 to Components.Count-1 do
			if i=0 then
				Result:=Components[i]
			else
				Result:=Result+Separator+Components[i];
	end;

begin
	try
		Tokens:=TStringList.Create;

		{Check if full path is less than MaxLength}
		Result:=Path;
		if StrLen(PChar(Result))<=MaxLength then
			Exit;

		{Check if can replace the 2nd token with the replacement and make length less than MaxLength}
		if BreakApart(Result,Separator,Tokens)<3 then
			Exit
		else
			begin
				Tokens[1]:=Replacement;
				Result:=BuildPath(Tokens);
			end;

		{Must continue to delete components until can get the length below the maximum}
		while (StrLen(PChar(Result))>MaxLength) and (Tokens.Count>3) do
			begin
				Tokens.Delete(2);
				Result:=BuildPath(Tokens);
			end;
	finally
		Tokens.Free;
	end;
end;

//--------------------------------------------------------------------------------------------------------//
{Breaks a string into tokens at the specified separator string}
function BreakApart(const theString, Separator: String; var Tokens: TStringList): Integer;
var
  Index: Integer;
	CurrentString: String;
	CurrentToken: String;
	Done: Boolean;
begin
	Result:=0;
	CurrentString:=theString;
	Done:=FALSE;
	Tokens.Clear;

	repeat
		{Find the first separator in the string}
		Index:=Pos(Separator,CurrentString);

 		{If separator not found, we are done}
		if Index=0 then
			begin
				{Last token is whatever string is left}
				CurrentToken:=CurrentString;
        Done:=TRUE;
  		end
		else
			begin
				{Get token and chop off the beginning}
				CurrentToken:=Copy(CurrentString,1,Index-1);
				CurrentString:=Copy(CurrentString,Index+1,Length(CurrentString)-Index);
      end;

		{Add the token to the string list}
		Tokens.Add(CurrentToken);
		Inc(Result);

  until Done;
end;




// TBrowseFolder support functions
//--------------------------------------------------------------------------------------------------------//
{Center the given window on the Foreground window  - Added by Manuel Duarte}
{Modifed by Todd Fast to place the top of the dialog at visual center of main window}
procedure CenterWindow(HWindow: HWND);
var
  Rect: TRect;
  FWRect: TRect;
  ForegroundWindow : HWND;
begin
  ForegroundWindow:=GetForegroundWindow;
  GetWindowRect(HWindow,Rect);
  GetWindowRect(ForegroundWindow,FWRect);
  SetWindowPos(HWindow,0,
		(FWRect.Left+(FWRect.Right-FWRect.Left) div 2)-(Rect.Right-Rect.Left) div 2,
		FWRect.Top+((FWRect.Bottom-FWRect.Top) div 4),
		0,0,SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
end;


//--------------------------------------------------------------------------------------------------------//
{This procedure compliments SHGetPathFromIDList in the Win32 API, and allows you to obtain a PIDL
from a path string.}
procedure GetIDListFromPath(Path: String; var ItemIDList: PItemIDList);
var
	ShellFolderInterface: IShellFolder;
	CharsParsed: ULONG;
	Attributes: ULONG;
begin
	// Get a pointer to the/an IShellFolder interface.  The easiest way to do this is
	// to use SHGetDesktopFolder
	if SHGetDesktopFolder(ShellFolderInterface)=NOERROR then
		try
			// Generate a PIDL from the given path name
			// Don't forget, you'll need to free the ItemIDLIst using	CoTaskMemFree(ItemIDList)
			if DirectoryExists(Path) then
				ShellFolderInterface.ParseDisplayName(0,nil,StringToOleStr(Path),CharsParsed,ItemIDList,Attributes);
		finally
			// Release the interface.  Always necessary with COM interfaces.
      {$IFDEF DELPHI3}
  		ShellFolderInterface._Release;
      {$ELSE}
   		ShellFolderInterface.Release;
      {$ENDIF}
		end;
end;


//--------------------------------------------------------------------------------------------------------//
procedure AddCustomControls(HWindow: HWND; Instance: TBrowseFolder);
var
	ButtonWindowHandle: HWND;
	TempFont: TFont;
  ControlCreateStyles: Integer;
  ControlWidth: Integer;
begin
	// Create the custom button
  ControlCreateStyles := WS_CHILD or WS_CLIPSIBLINGS or WS_VISIBLE or WS_TABSTOP;
  if Instance.FCustomButtonType = btCheckBox then
    ControlCreateStyles:=ControlCreateStyles or BS_AUTOCHECKBOX
  else
    ControlCreateStyles:=ControlCreateStyles or BS_PUSHBUTTON;

  ButtonWindowHandle:=CreateWindow('BUTTON',PChar(Instance.CustomButtonCaption),
    ControlCreateStyles,12,270,Instance.CustomButtonWidth,23,HWindow,CUSTOM_BUTTON_ID,HInstance,nil);

	// Ensure the button's font is the default system font
  try
		TempFont:=TFont.Create;
	  PostMessage(ButtonWindowHandle,WM_SETFONT,Longint(TempFont.Handle),MAKELPARAM(1,0));
	finally
		TempFont.Free;
	end;

  EnableWindow(ButtonWindowHandle,Instance.CustomButtonEnabled);
  if Instance.CustomButtonType = btCheckBox then
    CheckDlgButton(HWindow, CUSTOM_BUTTON_ID, Ord(Instance.CustomButtonChecked));

	// Replace the dialog's window procedure with our custom window procedure
	SetWindowLong(HWIndow,GWL_WNDPROC,Longint(@CustomWndProc));

	Instance.CustomButtonHandle:=ButtonWindowHandle;
end;


//--------------------------------------------------------------------------------------------------------//
{This custom window procedure lets us intercept any messages that the dialog receives and
process any messages we need to (like a button click).  After doing its own custom processing,
it passes the call through to the default dialog procedure.}
function CustomWndProc(HWindow: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
	Instance: TBrowseFolder;
begin
	// Get the instance of the TBrowseFolder we're working with from the
	// extra window data set in BrowserCallbackProc
	Instance:=TBrowseFolder(GetWindowLong(HWindow,GWL_USERDATA));

  // if user wants checkbox, update our checked state property
  if (Msg=WM_COMMAND) and (Lo(wParam)=IDOK) then
    if Instance.FCustomButtonType=btCheckBox then
      begin
        Instance.FCustomButtonChecked:=Boolean(IsDlgButtonChecked(HWindow,CUSTOM_BUTTON_ID));
        Result:=DefDlgProc(HWindow,Msg,wParam,lParam);
        Exit;
      end;

	// Intercept our custom button's click events
	if (Msg=WM_COMMAND) and (Lo(wParam)=CUSTOM_BUTTON_ID) then
		begin
			// Show the current directory if in design mode
			if csDesigning in Instance.ComponentState then
				MessageDlg('Current directory is '+Instance.SelectedDirectory,mtInformation,[mbOK],0)
			else
			// Otherwise, execute the user's code
			if Assigned(Instance.OnCustomButtonClick) then
				Instance.OnCustomButtonClick(Instance,HWindow);

			Result:=0;
		end
	else
		// Pass the processing on to the default dialog procedure
		Result:=DefDlgProc(HWindow,Msg,wParam,lParam);
end;


//--------------------------------------------------------------------------------------------------------//
{Callback procedure; Windows calls this procedure upon certain events in the browse dialog.  This fucntion
calls any defined event handlers for the associated TBrowseFolder instance.}
procedure BrowserCallbackProc(HWindow: HWND; uMsg: Integer; lParameter: LPARAM; lpBrowseFolder: LPARAM);
var
	Instance: TBrowseFolder;
	Path: String;
	ValidPath: Boolean;
	TempPath: array[0..MAX_PATH] of Char; // To avoid some odd problems I've encountered casting strings as PChar's.  Sometimes, cast values do not contain the correct text
begin
	// Get the current instance from the lpData pointer that was saved in
	// the Execute method
	Instance:=TBrowseFolder(lpBrowseFolder);

	// Process the standard dialog messages
	case uMsg of

		BFFM_INITIALIZED:
	    begin
				Instance.DialogHandle:=HWindow;
  	  	CenterWindow(HWindow); {Added by Manuel Duarte}

				// Save the pointer to the BrowseFolder instance with the window
				SetWindowLong(HWindow,GWL_USERDATA,lpBrowseFolder);

				// Set the initial path
				if DirectoryExists(Instance.Directory) then
					Instance.SetSelectionPath(HWindow,Instance.Directory);

      	// Show the custom button
				if Instance.CustomButtonVisible then
					AddCustomControls(HWindow,Instance);

	   		// Fire the user event
				if Assigned(Instance.OnInitialized) then
					Instance.OnInitialized(Instance,HWindow);
	    end;

		BFFM_SELCHANGED:
			begin
				// Set the directory path
				SHGetPathFromIDList(PItemIDList(lParameter),TempPath);

				// Allow the user to read the currently selected path from the
				// OnSelectionChange event
				Instance.FSelectedDirectory:=StrPas(TempPath);

				if Instance.ShowPathInStatusArea then
					begin
						SetLength(Path,MAX_PATH);
						Path:=CompressString(StrPas(TempPath),'\','...',MAX_PATH_DISPLAY_LENGTH);
						SendMessage(HWindow,BFFM_SETSTATUSTEXT,0,Longint(PChar(Path)));
					end;

				// {Added by Atoh Tanner}
				// here is bux-fix to the problem, when you want to enable OK
				// button only on FileSysDirs. But by default while selecting
				// computer name in Network neighbourhood, then it enables OK, but
				// returns nothing. This hack disables OK button if not valid
				// item is selected. I didn't spend time on global FFlags,
				// so it manages with button every time. I always want only filesysdirs ;)
				//if not (bfFileSysDirsOnly in FFlags) then
				ValidPath:=SHGetPathFromIDList(PItemIDList(lParameter),TempPath);
				Instance.EnableOK(HWIndow,ValidPath);

    		// Fire the user event
				if Assigned(Instance.OnSelectionChanged) then
					Instance.OnSelectionChanged(Instance,HWindow,PItemIDList(lParameter),Instance.SelectedDirectory);
			end;
	end;
end;




// TBrowseFolder implementation
//--------------------------------------------------------------------------------------------------------//
constructor TBrowseFolder.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	SetLength(FDisplayName,MAX_PATH);
	SetLength(FDirectory,MAX_PATH);
  FParentHandle:=0;
	FRootFolder:=foDesktopExpanded;
	FCustomButtonVisible:=FALSE;
	FCustomButtonEnabled:=TRUE;
	FCustomButtonWidth:=75;
  FCustomButtonType:=btPushButton;
  FFlags:=[bfFileSysDirsOnly, bfStatusText];
	FDirectory:='';
	FSelectedDirectory:='';
end;

//--------------------------------------------------------------------------------------------------------//
{Use this function to set the status text of the browse dialog from within one of the TBrowseFolder event handlers}
procedure TBrowseFolder.SetStatusText(const Hwnd: HWND; const StatusText: String);
begin
	SendMessage(Hwnd,BFFM_SETSTATUSTEXT,0,Longint(PChar(StatusText)));
end;

//--------------------------------------------------------------------------------------------------------//
{Use this function to set the selection of the browse dialog manually from within one of the TBrowseFolder event handlers}
procedure TBrowseFolder.SetSelectionPIDL(const Hwnd: HWND; const ItemIDList: PItemIDList);
begin
	SendMessage(Hwnd,BFFM_SETSELECTION,Ord(FALSE),Longint(ItemIDList));
end;

//--------------------------------------------------------------------------------------------------------//
{Use this function to set the selection of the browse dialog manually from within one of the TBrowseFolder event handlers}
procedure TBrowseFolder.SetSelectionPath(const Hwnd: HWND; const Path: String);
begin
	SendMessage(Hwnd,BFFM_SETSELECTION,Ord(TRUE),Longint(PChar(Path)));
end;

//--------------------------------------------------------------------------------------------------------//
{Use this function to enable/disable the OK button of the browse dialog from within one of the TBrowseFolder event handlers}
procedure TBrowseFolder.EnableOK(const Hwnd: HWND; const Value: Boolean);
begin
	SendMessage(Hwnd,BFFM_ENABLEOK,0,Ord(Value));

	// If we should, disable/enable the custom button in sync with the OK button
	if SyncCustomButton then
		CustomButtonEnabled:=Value;
end;

//--------------------------------------------------------------------------------------------------------//
{Use this function to enable/disable the custom button of the browse dialog from within one of the TBrowseFolder event handlers}
procedure TBrowseFolder.SetCustomButtonEnabled(Value: Boolean);
begin
	FCustomButtonEnabled:=Value;
	if (IsWindow(CustomButtonHandle)) then
  	EnableWindow(CustomButtonHandle,Value);
end;

//--------------------------------------------------------------------------------------------------------//
{Use this function to enable/disable the custom button of the browse dialog from within one of the TBrowseFolder event handlers}
procedure TBrowseFolder.SetCustomButtonCaption(Value: String);
begin
	FCustomButtonCaption:=Value;
	if (IsWindow(CustomButtonHandle)) then
  	SetWindowText(CustomButtonHandle,PChar(Value));
end;

//--------------------------------------------------------------------------------------------------------//
{Use this function to enable/disable the custom button of the browse dialog from within one of the TBrowseFolder event handlers}
procedure TBrowseFolder.SetCustomButtonWidth(Value: Integer);
begin
	if Value<=0 then
		FCustomButtonWidth:=75
  else
		FCustomButtonWidth:=Value;
end;

//--------------------------------------------------------------------------------------------------------//
procedure TBrowseFolder.SetSelectedDirectory(Value: String);
begin
	SetSelectionPath(DialogHandle,Value);
end;

//--------------------------------------------------------------------------------------------------------//
{Use this function to show the browse dialog}
function TBrowseFolder.Execute: Boolean;
var
	BrowseInfo: TBrowseInfo;
	ItemIDList: PItemIDList;		// Pointer to a file ID list (PIDL)
	i: Integer;
	TempPath: array[0..MAX_PATH] of Char; // To avoid some odd problems I've encountered casting strings as PChar's
begin
	try
		{Init the BrowseInfo structure}
		// Added by Atoh Tanner
		if IsWindow(FParentHandle) then   // Pass 0 if want owner handle
			BrowseInfo.hwndOwner:=FParentHandle
		else
		if (Owner is TWinControl) then
			BrowseInfo.hwndOwner:=TWinControl(Owner).Handle
		else
			BrowseInfo.hwndOwner:=Application.MainForm.Handle;

		{Get the pointer to the appropriate folder pidl as the root}
		// Added by Atoh Taner
		// If root is NIL, it shows MyComputer expanded so both drives and network stuff are visible.
		// This is default Desktop, but I don't know why SHGetSpecialFolderLocation retrieves poor PIDL, so
		// it doesn't collapse tree. It's nice if it is expanded.  :)
		if FRootFolder=foDesktopExpanded then
			BrowseInfo.pidlRoot:=nil
		else
			SHGetSpecialFolderLocation(Application.Handle,SH_FOLDERS_ARRAY[FRootFolder],BrowseInfo.pidlRoot);

		BrowseInfo.pszDisplayName:=PChar(FDisplayName);
		BrowseInfo.lpszTitle:=PChar(FTitle);

		{OR all the flags together}
		BrowseInfo.ulFlags:=0;
		for i:=0 to NUMBER_OF_BROWSE_INFO_FLAGS-1 do
			if TBrowseInfoFlags(i) in FFlags then
				BrowseInfo.ulFlags:=BrowseInfo.ulFlags or BROWSE_FLAG_ARRAY[TBrowseInfoFlags(i)];

		BrowseInfo.lpfn:=@BrowserCallbackProc;
		BrowseInfo.lParam:=Longint(Self);
		BrowseInfo.iImage:=0;

		{Browse; return is nil if user cancels}
		ItemIDList:=SHBrowseForFolder(BrowseInfo);
		Result:=ItemIDList<>nil;
		if Result then
			begin
				SHGetPathFromIDList(ItemIDList,TempPath);
				FDirectory:=StrPas(TempPath);
				FSelectedDirectory:=FDirectory;
				FImageIndex:=BrowseInfo.iImage;
			end;

	finally
		{Free the ID lists with the system task allocator}
		CoTaskMemFree(ItemIDList);
		CoTaskMemFree(BrowseInfo.pidlRoot);
	end;
end;

end.
