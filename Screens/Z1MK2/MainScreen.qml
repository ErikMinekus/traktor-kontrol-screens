import CSI 1.0
import QtQuick 2.0

Item {
  id: screen

  // side is unused but needed for compatibility
  property int side: ScreenSide.Left

  property string settingsPath: ""
  property string propertiesPath: ""

  width:  128
  height: 64
  clip:   true

  MappingProperty { id: leftDeckIdxProp; path: screen.propertiesPath + ".left_deck_index" }
  property alias leftDeckIdx: leftDeckIdxProp.value

  MappingProperty { id: rightDeckIdxProp; path: screen.propertiesPath + ".right_deck_index" }
  property alias rightDeckIdx: rightDeckIdxProp.value

  AppProperty { id: deckAMixerFx; path: "app.traktor.mixer.channels.1.fx.select" }
  AppProperty { id: deckBMixerFx; path: "app.traktor.mixer.channels.2.fx.select" }
  AppProperty { id: deckCMixerFx; path: "app.traktor.mixer.channels.3.fx.select" }
  AppProperty { id: deckDMixerFx; path: "app.traktor.mixer.channels.4.fx.select" }
  readonly property variant decksMixerFx: [ deckAMixerFx.value, deckBMixerFx.value, deckCMixerFx.value, deckDMixerFx.value ]
  readonly property variant decksMixerFxNames: [ deckAMixerFx.description, deckBMixerFx.description, deckCMixerFx.description, deckDMixerFx.description ]

  AppProperty { id: masterLevelProp; path: "app.traktor.mixer.master.level.sum" }
  AppProperty { id: masterLevelClipProp; path: "app.traktor.mixer.master.level.clip.sum" }
  AppProperty { id: limiterStateProp; path: "app.traktor.mixer.master.limiter_state" }

  function deckImage(deckIdx)
  {
    switch(deckIdx)
    {
      case 1: return "A.png";
      case 2: return "B.png";
      case 3: return "C.png";
      case 4: return "D.png";
    }

    // Fallback
    return "A.png";
  }

  Rectangle {
    color: "black"
    anchors.fill: parent

    Item {
      anchors.fill: parent
      visible: true

      // Master level meter
      Item {
        anchors {
          top: parent.top
          left: parent.left
          right: parent.right
        }
        height: 20

        Image {
          anchors {
              top: parent.top
              left: parent.left
              topMargin: 10
              leftMargin: 10
          }
          source: "Images/MasterMeter.png"

          // Master level
          Rectangle
          {
            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }

            color: "white"
            width: Math.min(masterLevelProp.value * parent.width * 0.9, 86)
          }

          // Master clip
          Rectangle
          {
            visible: masterLevelClipProp.value != 0
            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
                leftMargin: 89
            }

            color: "white"
            width: 21
          }
        }

        // Limiter state
        Rectangle
        {
          visible: limiterStateProp.value != 0
          anchors {
              top: parent.top
              left: parent.left
              bottom: parent.bottom
              topMargin: 6
              leftMargin: 94
          }

          color: "white"
          width: 2
        }
      }

      // Left deck assignment
      Image {
          anchors {
              bottom: parent.bottom
              left: parent.left
          }
  
          source:    "Images/" + deckImage(leftDeckIdx)
          fillMode:  Image.PreserveAspectFit
      }

      // Channel FX
      Item {
        visible: decksMixerFx[leftDeckIdx - 1] != decksMixerFx[rightDeckIdx - 1]
        anchors.fill: parent

        ThinText {
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 30
                leftMargin: 40
            }
            font.pixelSize: 12
            horizontalAlignment: Text.AlignLeft
            font.capitalization: Font.AllUppercase
            text: " " + decksMixerFxNames[leftDeckIdx - 1]
        }

        ThinText {
            anchors {
                right: parent.right
                bottom: parent.bottom
                rightMargin: 40
                bottomMargin: 3
            }
            font.pixelSize: 12
            horizontalAlignment: Text.AlignRight
            font.capitalization: Font.AllUppercase
            text: " " + decksMixerFxNames[rightDeckIdx - 1]
        }
      }

      AnimatedImage {
          visible: decksMixerFx[leftDeckIdx - 1] == decksMixerFx[rightDeckIdx - 1]

          anchors {
              bottom: parent.bottom
              left: parent.left
              leftMargin: 42
          }
  
          source:    "Images/ChannelFX/" + decksMixerFxNames[leftDeckIdx - 1] + ".gif"
          fillMode:  Image.PreserveAspectFit
      }

      // Right deck assignment
      Image {
          anchors {
              bottom: parent.bottom
              right: parent.right
          }
  
          source:    "Images/" + deckImage(rightDeckIdx)
          fillMode:  Image.PreserveAspectFit
      }
    }
  }
}
