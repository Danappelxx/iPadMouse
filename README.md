# iPad Mouse
An iOS+OSX app that allows you to use your iPad (or any iOS device) as a graphics tablet. Latency is minimal due to the use of WebSockets over a direct WiFi connection.

[![Demonstration](https://img.youtube.com/vi/tTHTx4MMwg4/0.jpg)](https://www.youtube.com/watch?v=tTHTx4MMwg4 "iPad Mouse Demo")

## Features
- Single tap to left click
- Double tap to double left click
- Single tap + movement to move mouse
- Double tap + movement to move mouse with left gclick

## Dependencies
Uses [StarScream](https://github.com/daltoniam/Starscream) as the WebSocket client, and [Zewo/WebSocketServer](https://github.com/Zewo/WebSocketServer) as the WebSocket server. You can fetch these using `carthage bootstrap --no-build` and `swift build -X`, respectively.

## Setup
### Client
To run the client application, you need to open the xcode project in Xcode 8 Beta 2. Then, the app should run on any iOS device (tested on iOS 10 iPad Pro).

### Server
To run the server either use a precompiled binary or build from source.

#### Precompiled Binary
Download the binary for the [latest release](https://github.com/Danappelxx/iPadMouse/releases) and CD into the downloads directory. Run `chmod +x ipad-mouse` and then `./ipad-mouse` to start the server.

#### Build from Source
You need to be able to build code compatible with the 05-09 snapshot with the OSX SDK. For me, the following options work:

- Generate the Xcode project with `swift build -X` and open it using Xcode 7.3.1 with the 05-09 snapshot selected
- Have Xcode 8 Beta 1 selected using `xcode-select` and run `xcrun --sdk macosx swift build` in the command line

## Usage
Ensure that both of your devices are connected to the same WiFi network.

Replace the [`ip` constant](https://github.com/Danappelxx/iPadMouse/blob/master/ipad-mouse-ios/ViewController.swift#L14) with your mac's ip address in the local network. You can find this by running `ifconfig | grep netmask`. For my machine, it is `192.168.1.132`.

Run the iOS app on your device and wait for it to connect.
