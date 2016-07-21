import PackageDescription

let package = Package(
    name: "ipad-mouse",
    dependencies: [
        .Package(url: "https://github.com/Zewo/WebSocketServer.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/VeniceX/HTTPServer.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/Zewo/JSON", majorVersion: 0, minor: 9)
    ]
)
