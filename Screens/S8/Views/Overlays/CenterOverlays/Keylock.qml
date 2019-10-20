import QtQuick 2.0
import CSI 1.0

import '../../../../Defines' as Defines


// dimensions are set in CenterOverlay.qml

CenterOverlay {
  id: keylock

  property int  deckId:    0
  readonly property variant keyText:    {"1d": "8B", "8d": "3B", "3d": "10B", "10d": "5B", "5d": "12B", "12d": "7B",
                                         "7d": "2B", "2d": "9B", "9d": "4B", "4d": "11B", "11d": "6B", "6d": "1B",
                                         "10m": "5A", "5m": "12A", "12m": "7A", "7m": "2A", "2m": "9A", "9m": "4A",
                                         "4m": "11A", "11m": "6A", "6m": "1A", "1m": "8A", "8m": "3A", "3m": "10A"}

  Defines.Margins {id: customMargins }


  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: keyValue;   path: "app.traktor.decks." + (deckId+1) + ".track.key.adjust" }
  AppProperty { id: keyId;      path: "app.traktor.decks." + (deckId+1) + ".track.key.final_id" }
  AppProperty { id: keyEnable;  path: "app.traktor.decks." + (deckId+1) + ".track.key.lock_enabled" }
  AppProperty { id: keyDisplay; path: "app.traktor.decks." + (deckId+1) + ".track.key.resulting.precise" }
  

  property real key:    keyValue.value * 12
  property int  offset: (key.toFixed(2) - key.toFixed(0)) * 100.0
  property var keyColor: keyEnable.value && keyId.value >= 0 ? colors.musicalKeyColors[keyId.value] : colors.colorWhite

  //--------------------------------------------------------------------------------------------------------------------

  // headline
  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        customMargins.topMarginCenterOverlayHeadline
    font.pixelSize:           fonts.largeFontSize
    color:                    colors.colorCenterOverlayHeadline
    text:                     "KEY"
  }

  // button
  Rectangle {
    anchors.top:              parent.top
    anchors.left:             parent.left
    anchors.topMargin:        67
    anchors.leftMargin:       21
    width: 43
    height: 17
    color: (keyEnable.value) ? "white" : "black"
    radius: 1

    Text {
      anchors.centerIn: parent
      anchors.verticalCenterOffset: 1
      anchors.horizontalCenterOffset: -1
      font.pixelSize: fonts.smallFontSize     
      text: "LOCK"
      color: (keyEnable.value) ? colors.colorBlack : colors.colorGrey104
    }
  }

  // key
  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        55
    font.pixelSize:           fonts.moreLargeValueFontSize
    font.family   :           "Pragmatica"
    color:                    keylock.keyColor
    opacity:                  (keyDisplay.value == "") ? 0 : 1
    text: {
      return keyDisplay.value.replace(
        /\d+(d|m)/,
        function (match) {
          return keyText[match] || match;
        }
      );
    }
  }

  // value
  Text {
    anchors.top:              parent.top
    anchors.right:            parent.right
    anchors.topMargin:        67
    anchors.rightMargin:      20
    font.pixelSize:           fonts.largeFontSize
    font.family   :           "Pragmatica"
    font.capitalization: Font.AllUppercase
    color:                    colors.colorGrey104
    text:  ((key<0)?"":"+") + key.toFixed(2).toString()
  }
  
  // footline
  Text {
    anchors.bottom:           parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin:     14.0
    font.pixelSize:           fonts.smallFontSize
    color:                    colors.colorGrey104
    text:                     "Hold BACK to reset"
  }
  
}
