import CSI 1.0

Module
{
  id: module
  property int index: 1
  property string surface: ""

  property bool pressed: false
  property bool engaged: false

  AppProperty { id: keyLockProp; path: "app.traktor.decks." + module.index + ".track.key.lock_enabled" }

  Wire
  {
    from: "%surface%.key_lock"
    to: ButtonScriptAdapter {
      onPress: {
        module.engaged = true;
        module.pressed = true;
      }
      onRelease: {
        if (module.engaged)
        {
          keyLockProp.value = !keyLockProp.value;
        }
        module.pressed = false;
      }
      brightness: keyLockProp.value ? 1.0 : 0.0
      color: Color.Blue
    }
  }

  EncoderScriptAdapter { name: "detect_encoder_turn"; onTick: { module.engaged = false; } }
  ButtonScriptAdapter { name: "detect_encoder_push"; onPress: { module.engaged = false; } }
  RelativePropertyAdapter { name: "adjust_key"; path: "app.traktor.decks." + module.index + ".track.key.transpose"; mode: RelativeMode.Stepped; step: 1 }
  SetPropertyAdapter { name: "reset_key"; path: "app.traktor.decks." + module.index + ".track.key.adjust"; value: 0 }

  WiresGroup
  {
    enabled: module.pressed

    Wire { from: "%surface%.loop_size.turn"; to: "detect_encoder_turn" }
    Wire { from: "%surface%.loop_move.turn"; to: "detect_encoder_turn" }

    Wire { from: "%surface%.loop_size.push"; to: "detect_encoder_push" }
    Wire { from: "%surface%.loop_move.push"; to: "detect_encoder_push" }

    WiresGroup
    {
      enabled: keyLockProp.value

      Wire { from: "%surface%.loop_size.turn"; to: "adjust_key" }
      Wire { from: "%surface%.loop_move.turn"; to: "adjust_key" }

      Wire { from: "%surface%.loop_size.push"; to: "reset_key" }
      Wire { from: "%surface%.loop_move.push"; to: "reset_key" }
    }
  }
}
