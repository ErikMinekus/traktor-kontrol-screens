import QtQuick 2.0
import Traktor.Gui 1.0 as Traktor
import Qt5Compat.GraphicalEffects
import CSI 1.0

import '../../../Defines' as Defines


// The hotcue can be used to show all different types of hotcues. Type switching is done by using the 'hotcue state'.
// The number shown in the hotcue can be set by using hotcueId.
Item {
  id : hotcue

  property bool   showHead:     true
  property bool   smallHead:    true 
  property color  hotcueColor:  "transparent" 
  property int    hotcueId:     0
  property int    hotcueLength: 0
  property int    topMargin:    6


  readonly property double borderWidth:       2
  readonly property bool   useAntialiasing:   true
  readonly property int    smallCueHeight:    hotcue.height + 3
  readonly property int    smallCueTopMargin: -8
  readonly property int    largeCueHeight:    hotcue.height 
  readonly property var    hotcueMarkerTypes: { 0: "hotcue", 1: "fadeIn", 2: "fadeOut", 3: "load", 4: "grid", 5: "loop" }
  readonly property string hotcueState:       ( exists.value && type.value != -1) ? hotcueMarkerTypes[type.value] : "off"
  
  AppProperty { id: type;   path: "app.traktor.decks." + (parent.deckId+1) + ".track.cue.hotcues." + hotcue.hotcueId + ".type"   }
  AppProperty { id: active; path: "app.traktor.decks." + (parent.deckId+1) + ".track.cue.hotcues." + hotcue.hotcueId + ".active" }
  AppProperty { id: exists; path: "app.traktor.decks." + (parent.deckId+1) + ".track.cue.hotcues." + hotcue.hotcueId + ".exists" }

  height:  parent.height
  clip:    false

  Defines.Colors { id: colors }
  Defines.Font   { id: fonts  }

  //--------------------------------------------------------------------------------------------------------------------
  // If the hotcue should only be represented as a single line, use 'flagpole'

  Rectangle {
    id: flagpole
    anchors.bottom:           parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    height:                   smallCueHeight - 2
    width:                    3
    border.width:             1
    border.color:             colors.colorBlack50
    color:                    hotcue.hotcueColor
    visible:                  !showHead && (smallHead == true)
  }

  //--------------------------------------------------------------------------------------------------------------------
  // cue loader loads the different kinds of hotcues depending on their type (-> states at end of file)

  Item {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    height:                   smallHead ? 32 : (parent.height)
    width:                    40
    clip:                     false
    visible:                  hotcue.showHead
    Loader { 
      id: cueLoader 
      anchors.fill: parent
      active:       true
      visible:      true
      clip:         false
    }
  }

  // GRID --------------------------------------------------------------------------------------------------------------

  Component {
    id: gridComponentSmall
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.topMargin:  hotcue.smallCueTopMargin
      anchors.leftMargin: -6

      antialiasing:       useAntialiasing

      color:              hotcue.hotcueColor
      border.width:       borderWidth
      border.color:       colors.colorBlack50

      points: [ Qt.point(0 , 8)
              , Qt.point(0 , 0)
              , Qt.point(10, 0) 
              , Qt.point(10, 8)
              , Qt.point(5 , 11)
              ]
      Text { 
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 3
        anchors.topMargin: -1
        color:              colors.colorBlack
        text:               hotcue.hotcueId
        font.pixelSize:     fonts.miniFontSize
      }
    }
  }

  Component {
    id: gridComponentLarge
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.leftMargin: -8
      anchors.topMargin:  -1
      antialiasing:       useAntialiasing

      color:              hotcue.hotcueColor
      border.width:       borderWidth
      border.color:       colors.colorBlack50
      points: [ Qt.point(0 , 10)
              , Qt.point(0 , 0)
              , Qt.point(13, 0)
              , Qt.point(13, 10)
              , Qt.point(6 , 14)
              ]
      Text { 
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 4
        color:              colors.colorBlack
        text:               hotcue.hotcueId
        font.pixelSize:     fonts.miniFontSize
      }
    }
  }

  // CUE ----------------------------------------------------------------------------------------------------------------

  Component {
    id: hotcueComponentSmall
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.topMargin:  hotcue.smallCueTopMargin
      anchors.leftMargin: -2
      antialiasing:       useAntialiasing

      color:              hotcue.hotcueColor
      border.width:       borderWidth
      border.color:       colors.colorBlack50
      points: [ Qt.point(0 , 0)
              , Qt.point(10, 0)
              , Qt.point(13, 4.5)
              , Qt.point(10, 9)
              , Qt.point(0 , 9)
              ]
      Text {
        anchors.top:        parent.top; 
        anchors.left:       parent.left; 
        anchors.leftMargin: 3
        anchors.topMargin:  -1
        color:              colors.colorBlack; 
        text:               hotcue.hotcueId; 
        font.pixelSize:     fonts.miniFontSize
      }
    }
  }

  Component {
    id: hotcueComponentLarge
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.leftMargin: -3
      anchors.topMargin:  -1
      antialiasing:       useAntialiasing

      color:              colors.colorDeckBlueBright 
      border.width:       borderWidth
      border.color:       colors.colorBlack50
      points: [ Qt.point(0 , 0)
              , Qt.point(12, 0)
              , Qt.point(15, 5.5)
              , Qt.point(12, 11)
              , Qt.point(0 , 11)
              ]
      Text {
        anchors.top:        parent.top;         
        anchors.left:       parent.left; 
        anchors.leftMargin: 4
        color:              colors.colorBlack; 
        text:               hotcue.hotcueId; 
        font.pixelSize:     fonts.miniFontSize
      }
    }
  }

  // FADE IN -----------------------------------------------------------------------------------------------------------

  Component {
    id: fadeInComponentSmall
    Traktor.Polygon {
      anchors.top:         cueLoader.top
      anchors.right:       cueLoader.right 
      anchors.topMargin:   hotcue.smallCueTopMargin
      anchors.rightMargin: -5
      antialiasing:        useAntialiasing

      color:               hotcue.hotcueColor   
      border.width:        borderWidth
      border.color:        colors.colorBlack50
      points: [ Qt.point(-0.4, 9)
              , Qt.point(3 , 0)
              , Qt.point(13, 0) 
              , Qt.point(13, 9)
              ]

      Text {
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.topMargin:  -1
        anchors.leftMargin: borderWidth + 5
        color:              colors.colorBlack 
        text:               hotcue.hotcueId; 
        font.pixelSize:     fonts.miniFontSize
      }
    }
  }

  Component {
    id: fadeInComponentLarge
    Traktor.Polygon {
      anchors.top:         cueLoader.top
      anchors.left:        cueLoader.horizontalCenter
      anchors.topMargin:   -1
      anchors.leftMargin:  -19
      antialiasing:        useAntialiasing

      color:               hotcue.hotcueColor   
      border.width:        borderWidth
      border.color:        colors.colorBlack50
      points: [ Qt.point(-0.4, 11)
              , Qt.point(5 , 0)
              , Qt.point(16, 0)
              , Qt.point(16, 11)
              ]

      Text {
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 8
        color:              colors.colorBlack
        text:               hotcue.hotcueId; 
        font.pixelSize:     fonts.miniFontSize
      }
    }
  }

  // FADE OUT ----------------------------------------------------------------------------------------------------------

  Component {
    id: fadeOutComponentSmall
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter 
      anchors.topMargin:  hotcue.smallCueTopMargin
      anchors.leftMargin: -2
      antialiasing:       useAntialiasing

      color:              hotcue.hotcueColor   
      border.width:       borderWidth
      border.color:       colors.colorBlack50
      points: [ Qt.point(0, 0)
              , Qt.point(10, 0)
              , Qt.point(13, 9)
              , Qt.point(0, 9)
              ]
      Text { 
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 3.5
        anchors.topMargin:  -1
        color:              colors.colorBlack; 
        text:               hotcue.hotcueId; 
        font.pixelSize:     fonts.miniFontSize
      }
    }
  }

  Component {
    id: fadeOutComponentLarge
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.leftMargin: -3
      anchors.topMargin:  -1
      antialiasing:       useAntialiasing

      color:              hotcue.hotcueColor   
      border.width:       borderWidth
      border.color:       colors.colorBlack50
      points: [ Qt.point(0, 0)
              , Qt.point(12, 0)
              , Qt.point(16, 11)
              , Qt.point(0, 11)
              ]
      Text { 
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 4
        color:              colors.colorBlack 
        text:               hotcue.hotcueId
        font.pixelSize:     fonts.miniFontSize
      }
    }
  }

  // LOAD --------------------------------------------------------------------------------------------------------------

  Component {
    id: loadComponentSmall
    Item {
      anchors.top:               cueLoader.top
      anchors.topMargin:         hotcue.smallCueTopMargin
      anchors.horizontalCenter:  cueLoader.horizontalCenter
      clip:               false

      // round head
      Rectangle {
        id: circle
        anchors.top:               parent.top
        anchors.horizontalCenter:  parent.horizontalCenter
        anchors.topMargin:         -1
        color:                     hotcue.hotcueColor
        width:                     13
        height:                    width
        radius:                    0.5*width
        border.width:              1
        border.color:              colors.colorBlack50

        Text {
          anchors.top:        parent.top
          anchors.left:       parent.left
          anchors.leftMargin: 3
          anchors.topMargin:  0
          color:              colors.colorBlack 
          text:               hotcue.hotcueId
          font.pixelSize:     fonts.miniFontSize
        }
      }

    }
  }

  Component {
    id: loadComponentLarge
    Item {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.leftMargin: -21 
      anchors.topMargin:  -2
      height:             cueLoader.height
      clip:               false

      // round head
      Rectangle {
        id: circle
        anchors.top:              parent.top
        anchors.topMargin:        -1
        anchors.horizontalCenter: parent.horizontalCenter
        color:                    hotcue.hotcueColor
        width:                    17
        height:                   width
        radius:                   0.5*width
        border.width:             borderWidth
        border.color:             colors.colorBlack50

        Text {
          anchors.top:        parent.top
          anchors.left:       parent.left
          anchors.leftMargin: 5
          anchors.topMargin:  2
          color:              colors.colorBlack
          text:               hotcue.hotcueId
          font.pixelSize:     fonts.miniFontSize
        }
      }
    }
  }

  // LOOP --------------------------------------------------------------------------------------------------------------

   Component {
      id: loopComponentSmall
    Item {
      clip:                     false
      anchors.top:              cueLoader.top
      anchors.topMargin:        hotcue.smallCueTopMargin
      anchors.left:             cueLoader.left
      Traktor.Polygon {
        anchors.top:        parent.top
        anchors.left:       parent.horizontalCenter
        anchors.leftMargin: -11
        antialiasing: true
        color:             hotcue.hotcueColor   
        border.width:       borderWidth
        border.color:       colors.colorBlack50
        points: [ Qt.point(0 , 9)
                , Qt.point(0 , 0)
                , Qt.point(10, 0)
                , Qt.point(10, 9)
                ]

        Text { 
          anchors.top:        parent.top
          anchors.left:       parent.left
          anchors.leftMargin: 3
          anchors.topMargin: -1
          color:              colors.colorBlack
          text:               hotcue.hotcueId
          font.pixelSize:     fonts.miniFontSize
        }
      }

      Traktor.Polygon {
        anchors.top:        parent.top
        anchors.left:       parent.horizontalCenter 
        anchors.leftMargin: hotcueLength -1
        // anchors.topMargin:  hotcue.topMargin
        antialiasing: useAntialiasing

        color:             hotcue.hotcueColor   
        border.width:       borderWidth
        border.color:       colors.colorBlack50
        points: [ Qt.point(0, 0)
                , Qt.point(10, 0)
                , Qt.point(10, 9)
                , Qt.point(0, 9)
                ]
      }
    }
  }

  Component {
    id: loopComponentLarge
    Item {
      anchors.top:          cueLoader.top
      anchors.left:         cueLoader.left
      anchors.topMargin:    -1
      anchors.leftMargin:   -1
      clip:                 false
      Traktor.Polygon {
        anchors.top:        parent.top
        anchors.left:       parent.horizontalCenter
        anchors.leftMargin: -15
        antialiasing:       true
        color:              hotcue.hotcueColor   
        border.width:       borderWidth 
        border.color:       colors.colorBlack50
  
        points: [ Qt.point(0 , 11)
                , Qt.point(0 , 0)
                , Qt.point(14, 0)
                , Qt.point(14, 11)
                ]

        Text { 
          anchors.top:        parent.top
          anchors.left:       parent.left
          anchors.leftMargin: 5
          color:             colors.colorBlack 
          text:              hotcue.hotcueId
          font.pixelSize:    fonts.miniFontSize
        }
      }

      Traktor.Polygon {
        anchors.top:        parent.top
        anchors.left:       parent.horizontalCenter 
        anchors.leftMargin: hotcueLength -1
        antialiasing:       useAntialiasing

        color:              hotcue.hotcueColor   
        border.width:       borderWidth
        border.color:       colors.colorBlack50
        points: [ Qt.point(0, 0)
                , Qt.point(14, 0)
                , Qt.point(14, 11)
                , Qt.point(0, 11)
                ]
      }
    }
  }

  //-------------------------------------------------------------------------------------------------------------------- 

  state: hotcueState
  states: [
    State {
      name: "off";
      PropertyChanges { target: hotcue;      visible:         false   }
    },
    State {
      name: "grid";
      PropertyChanges { target: hotcue;      hotcueColor:     colors.hotcue.grid   }
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? gridComponentSmall : gridComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
      name: "hotcue";
      PropertyChanges { target: hotcue;      hotcueColor:     colors.hotcue.hotcue } 
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? hotcueComponentSmall : hotcueComponentLarge  }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
      name: "fadeIn";
      PropertyChanges { target: hotcue;      hotcueColor:     colors.hotcue.fade } 
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? fadeInComponentSmall : fadeInComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
      name: "fadeOut";
      PropertyChanges { target: hotcue;      hotcueColor:     colors.hotcue.fade } 
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? fadeOutComponentSmall  : fadeOutComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
      name: "load";
      PropertyChanges { target: hotcue;      hotcueColor:     colors.hotcue.load } 
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? loadComponentSmall : loadComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
       name: "loop";
      PropertyChanges { target: hotcue;      hotcueColor:     colors.hotcue.loop } 
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? loopComponentSmall  : loopComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    } 
  ]       
}
