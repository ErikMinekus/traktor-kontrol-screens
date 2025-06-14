import CSI 1.0

import "Defines"

Module
{
  id: module
  property int deckIdx: 0
  property string surface: ""
  property string propertiesPath: ""

  property bool shift: false
  property int eqModePushAction: 0
  property int eqModeShiftPushAction: 0
  property int stemsModePushAction: 0
  property int stemsModeShiftPushAction: 0
  property int channelFxPushAction: 0
  property int channelFxShiftPushAction: 0
  property int prelistenPushAction: 0
  property int prelistenShiftPushAction: 0

  property bool showEndWarning: false
  property bool showSyncWarning: false
  property bool showActiveLoop: false
  property int  bottomLedsDefaultColor: 0

  MappingPropertyDescriptor { path: module.propertiesPath + ".active_deck"; type: MappingPropertyDescriptor.Integer; value: module.deckIdx }
  MappingPropertyDescriptor { id: lastActiveKnobProp; path: module.propertiesPath + ".last_active_knob"; type: MappingPropertyDescriptor.Integer; value: 1 }

  MappingPropertyDescriptor { path: module.propertiesPath + ".knobs_are_active"; type: MappingPropertyDescriptor.Boolean; value: false }
  SwitchTimer { name: "knobs_activity_timer"; setTimeout: 0; resetTimeout: 1000 }

  // Screen
  KontrolScreen { name: "side_screen"; propertiesPath: module.propertiesPath; flavor: ScreenFlavor.Z1MK2_Side }
  Wire { from: "side_screen.output"; to: "%surface%.display" }

  property alias channel_mode_1: channelModeProp1.value
  property alias channel_mode_2: channelModeProp2.value
  property alias channel_mode_3: channelModeProp3.value
  property alias channel_mode_4: channelModeProp4.value
  MappingPropertyDescriptor { id: channelModeProp1; path: module.propertiesPath + ".channel_mode.1"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { id: channelModeProp2; path: module.propertiesPath + ".channel_mode.2"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { id: channelModeProp3; path: module.propertiesPath + ".channel_mode.3"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { id: channelModeProp4; path: module.propertiesPath + ".channel_mode.4"; type: MappingPropertyDescriptor.Boolean; value: false }
  
  // Soft takeover
  SoftTakeover { name: "softtakeover1" }
  SoftTakeover { name: "softtakeover2" }
  SoftTakeover { name: "softtakeover3" }
  SoftTakeover { name: "softtakeover4" }
  SoftTakeover { name: "softtakeover5" }
  SoftTakeover { name: "softtakeover_fader" }

  // Level meter
  LEDLevelMeter { name: "level_meter"; dBThresholds: [-27,-24,-21,-18,-15,-12,-9,-6,-3,0] }
  Wire { from: "%surface%.level_meter"; to: "level_meter" }

  MappingPropertyDescriptor { path: module.propertiesPath + ".softtakeover.1.direction"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { path: module.propertiesPath + ".softtakeover.2.direction"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { path: module.propertiesPath + ".softtakeover.3.direction"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { path: module.propertiesPath + ".softtakeover.4.direction"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { path: module.propertiesPath + ".softtakeover.5.direction"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { path: module.propertiesPath + ".softtakeover.fader.direction"; type: MappingPropertyDescriptor.Integer; value: 0 }

  Wire { from: "%surface%.gain";    to: "softtakeover1.input" }
  Wire { from: "%surface%.eq.high"; to: "softtakeover2.input" }
  Wire { from: "%surface%.eq.mid";  to: "softtakeover3.input" }
  Wire { from: "%surface%.eq.low";  to: "softtakeover4.input" }
  Wire { from: "%surface%.channel_fx.amount";  to: "softtakeover5.input" }
  Wire { from: "%surface%.volume";             to: "softtakeover_fader.input" }

  Wire { from: "softtakeover1.direction_monitor"; to: DirectPropertyAdapter { path: module.propertiesPath + ".softtakeover.1.direction" } }
  Wire { from: "softtakeover2.direction_monitor"; to: DirectPropertyAdapter { path: module.propertiesPath + ".softtakeover.2.direction" } }
  Wire { from: "softtakeover3.direction_monitor"; to: DirectPropertyAdapter { path: module.propertiesPath + ".softtakeover.3.direction" } }
  Wire { from: "softtakeover4.direction_monitor"; to: DirectPropertyAdapter { path: module.propertiesPath + ".softtakeover.4.direction" } }
  Wire { from: "softtakeover5.direction_monitor"; to: DirectPropertyAdapter { path: module.propertiesPath + ".softtakeover.5.direction" } }
  Wire { from: "softtakeover_fader.direction_monitor"; to: DirectPropertyAdapter { path: module.propertiesPath + ".softtakeover.fader.direction" } }

  // Knobs activity
  WiresGroup
  {
    Wire {
      from: Or
      {
        inputs:
        [
          "%surface%.gain.is_turned",
          "%surface%.eq.high.is_turned",
          "%surface%.eq.mid.is_turned",
          "%surface%.eq.low.is_turned",
          "%surface%.channel_fx.amount.is_turned"
        ]
      }
      to: "knobs_activity_timer.input"
    }

    Wire { from: "knobs_activity_timer.output.value"; to: ValuePropertyAdapter { path: module.propertiesPath + ".knobs_are_active"; output: false } }

    Wire { from: "%surface%.gain";    to: KnobScriptAdapter { onTurn: { lastActiveKnobProp.value = 1 } } }
    Wire { from: "%surface%.eq.high"; to: KnobScriptAdapter { onTurn: { lastActiveKnobProp.value = 2 } } }
    Wire { from: "%surface%.eq.mid";  to: KnobScriptAdapter { onTurn: { lastActiveKnobProp.value = 3 } } }
    Wire { from: "%surface%.eq.low";  to: KnobScriptAdapter { onTurn: { lastActiveKnobProp.value = 4 } } }
    Wire { from: "%surface%.channel_fx.amount";  to: KnobScriptAdapter { onTurn: { lastActiveKnobProp.value = 5 } } }
  }

  // Adapters
  Group
  {
    name: "decks"

    Group
    {
      name: "1"

      TransportSection { name: "transport"; channel: 1 }
      ButtonTempoBend { name: "tempo_bend"; channel: 1 }
    }

    Group
    {
      name: "2"

      TransportSection { name: "transport"; channel: 2 }
      ButtonTempoBend { name: "tempo_bend"; channel: 2 }
    }

    Group
    {
      name: "3"

      TransportSection { name: "transport"; channel: 3 }
      ButtonTempoBend { name: "tempo_bend"; channel: 3 }
    }

    Group
    {
      name: "4"

      TransportSection { name: "transport"; channel: 4 }
      ButtonTempoBend { name: "tempo_bend"; channel: 4 }
    }
  }

  // Deck A
  WiresGroup
  {
    enabled: module.deckIdx == 1

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.eq_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.1"; color: Color.Blue; value: false } enabled: module.eqModePushAction == ButtonsActions.select_eq_mode }
      Wire { from: "%surface%.eq_mode";    to: "decks.1.transport.cue";  enabled: module.eqModePushAction == ButtonsActions.cue }
      Wire { from: "%surface%.eq_mode";    to: "decks.1.transport.play"; enabled: module.eqModePushAction == ButtonsActions.play }
      Wire { from: "%surface%.eq_mode";    to: "decks.1.transport.sync"; enabled: module.eqModePushAction == ButtonsActions.sync }
      Wire { from: "%surface%.eq_mode";    to: "decks.1.transport.return_to_zero";  enabled: module.eqModePushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.eq_mode";    to: "decks.1.tempo_bend.up"; enabled: module.eqModePushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.eq_mode";    to: "decks.1.tempo_bend.down"; enabled: module.eqModePushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.eq_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.1"; color: Color.Blue; value: false } enabled: module.eqModeShiftPushAction == ButtonsActions.select_eq_mode }
      Wire { from: "%surface%.eq_mode";    to: "decks.1.transport.cue";  enabled: module.eqModeShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.eq_mode";    to: "decks.1.transport.play"; enabled: module.eqModeShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.eq_mode";    to: "decks.1.transport.sync"; enabled: module.eqModeShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.eq_mode";    to: "decks.1.transport.return_to_zero";  enabled: module.eqModeShiftPushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.eq_mode";    to: "decks.1.tempo_bend.up"; enabled: module.eqModeShiftPushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.eq_mode";    to: "decks.1.tempo_bend.down"; enabled: module.eqModeShiftPushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.stems_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.1"; color: Color.Blue; value: true } enabled: module.stemsModePushAction == ButtonsActions.select_stems_mode }
      Wire { from: "%surface%.stems_mode";    to: "decks.1.transport.cue";  enabled: module.stemsModePushAction == ButtonsActions.cue }
      Wire { from: "%surface%.stems_mode";    to: "decks.1.transport.play"; enabled: module.stemsModePushAction == ButtonsActions.play }
      Wire { from: "%surface%.stems_mode";    to: "decks.1.transport.sync"; enabled: module.stemsModePushAction == ButtonsActions.sync }
      Wire { from: "%surface%.stems_mode";    to: "decks.1.transport.return_to_zero";  enabled: module.stemsModePushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.stems_mode";    to: "decks.1.tempo_bend.up"; enabled: module.stemsModePushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.stems_mode";    to: "decks.1.tempo_bend.down"; enabled: module.stemsModePushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.stems_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.1"; color: Color.Blue; value: true } enabled: module.stemsModeShiftPushAction == ButtonsActions.select_stems_mode }
      Wire { from: "%surface%.stems_mode";    to: "decks.1.transport.cue";  enabled: module.stemsModeShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.stems_mode";    to: "decks.1.transport.play"; enabled: module.stemsModeShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.stems_mode";    to: "decks.1.transport.sync"; enabled: module.stemsModeShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.stems_mode";    to: "decks.1.transport.return_to_zero";  enabled: module.stemsModeShiftPushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.stems_mode";    to: "decks.1.tempo_bend.up"; enabled: module.stemsModeShiftPushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.stems_mode";    to: "decks.1.tempo_bend.down"; enabled: module.stemsModeShiftPushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.channel_fx.on";    to: "decks.1.transport.cue";  enabled: module.channelFxPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.1.transport.play"; enabled: module.channelFxPushAction == ButtonsActions.play }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.1.transport.sync"; enabled: module.channelFxPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.1.transport.return_to_zero";  enabled: module.channelFxPushAction == ButtonsActions.skip_to_start  }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.channel_fx.on";    to: "decks.1.transport.cue";  enabled: module.channelFxShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.1.transport.play"; enabled: module.channelFxShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.1.transport.sync"; enabled: module.channelFxShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.1.transport.return_to_zero";  enabled: module.channelFxShiftPushAction == ButtonsActions.skip_to_start  }
    }

    // EQ Mode
    WiresGroup
    {
      enabled: !module.channel_mode_1

      Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.gain";    ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.high"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.mid";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    }

    // Stems mode
    WiresGroup
    {
      enabled: module.channel_mode_1

      Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.1.stems.1.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.1.stems.2.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.1.stems.3.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.1.stems.4.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.cue";    to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.cue"; color: Color.Blue } enabled: module.prelistenPushAction == ButtonsActions.prelisten }
      Wire { from: "%surface%.cue";    to: "decks.1.transport.cue";  enabled: module.prelistenPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.cue";    to: "decks.1.transport.play"; enabled: module.prelistenPushAction == ButtonsActions.play }
      Wire { from: "%surface%.cue";    to: "decks.1.transport.sync"; enabled: module.prelistenPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.cue";    to: "decks.1.transport.return_to_zero";  enabled: module.prelistenPushAction == ButtonsActions.skip_to_start  }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.cue";    to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.cue"; color: Color.Blue } enabled: module.prelistenShiftPushAction == ButtonsActions.prelisten }
      Wire { from: "%surface%.cue";    to: "decks.1.transport.cue";  enabled: module.prelistenShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.cue";    to: "decks.1.transport.play"; enabled: module.prelistenShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.cue";    to: "decks.1.transport.sync"; enabled: module.prelistenShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.cue";    to: "decks.1.transport.return_to_zero";  enabled: module.prelistenShiftPushAction == ButtonsActions.skip_to_start  }
    }

    // Channel FX Amount
    Wire { from: "softtakeover5.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.adjust";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    // Volume Fader + Level meter
    Wire { from: "softtakeover_fader.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.volume";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    Wire { from: "level_meter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels.1.level.prefader.linear.sum"; input: false } }
  }

  // Deck B
  WiresGroup
  {
    enabled: module.deckIdx == 2

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.eq_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.2"; color: Color.Blue; value: false } enabled: module.eqModePushAction == ButtonsActions.select_eq_mode }
      Wire { from: "%surface%.eq_mode";    to: "decks.2.transport.cue";  enabled: module.eqModePushAction == ButtonsActions.cue }
      Wire { from: "%surface%.eq_mode";    to: "decks.2.transport.play"; enabled: module.eqModePushAction == ButtonsActions.play }
      Wire { from: "%surface%.eq_mode";    to: "decks.2.transport.sync"; enabled: module.eqModePushAction == ButtonsActions.sync }
      Wire { from: "%surface%.eq_mode";    to: "decks.2.transport.return_to_zero";  enabled: module.eqModePushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.eq_mode";    to: "decks.2.tempo_bend.up"; enabled: module.eqModePushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.eq_mode";    to: "decks.2.tempo_bend.down"; enabled: module.eqModePushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.eq_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.2"; color: Color.Blue; value: false } enabled: module.eqModeShiftPushAction == ButtonsActions.select_eq_mode }
      Wire { from: "%surface%.eq_mode";    to: "decks.2.transport.cue";  enabled: module.eqModeShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.eq_mode";    to: "decks.2.transport.play"; enabled: module.eqModeShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.eq_mode";    to: "decks.2.transport.sync"; enabled: module.eqModeShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.eq_mode";    to: "decks.2.transport.return_to_zero";  enabled: module.eqModeShiftPushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.eq_mode";    to: "decks.2.tempo_bend.up"; enabled: module.eqModeShiftPushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.eq_mode";    to: "decks.2.tempo_bend.down"; enabled: module.eqModeShiftPushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.stems_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.2"; color: Color.Blue; value: true } enabled: module.stemsModePushAction == ButtonsActions.select_stems_mode }
      Wire { from: "%surface%.stems_mode";    to: "decks.2.transport.cue";  enabled: module.stemsModePushAction == ButtonsActions.cue }
      Wire { from: "%surface%.stems_mode";    to: "decks.2.transport.play"; enabled: module.stemsModePushAction == ButtonsActions.play }
      Wire { from: "%surface%.stems_mode";    to: "decks.2.transport.sync"; enabled: module.stemsModePushAction == ButtonsActions.sync }
      Wire { from: "%surface%.stems_mode";    to: "decks.2.transport.return_to_zero";  enabled: module.stemsModePushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.stems_mode";    to: "decks.2.tempo_bend.up"; enabled: module.stemsModePushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.stems_mode";    to: "decks.2.tempo_bend.down"; enabled: module.stemsModePushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.stems_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.2"; color: Color.Blue; value: true } enabled: module.stemsModeShiftPushAction == ButtonsActions.select_stems_mode }
      Wire { from: "%surface%.stems_mode";    to: "decks.2.transport.cue";  enabled: module.stemsModeShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.stems_mode";    to: "decks.2.transport.play"; enabled: module.stemsModeShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.stems_mode";    to: "decks.2.transport.sync"; enabled: module.stemsModeShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.stems_mode";    to: "decks.2.transport.return_to_zero";  enabled: module.stemsModeShiftPushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.stems_mode";    to: "decks.2.tempo_bend.up"; enabled: module.stemsModeShiftPushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.stems_mode";    to: "decks.2.tempo_bend.down"; enabled: module.stemsModeShiftPushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.channel_fx.on";    to: "decks.2.transport.cue";  enabled: module.channelFxPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.2.transport.play"; enabled: module.channelFxPushAction == ButtonsActions.play }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.2.transport.sync"; enabled: module.channelFxPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.2.transport.return_to_zero";  enabled: module.channelFxPushAction == ButtonsActions.skip_to_start  }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.channel_fx.on";    to: "decks.2.transport.cue";  enabled: module.channelFxShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.2.transport.play"; enabled: module.channelFxShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.2.transport.sync"; enabled: module.channelFxShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.2.transport.return_to_zero";  enabled: module.channelFxShiftPushAction == ButtonsActions.skip_to_start  }
    }

    // EQ Mode
    WiresGroup
    {
      enabled: !module.channel_mode_2

      Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.gain";    ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.high"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.mid";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    }

    // Stems mode
    WiresGroup
    {
      enabled: module.channel_mode_2

      Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.2.stems.1.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.2.stems.2.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.2.stems.3.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.2.stems.4.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.cue";    to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.cue"; color: Color.Blue } enabled: module.prelistenPushAction == ButtonsActions.prelisten }
      Wire { from: "%surface%.cue";    to: "decks.2.transport.cue";  enabled: module.prelistenPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.cue";    to: "decks.2.transport.play"; enabled: module.prelistenPushAction == ButtonsActions.play }
      Wire { from: "%surface%.cue";    to: "decks.2.transport.sync"; enabled: module.prelistenPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.cue";    to: "decks.2.transport.return_to_zero";  enabled: module.prelistenPushAction == ButtonsActions.skip_to_start  }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.cue";    to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.cue"; color: Color.Blue } enabled: module.prelistenShiftPushAction == ButtonsActions.prelisten }
      Wire { from: "%surface%.cue";    to: "decks.2.transport.cue";  enabled: module.prelistenShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.cue";    to: "decks.2.transport.play"; enabled: module.prelistenShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.cue";    to: "decks.2.transport.sync"; enabled: module.prelistenShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.cue";    to: "decks.2.transport.return_to_zero";  enabled: module.prelistenShiftPushAction == ButtonsActions.skip_to_start  }
    }

    // Channel FX Amount
    Wire { from: "softtakeover5.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.adjust";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    // Volume Fader + Level meter
    Wire { from: "softtakeover_fader.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.volume";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    Wire { from: "level_meter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels.2.level.prefader.linear.sum"; input: false } }
  }

  // Deck C
  WiresGroup
  {
    enabled: module.deckIdx == 3

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.eq_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.3"; color: Color.Blue; value: false } enabled: module.eqModePushAction == ButtonsActions.select_eq_mode }
      Wire { from: "%surface%.eq_mode";    to: "decks.3.transport.cue";  enabled: module.eqModePushAction == ButtonsActions.cue }
      Wire { from: "%surface%.eq_mode";    to: "decks.3.transport.play"; enabled: module.eqModePushAction == ButtonsActions.play }
      Wire { from: "%surface%.eq_mode";    to: "decks.3.transport.sync"; enabled: module.eqModePushAction == ButtonsActions.sync }
      Wire { from: "%surface%.eq_mode";    to: "decks.3.transport.return_to_zero";  enabled: module.eqModePushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.eq_mode";    to: "decks.3.tempo_bend.up"; enabled: module.eqModePushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.eq_mode";    to: "decks.3.tempo_bend.down"; enabled: module.eqModePushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.eq_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.3"; color: Color.Blue; value: false } enabled: module.eqModeShiftPushAction == ButtonsActions.select_eq_mode }
      Wire { from: "%surface%.eq_mode";    to: "decks.3.transport.cue";  enabled: module.eqModeShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.eq_mode";    to: "decks.3.transport.play"; enabled: module.eqModeShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.eq_mode";    to: "decks.3.transport.sync"; enabled: module.eqModeShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.eq_mode";    to: "decks.3.transport.return_to_zero";  enabled: module.eqModeShiftPushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.eq_mode";    to: "decks.3.tempo_bend.up"; enabled: module.eqModeShiftPushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.eq_mode";    to: "decks.3.tempo_bend.down"; enabled: module.eqModeShiftPushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.stems_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.3"; color: Color.Blue; value: true } enabled: module.stemsModePushAction == ButtonsActions.select_stems_mode }
      Wire { from: "%surface%.stems_mode";    to: "decks.3.transport.cue";  enabled: module.stemsModePushAction == ButtonsActions.cue }
      Wire { from: "%surface%.stems_mode";    to: "decks.3.transport.play"; enabled: module.stemsModePushAction == ButtonsActions.play }
      Wire { from: "%surface%.stems_mode";    to: "decks.3.transport.sync"; enabled: module.stemsModePushAction == ButtonsActions.sync }
      Wire { from: "%surface%.stems_mode";    to: "decks.3.transport.return_to_zero";  enabled: module.stemsModePushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.stems_mode";    to: "decks.3.tempo_bend.up"; enabled: module.stemsModePushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.stems_mode";    to: "decks.3.tempo_bend.down"; enabled: module.stemsModePushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.stems_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.3"; color: Color.Blue; value: true } enabled: module.stemsModeShiftPushAction == ButtonsActions.select_stems_mode }
      Wire { from: "%surface%.stems_mode";    to: "decks.3.transport.cue";  enabled: module.stemsModeShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.stems_mode";    to: "decks.3.transport.play"; enabled: module.stemsModeShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.stems_mode";    to: "decks.3.transport.sync"; enabled: module.stemsModeShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.stems_mode";    to: "decks.3.transport.return_to_zero";  enabled: module.stemsModeShiftPushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.stems_mode";    to: "decks.3.tempo_bend.up"; enabled: module.stemsModeShiftPushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.stems_mode";    to: "decks.3.tempo_bend.down"; enabled: module.stemsModeShiftPushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.channel_fx.on";    to: "decks.3.transport.cue";  enabled: module.channelFxPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.3.transport.play"; enabled: module.channelFxPushAction == ButtonsActions.play }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.3.transport.sync"; enabled: module.channelFxPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.3.transport.return_to_zero";  enabled: module.channelFxPushAction == ButtonsActions.skip_to_start  }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.channel_fx.on";    to: "decks.3.transport.cue";  enabled: module.channelFxShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.3.transport.play"; enabled: module.channelFxShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.3.transport.sync"; enabled: module.channelFxShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.3.transport.return_to_zero";  enabled: module.channelFxShiftPushAction == ButtonsActions.skip_to_start  }
    }

    // EQ Mode
    WiresGroup
    {
      enabled: !module.channel_mode_3

      Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.gain";    ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.high"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.mid";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    }

    // Stems mode
    WiresGroup
    {
      enabled: module.channel_mode_3

      Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.3.stems.1.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.3.stems.2.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.3.stems.3.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.3.stems.4.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.cue";    to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.cue"; color: Color.Blue } enabled: module.prelistenPushAction == ButtonsActions.prelisten }
      Wire { from: "%surface%.cue";    to: "decks.3.transport.cue";  enabled: module.prelistenPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.cue";    to: "decks.3.transport.play"; enabled: module.prelistenPushAction == ButtonsActions.play }
      Wire { from: "%surface%.cue";    to: "decks.3.transport.sync"; enabled: module.prelistenPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.cue";    to: "decks.3.transport.return_to_zero";  enabled: module.prelistenPushAction == ButtonsActions.skip_to_start  }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.cue";    to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.cue"; color: Color.Blue } enabled: module.prelistenShiftPushAction == ButtonsActions.prelisten }
      Wire { from: "%surface%.cue";    to: "decks.3.transport.cue";  enabled: module.prelistenShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.cue";    to: "decks.3.transport.play"; enabled: module.prelistenShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.cue";    to: "decks.3.transport.sync"; enabled: module.prelistenShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.cue";    to: "decks.3.transport.return_to_zero";  enabled: module.prelistenShiftPushAction == ButtonsActions.skip_to_start  }
    }

    // Channel FX Amount
    Wire { from: "softtakeover5.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.adjust";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    // Volume Fader + Level meter
    Wire { from: "softtakeover_fader.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.volume";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    Wire { from: "level_meter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels.3.level.prefader.linear.sum"; input: false } }
  }

  // Deck D
  WiresGroup
  {
    enabled: module.deckIdx == 4

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.eq_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.4"; color: Color.Blue; value: false } enabled: module.eqModePushAction == ButtonsActions.select_eq_mode }
      Wire { from: "%surface%.eq_mode";    to: "decks.4.transport.cue";  enabled: module.eqModePushAction == ButtonsActions.cue }
      Wire { from: "%surface%.eq_mode";    to: "decks.4.transport.play"; enabled: module.eqModePushAction == ButtonsActions.play }
      Wire { from: "%surface%.eq_mode";    to: "decks.4.transport.sync"; enabled: module.eqModePushAction == ButtonsActions.sync }
      Wire { from: "%surface%.eq_mode";    to: "decks.4.transport.return_to_zero";  enabled: module.eqModePushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.eq_mode";    to: "decks.4.tempo_bend.up"; enabled: module.eqModePushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.eq_mode";    to: "decks.4.tempo_bend.down"; enabled: module.eqModePushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.eq_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.4"; color: Color.Blue; value: false } enabled: module.eqModeShiftPushAction == ButtonsActions.select_eq_mode }
      Wire { from: "%surface%.eq_mode";    to: "decks.4.transport.cue";  enabled: module.eqModeShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.eq_mode";    to: "decks.4.transport.play"; enabled: module.eqModeShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.eq_mode";    to: "decks.4.transport.sync"; enabled: module.eqModeShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.eq_mode";    to: "decks.4.transport.return_to_zero";  enabled: module.eqModeShiftPushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.eq_mode";    to: "decks.4.tempo_bend.up"; enabled: module.eqModeShiftPushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.eq_mode";    to: "decks.4.tempo_bend.down"; enabled: module.eqModeShiftPushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.stems_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.4"; color: Color.Blue; value: true } enabled: module.stemsModePushAction == ButtonsActions.select_stems_mode }
      Wire { from: "%surface%.stems_mode";    to: "decks.4.transport.cue";  enabled: module.stemsModePushAction == ButtonsActions.cue }
      Wire { from: "%surface%.stems_mode";    to: "decks.4.transport.play"; enabled: module.stemsModePushAction == ButtonsActions.play }
      Wire { from: "%surface%.stems_mode";    to: "decks.4.transport.sync"; enabled: module.stemsModePushAction == ButtonsActions.sync }
      Wire { from: "%surface%.stems_mode";    to: "decks.4.transport.return_to_zero";  enabled: module.stemsModePushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.stems_mode";    to: "decks.4.tempo_bend.up"; enabled: module.stemsModePushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.stems_mode";    to: "decks.4.tempo_bend.down"; enabled: module.stemsModePushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.stems_mode";    to: SetPropertyAdapter { path: module.propertiesPath + ".channel_mode.4"; color: Color.Blue; value: true } enabled: module.stemsModeShiftPushAction == ButtonsActions.select_stems_mode }
      Wire { from: "%surface%.stems_mode";    to: "decks.4.transport.cue";  enabled: module.stemsModeShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.stems_mode";    to: "decks.4.transport.play"; enabled: module.stemsModeShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.stems_mode";    to: "decks.4.transport.sync"; enabled: module.stemsModeShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.stems_mode";    to: "decks.4.transport.return_to_zero";  enabled: module.stemsModeShiftPushAction == ButtonsActions.skip_to_start  }
      Wire { from: "%surface%.stems_mode";    to: "decks.4.tempo_bend.up"; enabled: module.stemsModeShiftPushAction == ButtonsActions.nudge_fwd }
      Wire { from: "%surface%.stems_mode";    to: "decks.4.tempo_bend.down"; enabled: module.stemsModeShiftPushAction == ButtonsActions.nudge_bwd }
    }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.channel_fx.on";    to: "decks.4.transport.cue";  enabled: module.channelFxPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.4.transport.play"; enabled: module.channelFxPushAction == ButtonsActions.play }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.4.transport.sync"; enabled: module.channelFxPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.4.transport.return_to_zero";  enabled: module.channelFxPushAction == ButtonsActions.skip_to_start  }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.channel_fx.on";    to: "decks.4.transport.cue";  enabled: module.channelFxShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.4.transport.play"; enabled: module.channelFxShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.4.transport.sync"; enabled: module.channelFxShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.channel_fx.on";    to: "decks.4.transport.return_to_zero";  enabled: module.channelFxShiftPushAction == ButtonsActions.skip_to_start  }
    }

    // EQ Mode
    WiresGroup
    {
      enabled: !module.channel_mode_4

      Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.gain";    ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.high"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.mid";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    }

    // Stems mode
    WiresGroup
    {
      enabled: module.channel_mode_4

      Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.4.stems.1.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.4.stems.2.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.4.stems.3.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
      Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.4.stems.4.volume"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.cue";    to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.cue"; color: Color.Blue } enabled: module.prelistenPushAction == ButtonsActions.prelisten }
      Wire { from: "%surface%.cue";    to: "decks.4.transport.cue";  enabled: module.prelistenPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.cue";    to: "decks.4.transport.play"; enabled: module.prelistenPushAction == ButtonsActions.play }
      Wire { from: "%surface%.cue";    to: "decks.4.transport.sync"; enabled: module.prelistenPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.cue";    to: "decks.4.transport.return_to_zero";  enabled: module.prelistenPushAction == ButtonsActions.skip_to_start  }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.cue";    to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.cue"; color: Color.Blue } enabled: module.prelistenShiftPushAction == ButtonsActions.prelisten }
      Wire { from: "%surface%.cue";    to: "decks.4.transport.cue";  enabled: module.prelistenShiftPushAction == ButtonsActions.cue }
      Wire { from: "%surface%.cue";    to: "decks.4.transport.play"; enabled: module.prelistenShiftPushAction == ButtonsActions.play }
      Wire { from: "%surface%.cue";    to: "decks.4.transport.sync"; enabled: module.prelistenShiftPushAction == ButtonsActions.sync }
      Wire { from: "%surface%.cue";    to: "decks.4.transport.return_to_zero";  enabled: module.prelistenShiftPushAction == ButtonsActions.skip_to_start  }
    }

    // Channel FX Amount
    Wire { from: "softtakeover5.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.adjust";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    // Volume Fader + Level meter
    Wire { from: "softtakeover_fader.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.volume";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    Wire { from: "level_meter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels.4.level.prefader.linear.sum"; input: false } }
  }

  // Bottom LEDs
  AppProperty { id: inActiveLoopProp; path: "app.traktor.decks." + module.deckIdx + ".loop.is_in_active_loop" }
  AppProperty { id: endWarningProp; path: "app.traktor.decks." + module.deckIdx + ".track.track_end_warning" }

  AppProperty { id: syncProp; path: "app.traktor.decks." + module.deckIdx + ".sync.enabled" }
  AppProperty { id: phaseProp; path: "app.traktor.decks." + module.deckIdx + ".tempo.phase" }

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

  Wire { from: "%surface%.bottom.leds";  to: "loop_lighter"; enabled: shouldShowActiveLoop }
  Wire { from: "%surface%.bottom.leds";  to: "warning_blinker"; enabled: shouldShowEndWarning && !shouldShowActiveLoop }
  Wire { from: "%surface%.bottom.leds";  to: "sync_lighter"; enabled: shouldShowSyncWarning && !shouldShowEndWarning && !shouldShowActiveLoop }

  WiresGroup
  {
    enabled: !shouldShowSyncWarning && !shouldShowEndWarning && !shouldShowActiveLoop

    Wire { from: "%surface%.bottom.leds"; to: "default_lighter"; enabled: module.bottomLedsDefaultColor != Color.White }

    WiresGroup
    {
      enabled: module.bottomLedsDefaultColor == Color.White
  
      Wire { from: "%surface%.bottom.leds.1"; to: "rainbow_lighter_1" }
      Wire { from: "%surface%.bottom.leds.2"; to: "rainbow_lighter_2" }
      Wire { from: "%surface%.bottom.leds.3"; to: "rainbow_lighter_3" }
      Wire { from: "%surface%.bottom.leds.4"; to: "rainbow_lighter_4" }
      Wire { from: "%surface%.bottom.leds.5"; to: "rainbow_lighter_5" }
      Wire { from: "%surface%.bottom.leds.6"; to: "rainbow_lighter_6" }
    }
  }
}
