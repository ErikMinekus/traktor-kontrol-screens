import CSI 1.0

import "Defines"
import "../Common/ChannelFX"

Module
{
  id: module
  property bool cancelMultiSelection: false
  property int currentlySelectedFx: -1
  property string surface: ""
  property int leftDeckIdx: 0
  property int rightDeckIdx: 0

  property bool shift: false
  property int filterPushAction: 0
  property int channelFxPushAction: 0
  property int channelFxShiftPushAction: 0

  readonly property string fxSelectionPrefix: module.surface + ".center.channel_fx"

  // Mixer Effects Color Scheme
  readonly property variant colorScheme: [
    Color.LightOrange,  // Filter
    Color.Red,          // FX1
    Color.Green,        // FX2
    Color.Blue,         // FX3
    Color.Yellow        // FX4
  ]

  readonly property bool toggleButtons: (!module.shift && module.channelFxPushAction == ButtonsActions.toggle_channel_fx) || (module.shift && module.channelFxShiftPushAction == ButtonsActions.toggle_channel_fx)
  readonly property bool momentaryButtons: (!module.shift && module.channelFxPushAction == ButtonsActions.temporary_channel_fx) || (module.shift && module.channelFxShiftPushAction == ButtonsActions.temporary_channel_fx)

  ChannelFX
  {
    id: channel1
    active: (module.toggleButtons || module.momentaryButtons) && (module.leftDeckIdx == 1)
    momentary: module.momentaryButtons
    name: "channel1"
    surface_mixer_channel: module.surface + ".left"
    index: 1
    onFxChanged : { module.cancelMultiSelection = true; }
    channelFxSelectorVal: module.currentlySelectedFx
  }

  ChannelFX
  {
    id: channel2
    active: (module.toggleButtons || module.momentaryButtons) && (module.rightDeckIdx == 2)
    momentary: module.momentaryButtons
    name: "channel2"
    surface_mixer_channel: module.surface + ".right"
    index: 2
    onFxChanged : { module.cancelMultiSelection = true; }
    channelFxSelectorVal: module.currentlySelectedFx
  }

  ChannelFX
  {
    id: channel3
    active: (module.toggleButtons || module.momentaryButtons) && (module.leftDeckIdx == 3)
    momentary: module.momentaryButtons
    name: "channel3"
    surface_mixer_channel: module.surface + ".left"
    index: 3
    onFxChanged : { module.cancelMultiSelection = true; }
    channelFxSelectorVal: module.currentlySelectedFx
  }

  ChannelFX
  {
    id: channel4
    active: (module.toggleButtons || module.momentaryButtons) && (module.rightDeckIdx == 4)
    momentary: module.momentaryButtons
    name: "channel4"
    surface_mixer_channel: module.surface + ".right"
    index: 4
    onFxChanged : { module.cancelMultiSelection = true; }
    channelFxSelectorVal: module.currentlySelectedFx
  }

  function onFxSelectReleased(fxSelection)
  {
    if (!module.cancelMultiSelection)
    {
      channel1.selectedFx.value = fxSelection;
      channel2.selectedFx.value = fxSelection;
      channel3.selectedFx.value = fxSelection;
      channel4.selectedFx.value = fxSelection;
    }
    if (module.currentlySelectedFx == fxSelection)
      module.currentlySelectedFx = -1;
  }

  function onFxSelectPressed(fxSelection)
  {
    module.cancelMultiSelection = (module.currentlySelectedFx != -1);
    module.currentlySelectedFx = fxSelection;
  }

  function isFxUsed(index)
  {
    return channel1.selectedFx.value == index ||
           channel2.selectedFx.value == index ||
           channel3.selectedFx.value == index ||
           channel4.selectedFx.value == index;
  }

  Wire
  {
    from: module.fxSelectionPrefix + ".filter";
    to: ButtonScriptAdapter
    {
      onPress:
      {
        onFxSelectPressed(0)
      }
      onRelease:
      {
        onFxSelectReleased(0)
      }
      color: module.colorScheme[0]
      brightness: isFxUsed(0) ? 1.0 : 0.0
    }
    enabled: module.filterPushAction == ButtonsActions.select_channel_fx_filter
  }

  Wire
  {
    from: module.fxSelectionPrefix + ".fx1";
    to: ButtonScriptAdapter
    {
      onPress:
      {
        onFxSelectPressed(1)
      }
      onRelease:
      {
        onFxSelectReleased(1)
      }
      color: module.colorScheme[1]
      brightness: isFxUsed(1) ? 1.0 : 0.0
    }
  }

  Wire
  {
    from: module.fxSelectionPrefix + ".fx2";
    to: ButtonScriptAdapter
    {
      onPress:
      {
        onFxSelectPressed(2)
      }
      onRelease:
      {
        onFxSelectReleased(2)
      }
      color: module.colorScheme[2]
      brightness: isFxUsed(2) ? 1.0 : 0.0
    }
  }

  Wire
  {
    from: module.fxSelectionPrefix + ".fx3";
    to: ButtonScriptAdapter
    {
      onPress:
      {
        onFxSelectPressed(3)
      }
      onRelease:
      {
        onFxSelectReleased(3)
      }
      color: module.colorScheme[3]
      brightness: isFxUsed(3) ? 1.0 : 0.0
    }
  }

  Wire
  {
    from: module.fxSelectionPrefix + ".fx4";
    to: ButtonScriptAdapter
    {
      onPress:
      {
        onFxSelectPressed(4)
      }
      onRelease:
      {
        onFxSelectReleased(4)
      }
      color: module.colorScheme[4]
      brightness: isFxUsed(4) ? 1.0 : 0.0
    }
  }
}
