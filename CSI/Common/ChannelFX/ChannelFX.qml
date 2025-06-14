import CSI 1.0
import "../../../Defines"

Module
{
  id: module
  property bool active: false
  property bool momentary: false
  property int index: 1
  property alias selectedFx: fxSelect
  property int channelFxSelectorVal: -1
  property string surface_mixer_channel: ""

  signal fxChanged()

  // helpers
  readonly property string app_prefix: "app.traktor.mixer.channels." + module.index + "."

  AppProperty { id: fxSelect; path: app_prefix + "fx.select"; }
  AppProperty { id: fxOn;     path: app_prefix + "fx.on" }

  readonly property variant currentColor: colorScheme[fxSelect.value]

  WiresGroup
  {
    enabled: module.active

    // Channel FX Enable
    Wire
    {
      enabled: !module.momentary && (module.channelFxSelectorVal == -1);
      from: module.surface_mixer_channel + ".channel_fx.on";
      to: TogglePropertyAdapter
      {
        path: app_prefix + "fx.on";
        color: module.currentColor;
      }
    }
    Wire
    {
      enabled: module.momentary && (module.channelFxSelectorVal == -1);
      from: module.surface_mixer_channel + ".channel_fx.on";
      to: HoldPropertyAdapter
      {
        path: app_prefix + "fx.on";
        color: module.currentColor;
      }
    }

    Wire
    {
      enabled: module.channelFxSelectorVal != -1;
      from: module.surface_mixer_channel + ".channel_fx.on";
      to: ButtonScriptAdapter
      {
        onPress :
        {
          module.selectedFx.value = module.channelFxSelectorVal;
          fxChanged();
        }
        color: module.currentColor;
        brightness: fxOn.value ? 1.0 : 0.5
      }
    }
  }
}
