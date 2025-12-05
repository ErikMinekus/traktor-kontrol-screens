import CSI 1.0
import "../Common"
import "../../Defines"

Module
{
  id: module
  property int index: 1
  property string surface_prefix: ""
  property string propertiesPath: ""

  // Settings
  property bool temporaryPreview: true
  property bool temporaryFullScreen: false

  property bool showEndWarning: false
  property bool showSyncWarning: false
  property bool showActiveLoop: false
  property int  bottomLedsDefaultColor: 0

  // Shift
  property alias shift: shiftProp.value
  MappingPropertyDescriptor { id: shiftProp; path: module.propertiesPath + ".shift"; type: MappingPropertyDescriptor.Boolean; value: false }
  Wire { from: "%surface_prefix%.shift";  to: DirectPropertyAdapter { path: module.propertiesPath + ".shift"  } }

  // Browser
  ExtendedBrowserModule
  {
    name: "browse"
    surface: module.surface_prefix
    deckIdx: module.index
    active: true
    temporaryPreview: module.temporaryPreview
    temporaryFullScreen: module.temporaryFullScreen
  }

  // FX Unit
  FxUnit { name: "adapter"; channel: module.index }

  Wire { from: "%surface_prefix%.fx.knobs.1"; to: "adapter.dry_wet" }
  Wire { from: "%surface_prefix%.fx.knobs.2"; to: "adapter.knob1" }
  Wire { from: "%surface_prefix%.fx.knobs.3"; to: "adapter.knob2" }
  Wire { from: "%surface_prefix%.fx.knobs.4"; to: "adapter.knob3" }

  WiresGroup
  {
    enabled: !module.shift

    Wire { from: "%surface_prefix%.fx.buttons.1"; to: "adapter.enabled" }
    Wire { from: "%surface_prefix%.fx.buttons.2"; to: "adapter.button1" }
    Wire { from: "%surface_prefix%.fx.buttons.3"; to: "adapter.button2" }
    Wire { from: "%surface_prefix%.fx.buttons.4"; to: "adapter.button3" }
  }

  WiresGroup
  {
    enabled: module.shift

    WiresGroup
    {
      enabled: fxUnitType.value == FxType.Single

      Wire { from: "%surface_prefix%.fx.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx." + module.index + ".type"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
      Wire { from: "%surface_prefix%.fx.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx." + module.index + ".select.1"; mode: RelativeMode.Decrement; wrap: true; color: Color.LightOrange } }
      Wire { from: "%surface_prefix%.fx.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx." + module.index + ".select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
    }

    WiresGroup
    {
      enabled: fxUnitType.value == FxType.Group

      Wire { from: "%surface_prefix%.fx.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx." + module.index + ".type"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
      Wire { from: "%surface_prefix%.fx.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx." + module.index + ".select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
      Wire { from: "%surface_prefix%.fx.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx." + module.index + ".select.2"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
      Wire { from: "%surface_prefix%.fx.buttons.4";   to: RelativePropertyAdapter{ path: "app.traktor.fx." + module.index + ".select.3"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
    }

    WiresGroup
    {
      enabled: fxUnitType.value == FxType.PatternPlayer

      Wire { from: "%surface_prefix%.fx.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx." + module.index + ".type"; mode: RelativeMode.Increment; wrap: true; color: Color.Mint } }
      Wire { from: "%surface_prefix%.fx.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx." + module.index + ".kitSelect"; mode: RelativeMode.Decrement; wrap: true; color: Color.Mint } }
      Wire { from: "%surface_prefix%.fx.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx." + module.index + ".kitSelect"; mode: RelativeMode.Increment; wrap: true; color: Color.Mint } }
    }
  }

  TempoControl { id: tempoControl; name: "tempo_control"; channel: module.index }
  DirectPropertyAdapter { name: "tempo_fader_relative"; path: "mapping.settings.tempo_fader_relative"; input: false }

  Wire{ from: "tempo_fader_relative"; to: "tempo_control.enable_relative_mode" }
  Wire { from: "%surface_prefix%.pitch.fader"; to: "tempo_control.adjust"; enabled: !module.shift }

  Loop { name: "loop";  channel: module.index }
  WiresGroup {
    enabled: !keyControl.pressed && !stems.isStemSelected

    Wire { from: "%surface_prefix%.loop_size"; to: "loop.autoloop"}
    Wire { from: "%surface_prefix%.loop_move"; to: "loop.move"; enabled: !module.shift}
    Wire { from: "%surface_prefix%.loop_move"; to: "loop.one_beat_move"; enabled:  module.shift }
  }

  TransportSection
  {
    name: "transport"
    channel: module.index

    syncColor: Color.Blue
    masterColor: Color.Blue
    fluxColor: Color.Red
    reverseColor: Color.Red
  }

  Wire { from: "%surface_prefix%.reverse";     to: "transport.flux_reverse"    }
  Wire { from: "%surface_prefix%.flux";        to: "transport.flux"            }
  Wire { from: "%surface_prefix%.play";        to: "transport.play"            }
  Wire { from: "%surface_prefix%.cue";         to: "transport.cue"             ; enabled: !module.shift }
  Wire { from: "%surface_prefix%.cue";         to: "transport.return_to_zero"  ; enabled:  module.shift }

  // Master + Sync
  Wire { from: "%surface_prefix%.sync.color"; to: "transport.sync.color" }
  Wire { from: "%surface_prefix%.sync.brightness"; to: "transport.sync.brightness" }
  Wire { from: "%surface_prefix%.master.color"; to: "transport.master.color" }
  Wire { from: "%surface_prefix%.master.brightness"; to: "transport.master.brightness" }

  AppProperty { id: syncProp; path: "app.traktor.decks." + module.index + ".sync.enabled" }
  AppProperty { id: masterProp; path: "app.traktor.decks." + module.index + ".set_as_master" }

  Wire
  {
    from: "%surface_prefix%.sync"
    to: ButtonScriptAdapter {
      id: syncButton
      property bool engaged: false

      onPress: {
        if (masterButton.engaged)
        {
          masterButton.engaged = false;
          tempoControl.reset();
        }
        else
        {
          syncButton.engaged = true;
        }
      }
      onRelease: {
        if (syncButton.engaged)
        {
          syncProp.value = !syncProp.value;
        }
      }
      output: false
    }
  }

  Wire
  {
    from: "%surface_prefix%.master"
    to: ButtonScriptAdapter {
      id: masterButton
      property bool engaged: false

      onPress: {
        if (syncButton.engaged)
        {
          syncButton.engaged = false;
          tempoControl.reset();
        }
        else
        {
          masterButton.engaged = true;
        }
      }
      onRelease: {
        if (masterButton.engaged)
        {
          masterProp.value = true;
        }
      }
      output: false
    }
  }

  // Key
  MX2KeyControl { id: keyControl; name: "key_control"; surface: module.surface_prefix; index: module.index }

  // Pads
  function updatePadsMode()
  {
    if (deckTypeProp.value == DeckType.Live)
    {
      padsMode.value = module.disabled;
    }
    else if (deckTypeProp.value == DeckType.Remix) 
    {
      padsMode.value = module.fluxLoop;
    }
    else
    {
      padsMode.value = module.hotcues;
    }
  }

  AppProperty {
    id: fxUnitType
    path: "app.traktor.fx." + module.index + ".type"
    onValueChanged: {
      if (fxUnitType.value != FxType.PatternPlayer && (padsMode.value == module.pattern1 || padsMode.value == module.pattern2))
      {
        updatePadsMode();
      }
    }
  }

  AppProperty { id: deckTypeProp; path: "app.traktor.decks." + module.index + ".type"; onValueChanged: { updatePadsMode(); } }

  readonly property int disabled:  0
  readonly property int hotcues:   1
  readonly property int stems:     2
  readonly property int pattern1:  3
  readonly property int pattern2:  4
  readonly property int fluxLoop:  5

  // LED Brightness
  readonly property real onBrightness:     1.0
  readonly property real dimmedBrightness: 0.0

  MappingPropertyDescriptor { id: padsMode; path: module.propertiesPath + ".pads_mode"; type: MappingPropertyDescriptor.Integer; value: module.hotcues; min: module.disabled; max: module.fluxLoop }

  Wire { 
    enabled: deckTypeProp.value == DeckType.Track || deckTypeProp.value == DeckType.Stem
    from: "%surface_prefix%.hotcues"
    to: SetPropertyAdapter{ path: module.propertiesPath + ".pads_mode"; value: module.hotcues; color: Color.Blue }
  }

  Wire {
    enabled: deckTypeProp.value == DeckType.Stem
    from: "%surface_prefix%.stems"
    to: SetPropertyAdapter{ path: module.propertiesPath + ".pads_mode"; value: module.stems; color: Color.Blue }
  }

  Wire {
    enabled: deckTypeProp.value != DeckType.Live
    from: "%surface_prefix%.flux_loop"
    to: SetPropertyAdapter{ path: module.propertiesPath + ".pads_mode"; value: module.fluxLoop; color: Color.Blue }
  }

  WiresGroup {
    enabled: fxUnitType.value == FxType.PatternPlayer

    Wire {
            from: "%surface_prefix%.pattern"
            to: ButtonScriptAdapter
            {
              onPress:
              {
                switch (padsMode.value)
                {
                  case module.stems:
                  case module.hotcues:
                  case module.fluxLoop:
                    padsMode.value = module.pattern1;
                    break;

                  case module.pattern1:
                    padsMode.value = module.pattern2;
                    break;

                  case module.pattern2:
                    padsMode.value = module.pattern1;
                    break;
                }
              }
              brightness: padsMode.value == module.pattern1 || padsMode.value == module.pattern2 ? onBrightness : dimmedBrightness
              color: padsMode.value == module.pattern2 ? Color.White : Color.Blue
            }
            enabled: !module.shift
    }
    Wire {
            from: "%surface_prefix%.pattern"
            to: TriggerPropertyAdapter{ path: "app.traktor.fx." + module.index + ".pattern_player.clear_pattern"; color: Color.Red }
            enabled: module.shift
    }
  }

  HotcuesModule
  {
    name: "hotcues"
    shift: shiftProp.value
    active: padsMode.value == module.hotcues
    deckIdx:  module.index
    surface: module.surface_prefix
  }

  MX2Stems
  {  
    id: stems
    name: "stems"
    surface: module.surface_prefix
    deckPropertiesPath: module.propertiesPath
    deckIdx: module.index
    active: padsMode.value == module.stems
    shift: module.shift
  }

  PatternPlayer { name: "pattern_player"; channel: module.index }
  WiresGroup
  {
    enabled: padsMode.value == module.pattern1

    Wire { from: "%surface_prefix%.pads.1"; to: "pattern_player.step_1" }
    Wire { from: "%surface_prefix%.pads.2"; to: "pattern_player.step_2" }
    Wire { from: "%surface_prefix%.pads.3"; to: "pattern_player.step_3" }
    Wire { from: "%surface_prefix%.pads.4"; to: "pattern_player.step_4" }
    Wire { from: "%surface_prefix%.pads.5"; to: "pattern_player.step_5" }
    Wire { from: "%surface_prefix%.pads.6"; to: "pattern_player.step_6" }
    Wire { from: "%surface_prefix%.pads.7"; to: "pattern_player.step_7" }
    Wire { from: "%surface_prefix%.pads.8"; to: "pattern_player.step_8" }
  }
  WiresGroup
  {
    enabled: padsMode.value == module.pattern2

    Wire { from: "%surface_prefix%.pads.1"; to: "pattern_player.step_9" }
    Wire { from: "%surface_prefix%.pads.2"; to: "pattern_player.step_10" }
    Wire { from: "%surface_prefix%.pads.3"; to: "pattern_player.step_11" }
    Wire { from: "%surface_prefix%.pads.4"; to: "pattern_player.step_12" }
    Wire { from: "%surface_prefix%.pads.5"; to: "pattern_player.step_13" }
    Wire { from: "%surface_prefix%.pads.6"; to: "pattern_player.step_14" }
    Wire { from: "%surface_prefix%.pads.7"; to: "pattern_player.step_15" }
    Wire { from: "%surface_prefix%.pads.8"; to: "pattern_player.step_16" }
  }

  // Stutter Loops
  FluxedLoop { name: "fluxed_loop"; channel: module.index }
  ButtonSection { name: "stutter_pads"; buttons: 8; color: Color.Green; buttonHandling: ButtonSection.Stack }

  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_32 } to: "stutter_pads.button1.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_16 } to: "stutter_pads.button2.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_8  } to: "stutter_pads.button3.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_4  } to: "stutter_pads.button4.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_2  } to: "stutter_pads.button5.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1    } to: "stutter_pads.button6.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_2    } to: "stutter_pads.button7.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_4    } to: "stutter_pads.button8.value" }

  Wire { from: "stutter_pads.value";      to: "fluxed_loop.size"   }
  Wire { from: "stutter_pads.active";     to: "fluxed_loop.active" }

  WiresGroup
  {
    enabled: padsMode.value == module.fluxLoop

    Wire { from: "%surface_prefix%.pads.1"; to: "stutter_pads.button1" }
    Wire { from: "%surface_prefix%.pads.2"; to: "stutter_pads.button2" }
    Wire { from: "%surface_prefix%.pads.3"; to: "stutter_pads.button3" }
    Wire { from: "%surface_prefix%.pads.4"; to: "stutter_pads.button4" }
    Wire { from: "%surface_prefix%.pads.5"; to: "stutter_pads.button5" }
    Wire { from: "%surface_prefix%.pads.6"; to: "stutter_pads.button6" }
    Wire { from: "%surface_prefix%.pads.7"; to: "stutter_pads.button7" }
    Wire { from: "%surface_prefix%.pads.8"; to: "stutter_pads.button8" }
  }

  // Jogwheel //
  MappingPropertyDescriptor {
    id: jogMode
    path: module.propertiesPath + ".jog_mode"
    type: MappingPropertyDescriptor.Boolean
  }

  Wire { from: "%surface_prefix%.mode.jogwheel"; to: SetPropertyAdapter{ path: module.propertiesPath + ".jog_mode"; value: true; color: Color.Blue } }
  Wire { from: "%surface_prefix%.mode.turntable"; to: SetPropertyAdapter{ path: module.propertiesPath + ".jog_mode"; value: false; color: Color.Blue } }

  Turntable { name: "turntable"; channel: module.index }

  WiresGroup {
    Wire { from: "%surface_prefix%.jogwheel.rotation"; to: "turntable.rotation" }
    Wire { from: "%surface_prefix%.jogwheel.speed"; to: "turntable.speed" }
    Wire { from: "%surface_prefix%.jogwheel.touch"; to: "turntable.touch"; enabled: !jogMode.value }
    Wire { from: "%surface_prefix%.shift"; to: "turntable.shift" }
  }

  // Bottom LEDs
  AppProperty { id: inActiveLoopProp; path: "app.traktor.decks." + module.index + ".loop.is_in_active_loop" }
  AppProperty { id: endWarningProp; path: "app.traktor.decks." + module.index + ".track.track_end_warning" }

  AppProperty { id: phaseProp; path: "app.traktor.decks." + module.index + ".tempo.phase" }

  property bool shouldShowEndWarning: showEndWarning && endWarningProp.value
  property bool shouldShowActiveLoop: showActiveLoop && inActiveLoopProp.value
  property bool shouldShowSyncWarning: showSyncWarning && syncProp.value && (Math.abs(phaseProp.value) >= 0.008)

  Lighter { name: "sync_lighter"; ledCount: 6; color: Color.Red;   brightness: 1.0 }
  Lighter { name: "loop_lighter"; ledCount: 6; color: Color.Green; brightness: 1.0 }
  Blinker { name: "warning_blinker"; ledCount: 6; autorun: true; color: Color.Red; defaultBrightness: 0.0; cycle: 300 }

  Lighter { name: "default_lighter";   ledCount: 6; color: module.bottomLedsDefaultColor; brightness: 1.0 }
  Lighter { name: "rainbow_lighter_1"; color: Color.Red;                     brightness: 1.0 }
  Lighter { name: "rainbow_lighter_2"; color: Color.LightOrange;             brightness: 1.0 }
  Lighter { name: "rainbow_lighter_3"; color: Color.Yellow;                  brightness: 1.0 }
  Lighter { name: "rainbow_lighter_4"; color: Color.Green;                   brightness: 1.0 }
  Lighter { name: "rainbow_lighter_5"; color: Color.Blue;                    brightness: 1.0 }
  Lighter { name: "rainbow_lighter_6"; color: Color.Purple;                  brightness: 1.0 }

  Wire { from: "%surface_prefix%.bottom.leds";  to: "loop_lighter"; enabled: shouldShowActiveLoop }
  Wire { from: "%surface_prefix%.bottom.leds";  to: "warning_blinker"; enabled: shouldShowEndWarning && !shouldShowActiveLoop }
  Wire { from: "%surface_prefix%.bottom.leds";  to: "sync_lighter"; enabled: shouldShowSyncWarning && !shouldShowEndWarning && !shouldShowActiveLoop }

  WiresGroup
  {
    enabled: !shouldShowSyncWarning && !shouldShowEndWarning && !shouldShowActiveLoop

    Wire { from: "%surface_prefix%.bottom.leds"; to: "default_lighter"; enabled: module.bottomLedsDefaultColor != Color.White }

    WiresGroup
    {
      enabled: module.bottomLedsDefaultColor == Color.White
  
      Wire { from: "%surface_prefix%.bottom.leds.1"; to: "rainbow_lighter_1" }
      Wire { from: "%surface_prefix%.bottom.leds.2"; to: "rainbow_lighter_2" }
      Wire { from: "%surface_prefix%.bottom.leds.3"; to: "rainbow_lighter_3" }
      Wire { from: "%surface_prefix%.bottom.leds.4"; to: "rainbow_lighter_4" }
      Wire { from: "%surface_prefix%.bottom.leds.5"; to: "rainbow_lighter_5" }
      Wire { from: "%surface_prefix%.bottom.leds.6"; to: "rainbow_lighter_6" }
    }
  }
}
