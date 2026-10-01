# RiverApiLogs

An in-app network inspector for iOS. RiverApiLogs records every HTTP request your app makes and lets you browse them on the device, with no proxy, certificates or Mac required.

Shake the device, and a list of every request, response, header and body captured in the current session appears over your app.

![Swift 5.8+](https://img.shields.io/badge/Swift-5.8%2B-orange)
![iOS 13+](https://img.shields.io/badge/iOS-13%2B-blue)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen)

---

## Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick start](#quick-start)
- [Usage](#usage)
- [API reference](#api-reference)
- [Security and privacy](#security-and-privacy)
- [Troubleshooting](#troubleshooting)
- [Credits](#credits)

---

## Features

- **Automatic capture.** It intercepts traffic from `URLSession`, including sessions created with custom configurations, so you don't have to change your networking code.
- **Request list.** Every call shows its method, URL, status code and duration. You can search by URL, method or response type.
- **Request details.** It shows request and response headers, bodies and URL query strings, and previews images.
- **Pretty-printed bodies.** JSON and other text bodies are formatted so they're easy to read.
- **Sharing.** You can share a simple log or a full log, or export a request as a `curl` command.
- **Statistics.** The statistics screen shows totals, success and failure counts, average response times and data sizes.
- **Filtering.** You can choose which response types appear in the list and statistics.
- **Session logs.** You can share the whole session log from Settings, or read it in code.
- **URL exclusions.** You can stop capturing specific URLs or regex patterns, such as analytics or health checks.
- **Flexible presentation.** Open the inspector by shaking the device, or from your own button or gesture.

## Requirements

| | Minimum |
|---|---|
| iOS | 13.0 |
| Swift | 5.8 |
| Xcode | 14.3 |

> **macOS:** `Package.swift` declares macOS 13, but the macOS code path is not yet complete. iOS is the only supported platform for now.

## Installation

### Swift Package Manager (Xcode)

1. In Xcode, choose **File > Add Package Dependencies…**
2. Enter the repository URL:
   ```
   https://github.com/rashed008/RiverApiLogs.git
   ```
3. Choose **Up to Next Major Version** from `1.0.0`, then add the **RiverApiLogs** library to your app target.

### Swift Package Manager (`Package.swift`)

```swift
dependencies: [
    .package(url: "https://github.com/rashed008/RiverApiLogs.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: ["RiverApiLogs"]
    )
]
```

## Quick start

Start RiverApiLogs as early as you can, before your app sends its first request.

**UIKit (`AppDelegate`)**

```swift
import UIKit
import RiverApiLogs

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        RiverNFX.sharedInstance().start()
        #endif
        return true
    }
}
```

**SwiftUI**

```swift
import SwiftUI
import RiverApiLogs

@main
struct MyApp: App {
    init() {
        #if DEBUG
        RiverNFX.sharedInstance().start()
        #endif
    }

    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
```

Run the app, make a few requests, then **shake the device** to open the inspector. In the Simulator, use **Device > Shake** or press **⌃⌘Z**.

## Usage

### Open the inspector from your own UI

To open the inspector from a debug menu, button or gesture of your own, turn off the shake gesture:

```swift
RiverNFX.sharedInstance().setGesture(.custom)

// Later, for example from a debug button:
RiverNFX.sharedInstance().show()

// Or present it from a specific view controller:
RiverNFX.sharedInstance().show(on: someViewController)
```

You can close it with `hide()` or switch between open and closed with `toggle()`.

### Exclude URLs

Leave noisy or sensitive endpoints out of the log:

```swift
let logger = RiverNFX.sharedInstance()

// Exact URLs (matched as a prefix)
logger.ignoreURL("https://analytics.example.com")
logger.ignoreURLs([
    "https://api.example.com/health",
    "https://cdn.example.com"
])

// Regular expressions
logger.ignoreURLsWithRegex(".*\\.png$")
logger.ignoreURLsWithRegexes([".*/metrics/.*", ".*/ping$"])
```

### Read the session log in code

```swift
if let data = RiverNFX.sharedInstance().getSessionLog(),
   let log = String(data: data, encoding: .utf8) {
    print(log)
}
```

### Control response caching

Captured responses aren't cached by default. You can change this:

```swift
RiverNFX.sharedInstance().setCachePolicy(.allowedInMemoryOnly)
```

### Stop logging

```swift
RiverNFX.sharedInstance().stop()   // Stops capture and clears the logs for this session
```

## API reference

All methods are on the shared instance, `RiverNFX.sharedInstance()`, and can also be called from Objective-C.

| Method | Description |
|---|---|
| `start()` | Starts capturing network traffic. |
| `stop()` | Stops capturing and clears stored data. |
| `isStarted() -> Bool` | Returns whether capture is running. |
| `show()` | Opens the inspector over the top-most view controller. |
| `show(on:)` | Opens the inspector from the given view controller. |
| `hide()` | Closes the inspector. |
| `toggle()` | Opens or closes the inspector. |
| `setGesture(_:)` | `.shake` (default) or `.custom`, which opens the inspector only when you call `show()`. |
| `ignoreURL(_:)` / `ignoreURLs(_:)` | Leaves URLs that start with the given strings out of the log. |
| `ignoreURLsWithRegex(_:)` / `ignoreURLsWithRegexes(_:)` | Leaves URLs that match the given patterns out of the log. |
| `getSessionLog() -> Data?` | Returns the raw session log. |
| `setCachePolicy(_:)` | Sets the `URLCache.StoragePolicy` for captured responses. |

## Security and privacy

RiverApiLogs is a debugging tool. It records full requests and responses, including:

- authorisation headers, bearer tokens and cookies
- request and response bodies, which may contain personal information

Recommendations:

- **Only enable it in debug or internal builds.** Wrap `start()` in `#if DEBUG` or a build flag so it's never active in App Store builds.
- **Exclude sensitive endpoints** with `ignoreURL` or `ignoreURLsWithRegex`, such as login, payments and identity services.
- **Treat shared logs as sensitive.** Exported logs and `curl` commands may contain live credentials. Don't paste them into public issues or chat channels without redacting them.

Logs are stored in the app's sandbox and cleared each time `start()` or `stop()` is called. They are never sent off the device unless you share them.

## Troubleshooting

**Shaking does nothing.**
Check that `start()` has been called and that `setGesture(.custom)` hasn't been set. In the Simulator, use **Device > Shake**.

**Some requests are missing.**
Call `start()` before your app creates its `URLSession` instances. Also check that the URL doesn't match one of your ignore rules. Only `URLSession`-based traffic is captured. Raw sockets, WebSockets and some third-party SDK networking stacks may not be captured.

**"Already started!" in the console.**
`start()` was called more than once. This does no harm, and the extra calls are ignored.

## Credits

RiverApiLogs is based on [netfox](https://github.com/kasketis/netfox) by Christos Kasketis and contributors, which is released under the MIT licence. Many internal types keep the `NFX` prefix from the original project.

Maintained by [Md Rashed Pervez](https://github.com/rashed008).
