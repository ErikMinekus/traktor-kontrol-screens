import CSI 1.0
import QtQuick 2.0
import Qt5Compat.GraphicalEffects

import '../../../../Defines'
import '../Waveform' as WF
import '../Widgets' as Widgets

Item {
  id: trackDeck
  property int    deckId:          0
  property string deckSizeState:   "large"
  property color  deckColor:       colors.colorBgEmpty // transparent blue not possible for logo due to low bit depth of displays. was: // (deckId < 2) ? colors.colorDeckBlueBright12Full : colors.colorBgEmpty
  property bool   trackIsLoaded:   (primaryKey.value > 0)
  
  readonly property int waveformHeight: (deckSizeState == "small") ? 0 : ( parent ? ( (deckSizeState == "medium") ? 0 : (parent.height-113) ) : 0 )

  property bool showLoopSize: false
  property int  zoomLevel:    1
  property bool isInEditMode: false
  property int    stemStyle:    StemStyle.track
  property string propertiesPath: ""

  readonly property int minSampleWidth: 0x800
  readonly property int sampleWidth: minSampleWidth << zoomLevel


  //--------------------------------------------------------------------------------------------------------------------

  AppProperty   { id: deckType;          path: "app.traktor.decks." + (deckId + 1) + ".type"                    }
  AppProperty   { id: primaryKey;        path: "app.traktor.decks." + (deckId + 1) + ".track.content.entry_key" }

  //--------------------------------------------------------------------------------------------------------------------
  // Waveform
  //--------------------------------------------------------------------------------------------------------------------

  WF.WaveformContainer {
    id: waveformContainer

    deckId:         trackDeck.deckId
    deckSizeState:  trackDeck.deckSizeState
    sampleWidth:    trackDeck.sampleWidth
    propertiesPath: trackDeck.propertiesPath

    anchors.top:          parent.top
    anchors.left:         parent.left
    anchors.right:        parent.right
    showLoopSize:         trackDeck.showLoopSize
    isInEditMode:         trackDeck.isInEditMode
    stemStyle:            trackDeck.stemStyle

    anchors.topMargin:    70

    // the height of the waveform is defined as the remaining space of deckHeight - stripe.height - spacerWaveStripe.height
    height:  waveformHeight              
    visible: (trackIsLoaded && deckSizeState == "large") ? 1 : 0

    Behavior on height { PropertyAnimation { duration: durations.deckTransition } }
  }
  

  //--------------------------------------------------------------------------------------------------------------------
  // Stripe
  //--------------------------------------------------------------------------------------------------------------------

  Widgets.HotcueRow {
    anchors.left:   trackDeck.left
    anchors.bottom: stripe.top
    anchors.bottomMargin: 10
    opacity:        (trackDeck.trackIsLoaded && deckSizeState == "medium") ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: durations.deckTransition } }
  }

  //--------------------------------------------------------------------------------------------------------------------

  WF.Stripe {
    id: stripe

    readonly property int largeDeckBottomMargin: (waveformContainer.isStemStyleDeck) ? 6 : 12
    
    readonly property int smallDeckBottomMargin: (deckId > 1) ? 9 : 6

    anchors.left:           trackDeck.left
    anchors.right:          trackDeck.right
    anchors.bottom:         trackDeck.bottom
    anchors.bottomMargin:   5 // (deckSizeState == "large") ? largeDeckBottomMargin : smallDeckBottomMargin
    anchors.leftMargin:     9
    anchors.rightMargin:    9
    height:                 28
    opacity:                trackDeck.trackIsLoaded ? 1 : 0

    deckId:                 trackDeck.deckId
    windowSampleWidth:      trackDeck.sampleWidth

    audioStreamKey: deckTypeValid(deckType.value) ? ["PrimaryKey", primaryKey.value] : ["PrimaryKey", 0]

    function deckTypeValid(deckType)      { return (deckType == DeckType.Track || deckType == DeckType.Stem);  }

    Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Empty Deck
  //--------------------------------------------------------------------------------------------------------------------

  // Image (Logo) for empty Track Deck  --------------------------------------------------------------------------------

  Image {
    id: emptyTrackDeckImage
    anchors.fill:         parent
    anchors.bottomMargin: 18
    anchors.topMargin:    5
    visible:              false // visibility is handled through the emptyTrackDeckImageColorOverlay
    source:               "../../../Images/EmptyDeck.png"
    fillMode:             Image.PreserveAspectFit
  }

  // Deck color for empty deck image  ----------------------------------------------------------------------------------

  ColorOverlay {
    id: emptyTrackDeckImageColorOverlay
    anchors.fill: emptyTrackDeckImage
    color:        deckColor
    visible:      (!trackIsLoaded && deckSizeState != "small")
    source:       emptyTrackDeckImage
  }

}
