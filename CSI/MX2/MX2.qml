import CSI 1.0
import "../Common/ChannelFX"

Mapping
{
  id: mapping

  MX2 { name: "surface" }

  Wire { from: "surface.mixer.main.volume"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master_volume" } }
  Wire { from: "surface.mixer.main.clip"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.sum" } }

  Wire { from: "surface.mixer.cue_mix"; to: DirectPropertyAdapter { path: "app.traktor.mixer.cue.mix" } }
  Wire { from: "surface.mixer.cue_vol"; to: DirectPropertyAdapter { path: "app.traktor.mixer.cue.volume" } }
  Wire { from: "surface.mixer.xfader"; to: DirectPropertyAdapter { path: "app.traktor.mixer.xfader.adjust" } }

  MX2Channel { name: "channel1"; index: 1 }
  MX2Channel { name: "channel2"; index: 2 }
  TwoChannelFXSelector
  {
    name: "channel_fx_selector"
    surface: "surface"
    momentaryButtons: mixerEffectsTemporaryProp.value
  }

  Wire 
  { 
    from: "surface.mixer.mic"; 
    to: TogglePropertyAdapter { path: "app.traktor.mixer.mic_volume"; value: VolumeLevels.volumeZeroDb; defaultValue: VolumeLevels.minusInfDb } 
  }

  MX2Deck {
    name: "deck_a"
    index: 1
    surface_prefix: "surface.left"
    propertiesPath: "mapping.state.left"
    temporaryPreview: previewPlayerTemporaryProp.value
    temporaryFullScreen: viewSwitchTemporaryProp.value

    showEndWarning: showEndWarningProp.value
    showSyncWarning: showSyncWarningProp.value
    showActiveLoop: showActiveLoopProp.value
    bottomLedsDefaultColor: bottomLedsDefaultColorProp.value
  }
  MX2Deck {
    name: "deck_b"
    index: 2
    surface_prefix: "surface.right"
    propertiesPath: "mapping.state.right"
    temporaryPreview: previewPlayerTemporaryProp.value
    temporaryFullScreen: viewSwitchTemporaryProp.value

    showEndWarning: showEndWarningProp.value
    showSyncWarning: showSyncWarningProp.value
    showActiveLoop: showActiveLoopProp.value
    bottomLedsDefaultColor: bottomLedsDefaultColorProp.value
  }

  MappingPropertyDescriptor { path: "mapping.settings.tempo_fader_relative"; type: MappingPropertyDescriptor.Boolean; value: false; }
  MappingPropertyDescriptor { id: mixerEffectsTemporaryProp; path: "mapping.settings.mixer_effects_temporary"; type: MappingPropertyDescriptor.Boolean; value: false; }
  MappingPropertyDescriptor { id: previewPlayerTemporaryProp; path: "mapping.settings.preview_player_temporary"; type: MappingPropertyDescriptor.Boolean; value: false; }
  MappingPropertyDescriptor { id: viewSwitchTemporaryProp; path: "mapping.settings.view_switch_temporary"; type: MappingPropertyDescriptor.Boolean; value: false; }

  // Color override
  MappingPropertyDescriptor { path: "mapping.settings.play_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.play.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.play_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.play.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.play_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.cue_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.cue.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.cue_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.cue.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.cue_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.key_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.key_lock.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.key_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.key_lock.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.key_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.sync_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.sync.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.sync_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.sync.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.sync_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.reverse_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.reverse.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.reverse_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.reverse.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.reverse_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.master_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.master.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.master_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.master.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.master_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.flux_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.flux.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.flux_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.flux.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.flux_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.ttmode_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.mode.turntable.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.ttmode_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.mode.turntable.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.ttmode_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.jogmode_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.mode.jogwheel.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.jogmode_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.mode.jogwheel.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.jogmode_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.hotcues_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.hotcues.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.hotcues_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.hotcues.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.hotcues_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.stems_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.stems.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.stems_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.stems.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.stems_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.pattern_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.pattern.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.pattern_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.pattern.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.pattern_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.loops_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.flux_loop.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.loops_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.flux_loop.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.loops_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.favorites_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.browse.favorite.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.favorites_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.browse.favorite.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.favorites_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.star_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.browse.add_to_list.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.star_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.browse.add_to_list.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.star_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.preview_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.browse.preview.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.preview_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.browse.preview.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.preview_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.view_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.browse.view.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.view_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.browse.view.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.view_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.assign_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.mixer.channels.1.deck_fx_assign.1.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.assign_buttons.custom_color"; input: false } }
  Wire { from: "surface.mixer.channels.1.deck_fx_assign.2.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.assign_buttons.custom_color"; input: false } }
  Wire { from: "surface.mixer.channels.2.deck_fx_assign.1.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.assign_buttons.custom_color"; input: false } }  
  Wire { from: "surface.mixer.channels.2.deck_fx_assign.2.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.assign_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.deck_unit_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.fx.buttons.1.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.deck_unit_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.fx.buttons.2.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.deck_unit_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.fx.buttons.3.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.deck_unit_buttons.custom_color"; input: false } }  
  Wire { from: "surface.left.fx.buttons.4.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.deck_unit_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.fx.buttons.1.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.deck_unit_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.fx.buttons.2.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.deck_unit_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.fx.buttons.3.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.deck_unit_buttons.custom_color"; input: false } }  
  Wire { from: "surface.right.fx.buttons.4.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.deck_unit_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.channel_fx_1_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.mixer.channel_fx.fx1.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.channel_fx_1_button.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.channel_fx_2_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.mixer.channel_fx.fx2.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.channel_fx_2_button.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.channel_fx_3_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.mixer.channel_fx.fx3.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.channel_fx_3_button.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.channel_fx_4_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.mixer.channel_fx.fx4.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.channel_fx_4_button.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.channel_fx_filter_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.mixer.channel_fx.filter.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.channel_fx_filter_button.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.channel_fx_on_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.mixer.channels.1.channel_fx.on.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.channel_fx_on_buttons.custom_color"; input: false } }
  Wire { from: "surface.mixer.channels.2.channel_fx.on.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.channel_fx_on_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.prelisten_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.mixer.channels.1.cue.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.prelisten_buttons.custom_color"; input: false } }
  Wire { from: "surface.mixer.channels.2.cue.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.prelisten_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.microphone_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.mixer.mic.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.microphone_button.custom_color"; input: false } }

  MappingPropertyDescriptor { id: showEndWarningProp; path: "mapping.settings.bottom_leds.show_end_warning"; type: MappingPropertyDescriptor.Boolean; value: true }
  MappingPropertyDescriptor { id: showSyncWarningProp; path: "mapping.settings.bottom_leds.show_sync_warning"; type: MappingPropertyDescriptor.Boolean; value: true }
  MappingPropertyDescriptor { id: showActiveLoopProp; path: "mapping.settings.bottom_leds.show_active_loop"; type: MappingPropertyDescriptor.Boolean; value: true }
  MappingPropertyDescriptor { id: bottomLedsDefaultColorProp; path: "mapping.settings.bottom_leds.default_color"; type: MappingPropertyDescriptor.Integer; value: Color.Blue }
}
