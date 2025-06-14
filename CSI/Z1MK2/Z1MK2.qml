import CSI 1.0

import "Defines"

Mapping
{
  id: mapping
  readonly property string propertiesPath: "mapping.state"

  MappingPropertyDescriptor {
    id: deckAssignmentProp
    type: MappingPropertyDescriptor.Integer
    path: mapping.propertiesPath + ".deck_assignment"

    value: DeviceAssignment.decks_a_b
    min:   DeviceAssignment.decks_a_b
    max:   DeviceAssignment.decks_c_d
  }

  readonly property int leftDeckIdx: DeviceAssignment.leftDeckIdx(deckAssignmentProp.value)
  MappingPropertyDescriptor { path: mapping.propertiesPath + ".left_deck_index"; type: MappingPropertyDescriptor.Integer; value: mapping.leftDeckIdx }

  readonly property int rightDeckIdx: DeviceAssignment.rightDeckIdx(deckAssignmentProp.value)
  MappingPropertyDescriptor { path: mapping.propertiesPath + ".right_deck_index"; type: MappingPropertyDescriptor.Integer; value: mapping.rightDeckIdx }

  Z1MK2 { name: "surface" }

  Wire { from: "surface.mode"; to: RelativePropertyAdapter { path: mapping.propertiesPath + ".deck_assignment"; mode: RelativeMode.Increment; wrap: true } }

  Z1MK2Side
  {
    name: "left"
    deckIdx: mapping.leftDeckIdx
    surface: "surface.left"
    propertiesPath: mapping.propertiesPath + ".left"

    shift: mapping.shift
    eqModePushAction: eqModePushActionProp.value
    eqModeShiftPushAction: eqModeShiftPushActionProp.value
    stemsModePushAction: stemsModePushActionProp.value
    stemsModeShiftPushAction: stemsModeShiftPushActionProp.value
    channelFxPushAction: channelFxPushActionProp.value
    channelFxShiftPushAction: channelFxShiftPushActionProp.value
    prelistenPushAction: prelistenPushActionProp.value
    prelistenShiftPushAction: prelistenShiftPushActionProp.value

    showEndWarning: showEndWarningProp.value
    showSyncWarning: showSyncWarningProp.value
    showActiveLoop: showActiveLoopProp.value
    bottomLedsDefaultColor: bottomLedsDefaultColorProp.value
  }

  Z1MK2Side
  {
    name: "right"
    deckIdx: mapping.rightDeckIdx
    surface: "surface.right"
    propertiesPath: mapping.propertiesPath + ".right"

    shift: mapping.shift
    eqModePushAction: eqModePushActionProp.value
    eqModeShiftPushAction: eqModeShiftPushActionProp.value
    stemsModePushAction: stemsModePushActionProp.value
    stemsModeShiftPushAction: stemsModeShiftPushActionProp.value
    channelFxPushAction: channelFxPushActionProp.value
    channelFxShiftPushAction: channelFxShiftPushActionProp.value
    prelistenPushAction: prelistenPushActionProp.value
    prelistenShiftPushAction: prelistenShiftPushActionProp.value

    showEndWarning: showEndWarningProp.value
    showSyncWarning: showSyncWarningProp.value
    showActiveLoop: showActiveLoopProp.value
    bottomLedsDefaultColor: bottomLedsDefaultColorProp.value
  }

  Z1MK2FXSelector
  {
    name: "channel_fx_selector"
    surface: "surface"
    leftDeckIdx: mapping.leftDeckIdx
    rightDeckIdx: mapping.rightDeckIdx

    shift: mapping.shift
    filterPushAction: filterPushActionProp.value
    channelFxPushAction: channelFxPushActionProp.value
    channelFxShiftPushAction: channelFxShiftPushActionProp.value
  }

  Wire { from: "surface.center.crossfader";         to: DirectPropertyAdapter { path: "app.traktor.mixer.xfader.adjust"   } }
  Wire { from: "surface.center.main";               to: DirectPropertyAdapter { path: "app.traktor.mixer.master_volume"   } }
  Wire { from: "surface.center.cue_mix";            to: DirectPropertyAdapter { path: "app.traktor.mixer.cue.mix"         } }
  Wire { from: "surface.center.cue_vol";            to: DirectPropertyAdapter { path: "app.traktor.mixer.cue.volume"      } }

  KontrolScreen { name: "main_screen"; side: ScreenSide.Left; propertiesPath: mapping.propertiesPath; flavor: ScreenFlavor.Z1MK2_Main }
  Wire { from: "main_screen.output"; to: "surface.display.mode" }

  // Shift
  property alias shift: shiftProp.value
  MappingPropertyDescriptor { id: shiftProp; path: mapping.propertiesPath + ".shift"; type: MappingPropertyDescriptor.Boolean; value: false }

  Wire { from: "surface.center.channel_fx.filter"; to: DirectPropertyAdapter { path: mapping.propertiesPath + ".shift"; color: Color.Blue } enabled: filterPushActionProp.value == ButtonsActions.shift }

  // Settings
  MappingPropertyDescriptor { id: filterPushActionProp; path: "mapping.settings.filter_push_action"; type: MappingPropertyDescriptor.Integer; value: ButtonsActions.select_channel_fx_filter }

  MappingPropertyDescriptor { id: eqModePushActionProp; path: "mapping.settings.eq_mode_push_action"; type: MappingPropertyDescriptor.Integer; value: ButtonsActions.select_eq_mode }
  MappingPropertyDescriptor { id: eqModeShiftPushActionProp; path: "mapping.settings.eq_mode_shiftpush_action"; type: MappingPropertyDescriptor.Integer; value: ButtonsActions.select_eq_mode }
  MappingPropertyDescriptor { id: stemsModePushActionProp; path: "mapping.settings.stems_mode_push_action"; type: MappingPropertyDescriptor.Integer; value: ButtonsActions.select_stems_mode }
  MappingPropertyDescriptor { id: stemsModeShiftPushActionProp; path: "mapping.settings.stems_mode_shiftpush_action"; type: MappingPropertyDescriptor.Integer; value: ButtonsActions.select_stems_mode }

  MappingPropertyDescriptor { id: channelFxPushActionProp; path: "mapping.settings.channel_fx_push_action"; type: MappingPropertyDescriptor.Integer; value: ButtonsActions.toggle_channel_fx }
  MappingPropertyDescriptor { id: channelFxShiftPushActionProp; path: "mapping.settings.channel_fx_shiftpush_action"; type: MappingPropertyDescriptor.Integer; value: ButtonsActions.temporary_channel_fx }

  MappingPropertyDescriptor { id: prelistenPushActionProp; path: "mapping.settings.prelisten_push_action"; type: MappingPropertyDescriptor.Integer; value: ButtonsActions.prelisten }
  MappingPropertyDescriptor { id: prelistenShiftPushActionProp; path: "mapping.settings.prelisten_shiftpush_action"; type: MappingPropertyDescriptor.Integer; value: ButtonsActions.prelisten }

  // Color override
  MappingPropertyDescriptor { path: "mapping.settings.eq_mode_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.eq_mode.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.eq_mode_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.eq_mode.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.eq_mode_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.stems_mode_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.stems_mode.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.stems_mode_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.stems_mode.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.stems_mode_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.channel_fx_1_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.center.channel_fx.fx1.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.channel_fx_1_button.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.channel_fx_2_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.center.channel_fx.fx2.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.channel_fx_2_button.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.channel_fx_3_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.center.channel_fx.fx3.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.channel_fx_3_button.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.channel_fx_4_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.center.channel_fx.fx4.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.channel_fx_4_button.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.channel_fx_filter_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.center.channel_fx.filter.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.channel_fx_filter_button.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.channel_fx_on_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.channel_fx.on.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.channel_fx_on_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.channel_fx.on.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.channel_fx_on_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.cue_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.cue.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.cue_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.cue.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.cue_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { id: showEndWarningProp; path: "mapping.settings.bottom_leds.show_end_warning"; type: MappingPropertyDescriptor.Boolean; value: true }
  MappingPropertyDescriptor { id: showSyncWarningProp; path: "mapping.settings.bottom_leds.show_sync_warning"; type: MappingPropertyDescriptor.Boolean; value: true }
  MappingPropertyDescriptor { id: showActiveLoopProp; path: "mapping.settings.bottom_leds.show_active_loop"; type: MappingPropertyDescriptor.Boolean; value: true }
  MappingPropertyDescriptor { id: bottomLedsDefaultColorProp; path: "mapping.settings.bottom_leds.default_color"; type: MappingPropertyDescriptor.Integer; value: Color.Blue }
}
