# Browser

A fast, lightweight, secure, independent, cross-platform web browser written in **Zig** using the operating system's **native WebView**.

## Goals

- Cross-platform (Linux, MacOS, Windows)
- Native look and feel
- Fast startup
- Small executable
- Simple architecture
- Minimal external dependencies
- Low RAM usage
- Learn browser development without implementing an HTML/CSS/JS engine

## Philosophy

Hello Browser is **not** a browser engine.

Instead, it provides a browser application built around the platform's native WebView.

Rendering is delegated to:

| Platform | Engine              |
| -------- | ------------------- |
| Linux    | WebKitGTK           |
| macOS    | WKWebView           |
| Windows  | WebView2 (Chromium) |

The browser itself is responsible for everything around the rendering engine.

## Planned Features

### Core

- Main window
- Native WebView
- Address bar
- Back
- Forward
- Reload
- Stop loading
- Home page

### Navigation

- Open URL
- Open local HTML files
- Multiple tabs
- New window

### History

- Navigation history
- Recently closed tabs
- Session restore

### Bookmarks

- Add bookmark
- Remove bookmark
- Bookmark manager

### Settings

- Homepage
- Search engine
- Downloads location
- Theme
- Privacy options

### Downloads

- Download manager
- Progress indicator
- Pause/Resume
- Open downloaded files

### UI

- Toolbar
- Status bar
- Find in page
- Zoom controls
- Fullscreen

### Privacy

- Clear browsing data
- Cookie management
- Private browsing

### Developer

- Developer tools (if supported)
- View source
- Console output

## Project Structure

```
hello-browser/
│
├── build.zig
├── build.zig.zon
├── README.md
│
├── src/
│   ├── main.zig
│   ├── app.zig
│   ├── browser.zig
│   ├── window.zig
│   ├── webview.zig
│   ├── history.zig
│   ├── bookmarks.zig
│   ├── settings.zig
│   └── ui/
│
├── assets/
│
└── docs/
```

## Architecture

```
+---------------------------+
|        Browser UI         |
|---------------------------|
| Tabs                      |
| Toolbar                   |
| Address Bar               |
| Bookmarks                 |
| History                   |
| Settings                  |
|---------------------------|
|      Native WebView       |
|---------------------------|
| HTML                      |
| CSS                       |
| JavaScript                |
| Networking                |
| Cookies                   |
| Rendering                 |
+---------------------------+
```

## Future Roadmap

### Milestone 1

- Window
- Embedded WebView
- Open URL
- Reload
- Back
- Forward

### Milestone 2

- Tabs
- History
- Bookmarks

### Milestone 3

- Downloads
- Settings
- Find in page
- Zoom

### Milestone 4

- Private mode
- Better UI

### Milestone 5

- Cross-platform polish
- Packaging
- Automatic updates

## License

MIT

## Comparing browser features

