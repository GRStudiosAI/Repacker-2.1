; Compile this script to build MoviePlayer.exe directly.
[Setup]
AppName=GR Catgirl Player
AppVersion=1.0.0
AppPublisher=GR Studios AI LLC
DefaultDirName={localappdata}\GR Studios AI\MoviePlayer
PrivilegesRequired=lowest
SetupArchitecture=x86
Uninstallable=no
CreateUninstallRegKey=no
OutputDir=Output
OutputBaseFilename=GRCatgirlPlayer
Compression=lzma2
SetupIconFile=PlayerUI\GRCatgirl.ico

[Files]
Source: "PlayerUI\Launcher.bmp"; Flags: dontcopy

Source: "PlayerUI\GRCatgirl.ico"; Flags: dontcopy

Source: "PlayerUI\character.bmp"; Flags: dontcopy
Source: "PlayerUI\banner.bmp"; Flags: dontcopy

Source: "PlayerUI\profile.bmp"; Flags: dontcopy

Source: "PlayerUI\bass24.dll"; Flags: dontcopy skipifsourcedoesntexist

Source: "PlayerUI\VolumeTrack.bmp"; Flags: dontcopy
Source: "PlayerUI\VolumeFill.bmp"; Flags: dontcopy
Source: "PlayerUI\VolumeThumb.bmp"; Flags: dontcopy
Source: "PlayerUI\EqKnob.bmp"; Flags: dontcopy

Source: "PlayerUI\VizColor0.bmp"; Flags: dontcopy
Source: "PlayerUI\VizColor1.bmp"; Flags: dontcopy
Source: "PlayerUI\VizColor2.bmp"; Flags: dontcopy
Source: "PlayerUI\VizColor3.bmp"; Flags: dontcopy
#if !FileExists(SourcePath + "PlayerUI\GRVideoBridge.dll")
  #error Build the x86 FFmpeg playback bridge as PlayerUI\GRVideoBridge.dll before compiling this script.
#endif
Source: "PlayerUI\GRVideoBridge.dll"; DestDir: "{tmp}\PlayerUI"; Flags: dontcopy
Source: "PlayerUI\avcodec-63.dll"; DestDir: "{tmp}\PlayerUI"; Flags: dontcopy
Source: "PlayerUI\avformat-63.dll"; DestDir: "{tmp}\PlayerUI"; Flags: dontcopy
Source: "PlayerUI\avutil-61.dll"; DestDir: "{tmp}\PlayerUI"; Flags: dontcopy
Source: "PlayerUI\swscale-10.dll"; DestDir: "{tmp}\PlayerUI"; Flags: dontcopy
Source: "PlayerUI\swresample-7.dll"; DestDir: "{tmp}\PlayerUI"; Flags: dontcopy
Source: "PlayerUI\avfilter-12.dll"; DestDir: "{tmp}\PlayerUI"; Flags: dontcopy
Source: "PlayerUI\avdevice-63.dll"; DestDir: "{tmp}\PlayerUI"; Flags: dontcopy
Source: "PlayerUI\FFmpeg-LICENSE.txt"; DestDir: "{tmp}\PlayerUI"; Flags: dontcopy

[Code]
type
  TFftData = array[0..127] of Single;
  TEqBand = record
    Center, Bandwidth, Gain: Single;
  end;
  TPlayerPoint = record
    X, Y: Integer;
  end;
  TPlayerRect = record
    Left, Top, Right, Bottom: Integer;
  end;
  TPlayerMonitor = record
    Size: LongWord;
    Bounds, WorkArea: TPlayerRect;
    Flags: LongWord;
  end;
var
  Player: TSetupForm;
  Screen: TPanel;
  Logo, CharacterArt, BannerArt: TBitmapImage;
  TitleText, TimeText: TNewStaticText;
  Timeline: TNewProgressBar;
  OpenButton, PauseButton, BackButton, ForwardButton, MuteButton, FullButton: TNewButton;
  Queue: TNewListBox;
  QueuePaths, ShuffleRemaining: TStringList;
  MenuPanel: TPanel;
  MenuButton: TBitmapImage;
  PlaylistPath, CurrentVideoPath: String;
  QueueTitle, ViewerHint: TNewStaticText;
  PlaylistPageOpen: Boolean;
  MediaOpen, Paused, Full, IsVideo: Boolean;
  Duration, Volume: Integer;
  Muted: Boolean;
  VolumeTrack, VolumeFill, VolumeThumb: TBitmapImage;
  VolumeDragging, BassReady, BassCompatible: Boolean;
  ModeButton, VizButton: TNewButton;
  VizMode: Integer;
  VizBars: array[0..23] of TBitmapImage;
  VizPalette: array[0..3] of TBitmapImage;
  VizBarColor: array[0..23] of Integer;
  PlayMode, CurrentIndex: Integer;
  Stream: LongWord;
  EqGain: array[0..2] of Integer;
  EqForm: TSetupForm;
  EqTrack, EqThumb: array[0..2] of TBitmapImage;
  EqKnob, EqMarker: array[0..2] of TBitmapImage;
  EqReadout: array[0..2] of TNewStaticText;
  EqState: TNewStaticText;
  KnobBand, FaderBand, KnobStartY, KnobStartGain: Integer;
  EqEffects: array[0..2] of LongWord;
  ControlsHidden, CursorKnown: Boolean;
  LastCursor: TPlayerPoint;
  IdleTicks: Integer;
  TimerId: LongWord;
  BrandIcon, VideoModule, VideoPlayer: LongWord;
  SwitchingMedia, InsideTick: Boolean;
  SavedBounds: TPlayerRect;
  SavedStyle: Longint;

function Mci(Command, Reply: String; Size, Callback: LongWord): LongWord;
  external 'mciSendStringW@winmm.dll stdcall';
function SetPlayerTimer(Window: HWND; Id, Interval, Callback: LongWord): LongWord;
  external 'SetTimer@user32.dll stdcall';
function KillPlayerTimer(Window: HWND; Id: LongWord): Boolean;
  external 'KillTimer@user32.dll stdcall';
function LoadBrandIcon(Instance: LongWord; FileName: String; ImageType: LongWord;
  Width, Height: Integer; Flags: LongWord): LongWord;
  external 'LoadImageW@user32.dll stdcall';
function ReleaseBrandIcon(Icon: LongWord): Boolean;
  external 'DestroyIcon@user32.dll stdcall';

procedure InitCommonControls;
  external 'InitCommonControls@comctl32.dll stdcall';
function CreateSlider(ExStyle: LongWord; ClassName, Text: String; Style: LongWord;
  X, Y, W, H: Integer; Parent: HWND; Menu, Instance, Param: LongWord): HWND;
  external 'CreateWindowExW@user32.dll stdcall';
function DisableSliderTheme(Window: HWND; AppName, IdList: String): Longint;
  external 'SetWindowTheme@uxtheme.dll stdcall';
function RedrawSlider(Window: HWND; UpdateRect, Region, Flags: LongWord): Boolean;
  external 'RedrawWindow@user32.dll stdcall';
function MoveSlider(Window: HWND; X, Y, W, H: Integer; Repaint: Boolean): Boolean;
  external 'MoveWindow@user32.dll stdcall';

function ReadSpectrum(Channel: LongWord; var Data: TFftData; Flags: LongWord): LongWord;
  external 'BASS_ChannelGetData@{tmp}\bass24.dll stdcall delayload';

function BVersion: LongWord;
  external 'BASS_GetVersion@{tmp}\bass24.dll stdcall delayload';

function CheckBass: Boolean;
begin
  Result := False;
  try
    ExtractTemporaryFile('bass24.dll');
    Result := (BVersion shr 16) = $0204;
  except
    Log('Optional BASS 2.4 unavailable. Using Windows playback.');
  end;
end;

function BInit(Device: Integer; Rate, Flags: LongWord; Window: HWND; Clsid: LongWord): Boolean;
  external 'BASS_Init@{tmp}\bass24.dll stdcall delayload';
function BFree: Boolean;
  external 'BASS_Free@{tmp}\bass24.dll stdcall delayload';
function BOpen(Memory: Boolean; Path: String; Offset, Length: Int64; Flags: LongWord): LongWord;
  external 'BASS_StreamCreateFile@{tmp}\bass24.dll stdcall delayload';
function BClose(Channel: LongWord): Boolean;
  external 'BASS_StreamFree@{tmp}\bass24.dll stdcall delayload';
function BPlay(Channel: LongWord; Restart: Boolean): Boolean;
  external 'BASS_ChannelPlay@{tmp}\bass24.dll stdcall delayload';
function BPause(Channel: LongWord): Boolean;
  external 'BASS_ChannelPause@{tmp}\bass24.dll stdcall delayload';
