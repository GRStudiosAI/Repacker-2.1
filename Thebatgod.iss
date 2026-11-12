#define GameName "Batman Arkham Knight" ;Add Your Game Name
#define Repacked "By TheBatGOD"  ;Add Your Bus./Repacker Name
#define GameVerName "Batman Arkham Knight"
#define AppVersion "Cracked Version 2.0" ;Add Your Game Version
#define Copyright "GRStudiosAILLC(c)2025"   ;Add Your Copyright
#define AppURL "https://www.grepacksstudios.icu/"

#define NeedSize 33500    ;Add Your Game Totall Space
#define NeedMem 415     ;Add Your Game Minimum Space
#define Processor "1060"
#define VideoCard "128"
#define RAM "8000"
#define WinVerMajor "2"
#define WinVerMinor "1"
#define ServicePack "2"
#define SetupName "Batman Arkham Knight"
#define SetupOut "Output"
#define UninstallAssets "{commonpf}\GR Studios AI\Uninstall Assets\" + GameName

[Setup]
DisableWelcomePage=no
DisableDirPage=no
; Legacy ISDone and wizard DLLs require a 32-bit Setup process.
SetupArchitecture=x86
ArchitecturesAllowed=x64compatible
PrivilegesRequired=Admin
AppName={#GameName}
AppVerName={#GameVerName}
AppPublisher={#Repacked}
AppVersion={#AppVersion}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
AppComments={#GameName}
DefaultDirName={commonpf64}\{#GameName}
VersionInfoDescription={#GameName}
DefaultGroupName={#GameName}
OutputBaseFilename={#SetupName}
OutputDir={#SetupOut}
Compression=lzma2/ultra64
UsePreviousLanguage=no
SetupIconFile=InstallFiles\icon.ico
AppCopyright={#Copyright}
#ifdef Internal
DiskSpanning=yes
DiskSliceSize=906993073
SlicesPerDisk=5
#endif
#ifdef SIGNTOOL
SignTool=ispacksigntool
SignTool=ispacksigntool256
SignedUninstaller=yes
#endif


[Files]
Source: InstallFiles\*; Flags: dontcopy;
Source: Icons\*; Flags: dontcopy

Source: InstallFiles\WizardImage.jpg; DestDir: {#UninstallAssets}; Flags: ignoreversion; Attribs: hidden system
Source: InstallFiles\botva2.dll; DestDir: {#UninstallAssets}; Flags: ignoreversion; Attribs: hidden system
Source: InstallFiles\Button.png; DestDir: {#UninstallAssets}; Flags: ignoreversion; Attribs: hidden system
Source: InstallFiles\Tiger.cjstyles; DestDir: {#UninstallAssets}; Flags: ignoreversion; Attribs: hidden system
Source: InstallFiles\ISSkin.dll; DestDir: {#UninstallAssets}; Flags: ignoreversion; Attribs: hidden system
Source: InstallFiles\InnoCallback.dll; DestDir: {#UninstallAssets}; Flags: ignoreversion; Attribs: hidden system




[Icons]
Name: {group}\Batman Arkham Knight ; Filename: {app}\unins000.exe; WorkingDir: {app}; Check: CheckError
Name: {commondesktop}\Batman Arkham Knight ; Filename: {app}\Binaries\Win64\BatmanAK.exe; WorkingDir: {app}; Check: CheckError
Name: "{group}\{cm:ProgramOnTheWeb,{#GameName}}"; Filename: "{#AppURL}"
Name: "{group}\{cm:UninstallProgram,{#GameName}}"; Filename: "{uninstallexe}"


[Languages]
Name: eng; MessagesFile: compiler:Default.isl

[Messages]
eng.WinVersionTooLowError=The installer is not compatible with your operating system version.
eng.SetupWindowTitle={#GameName} {#Repacked}
eng.ExitSetupMessage=Are you sure you want to uninstall the game {#GameName}?
eng.SelectDirDesc=Where do you want to install the game {#GameName}?
eng.NoProgramGroupCheck2=Do not create a folder in the Start menu
eng.InstallingLabel=Please, Wait, while the game is installed on your computer.
eng.UninstallAppTitle=Removal
eng.UninstallAppFullTitle={#GameName}
eng.ConfirmUninstall=Do you really want to uninstall the game {#GameName}?
eng.UninstalledAll=A game {#GameName} has been completely removed from your computer.
eng.UninstalledMost=Deleting a game{#GameName} completed.%n%nSome items could not be deleted. You can remove them yourself.

eng.ButtonBack=< Back
eng.ButtonNext=Next >
eng.ButtonInstall=Install
eng.ButtonFinish=Finish
eng.ButtonWizardBrowse=Browse...

[CustomMessages]
eng.Welcome=Greetings
eng.System=System
eng.Catalogue=Catalog
eng.StartMenu=Start menu
eng.Task=Tasks
eng.Installing=Installation
eng.Uninstalling=Removal
eng.Finish=Completion
eng.Welcome1=Welcome to Game Setup Wizard%n{#GameName}
eng.Welcome2=The program will install the game {#GameName} on your computer.%n%nIt is recommended that you close antivirus packages and all other applications before continuing.%n%nClick Next to continue or Cancel to exit the installer.
eng.Requirements1=Checking system requirements
eng.Requirements2=The installer found the following prerequisites
eng.Requirements3=All components meet the requirements of the game.
eng.Requirements4=Components highlighted in red do not meet the requirements of the game.
eng.DeviceDriver=Device driver not found
eng.Processor=Processor
eng.VideoCard=Video Card
eng.SoundCard=Sound Card
eng.RAM=RAM
eng.OperationSystem=Operating System
eng.TotalSpace=Total Space :
eng.FreeSpace=Free Space :
eng.NeedSpace=Need Space :
eng.SelectTasksLabel=Select additional tasks that should be performed when installing the game, then click "Install".

eng.StartMenuLbl=Click "Install" to continue. If you want to select a different folder, click Browse.
eng.TasksName=Choose additional tasks
eng.TasksDescription=What additional tasks need to be completed?
eng.DirectX=Îáíîâèòü DirectX
eng.QuickLaunch=Create shortcut in Quick Launch
eng.Desktop=Create a desktop shortcut
eng.DirectXInstall=DirectX update in progress...
eng.AllProgress=File unpacking progress:
eng.Remains=It remains to wait
eng.Hour=hour
eng.Min=min
eng.Sec=sec
eng.FinishedHeading=Installing the game {#GameName} completed successfully.
eng.FinishedLabel=A game {#GameVerName} has been successfully installed on your computer. To launch it, select the appropriate shortcut in the Start menu or on the Desktop.
eng.FinishedLabel2=Click "Finish" to exit the installer.
eng.Uninstall=Delete {#GameName}
eng.DeleteSave=Delete saved games and profiles?
eng.WizardUninst=Deletion status
eng.UninstDescript=Please wait while the game is removed from your computer.
eng.StatusUninst=Deleting a game {#GameName}...
eng.AllProgressUninst=Overall game uninstall progress:
eng.Error=Unpacking error!
eng.Error2=Installation {#GameName} not completed.
eng.Error3=During installation {#GameName} an error occurred, please %ndisable third-party programs and try the installation again.%n%nClick Finish to exit the installer.


[UninstallDelete]
Type: files; Name: {app}


[code]
type
  TTimerProc = procedure (h: Longword; msg: Longword; idevent: Longword; dwTime: Longword);
  TBtnEventProc = procedure (h:HWND);
  TPBProc = function  (h:hWnd;Msg,wParam,lParam:Longint):Longint;

  TALabel = array of TLabel;
const
  BtnClickEventID      = 1;
  BtnMouseEnterEventID = 2;
  LanguageButtonCount  = 2;
  BASS_ACTIVE_PAUSED   = 3;
  BASS_SAMPLE_LOOP     = 4;
  WFDiskTimerID        = 1;
  WFSysReqTimerID      = 2;

var
  SystemPage, SelectTasksPage: TWizardPage;

  MusicButton,
  hCancelBtn, hNextBtn, hBackBtn, hDirBrowseBtn, hGroupBrowseBtn,  hCancelUninstBtn,
  LogoBtn, NoIconsCheck, DesktopCheck, QuickLaunchCheck, DirectXCheck, mp3Handle: HWND;

  WFButtonFont, UPFButtonFont: TFont;
  mp3Name, OldDisk: string;
  work1, work2, work3,work4,work5, work6, work7: Longint;
  Welcome, System, Catalogue, StartMenu, Tasks, Installing, Finish, Uninstalling,

  PageNameLabel, PageDescriptionLabel,
  WelcomeLabel1, WelcomeLabel2,
  RequirementsLbl, ProcessorLbl, VideoCardLbl, SoundCardLbl, RAMLbl, SystemLbl,
  ProcessorNameLbl, VideoCardNameLbl, SoundCardNameLbl, RAMTotalLbl, SystemNameLbl,

  SelectDirBrowseLabel, DirEditLabel, TotalSpaceLabel, NeedSpaceLabel, FreeSpaceLabel,
  SelectStartMenuFolderBrowseLabel, GroupEditLabel, NoIconsLabel,
  SelectTasksLabel, DesktopLabel, QuickLaunchLabel,
  FilenameLabel, StatusLabel, ProgressInfoLabel,
  FinishedHeadingLabel, FinishedLabel,
  WizardUninstLabel, UninstPageDescriptLabel, StatusUninstLabel : TLabel;

  StatusPanel, RequirementsPanel, Edit,DirFolder,HardDrivePanel,
  Logo, GroupFolder,WizardImg, HDD: Longint;

  FreeMB, TotalMB: Cardinal;
  AImg: array of Longint;
  LanguageButton: array [1..LanguageButtonCount] of HWND;
  ASysReq, ADisk: TALabel;
  Keys: TArrayOfString;

function WrapBtnCallback(Callback: TBtnEventProc; ParamCount: Integer): Longword; external 'wrapcallback@{tmp}\innocallback.dll stdcall delayload';
function BtnCreate(hParent:HWND; Left,Top,Width,Height:integer; FileName:PAnsiChar; ShadowWidth:integer; IsCheckBtn:boolean):HWND;  external 'BtnCreate@{tmp}\botva2.dll stdcall delayload';
procedure BtnRefresh(h:HWND); external 'BtnRefresh@{tmp}\botva2.dll stdcall delayload';
function BtnGetChecked(h:HWND):boolean; external 'BtnGetChecked@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetChecked(h:HWND; Value:boolean); external 'BtnSetChecked@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetText(h:HWND; Text:PAnsiChar);  external 'BtnSetText@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetVisibility(h:HWND; Value:boolean); external 'BtnSetVisibility@{tmp}\botva2.dll stdcall delayload';
function BtnGetEnabled(h:HWND):boolean; external 'BtnGetEnabled@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetEnabled(h:HWND; Value:boolean); external 'BtnSetEnabled@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetFont(h:HWND; Font:Cardinal); external 'BtnSetFont@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetFontColor(h:HWND; NormalFontColor, FocusedFontColor, PressedFontColor, DisabledFontColor: Cardinal); external 'BtnSetFontColor@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetEvent(h:HWND; EventID:integer; Event:Longword); external 'BtnSetEvent@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetCursor(h:HWND; hCur:Cardinal); external 'BtnSetCursor@{tmp}\botva2.dll stdcall delayload';
procedure BtnSetPosition(h:HWND; NewLeft, NewTop, NewWidth, NewHeight: integer); external 'BtnSetPosition@{tmp}\botva2.dll stdcall delayload';
function GetSysCursorHandle(id:integer):Cardinal; external 'GetSysCursorHandle@{tmp}\botva2.dll stdcall delayload';
function ImgLoad(Wnd :HWND; FileName :PAnsiChar; Left, Top, Width, Height :integer; Stretch, IsBkg :boolean) :Longint; external 'ImgLoad@{tmp}\botva2.dll stdcall delayload';
procedure ImgSetPosition(img :Longint; NewLeft, NewTop, NewWidth, NewHeight :integer); external 'ImgSetPosition@{tmp}\botva2.dll stdcall delayload';
procedure ImgRelease(img :Longint); external 'ImgRelease@{tmp}\botva2.dll stdcall delayload';
procedure ImgSetVisibility(img :Longint; Visible :boolean); external 'ImgSetVisibility@{tmp}\botva2.dll stdcall delayload';
function ImgGetVisibility(img:Longint):boolean; external 'ImgGetVisibility@{tmp}\botva2.dll stdcall delayload';
procedure ImgApplyChanges(h:HWND); external 'ImgApplyChanges@{tmp}\botva2.dll stdcall delayload';
procedure gdipShutdown;  external 'gdipShutdown@{tmp}\botva2.dll stdcall delayload';

function sndPlaySound(lpszSoundName: AnsiString; uFlags: cardinal):integer; external 'sndPlaySoundA@winmm.dll stdcall';

function SetTimer(hWnd, nIDEvent, uElapse, lpTimerFunc: LongWord): LongWord; external 'SetTimer@user32.dll stdcall';
function KillTimer(hWnd, nIDEvent: LongWord): LongWord; external 'KillTimer@user32.dll stdcall';
function WrapTimerProc(callback:TTimerProc; paramcount:integer):LongWord; external 'wrapcallback@{tmp}\innocallback.dll stdcall delayload';

function SetWindowLong(hWnd: HWND; nIndex: Integer; dwNewLong: Longint): Longint; external 'SetWindowLongA@user32.dll stdcall';

procedure LoadSkin(lpszPath: PAnsiChar; lpszIniFileName: PAnsiChar); external 'LoadSkin@{tmp}\isskin.dll stdcall delayload';
procedure UnloadSkin; external 'UnloadSkin@{tmp}\isskin.dll stdcall delayload';
function ShowWindow(hWnd: Integer; uType: Integer): Integer; external 'ShowWindow@user32.dll stdcall';

//================== Connecting the module ==================//
#include "Iss\ProgressBar.iss"
var
pb, pb1: Longint;
#include "Iss\ISDone.iss"
//================== Connecting the module ==================//
function InitializeSetup:Boolean;
begin

  ExtractTemporaryFile('botva2.dll');
  ExtractTemporaryFile('Click.wav');
  ExtractTemporaryFile('isskin.dll');
  ExtractTemporaryFile('Tiger.cjstyles');

  LoadSkin(ExpandConstant('{tmp}\Tiger.cjstyles'), '');
  Result:=True;
end;


//************************************************ [Start - Inserting Images] ***************************************************//

procedure CreateWizardImage;
var
  i: integer;
begin
  WizardForm.ClientWidth:=ScaleX(877);
  WizardForm.ClientHeight:=ScaleY(485);
  //WizardForm.Center;
  WizardForm.BorderStyle :=  bsDialog;
  WizardForm.OuterNotebook.Hide;
  WizardForm.InnerNotebook.Hide;
  WizardForm.Bevel.Hide;

  ExtractTemporaryFile('WizardImage.jpg');
  ExtractTemporaryFile('button.png');
  ExtractTemporaryFile('MusicButton.png');
  ExtractTemporaryFile('RequirementsPanel.png');
  ExtractTemporaryFile('Edit.png');
  ExtractTemporaryFile('DirFolder.png');
  ExtractTemporaryFile('HardDrivePanel.png');
  ExtractTemporaryFile('HDD.png');
  ExtractTemporaryFile('GroupFolder.png');
  ExtractTemporaryFile('CheckBox.png');
  ExtractTemporaryFile('ProgressBackground.png');
  ExtractTemporaryFile('ProgressImg.png');
  ExtractTemporaryFile('Logo.png');
  ExtractTemporaryFile('back2.png');

  ExtractTemporaryFile('work1.png');
  ExtractTemporaryFile('work2.png');
  ExtractTemporaryFile('work3.png');
  ExtractTemporaryFile('work4.png');
  ExtractTemporaryFile('work5.png');
  ExtractTemporaryFile('work6.png');
  ExtractTemporaryFile('work7.png');

  ExtractTemporaryFile('WFEnter.wav');
  ExtractTemporaryFile('Check.wav');
  ExtractTemporaryFile('Music.mp3');
  ExtractTemporaryFile('BASS.dll');
  ExtractTemporaryFile('LogoButton.png');

  ExtractTemporaryFile('1.ico');
  ExtractTemporaryFile('2.ico');
  ExtractTemporaryFile('3.ico');
  ExtractTemporaryFile('4.ico');
  ExtractTemporaryFile('5.ico');

  WizardImg:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\WizardImage.jpg'),ScaleX(0),ScaleY(0),WizardForm.ClientWidth,WizardForm.ClientHeight,True,True);

  SetArrayLength(AImg,5);
  for i:=0 to GetArrayLength(AImg)-1 do begin
  AImg[i]:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\'+IntToStr(i+1)+'.jpg'),0,0,WizardForm.ClientWidth,WizardForm.ClientHeight,True,True);
  ImgSetVisibility(AImg[i],False);
  end;


  work1:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\work1.png'),ScaleX(0), ScaleY(0),WizardForm.ClientWidth,WizardForm.ClientHeight,True,True);
  work2:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\work2.png'),ScaleX(0), ScaleY(0),WizardForm.ClientWidth,WizardForm.ClientHeight,True,True);
  work3:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\work3.png'),ScaleX(0), ScaleY(0),WizardForm.ClientWidth,WizardForm.ClientHeight,True,True);
  work4:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\work4.png'),ScaleX(0), ScaleY(0),WizardForm.ClientWidth,WizardForm.ClientHeight,True,True);
  work5:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\work5.png'),ScaleX(0), ScaleY(0),WizardForm.ClientWidth,WizardForm.ClientHeight,True,True);
  work6:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\work6.png'),ScaleX(0), ScaleY(0),WizardForm.ClientWidth,WizardForm.ClientHeight,True,True);
  work7:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\work7.png'),ScaleX(0), ScaleY(0),WizardForm.ClientWidth,WizardForm.ClientHeight,True,True);

  Logo:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\Logo.png'),ScaleX(0), ScaleY(0),WizardForm.ClientWidth,WizardForm.ClientHeight,True,False);
  ImgSetVisibility(logo,false);


  ImgSetVisibility(work1,False);
  ImgSetVisibility(work2,False);
  ImgSetVisibility(work3,False);
  ImgSetVisibility(work4,False);
  ImgSetVisibility(work5,False);
  ImgSetVisibility(work6,False);
  ImgSetVisibility(work7,False);

  ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\back2.png'),ScaleX(0), ScaleY(0),877,485,True,True);
  RequirementsPanel:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\RequirementsPanel.png'),ScaleX(220), ScaleY(0),ScaleX(700),ScaleY(485),True,True);
  Edit:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\Edit.png'),ScaleX(340), ScaleY(240),ScaleX(420),ScaleY(22),True,True);
  DirFolder:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\DirFolder.png'),ScaleX(280), ScaleY(200),ScaleX(60),ScaleY(74),True,True);
  HardDrivePanel:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\HardDrivePanel.png'),ScaleX(340), ScaleY(283),ScaleX(420),ScaleY(70),True,True);
  HDD:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\HDD.png'),ScaleX(280), ScaleY(283),ScaleX(60),ScaleY(74),True,True);
  GroupFolder:=ImgLoad(WizardForm.Handle,ExpandConstant('{tmp}\GroupFolder.png'),ScaleX(280), ScaleY(200),ScaleX(60),ScaleY(74),True,True);

  ImgApplyChanges(WizardForm.Handle);
end;

//************************************************ [End - Inserting Images] ***************************************************//

//************************************************ [Start - Button textures] ***************************************************//

procedure SetStateNewButtons;
begin
  with WizardForm.BackButton do begin
    BtnSetText(hBackBtn,PAnsiChar(Caption));
    BtnSetVisibility(hBackBtn,Visible);
    BtnSetEnabled(hBackBtn,Enabled);
  end;
  with WizardForm.NextButton do begin
    BtnSetText(hNextBtn,PAnsiChar(Caption));
    BtnSetVisibility(hNextBtn,Visible);
    BtnSetEnabled(hNextBtn,Enabled);
  end;
  with WizardForm.CancelButton do begin
    BtnSetText(hCancelBtn,PAnsiChar(Caption));
    BtnSetVisibility(hCancelBtn,Visible);
    BtnSetEnabled(hCancelBtn,Enabled);
  end;
  BtnSetText(hDirBrowseBtn,PAnsiChar(WizardForm.DirBrowseButton.Caption));
  BtnSetText(hGroupBrowseBtn,PAnsiChar(WizardForm.GroupBrowseButton.Caption));
end;

procedure WizardFormBtnClick(hBtn:HWND);
var
  Btn:TButton;
begin
  sndPlaySound(ExpandConstant('{tmp}\Click.wav'),$0001);
  case hBtn of
    hCancelBtn: Btn:=WizardForm.CancelButton;
    hNextBtn: Btn:=WizardForm.NextButton;
    hBackBtn: Btn:=WizardForm.BackButton;
    hDirBrowseBtn: Btn:=WizardForm.DirBrowseButton;
    hGroupBrowseBtn: Btn:=WizardForm.GroupBrowseButton;
  end;
  Btn.OnClick(Btn);
  SetStateNewButtons;
  BtnRefresh(hBtn);
end;

procedure WFBtnEnter(hBtn:HWND);
begin
  sndPlaySound(ExpandConstant('{tmp}\WFEnter.wav'),$0001);
end;

procedure LogoClick(hBtn:HWND);
var
Check:boolean;
begin
Check:=BtnGetChecked(hBtn);
sndPlaySound(ExpandConstant('{tmp}\Click.wav'),$0001);
Check:=BtnGetChecked(hBtn);
BtnSetEnabled(hBackBtn, not Check);
BtnSetEnabled(hNextBtn, not Check);
BtnSetEnabled(hCancelBtn, not Check);
BtnSetEnabled(hDirBrowseBtn, not Check);
BtnSetEnabled(hGroupBrowseBtn, not Check);
BtnSetEnabled(QuickLaunchCheck, not Check);
BtnSetEnabled(DesktopCheck, not Check);
BtnSetEnabled(NoIconsCheck, not Check);
BtnSetEnabled(MusicButton, not Check);
ImgSetVisibility(Logo, not ImgGetVisibility(Logo));
ImgApplyChanges(WizardForm.Handle);
end;

procedure ButtonsTextures;
begin
  WFButtonFont:=TFont.Create;
  WFButtonFont.Style:=[fsBold];

  with WizardForm.BackButton do begin
    hBackBtn:=BtnCreate(WizardForm.Handle,ScaleX(550),ScaleY(430),ScaleX(100),ScaleY(39),ExpandConstant('{tmp}\button.png'),18,False);
    BtnSetEvent(hBackBtn,BtnMouseEnterEventID,WrapBtnCallback(@WFBtnEnter,1));
    BtnSetEvent(hBackBtn,BtnClickEventID,WrapBtnCallback(@WizardFormBtnClick,1));
    BtnSetFont(hBackBtn,WFButtonFont.Handle);
    BtnSetFontColor(hBackBtn,$FFFFFF,$FFFFFF,$FFFFFF,$B6B6B6);
    BtnSetCursor(hBackBtn,GetSysCursorHandle(32649));
    Width:=0;
    Height:=0;
  end;

  with WizardForm.NextButton do begin
    hNextBtn:=BtnCreate(WizardForm.Handle,ScaleX(658),ScaleY(430),ScaleX(100),ScaleY(39),ExpandConstant('{tmp}\button.png'),18,False);
    BtnSetEvent(hNextBtn,BtnMouseEnterEventID,WrapBtnCallback(@WFBtnEnter,1));
    BtnSetEvent(hNextBtn,BtnClickEventID,WrapBtnCallback(@WizardFormBtnClick,1));
    BtnSetFont(hNextBtn,WFButtonFont.Handle);
    BtnSetFontColor(hNextBtn,$FFFFFF,$FFFFFF,$FFFFFF,$B6B6B6);
    BtnSetCursor(hNextBtn,GetSysCursorHandle(32649));
    Width:=0;
    Height:=0;
  end;

  with WizardForm.CancelButton do begin
    hCancelBtn:=BtnCreate(WizardForm.Handle,ScaleX(766),ScaleY(430),ScaleX(100),ScaleY(39),ExpandConstant('{tmp}\button.png'),18,False);
    BtnSetEvent(hCancelBtn,BtnMouseEnterEventID,WrapBtnCallback(@WFBtnEnter,1));
    BtnSetEvent(hCancelBtn,BtnClickEventID,WrapBtnCallback(@WizardFormBtnClick,1));
    BtnSetFont(hCancelBtn,WFButtonFont.Handle);
    BtnSetFontColor(hCancelBtn,$FFFFFF,$FFFFFF,$FFFFFF,$B6B6B6);
    BtnSetCursor(hCancelBtn,GetSysCursorHandle(32649));
    Width:=0;
    Height:=0;
  end;

  LogoBtn:=BtnCreate(WizardForm.Handle,ScaleX(40), ScaleY(430), ScaleX(36), ScaleY(36),ExpandConstant('{tmp}\LogoButton.png'),5,True);
  BtnSetEvent(LogoBtn,BtnClickEventID,WrapBtnCallback(@LogoClick,4));
  BtnSetEvent(LogoBtn,BtnMouseEnterEventID,WrapBtnCallback(@WFBtnEnter,1));
  BtnSetCursor(LogoBtn,GetSysCursorHandle(32649));

  with WizardForm.DirBrowseButton do begin
    hDirBrowseBtn:=BtnCreate(WizardForm.Handle,ScaleX(748),ScaleY(230),ScaleX(110),ScaleY(35),ExpandConstant('{tmp}\button.png'),18,False);
    BtnSetEvent(hDirBrowseBtn,BtnMouseEnterEventID,WrapBtnCallback(@WFBtnEnter,1));
    BtnSetEvent(hDirBrowseBtn,BtnClickEventID,WrapBtnCallback(@WizardFormBtnClick,1));
    BtnSetFont(hDirBrowseBtn,WFButtonFont.Handle);
    BtnSetFontColor(hDirBrowseBtn,$FFFFFF,$FFFFFF,$FFFFFF,$B6B6B6);
    BtnSetCursor(hDirBrowseBtn,GetSysCursorHandle(32649));
    Width:=0;
    Height:=0;
  end;

  with WizardForm.GroupBrowseButton do begin
    hGroupBrowseBtn:=BtnCreate(WizardForm.Handle,Left+418,Top+150,Width+31,Height+16,ExpandConstant('{tmp}\button.png'),18,False);
    BtnSetEvent(hGroupBrowseBtn,BtnMouseEnterEventID,WrapBtnCallback(@WFBtnEnter,1));
    BtnSetEvent(hGroupBrowseBtn,BtnClickEventID,WrapBtnCallback(@WizardFormBtnClick,1));
    BtnSetFont(hGroupBrowseBtn,WFButtonFont.Handle);
    BtnSetFontColor(hGroupBrowseBtn,$FFFFFF,$FFFFFF,$FFFFFF,$B6B6B6);
    BtnSetCursor(hGroupBrowseBtn,GetSysCursorHandle(32649));
    Width:=0;
    Height:=0;
  end;
end;

//************************************************ [End - Button texture] ***************************************************//

//************************************************ [Beginning - Music] ***************************************************//

function BASS_Init(device: Integer; freq, flags: DWORD; win: hwnd; CLSID: Integer): Boolean; external 'BASS_Init@files:BASS.dll stdcall delayload';
function BASS_StreamCreateFile(mem: BOOL; f: PAnsiChar; offset: DWORD; length: DWORD; flags: DWORD): DWORD; external 'BASS_StreamCreateFile@files:BASS.dll stdcall delayload';
function BASS_Start: Boolean; external 'BASS_Start@files:BASS.dll stdcall delayload';
function BASS_ChannelPlay(handle: DWORD; restart: BOOL): Boolean; external 'BASS_ChannelPlay@files:BASS.dll stdcall delayload';
function BASS_ChannelIsActive(handle: DWORD): Integer; external 'BASS_ChannelIsActive@files:BASS.dll stdcall delayload';
function BASS_ChannelPause(handle: DWORD): Boolean; external 'BASS_ChannelPause@files:BASS.dll stdcall delayload';
function BASS_Pause: Boolean; external 'BASS_Pause@files:BASS.dll stdcall delayload';
function BASS_Stop: Boolean; external 'BASS_Stop@files:BASS.dll stdcall delayload';
function BASS_Free: Boolean; external 'BASS_Free@files:BASS.dll stdcall delayload';

procedure MusicButtonClick(hBtn:HWND);
begin
  sndPlaySound(ExpandConstant('{tmp}\Click.wav'), $0001);
  if BtnGetChecked(MusicButton) then BASS_ChannelPause(mp3Handle)
    else if BASS_ChannelIsActive(mp3Handle)=BASS_ACTIVE_PAUSED then BASS_ChannelPlay(mp3Handle, False);
end;

procedure InsertMusic;
begin
  MusicButton:=BtnCreate(WizardForm.Handle,ScaleX(837),ScaleY(80),ScaleX(36),ScaleY(36),ExpandConstant('{tmp}\MusicButton.png'),0,True);
  BtnSetEvent(MusicButton,BtnClickEventID,WrapBtnCallback(@MusicButtonClick,1));
  BtnSetEvent(MusicButton,BtnMouseEnterEventID,WrapBtnCallback(@WFBtnEnter,1));
  BtnSetVisibility(MusicButton,True);
  BtnSetCursor(MusicButton,GetSysCursorHandle(32649));

  mp3Name:=ExpandConstant('{tmp}\Music.mp3');
  BASS_Init(-1,44100,0,0,0);
  mp3Handle:=BASS_StreamCreateFile(FALSE,PAnsiChar(mp3Name),0,0,BASS_SAMPLE_LOOP);
  BASS_Start;
  BASS_ChannelPlay(mp3Handle,False);
end;

//************************************************ [End - Music] ***************************************************//

//************************************************ [Home - Panel] ***************************************************//

procedure CreateStatusPanel;
begin
  Welcome := TLabel.Create(WizardForm);
  with Welcome do begin
    AutoSize:=False;
    SetBounds(ScaleX(13), ScaleY(80), ScaleX(125), ScaleY(20));

    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 10;
    Font.Style:=[fsBold];
    Caption := ExpandConstant('{cm:Welcome}');
    Parent := WizardForm;
  end;

  System := TLabel.Create(WizardForm);
  with System do begin
    AutoSize:=False;
    SetBounds(ScaleX(143), ScaleY(80), ScaleX(125), ScaleY(20));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 10;
    Font.Style:=[fsBold];
    Caption := ExpandConstant('{cm:System}');
    Parent := WizardForm;
  end;

  Catalogue := TLabel.Create(WizardForm);
  with Catalogue do begin
    AutoSize:=False;
    SetBounds(ScaleX(260), ScaleY(80), ScaleX(125), ScaleY(20));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 10;
    Font.Style:=[fsBold];
    Caption := ExpandConstant('{cm:Catalogue}');
    Parent := WizardForm;
  end;

  StartMenu := TLabel.Create(WizardForm);
  with StartMenu do begin
    AutoSize:=False;
    SetBounds(ScaleX(357), ScaleY(80), ScaleX(125), ScaleY(20));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 10;
    Font.Style:=[fsBold];
    Caption := ExpandConstant('{cm:StartMenu}');
    Parent := WizardForm;
  end;

  Tasks := TLabel.Create(WizardForm);
  with Tasks do begin
    AutoSize:=False;
    SetBounds(ScaleX(490), ScaleY(80), ScaleX(125), ScaleY(20));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 10;
    Font.Style:=[fsBold];
    Caption := ExpandConstant('{cm:Task}');
    Parent := WizardForm;
  end;

  Installing := TLabel.Create(WizardForm);
  with Installing do begin
    AutoSize:=False;
    SetBounds(ScaleX(593), ScaleY(80), ScaleX(125), ScaleY(20));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 10;
    Font.Style:=[fsBold];
    Caption := ExpandConstant('{cm:Installing}');
    Parent := WizardForm;
  end;

  Finish := TLabel.Create(WizardForm);
  with Finish do begin
    AutoSize:=False;
    SetBounds(ScaleX(703), ScaleY(80), ScaleX(125), ScaleY(20));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 10;
    Font.Style:=[fsBold];
    Caption := ExpandConstant('{cm:Finish}');
    Parent := WizardForm;
  end;
end;

//************************************************ [End - Panel] ***************************************************//

//************************************************ [Home - Page Components] ***************************************************//

function DetectHardware: Integer; external 'hwc_DetectHardware@files:get_hw_caps.dll stdcall';
function GetProcessorName: PAnsiChar; external 'hwc_GetProcessorName@files:get_hw_caps.dll stdcall';
function GetProcessorFreq: Integer; external 'hwc_GetProcessorFreq@files:get_hw_caps.dll stdcall';
function GetVideoCardName: PAnsiChar; external 'hwc_GetVideoCardName@files:get_hw_caps.dll stdcall';
function GetVidMemLocal: Integer; external 'hwc_GetVidMemLocal@files:get_hw_caps.dll stdcall';
function GetPdmWidth: Integer; external 'hwc_GetPdmWidth@files:get_hw_caps.dll stdcall';
function GetPdmHeight: Integer; external 'hwc_GetPdmHeight@files:get_hw_caps.dll stdcall';
function GetSoundCards: Integer; external 'hwc_GetSoundCards@files:get_hw_caps.dll stdcall';
function GetSoundCardName: PAnsiChar; external 'hwc_GetSoundCardName@files:get_hw_caps.dll stdcall';
function GetSystemPhys: Integer; external 'hwc_GetSystemPhys@files:get_hw_caps.dll stdcall';

function DelSp(s: string): string;
begin
  while Pos('  ',s)>0 do StringChange(s,'  ',' ');
  Result:=Trim(s);
end;

procedure GroupChange(Sender: TObject);
begin
  GroupEditLabel.Caption := MinimizePathName(WizardForm.GroupEdit.Text, GroupEditLabel.Font, GroupEditLabel.Width);
end;

function NumToStr(Float: Extended): string;
begin
  Result:=Format('%.2n', [Float]);
  StringChange(Result, ',', '.');
  while ((Result[Length(Result)]='0') or (Result[Length(Result)]='.')) and (Pos('.',Result)>0) do SetLength(Result,Length(Result)-1);
end;

function MbOrTB(Float: Extended): string;
begin
  if Float<1024 then Result:=NumToStr(Float)+' MB'
  else if (Float/1024)<1024 then Result:=NumToStr(Float/1024)+' GB'
  else if (Float/(1024*1024))<1024 then Result:=NumToStr(Float/(1024*1024))+' TB'
end;

procedure SysReqFlashing(h: Longword; msg: Longword; idevent: Longword; dwTime: Longword);
var
  i:integer;
begin
  for i:= 0 to GetArrayLength(ASysReq)-1 do
    if ASysReq[i].Font.Color=$FFFFFF then ASysReq[i].Font.Color:=$0000FF else ASysReq[i].Font.Color:=$FFFFFF;
end;

procedure DiskFlashing(h: Longword; msg: Longword; idevent: Longword; dwTime: Longword);
var
  i:integer;
begin
  for i:= 0 to GetArrayLength(ADisk)-1 do
    if ADisk[i].Font.Color=$FFFFFF then ADisk[i].Font.Color:=$0000FF else ADisk[i].Font.Color:=$FFFFFF;
end;

function GetElementIndex(a:TALabel; lbl:TLabel):integer;
var
  i:integer;
  f:boolean;
begin
  Result:=-1;
  f:=False;
  for i:=0 to GetArrayLength(a)-1 do
    if a[i]=lbl then begin
      f:=True;
      Break;
    end;
  if f then Result:=i;
end;

procedure AddLabelToArray(var a:TALabel; lbl:TLabel);
begin
  if GetElementIndex(a,lbl)=-1 then begin
    SetArrayLength(a,GetArrayLength(a)+1);
    a[GetArrayLength(a)-1]:=lbl;
  end;
end;

procedure DeleteLabelFromArray(var a:TALabel; lbl:integer);
var
  Last,i:integer;
begin
  if lbl<>-1 then begin
    Last:=GetArrayLength(a)-1;
    if lbl<Last then
      for i:=lbl to Last-1 do a[i]:=a[i+1];
    SetArrayLength(a,Last);
  end;
end;

procedure GetFreeSpaceCaption(Sender: TObject);
var
  CurrentDisk: String;
  i:integer;
begin
  CurrentDisk:=ExtractFileDrive(WizardForm.DirEdit.Text);
  DirEditLabel.Caption:=MinimizePathName(WizardForm.DirEdit.Text, DirEditLabel.Font, DirEditLabel.Width);
  if not GetSpaceOnDisk(CurrentDisk,True,FreeMB,TotalMB) then begin
    KillTimer(WizardForm.Handle,WFDiskTimerID);
    SetArrayLength(ADisk,0);
    TotalSpaceLabel.Visible:=False;
    FreeSpaceLabel.Visible:=False;
    BtnSetEnabled(hNextBtn,False);
    WizardForm.NextButton.Enabled:=False;
    OldDisk:=CurrentDisk;
    Exit;
  end;

  TotalSpaceLabel.Visible:=True;
  FreeSpaceLabel.Visible:=True;

  if CurrentDisk<>OldDisk then begin
    OldDisk:=CurrentDisk;
    TotalSpaceLabel.Caption := ExpandConstant('{cm:TotalSpace} ') + MbOrTB(TotalMb);
    FreeSpaceLabel.Caption := ExpandConstant('{cm:FreeSpace} ') + MbOrTB(FreeMb) + ' (' + IntToStr((FreeMb*100) div TotalMB) + ' %)';

    if WizardForm.CurPageID = wpSelectDir then begin
      if FreeMB>={#NeedSize} then begin
        i:=GetElementIndex(ADisk,FreeSpaceLabel);
        if i<>-1 then begin
          DeleteLabelFromArray(ADisk,i);
          FreeSpaceLabel.Font.Color:=$FFFFFF;
          if GetArrayLength(ADisk)=0 then KillTimer(WizardForm.Handle,WFDiskTimerID);
        end;
      end else AddLabelToArray(ADisk,FreeSpaceLabel);

      if TotalMb>={#NeedSize} then begin
        i:=GetElementIndex(ADisk,TotalSpaceLabel);
        if i<>-1 then begin
          DeleteLabelFromArray(ADisk,i);
          TotalSpaceLabel.Font.Color:=$FFFFFF;
          if GetArrayLength(ADisk)=0 then KillTimer(WizardForm.Handle,WFDiskTimerID);
        end;
      end else AddLabelToArray(ADisk,TotalSpaceLabel);

      if GetArrayLength(ADisk)>0 then SetTimer(WizardForm.Handle,WFDiskTimerID,1000,WrapTimerProc(@DiskFlashing,4));
      BtnSetEnabled(hNextBtn,not (GetArrayLength(ADisk)>0));
      WizardForm.NextButton.Enabled:=not (GetArrayLength(ADisk)>0);
    end;
  end;
end;

function NoIcons: Boolean;
begin
  Result:= BtnGetEnabled(hGroupBrowseBtn);
end;

function Desktop: Boolean;
begin
  Result:= BtnGetChecked(DesktopCheck);
end;

function QuickLaunch: Boolean;
begin
  Result:= BtnGetChecked(QuickLaunchCheck);
end;



procedure NoIconsClick(hBtn:HWND);
var
  Check:boolean;
begin
  sndPlaySound(ExpandConstant('{tmp}\Check.wav'), $0001);
  Check:=BtnGetChecked(hBtn);
  BtnSetEnabled(hGroupBrowseBtn, not Check);
  GroupEditLabel.Enabled:=not Check;
  if Check then NoIconsLabel.Font.Color:=$00FFFF else NoIconsLabel.Font.Color:=$FFFFFF;
end;

procedure NoIconsLabelClick(Sender:TObject);
begin
  BtnSetChecked(NoIconsCheck, not BtnGetChecked(NoIconsCheck));
  NoIconsClick(NoIconsCheck);
end;

procedure DesktopClick(hBtn:HWND);
begin
  sndPlaySound(ExpandConstant('{tmp}\Check.wav'), $0001);
  if BtnGetChecked(hBtn) then DesktopLabel.Font.Color:=$00FFFF else DesktopLabel.Font.Color:=$FFFFFF;
end;

procedure DesktopLabelClick(Sender:TObject);
begin
  BtnSetChecked(DesktopCheck, not BtnGetChecked(DesktopCheck));
  DesktopClick(DesktopCheck);
end;

procedure QuickLaunchClick(hBtn:HWND);
begin
  sndPlaySound(ExpandConstant('{tmp}\Check.wav'), $0001);
  if BtnGetChecked(hBtn) then QuickLaunchLabel.Font.Color:=$00FFFF else QuickLaunchLabel.Font.Color:=$FFFFFF;
end;

procedure QuickLaunchLabelClick(Sender:TObject);
begin
  BtnSetChecked(QuickLaunchCheck, not BtnGetChecked(QuickLaunchCheck));
  QuickLaunchClick(QuickLaunchCheck);
end;

procedure CreatePageComponents;
var
  Pdm: string;
  vr,VidRam : Longint;
  Version: TWindowsVersion;
begin
  PageNameLabel:=TLabel.Create(WizardForm);
  with PageNameLabel do begin
    Alignment := taCenter;
    AutoSize:= False;
    SetBounds(ScaleX(345), ScaleY(145), ScaleX(400), ScaleY(30));
    Transparent:=True;
    Font.Name:= 'Georgia';
    Font.Size:= 12;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    Parent:=WizardForm;
  end;

  PageDescriptionLabel:=TLabel.Create(WizardForm);
  with PageDescriptionLabel do begin
    Alignment := taCenter;
    AutoSize:= False;
    SetBounds(ScaleX(250), ScaleY(175), ScaleX(600), ScaleY(50));
    Wordwrap:= True;
    Transparent:=True;
    Font.Name:= 'Georgia';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold, fsItalic];
    Parent:=WizardForm;
  end;

////////////////////// WelcomePage //////////////////////

  WelcomeLabel1:= TLabel.Create(WizardForm);
  with WelcomeLabel1 do begin
    AutoSize:=False
    SetBounds(ScaleX(227), ScaleY(145), ScaleX(648), ScaleY(65));
    WordWrap:=True
    Alignment := taCenter;
    Transparent:=True
    Font.Name:='Georgia';
    Font.Size:= 12;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold]
    Caption:= ExpandConstant('{cm:Welcome1}');
    Parent:=WizardForm
  end;

  WelcomeLabel2:=TLabel.Create(WizardForm);
  with WelcomeLabel2 do begin
    AutoSize:=False
    SetBounds(ScaleX(227), ScaleY(215), ScaleX(648), ScaleY(200));
    WordWrap:=True
    Transparent:=True
    Alignment := taCenter;
    Font.Name:='Georgia';
    Font.Size:= 10;
    Font.Color:=$FFFFFF;
    Font.Style := [fsBold, fsItalic];
    Caption:= ExpandConstant('{cm:Welcome2}');
    Parent:=WizardForm
  end;

////////////////////// WelcomePage //////////////////////

////////////////////// SystemPage //////////////////////

  SystemPage:=CreateCustomPage(wpLicense, ExpandConstant('{cm:Requirements1}'), ExpandConstant('{cm:Requirements2}'));

  RequirementsLbl := TLabel.Create(WizardForm);
  with RequirementsLbl do begin
    AutoSize:=False;
    SetBounds(ScaleX(242), ScaleY(200), ScaleX(605), ScaleY(50));
    Transparent:=True;
    Font.Name:= 'Georgia';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Alignment := taCenter;
    Font.Style:=[fsBold, fsItalic];
    Caption := ExpandConstant('{cm:Requirements3}');
    Parent:=WizardForm;
  end;

  //================= Start - Processor =================//

  ProcessorLbl := TLabel.Create(WizardForm);
  with ProcessorLbl do begin
    AutoSize:=False;
    SetBounds(ScaleX(285), ScaleY(246), ScaleX(150), ScaleY(22));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    Caption := ExpandConstant('{cm:Processor}');
    Parent := WizardForm;
  end;

  ProcessorNameLbl := TLabel.Create(WizardForm);
  with ProcessorNameLbl do begin
    AutoSize:=False;
    SetBounds(ScaleX(463), ScaleY(246), ScaleX(400), ScaleY(22));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    Caption := DelSP(GetProcessorName) + ' @' + IntToStr(GetProcessorFreq) + ' MHz';
    Parent := WizardForm;
  end;

  RegGetSubkeyNames(HKLM, 'Hardware\Description\System\CentralProcessor', Keys)

  if (GetProcessorFreq*GetArrayLength(Keys)) < {#Processor} then
  begin
    RequirementsLbl.Caption := ExpandConstant('{cm:Requirements4}');
    AddLabelToArray(AsysReq,ProcessorNameLbl);
  end;

//================= End - Processor =================//

//================= Start - Video adapter =================//

  VideoCardLbl := TLabel.Create(WizardForm);
  with VideoCardLbl do begin
    AutoSize:=False;
    SetBounds(ScaleX(285), ScaleY(276), ScaleX(150), ScaleY(22));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    Caption := ExpandConstant('{cm:VideoCard}');
    Parent := WizardForm;
  end;

  VideoCardNameLbl := TLabel.Create(WizardForm);
  with VideoCardNameLbl do begin
    AutoSize:=False;
    SetBounds(ScaleX(463), ScaleY(276), ScaleX(400), ScaleY(22));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    Caption := GetVideoCardName;
    Parent := WizardForm;
  end;

  Pdm:=' ['+IntToStr(GetPdmWidth)+'x'+IntToStr(GetPdmHeight)+']';

  VidRam:=GetVidMemLocal/1000000;
  if (VidRam<63) or (VidRam>1100) then vr:=VidRam
  else if VidRam<100 then vr:=64
  else if VidRam<200 then vr:=128
  else if VidRam<300 then vr:=256
  else if VidRam<400 then vr:=384
  else if VidRam<600 then vr:=512
  else if VidRam<800 then vr:=792
  else if VidRam>800 then vr:=1024;

  if VidRam=0 then VideoCardNameLbl.Caption:=ExpandConstant('{cm:DeviceDriver}')
    else VideoCardNameLbl.Caption:=DelSp(VideoCardNameLbl.Caption)+' ~'+IntToStr(vr)+' MB'+Pdm;
  if vr<{#VideoCard} then begin
    RequirementsLbl.Caption:=ExpandConstant('{cm:Requirements4}');
    AddLabelToArray(ASysReq,VideoCardNameLbl);
  end;

//================= End - Video adapter =================//

//================= Home - Soundcard =================//

  SoundCardLbl := TLabel.Create(WizardForm);
  with SoundCardLbl do begin
    AutoSize:=False;
    SetBounds(ScaleX(285), ScaleY(307), ScaleX(150), ScaleY(22));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    Caption := ExpandConstant('{cm:SoundCard}');
    Parent := WizardForm;
  end;

  SoundCardNameLbl := TLabel.Create(WizardForm);
  with SoundCardNameLbl do begin
    AutoSize:=False;
    SetBounds(ScaleX(463), ScaleY(307), ScaleX(400), ScaleY(22));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    Caption := GetSoundCardName;
    Parent := WizardForm;
  end;

  if GetSoundCards = 0 then begin
    RequirementsLbl.Caption:= ExpandConstant('{cm:Requirements4}');
    SoundCardNameLbl.Caption:= ExpandConstant('{cm:DeviceDriver}');
    AddLabelToArray(ASysReq,SoundCardNameLbl);
  end;

//================= End - Soundcard =================//

//================= Start - OK =================//

  RAMLbl := TLabel.Create(WizardForm);
  with RAMLbl do begin
    AutoSize:=False;
    SetBounds(ScaleX(285), ScaleY(338), ScaleX(150), ScaleY(22));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    Caption := ExpandConstant('{cm:RAM}');
    Parent := WizardForm;
  end;

  RAMTotalLbl := TLabel.Create(WizardForm);
  with RAMTotalLbl do begin
    AutoSize:=False;
    SetBounds(ScaleX(463), ScaleY(338), ScaleX(400), ScaleY(22));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    Caption := IntToStr(GetSystemPhys + 1) + ' MB';
    Parent := WizardForm;
  end;

  if (GetSystemPhys+1)<{#RAM} then begin
    RequirementsLbl.Caption := ExpandConstant('{cm:Requirements4}');
    AddLabelToArray(ASysReq,RAMTotalLbl);
  end;

//================= End - OK =================//

//================= Start - Operating System =================//

  GetWindowsVersionEx(Version);

  SystemLbl := TLabel.Create(WizardForm);
  with SystemLbl do begin
    AutoSize:=False;
    SetBounds(ScaleX(285), ScaleY(370), ScaleX(150), ScaleY(22));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    Caption := ExpandConstant('{cm:OperationSystem}');
    Parent := WizardForm;
  end;

  SystemNameLbl := TLabel.Create(WizardForm);
  with SystemNameLbl do begin
    AutoSize:=False;
    SetBounds(ScaleX(463), ScaleY(370), ScaleX(400), ScaleY(22));
    Transparent:=True;
    Font.Name:= 'Arial';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    if Version.ProductType <> VER_NT_WORKSTATION then
      Caption := 'Windows Server'
    else if (Version.Major = 10) and (Version.Build >= 22000) then
      Caption := 'Windows 11'
    else if Version.Major = 10 then
      Caption := 'Windows 10'
    else
      Caption := Format('Windows %d.%d', [Version.Major, Version.Minor]);
    Caption := Caption + Format(' (build %d)', [Version.Build]);
    Parent := WizardForm;
  end;

  

  if not Version.NTPlatform or
    (Version.NTPlatform and (Version.Major<{#WinVerMajor})) or
    (Version.NTPlatform and (Version.Major={#WinVerMajor}) and (Version.Minor<{#WinVerMinor})) or
    (Version.NTPlatform and (Version.Major={#WinVerMajor}) and (Version.Minor={#WinVerMinor}) and (Version.ServicePackMajor<{#ServicePack})) then begin
    RequirementsLbl.Caption := ExpandConstant('{cm:Requirements4}');
    AddLabelToArray(ASysReq,SystemNameLbl);
  end;

//================= End - Operating System =================//

////////////////////// SystemPage //////////////////////

////////////////////// SelectDirPage //////////////////////

  SelectDirBrowseLabel := TLabel.Create(WizardForm);
  with SelectDirBrowseLabel do begin
    AutoSize:=False;
    SetBounds(ScaleX(340), ScaleY(200), ScaleX(500), ScaleY(50));
    WordWrap:= True;

    Transparent:=True;
    Font.Name:= 'Georgia'
    Font.Size:= 8;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    Caption:= WizardForm.SelectDirBrowseLabel.Caption;
    Parent := WizardForm;
    Visible :=false
  end;

  DirEditLabel := TLabel.Create(WizardForm);
  with DirEditLabel do begin
    AutoSize:=False;
    SetBounds(ScaleX(345), ScaleY(243), ScaleX(390), ScaleY(15));
    WordWrap:= True;
    ShowAccelChar := False;
    Transparent:=True;
    Font.Name:= 'Arial'
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    Caption := MinimizePathName(WizardForm.DirEdit.Text, DirEditLabel.Font, DirEditLabel.Width);
    Parent := WizardForm;
  end;

  TotalSpaceLabel := TLabel.Create(WizardForm);
  with TotalSpaceLabel do begin
    AutoSize:=False;
    SetBounds(ScaleX(345), ScaleY(290), ScaleX(500), ScaleY(17));
    Transparent:=True;
    Font.Name:= 'Georgia';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold, fsItalic];
    Parent := WizardForm;
  end;

  FreeSpaceLabel := TLabel.Create(WizardForm);
  with FreeSpaceLabel do begin
    AutoSize:=False;
    SetBounds(ScaleX(345), ScaleY(310), ScaleX(500), ScaleY(17));
    Transparent:=True;
    Font.Name:= 'Georgia';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold, fsItalic];
    Parent := WizardForm;
  end;

  NeedSpaceLabel := TLabel.Create(WizardForm);
  with NeedSpaceLabel do begin
    AutoSize:=False;
    SetBounds(ScaleX(345), ScaleY(330), ScaleX(500), ScaleY(17));
    Transparent:=True;
    Font.Name:= 'Georgia';
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold, fsItalic];
    Caption := ExpandConstant('{cm:NeedSpace} ') + MbOrTB({#NeedSize});
    Parent := WizardForm;
  end;

////////////////////// SelectDirPage //////////////////////

////////////////////// SelectProgramGroupPage //////////////////////

  SelectStartMenuFolderBrowseLabel := TLabel.Create(WizardForm);
  with SelectStartMenuFolderBrowseLabel do begin
    AutoSize:=False;
    SetBounds(ScaleX(340), ScaleY(200), ScaleX(500), ScaleY(50));
    WordWrap:= True;
    Transparent:=True;
    Font.Name:= 'Georgia'
    Font.Size:= 8;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    Caption:= WizardForm.SelectStartMenuFolderBrowseLabel.Caption;
    Parent := WizardForm;
  end;

  GroupEditLabel := TLabel.Create(WizardForm);
  with GroupEditLabel do begin
    AutoSize:=False;
    SetBounds(ScaleX(345), ScaleY(243), ScaleX(446), ScaleY(15));
    WordWrap:= True;
    ShowAccelChar := False;
    Transparent:=True;
    Font.Name:= 'Arial'
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold];
    Caption := MinimizePathName(WizardForm.GroupEdit.Text, GroupEditLabel.Font, GroupEditLabel.Width);
    Parent := WizardForm;
  end;

  NoIconsCheck:=BtnCreate(WizardForm.Handle,ScaleX(335),ScaleY(310),ScaleX(28),ScaleY(28),ExpandConstant('{tmp}\CheckBox.png'),8,True);
  BtnSetEvent(NoIconsCheck,BtnClickEventID,WrapBtnCallback(@NoIconsClick,1));
  BtnSetEvent(NoIconsCheck,BtnMouseEnterEventID,WrapBtnCallback(@WFBtnEnter,1));
  BtnSetCursor(NoIconsCheck,GetSysCursorHandle(32649));


  NoIconsLabel := TLabel.Create(WizardForm);
  with NoIconsLabel do begin
    AutoSize:=False;
    SetBounds(ScaleX(370), ScaleY(317), ScaleX(275), ScaleY(17));
    OnClick:= @NoIconsLabelClick;
    Cursor:= CrHand;
    Transparent:=True;
    Font.Name:= 'Georgia'
    Font.Size:= 10;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold,fsItalic];
    Caption := WizardForm.NoIconsCheck.Caption;
    Parent := WizardForm;
  end;

  WizardForm.DirEdit.OnChange := @GetFreeSpaceCaption;
  WizardForm.DirEdit.Text:= WizardForm.DirEdit.Text;
  WizardForm.GroupEdit.OnChange := @GroupChange;

////////////////////// SelectProgramGroupPage //////////////////////

////////////////////// SelectTasksPade //////////////////////

  SelectTasksPage := CreateCustomPage(wpSelectProgramGroup, ExpandConstant('{cm:TasksName}'), ExpandConstant('{cm:TasksDescription}'));
  SelectTasksLabel := TLabel.Create(WizardForm);
  with SelectTasksLabel do begin
    Alignment := taCenter;
    AutoSize:=False;
    SetBounds(ScaleX(240), ScaleY(200), ScaleX(600), ScaleY(50));
    WordWrap:= True;
    Transparent:=True;
    Font.Name:= 'Georgia'
    Font.Size:= 10;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold, fsItalic];
    Caption:= ExpandConstant('{cm:SelectTasksLabel}');
    Parent := WizardForm;
  end;

  DesktopCheck:=BtnCreate(WizardForm.Handle,ScaleX(255),ScaleY(310),ScaleX(28),ScaleY(28),ExpandConstant('{tmp}\CheckBox.png'),8,True);
  BtnSetEvent(DesktopCheck,BtnClickEventID,WrapBtnCallback(@DesktopClick,1));
  BtnSetEvent(DesktopCheck,BtnMouseEnterEventID,WrapBtnCallback(@WFBtnEnter,1));
  BtnSetCursor(DesktopCheck,GetSysCursorHandle(32649));

  DesktopLabel := TLabel.Create(WizardForm);
  with DesktopLabel do begin
    AutoSize:=False;
    SetBounds(ScaleX(290), ScaleY(317), ScaleX(265), ScaleY(17));
    OnClick:= @DesktopLabelClick;
    Cursor:= CrHand;
    Transparent:=True;
    Font.Name:= 'Georgia'
    Font.Size:= 10;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold,fsItalic];
    Caption := ExpandConstant('{cm:Desktop}');
    Parent := WizardForm;
  end;

  QuickLaunchCheck:=BtnCreate(WizardForm.Handle,ScaleX(255),ScaleY(333),ScaleX(28),ScaleY(28),ExpandConstant('{tmp}\CheckBox.png'),8,True);
  BtnSetEvent(QuickLaunchCheck,BtnClickEventID,WrapBtnCallback(@QuickLaunchClick,1));
  BtnSetEvent(QuickLaunchCheck,BtnMouseEnterEventID,WrapBtnCallback(@WFBtnEnter,1));
  BtnSetCursor(QuickLaunchCheck,GetSysCursorHandle(32649));

  QuickLaunchLabel := TLabel.Create(WizardForm);
  with QuickLaunchLabel do begin
    AutoSize:=False;
    SetBounds(ScaleX(290), ScaleY(340), ScaleX(345), ScaleY(17));
    OnClick:= @QuickLaunchLabelClick;
    Cursor:= CrHand;
    Transparent:=True;
    Font.Name:= 'Georgia'
    Font.Size:= 10;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold,fsItalic];
    Caption := ExpandConstant('{cm:QuickLaunch}');
    Parent := WizardForm;
  end;

  LanguageButton[1]:=BtnCreate(WizardForm.Handle,ScaleX(395),ScaleY(403),ScaleX(48),ScaleY(36),ExpandConstant('{tmp}\ru.png'),0,True);

  BtnSetEvent(LanguageButton[1],BtnMouseEnterEventID,WrapBtnCallback(@WFBtnEnter,1));
  BtnSetCursor(LanguageButton[1],GetSysCursorHandle(32649));

  LanguageButton[2]:=BtnCreate(WizardForm.Handle,ScaleX(460),ScaleY(403),ScaleX(48),ScaleY(36),ExpandConstant('{tmp}\us.png'),0,True);

  BtnSetEvent(LanguageButton[2],BtnMouseEnterEventID,WrapBtnCallback(@WFBtnEnter,1));
  BtnSetCursor(LanguageButton[2],GetSysCursorHandle(32649));

  BtnSetChecked(LanguageButton[1],True);

////////////////////// SelectTasksPade //////////////////////

////////////////////// InstallingPage //////////////////////

  StatusLabel := TLabel.Create(WizardForm);
  with StatusLabel do begin
    AutoSize:=False;
    SetBounds(ScaleX(250), ScaleY(245), ScaleX(558), ScaleY(17));
    Transparent:=True;
    Font.Name:= 'Georgia'
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold,fsItalic];
    Parent := WizardForm;
  end;

  FilenameLabel := TLabel.Create(WizardForm);
  with FilenameLabel do begin
    AutoSize:=False;
    SetBounds(ScaleX(250), ScaleY(270), ScaleX(558), ScaleY(17));
    Transparent:=True;
    Font.Name:= 'Georgia'
    Font.Size:= 9;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold,fsItalic];
    Parent := WizardForm;
  end;



////////////////////// InstallingPage //////////////////////

////////////////////// FinishedPage //////////////////////

  FinishedHeadingLabel:= TLabel.Create(WizardForm);
  with FinishedHeadingLabel do begin
    AutoSize:=False
    SetBounds(ScaleX(227), ScaleY(145), ScaleX(648), ScaleY(200));
    WordWrap:=True
    Alignment := taCenter;
    Transparent:=True
    Font.Name:='Georgia';
    Font.Size:= 12;
    Font.Color:=$FFFFFF;
    Font.Style:=[fsBold]
    Caption:= ExpandConstant('{cm:FinishedHeading}');
    Parent:=WizardForm
  end;


  FinishedLabel:=TLabel.Create(WizardForm);
  with FinishedLabel do begin
    AutoSize:=False
    SetBounds(ScaleX(227), ScaleY(215), ScaleX(648), ScaleY(65));
    WordWrap:=True
    Transparent:=True
    Alignment := taCenter;
    Font.Name:='Georgia';
    Font.Size:= 10;
    Font.Color:=$FFFFFF;
    Font.Style := [fsBold, fsItalic];
    Caption:= ExpandConstant('{cm:FinishedLabel}')+#13#13+ExpandConstant('{cm:FinishedLabel2}');
    Parent:=WizardForm
  end;
end;

////////////////////// FinishedPage //////////////////////

////////////////////// UninstallingPage //////////////////////

function InitializeUninstall: Boolean;
begin
  CopyFile(ExpandConstant('{#UninstallAssets}\botva2.dll'), ExpandConstant('{tmp}\botva2.dll'), False);
  CopyFile(ExpandConstant('{#UninstallAssets}\InnoCallback.dll'), ExpandConstant('{tmp}\InnoCallback.dll'), False);
  CopyFile(ExpandConstant('{#UninstallAssets}\isskin.dll'), ExpandConstant('{tmp}\isskin.dll'), False);
  CopyFile(ExpandConstant('{#UninstallAssets}\Tiger.cjstyles'), ExpandConstant('{tmp}\Tiger.cjstyles'), False);
  LoadSkin(ExpandConstant('{tmp}\Tiger.cjstyles'), '');
  Result:=True;
end;

//================== Deleting saves ==================//

procedure DeleteSavedGames(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep=usUninstall then
  if DirExists(ExpandConstant('{userdocs}')+'\NFS Undercover') then
  if MsgBox(ExpandConstant('{cm:DeleteSave}'), mbInformation, MB_YESNO) = idYes then
  DelTree(ExpandConstant('{userdocs}')+'\NFS Undercover', True, True, True)
end;

//================== Deleting saves ==================//

procedure InitializeUninstallProgressForm;
var
  h:HWND;
begin
  with UninstallProgressForm do
  begin
    ClientWidth:=ScaleX(798);
    ClientHeight:=ScaleY(543);
    BorderStyle:=bsSingle
    BorderIcons:=[biSystemMenu]
    OuterNotebook.Hide;
    InnerNotebook.Hide;
    //Center;
    Bevel.Hide;
    CancelButton.Left:=ScaleX(660);
    CancelButton.Top:=ScaleY(495);
    CancelButton.Width:=CancelButton.Width+15;

    WizardUninstLabel := TLabel.Create(UninstallProgressForm);
    with WizardUninstLabel do begin
      AutoSize:=False;
      SetBounds(ScaleX(70), ScaleY(185), ScaleX(400), ScaleY(30));
      Transparent:=True;
      Font.Name:= 'Georgia'
      Font.Size:= 13;
      Font.Color:=$FFFFFF;
      Font.Style:=[fsBold];
      Caption:= ExpandConstant('{cm:WizardUninst}');
      Parent := UninstallProgressForm;
    end;

    UninstPageDescriptLabel := TLabel.Create(UninstallProgressForm);
    with UninstPageDescriptLabel do begin
      AutoSize:=False;
      SetBounds(ScaleX(100), ScaleY(215), ScaleX(600), ScaleY(50));
      WordWrap:= True;
      Transparent:=True;
      Font.Name:= 'Georgia'
      Font.Size:= 10;
      Font.Color:=$FFFFFF;
      Font.Style:=[fsBold, fsItalic];
      Caption:= ExpandConstant('{cm:UninstDescript}');
      Parent := UninstallProgressForm;
    end;

    StatusUninstLabel := TLabel.Create(UninstallProgressForm);
    with StatusUninstLabel do begin
      AutoSize:=False;
      SetBounds(ScaleX(120), ScaleY(250), ScaleX(560), ScaleY(17));
      Transparent:=True;
      Font.Name:= 'Georgia'
      Font.Size:= 10;
      Font.Color:=$FFFFFF;
      Font.Style:=[fsBold, fsItalic];
      Caption:= ExpandConstant('{cm:StatusUninst}');
      Parent := UninstallProgressForm;
    end;

    Installing := TLabel.Create(UninstallProgressForm);
    with  Installing do begin
      AutoSize:=False;
      SetBounds(ScaleX(170), ScaleY(96), ScaleX(114), ScaleY(20));
      Transparent:=True;
      Font.Name:= 'Arial';
      Font.Size:= 10;
      Font.Color:=$FFFFFF;
      Font.Style:=[fsBold];
      Caption := ExpandConstant('{cm:Installing}');
      Parent := UninstallProgressForm;
    end;

    Uninstalling := TLabel.Create(UninstallProgressForm);
    with  Uninstalling do begin
      AutoSize:=False;
      SetBounds(ScaleX(570), ScaleY(96), ScaleX(114), ScaleY(20));
      Transparent:=True;
      Font.Name:= 'Arial';
      Font.Size:= 10;
      Font.Color:=$00FFFF;
      Font.Style:=[fsBold];
      Caption := ExpandConstant('{cm:Uninstalling}');
      Parent := UninstallProgressForm;
    end;

    ProgressInfoLabel := TLabel.Create(UninstallProgressForm);
    with ProgressInfoLabel do begin
      AutoSize:=False;
      SetBounds(ScaleX(120), ScaleY(355), ScaleX(560), ScaleY(17));
      Alignment := taCenter;
      Transparent:=True;
      Font.Name:= 'Georgia';
      Font.Size:= 10;
      Font.Color:=$FFFFFF;
      Font.Style:=[fsBold,fsItalic];
      Parent := UninstallProgressForm;
    end;

    h:=UninstallProgressForm.Handle;

    CopyFile(ExpandConstant('{#UninstallAssets}\WizardImage.jpg'), ExpandConstant('{tmp}\WizardImage.jpg'), False);
    CopyFile(ExpandConstant('{#UninstallAssets}\button.png'), ExpandConstant('{tmp}\button.png'), False);

    ImgLoad(h,ExpandConstant('{tmp}\WizardImage.jpg'),ScaleX(0),ScaleY(0),UninstallProgressForm.ClientWidth,UninstallProgressForm.ClientHeight,True,True);

    UPFButtonFont:=TFont.Create;
    UPFButtonFont.Style:=[fsBold];

    UninstallProgressForm.CancelButton.Visible:=False;
    with UninstallProgressForm.CancelButton do begin
      hCancelUninstBtn:=BtnCreate(h,Left-8,Top-8,Width+16,Height+16,ExpandConstant('{tmp}\button.png'),18,False);
      BtnSetText(hCancelUninstBtn, UninstallProgressForm.CancelButton.Caption);
      BtnSetFont(hCancelUninstBtn,UPFButtonFont.Handle);
      BtnSetFontColor(hCancelUninstBtn,$DAE369,$DAE369,$DAE369,$B6B6B6);
      BtnSetEnabled(hCancelUninstBtn,False);
    end;
  end;
  ImgApplyChanges(h);
end;

////////////////////// UninstallingPage //////////////////////

procedure HideComponents;
begin
  WelcomeLabel1.Hide;
  WelcomeLabel2.Hide;
  RequirementsLbl.Hide;
  ProcessorLbl.Hide;
  ProcessorNameLbl.Hide;
  VideoCardLbl.Hide;
  VideoCardNameLbl.Hide;
  SoundCardLbl.Hide;
  SoundCardNameLbl.Hide;
  RAMLbl.Hide;
  RAMTotalLbl.Hide;
  SystemLbl.Hide;
  SystemNameLbl.Hide;
  SelectDirBrowseLabel.Hide;
  DirEditLabel.Hide;
  TotalSpaceLabel.Hide;
  FreeSpaceLabel.Hide;
  NeedSpaceLabel.Hide;
  NoIconsLabel.Hide;
  SelectStartMenuFolderBrowseLabel.Hide;
  WizardForm.GroupBrowseButton.Hide;
  GroupEditLabel.Hide;
  SelectTasksLabel.Hide;
  DesktopLabel.Hide;
  QuickLaunchLabel.Hide;

  StatusLabel.Hide;
  FilenameLabel.Hide;
  FinishedHeadingLabel.Hide;
  FinishedLabel.Hide;

end;

procedure ShowComponents(CurPageID: Integer);
begin
  PageNameLabel.Caption:=WizardForm.PageNameLabel.Caption
  PageDescriptionLabel.Caption:=WizardForm.PageDescriptionLabel.Caption

    ImgSetVisibility(work1,False);
  ImgSetVisibility(work2,False);
  ImgSetVisibility(work3,False);
  ImgSetVisibility(work4,False);
  ImgSetVisibility(work5,False);
  ImgSetVisibility(work6,False);

  case CurPageID of
    wpWelcome:
    begin
    ImgSetVisibility(work1,True);
      //Welcome.Font.Color := $00FFFF;
      ImgSetPosition(StatusPanel,ScaleX(0),ScaleY(95),ScaleX(114),ScaleY(20));
      WelcomeLabel1.Show
      WelcomeLabel2.Show
    end;

    SystemPage.ID:
    begin
    ImgSetVisibility(work2,True);
      //System.Font.Color := $00FFFF;
      ImgSetPosition(StatusPanel,ScaleX(114),ScaleY(95),ScaleX(114),ScaleY(20));
      ImgSetVisibility(RequirementsPanel,True);
      RequirementsLbl.Show;
      ProcessorLbl.Show;
      ProcessorNameLbl.Show;
      VideoCardLbl.Show;
      VideoCardNameLbl.Show;
      SoundCardLbl.Show;
      SoundCardNameLbl.Show;
      RAMLbl.Show;
      RAMTotalLbl.Show;
      SystemLbl.Show;
      SystemNameLbl.Show;
    end;

    wpSelectDir:
    begin
    ImgSetVisibility(work3,True);
      //Catalogue.Font.Color := $00FFFF;
      ImgSetPosition(StatusPanel,ScaleX(228),ScaleY(95),ScaleX(114),ScaleY(20));
      ImgSetVisibility(Edit,True);
      ImgSetVisibility(DirFolder,True);
      ImgSetVisibility(HardDrivePanel,True);
      ImgSetVisibility(HDD,True);
      BtnSetVisibility(hDirBrowseBtn,True);
      SelectDirBrowseLabel.Show
      DirEditLabel.Show;
      TotalSpaceLabel.Show;
      FreeSpaceLabel.Show;
      NeedSpaceLabel.Show;
    end;

    wpSelectProgramGroup:
    begin
    ImgSetVisibility(work4,True);
      //StartMenu.Font.Color := $00FFFF;
      ImgSetPosition(StatusPanel,ScaleX(342),ScaleY(95),ScaleX(114),ScaleY(20));
      ImgSetVisibility(GroupFolder,True);
      ImgSetVisibility(Edit,True);
      BtnSetVisibility(hGroupBrowseBtn,True);
      BtnSetVisibility(NoIconsCheck,True);
      SelectStartMenuFolderBrowseLabel.Show;
      WizardForm.GroupBrowseButton.Show;
      GroupEditLabel.Show;
      NoIconsLabel.Show;
    end;

    SelectTasksPage.ID:
    begin
    ImgSetVisibility(work5,True);
      ImgSetPosition(StatusPanel,ScaleX(456),ScaleY(95),ScaleX(114),ScaleY(20));
      BtnSetVisibility(DesktopCheck,True);
      BtnSetVisibility(QuickLaunchCheck,True);
      BtnSetVisibility(DirectXCheck,True);
      BtnSetVisibility(LanguageButton[1],FALSE);
      BtnSetVisibility(LanguageButton[2],FALSE);
      BtnSetChecked(DirectXCheck,True);
      SelectTasksLabel.Show;
      DesktopLabel.Show;
      QuickLaunchLabel.Show;

      WizardForm.NextButton.Caption:=SetupMessage(msgButtonInstall);
    end;

    wpInstalling:
    begin
ImgSetVisibility(work6,True);
ImgSetPosition(StatusPanel,ScaleX(570),ScaleY(95),ScaleX(114),ScaleY(20));
StatusLabel.Show;
end;

    wpFinished:
    begin
    ImgSetVisibility(work7,True);
      ImgSetPosition(StatusPanel,ScaleX(684),ScaleY(95),ScaleX(114),ScaleY(20));
      BtnSetPosition(hNextBtn, ScaleX(585),ScaleY(430),ScaleX(106),ScaleY(39));
      FinishedHeadingLabel.Show;
      FinishedLabel.Show;
    end
  end;
  ImgApplyChanges(WizardForm.Handle);
end;

//************************************************ [End - Page Components] ***************************************************//

//************************************************ [Start - Programs] ***************************************************//
//************************************************ [End - Programs] ***************************************************//

procedure InitializeWizard;
begin
  CreateWizardImage;
  ButtonsTextures;
  InsertMusic;
  CreatePageComponents;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  CurPageChanged2(CurPageID);
  SetStateNewButtons;
  HideComponents;
  ImgSetVisibility(RequirementsPanel,False);
  ImgSetVisibility(Edit,False);
  ImgSetVisibility(DirFolder,False);
  BtnSetVisibility(hDirBrowseBtn,False);
  ImgSetVisibility(HardDrivePanel,False);
  ImgSetVisibility(HDD,False);
  ImgSetVisibility(GroupFolder,False);
  BtnSetVisibility(hGroupBrowseBtn,False);
  BtnSetVisibility(NoIconsCheck,False);
  BtnSetVisibility(DesktopCheck,False);
  BtnSetVisibility(QuickLaunchCheck,False);
  BtnSetVisibility(DirectXCheck,False);
  BtnSetVisibility(LanguageButton[1],False);
  BtnSetVisibility(LanguageButton[2],False);

  ShowComponents(CurPageID);
  ImgApplyChanges(WizardForm.Handle);

  if GetArrayLength(ASysReq)>0 then
    if CurPageID=SystemPage.ID then SetTimer(WizardForm.Handle,WFSysReqTimerID,1000,WrapTimerProc(@SysReqFlashing,4))
      else KillTimer(WizardForm.Handle,WFSysReqTimerID);

  if CurPageID=wpSelectDir then begin
    OldDisk:='';
    GetFreeSpaceCaption(nil);
  end else if GetArrayLength(ADisk)>0 then KillTimer(WizardForm.Handle,WFDiskTimerID);
end;

procedure DeinitializeSetup;
begin
  gdipShutdown;
    BASS_Stop;
    BASS_Free;
    WFButtonFont.Free;
    ShowWindow(StrToInt(ExpandConstant('{wizardhwnd}')),0);
  	UnloadSkin;
	  SetArrayLength(AImg,0);
  end;

procedure DeinitializeUninstall;
begin
  gdipShutdown;
  UnloadSkin;
  if Assigned(UPFButtonFont) then UPFButtonFont.Free;
end;

//------------[NO LONGER]------------//

procedure AllCancel;
begin
   SetWindowLong(WizardForm.ProgressGauge.Handle,-4,PBOldProc);
   ImgPBDelete(NewPB);
   ImgPBDelete(NewPB2);
   ImgApplyChanges(WizardForm.Handle);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  case CurStep of
    ssInstall: begin
    CurStepChanged2(CurStep);
    NewPB:=ImgPBCreate(WizardForm.Handle, ExpandConstant('{tmp}\ProgressBackground.png'), ExpandConstant('{tmp}\ProgressImg.png'),ScaleX(250),ScaleY(300),ScaleX(560),ScaleY(25));
    ImgApplyChanges(WizardForm.Handle);
    PBOldProc:=SetWindowLong(WizardForm.ProgressGauge.Handle,-4,CallBackProc(@PBProc,4));
   end;
   ssPostInstall: AllCancel;
  end;
end;

procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
   if CurPageID=wpInstalling then begin
   Confirm:=False;
   Cancel:=ExitSetupMsgBox;
   if Cancel then AllCancel;
  end;
end;

//------------[PROGRAM]------------//


