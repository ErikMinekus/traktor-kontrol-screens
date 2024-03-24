pragma Singleton

import QtQuick 2.0

QtObject {
  // Display Open Key as Camelot Key
  readonly property bool camelotKey: true

  // Move playmarker position to the left
  readonly property bool playmarkerPositionLeft: true

  // Display bar markers on large waveform
  readonly property bool waveformBarMarkers: true

  // Display minute markers on stripe waveform
  readonly property bool waveformMinuteMarkers: true

  // Waveform colors
  //  0: Default
  //  1: Red
  //  2: Dark Orange
  //  3: Light Orange
  //  4: Warm Yellow
  //  5: Yellow
  //  6: Lime
  //  7: Green
  //  8: Mint
  //  9: Cyan
  // 10: Turquoise
  // 11: Blue
  // 12: Plum
  // 13: Violet
  // 14: Purple
  // 15: Magenta
  // 16: Fuchsia
  // 17: Infrared
  // 18: Ultraviolet
  // 19: X-Ray
  // 20: Nexus
  // 21: Prime
  // 22: RB 3Band
  readonly property int  waveformColors: 20
}
