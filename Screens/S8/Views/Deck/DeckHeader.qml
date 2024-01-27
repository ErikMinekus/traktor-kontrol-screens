import CSI 1.0
import QtQuick 2.0
import Qt5Compat.GraphicalEffects

import '../Widgets' as Widgets

//--------------------------------------------------------------------------------------------------------------------
//  DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

Item {
  id: deck_header
  
  // QML-only deck types
  readonly property int thruDeckType:  4

  // Placeholder variables for properties that have to be set in the elements for completeness - but are actually set
  // in the states
  readonly property int    _intSetInState:    0

  // Here all the properties defining the content of the DeckHeader are listed. They are set in DeckView.
  property int    deck_Id:           0
  property string headerState:      "large" // this property is used to set the state of the header (large/small)
  
  readonly property variant deckLetters:        ["A",                         "B",                          "C",                  "D"                 ]
  readonly property variant textColors:         [colors.colorDeckBlueBright,  colors.colorDeckBlueBright,   colors.colorGrey232,  colors.colorGrey232 ]
  readonly property variant darkerTextColors:   [colors.colorDeckBlueDark,    colors.colorDeckBlueDark,     colors.colorGrey72,   colors.colorGrey72  ]

  readonly property variant loopText:           ["/32", "/16", "1/8", "1/4", "1/2", "1", "2", "4", "8", "16", "32"]

  // these variables can not be changed from outside
  readonly property int speed: 40  // Transition speed
  readonly property int smallHeaderHeight: 20
  readonly property int largeHeaderHeight: 40

  readonly property int rightMargin_middleText_large: 105
  readonly property int rightMargin_rightText_large:  44

  readonly property bool   isLoaded:    top_left_text.isLoaded
  readonly property int    deckType:    deckTypeProperty.value
  readonly property int    isInSync:    top_left_text.isInSync
  readonly property int    isMaster:    top_left_text.isMaster
  readonly property int    loopSizePos: headerPropertyLoopSize.value

  function hasTrackStyleHeader(deckType)      { return (deckType == DeckType.Track  || deckType == DeckType.Stem);  }

  // PROPERTY SELECTION
  // IMPORTANT: See 'stateMapping' in DeckHeaderText.qml for the correct Mapping from
  //            the state-enum in c++ to the corresponding state
  // NOTE: For now, we set fix states in the DeckHeader! But we wanna be able to
  //       change the states.
  property int topLeftState:      0                                 // headerSettingTopLeft.value
  property int topMiddleState:    hasTrackStyleHeader(deckType) ? 15 : 29 // headerSettingTopMid.value
  property int topRightState:     hasTrackStyleHeader(deckType) ? 17 : 30 // headerSettingTopRight.value

  property int bottomLeftState:   1                                 // headerSettingMidLeft.value

  height: largeHeaderHeight
  clip: false //true
  Behavior on height { NumberAnimation { duration: speed } }

  readonly property int warningTypeNone:    0
  readonly property int warningTypeWarning: 1
  readonly property int warningTypeError:   2

  property bool isError:   (deckHeaderWarningType.value == warningTypeError)
  

  //--------------------------------------------------------------------------------------------------------------------
  // Helper function
  function toInt(val) { return parseInt(val); }

  //--------------------------------------------------------------------------------------------------------------------
  //  DECK PROPERTIES
  //--------------------------------------------------------------------------------------------------------------------



  AppProperty { id: deckTypeProperty;           path: "app.traktor.decks." + (deck_Id+1) + ".type" }

  AppProperty { id: directThru;                 path: "app.traktor.decks." + (deck_Id+1) + ".direct_thru"; onValueChanged: { updateHeader() } }
  AppProperty { id: headerPropertyLoopActive;   path: "app.traktor.decks." + (deck_Id+1) + ".loop.active"; }
  AppProperty { id: headerPropertyLoopSize;     path: "app.traktor.decks." + (deck_Id+1) + ".loop.size"; }
  
  AppProperty { id: deckHeaderWarningActive;       path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".active"; }
  AppProperty { id: deckHeaderWarningType;         path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".type";   }
  AppProperty { id: deckHeaderWarningMessage;      path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".long";   }
  AppProperty { id: deckHeaderWarningShortMessage; path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".short";  }

  //--------------------------------------------------------------------------------------------------------------------
  //  STATE OF THE DECK HEADER LABELS
  //--------------------------------------------------------------------------------------------------------------------
  AppProperty { id: headerSettingTopLeft;       path: "app.traktor.settings.deckheader.top.left";  }  
  AppProperty { id: headerSettingTopMid;        path: "app.traktor.settings.deckheader.top.mid";   }  
  AppProperty { id: headerSettingTopRight;      path: "app.traktor.settings.deckheader.top.right"; }
  AppProperty { id: headerSettingMidLeft;       path: "app.traktor.settings.deckheader.mid.left";  }  
  AppProperty { id: headerSettingMidMid;        path: "app.traktor.settings.deckheader.mid.mid";   }  
  AppProperty { id: headerSettingMidRight;      path: "app.traktor.settings.deckheader.mid.right"; }

  AppProperty { id: propKeylock;                path: "app.traktor.decks." + (deck_Id+1) + ".track.key.lock_enabled" }
  AppProperty { id: propTrackLength;            path: "app.traktor.decks." + (deck_Id+1) + ".track.content.track_length"; }
  AppProperty { id: propElapsedTime;            path: "app.traktor.decks." + (deck_Id+1) + ".track.player.elapsed_time"; }
  AppProperty { id: propMixerBpm;               path: "app.traktor.decks." + (deck_Id+1) + ".tempo.base_bpm" }
  AppProperty { id: propTempo;                  path: "app.traktor.decks." + (deck_Id+1) + ".tempo.tempo_for_display" }
  AppProperty { id: propQuant;                  path: "app.traktor.quant" }
  AppProperty { id: propSnap;                   path: "app.traktor.snap" }

  //--------------------------------------------------------------------------------------------------------------------
  //  UPDATE VIEW
  //--------------------------------------------------------------------------------------------------------------------

  Component.onCompleted:  { updateHeader(); }
  onHeaderStateChanged:   { updateHeader(); }
  onIsLoadedChanged:      { updateHeader(); }
  onDeckTypeChanged:      { updateHeader(); }
  onIsMasterChanged:      { updateHeader(); }

  function updateHeader() {
    updateExplicitDeckHeaderNames();
  }


  
  //--------------------------------------------------------------------------------------------------------------------
  //  DECK HEADER TEXT
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id:top_line;
    anchors.horizontalCenter: parent.horizontalCenter
    width:  deck_header.width // (headerState == "small") ? deck_header.width-18 : deck_header.width
    height: 40
    color:  colors.colorFxHeaderBg
    Behavior on width { NumberAnimation { duration: 0.5*speed } }
  }

  // top_left_text: TITEL
  DeckHeaderText {
    id: top_left_text
    deckId: deck_Id
    explicitName: ""
    maxTextWidth : 275 // (deckType == DeckType.Stem) ? 200 - stem_text.width : 200
    textState: topLeftState
    color:     colors.colorGrey232
    elide:     Text.ElideRight
    font.pixelSize:     fonts.middleFontSize
    anchors.top:        top_line.top
    anchors.left:       deck_letter_large.right

    anchors.topMargin:  2
    anchors.leftMargin: 5
    Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
  }
  
  // bottom_left_text: ARTIST
  DeckHeaderText {
    id: bottom_left_text
    deckId: deck_Id
    explicitName: ""
    maxTextWidth : 275 // directThru.value ? 1000 : 200
    textState:  bottomLeftState
    color:      colors.colorGrey72
    elide:      Text.ElideRight
    font.pixelSize:     fonts.smallFontSize
    anchors.top:        top_line.top
    anchors.left:       deck_letter_large.right
    anchors.topMargin:  20
    anchors.leftMargin: 5
    Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
  }

  // top_middle_text: REMAINING TIME
  DeckHeaderText {
    id: top_middle_text
    deckId: deck_Id
    explicitName: ""
    maxTextWidth : 80
    textState:  topMiddleState
    font.family: "Pragmatica" // is monospaced
    color:      colors.colorGrey232
    elide:      Text.ElideRight
    font.pixelSize: fonts.largeFontSize
    horizontalAlignment: Text.AlignRight
    anchors.top:          top_line.top
    anchors.right:        parent.right
    anchors.topMargin:    11
    anchors.rightMargin:  rightMargin_middleText_large // set by 'state'
    Behavior on anchors.topMargin   { NumberAnimation { duration: speed } }
    Behavior on anchors.rightMargin { NumberAnimation { duration: speed } }
  }

  // top_right_text: BPM
  DeckHeaderText {
    id: top_right_text
    deckId: deck_Id
    explicitName: ""
    maxTextWidth :  50
    textState:  topRightState
    font.family: "Pragmatica" // is monospaced
    color:      colors.colorGrey232
    elide:      Text.ElideRight
    font.pixelSize: fonts.largeFontSize
    horizontalAlignment: Text.AlignHCenter
    anchors.top:          top_line.top
    anchors.right:        parent.right
    anchors.topMargin:    11
    anchors.rightMargin:  rightMargin_rightText_large // set by 'state'
    Behavior on anchors.rightMargin { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin   { NumberAnimation { duration: speed } }
  }

  MappingProperty { id: showBrowserOnTouch; path: "mapping.settings.show_browser_on_touch"; onValueChanged: { updateExplicitDeckHeaderNames() } }

  function updateExplicitDeckHeaderNames()
  {
    if (directThru.value) {
      top_left_text.explicitName      = "Direct Thru";
      bottom_left_text.explicitName   = "The Mixer Channel is currently In Thru mode";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
    }
    else if (deckType == DeckType.Live) {
      top_left_text.explicitName      = "Live Input";
      bottom_left_text.explicitName   = "Traktor Audio Passthru";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
    }
    else if ((deckType == DeckType.Track)  && !isLoaded) {
      top_left_text.explicitName      = "No Track Loaded";
      bottom_left_text.explicitName   = showBrowserOnTouch.value ? "Touch Browse Knob" : "Push Browse Knob";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
    }
    else if (deckType == DeckType.Stem && !isLoaded) {
      top_left_text.explicitName      = "No Stem Loaded";
      bottom_left_text.explicitName   = showBrowserOnTouch.value ? "Touch Browse Knob" : "Push Browse Knob";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
    }
    else if (deckType == DeckType.Remix && !isLoaded) {
      top_left_text.explicitName      = " ";
      // Force the the following DeckHeaderText to be empty
      bottom_left_text.explicitName   = " ";
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
    }
    else {
      // Switch off explicit naming!
      top_left_text.explicitName      = "";
      bottom_left_text.explicitName   = "";
      top_middle_text.explicitName    = "";
      top_right_text.explicitName     = "";
    }
  }


  //--------------------------------------------------------------------------------------------------------------------
  //  Phase Meter
  //--------------------------------------------------------------------------------------------------------------------

  Widgets.PhaseMeter {
    anchors.top: parent.top
    anchors.topMargin: 50
    anchors.left: parent.left
    anchors.leftMargin: 165 // (deck_header.width - phaseMeter.width) / 2
    opacity: (isLoaded && headerState != "small" && hasTrackStyleHeader(deckType)) ? 1 : 0
    deckId: deck_Id
    Behavior on opacity { NumberAnimation { duration: speed } }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Deck Letter (A, B, C or D)
  //--------------------------------------------------------------------------------------------------------------------

  Image {
    id: deck_letter_large
    anchors.top: top_line.top
    anchors.left: parent.left
    anchors.topMargin: 1
    anchors.leftMargin: 6
    width: 28
    height: 36
    visible: false
    clip: true
    fillMode: Image.Stretch
    source: "../Images/Deck_" + deckLetters[deck_Id] + ".png"
    Behavior on height { NumberAnimation { duration: speed } }
    Behavior on opacity { NumberAnimation { duration: speed } }
  }

  ColorOverlay {
    id: deck_letter_color_overlay
    color: textColors[deck_Id]
    anchors.fill: deck_letter_large
    source: deck_letter_large
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  WARNING MESSAGES
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: warning_box
    anchors.top:        parent.top
    anchors.right:      top_middle_text.left
    anchors.left:       deck_letter_large.right
    anchors.leftMargin: 5
    height:             40
    color:              colors.colorFxHeaderBg
    visible:            deckHeaderWarningActive.value
    
    Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }

    Text {
      id: top_warning_text
      color:              isError ? colors.colorRed : colors.colorOrange
      font.pixelSize:     fonts.middleFontSize

      text: deckHeaderWarningShortMessage.value

      anchors.top:        parent.top
      anchors.left:       parent.left
      anchors.topMargin:  2
      Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
      Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    Text {
      id: bottom_warning_text
      color:      isError ? colors.colorRed : colors.colorOrangeDimmed
      elide:      Text.ElideRight
      font.pixelSize:     fonts.smallFontSize

      text: deckHeaderWarningMessage.value


      anchors.top:        parent.top
      anchors.left:       parent.left
      anchors.topMargin:  20
      Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
      Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }
  }

  Timer {
    id: warningTimer
    interval: 1200
    repeat: true
    running: deckHeaderWarningActive.value
    onTriggered: {
      if (warning_box.opacity == 1) {
        warning_box.opacity = 0;
      } else {
        warning_box.opacity = 1;
      }
    }
  }



  //--------------------------------------------------------------------------------------------------------------------
  //  Key Lock
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    anchors.top:   parent.top
    anchors.topMargin:   10
    anchors.right: parent.right
    anchors.rightMargin: 10
    width:         20
    height:        width
    radius:        4
    color:         (propKeylock.value ? colors.colorGreenActive : colors.colorGreyInactive)
    visible:       isLoaded

    Text {
      anchors.fill:        parent
      anchors.topMargin:   2
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment:   Text.AlignVCenter
      text:  "♩"
      font.pixelSize: fonts.scale(14)
      color: "black"
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Quantize / Snap
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    anchors.top:   parent.top
    anchors.topMargin:  50
    anchors.left:  parent.left
    anchors.leftMargin: 10
    width:         82
    height:        20
    radius:        4
    color:         (propQuant.value ? colors.colorGreenActive : colors.colorGreyInactive)
    opacity:       (isLoaded && headerState != "small" && hasTrackStyleHeader(deckType)) ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: speed } }

    Text {
      anchors.fill:        parent
      anchors.topMargin:   1
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment:   Text.AlignVCenter
      text:  "QUANTIZE"
      font.pixelSize: fonts.smallFontSize
      color: "black"
    }
  }

  Rectangle {
    anchors.top:   parent.top
    anchors.topMargin:  50
    anchors.left:  parent.left
    anchors.leftMargin: 102
    width:         52
    height:        20
    radius:        4
    color:         (propSnap.value ? colors.colorGreenActive : colors.colorGreyInactive)
    opacity:       (isLoaded && headerState != "small" && hasTrackStyleHeader(deckType)) ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: speed } }

    Text {
      anchors.fill:        parent
      anchors.topMargin:   1
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment:   Text.AlignVCenter
      text:  "SNAP"
      font.pixelSize: fonts.smallFontSize
      color: "black"
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  BPM
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    anchors.top:   parent.top
    anchors.topMargin:   55
    anchors.right: parent.right
    anchors.rightMargin: 8
    width:         90
    height:        20
    color:         "transparent"
    opacity:       (isLoaded && headerState != "small" && hasTrackStyleHeader(deckType)) ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: speed } }

    // Decimal Value
    Text {
      id: bpm_anchor
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      color: colors.colorGrey72
      font.pixelSize: fonts.scale(27)
      font.family: "Pragmatica"

      text: {
        var bpm = propMixerBpm.value * propTempo.value;
        var dec = Math.round((bpm % 1) * 100);
        if (dec == 100) dec = 0;

        var decStr = dec.toString();
        if (dec < 10) decStr = "0" + decStr;

        return decStr;
      }
    }
    // Whole Number Value
    Text {
      anchors.bottom: parent.bottom
      anchors.right: bpm_anchor.left
      anchors.rightMargin:  1
      color: colors.colorGrey232
      font.pixelSize: fonts.scale(30)
      font.family: "Pragmatica"

      text: {
        return Math.floor((propMixerBpm.value * propTempo.value).toFixed(2)).toString();
      }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Loop Size
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    anchors.top:   parent.top
    anchors.topMargin:  79
    anchors.left:  parent.left
    anchors.leftMargin: 10
    width:         82
    height:        20
    color:         "transparent"
    clip:          true
    opacity:       (isLoaded && headerState != "small" && hasTrackStyleHeader(deckType)) ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: speed } }

    Image {
      id: loop_arrow
      anchors.top: parent.top
      anchors.topMargin: -11
      anchors.left: parent.left
      anchors.leftMargin: -4
      width: 42
      height: 42
      source: "./../Images/LoopArrow_Icon.svg"
      visible: false
    }
    ColorOverlay {
      color: (headerPropertyLoopActive.value ? colors.colorGreenActive : colors.colorGrey72)
      anchors.fill: loop_arrow
      source: loop_arrow
    }
    Text {
      anchors.top: parent.top
      anchors.topMargin: -1
      anchors.right: parent.right
      width: 50
      color: (headerPropertyLoopActive.value ? colors.colorGrey232 : colors.colorGrey72)
      font.pixelSize: fonts.scale(24)
      font.family: "Pragmatica"
      horizontalAlignment: Text.AlignHCenter
      text: loopText[loopSizePos]
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Remaining Time
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    anchors.top:   parent.top
    anchors.topMargin:   85
    anchors.left: parent.left
    anchors.leftMargin: 157
    width:         148
    height:        20
    color:         "transparent"
    opacity:       (isLoaded && headerState != "small" && hasTrackStyleHeader(deckType)) ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: speed } }

    // Decimal Value
    Text {
      id: time_anchor
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      color: colors.colorGrey72
      font.pixelSize: fonts.scale(27)
      font.family: "Pragmatica"

      text: {
        var seconds = propTrackLength.value - propElapsedTime.value;
        if (seconds < 0) seconds = 0;

        var ms = Math.floor((seconds % 1) * 10);

        return "." + ms.toString();
      }
    }
    // Whole Number Value
    Text {
      anchors.bottom: parent.bottom
      anchors.right: time_anchor.left
      color: colors.colorGrey232
      font.pixelSize: fonts.scale(30)
      font.family: "Pragmatica"

      text: {
        var seconds = propTrackLength.value - propElapsedTime.value;
        if (seconds < 0) seconds = 0;

        var sec = Math.floor(seconds % 60);
        var min = (Math.floor(seconds) - sec) / 60;

        var secStr = sec.toString();
        if (sec < 10) secStr = "0" + secStr;

        var minStr = min.toString();
        if (min < 10) minStr = "0" + minStr;

        return "- " + minStr + ":" + secStr;
      }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Tempo
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    anchors.top:   parent.top
    anchors.topMargin:   81
    anchors.right: parent.right
    anchors.rightMargin: 10
    width:         88
    height:        20
    color:         "transparent"
    opacity:       (isLoaded && headerState != "small" && hasTrackStyleHeader(deckType)) ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: speed } }

    Text {
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.rightMargin: 4
      color: colors.colorGrey72
      font.pixelSize: fonts.scale(20)
      font.family: "Pragmatica"

      text: {
        var tempo = propTempo.value - 1;
        return ((tempo <= 0) ? "" : "+") + (tempo * 100).toFixed(1).toString() + "%";
      }
    }
  }

}
