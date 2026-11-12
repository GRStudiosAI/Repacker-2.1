; Compile this script to build GameLauncher.exe directly.
[Setup]
AppName=GR Studios AI Game Launcher
AppVersion=1.0.0
AppPublisher=GR Studios AI LLC
DefaultDirName={localappdata}\GR Studios AI\GameLauncher
PrivilegesRequired=lowest
Uninstallable=no
CreateUninstallRegKey=no
OutputDir=Output
OutputBaseFilename=GameLauncher
Compression=lzma2

[Files]
Source: "GameUI\Launcher.bmp"; Flags: dontcopy

[Code]
var
  MainForm: TSetupForm;
  Status: TNewStaticText;
  PlayButton: TNewButton;

procedure PlayClick(Sender: TObject);
var
  Target: String;
  ErrorCode: Integer;
begin
  Target := GetIniString('Game', 'Executable', '', ExpandConstant('{src}\LauncherInfo.ini'));
  if Target <> '' then
    Target := ExpandConstant('{src}\') + Target
  else if not GetOpenFileName('Select the game executable', Target, ExpandConstant('{src}'),
    'Windows applications (*.exe)|*.exe', 'exe') then
    Exit;
  if not FileExists(Target) then
    Status.Caption := 'Game executable not found.'
  else if not Exec(Target, '', ExtractFileDir(Target), SW_SHOWNORMAL, ewNoWait, ErrorCode) then
    Status.Caption := 'Could not launch the game. Error ' + IntToStr(ErrorCode)
  else
    Status.Caption := 'Game launched.';
end;

function AddButton(Caption: String; Left: Integer): TNewButton;
begin
  Result := TNewButton.Create(MainForm);
  Result.Parent := MainForm;
  Result.SetBounds(ScaleX(Left), ScaleY(222), ScaleX(118), ScaleY(32));
  Result.Caption := Caption;
end;

function InitializeSetup: Boolean;
var
  Art: TBitmapImage;
  Heading: TNewStaticText;
begin
  Result := False;
  MainForm := CreateCustomForm(ScaleX(640), ScaleY(275), False, False);
  try
    MainForm.Caption := 'GR Studios AI Game Launcher';
    MainForm.Color := $002F131C;
    ExtractTemporaryFile('Launcher.bmp');
    Art := TBitmapImage.Create(MainForm);
    Art.Parent := MainForm;
    Art.SetBounds(ScaleX(22), ScaleY(22), ScaleX(112), ScaleY(112));
    Art.Stretch := True;
    Art.Bitmap.LoadFromFile(ExpandConstant('{tmp}\Launcher.bmp'));
    Heading := TNewStaticText.Create(MainForm);
    Heading.Parent := MainForm;
    Heading.Caption := 'Game Launcher';
    Heading.SetBounds(ScaleX(155), ScaleY(30), ScaleX(440), ScaleY(48));
    Heading.Font.Size := 23;
    Heading.Font.Color := clWhite;
    Status := TNewStaticText.Create(MainForm);
    Status.Parent := MainForm;
    Status.SetBounds(ScaleX(155), ScaleY(95), ScaleX(455), ScaleY(26));
    Status.Font.Color := clWhite;
    Status.Caption := 'Choose Play to launch the game.';

    PlayButton := AddButton('Play', 22);
    PlayButton.OnClick := @PlayClick;

    MainForm.ShowModal;

  finally
    MainForm.Free;
  end;
end;

