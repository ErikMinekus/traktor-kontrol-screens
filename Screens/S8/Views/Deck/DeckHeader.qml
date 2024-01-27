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

  // these variables can not be changed from outside
  readonly property int speed: 40  // Transition speed
  readonly property int smallHeaderHeight: 20
  readonly property int mediumHeaderHeight: 24
  readonly property int largeHeaderHeight: 40

  readonly property bool   isLoaded:    top_left_text.isLoaded
  readonly property int    deckType:    deckTypeProperty.value

  function hasTrackStyleHeader(deckType)      { return (deckType == DeckType.Track  || deckType == DeckType.Stem);  }

  // PROPERTY SELECTION
  // IMPORTANT: See 'stateMapping' in DeckHeaderText.qml for the correct Mapping from
  //            the state-enum in c++ to the corresponding state
  // NOTE: For now, we set fix states in the DeckHeader! But we wanna be able to
  //       change the states.
  property int topLeftState:      0                                 // headerSettingTopLeft.value
  property int topMiddleState:    hasTrackStyleHeader(deckType) ? 14 : 29 // headerSettingTopMid.value
  property int topRightState:     hasTrackStyleHeader(deckType) ? 17 : 30 // headerSettingTopRight.value

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
  
  AppProperty { id: deckHeaderWarningActive;       path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".active"; }
  AppProperty { id: deckHeaderWarningType;         path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".type";   }
  AppProperty { id: deckHeaderWarningShortMessage; path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".short";  }

  //--------------------------------------------------------------------------------------------------------------------
  //  UPDATE VIEW
  //--------------------------------------------------------------------------------------------------------------------

  Component.onCompleted:  { updateHeader(); }
  onHeaderStateChanged:   { updateHeader(); }
  onIsLoadedChanged:      { updateHeader(); }
  onDeckTypeChanged:      { updateHeader(); }

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
    height: 1
    color:  textColors[deck_Id]
    Behavior on width { NumberAnimation { duration: 0.5*speed } }
  }

  // top_left_text: TITEL
  DeckHeaderText {
    id: top_left_text
    deckId: deck_Id
    explicitName: ""
    maxTextWidth : 276 // (deckType == DeckType.Stem) ? 200 - stem_text.width : 200
    textState: topLeftState
    color:     textColors[deck_Id]
    elide:     Text.ElideRight
    font.pixelSize:     fonts.scale(13)
    anchors.top:        top_line.bottom
    anchors.left:       parent.left

    anchors.topMargin:  -1
    anchors.leftMargin: 3
    Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
  }

  // top_middle_text: REMAINING TIME
  DeckHeaderText {
    id: top_middle_text
    deckId: deck_Id
    explicitName: ""
    maxTextWidth : 50
    textState:  topMiddleState
    font.family: "Pragmatica" // is monospaced
    color:      textColors[deck_Id]
    elide:      Text.ElideRight
    font.pixelSize: fonts.scale(13)
    horizontalAlignment: Text.AlignRight
    anchors.top:          top_line.bottom
    anchors.left:         parent.left
    anchors.topMargin:    1
    anchors.leftMargin:   299
    Behavior on anchors.topMargin   { NumberAnimation { duration: speed } }
    Behavior on anchors.rightMargin { NumberAnimation { duration: speed } }
  }

  // top_right_text: BPM
  DeckHeaderText {
    id: top_right_text
    deckId: deck_Id
    explicitName: ""
    maxTextWidth :  80
    textState:  topRightState
    font.family: "Pragmatica" // is monospaced
    color:      textColors[deck_Id]
    elide:      Text.ElideRight
    font.pixelSize: fonts.scale(13)
    anchors.top:          top_line.bottom
    anchors.left:         parent.left
    anchors.topMargin:    1
    anchors.leftMargin:   393
    Behavior on anchors.rightMargin { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin   { NumberAnimation { duration: speed } }
  }

  MappingProperty { id: showBrowserOnTouch; path: "mapping.settings.show_browser_on_touch"; onValueChanged: { updateExplicitDeckHeaderNames() } }

  function updateExplicitDeckHeaderNames()
  {
    if (directThru.value) {
      top_left_text.explicitName      = "Direct Thru";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
    }
    else if (deckType == DeckType.Live) {
      top_left_text.explicitName      = "Live Input";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
    }
    else if ((deckType == DeckType.Track)  && !isLoaded) {
      top_left_text.explicitName      = "No Track Loaded";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
    }
    else if (deckType == DeckType.Stem && !isLoaded) {
      top_left_text.explicitName      = "No Stem Loaded";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
    }
    else if (deckType == DeckType.Remix && !isLoaded) {
      top_left_text.explicitName      = " ";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
    }
    else {
      // Switch off explicit naming!
      top_left_text.explicitName      = "";
      top_middle_text.explicitName    = "";
      top_right_text.explicitName     = "";
    }
  }


  //--------------------------------------------------------------------------------------------------------------------
  //  Phase Meter
  //--------------------------------------------------------------------------------------------------------------------

  Widgets.PhaseMeter {
    anchors.top: parent.top
    anchors.topMargin: 22
    anchors.left: parent.left
    anchors.leftMargin: 161 // (deck_header.width - phaseMeter.width) / 2
    opacity: (isLoaded && headerState == "large") ? 1 : 0
    deckId: deck_Id
    Behavior on opacity { NumberAnimation { duration: speed } }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Deck Letter (A, B, C or D)
  //--------------------------------------------------------------------------------------------------------------------

  // Deck Letter Small
  Text {
    id: deck_letter_small
    width:               10
    height:              width
    anchors.top:         top_line.bottom
    anchors.right:       parent.right
    anchors.topMargin:   -1
    anchors.rightMargin: 3
    text:                deckLetters[deck_Id]
    color:               textColors[deck_Id]
    font.pixelSize:      fonts.scale(13)
    font.family:         "Pragmatica MediumTT"
    opacity:             1
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  WARNING MESSAGES
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: warning_box
    anchors.top:        parent.top
    anchors.topMargin:  1
    anchors.right:      deck_letter_small.left
    anchors.rightMargin: 3
    anchors.left:       parent.left
    anchors.leftMargin: 3
    height:             17
    color:              colors.colorBlack
    visible:            deckHeaderWarningActive.value
    
    Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }

    Text {
      id: top_warning_text
      color:              isError ? colors.colorRed : colors.colorOrange
      font.pixelSize:     fonts.scale(13)

      text: deckHeaderWarningShortMessage.value

      anchors.top:        parent.top
      anchors.left:       parent.left
      anchors.topMargin:  -1
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
  //  STATES FOR THE DIFFERENT HEADER SIZES
  //--------------------------------------------------------------------------------------------------------------------

  state: headerState

  states: [
    State {
      name: "small";
      PropertyChanges { target: deck_header;        height: smallHeaderHeight }
    },
    State {
      name: "medium";
      PropertyChanges { target: deck_header;        height: mediumHeaderHeight }
    },
    State {
      name: "large"; //when: temporaryMouseArea.released
      PropertyChanges { target: deck_header;        height: largeHeaderHeight }
    }
  ]
}
