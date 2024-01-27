import CSI 1.0
import QtQuick 2.0
import Qt5Compat.GraphicalEffects

import '../Widgets' as Widgets

//------------------------------------------------------------------------------------------------------------------
//  LIST ITEM - DEFINES THE INFORMATION CONTAINED IN ONE LIST ITEM
//------------------------------------------------------------------------------------------------------------------

// the model contains the following roles:
//  dataType, nodeIconId, nodeName, coverUrl, artistName, trackName, bpm, key, keyIndex, rating, loadedInDeck, prevPlayed, prelisten

Item {
  id: contactDelegate

  property int           screenFocus:           0
  property color         deckColor :            qmlBrowser.focusColor
  property color         textColor :            ListView.isCurrentItem ? deckColor : colors.colorFontsListBrowser
  property bool          isCurrentItem :        ListView.isCurrentItem
  property string        prepIconColorPostfix:  (screenFocus < 2 && ListView.isCurrentItem) ? "Blue" : ((screenFocus > 1 && ListView.isCurrentItem) ? "White" : "Grey")
  readonly property int  textTopMargin:         7 // centers text vertically
  readonly property bool isLoaded:              (model.dataType == BrowserDataType.Track) ? model.loadedInDeck.length > 0 : false
  // visible: !ListView.isCurrentItem
  readonly property variant keyText:            ["8B", "3B", "10B", "5B", "12B", "7B", "2B", "9B", "4B", "11B", "6B", "1B",
                                                 "5A", "12A", "7A", "2A", "9A", "4A", "11A", "6A", "1A", "8A", "3A", "10A"]

  height: 33
  anchors.left: parent.left
  anchors.right: parent.right

  // container for zebra & track infos
  Rectangle {
    // when changing colors here please remember to change it in the GridView in Templates/Browser.qml 
    color:  (index%2 == 0) ? colors.colorGrey08 : "transparent" 
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: 3
    anchors.rightMargin: 3
    height: parent.height  

    // track name, toggles with folder name
    Rectangle {
      id: firstFieldTrack
      anchors.left: parent.left //listImage.right
      anchors.top: parent.top
      anchors.topMargin: contactDelegate.textTopMargin
      anchors.leftMargin: 37
      width: 190
      visible: (model.dataType == BrowserDataType.Track)

      //! Dummy text to measure maximum text lenght dynamically and adjust icons behind it.
      Text {
        id: textLengthDummy
        visible: false
        font.pixelSize: fonts.middleFontSize
        text: (model.dataType == BrowserDataType.Track) ? model.trackName  : ( (model.dataType == BrowserDataType.Folder) ? model.nodeName : "")
      }

      Text {
        id: firstFieldText
        width: (textLengthDummy.width) > 175 ? 175 : textLengthDummy.width
        // visible: false
        elide: Text.ElideRight
        text: textLengthDummy.text
        font.pixelSize: fonts.middleFontSize
        color: textColor
      }

      Image {
        id: prepListIcon
        visible: (model.dataType == BrowserDataType.Track) ? model.prepared : false
        source: "./../Images/PrepListIcon" + prepIconColorPostfix + ".png"
        width: sourceSize.width
        height: sourceSize.height
        anchors.left: firstFieldText.right 
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.leftMargin: 5
      }
    }   

    // folder name
    Text {
      id: firstFieldFolder
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.topMargin: contactDelegate.textTopMargin
      anchors.leftMargin: 37
      color: textColor
      clip: true
      text: (model.dataType == BrowserDataType.Folder) ? model.nodeName : ""
      font.pixelSize: fonts.middleFontSize
      elide: Text.ElideRight
      visible: (model.dataType != BrowserDataType.Track)
    }
    

    // artist name
    Text {
      id: trackTitleField
      anchors.leftMargin: 9
      anchors.left: (model.dataType == BrowserDataType.Track) ? firstFieldTrack.right : firstFieldFolder.right
      anchors.top: parent.top
      anchors.topMargin: contactDelegate.textTopMargin
      width: 130
      color: textColor
      clip: true
      text: (model.dataType == BrowserDataType.Track) ? model.artistName: ""
      font.pixelSize: fonts.middleFontSize
      elide: Text.ElideRight
    }  

    // bpm
    Text {
      id: bpmField
      anchors.left: trackTitleField.right    
      anchors.top: parent.top
      anchors.topMargin: contactDelegate.textTopMargin
      horizontalAlignment: Text.AlignRight
      width: 36
      color: textColor
      clip: true
      text: (model.dataType == BrowserDataType.Track) ? model.bpm.toFixed(0) : ""
      font.pixelSize: fonts.middleFontSize
    }  

    function colorForKey(keyIndex) {
      return colors.musicalKeyColors[keyIndex]
    }

    // key
    Text {
      id: keyField
      anchors.left: bpmField.right
      anchors.top: parent.top
      anchors.topMargin: contactDelegate.textTopMargin
      horizontalAlignment: Text.AlignRight

      color: (model.dataType == BrowserDataType.Track) ? (((model.key == "none") || (model.key == "None")) ? textColor : parent.colorForKey(model.keyIndex)) : textColor
      width: 36
      clip: true
      text: (model.dataType == BrowserDataType.Track) ? (((model.key == "none") || (model.key == "None")) ? "n.a." : keyText[model.keyIndex]) : ""
      font.pixelSize: fonts.middleFontSize
    }

    // track rating
    Widgets.TrackRating {
      id: ratingField
      visible:     (model.dataType == BrowserDataType.Track)
      rating:      (model.dataType == BrowserDataType.Track) ? ((model.rating == "") ? 0 : model.rating ) : 0
      // rating:      ((model.dataType == BrowserDataType.Track) && (model.rating != "")) ? ratingMap[model.rating] : 0
      anchors.right: parent.right
      anchors.rightMargin: 2
      anchors.verticalCenter: parent.verticalCenter
      height: 13
      width: 20
      bigLineColor:   contactDelegate.isCurrentItem ? ((contactDelegate.screenFocus < 2) ? colors.colorDeckBlueBright       : colors.colorWhite )    : colors.colorGrey64
      smallLineColor: contactDelegate.isCurrentItem ? ((contactDelegate.screenFocus < 2) ? colors.colorDeckBlueBright50Full : colors.colorGrey128 )  : colors.colorGrey32
    }

    
    ListHighlight {
      anchors.fill: parent
      visible: contactDelegate.isCurrentItem
      anchors.leftMargin: (model.dataType == BrowserDataType.Track) ? 34 : 0
      anchors.rightMargin: 0 
    }
  }

  Rectangle {
    id: trackImage 
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: 3              
    width: 33
    height: 33
    color: (model.coverUrl != "") ? "transparent" : ((contactDelegate.screenFocus < 2) ? colors.colorDeckBlueBright50Full : colors.colorGrey128 )
    visible: (model.dataType == BrowserDataType.Track)

    Image {
      id: cover
      anchors.fill: parent
      source: (model.dataType == BrowserDataType.Track) ? ("image://covers/" + model.coverUrl ) : ""
      fillMode: Image.PreserveAspectFit
      clip: true
      cache: false
      sourceSize.width: width
      sourceSize.height: height
      // the image either provides the cover of the track, or if not available the traktor logo on colored background ( opacity == 0.3)
      opacity: (model.coverUrl != "") ? 1.0 : 0.3
    }

    // darkens unselected covers
    Rectangle {
      id: darkener
      anchors.fill: parent
      color: {
          if (model.prelisten)
          {
            return colors.browser.prelisten;
          }
          else
          {
            if (model.prevPlayed)
            {
              return colors.colorBlack88;
            }
            else if (!isCurrentItem)
            {
              return colors.colorBlack81;
            }
            else if (isCurrentItem)
            {
              return "transparent";
            }
            else
            {
              return colors.colorBlack60;
            }
          }
        }
      }

    Rectangle {
      id: cover_border
      anchors.fill: trackImage
      color: "transparent"
      border.width: 1
      border.color: isCurrentItem ? colors.colorWhite16 : colors.colorGrey16 // semi-transparent border on artwork
      visible: (model.coverUrl != "")
    }

    Image {
      anchors.centerIn: trackImage
      width: 17
      height: 17
      source: "../Images/PreviewIcon_Big.png"
      fillMode: Image.Pad
      clip: true
      cache: false
      sourceSize.width: width
      sourceSize.height: height
      visible: (model.dataType == BrowserDataType.Track) ? model.prelisten : false
    }

    Image {
      anchors.centerIn: trackImage
      width: 17
      height: 17
      source: "../Images/PreviouslyPlayed_Icon.png"
      fillMode: Image.Pad
      clip: true
      cache: false
      sourceSize.width: width
      sourceSize.height: height
      visible: (model.dataType == BrowserDataType.Track) ? (model.prevPlayed && !model.prelisten) : false
    }
    
    Image {
      id: loadedDeckA
      source: "../Images/LoadedDeckA.png"
      anchors.top: parent.top
      anchors.left: parent.left
      sourceSize.width: 11
      sourceSize.height: 11
      visible: (model.dataType == BrowserDataType.Track && parent.isLoadedInDeck("A"))
    }

    Image {
      id: loadedDeckB
      source: "../Images/LoadedDeckB.png"
      anchors.top: parent.top
      anchors.right: parent.right
      sourceSize.width: 11
      sourceSize.height: 11
      visible: (model.dataType == BrowserDataType.Track && parent.isLoadedInDeck("B"))
    }

    Image {
      id: loadedDeckC
      source: "../Images/LoadedDeckC.png"
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      sourceSize.width: 11
      sourceSize.height: 11
      visible: (model.dataType == BrowserDataType.Track && parent.isLoadedInDeck("C"))
    }

    Image {
      id: loadedDeckD
      source: "../Images/LoadedDeckD.png"
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      sourceSize.width: 11
      sourceSize.height: 11
      visible: (model.dataType == BrowserDataType.Track && parent.isLoadedInDeck("D"))
    }

    function isLoadedInDeck(deckLetter)
    {
      return model.loadedInDeck.indexOf(deckLetter) != -1;
    }
  }

  // folder icon
  Image {
    id:       folderIcon
    source:   (model.dataType == BrowserDataType.Folder) ? ("image://icons/" + model.nodeIconId ) : ""
    width:    33
    height:   33
    fillMode: Image.PreserveAspectFit
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: 3
    clip:     true
    cache:    false
    visible:  false
  }

  ColorOverlay {
    id: folderIconColorOverlay
    color: isCurrentItem == false ? colors.colorFontsListBrowser : contactDelegate.deckColor // unselected vs. selected
    anchors.fill: folderIcon
    source: folderIcon
  }
  
  function hideCoverBorder() {
    if (model.dataType == BrowserDataType.Folder) {
      return false
    }
    return true
  }

  // // cover border
  // Rectangle {
    //   id:cover_innerBorder
    //   color: "transparent"
    //   border.width: 1
    //   border.color: "#26FFFFFF"
    //   height: listImage.height
    //   width: height 
    //   visible: hideCoverBorder()
    //   anchors.top: listImage.top
    //   anchors.left: listImage.left
    // }
  }
