# GR Studios AI Compressor

GR Studios AI Compressor is a Windows desktop utility for creating FreeArc archives for repacking workflows. It saves archives with a `.bin` extension and checks them for integrity before writing them to the selected output path.

## Features

- Create archives from a folder or limit the input with filename patterns.
- Choose from No compression, Fast, Balanced, and Maximum presets.
- View compression and verification output in the app.

## Build from source

With Windows PowerShell and the .NET Framework C# compiler available, run the following from the repository root:

```powershell
.\Build-WithIcon.ps1 -LogoIcon .\GRCatgirl.ico
```

The script builds `Compressor.exe`. Archive creation requires a compatible FreeArc executable at `Resources\arc.exe`, relative to the app executable.

## License

The compressor source and build scripts are available under the [MIT License](LICENSE). Third-party utilities and artwork retain their respective terms.

Developed by **GR Studios AI LLC**.
