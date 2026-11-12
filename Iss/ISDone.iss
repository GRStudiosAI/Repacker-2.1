[UninstallDelete]
Type: filesandordirs; Name: {app}

[Code]
var
  LabelPct1: TLabel;
  NewPB2         : TImgPB;
  CancelUnpackingBtn: HWND;
const
  PCFonFLY=true;
  notPCFonFLY=false;
var
  ISDoneCancel:integer;
  ISDoneError:boolean;
  PCFVer:double;

type
  TCallback = function (OveralPct,CurrentPct: integer;CurrentFile,TimeStr1,TimeStr2,TimeStr3:PAnsiChar): longword;

function WrapCallback(callback:TCallback; paramcount:integer):longword;external 'wrapcallback@files:ISDone.dll stdcall delayload';

function ISArcExtract(CurComponent:Cardinal; PctOfTotal:double; InName, OutPath, ExtractedPath: AnsiString; DeleteInFile:boolean; Password, CfgFile, WorkPath: AnsiString; ExtractPCF: boolean ):boolean; external 'ISArcExtract@files:ISDone.dll stdcall delayload';
function IS7ZipExtract(CurComponent:Cardinal; PctOfTotal:double; InName, OutPath: AnsiString; DeleteInFile:boolean; Password: AnsiString):boolean; external 'IS7zipExtract@files:ISDone.dll stdcall delayload';
function ISRarExtract(CurComponent:Cardinal; PctOfTotal:double; InName, OutPath: AnsiString; DeleteInFile:boolean; Password: AnsiString):boolean; external 'ISRarExtract@files:ISDone.dll stdcall delayload';
function ISPrecompExtract(CurComponent:Cardinal; PctOfTotal:double; InName, OutFile: AnsiString; DeleteInFile:boolean):boolean; external 'ISPrecompExtract@files:ISDone.dll stdcall delayload';
function ISSRepExtract(CurComponent:Cardinal; PctOfTotal:double; InName, OutFile: AnsiString; DeleteInFile:boolean):boolean; external 'ISSrepExtract@files:ISDone.dll stdcall delayload';
function ISxDeltaExtract(CurComponent:Cardinal; PctOfTotal:double; minRAM,maxRAM:integer; InName, DiffFile, OutFile: AnsiString; DeleteInFile:boolean):boolean; external 'ISxDeltaExtract@files:ISDone.dll stdcall delayload';
function ISPackZIP(CurComponent:Cardinal; PctOfTotal:double; InName, OutFile: AnsiString;ComprLvl:integer; DeleteInFile:boolean):boolean; external 'ISPackZIP@files:ISDone.dll stdcall delayload';
function ShowChangeDiskWindow(Text, DefaultPath, SearchFile:AnsiString):boolean; external 'ShowChangeDiskWindow@files:ISDone.dll stdcall delayload';

function Exec2 (FileName, Param: PAnsiChar;Show:boolean):boolean; external 'Exec2@files:ISDone.dll stdcall delayload';
function ISFindFiles(CurComponent:Cardinal; FileMask:AnsiString; var ColFiles:integer):integer; external 'ISFindFiles@files:ISDone.dll stdcall delayload';
function ISPickFilename(FindHandle:integer; OutPath:AnsiString; var CurIndex:integer; DeleteInFile:boolean):boolean; external 'ISPickFilename@files:ISDone.dll stdcall delayload';
function ISGetName(TypeStr:integer):PAnsichar; external 'ISGetName@files:ISDone.dll stdcall delayload';
function ISFindFree(FindHandle:integer):boolean; external 'ISFindFree@files:ISDone.dll stdcall delayload';
function ISExec(CurComponent:Cardinal; PctOfTotal,SpecifiedProcessTime:double; ExeName,Parameters,TargetDir,OutputStr:AnsiString):boolean; external 'ISExec@files:ISDone.dll stdcall delayload';

function SrepInit(TmpFile:PAnsiChar;VirtMem,MaxSave:Cardinal):boolean; external 'SrepInit@files:ISDone.dll stdcall delayload';
function PrecompInit(PrecompVers:single):boolean; external 'PrecompInit@files:ISDone.dll stdcall delayload';
function FileSearchInit(RecursiveSubDir:boolean):boolean; external 'FileSearchInit@files:ISDone.dll stdcall delayload';
function ISDoneInit(RecordFileName:AnsiString; TimeType,Comp1,Comp2,Comp3:Cardinal; WinHandle, NeededMem:longint; callback:TCallback):boolean; external 'ISDoneInit@files:ISDone.dll stdcall';
function ISDoneStop:boolean; external 'ISDoneStop@files:ISDone.dll stdcall';

function ProgressCallback(OveralPct,CurrentPct: integer;CurrentFile,TimeStr1,TimeStr2,TimeStr3:PAnsiChar): longword;
begin
  ImgPBSetPosition(NewPB2,OveralPct/10);
  LabelPct1.Caption := 'Done: '+ IntToStr(OveralPct div 10)+'.'+chr(48 + OveralPct mod 10)+'%';
  ImgApplyChanges(WizardForm.Handle);
  ImgApplyChanges(WizardForm.Handle);
  Result := ISDoneCancel;
end;

procedure CancelUnpackingOnClick(hBtn:HWND);
begin
if MsgBox( SetupMessage( msgExitSetupMessage ), mbConfirmation, MB_YESNO ) = IDYES then
ISDoneCancel:= 1;
end;

procedure HideControls;
begin
LabelPct1.Hide;
end;

