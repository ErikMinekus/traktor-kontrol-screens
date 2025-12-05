import CSI 1.0
import QtQuick 2.0

Item {
  id: screen

  property int side: ScreenSide.Left;

  property string settingsPath: ""
  property string propertiesPath: ""

  width:  128
  height: 64
  clip:   true

  MappingProperty { id: deckIdxProp; path: screen.propertiesPath + ".active_deck" }
  property alias deckIdx: deckIdxProp.value

  MappingProperty { id: channelModeProp; path: screen.propertiesPath + ".channel_mode." + deckIdx }
  property alias channel_mode: channelModeProp.value

  MappingProperty { id: lastTouchedKnobProp; path: screen.propertiesPath + ".last_active_knob" }
  property alias lastTouchedKnob: lastTouchedKnobProp.value

  MappingProperty { id: knobsAreActiveProp; path: screen.propertiesPath + ".knobs_are_active" }
  property alias knobsAreActive: knobsAreActiveProp.value

  MappingProperty { id: knobsSoftTakeoverDirectionProp; path: screen.propertiesPath + ".softtakeover." + lastTouchedKnob + ".direction" }
  property alias knobsSoftTakeoverDirection: knobsSoftTakeoverDirectionProp.value

  MappingProperty { id: faderSoftTakeoverDirectionProp; path: screen.propertiesPath + ".softtakeover.fader.direction" }
  property alias faderSoftTakeoverDirection: faderSoftTakeoverDirectionProp.value

  AppProperty { id: deckCue; path: "app.traktor.mixer.channels." + deckIdx + ".cue"  }
  AppProperty { id: deckVolume; path: "app.traktor.mixer.channels." + deckIdx + ".volume" }

  AppProperty { id: deckGain; path: "app.traktor.mixer.channels." + deckIdx + ".gain"    }
  AppProperty { id: deckHigh; path: "app.traktor.mixer.channels." + deckIdx + ".eq.high" }
  AppProperty { id: deckMid;  path: "app.traktor.mixer.channels." + deckIdx + ".eq.mid"  }
  AppProperty { id: deckLow;  path: "app.traktor.mixer.channels." + deckIdx + ".eq.low"  }

  AppProperty { id: deckChannelFxAmount;  path: "app.traktor.mixer.channels." + deckIdx + ".fx.adjust"  }

  AppProperty { id: stem1Volume; path: "app.traktor.decks." + deckIdx + ".stems.1.volume" }
  AppProperty { id: stem2Volume; path: "app.traktor.decks." + deckIdx + ".stems.2.volume" }
  AppProperty { id: stem3Volume; path: "app.traktor.decks." + deckIdx + ".stems.3.volume" }
  AppProperty { id: stem4Volume; path: "app.traktor.decks." + deckIdx + ".stems.4.volume" }

  function parameterName(knob)
  {
    if (knob == 5)
    {
      return "FX";
    }

    if (screen.channel_mode)
    {
      switch(knob)
      {
        case 1: return "DRUM";
        case 2: return "BASS";
        case 3: return "OTHR";
        case 4: return "VOCL";
      }
    }
    else
    {
      switch(knob)
      {
        case 1: return "GAIN";
        case 2: return "HIGH";
        case 3: return "MID";
        case 4: return "LOW";
      }
    }

    return "";
  }

  function parameterValue(knob)
  {
    if (knob == 5)
    {
      return Math.round((deckChannelFxAmount.value - 0.5) * 200);
    }

    if (screen.channel_mode)
    {
      switch(knob)
      {
        case 1: return Math.round(stem1Volume.value * 100);
        case 2: return Math.round(stem2Volume.value * 100);
        case 3: return Math.round(stem3Volume.value * 100);
        case 4: return Math.round(stem4Volume.value * 100);
      }
    }
    else
    {
      switch(knob)
      {
        case 1: return Math.round(deckGain.value * 100);
        case 2: return Math.round((deckHigh.value - 0.5) * 200);
        case 3: return Math.round((deckMid.value - 0.5) * 200);
        case 4: return Math.round((deckLow.value - 0.5) * 200);
      }
    }

    return "";
  }

  Rectangle {
    color: "black"
    anchors.fill: parent

    Item
    {
      anchors.fill: parent

      // Pre-listen
      Image {
        anchors {
            top: parent.top
            left: parent.left
        }

        source:    "Images/Indicator.png"
        fillMode:  Image.PreserveAspectFit
        visible: deckCue.value
      }

      Item {
        visible: !knobsAreActive
        anchors.fill: parent

        // Channel fader
        Item {
          anchors {
            bottom: parent.bottom
            left: parent.left
          }
          width: 95

          Image {
            anchors {
                bottom: parent.bottom
                left: parent.left
            }

            source:    "Images/Speaker.png"
            fillMode:  Image.PreserveAspectFit
          }

          AnimatedImage {
              anchors {
                  bottom: parent.bottom
                  right: volumeText.left
                  rightMargin: -10
                  bottomMargin: 3
              }

              visible:   faderSoftTakeoverDirection !== 0
              source:    faderSoftTakeoverDirection === 1 ? "Images/SoftTakeoverUp.gif" : "Images/SoftTakeoverDown.gif"
              fillMode:  Image.PreserveAspectFit
          }

          ThinText {
            id: volumeText
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: -3
                rightMargin: 16
              }
              //font.pixelSize: 24
              horizontalAlignment: Text.AlignRight
              font.capitalization: Font.AllUppercase
              text: " " + Math.round(deckVolume.value * 100)
          }
        }

        // EQ indicators
        Item {
          visible: screen.channel_mode == false
          anchors.fill: parent

          Item {
            anchors {
              bottom: parent.bottom
              right: parent.right
              rightMargin: 2
            }
            width: 12
            height: 55

            ThinText {
              anchors {
                  top: parent.top
                  right: parent.right
                }
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                text: "G"
            }

            Image {
              anchors {
                  bottom: parent.bottom
                  right: parent.right
              }

              source:    "Images/EQMeter_unipolar.png"
              fillMode:  Image.PreserveAspectFit

              // Gain level
              Rectangle
              {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                color: "white"
                height: Math.min(deckGain.value * parent.height, 41)
              }
            }
          }

          Item {
            anchors {
              bottom: parent.bottom
              right: parent.right
              rightMargin: 14
            }
            width: 12
            height: 55

            ThinText {
              anchors {
                  top: parent.top
                  right: parent.right
                }
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                text: "H"
            }

            Image {
              anchors {
                  bottom: parent.bottom
                  right: parent.right
              }

              source:    "Images/EQMeter_bipolar.png"
              fillMode:  Image.PreserveAspectFit

              // High level
              Rectangle
              {
                visible: deckHigh.value > 0.5

                anchors {
                    bottom: parent.verticalCenter
                    left: parent.left
                    right: parent.right
                }

                color: "white"
                height: Math.min((deckHigh.value - 0.5), 0.5) * 41
              }

              Rectangle
              {
                visible: deckHigh.value < 0.5

                anchors {
                    top: parent.verticalCenter
                    left: parent.left
                    right: parent.right
                }

                color: "white"
                height: Math.min((0.5 - deckHigh.value), 0.5) * 41
              }
            }
          }

          Item {
            anchors {
              bottom: parent.bottom
              right: parent.right
              rightMargin: 26
            }
            width: 12
            height: 55

            ThinText {
              anchors {
                  top: parent.top
                  right: parent.right
                }
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                text: "M"
            }

            Image {
              anchors {
                  bottom: parent.bottom
                  right: parent.right
              }

              source:    "Images/EQMeter_bipolar.png"
              fillMode:  Image.PreserveAspectFit

              // Mid level
              Rectangle
              {
                visible: deckMid.value > 0.5

                anchors {
                    bottom: parent.verticalCenter
                    left: parent.left
                    right: parent.right
                }

                color: "white"
                height: Math.min((deckMid.value - 0.5), 0.5) * 41
              }

              Rectangle
              {
                visible: deckMid.value < 0.5

                anchors {
                    top: parent.verticalCenter
                    left: parent.left
                    right: parent.right
                }

                color: "white"
                height: Math.min((0.5 - deckMid.value), 0.5) * 41
              }
            }
          }

          Item {
            anchors {
              bottom: parent.bottom
              right: parent.right
              rightMargin: 38
            }
            width: 12
            height: 55

            ThinText {
              anchors {
                  top: parent.top
                  right: parent.right
                }
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                text: "L"
            }

            Image {
              anchors {
                  bottom: parent.bottom
                  right: parent.right
              }

              source:    "Images/EQMeter_bipolar.png"
              fillMode:  Image.PreserveAspectFit

              // Low level
              Rectangle
              {
                visible: deckLow.value > 0.5

                anchors {
                    bottom: parent.verticalCenter
                    left: parent.left
                    right: parent.right
                }

                color: "white"
                height: Math.min((deckLow.value - 0.5), 0.5) * 41
              }

              Rectangle
              {
                visible: deckLow.value < 0.5

                anchors {
                    top: parent.verticalCenter
                    left: parent.left
                    right: parent.right
                }

                color: "white"
                height: Math.min((0.5 - deckLow.value), 0.5) * 41
              }
            }
          }
        }

        // Stem indicators
        Item {
          visible: screen.channel_mode == true
          anchors.fill: parent

          Item {
            anchors {
              bottom: parent.bottom
              right: parent.right
              bottomMargin: 2
            }
            width: 46
            height: 12

            ThinText {
              anchors {
                  bottom: parent.bottom
                  left: parent.left
                  bottomMargin: -2
                }
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                text: "V"
            }

            Image {
              anchors {
                  bottom: parent.bottom
                  right: parent.right
              }

              source:    "Images/StemMeter.png"
              fillMode:  Image.PreserveAspectFit

              // Vocal level
              Rectangle
              {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    top: parent.top
                }

                color: "white"
                width: Math.min(stem4Volume.value * parent.width, 36)
              }
            }
          }

          Item {
            anchors {
              bottom: parent.bottom
              right: parent.right
              bottomMargin: 14
            }
            width: 46
            height: 12

            ThinText {
              anchors {
                  bottom: parent.bottom
                  left: parent.left
                  bottomMargin: -2
                }
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                text: "O"
            }

            Image {
              anchors {
                  bottom: parent.bottom
                  right: parent.right
              }

              source:    "Images/StemMeter.png"
              fillMode:  Image.PreserveAspectFit

              // Other level
              Rectangle
              {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    top: parent.top
                }

                color: "white"
                width: Math.min(stem3Volume.value * parent.width, 36)
              }
            }
          }

          Item {
            anchors {
              bottom: parent.bottom
              right: parent.right
              bottomMargin: 26
            }
            width: 46
            height: 12

            ThinText {
              anchors {
                  bottom: parent.bottom
                  left: parent.left
                  bottomMargin: -2
                }
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                text: "B"
            }

            Image {
              anchors {
                  bottom: parent.bottom
                  right: parent.right
              }

              source:    "Images/StemMeter.png"
              fillMode:  Image.PreserveAspectFit

              // Bass level
              Rectangle
              {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    top: parent.top
                }

                color: "white"
                width: Math.min(stem2Volume.value * parent.width, 36)
              }
            }
          }

          Item {
            anchors {
              bottom: parent.bottom
              right: parent.right
              bottomMargin: 38
            }
            width: 46
            height: 12

            ThinText {
              anchors {
                  bottom: parent.bottom
                  left: parent.left
                  bottomMargin: -2
                }
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                text: "D"
            }

            Image {
              anchors {
                  bottom: parent.bottom
                  right: parent.right
              }

              source:    "Images/StemMeter.png"
              fillMode:  Image.PreserveAspectFit

              // Drums level
              Rectangle
              {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    top: parent.top
                }

                color: "white"
                width: Math.min(stem1Volume.value * parent.width, 36)
              }
            }
          }
        }
      }

      // Parameter overlay
      Item
      {
        visible: knobsAreActive
        anchors.fill: parent

        ThinText {
            anchors {
                bottom: parent.bottom
                left: parent.left
                leftMargin: -13
                bottomMargin: -5
            }
            font.capitalization: Font.AllUppercase
            text: " " + parameterName(lastTouchedKnob)
        }

        ThinText {
            id: valueText

            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: -5
                rightMargin: -3
            }
            font.capitalization: Font.AllUppercase
            text: " " + parameterValue(lastTouchedKnob)
        }

        AnimatedImage {
            anchors {
                bottom: parent.bottom
                right: valueText.left
                rightMargin: -10
            }
            visible:   knobsSoftTakeoverDirection !== 0
            source:    knobsSoftTakeoverDirection === 1 ? "Images/SoftTakeoverUp.gif" : "Images/SoftTakeoverDown.gif"
            fillMode:  Image.PreserveAspectFit
        }
      }
    }

  }
}
