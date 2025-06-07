import QtQuick 2.0
import Qt5Compat.GraphicalEffects
import CSI 1.0

import '../../../Defines' as Defines

Item {
  id : phaseMeter

  property int              deckId:        0

  readonly property bool    isMaster:      (propSyncMasterDeck.value == deckId)
  readonly property bool    isMasterClock: (propSyncMasterDeck.value == -1)
  readonly property var     deckType:      [propDeckAType.value, propDeckBType.value, propDeckCType.value, propDeckDType.value]
  readonly property var     elapsedTime:   [propDeckAElapsedTime.value, propDeckBElapsedTime.value, propDeckCElapsedTime.value, propDeckDElapsedTime.value]
  readonly property var     gridOffset:    [propDeckAGridOffset.value, propDeckBGridOffset.value, propDeckCGridOffset.value, propDeckDGridOffset.value]
  readonly property var     mixerBpm:      [propDeckAMixerBpm.value, propDeckBMixerBpm.value, propDeckCMixerBpm.value, propDeckDMixerBpm.value]
  readonly property var     nextCuePoint:  [propDeckANextCuePoint.value, propDeckBNextCuePoint.value, propDeckCNextCuePoint.value, propDeckDNextCuePoint.value]
  readonly property var     remixBeatPos:  [propDeckARemixBeatPos.value, propDeckBRemixBeatPos.value, propDeckCRemixBeatPos.value, propDeckDRemixBeatPos.value]

  AppProperty { id: propSyncMasterDeck;    path: "app.traktor.masterclock.source_id" }
  AppProperty { id: propDeckAType;         path: "app.traktor.decks.1.type" }
  AppProperty { id: propDeckBType;         path: "app.traktor.decks.2.type" }
  AppProperty { id: propDeckCType;         path: "app.traktor.decks.3.type" }
  AppProperty { id: propDeckDType;         path: "app.traktor.decks.4.type" }
  AppProperty { id: propDeckAGridOffset;   path: "app.traktor.decks.1.content.grid_offset" }
  AppProperty { id: propDeckBGridOffset;   path: "app.traktor.decks.2.content.grid_offset" }
  AppProperty { id: propDeckCGridOffset;   path: "app.traktor.decks.3.content.grid_offset" }
  AppProperty { id: propDeckDGridOffset;   path: "app.traktor.decks.4.content.grid_offset" }
  AppProperty { id: propDeckAElapsedTime;  path: "app.traktor.decks.1.track.player.elapsed_time" }
  AppProperty { id: propDeckBElapsedTime;  path: "app.traktor.decks.2.track.player.elapsed_time" }
  AppProperty { id: propDeckCElapsedTime;  path: "app.traktor.decks.3.track.player.elapsed_time" }
  AppProperty { id: propDeckDElapsedTime;  path: "app.traktor.decks.4.track.player.elapsed_time" }
  AppProperty { id: propDeckANextCuePoint; path: "app.traktor.decks.1.track.player.next_cue_point" }
  AppProperty { id: propDeckBNextCuePoint; path: "app.traktor.decks.2.track.player.next_cue_point" }
  AppProperty { id: propDeckCNextCuePoint; path: "app.traktor.decks.3.track.player.next_cue_point" }
  AppProperty { id: propDeckDNextCuePoint; path: "app.traktor.decks.4.track.player.next_cue_point" }
  AppProperty { id: propDeckAMixerBpm;     path: "app.traktor.decks.1.tempo.base_bpm" }
  AppProperty { id: propDeckBMixerBpm;     path: "app.traktor.decks.2.tempo.base_bpm" }
  AppProperty { id: propDeckCMixerBpm;     path: "app.traktor.decks.3.tempo.base_bpm" }
  AppProperty { id: propDeckDMixerBpm;     path: "app.traktor.decks.4.tempo.base_bpm" }
  AppProperty { id: propDeckARemixBeatPos; path: "app.traktor.decks.1.remix.current_beat_pos" }
  AppProperty { id: propDeckBRemixBeatPos; path: "app.traktor.decks.2.remix.current_beat_pos" }
  AppProperty { id: propDeckCRemixBeatPos; path: "app.traktor.decks.3.remix.current_beat_pos" }
  AppProperty { id: propDeckDRemixBeatPos; path: "app.traktor.decks.4.remix.current_beat_pos" }

  width:   180
  height:  18

  Defines.Colors { id: colors }
  Defines.Font   { id: fonts  }


  // MASTER BEAT
  Repeater {
    id: master_beats
    model: 4

    Rectangle {
      width:  36
      height: 8
      y:      0
      x:      index * 38
      color:  isMaster || isMasterClock ? colors.colorGrey08
        : isCurrentBeat(propSyncMasterDeck.value, index) ? colors.colorGrey232 : colors.colorGrey32
    }
  }

  // BEAT
  Repeater {
    id: beats
    model: 4

    Rectangle {
      width:  36
      height: 8
      y:      10
      x:      index * 38
      color:  isCurrentBeat(deckId, index) ? colors.colorGreenActive : colors.colorGreenInactive
    }
  }

  // MASTER BEATS TO CUE
  Text {
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: -1
    anchors.rightMargin: isApproachingNextCue(propSyncMasterDeck.value) ? 1 : 0
    font.family: "Pragmatica"
    font.pixelSize: fonts.miniFontSize
    horizontalAlignment: Text.AlignRight
    color: isApproachingNextCue(propSyncMasterDeck.value) ? colors.colorRed : colors.colorGrey232
    text: getBeatsToCueText(propSyncMasterDeck.value)
    visible: !isMaster && !isMasterClock && !isRemixDeck(propSyncMasterDeck.value)
  }

  // BEATS TO CUE
  Text {
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: 9
    anchors.rightMargin: isApproachingNextCue(deckId) ? 1 : 0
    font.family: "Pragmatica"
    font.pixelSize: fonts.miniFontSize
    horizontalAlignment: Text.AlignRight
    color: isApproachingNextCue(deckId) ? colors.colorRed : colors.colorGreenActive
    text: getBeatsToCueText(deckId)
    visible: !isRemixDeck(deckId)
  }


  //--------------------------------------------------------------------------------------------------------------------
  //  FUNCTIONS
  //--------------------------------------------------------------------------------------------------------------------

  function getBeats(deck) {
    var beats = isRemixDeck(deck) ? remixBeatPos[deck] : ((elapsedTime[deck] * 1000 - gridOffset[deck]) * mixerBpm[deck]) / 60000.0;

    return Math.floor((beats || 0) * 10000) / 10000;
  }

  function getBeatsToCue(deck) {
    var beats = ((nextCuePoint[deck] - elapsedTime[deck] * 1000) * mixerBpm[deck]) / 60000.0;

    return Math.floor((beats || 0) * 10000) / 10000;
  }

  function getBeatsToCueText(deck) {
    var beats = getBeatsToCue(deck);
    if (beats < 0 || beats >= 256) return "——.—";

    var bars = Math.floor(beats / 4);
    var beat = Math.floor(beats % 4) + 1;

    return (bars < 10 ? "0" : "") + bars + "." + beat;
  }

  function isApproachingNextCue(deck) {
    var beats = getBeatsToCue(deck);

    return beats >= 0 && Math.floor(beats / 4) < 4;
  }

  function isCurrentBeat(deck, index) {
    var beats = getBeats(deck);
    var beat  = ((Math.floor(beats) % 4) + 4) % 4;

    return beat == index;
  }

  function isRemixDeck(deck) {
    return deckType[deck] == DeckType.Remix;
  }

}
