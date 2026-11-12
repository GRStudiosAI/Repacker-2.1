[Code]
type
  TImgPB = record
    Left,
    Top,
    Width,
    Height,
    MaxWidth  : integer;
    img1,img2 : Longint;
  end;

var
  NewPB   : TImgPB;
  PBOldProc: Longint;
  eTime, sTime  : DWORD;

function CallBackProc(P:TPBProc;ParamCount:integer):LongWord; external 'wrapcallback@files:innocallback.dll stdcall';
function CallWindowProc(lpPrevWndFunc: Longint; hWnd: HWND; Msg: UINT; wParam, lParam: Longint): Longint; external 'CallWindowProcA@user32.dll stdcall';
function GetTickCount: DWORD; external 'GetTickCount@kernel32.dll stdcall';

function ImgPBCreate(hParent :HWND; bk, pb :ansistring; Left, Top, Width, Height :integer):TImgPB;
begin
  Result.Left:=Left+2;
  Result.Top:=Top+2;
  Result.Width:=0;
  Result.Height:=Height-4;
  Result.MaxWidth:=Width-4;
  if Length(pb)>0 then Result.img1:=ImgLoad(hParent,pb,Result.Left,Result.Top,0,Result.Height,True,False) else Result.img1:=0;
  if Length(bk)>0 then Result.img2:=ImgLoad(hParent,bk,Left,Top,Width,Height,True,False) else Result.img2:=0;
end;

function LongintToStringTime(t:Longint):string;
var
   h,m,s:integer;
begin
   h:=t div 3600;
   t:=t-h*3600;
   m:=t div 60;
   s:=t-m*60;
   Result:='';
   if h>0 then Result:=Result+IntToStr(h)+' h ';
   if (m>0) or (h>0) then Result:=Result+IntToStr(m)+' min ';
   if (m>0) or (h>0) or (s>0) then Result:=Result+IntToStr(s)+' s';
end;

procedure ImgPBSetPosition(var PB :TImgPB; Percent :Extended);
var
  NewWidth:integer;
begin
  if PB.img1<>0 then begin
    NewWidth:=Round(PB.MaxWidth*Percent/100);
    if PB.Width<>NewWidth then begin
      PB.Width:=NewWidth;
      ImgSetPosition(PB.img1,PB.Left,PB.Top,PB.Width,PB.Height);
    end;
  end;
end;

procedure ImgPBDelete(var PB :TImgPB);
begin
  if PB.img1<>0 then ImgRelease(PB.img1);
  if PB.img2<>0 then ImgRelease(PB.img2);
  PB.img1:=0;
  PB.img2:=0;
end;

function PBProc(h:hWnd;Msg,wParam,lParam:Longint):Longint;
var
   lt:Longint;
   dt,at,pr,i1,i2:Extended;
   p:string;
   tc:DWORD;
begin
   Result:=CallWindowProc(PBOldProc,h,Msg,wParam,lParam);
   if (Msg=$402) and (WizardForm.ProgressGauge.Position>WizardForm.ProgressGauge.Min) then begin
   i1:=WizardForm.ProgressGauge.Position-WizardForm.ProgressGauge.Min;
   i2:=WizardForm.ProgressGauge.Max-WizardForm.ProgressGauge.Min;

   tc:=GetTickCount;
   if (tc-eTime)>=1000 then begin 
   dt:=(tc-sTime)/1000;
   at:=i2*dt/i1;
   lt:=Round(at-dt)
   eTime:=tc;
end;

   pr:=i1*100/i2;
   p:=' - ['+Format('%f',[pr])+'%]';
   StringChange(p,',','.');

   ImgPBSetPosition(NewPB,pr);
   ImgApplyChanges(WizardForm.Handle);
  end;
end;
