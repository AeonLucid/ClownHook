# ClownHook

Experimental hooking on Arm64.

> **Status** Experimenting 

## Setup

Install `xcodegen` to generate an Xcode project.

```
brew install xcodegen
```

Create the Xcode project.

```
xcodegen --spec project.json
```

Open `ClownHook.xcodeproj` in Xcode or AppCode.

Run either `ClownHookApp_iOS` or `ClownHookApp_macOS`.

## Credits

- https://github.com/landonf/libevil_patch