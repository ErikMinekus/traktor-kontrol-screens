# Display modifications for the Traktor Kontrol S8/S5/D2

Based on [Erik Minekus's Nexus Edition](https://github.com/ErikMinekus/traktor-kontrol-screens/tree/nexus). The `qml copy/` folder contains the unmodified stock files for comparison.

## Changes in appearance

### Browser: Harmonic key coloring relative to master deck

Keys in the browser list are colored based on their harmonic compatibility with the currently playing master deck, using the Camelot Wheel:

- **Yellow**: Same key (perfect match)
- **Orange**: ±1 semitone (adjacent keys)
- **Green**: +2 or +7 semitones (energy boost, same tonality)
- **Blue**: -2 or -7 semitones (energy drop, same tonality)
- **Default**: No harmonic relationship

Previously played tracks are tinted green, and tracks currently loaded in a deck are highlighted. This is implemented via `getMasterKeyOffset()` in `Screens/Defines/Utils.qml` and `getListItemKeyTextColor()` in the browser `ListDelegate.qml`.

### Browser: Compact layout showing more tracks

The browser list is denser so more tracks are visible at once:

- Row height reduced from 33px to 26px (fits 10 items instead of 8)
- Font size reduced from `middleFontSize` (15px) to `smallFontSize` (12px)
- Album art thumbnails reduced from 33x33px to 26x26px
- Deck load indicators (A/B/C/D corner badges) reduced from 11px to 9px
- Preview icons reduced from 17px to 13px
- Tighter margins throughout (left margins 37→30px, column widths adjusted)
- Browser header: wider text paths (150→280px max width), removed bottom shadow/gradient, added browser node icons (e.g., Track Collection, Playlists) with separator arrows

### Bar markers on the large waveform

Every 4th beat marker is drawn as a bar marker on the waveform, appearing at both the top and bottom edges. Beat markers are shown as 6px white ticks; bar markers are 10px red ticks. This makes phrase structure visible at a glance. Controlled by `Prefs.waveformBarMarkers` in `Defines/Prefs.qml`.

The bar markers are calculated dynamically in `BeatgridView.qml` by filtering the `beatMarkers` array to every 4th entry, aligned to the grid markers.

### Minute markers on the stripe waveform

Small 3px white tick marks appear at every 60-second interval on the stripe (overview) waveform, giving a sense of track position by time. Controlled by `Prefs.waveformMinuteMarkers` in `Defines/Prefs.qml`.

### Camelot key notation

Open Key notation (e.g., `1d`, `8m`) is converted to Camelot notation (e.g., `7B`, `2A`) throughout the browser using the formula: `(pitch + 6) % 12 + 1` with `d`→`B` and `m`→`A`. Controlled by `Prefs.camelotKey` in `Defines/Prefs.qml`.

### FX overlay is always fullscreen

The FX selection overlay uses the full screen instead of the small center overlay, making it easier to read FX names and parameters.

### Mixer FX selection overlay

A new center overlay (Shift+FX Select) shows the current Mixer FX assignment for the channel. While the overlay is open, the browse encoder cycles through the available Mixer FX slots. The available slots and their display names are configured in `Prefs.mixerFxSlots`. Each Mixer FX slot has a distinct color defined in `Colors.qml` via `mixerFxSlotColors`.

### Improved spacing and layout

- **Deck header**: Simplified from a two-row layout (title/artist + sync/loop/phase) to a single compact row showing title, remaining time with beat counter, and BPM with tempo percentage. Cover art and the STEM/STEP badge are removed. Header heights are tighter: small 20px (was 17), medium 24px (new), large 40px (was 45).
- **Track deck**: Waveform takes up more vertical space (waveformHeight calculation changed to give 83px to header+stripe instead of 43-53px). Stripe gap filler rectangles removed. Stripe margins reduced (9→6px).
- **Playmarker**: Changed from red to white (turns yellow when flux is active). Can be positioned at the left quarter of the waveform instead of center, controlled by `Prefs.playmarkerPositionLeft` — this gives a wider view of upcoming beats ahead of the playhead.
- **Stripe position indicator**: Box color changed from red to white, position adjusts to left-quarter or center based on `Prefs.playmarkerPositionLeft`.
- **Stripe background**: Changed from `colorBgEmpty` to `transparent`.

### Waveform zoom defaults

Default waveform zoom level changed from 7 to 9 (the maximum), showing more beats on screen at once.

### Spectrum waveform colors

Six new waveform color themes added beyond the stock 17, for a total of 23:

| Index | Theme       | Description                               |
| ----- | ----------- | ----------------------------------------- |
| 0-16  | Stock       | Default through Fuchsia                   |
| 17    | Infrared    | Red-Rose-BrightPink warm tones            |
| 18    | Ultraviolet | Blue-Plum-BrightMint cool tones           |
| 19    | X-Ray       | Monochrome grey with bright highs         |
| 20    | Nexus       | Red lows, blue mids, cyan highs (default) |
| 21    | Prime       | Blue lows, green mids, white highs        |
| 22    | RB 3Band    | Blue lows, orange mids, white highs       |

The default color is set to 20 (Nexus) in `Defines/Prefs.qml`. Each theme defines RGBA values for six frequency bands: `low1`, `low2`, `mid1`, `mid2`, `high1`, `high2`.

### Deck header info fields

The track deck header now displays:

- **Left**: Track title (wider, up to 276px)
- **Middle**: Remaining time with beat counter (state 14, was state 12 "elapsed time")
- **Right**: BPM with tempo percentage (state 17, was state 23 "key value")

### Sync button LED feedback

The Sync button LED now provides color feedback:

- **Green**: Tempo is synced and phase is aligned (within 0.01)
- **Red**: Tempo is synced but phase is off
- **Dim**: Sync is disabled

## Changes in functionality

### Sorting by Genre and Release

Two new browser sorting columns are available via the sort selector:

- **Genre**: Database column ID 9 (mapped as sort ID 15)
- **Release**: Database column ID 7 (mapped as sort ID 26)

These appear alongside the existing #, Title, Artist, BPM, Key, Rating, and Import Date sort options.

### Hold Sync to adjust BPM

The Sync button now has a dual-function behavior using a 250ms timer:

- **Quick press** (< 250ms): Toggles sync on/off
- **Hold** (≥ 250ms): Opens the BPM overlay temporarily so you can see the current tempo while adjusting. The overlay auto-closes when you release the button.
- **Shift+Sync**: Sets the deck as the master deck (was previously handled differently)

### Improved timings

Several timer values have been adjusted for better responsiveness:

| Timer                     | Stock  | Mod    | Effect                                    |
| ------------------------- | ------ | ------ | ----------------------------------------- |
| Overlay auto-hide         | 3000ms | 5000ms | Overlays stay visible longer              |
| Screen view blinker cycle | 300ms  | 1000ms | Slower, less distracting blink            |
| Browser back timer        | 1000ms | 500ms  | Faster back button response               |
| Overlay reset timeout     | 1000ms | 2000ms | More time before overlay resets           |
| Loop size touch timer     | 500ms  | 50ms   | Nearly instant loop size display on touch |

### Shift+Flux = Flux Reverse

Pressing Flux normally engages standard Flux mode. Pressing Shift+Flux engages Flux Reverse mode. This applies to all four decks. The wire mapping changes from a single `flux` target to separate `flux` (unshifted) and `flux_reverse` (shifted) targets.

### Shift+FX Select = Mixer FX

Pressing Shift+FX Select opens a new Mixer FX overlay. While the overlay is visible, the browse encoder cycles through the available Mixer FX for the focused channel (0-4, mapped to the slots defined in `Prefs.mixerFxSlots`). This provides quick access to Mixer FX selection without navigating through Traktor's preferences.

### BPM coarse and fine adjustment swap

The default and shifted behavior of the browse encoder during BPM adjustment are swapped:

- **Default** (no shift): Coarse BPM adjustment (was fine)
- **Shift held**: Fine BPM adjustment (was coarse)

This makes large tempo changes faster in the common case.

### Browse knob: Waveform zoom (Track) / Page scroll (Remix)

- **Track Deck**: The browse encoder controls waveform zoom level (step -1 per increment, covering the full 0-9 zoom range). This only works when no overlay is active.
- **Remix Deck**: The browse encoder scrolls through remix deck pages.
- **Step Sequencer**: The browse encoder scrolls through sequencer pages.

## Preferences (`Defines/Prefs.qml`)

All user-configurable options in one file:

| Property                 | Type  | Default                 | Description                                                 |
| ------------------------ | ----- | ----------------------- | ----------------------------------------------------------- |
| `barsPerPhrase`          | int   | 4                       | Bars per phrase for the beat counter                        |
| `camelotKey`             | bool  | true                    | Display Open Key as Camelot Key notation                    |
| `mixerFxSlots`           | array | RVRB, DLDL, NOISE, TIMG | Mixer FX available (must match Traktor Preferences > Mixer) |
| `playmarkerPositionLeft` | bool  | true                    | Move playmarker to the left quarter of the waveform         |
| `waveformBarMarkers`     | bool  | true                    | Show bar markers on the large waveform                      |
| `waveformMinuteMarkers`  | bool  | true                    | Show minute markers on the stripe waveform                  |
| `waveformColors`         | int   | 20                      | Waveform color theme (0-22, see table above)                |

## Editions

[Kontrol Edition](https://github.com/ErikMinekus/traktor-kontrol-screens/tree/master)\
[Nexus Edition](https://github.com/ErikMinekus/traktor-kontrol-screens/tree/nexus)\
[Prime Edition](https://github.com/ErikMinekus/traktor-kontrol-screens/tree/prime)

## How to install

**Mac:**

- Navigate to /Applications/Native Instruments/Traktor Pro 4
- Right click Traktor Pro 4.app, then click Show Package Contents
- Navigate to Contents/Resources/qml
- Make a backup of this folder!
- Replace the CSI, Defines and Screens folders
- Restart Traktor

**Windows:**

- Navigate to C:\Program Files\Native Instruments\Traktor Pro 4\Resources64\qml
- Make a backup of this folder!
- Replace the CSI, Defines and Screens folders
- Restart Traktor

## Screenshots

![Track Deck (Master)](https://ErikMinekus.github.io/traktor-kontrol-screens/nexus/track-deck-master.jpg)
![Track Deck (Sync)](https://ErikMinekus.github.io/traktor-kontrol-screens/nexus/track-deck-sync.jpg)
![Track Deck (Split View)](https://ErikMinekus.github.io/traktor-kontrol-screens/nexus/track-deck-split.jpg)
![Browser](https://ErikMinekus.github.io/traktor-kontrol-screens/nexus/browser.jpg)