| Feature browsers should have                                       | Chrome                                           | Firefox                                                       | Safari                                                                    |
| ------------------------------------------------------------------ | ------------------------------------------------ | ------------------------------------------------------------- | ------------------------------------------------------------------------- |
| Fast, standards-based rendering                                    | Blink/WebKit-derived engine (Chromium)           | Gecko engine                                                  | WebKit engine                                                             |
| Auto-updates                                                       | Yes (seamless/OS dependent)                      | Yes (seamless/OS dependent)                                   | Yes (macOS/iOS updates)                                                   |
| Extension/plugin support (secure sandboxed model)                  | Yes (Chrome Extensions)                          | Yes (WebExtensions)                                           | Yes (Safari Extensions)                                                   |
| Private browsing (per-session)                                     | Yes (Incognito)                                  | Yes (Private Window)                                          | Yes (Private Browsing)                                                    |
| Tracking protection controls                                       | Built-in tracking protection + ecosystem signals | Stronger default-ish tracking protections (varies by version) | Intelligent Tracking Prevention (ITP)                                     |
| Third-party cookie controls                                        | Gradual phaseouts/controls                       | Strict/Enhanced Tracking Protection options                   | ITP-based restrictions                                                    |
| Site permissions UI (camera/mic/location/notifications)            | Yes (site settings)                              | Yes (permissions prompts + settings)                          | Yes (site settings + prompts)                                             |
| Password manager integration                                       | Yes (Google Password Manager)                    | Yes (built-in + sync options)                                 | Yes (iCloud Keychain)                                                     |
| Passkeys support                                                   | Yes                                              | Yes                                                           | Yes                                                                       |
| Sync across devices                                                | Yes (Google account sync)                        | Yes (Firefox Account sync)                                    | Yes (Apple ID/iCloud)                                                     |
| Form autofill                                                      | Yes                                              | Yes                                                           | Yes (Autofill)                                                            |
| Do-not-track / privacy preferences                                 | Exposed settings                                 | Exposed settings                                              | Exposed settings (varies)                                                 |
| DNS security (secure transport)                                    | HTTPS + secure DNS features                      | HTTPS-only mode + DNS security features                       | HTTPS fallback + DNS/transport features (varies)                          |
| HTTPS enforcement / upgrade-insecure-requests                      | Yes                                              | Yes                                                           | Yes (where supported)                                                     |
| Content blocking (ads/scripts)                                     | Extensions + built-in protections                | Built-in-ish + extensions                                     | Extensions + built-in protections                                         |
| Pop-up blocking                                                    | Yes                                              | Yes                                                           | Yes                                                                       |
| Built-in translation                                               | Yes                                              | Limited/native options + add-ons                              | Yes (system/browser capabilities)                                         |
| Reader mode / article view                                         | Reader mode (varies by platform)                 | Reader View                                                   | Reader                                                                    |
| Tab management (grouping, preview, pinning)                        | Yes                                              | Yes                                                           | Yes                                                                       |
| Session restore (recover tabs after crash)                         | Yes                                              | Yes                                                           | Yes                                                                       |
| Search within page + find enhancements                             | Yes                                              | Yes                                                           | Yes                                                                       |
| Developer tools (DOM inspector, network profiler, console)         | Very full-featured                               | Very full-featured                                            | Full-featured but Safari-specific tooling                                 |
| Mobile responsiveness                                              | Yes                                              | Yes                                                           | Yes (strong on Apple platforms)                                           |
| Accessibility support (screen readers, keyboard nav)               | Yes                                              | Yes                                                           | Yes                                                                       |
| Download manager (resumable, safe warnings)                        | Yes                                              | Yes                                                           | Yes                                                                       |
| Safe browsing / phishing/malware protection                        | Yes (Google Safe Browsing)                       | Yes (Safe Browsing features)                                  | Yes (Safe Browsing protections)                                           |
| Certificate/SSL validation UI                                      | Yes                                              | Yes                                                           | Yes                                                                       |
| File upload/download APIs                                          | Yes                                              | Yes                                                           | Yes (with WebKit constraints)                                             |
| Web standards coverage (HTML/CSS/JS + APIs)                        | Broad                                            | Broad (often ahead on some features)                          | Good, but some APIs lag/lead depending on iOS/macOS                       |
| WebAssembly, WebGPU, modern JS features                            | Yes                                              | Yes                                                           | Yes (varies by version)                                                   |
| Web App installability (PWA)                                       | Yes (strong)                                     | Yes                                                           | Yes (Safari supports; iOS constraints)                                    |
| Offline support (Service Worker)                                   | Yes                                              | Yes                                                           | Yes (varies on iOS)                                                       |
| Notifications / background behavior                                | Yes                                              | Yes                                                           | Yes (platform limits)                                                     |
| Background tabs throttling / power management                      | Yes                                              | Yes                                                           | Yes (tuned for Apple devices)                                             |
| Media autoplay controls                                            | Yes                                              | Yes                                                           | Yes                                                                       |
| Focus/scrolling correctness for accessibility                      | Yes                                              | Yes                                                           | Yes                                                                       |
| Performance features (lazy loading, scheduling, memory management) | Yes                                              | Yes                                                           | Yes                                                                       |
| Localization & language detection                                  | Yes                                              | Yes                                                           | Yes                                                                       |
| Standards-based printing / PDF                                     | Built-in PDF viewer/print                        | Built-in PDF viewer/print                                     | Built-in PDF viewer/print                                                 |
| Automation/security boundaries for extensions                      | Strong sandboxing model                          | Strong sandboxing model                                       | Extension model (tighter on some platforms)                               |
| Cross-platform parity                                              | Medium (Windows/macOS/Android/ChromeOS vary)     | Medium (desktop + mobile)                                     | Medium-high on Apple; lower on Windows/Android (Safari doesn’t run there) |