function BActive(Channel: LongWord): LongWord;
  external 'BASS_ChannelIsActive@{tmp}\bass24.dll stdcall delayload';
function BVolume(Channel, Attribute: LongWord; Value: Single): Boolean;
  external 'BASS_ChannelSetAttribute@{tmp}\bass24.dll stdcall delayload';
function BPosition(Channel, Mode: LongWord): Int64;
  external 'BASS_ChannelGetPosition@{tmp}\bass24.dll stdcall delayload';
function BLength(Channel, Mode: LongWord): Int64;
  external 'BASS_ChannelGetLength@{tmp}\bass24.dll stdcall delayload';
function BSeconds(Channel: LongWord; Bytes: Int64): Double;
  external 'BASS_ChannelBytes2Seconds@{tmp}\bass24.dll stdcall delayload';
function BBytes(Channel: LongWord; Seconds: Double): Int64;
  external 'BASS_ChannelSeconds2Bytes@{tmp}\bass24.dll stdcall delayload';
function BSeek(Channel: LongWord; Bytes: Int64; Mode: LongWord): Boolean;
  external 'BASS_ChannelSetPosition@{tmp}\bass24.dll stdcall delayload';
function BAddEffect(Channel, Effect: LongWord; Priority: Integer): LongWord;
  external 'BASS_ChannelSetFX@{tmp}\bass24.dll stdcall delayload';
function BSetEffect(Effect: LongWord; var Band: TEqBand): Boolean;
  external 'BASS_FXSetParameters@{tmp}\bass24.dll stdcall delayload';
function ClockSeed: LongWord;
  external 'GetTickCount@kernel32.dll stdcall';

function ApplyEq: Boolean;
var
  I: Integer;
  Band: TEqBand;
begin
  Result := True;
  if Stream = 0 then Exit;
  for I := 0 to 2 do
  begin
    if I = 0 then Band.Center := 100
    else if I = 1 then Band.Center := 1000
    else Band.Center := 8000;
    Band.Bandwidth := 18;
    Band.Gain := EqGain[I];
    if EqEffects[I] = 0 then EqEffects[I] := BAddEffect(Stream, 7, 0);
    if EqEffects[I] = 0 then Result := False
    else if not BSetEffect(EqEffects[I], Band) then Result := False;
  end;
end;

function LoadVideoLibrary(Path: String; Reserved, Flags: LongWord): LongWord;
  external 'LoadLibraryExW@kernel32.dll stdcall';
function VideoOpen(FileName: String; Window: HWND; Volume: Integer): LongWord;
  external 'GRVideo_Open@{tmp}\PlayerUI\GRVideoBridge.dll stdcall delayload';
procedure VideoClose(Handle: LongWord);
  external 'GRVideo_Close@{tmp}\PlayerUI\GRVideoBridge.dll stdcall delayload';
procedure VideoPause(Handle: LongWord; Pause: Integer);
  external 'GRVideo_Pause@{tmp}\PlayerUI\GRVideoBridge.dll stdcall delayload';
function VideoTime(Handle: LongWord): Int64;
  external 'GRVideo_Time@{tmp}\PlayerUI\GRVideoBridge.dll stdcall delayload';
function VideoLength(Handle: LongWord): Int64;
  external 'GRVideo_Length@{tmp}\PlayerUI\GRVideoBridge.dll stdcall delayload';
procedure VideoSeek(Handle: LongWord; Position: Int64);
  external 'GRVideo_Seek@{tmp}\PlayerUI\GRVideoBridge.dll stdcall delayload';
procedure VideoVolume(Handle: LongWord; Level: Integer);
  external 'GRVideo_Volume@{tmp}\PlayerUI\GRVideoBridge.dll stdcall delayload';
function VideoFinished(Handle: LongWord): Integer;
  external 'GRVideo_Finished@{tmp}\PlayerUI\GRVideoBridge.dll stdcall delayload';

function PrepareVideo: Boolean;
begin
  if VideoModule = 0 then
  begin
    ExtractTemporaryFiles('{tmp}\PlayerUI\*');
    VideoModule := LoadVideoLibrary(
      ExpandConstant('{tmp}\PlayerUI\GRVideoBridge.dll'), 0, $00000008);
  end;
  Result := VideoModule <> 0;
end;

function StartVideo(FileName: String): Boolean;
var
  Level: Integer;
begin
  Result := False;
  if not PrepareVideo then Exit;
  Level := Volume;
  if Muted then Level := 0;
  VideoPlayer := VideoOpen(FileName, Screen.Handle, Level);
  Result := VideoPlayer <> 0;
  if Result then CurrentVideoPath := FileName;
end;

procedure ApplyWindowIcon(Form: TSetupForm);
begin
  if BrandIcon = 0 then Exit;
  SendMessage(Form.Handle, $0080, 0, BrandIcon);
  SendMessage(Form.Handle, $0080, 1, BrandIcon);
end;

function BrandedNotice(MessageText: String; Kind: TMsgBoxType; Buttons: Integer): Integer;
var
  Dialog: TSetupForm;
  Body: TNewStaticText;
  AcceptButton, RejectButton: TNewButton;
begin
  Dialog := CreateCustomForm(ScaleX(500), ScaleY(180), False, False);
  try
    Dialog.BorderStyle := bsSingle;
    Dialog.Caption := 'GR Catgirl Player';
    if Kind = mbError then Dialog.Caption := 'GR Catgirl Player - Error';
    if Kind = mbConfirmation then Dialog.Caption := 'GR Catgirl Player - Confirm';
    ApplyWindowIcon(Dialog);
    Body := TNewStaticText.Create(Dialog);
    Body.Parent := Dialog;
    Body.AutoSize := False;
    Body.WordWrap := True;
    Body.Caption := MessageText;
    Body.SetBounds(ScaleX(22), ScaleY(22), ScaleX(456), ScaleY(100));
    AcceptButton := TNewButton.Create(Dialog);
    AcceptButton.Parent := Dialog;
    AcceptButton.SetBounds(ScaleX(376), ScaleY(133), ScaleX(100), ScaleY(30));
    AcceptButton.Caption := 'OK';
    AcceptButton.ModalResult := mrOk;
    AcceptButton.Default := True;
    if Buttons = MB_YESNO then
    begin
      AcceptButton.Caption := 'Yes';
      RejectButton := TNewButton.Create(Dialog);
      RejectButton.Parent := Dialog;
      RejectButton.SetBounds(ScaleX(264), ScaleY(133), ScaleX(100), ScaleY(30));
      RejectButton.Caption := 'No';
      RejectButton.ModalResult := mrCancel;
      RejectButton.Cancel := True;
      Dialog.ActiveControl := RejectButton;
    end
    else
      AcceptButton.Cancel := True;
    if Dialog.ShowModal = mrOk then
    begin
      if Buttons = MB_YESNO then Result := idYes else Result := idOK;
    end
    else
      Result := idNo;
  finally
    Dialog.Free;
  end;
end;

function Command(Text: String): LongWord;
begin
  Result := Mci(Text, '', 0, 0);
end;

function MediaNumber(Item: String): Integer;
var
  Reply: String;
  Terminator: Integer;
