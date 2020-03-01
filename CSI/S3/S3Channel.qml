import CSI 1.0

Module
{
  id: module
  property int index: 1

  // helpers
  readonly property string surface_prefix: "s3.mixer.channels." + (module.index) + "."
  readonly property string app_prefix: "app.traktor.mixer.channels." + (module.index) + "."

  LEDLevelMeter { name: "meter"; segments: 15 }
  Wire { from: surface_prefix + "level_meter"; to: "meter" }
  Wire { from: "meter.level"; to: DirectPropertyAdapter { path: app_prefix + "level.prefader.linear.meter"; input: false } }

  // channel strip
  Wire { from: surface_prefix + "volume";               to: DirectPropertyAdapter { path: app_prefix + "volume"              } }
  Wire { from: surface_prefix + "gain";                 to: DirectPropertyAdapter { path: app_prefix + "gain"                } }
  Wire { from: surface_prefix + "eq.high";              to: DirectPropertyAdapter { path: app_prefix + "eq.high"             } }
  Wire { from: surface_prefix + "eq.mid";               to: DirectPropertyAdapter { path: app_prefix + "eq.mid"              } }
  Wire { from: surface_prefix + "eq.low";               to: DirectPropertyAdapter { path: app_prefix + "eq.low"              } }
  Wire { from: surface_prefix + "cue";                  to: TogglePropertyAdapter { path: app_prefix + "cue"                 } }

  Wire { from: surface_prefix + "channel_fx.amount"; to: DirectPropertyAdapter { path: app_prefix + "fx.adjust"; }}
}
