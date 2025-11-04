# InnoSetup-BASS-ZipInstaller

An advanced Inno Setup script that:
- Plays background music during installation using **BASS.dll**
- Automatically extracts a **ZIP file** after installation using **Windows Shell**
- Cleans up temporary files automatically

This setup demonstrates how to integrate multimedia and post-install file extraction in an Inno Setup wizard.

## 🧩 Features

- 🎵 **Background music** — plays `music.mp3` during installation via the [BASS Audio Library](https://www.un4seen.com/bass.html).  
- 📦 **Automatic ZIP extraction** — extracts `MyFiles.zip` to `{app}` after installation.  
- 🧹 **Temporary file cleanup** — deletes temporary files after use.  
- ⚙️ **Configurable installer** — uses Inno Setup constants like `{app}`, `{tmp}`, and `{autopf}`.

## 🧰 Prerequisites

Before compiling this script, ensure the following are available:

### 1. **Inno Setup**
- Download and install from [https://jrsoftware.org/isinfo.php](https://jrsoftware.org/isinfo.php)
- Version **6.2+** recommended for best compatibility

### 2. **BASS Audio Library**
- Obtain `bass.dll` from the [official BASS website](https://www.un4seen.com/bass.html)
- Place `bass.dll` in the same folder as your `.iss` script or in a subfolder referenced by:
  ```pascal
  Source: "bass.dll"; DestDir: "{app}"

  Required Files

You’ll need to include the following in your project directory:

Setup.iss          ← The script file (this code)

bass.dll           ← The BASS audio library

music.mp3          ← Background music

MyFiles.zip        ← Files to extract post-install

## 📄 Script Overview
🔹 [Setup]

Defines installer metadata and compression settings.

AppName=My Application

AppVersion=1.0

DefaultDirName={autopf}\MyApp

OutputBaseFilename=MyAppSetup

Compression=lzma2

SolidCompression=yes


🔹 [Files]

Includes bass.dll, music.mp3, and MyFiles.zip in the installer.
Temporary files are deleted after use.

🔹 [Code]

Initializes BASS and plays music during InitializeWizard.

Defines a ZIP extraction routine using Shell.Application.

Extracts MyFiles.zip in CurStepChanged when ssPostInstall occurs.

Cleans up temporary files and releases BASS resources on exit.

▶️ Usage

Place all required files (listed above) in the same folder as the script.

Open the .iss script in Inno Setup Compiler.

Click Compile (F9) to build your installer.

Run the generated setup executable (Output\MyAppSetup.exe).

During installation:

You’ll hear background music.

After installation, the ZIP contents will be automatically extracted into {app}.


## ⚠️ Notes & Tips

The ZIP extraction uses Windows Shell, so it relies on Windows' built-in ZIP support.
If you plan to distribute large files, consider adding a progress dialog or using an external unzip library for better feedback.
The BASS library is not open-source (free for non-commercial use); check its licensing if you use it commercially.