begin
  Result := 0;
  if Stream <> 0 then
  begin
    if Item = 'position' then Result := Round(BSeconds(Stream, BPosition(Stream, 0)) * 1000)
    else if Item = 'length' then Result := Round(BSeconds(Stream, BLength(Stream, 0)) * 1000);
    Exit;
  end;
  if VideoPlayer <> 0 then
  begin
    if Item = 'position' then Result := VideoTime(VideoPlayer)
    else if Item = 'length' then Result := VideoLength(VideoPlayer);
    Exit;
  end;
  SetLength(Reply, 64);
  if Mci('status grmedia ' + Item, Reply, 64, 0) <> 0 then Exit;
  Terminator := Pos(#0, Reply);
  if Terminator > 0 then SetLength(Reply, Terminator - 1);
  Result := StrToIntDef(Trim(Reply), 0);
end;

function ClockText(Milliseconds: Integer): String;
var
  Seconds: Integer;
begin
  Seconds := Milliseconds div 1000;
  Result := Format('%d:%.2d', [Seconds div 60, Seconds mod 60]);
end;

procedure UpdateVolume; forward;
procedure UpdateTimeline;
var
  Position: Integer;
begin
  if not MediaOpen then Exit;
  if VideoPlayer <> 0 then
  begin
    Position := MediaNumber('length');
    if (Position > 0) and (Position <> Duration) then
    begin
      Duration := Position;
      Timeline.Max := Duration;
      UpdateVolume;
    end;
  end;
  Position := MediaNumber('position');
  if Position < 0 then Position := 0;
  if Position > Duration then Position := Duration;
  Timeline.Position := Position;
  TimeText.Caption := ClockText(Position) + ' / ' + ClockText(Duration) +
    '     Volume ' + IntToStr(Volume) + '%';
  if Muted then TimeText.Caption := TimeText.Caption + ' (muted)';
end;

procedure UpdateVolume;
var
  EffectiveVolume: Integer;
  Gain: Single;
begin
  EffectiveVolume := Volume;
  if Muted then EffectiveVolume := 0;
  Gain := EffectiveVolume / 100.0;
  if Stream <> 0 then
  begin
    if not BVolume(Stream, 2, Gain) then Log('BASS rejected the requested volume.');
  end
  else if VideoPlayer <> 0 then VideoVolume(VideoPlayer, EffectiveVolume)
  else if MediaOpen then
    Command('setaudio grmedia volume to ' + IntToStr(EffectiveVolume * 10));
end;

function PlayerForeground: HWND;
  external 'GetForegroundWindow@user32.dll stdcall';
function PlayerKeyState(Key: Integer): Smallint;
  external 'GetAsyncKeyState@user32.dll stdcall';
function ReadPlayerCursor(var Point: TPlayerPoint): Boolean;
  external 'GetCursorPos@user32.dll stdcall';
function ShowSlider(Window: HWND; Mode: Integer): Boolean;
  external 'ShowWindow@user32.dll stdcall';
function CursorToPlayer(Window: HWND; var Point: TPlayerPoint): Boolean;
  external 'ScreenToClient@user32.dll stdcall';

procedure PaintVolume;
begin
  VolumeFill.Width := VolumeTrack.Width * Volume div 100;
  VolumeThumb.Left := VolumeTrack.Left + (VolumeTrack.Width - VolumeThumb.Width) * Volume div 100;
end;

procedure DragVolume(Click: Boolean);
var
  Point: TPlayerPoint;
  Level: Integer;
begin
  if ControlsHidden or (PlayerForeground <> Player.Handle) or ((not Click) and (PlayerKeyState(1) >= 0)) then
  begin
    VolumeDragging := False;
    Exit;
  end;
  if not ReadPlayerCursor(Point) then Exit;
  if not CursorToPlayer(Player.Handle, Point) then Exit;
  if not VolumeDragging then
    VolumeDragging := (Point.X >= VolumeTrack.Left) and
      (Point.X <= VolumeTrack.Left + VolumeTrack.Width) and
      (Abs(Point.Y - VolumeTrack.Top) <= ScaleY(12));
  if not VolumeDragging or (VolumeTrack.Width <= 0) then Exit;
  Level := (Point.X - VolumeTrack.Left) * 100 div VolumeTrack.Width;
  if Level < 0 then Level := 0;
  if Level > 100 then Level := 100;
  if Level = Volume then Exit;
  Volume := Level;
  PaintVolume;
  UpdateVolume;
end;

procedure ClickVolume(Sender: TObject);
begin
  VolumeDragging := False;
  DragVolume(True);
  VolumeDragging := False;
end;

procedure ToggleFull(Sender: TObject); forward;
procedure Layout(Sender: TObject); forward;

procedure SetControlsHidden(Hidden: Boolean);
begin
  if ControlsHidden = Hidden then Exit;
  ControlsHidden := Hidden;
  OpenButton.Visible := not Hidden;
  PauseButton.Visible := not Hidden;
  BackButton.Visible := not Hidden;
  ForwardButton.Visible := not Hidden;
  MuteButton.Visible := not Hidden;
  FullButton.Visible := not Hidden;
  ModeButton.Visible := not Hidden;
  Timeline.Visible := not Hidden;
  TimeText.Visible := not Hidden;
  VolumeTrack.Visible := not Hidden;
  VolumeFill.Visible := not Hidden;
  VolumeThumb.Visible := not Hidden;
  Layout(nil);
end;

procedure UpdateFullscreenControls;
var
  Point: TPlayerPoint;
begin
  if not (Full and MediaOpen and IsVideo and not Paused) then
  begin
    CursorKnown := False;
    IdleTicks := 0;
    SetControlsHidden(False);
    Exit;
  end;
  if PlayerForeground <> Player.Handle then Exit;
  if not ReadPlayerCursor(Point) then Exit;
  if (not CursorKnown) or (Point.X <> LastCursor.X) or (Point.Y <> LastCursor.Y) or
     (Point.Y >= Player.Top + Player.Height - ScaleY(90)) or (PlayerKeyState(1) < 0) then
  begin
    LastCursor := Point;
    CursorKnown := True;
    IdleTicks := 0;
    SetControlsHidden(False);
  end
  else if IdleTicks < 60 then
  begin
    IdleTicks := IdleTicks + 1;
    if IdleTicks = 60 then SetControlsHidden(True);
  end;
end;

function AddQueueFile(Path: String): Integer;
begin
  ShuffleRemaining.Clear;
  Result := QueuePaths.Add(Path);
  Queue.Items.Add(ExtractFileName(Path));
end;

procedure ClearQueue;
begin
  Queue.Items.Clear;
  QueuePaths.Clear;
  ShuffleRemaining.Clear;
  CurrentIndex := -1;
end;

procedure PlaySelected(Sender: TObject); forward;

procedure CloseMedia; forward;

procedure CloseFailedVideo;
begin
  CloseMedia;
  ViewerHint.Caption := 'FFmpeg could not open this video.';
  ViewerHint.Visible := Screen.Visible;
  TitleText.Caption := 'GR Catgirl Player';
end;

function NextShuffleIndex: Integer;
var
  I, Slot: Integer;
begin
  if ShuffleRemaining.Count = 0 then
    for I := 0 to QueuePaths.Count - 1 do
      if I <> CurrentIndex then ShuffleRemaining.Add(IntToStr(I));
  if ShuffleRemaining.Count = 0 then
    Result := CurrentIndex
  else
  begin
    Slot := Integer(ClockSeed mod ShuffleRemaining.Count);
    Result := StrToInt(ShuffleRemaining[Slot]);
    ShuffleRemaining.Delete(Slot);
  end;
end;

procedure CheckTrackEnd;
var
  N, Next, VideoStatus: Integer;
begin
  if not MediaOpen or Paused then Exit;
  if Stream <> 0 then
  begin
    if BActive(Stream) <> 0 then Exit;
  end
  else if VideoPlayer <> 0 then
  begin
    VideoStatus := VideoFinished(VideoPlayer);
    if VideoStatus = 0 then Exit;
    if VideoStatus < 0 then
    begin
      CloseFailedVideo;
      Exit;
    end;
  end
  else if (Duration <= 1) or (MediaNumber('position') < Duration) then Exit;
  Paused := True;
  PauseButton.Caption := '▶';
  N := Queue.Items.Count;
  if (CurrentIndex < 0) or (CurrentIndex >= N) then Exit;
  Next := CurrentIndex + 1;
  case PlayMode of
    1: Next := NextShuffleIndex;
    2: Next := Next mod N;
    3: Next := CurrentIndex;
  end;
  if Next >= N then Exit;
  Queue.ItemIndex := Next;
  PlaySelected(nil);
end;

procedure DrawVisualizer;
var
  Data: TFftData;
  I, Bin, Step, BarWidth, Height, AreaHeight, Y, ColorIndex: Integer;
  Level: Single;
  ShowBars, WasVisible: Boolean;
begin
  ShowBars := (VizMode <> 4) and (Stream <> 0) and not IsVideo and Screen.Visible;
  WasVisible := VizBars[0].Visible;
  if not ShowBars then
  begin
    if WasVisible then
    begin
      for I := 0 to 23 do VizBars[I].Hide;
      RedrawSlider(Screen.Handle, 0, 0, $0085);
    end;
    Exit;
  end;
  if ReadSpectrum(Stream, Data, $80000000) = $FFFFFFFF then Exit;
  Step := (Screen.Width - ScaleX(40)) div 24;
  AreaHeight := Screen.Height - ScaleY(92);
  if (Step < 4) or (AreaHeight < 10) then Exit;
  BarWidth := Step - ScaleX(3);
  if BarWidth < 1 then BarWidth := 1;
  SendMessage(Screen.Handle, $000B, 0, 0);
  try
  for I := 0 to 23 do
  begin
    VizBars[I].Visible := True;
    Bin := 1 + (I * I) div 5;
    if VizMode = 2 then Bin := 1 + ((2 * I - 23) * (2 * I - 23)) div 5;
    if VizMode = 1 then
      Level := (Data[1] + Data[2] + Data[3]) / 3
    else
      Level := Data[Bin];
    if Level < 0 then Level := 0;
    Height := Round(Sqrt(Level) * AreaHeight * 1.5);
    if Height > AreaHeight then Height := AreaHeight;
    if Height < 2 then Height := 2;
    if VizMode = 0 then
    begin
      ColorIndex := 0;
      if Height * 100 >= AreaHeight * 75 then ColorIndex := 3
      else if Height * 100 >= AreaHeight * 50 then ColorIndex := 1
      else if Height * 100 >= AreaHeight * 25 then ColorIndex := 2;
      if ColorIndex <> VizBarColor[I] then
      begin
        VizBars[I].Bitmap.Assign(VizPalette[ColorIndex].Bitmap);
        VizBarColor[I] := ColorIndex;
      end;
    end;
    Y := Screen.Height - ScaleY(26) - Height;
    if VizMode = 2 then Y := (Screen.Height - Height) div 2;
    if VizMode = 3 then
      VizBars[I].SetBounds(ScaleX(20) + I * Step, Y, BarWidth, ScaleY(4))
    else
      VizBars[I].SetBounds(ScaleX(20) + I * Step, Y, BarWidth, Height);
  end;
  finally
    SendMessage(Screen.Handle, $000B, 1, 0);
    RedrawSlider(Screen.Handle, 0, 0, $0085);
  end;
end;

procedure LoadVisualizerColor;
var
  I: Integer;
begin
  if VizMode = 4 then Exit;
  for I := 0 to 23 do
  begin
    VizBars[I].Bitmap.Assign(VizPalette[VizMode].Bitmap);
    VizBarColor[I] := VizMode;
  end;
end;

procedure CycleVisualizer(Sender: TObject);
begin
  VizMode := (VizMode + 1) mod 5;
  case VizMode of
    0: VizButton.Caption := 'Visualizer: Spectrum';
    1: VizButton.Caption := 'Visualizer: Bass pulse';
    2: VizButton.Caption := 'Visualizer: Mirror';
    3: VizButton.Caption := 'Visualizer: Dots';
    4: VizButton.Caption := 'Visualizer: Off';
  end;
  LoadVisualizerColor;
  DrawVisualizer;
end;

procedure RefreshEqBand(I: Integer);
var
  Angle: Extended;
begin
  EqThumb[I].Top := EqTrack[I].Top + (EqTrack[I].Height - EqThumb[I].Height) * (15 - EqGain[I]) div 30;
  EqReadout[I].Caption := IntToStr(EqGain[I]) + ' dB';
  Angle := EqGain[I] * 0.139626;
  EqMarker[I].SetBounds(EqKnob[I].Left + EqKnob[I].Width div 2 - ScaleX(3) + Round(Sin(Angle) * ScaleX(19)),
    EqKnob[I].Top + EqKnob[I].Height div 2 - ScaleY(3) - Round(Cos(Angle) * ScaleY(19)), EqMarker[I].Width, EqMarker[I].Height);
end;

procedure SetEqGain(Band, Gain: Integer);
begin
  if Gain < -15 then Gain := -15;
  if Gain > 15 then Gain := 15;
  if EqGain[Band] = Gain then Exit;
  EqGain[Band] := Gain;
  RefreshEqBand(Band);
  if not ApplyEq then EqState.Caption := 'The audio engine rejected an EQ band.'
  else if Stream = 0 then EqState.Caption := 'Settings will apply to the next music track.'
  else EqState.Caption := 'Live adjustments';
end;

procedure SyncEqualizer;
var
  I, Offset, Travel: Integer;
  Point: TPlayerPoint;
begin
  if EqForm = nil then Exit;
  if PlayerForeground <> EqForm.Handle then Exit;
  if PlayerKeyState(1) >= 0 then
  begin
    KnobBand := -1;
    FaderBand := -1;
    Exit;
  end;
  if not ReadPlayerCursor(Point) then Exit;
  if not CursorToPlayer(EqForm.Handle, Point) then Exit;
  if (KnobBand < 0) and (FaderBand < 0) then
    for I := 0 to 2 do
    begin
      if (Point.X >= EqKnob[I].Left) and (Point.X < EqKnob[I].Left + EqKnob[I].Width) and
         (Point.Y >= EqKnob[I].Top) and (Point.Y < EqKnob[I].Top + EqKnob[I].Height) then
      begin
        KnobBand := I;
        KnobStartY := Point.Y;
        KnobStartGain := EqGain[I];
        Break;
      end;
      if (Point.X >= EqThumb[I].Left - ScaleX(5)) and
         (Point.X < EqThumb[I].Left + EqThumb[I].Width + ScaleX(5)) and
         (Point.Y >= EqTrack[I].Top) and (Point.Y < EqTrack[I].Top + EqTrack[I].Height) then
      begin
        FaderBand := I;
        Break;
      end;
    end;
  if KnobBand >= 0 then
    SetEqGain(KnobBand, KnobStartGain + (KnobStartY - Point.Y) div 3);
  if FaderBand >= 0 then
  begin
    Travel := EqTrack[FaderBand].Height - EqThumb[FaderBand].Height;
    if Travel < 1 then Exit;
    Offset := Point.Y - EqTrack[FaderBand].Top - EqThumb[FaderBand].Height div 2;
    SetEqGain(FaderBand, 15 - Round(Offset * 30.0 / Travel));
  end;
end;

procedure DismissMenuOnOutsideClick;
var
  Point: TPlayerPoint;
begin
  if not MenuPanel.Visible then Exit;
  { Track the transition as well as the held state so a quick click is seen. }
  if PlayerKeyState(1) = 0 then Exit;
  if not ReadPlayerCursor(Point) then Exit;
  if not CursorToPlayer(Player.Handle, Point) then Exit;
  if (Point.X >= MenuPanel.Left) and (Point.X < MenuPanel.Left + MenuPanel.Width) and
     (Point.Y >= MenuPanel.Top) and (Point.Y < MenuPanel.Top + MenuPanel.Height) then Exit;
  if (Point.X >= MenuButton.Left) and (Point.X < MenuButton.Left + MenuButton.Width) and
     (Point.Y >= MenuButton.Top) and (Point.Y < MenuButton.Top + MenuButton.Height) then Exit;
  MenuPanel.Hide;
end;

procedure Tick(Window: HWND; Message, Id, Time: LongWord);
begin
  if SwitchingMedia or InsideTick then Exit;
  InsideTick := True;
  try
  if Full and (PlayerForeground = Player.Handle) and (PlayerKeyState(27) < 0) then ToggleFull(nil);
  UpdateFullscreenControls;
  DismissMenuOnOutsideClick;
  DragVolume(False);
  UpdateTimeline;
  CheckTrackEnd;
  DrawVisualizer;
  SyncEqualizer;
  finally
    InsideTick := False;
  end;
end;

procedure Layout(Sender: TObject);
var
  W, H: Integer;
begin
  W := Player.ClientWidth;
  H := Player.ClientHeight;
  if (W < ScaleX(650)) or (H < ScaleY(340)) then Exit;
  Logo.Visible := not Full;
  TitleText.Visible := not Full;
  MenuButton.Visible := not Full;
  MenuButton.SetBounds(W - ScaleX(56), ScaleY(8), ScaleX(40), ScaleY(40));
  MenuPanel.SetBounds(W - ScaleX(205), ScaleY(48), ScaleX(189), ScaleY(330));
  Screen.Visible := Full or not PlaylistPageOpen;
  ViewerHint.Visible := Screen.Visible and not (MediaOpen and IsVideo);
  QueueTitle.Visible := PlaylistPageOpen and not Full;
  QueueTitle.SetBounds(ScaleX(206), ScaleY(62), W - ScaleX(222), ScaleY(24));
  CharacterArt.Visible := not Full;
  BannerArt.Visible := not Full and not PlaylistPageOpen;
  if Full then
  begin
    if ControlsHidden then Screen.SetBounds(0, 0, W, H)
    else Screen.SetBounds(0, 0, W, H - ScaleY(90));
  end
  else
  begin
    CharacterArt.SetBounds(0, 0, ScaleX(194), H);
    BannerArt.SetBounds(ScaleX(206), ScaleY(58), W - ScaleX(222), ScaleY(64));
    Screen.SetBounds(ScaleX(206), ScaleY(132), W - ScaleX(222), H - ScaleY(224));
  end;
  Queue.Visible := PlaylistPageOpen and not Full;

  Queue.SetBounds(ScaleX(206), ScaleY(92), W - ScaleX(222), H - ScaleY(184));
  ViewerHint.SetBounds(Screen.Left + ScaleX(20), Screen.Top + ScaleY(24), Screen.Width - ScaleX(40), ScaleY(26));
  Timeline.SetBounds(ScaleX(16), H - ScaleY(83), W - ScaleX(32), ScaleY(5));
  TimeText.SetBounds(ScaleX(16), H - ScaleY(72), W - ScaleX(32), ScaleY(18));
  OpenButton.Top := H - ScaleY(43);
  PauseButton.Top := OpenButton.Top;
  BackButton.Top := OpenButton.Top;
  ForwardButton.Top := OpenButton.Top;
  MuteButton.Top := OpenButton.Top;
  VolumeTrack.SetBounds(ScaleX(440), OpenButton.Top + ScaleY(12), ScaleX(105), ScaleY(7));
  VolumeFill.Left := VolumeTrack.Left;
  VolumeFill.Top := VolumeTrack.Top;
  VolumeThumb.Top := VolumeTrack.Top - ScaleY(4);
  PaintVolume;
  FullButton.Top := OpenButton.Top;
  FullButton.Left := W - ScaleX(118);
  ModeButton.SetBounds(W - ScaleX(223), FullButton.Top, ScaleX(98), ScaleY(29));
  if MediaOpen and IsVideo and (VideoPlayer = 0) then
    Command('put grmedia destination at 0 0 ' + IntToStr(Screen.ClientWidth) +
      ' ' + IntToStr(Screen.ClientHeight));
end;

procedure CloseMedia;
var
  OldPlayer: LongWord;
begin
  if VideoPlayer <> 0 then
  begin
    OldPlayer := VideoPlayer;
    VideoPlayer := 0;
    MediaOpen := False;
    VideoClose(OldPlayer);
  end
  else if Stream <> 0 then
  begin
    BClose(Stream);
    Stream := 0;
    EqEffects[0] := 0;
    EqEffects[1] := 0;
    EqEffects[2] := 0;
  end
  else if MediaOpen then Command('close grmedia');
  MediaOpen := False;
  Paused := False;
  PauseButton.Caption := 'Ⅱ';
end;

procedure PlayFileInternal(FileName: String);
var
  Extension, OpenCommand: String;
  ErrorCode: LongWord;
begin
  Extension := Lowercase(ExtractFileExt(FileName));
  CloseMedia;
  IsVideo := (Extension <> '.mp3') and (Extension <> '.wav');
  OpenCommand := 'open "' + FileName + '" alias grmedia';
  Timeline.Position := 0;
  TimeText.Caption := '0:00 / 0:00';
  if IsVideo then
  begin
    ViewerHint.Caption := 'Opening video...';
    ViewerHint.Visible := Screen.Visible;
    RedrawSlider(Player.Handle, 0, 0, $0185);
    try
      if StartVideo(FileName) then
      begin
        MediaOpen := True;
        Duration := 1;
        Timeline.Max := Duration;
        TitleText.Caption := ExtractFileName(FileName);
        ViewerHint.Hide;
        UpdateVolume;
        Exit;
      end;
    except
      Log(GetExceptionMessage);
    end;
    CloseMedia;
    ViewerHint.Caption := 'Video could not be opened.';
    ViewerHint.Visible := Screen.Visible;
    BrandedNotice('Could not open this video. Check the FFmpeg playback bridge and the media file.', mbError, MB_OK);
    Exit;
  end;
  if (not IsVideo) and BassCompatible then
  begin
    Log('Audio: preparing BASS playback.');
    if not BassReady then BassReady := BInit(-1, 44100, 0, Player.Handle, 0);
    if BassReady then Stream := BOpen(False, FileName, 0, 0, $80000000);
    if Stream = 0 then
    begin
      BrandedNotice('Could not open this audio file.', mbError, MB_OK);
      Exit;
    end;
    MediaOpen := True;
    Duration := MediaNumber('length');
    if Duration < 1 then Duration := 1;
    Timeline.Max := Duration;
    ApplyEq;
    UpdateVolume;
    if not BPlay(Stream, False) then
    begin
      CloseMedia;
      BrandedNotice('Could not start audio playback.', mbError, MB_OK);
      Exit;
    end;
    TitleText.Caption := ExtractFileName(FileName);
    ViewerHint.Visible := Screen.Visible;
    ViewerHint.Caption := 'Playing music';
    Exit;
  end;
  ErrorCode := Command(OpenCommand);
  if ErrorCode = 0 then
  begin
    MediaOpen := True;
    Command('set grmedia time format milliseconds');
    Duration := MediaNumber('length');
    if Duration < 1 then Duration := 1;
    Timeline.Max := Duration;
    UpdateVolume;
    Layout(nil);
    ErrorCode := Command('play grmedia');
  end;
  if ErrorCode <> 0 then
  begin
    CloseMedia;
    TitleText.Caption := 'GR Catgirl Player';
    ViewerHint.Caption := 'Open music or a movie from the menu.';
    ViewerHint.Visible := Screen.Visible;
    BrandedNotice('Windows could not play this video (error ' + IntToStr(ErrorCode) + ').',
      mbError, MB_OK);
  end
  else
  begin
    TitleText.Caption := ExtractFileName(FileName);
    ViewerHint.Visible := Screen.Visible and not IsVideo;
    ViewerHint.Caption := 'Playing music';
    UpdateTimeline;
  end;
end;

procedure PlayFile(FileName: String);
begin
  if SwitchingMedia then Exit;
  SwitchingMedia := True;
  try
    PlayFileInternal(FileName);
  finally
    SwitchingMedia := False;
  end;
end;

procedure PlaySelected(Sender: TObject);
begin
  if Queue.ItemIndex >= 0 then
  begin
    CurrentIndex := Queue.ItemIndex;
    if ShuffleRemaining.IndexOf(IntToStr(CurrentIndex)) >= 0 then
      ShuffleRemaining.Delete(ShuffleRemaining.IndexOf(IntToStr(CurrentIndex)));
    PlayFile(QueuePaths[CurrentIndex]);
  end;
end;

procedure OpenMedia(Sender: TObject);
var
  FileName: String;
begin
  FileName := '';
  if GetOpenFileName('Open music or video', FileName, ExpandConstant('{src}'),
    'Media files|*.mp3;*.wav;*.mp4;*.mkv;*.avi;*.mov;*.webm;*.mpg;*.mpeg;*.wmv;*.m4v;*.ts;*.m2ts;*.flv;*.ogv;*.3gp;*.vob;*.gif|All files|*.*', '') then
  begin
    Queue.ItemIndex := AddQueueFile(FileName);
    PlaySelected(nil);
  end;
end;

procedure TogglePause(Sender: TObject);
begin
  if not MediaOpen then Exit;
  if VideoPlayer <> 0 then
    if VideoFinished(VideoPlayer) = 1 then
    begin
      PlayFile(CurrentVideoPath);
      Exit;
    end;
  if Paused then
  begin
    if Stream <> 0 then begin if not BPlay(Stream, False) then Exit; end
    else if VideoPlayer <> 0 then VideoPause(VideoPlayer, 0)
    else if Command('play grmedia') <> 0 then Exit;
    PauseButton.Caption := 'Ⅱ';
  end
  else
  begin
    if Stream <> 0 then begin if not BPause(Stream) then Exit; end
    else if VideoPlayer <> 0 then VideoPause(VideoPlayer, 1)
    else if Command('pause grmedia') <> 0 then Exit;
    PauseButton.Caption := '▶';
  end;
  Paused := not Paused;
end;

procedure Seek(Sender: TObject);
var
  Target, Direction, Count: Integer;
begin
  if not MediaOpen then Exit;
  if not IsVideo then
  begin
    Count := QueuePaths.Count;
    if (CurrentIndex < 0) or (CurrentIndex >= Count) then Exit;
    Direction := 1;
    if Sender = BackButton then Direction := -1;
    Target := CurrentIndex + Direction;
    if PlayMode = 2 then Target := (Target + Count) mod Count;
    if (Target < 0) or (Target >= Count) then Exit;
    Queue.ItemIndex := Target;
    PlaySelected(nil);
    Exit;
  end;
  Target := MediaNumber('position');
  if Sender = BackButton then Target := Target - 10000
  else Target := Target + 10000;
  if Target < 0 then Target := 0;
  if Target >= Duration then Target := Duration - 1;
  if Stream <> 0 then
  begin
    BSeek(Stream, BBytes(Stream, Target / 1000), 0);
    UpdateTimeline;
    Exit;
  end;
  if VideoPlayer <> 0 then
  begin
    VideoSeek(VideoPlayer, Target);
    UpdateTimeline;
    Exit;
  end;
  if Command('seek grmedia to ' + IntToStr(Target)) = 0 then
  begin
    if not Paused then Command('play grmedia');
    UpdateTimeline;
  end;
end;

procedure ToggleMute(Sender: TObject);
begin
  Muted := not Muted;
  if Muted then
  begin
    MuteButton.Caption := '🔇';
    MuteButton.Hint := 'Unmute';
  end
  else
  begin
    MuteButton.Caption := '🔊';
    MuteButton.Hint := 'Mute';
  end;
  UpdateVolume;
end;

function PlayerMonitor(Window: HWND; Flags: LongWord): LongWord;
  external 'MonitorFromWindow@user32.dll stdcall';
function ReadMonitor(Monitor: LongWord; var Info: TPlayerMonitor): Boolean;
  external 'GetMonitorInfoW@user32.dll stdcall';
function ReadPlayerBounds(Window: HWND; var Bounds: TPlayerRect): Boolean;
  external 'GetWindowRect@user32.dll stdcall';
function ReadPlayerStyle(Window: HWND; Index: Integer): Longint;
  external 'GetWindowLongW@user32.dll stdcall';
function WritePlayerStyle(Window: HWND; Index: Integer; Style: Longint): Longint;
  external 'SetWindowLongW@user32.dll stdcall';
function PositionPlayer(Window, AfterWindow: HWND; X, Y, Width, Height: Integer; Flags: LongWord): Boolean;
  external 'SetWindowPos@user32.dll stdcall';

procedure ApplyPlayerBounds(Bounds: TPlayerRect);
begin
  { SWP_NOZORDER or SWP_NOACTIVATE or SWP_FRAMECHANGED }
  PositionPlayer(Player.Handle, 0, Bounds.Left, Bounds.Top,
    Bounds.Right - Bounds.Left, Bounds.Bottom - Bounds.Top, $0034);
end;

procedure ToggleFull(Sender: TObject);
var
  Monitor: TPlayerMonitor;
begin
  if Full then
  begin
    Full := False;
    SetControlsHidden(False);
    WritePlayerStyle(Player.Handle, -16, SavedStyle);
    ApplyPlayerBounds(SavedBounds);
    FullButton.Caption := '⛶';
  end
  else
  begin
    Monitor.Size := 40;
    if not ReadMonitor(PlayerMonitor(Player.Handle, 2), Monitor) then Exit;
    if not ReadPlayerBounds(Player.Handle, SavedBounds) then Exit;
    SavedStyle := ReadPlayerStyle(Player.Handle, -16);
    CursorKnown := False;
    IdleTicks := 0;
    Full := True;
    { Remove WS_CAPTION and WS_THICKFRAME without recreating the window. }
    WritePlayerStyle(Player.Handle, -16, SavedStyle and not $00C40000);
    ApplyPlayerBounds(Monitor.Bounds);
    FullButton.Caption := '⤢';
  end;
  Layout(nil);
end;

function Button(Text: String; X, Width: Integer): TNewButton;
begin
  Result := TNewButton.Create(Player);
  Result.Parent := Player;
  Result.SetBounds(ScaleX(X), 0, ScaleX(Width), ScaleY(29));
  Result.Caption := Text;
  Result.Font.Size := 12;
  Result.ShowHint := True;
end;

procedure UpdateModeIcon;
begin
  case PlayMode of
    0: begin ModeButton.Caption := #$E179; ModeButton.Hint := 'In order'; end;
    1: begin ModeButton.Caption := #$E8B1; ModeButton.Hint := 'Shuffle'; end;
    2: begin ModeButton.Caption := #$E8EE; ModeButton.Hint := 'Repeat all'; end;
    3: begin ModeButton.Caption := #$E8ED; ModeButton.Hint := 'Repeat one'; end;
  end;
end;

procedure CycleMode(Sender: TObject);
begin
  ShuffleRemaining.Clear;
  PlayMode := (PlayMode + 1) mod 4;
  UpdateModeIcon;
end;

procedure ResetEqualizer(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to 2 do SetEqGain(I, 0);
end;

function MixerLabel(Text: String; X, Y, W: Integer): TNewStaticText;
begin
  Result := TNewStaticText.Create(EqForm);
  Result.Parent := EqForm;
  Result.Caption := Text;
  Result.Font.Color := $00F6DEFF;
  Result.SetBounds(ScaleX(X), ScaleY(Y), ScaleX(W), ScaleY(20));
end;

procedure OpenEqualizer(Sender: TObject);
var
  CloseButton, ResetButton: TNewButton;
  I, X: Integer;
  Name, Frequency: String;
begin
  MenuPanel.Hide;
  if not BassCompatible then
  begin
    BrandedNotice('The equalizer requires 32-bit BASS 2.4.', mbInformation, MB_OK);
    Exit;
  end;
  EqForm := CreateCustomForm(ScaleX(420), ScaleY(380), False, False);
  try
    EqForm.Caption := 'GR Catgirl Player - Equalizer';
    EqForm.BorderStyle := bsSingle;
    if BrandIcon <> 0 then
    begin
      SendMessage(EqForm.Handle, $0080, 0, BrandIcon);
      SendMessage(EqForm.Handle, $0080, 1, BrandIcon);
    end;
    FaderBand := -1;
    EqForm.Color := $0024192F;
    KnobBand := -1;
    EqState := MixerLabel('Adjust the faders or drag the knobs up and down.', 18, 15, 385);
    InitCommonControls;
    ExtractTemporaryFile('EqKnob.bmp');
    for I := 0 to 2 do
    begin
      X := 45 + I * 130;
      if I = 0 then begin Name := 'BASS'; Frequency := '100 Hz'; end
      else if I = 1 then begin Name := 'MID'; Frequency := '1 kHz'; end
      else begin Name := 'TREBLE'; Frequency := '8 kHz'; end;
      MixerLabel(Name, X, 45, 95);
      MixerLabel(Frequency, X, 65, 95);
      EqKnob[I] := TBitmapImage.Create(EqForm);
      EqKnob[I].Parent := EqForm;
      EqKnob[I].SetBounds(ScaleX(X), ScaleY(92), ScaleX(54), ScaleY(54));
      EqKnob[I].Stretch := True;
      EqKnob[I].Bitmap.LoadFromFile(ExpandConstant('{tmp}\EqKnob.bmp'));
      EqMarker[I] := TBitmapImage.Create(EqForm);
      EqMarker[I].Parent := EqForm;
      EqMarker[I].SetBounds(0, 0, ScaleX(6), ScaleY(6));
      EqMarker[I].Stretch := True;
      EqMarker[I].Bitmap.LoadFromFile(ExpandConstant('{tmp}\VolumeFill.bmp'));
      EqTrack[I] := TBitmapImage.Create(EqForm);
      EqTrack[I].Parent := EqForm;
      EqTrack[I].Stretch := True;
      EqTrack[I].SetBounds(ScaleX(X + 24), ScaleY(153), ScaleX(6), ScaleY(143));
      EqTrack[I].Bitmap.LoadFromFile(ExpandConstant('{tmp}\VolumeTrack.bmp'));
      EqThumb[I] := TBitmapImage.Create(EqForm);
      EqThumb[I].Parent := EqForm;
      EqThumb[I].Stretch := True;
      EqThumb[I].SetBounds(ScaleX(X + 11), ScaleY(153), ScaleX(32), ScaleY(12));
      EqThumb[I].Bitmap.LoadFromFile(ExpandConstant('{tmp}\VolumeThumb.bmp'));
      EqReadout[I] := MixerLabel('', X + 6, 302, 90);
      RefreshEqBand(I);
    end;
    ResetButton := TNewButton.Create(EqForm);
    ResetButton.Parent := EqForm;
    ResetButton.Caption := 'Reset to flat';
    ResetButton.SetBounds(ScaleX(18), ScaleY(337), ScaleX(104), ScaleY(28));
    ResetButton.OnClick := @ResetEqualizer;
    CloseButton := TNewButton.Create(EqForm);
    CloseButton.Parent := EqForm;
    CloseButton.Caption := 'Done';
    CloseButton.Cancel := True;
    CloseButton.ModalResult := mrOk;
    CloseButton.SetBounds(ScaleX(308), ScaleY(337), ScaleX(94), ScaleY(28));
    EqForm.ShowModal;
  finally
    EqForm.Free;
    EqForm := nil;
  end;
end;

procedure TogglePlaylistPage(Sender: TObject);
begin
  MenuPanel.Hide;
  if Full then Exit;
  PlaylistPageOpen := not PlaylistPageOpen;
  Layout(nil);
end;

procedure ToggleMenu(Sender: TObject);
begin
  MenuPanel.Visible := not MenuPanel.Visible;
  if MenuPanel.Visible then MenuPanel.BringToFront;
end;

procedure MenuOpen(Sender: TObject);
begin
  MenuPanel.Hide;
  OpenMedia(nil);
end;

procedure AddMusicFolder(Sender: TObject);
var
  Folder, Extension, Track: String;
  Entry: TFindRec;
  Added, FirstNew: Integer;
begin
  MenuPanel.Hide;
  Folder := '';
  if not BrowseForFolder('Choose a folder containing music', Folder, False) then Exit;
  Folder := AddBackslash(Folder);
  Added := 0;
  FirstNew := QueuePaths.Count;
  if FindFirst(Folder + '*', Entry) then
  begin
    try
      repeat
        if (Entry.Attributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
        begin
          Extension := Lowercase(ExtractFileExt(Entry.Name));
          if (Extension = '.mp3') or (Extension = '.wav') then
          begin
            Track := Folder + Entry.Name;
            if QueuePaths.IndexOf(Track) < 0 then
            begin
              AddQueueFile(Track);
              Added := Added + 1;
            end;
          end;
        end;
      until not FindNext(Entry);
    finally
      FindClose(Entry);
    end;
  end;
  if Added = 0 then
    BrandedNotice('No new MP3 or WAV files were found in that folder.', mbInformation, MB_OK)
  else
  begin
    Queue.ItemIndex := FirstNew;
    PlaySelected(nil);
  end;
end;

procedure LoadPlaylistInternal;
var
  FileName: String;
  Entries: TArrayOfString;
  I: Integer;
begin
  MenuPanel.Hide;
  FileName := '';
  if not GetOpenFileName('Load playlist', FileName, '', 'M3U playlists|*.m3u', 'm3u') then Exit;
  Log('Playlist: reading saved file.');
  if not LoadStringsFromFile(FileName, Entries) then
  begin
    BrandedNotice('Could not read the playlist.', mbError, MB_OK);
    Exit;
  end;
  PlaylistPath := FileName;
  QueueTitle.Caption := ChangeFileExt(ExtractFileName(FileName), '');
  ClearQueue;
  for I := 0 to GetArrayLength(Entries) - 1 do
    if (Entries[I] <> '') and (Copy(Entries[I], 1, 1) <> '#') then
      AddQueueFile(Entries[I]);
  if Queue.Items.Count > 0 then
  begin
    Queue.ItemIndex := 0;
    CurrentIndex := 0;
    Log('Playlist: starting first entry.');
    PlayFileInternal(QueuePaths[0]);
  end;
end;

procedure LoadPlaylist(Sender: TObject);
begin
  if SwitchingMedia then Exit;
  SwitchingMedia := True;
  try
    try
      LoadPlaylistInternal;
    except
      Log('Playlist load failed: ' + GetExceptionMessage);
      BrandedNotice('Could not load or play the playlist: ' + GetExceptionMessage, mbError, MB_OK);
    end;
  finally
    SwitchingMedia := False;
  end;
end;

procedure SavePlaylist(Sender: TObject);
var
  FileName: String;
  Entries: TArrayOfString;
  I: Integer;
begin
  MenuPanel.Hide;
  FileName := PlaylistPath;
  if FileName = '' then FileName := QueueTitle.Caption + '.m3u';
  if not GetSaveFileName('Save playlist', FileName, '', 'M3U playlists|*.m3u', 'm3u') then Exit;
  SetArrayLength(Entries, Queue.Items.Count);
  for I := 0 to Queue.Items.Count - 1 do Entries[I] := QueuePaths[I];
  if not SaveStringsToUTF8File(FileName, Entries, False) then
    BrandedNotice('Could not save the playlist.', mbError, MB_OK)
  else
  begin
    PlaylistPath := FileName;
    QueueTitle.Caption := ChangeFileExt(ExtractFileName(FileName), '');
    if (Queue.Items.Count > 0) and (not MediaOpen or Paused or (CurrentIndex < 0)) then
    begin
      Queue.ItemIndex := 0;
      PlaySelected(nil);
    end;
  end;
end;

procedure NewPlaylist(Sender: TObject);
var
  Dialog: TSetupForm;
  PromptLabel: TNewStaticText;
  NameEdit: TNewEdit;
  CreateButton, CancelButton: TNewButton;
  Name: String;
begin
  MenuPanel.Hide;
  Dialog := CreateCustomForm(ScaleX(340), ScaleY(128), False, False);
  try
    Dialog.Caption := 'GR Catgirl Player - New Playlist';
    Dialog.BorderStyle := bsSingle;
    ApplyWindowIcon(Dialog);
    PromptLabel := TNewStaticText.Create(Dialog);
    PromptLabel.Parent := Dialog;
    PromptLabel.Caption := 'Playlist name';
    PromptLabel.SetBounds(ScaleX(16), ScaleY(14), ScaleX(300), ScaleY(22));
    NameEdit := TNewEdit.Create(Dialog);
    NameEdit.Parent := Dialog;
    NameEdit.SetBounds(ScaleX(16), ScaleY(40), ScaleX(308), ScaleY(24));
    CreateButton := TNewButton.Create(Dialog);
    CreateButton.Parent := Dialog;
    CreateButton.Caption := 'Create';
    CreateButton.Default := True;
    CreateButton.ModalResult := mrOk;
    CreateButton.SetBounds(ScaleX(148), ScaleY(82), ScaleX(82), ScaleY(28));
    CancelButton := TNewButton.Create(Dialog);
    CancelButton.Parent := Dialog;
    CancelButton.Caption := 'Cancel';
    CancelButton.Cancel := True;
    CancelButton.ModalResult := mrCancel;
    CancelButton.SetBounds(ScaleX(242), ScaleY(82), ScaleX(82), ScaleY(28));
    Dialog.ActiveControl := NameEdit;
    if Dialog.ShowModal <> mrOk then Exit;
    Name := Trim(NameEdit.Text);
    if Name = '' then Exit;
    if Queue.Items.Count > 0 then
      if BrandedNotice('Start a new playlist and clear the current queue?', mbConfirmation, MB_YESNO) <> idYes then Exit;
    ClearQueue;
    PlaylistPath := '';
    QueueTitle.Caption := Name;
  finally
    Dialog.Free;
  end;
end;

procedure ClearPlaylist(Sender: TObject);
begin
  MenuPanel.Hide;
  ClearQueue;
end;

procedure MenuAbout(Sender: TObject);
var
  Dialog: TSetupForm;
  Artwork: TBitmapImage;
  Heading, Details: TNewStaticText;
  CloseButton: TNewButton;
begin
  MenuPanel.Hide;
  Dialog := CreateCustomForm(ScaleX(680), ScaleY(430), False, False);
  try
    Dialog.Caption := 'About GR Catgirl Player';
    Dialog.BorderStyle := bsSingle;
    Dialog.Color := $00191015;
    ApplyWindowIcon(Dialog);

    Artwork := TBitmapImage.Create(Dialog);
    Artwork.Parent := Dialog;
    Artwork.SetBounds(ScaleX(30), ScaleY(34), ScaleX(144), ScaleY(144));
    Artwork.Stretch := True;
    Artwork.Bitmap.LoadFromFile(ExpandConstant('{tmp}\Launcher.bmp'));

    Heading := TNewStaticText.Create(Dialog);
    Heading.Parent := Dialog;
    Heading.SetBounds(ScaleX(205), ScaleY(48), ScaleX(435), ScaleY(48));
    Heading.Caption := 'GR Catgirl Player';
    Heading.Font.Size := 24;
    Heading.Font.Style := [fsBold];
    Heading.Font.Color := $00EDBADE;

    Details := TNewStaticText.Create(Dialog);
    Details.Parent := Dialog;
    Details.AutoSize := False;
    Details.WordWrap := True;
    Details.SetBounds(ScaleX(207), ScaleY(111), ScaleX(420), ScaleY(230));
    Details.Font.Size := 12;
    Details.Font.Color := $00F2E9F4;
    Details.Caption := 'Version 1.0.0' + #13#10 +
      'GR Studios AI LLC' + #13#10 +
      'Where Imagination Meets Intelligence.' + #13#10#13#10 +
      'A Windows player for music, videos, and mixed playlists. Includes fullscreen video, a music equalizer, and audio visualizers.' + #13#10#13#10 +
      'Video playback powered by FFmpeg.';

    CloseButton := TNewButton.Create(Dialog);
    CloseButton.Parent := Dialog;
    CloseButton.SetBounds(ScaleX(544), ScaleY(368), ScaleX(106), ScaleY(32));
    CloseButton.Caption := 'Close';
    CloseButton.Default := True;
    CloseButton.Cancel := True;
    CloseButton.ModalResult := mrOk;
    Dialog.ShowModal;
  finally
    Dialog.Free;
  end;
end;

procedure AddMenuItem(Caption: String; Y: Integer; Handler: TNotifyEvent);
var
  Item: TNewButton;
begin
  Item := TNewButton.Create(MenuPanel);
  Item.Parent := MenuPanel;
  Item.SetBounds(ScaleX(7), ScaleY(Y), ScaleX(175), ScaleY(27));
  Item.Caption := Caption;
  Item.OnClick := Handler;
end;

function InitializeSetup: Boolean;
var
  I: Integer;
begin
  Result := False;
  Volume := 70;
  CurrentIndex := -1;
  Player := CreateCustomForm(ScaleX(820), ScaleY(590), False, False);
  try
    Player.Caption := 'GR Catgirl Player';
    Player.BorderStyle := bsSizeable;
    Player.Color := $00191015;
    ExtractTemporaryFile('GRCatgirl.ico');
    BrandIcon := LoadBrandIcon(0, ExpandConstant('{tmp}\GRCatgirl.ico'), 1, 32, 32, $10);
    if BrandIcon <> 0 then
    begin
      SendMessage(Player.Handle, $0080, 0, BrandIcon);
      SendMessage(Player.Handle, $0080, 1, BrandIcon);
    end;
    ExtractTemporaryFile('Launcher.bmp');
    Logo := TBitmapImage.Create(Player);
    Logo.Parent := Player;
    Logo.SetBounds(ScaleX(206), ScaleY(10), ScaleX(36), ScaleY(36));
    Logo.Stretch := True;
    Logo.Bitmap.LoadFromFile(ExpandConstant('{tmp}\Launcher.bmp'));
    TitleText := TNewStaticText.Create(Player);
    TitleText.Parent := Player;
    TitleText.SetBounds(ScaleX(252), ScaleY(16), ScaleX(355), ScaleY(28));
    TitleText.Caption := 'GR Catgirl Player';
    TitleText.Font.Size := 14;
    TitleText.Font.Style := [fsBold];
    TitleText.Font.Color := $00EDBADE;
    ExtractTemporaryFile('character.bmp');
    ExtractTemporaryFile('banner.bmp');
    CharacterArt := TBitmapImage.Create(Player);
    CharacterArt.Parent := Player;
    CharacterArt.Stretch := True;
    CharacterArt.Bitmap.LoadFromFile(ExpandConstant('{tmp}\character.bmp'));
    BannerArt := TBitmapImage.Create(Player);
    BannerArt.Parent := Player;
    BannerArt.Stretch := True;
    BannerArt.Bitmap.LoadFromFile(ExpandConstant('{tmp}\banner.bmp'));
    Screen := TPanel.Create(Player);
    Screen.Parent := Player;
    Screen.BevelOuter := bvNone;
    Screen.Color := clBlack;
    QueuePaths := TStringList.Create;
    ShuffleRemaining := TStringList.Create;
    Queue := TNewListBox.Create(Player);
    Queue.Parent := Player;
    Queue.Color := $002D193E;
    Queue.Font.Color := clWhite;
    Queue.OnDblClick := @PlaySelected;
    Timeline := TNewProgressBar.Create(Player);
    Timeline.Parent := Player;
    TimeText := TNewStaticText.Create(Player);
    TimeText.Parent := Player;
    TimeText.Font.Color := clWhite;
    TimeText.Caption := '0:00 / 0:00     Volume 70%';
    OpenButton := Button('＋', 16, 65);
    OpenButton.OnClick := @OpenMedia;
    PauseButton := Button('Ⅱ', 96, 70);
    PauseButton.OnClick := @TogglePause;
    BackButton := Button('⏪', 176, 70);
    BackButton.OnClick := @Seek;
    ForwardButton := Button('⏩', 256, 70);
    ForwardButton.OnClick := @Seek;
    OpenButton.Hint := 'Open media';
    PauseButton.Hint := 'Play or pause';
    BackButton.Hint := 'Previous track / Movie: back 10 seconds';
    ForwardButton.Hint := 'Next track / Movie: forward 10 seconds';
    MuteButton := Button('🔊', 368, 62);
    MuteButton.Hint := 'Mute';
    MuteButton.OnClick := @ToggleMute;
    VolumeTrack := TBitmapImage.Create(Player);
    VolumeTrack.Parent := Player;
    VolumeTrack.OnClick := @ClickVolume;
    ExtractTemporaryFile('VolumeTrack.bmp');
    VolumeTrack.Stretch := True;
    VolumeTrack.Bitmap.LoadFromFile(ExpandConstant('{tmp}\VolumeTrack.bmp'));
    VolumeFill := TBitmapImage.Create(Player);
    VolumeFill.Parent := Player;
    VolumeFill.OnClick := @ClickVolume;
    ExtractTemporaryFile('VolumeFill.bmp');
    VolumeFill.Stretch := True;
    VolumeFill.Bitmap.LoadFromFile(ExpandConstant('{tmp}\VolumeFill.bmp'));
    VolumeFill.Height := ScaleY(7);
    VolumeThumb := TBitmapImage.Create(Player);
    VolumeThumb.Parent := Player;
    VolumeThumb.OnClick := @ClickVolume;
    ExtractTemporaryFile('VolumeThumb.bmp');
    VolumeThumb.Stretch := True;
    VolumeThumb.Bitmap.LoadFromFile(ExpandConstant('{tmp}\VolumeThumb.bmp'));
    VolumeThumb.Width := ScaleX(10);
    VolumeThumb.Height := ScaleY(13);
    FullButton := Button('⛶', 0, 102);
    FullButton.Hint := 'Toggle fullscreen';
    FullButton.OnClick := @ToggleFull;
    ModeButton := Button('', 0, 98);
    ModeButton.Font.Name := 'Segoe MDL2 Assets';
    UpdateModeIcon;
    ModeButton.OnClick := @CycleMode;
    QueueTitle := TNewStaticText.Create(Player);
    QueueTitle.Parent := Player;
    QueueTitle.Caption := 'Playlist';
    QueueTitle.Font.Color := $00EDBADE;
    QueueTitle.Font.Style := [fsBold];
    ViewerHint := TNewStaticText.Create(Player);
    ViewerHint.Parent := Player;
    ViewerHint.Caption := 'Open music or a movie from the menu.';
    ViewerHint.Font.Color := $00EDBADE;
    ViewerHint.Font.Size := 11;
    ExtractTemporaryFile('profile.bmp');
    MenuButton := TBitmapImage.Create(Player);
    MenuButton.Parent := Player;
    MenuButton.Stretch := True;
    MenuButton.Bitmap.LoadFromFile(ExpandConstant('{tmp}\profile.bmp'));
    MenuButton.OnClick := @ToggleMenu;
    MenuPanel := TPanel.Create(Player);
    MenuPanel.Parent := Player;
    MenuPanel.Color := $002D193E;
    MenuPanel.Hide;
    AddMenuItem('Open media...', 7, @MenuOpen);
    AddMenuItem('Add music folder...', 39, @AddMusicFolder);
    AddMenuItem('New playlist...', 71, @NewPlaylist);
    AddMenuItem('Load playlist...', 103, @LoadPlaylist);
    AddMenuItem('Save playlist...', 135, @SavePlaylist);
    AddMenuItem('Clear playlist', 167, @ClearPlaylist);
    AddMenuItem('Music equalizer...', 199, @OpenEqualizer);
    VizButton := TNewButton.Create(MenuPanel);
    VizButton.Parent := MenuPanel;
    VizButton.SetBounds(ScaleX(7), ScaleY(231), ScaleX(175), ScaleY(27));
    VizButton.Caption := 'Visualizer: Spectrum';
    AddMenuItem('Playlist / Player', 263, @TogglePlaylistPage);
    AddMenuItem('About', 295, @MenuAbout);
    VizButton.OnClick := @CycleVisualizer;
    for I := 0 to 23 do
    begin
      VizBars[I] := TBitmapImage.Create(Player);
      VizBars[I].Parent := Screen;
      VizBars[I].Stretch := True;

      VizBars[I].Height := 2;
      VizBars[I].Hide;
    end;
    for I := 0 to 3 do
    begin
      ExtractTemporaryFile('VizColor' + IntToStr(I) + '.bmp');
      VizPalette[I] := TBitmapImage.Create(Player);
      VizPalette[I].Bitmap.LoadFromFile(ExpandConstant('{tmp}\VizColor' + IntToStr(I) + '.bmp'));
    end;
    LoadVisualizerColor;
    BassCompatible := CheckBass;
    try
      if not PrepareVideo then Log('Video initialization deferred.');
    except
      Log('Video initialization deferred: ' + GetExceptionMessage);
    end;
    Player.OnResize := @Layout;
    Layout(nil);
    TimerId := SetPlayerTimer(Player.Handle, 1, 50, CreateCallback(@Tick));
    Player.ShowModal;
  finally
    if TimerId <> 0 then KillPlayerTimer(Player.Handle, TimerId);
    if MediaOpen then CloseMedia;
    if BassReady then BFree;
    ShuffleRemaining.Free;
    QueuePaths.Free;
    Player.Free;
    if BrandIcon <> 0 then ReleaseBrandIcon(BrandIcon);
  end;
end;