procedure ShowComponents2;
begin
    LabelPct1 := TLabel.Create(WizardForm);
  with LabelPct1 do begin
    BringToFront;
    AutoSize:=False;
    SetBounds(ScaleX(250), ScaleY(330), ScaleX(638), ScaleY(17));
    Transparent:=True;
    Font.Name:= 'Arial'
    Font.Size:= 9;
    Font.Color:=clwhite;
    Font.Style:=[fsBold, fsItalic];
    Parent := WizardForm;
  end;
  end;

Procedure CurPageChanged2(CurPageID: Integer);
Begin
  if (CurPageID = wpFinished) and ISDoneError then
  begin
  WizardForm.Caption:=ExpandConstant('{cm:Error}');
  StatusLabel.Caption:='Install rollback...'
  FinishedHeadingLabel.Font.Color:=clred;
  FinishedLabel.Font.Color:=clred;
  FinishedHeadingLabel.Caption:=ExpandConstant('{cm:Error2}');
  FinishedLabel.Caption:=ExpandConstant('{cm:Error3}');
  end;
  end;

function CheckError:boolean;
begin
  result:= not ISDoneError;
end;

procedure CurStepChanged2(CurStep: TSetupStep);
var Comps1,Comps2,Comps3:longword;
#ifdef Components
    TmpValue:longword;
#endif
begin
  if CurStep = ssInstall then begin
    ShowComponents2;
    BtnSetEvent(hCancelBtn,BtnClickEventID,WrapBtnCallback(@CancelUnpackingOnClick,1));
    NewPB2:=ImgPBCreate(WizardForm.Handle, ExpandConstant('{tmp}\ProgressBackground.png'), ExpandConstant('{tmp}\ProgressImg.png'),ScaleX(250),ScaleY(300),ScaleX(560),ScaleY(25));
    BtnSetText(CancelUnpackingBtn,WizardForm.CancelButton.Caption);
    LabelPct1.Show;
    ImgApplyChanges(WizardForm.Handle);
    ISDoneCancel:=0;
    StatusLabel.Caption:='Unpacking files...'

// Extract all necessary files to the {tmp} folder.
#ifdef facompress
    ExtractTemporaryFile('facompress.dll'); //speeds up the unpacking of .arc archives.
#endif
#ifdef SrepInside
    ExtractTemporaryFile('arc.ini');
    ExtractTemporaryFile('srep.exe');
#endif
#ifdef records
    ExtractTemporaryFile('records.inf');
#endif
#ifdef precomp
  #if precomp == "0.38"
      ExtractTemporaryFile('precomp038.exe');
  #else
    #if precomp == "0.4"
      ExtractTemporaryFile('precomp040.exe');
    #else
      #if precomp == "0.41"
      ExtractTemporaryFile('precomp041.exe');
      #else
      ExtractTemporaryFile('precomp038.exe');
      ExtractTemporaryFile('precomp040.exe');
      ExtractTemporaryFile('precomp041.exe');
      #endif
    #endif
  #endif
#endif
#ifdef unrar
    ExtractTemporaryFile('Unrar.dll');
#endif
#ifdef XDelta
    ExtractTemporaryFile('XDelta3.dll');
#endif
#ifdef PackZIP
    ExtractTemporaryFile('7z.dll');
    ExtractTemporaryFile('PackZIP.exe');
#endif

// We prepare a variable containing all information about the selected components for ISDone.dll
// maximum 96 components.
    Comps1:=0; Comps2:=0; Comps3:=0;
#ifdef Components
    TmpValue:=1;
    if IsComponentSelected('text\rus') then Comps1:=Comps1+TmpValue;     //component 1
    TmpValue:=TmpValue*2;
    if IsComponentSelected('text\eng') then Comps1:=Comps1+TmpValue;     //component 2
    TmpValue:=TmpValue*2;
    if IsComponentSelected('voice\rus') then Comps1:=Comps1+TmpValue;    //component 3
    TmpValue:=TmpValue*2;
    if IsComponentSelected('voice\eng') then Comps1:=Comps1+TmpValue;    //component 4
//    .....
// see help
#endif

#ifdef precomp
  PCFVer:={#precomp};
#else
  PCFVer:=0;
#endif
    ISDoneError:=true;
    if ISDoneInit(ExpandConstant('{src}\records.inf'), $F777, Comps1,Comps2,Comps3, WizardForm.Handle, 512, @ProgressCallback) then begin
      repeat
        if not SrepInit('',512,0) then break;
        if not PrecompInit(PCFVer) then break;
        if not FileSearchInit(false) then break;
        ISDoneError:=false;
        // Data will be extracted. Change filename
#ifdef OnlinePayload
        if not ISArcExtract ( 0, 100, ExpandConstant('{tmp}\data.bin'), ExpandConstant('{app}'), '', false, '', '', ExpandConstant('{app}'), notPCFonFLY {PCFonFLY}) then break;
#else
        if not ISArcExtract ( 0, 0, ExpandConstant('{src}\*.bin'), ExpandConstant('{app}'), '', false, '', '', ExpandConstant('{app}'), notPCFonFLY {PCFonFLY}) then break;
#endif
        ImgPBDelete(NewPB);
        ImgPBDelete(NewPB2);
        ISDoneError:=false;
      until true;
      ISDoneStop;
    end;
    HideControls;
  end;
  if (CurStep=ssPostInstall) and ISDoneError then begin
    Exec2(ExpandConstant('{uninstallexe}'), '/SILENT', false);
    ImgSetVisibility(pb,false);
    ImgSetVisibility(pb1,false);
    ImgPBDelete(NewPB);
   ImgPBDelete(NewPB2);
  end;
end;
