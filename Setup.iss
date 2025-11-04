[Setup]
AppName=My Application
AppVersion=1.0
DefaultDirName={autopf}\MyApp
DefaultGroupName=My Application
OutputDir=Output
OutputBaseFilename=MyAppSetup
Compression=lzma2
SolidCompression=yes

[Files]
; Include the zip file in the installer
Source: "MyFiles.zip"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "bass.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "music.mp3"; DestDir: "{app}"; Flags: ignoreversion

[Code]
const
BASS_SAMPLE_LOOP = 4;
BASS_UNICODE = $80000000;
BASS_CONFIG_GVOL_STREAM = 5;
const
#ifndef UNICODE
EncodingFlag = 0;
#else
EncodingFlag = BASS_UNICODE;
#endif
type
HSTREAM = DWORD;

function BASS_Init(device: LongInt; freq, flags: DWORD;
win: HWND; clsid: Cardinal): BOOL;
external 'BASS_Init@files:bass.dll stdcall';
function BASS_StreamCreateFile(mem: BOOL; f: string; offset1: DWORD;
offset2: DWORD; length1: DWORD; length2: DWORD; flags: DWORD): HSTREAM;
external 'BASS_StreamCreateFile@files:bass.dll stdcall';
function BASS_ChannelPlay(handle: DWORD; restart: BOOL): BOOL;
external 'BASS_ChannelPlay@files:bass.dll stdcall';
function BASS_SetConfig(option: DWORD; value: DWORD ): BOOL;
external 'BASS_SetConfig@files:bass.dll stdcall';
function BASS_Free: BOOL;
external 'BASS_Free@files:bass.dll stdcall';

procedure InitializeWizard;
var
StreamHandle: HSTREAM;
begin
ExtractTemporaryFile('music.mp3');
if BASS_Init(-1, 44100, 0, 0, 0) then
begin
StreamHandle := BASS_StreamCreateFile(False,
ExpandConstant('{tmp}\music.mp3'), 0, 0, 0, 0,
EncodingFlag or BASS_SAMPLE_LOOP);
BASS_SetConfig(BASS_CONFIG_GVOL_STREAM, 2500);
BASS_ChannelPlay(StreamHandle, False);
end;
end;

procedure DeinitializeSetup;
begin
BASS_Free;
end;

[Code]
// Function to extract zip files using Windows Shell
procedure ExtractZip(ZipFile, TargetPath: string);
var
Shell: Variant;
ZipFileVariant: Variant;
TargetFolder: Variant;
begin
// Create Shell object
Shell := CreateOleObject('Shell.Application');

// Get the zip file
ZipFileVariant := Shell.NameSpace(ZipFile);

// Get target folder
TargetFolder := Shell.NameSpace(TargetPath);

// Extract all files (16 = No progress dialog, no confirmation dialogs)
TargetFolder.CopyHere(ZipFileVariant.Items, 16);
end;

// Run after all files are installed
procedure CurStepChanged(CurStep: TSetupStep);
var
ZipPath: string;
ExtractPath: string;
begin
if CurStep = ssPostInstall then
begin
// Set paths
ZipPath := ExpandConstant('{tmp}\MyFiles.zip');
ExtractPath := ExpandConstant('{app}');

// Show progress
WizardForm.StatusLabel.Caption := 'Extracting files...';
WizardForm.ProgressGauge.Style := npbstMarquee;

try
// Extract the zip file
ExtractZip(ZipPath, ExtractPath);

// Optional: Add a delay to ensure extraction completes
Sleep(1000);

// Delete the zip file after extraction
if FileExists(ZipPath) then
begin
DeleteFile(ZipPath);
end;
except
MsgBox('Error extracting files...', mbError, MB_OK);
end;

WizardForm.ProgressGauge.Style := npbstNormal;
end;
end;
