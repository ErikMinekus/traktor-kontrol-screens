import CSI 1.0
import QtQuick 2.0

import '../../../../Defines' as Defines
import '../../../../../Defines'


// dimensions are set in CenterOverlay.qml

CenterOverlay {
  id: mixerFx

  Defines.Margins { id: customMargins }

  property int  deckId:    0

  readonly property var mixerFxNames: {
    "BRPL": "Barber Pole",
    "CRSH": "Crush",
    "DLDL": "Dual Delay",
    "DTDL": "Dotted Delay",
    "FLNG": "Flanger",
    "FLTR": "Filter",
    "NOISE": "Noise",
    "RVRB": "Reverb",
    "TIMG": "Time Gater",
  }
  readonly property var mixerFxSlotNames: [
    mixerFxNames["FLTR"],
    mixerFxNames[Prefs.mixerFxSlots[0]],
    mixerFxNames[Prefs.mixerFxSlots[1]],
    mixerFxNames[Prefs.mixerFxSlots[2]],
    mixerFxNames[Prefs.mixerFxSlots[3]],
  ]

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: fxSelect; path: "app.traktor.mixer.channels." + (deckId+1) + ".fx.select" }

  //--------------------------------------------------------------------------------------------------------------------

  // headline
  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        customMargins.topMarginCenterOverlayHeadline
    font.pixelSize:           fonts.largeFontSize
    color:                    colors.colorCenterOverlayHeadline
    text:                     "MIXER FX"
  }

  // value
  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        53
    font.pixelSize:           fonts.extraLargeValueFontSize
    font.family:              "Pragmatica"
    color:                    colors.mixerFxSlotColors[fxSelect.value]
    text:                     mixerFxSlotNames[fxSelect.value]
  }
}
