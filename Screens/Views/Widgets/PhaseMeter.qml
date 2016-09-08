import QtQuick 2.0
import './../Definitions/' as Definitions
import QtGraphicalEffects 1.0
import CSI 1.0


Item {
  id : phaseMeter

  property int              deckId:        0

  readonly property variant deckLetters:   ["A", "B", "C", "D"]
  readonly property int     isMaster:      (propSyncMasterDeck.value == deckId) ? 1 : 0

  AppProperty { id: propSyncMasterDeck;    path: "app.traktor.masterclock.source_id" }
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

  width:   156
  height:  12
  clip:    false

  Definitions.Colors { id: colors }
  Definitions.Font   { id: fonts  }


  // MASTER DECK
  Rectangle {
    width: 12
    height: 12
    y: 0
    x: -15
    color: "orange"
    radius: 2
    visible: (propSyncMasterDeck.value > -1 && !isMaster)

    Text {
      anchors.centerIn: parent
      color: "black"
      font.pixelSize: fonts.miniFontSize
      font.family: "Pragmatica MediumTT"
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: deckLetters[propSyncMasterDeck.value]
    }
  }

  // BEAT
  Repeater {
    id: beats
    model: 4

    Rectangle {
      width:           36
      height:          parent.height
      y:               0
      x:               index * 40
      border.color:    (index % 4 == 0) ? "red" : "orange"
      border.width:    1
      radius:          2

      function getBeatColor(index) {
        if (isMaster) return "transparent";

        var beats = getMasterBeats();
        if (beats == -1) return "transparent";

        var beat = parseInt(beats) % 4;
        if (beat < 0) beat += 4;

        if (beat != index) return "transparent";
        if (beat == 0) return "red";

        return "orange";
      }
      color:           getBeatColor(index)
    }
  }

  // BEATS TO CUE
  Text {
    width: 30
    y: 0
    x: 158
    font.pixelSize: fonts.scale(13)
    font.family: "Pragmatica"
    horizontalAlignment: Text.AlignRight

    function getBeatsToCueColor() {
      if (isMaster) return "orange";

      var beats = parseInt(getMasterBeatsToCue());
      if (beats < 0 || beats > 255) return "orange";

      var bars = parseInt(beats / 4);
      if (bars < 4) return "red";

      return "orange";
    }
    color: getBeatsToCueColor()

    function getBeatsToCueString() {
      if (isMaster) return "——.—";

      var beats = parseInt(getMasterBeatsToCue());
      if (beats < 0 || beats > 255) return "——.—";

      var bars = parseInt(beats / 4);
      var beat = parseInt(beats % 4) + 1;
      if (bars < 0) bars = 0;
      if (beat < 1) beat = 1;

      var barsStr = bars.toString();
      if (bars < 10) barsStr = "0" + barsStr;

      return barsStr + "." + beat.toString();
    }
    text: getBeatsToCueString()
  }


  //--------------------------------------------------------------------------------------------------------------------
  //  FUNCTIONS
  //--------------------------------------------------------------------------------------------------------------------

  function getMasterBeats() {
    switch (propSyncMasterDeck.value) {
      case 0: return ((propDeckAElapsedTime.value * 1000 - propDeckAGridOffset.value) * propDeckAMixerBpm.value) / 60000.0;
      case 1: return ((propDeckBElapsedTime.value * 1000 - propDeckBGridOffset.value) * propDeckBMixerBpm.value) / 60000.0;
      case 2: return ((propDeckCElapsedTime.value * 1000 - propDeckCGridOffset.value) * propDeckCMixerBpm.value) / 60000.0;
      case 3: return ((propDeckDElapsedTime.value * 1000 - propDeckDGridOffset.value) * propDeckDMixerBpm.value) / 60000.0;
    }

    return -1;
  }

  function getMasterBeatsToCue() {
    switch (propSyncMasterDeck.value) {
      case 0: return ((propDeckANextCuePoint.value - propDeckAElapsedTime.value * 1000) * propDeckAMixerBpm.value) / 60000.0;
      case 1: return ((propDeckBNextCuePoint.value - propDeckBElapsedTime.value * 1000) * propDeckBMixerBpm.value) / 60000.0;
      case 2: return ((propDeckCNextCuePoint.value - propDeckCElapsedTime.value * 1000) * propDeckCMixerBpm.value) / 60000.0;
      case 3: return ((propDeckDNextCuePoint.value - propDeckDElapsedTime.value * 1000) * propDeckDMixerBpm.value) / 60000.0;
    }

    return -1;
  }

}
