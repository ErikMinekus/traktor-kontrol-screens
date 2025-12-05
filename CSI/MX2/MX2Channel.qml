import CSI 1.0

Module
{
  id: module
  property int index: 1

  readonly property string surface_prefix: "surface.mixer.channels." + module.index + "." 
  readonly property string app_prefix: "app.traktor.mixer.channels." + module.index + "."

  // LED Meters
  LEDLevelMeter { name: "meter"; segments: 9 } 
  Wire { from: surface_prefix + "level_meter"; to: "meter" }
  Wire { from: "meter.level"; to: DirectPropertyAdapter { path: app_prefix + "level.prefader.linear.meter"; input: false } }

  AppProperty { id: fxUnit1Type; path: "app.traktor.fx.1.type" }
  AppProperty { id: fxUnit2Type; path: "app.traktor.fx.2.type" }
  
  // Channel strip
  Wire { from: surface_prefix + "volume";               to: DirectPropertyAdapter { path: app_prefix + "volume"         } }
  Wire { from: surface_prefix + "gain";                 to: DirectPropertyAdapter { path: app_prefix + "gain"           } }
  Wire { from: surface_prefix + "eq.high";              to: DirectPropertyAdapter { path: app_prefix + "eq.high"        } }
  Wire { from: surface_prefix + "eq.mid";               to: DirectPropertyAdapter { path: app_prefix + "eq.mid"         } }
  Wire { from: surface_prefix + "eq.low";               to: DirectPropertyAdapter { path: app_prefix + "eq.low"         } }
  Wire { from: surface_prefix + "cue";                  to: TogglePropertyAdapter { path: app_prefix + "cue"            } }
  Wire { from: surface_prefix + "deck_fx_assign.1";     to: TogglePropertyAdapter { path: app_prefix + "fx.assign.1"; color: fxUnit1Type.value == FxType.PatternPlayer ? Color.Mint : Color.LightOrange } }
  Wire { from: surface_prefix + "deck_fx_assign.2";     to: TogglePropertyAdapter { path: app_prefix + "fx.assign.2"; color: fxUnit2Type.value == FxType.PatternPlayer ? Color.Mint : Color.LightOrange } }
}
