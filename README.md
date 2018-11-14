# screenshot

Take a screenshot of a specific window on macOS.

Inspired by https://github.com/thismachinechills/screenshot, but rewritten to be a native swift app.

```
Usage: screenshot <app> [options]

Take a screenshot of the specified <app>lication

Options:
  -f, --format <value>      Output format (bmp, gif, jpeg, jpeg2000, png, tiff) [Default: png]
  -o, --out-file <value>    Output file [Required]
  -s, --shadow              Capture the shadow as well
  -t, --title <value>       Window title
```

## Dev

### Run

```sh
swift run screenshot
```

### Build

```sh
swift build --configuration=release -Xswiftc -static-stdlib
```

### Generate Xcode project

```sh
swift package generate-xcodeproj --xcconfig-overrides=Config.xcconfig
```
