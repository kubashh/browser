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

## TODO

- parse html
- render html
- parse css
- render css
- parse js
- run js
- networking
- cookies
- rendering
- tabs
- toolbar
- address Bar
- bookmarks
- history
- settings

- Window
- Embedded WebView
- Open URL
- Reload
- Back
- Forward

- Tabs
- History
- Bookmarks

- Downloads
- Settings
- Find in page
- Zoom

- Private mode
- Better UI

- Cross-platform polish
- Packaging
- Automatic updates

## License

MIT

## Comparing browser features

| Feature browsers should have                                       | ThisBrowser | Chrome                                           | Firefox                                                       | Safari                                                                    |
| ------------------------------------------------------------------ | ----------- | ------------------------------------------------ | ------------------------------------------------------------- | ------------------------------------------------------------------------- |
| Fast, standards-based rendering                                    | No          | Blink/WebKit-derived engine (Chromium)           | Gecko engine                                                  | WebKit engine                                                             |
| Auto-updates                                                       | No          | Yes (seamless/OS dependent)                      | Yes (seamless/OS dependent)                                   | Yes (macOS/iOS updates)                                                   |
| Extension/plugin support (secure sandboxed model)                  | No          | Yes (Chrome Extensions)                          | Yes (WebExtensions)                                           | Yes (Safari Extensions)                                                   |
| Private browsing (per-session)                                     | No          | Yes (Incognito)                                  | Yes (Private Window)                                          | Yes (Private Browsing)                                                    |
| Tracking protection controls                                       | No          | Built-in tracking protection + ecosystem signals | Stronger default-ish tracking protections (varies by version) | Intelligent Tracking Prevention (ITP)                                     |
| Third-party cookie controls                                        | No          | Gradual phaseouts/controls                       | Strict/Enhanced Tracking Protection options                   | ITP-based restrictions                                                    |
| Site permissions UI (camera/mic/location/notifications)            | No          | Yes (site settings)                              | Yes (permissions prompts + settings)                          | Yes (site settings + prompts)                                             |
| Password manager integration                                       | No          | Yes (Google Password Manager)                    | Yes (built-in + sync options)                                 | Yes (iCloud Keychain)                                                     |
| Passkeys support                                                   | No          | Yes                                              | Yes                                                           | Yes                                                                       |
| Sync across devices                                                | No          | Yes (Google account sync)                        | Yes (Firefox Account sync)                                    | Yes (Apple ID/iCloud)                                                     |
| Form autofill                                                      | No          | Yes                                              | Yes                                                           | Yes (Autofill)                                                            |
| Do-not-track / privacy preferences                                 | No          | Exposed settings                                 | Exposed settings                                              | Exposed settings (varies)                                                 |
| DNS security (secure transport)                                    | No          | HTTPS + secure DNS features                      | HTTPS-only mode + DNS security features                       | HTTPS fallback + DNS/transport features (varies)                          |
| HTTPS enforcement / upgrade-insecure-requests                      | No          | Yes                                              | Yes                                                           | Yes (where supported)                                                     |
| Content blocking (ads/scripts)                                     | No          | Extensions + built-in protections                | Built-in-ish + extensions                                     | Extensions + built-in protections                                         |
| Pop-up blocking                                                    | No          | Yes                                              | Yes                                                           | Yes                                                                       |
| Built-in translation                                               | No          | Yes                                              | Limited/native options + add-ons                              | Yes (system/browser capabilities)                                         |
| Reader mode / article view                                         | No          | Reader mode (varies by platform)                 | Reader View                                                   | Reader                                                                    |
| Tab management (grouping, preview, pinning)                        | No          | Yes                                              | Yes                                                           | Yes                                                                       |
| Session restore (recover tabs after crash)                         | No          | Yes                                              | Yes                                                           | Yes                                                                       |
| Search within page + find enhancements                             | No          | Yes                                              | Yes                                                           | Yes                                                                       |
| Developer tools (DOM inspector, network profiler, console)         | No          | Very full-featured                               | Very full-featured                                            | Full-featured but Safari-specific tooling                                 |
| Mobile responsiveness                                              | No          | Yes                                              | Yes                                                           | Yes (strong on Apple platforms)                                           |
| Accessibility support (screen readers, keyboard nav)               | No          | Yes                                              | Yes                                                           | Yes                                                                       |
| Download manager (resumable, safe warnings)                        | No          | Yes                                              | Yes                                                           | Yes                                                                       |
| Safe browsing / phishing/malware protection                        | No          | Yes (Google Safe Browsing)                       | Yes (Safe Browsing features)                                  | Yes (Safe Browsing protections)                                           |
| Certificate/SSL validation UI                                      | No          | Yes                                              | Yes                                                           | Yes                                                                       |
| File upload/download APIs                                          | No          | Yes                                              | Yes                                                           | Yes (with WebKit constraints)                                             |
| Web standards coverage (HTML/CSS/JS + APIs)                        | No          | Broad                                            | Broad (often ahead on some features)                          | Good, but some APIs lag/lead depending on iOS/macOS                       |
| WebAssembly, WebGPU, modern JS features                            | No          | Yes                                              | Yes                                                           | Yes (varies by version)                                                   |
| Web App installability (PWA)                                       | No          | Yes (strong)                                     | Yes                                                           | Yes (Safari supports; iOS constraints)                                    |
| Offline support (Service Worker)                                   | No          | Yes                                              | Yes                                                           | Yes (varies on iOS)                                                       |
| Notifications / background behavior                                | No          | Yes                                              | Yes                                                           | Yes (platform limits)                                                     |
| Background tabs throttling / power management                      | No          | Yes                                              | Yes                                                           | Yes (tuned for Apple devices)                                             |
| Media autoplay controls                                            | No          | Yes                                              | Yes                                                           | Yes                                                                       |
| Focus/scrolling correctness for accessibility                      | No          | Yes                                              | Yes                                                           | Yes                                                                       |
| Performance features (lazy loading, scheduling, memory management) | No          | Yes                                              | Yes                                                           | Yes                                                                       |
| Localization & language detection                                  | No          | Yes                                              | Yes                                                           | Yes                                                                       |
| Standards-based printing / PDF                                     | No          | Built-in PDF viewer/print                        | Built-in PDF viewer/print                                     | Built-in PDF viewer/print                                                 |
| Automation/security boundaries for extensions                      | No          | Strong sandboxing model                          | Strong sandboxing model                                       | Extension model (tighter on some platforms)                               |
| Cross-platform parity                                              | No          | Medium (Windows/macOS/Android/ChromeOS vary)     | Medium (desktop + mobile)                                     | Medium-high on Apple; lower on Windows/Android (Safari doesn’t run there) |
