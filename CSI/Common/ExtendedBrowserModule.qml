import CSI 1.0
import "../../Defines"
import "DeckHelpers.js" as Helpers

// Module for browser components containing "Preview", "Favorite", "Preparation", and "View",
// along with an encoder for browsing.

Module
{
  id: module
  property string surface: ""
  property int deckIdx: 1
  property bool active: false

  // Settings ---------------------------
  property bool temporaryPreview: true
  property bool temporaryFullScreen: false

  // Encoder Modes ----------------------
  readonly property int listMode:           0
  readonly property int favoritesMode:      1
  readonly property int previewPlayerMode:  2
  readonly property int treeMode:           3
  // ------------------------------------
  property bool shift: false
  property int encoderMode: module.listMode
  // ------------------------------------

  // LED Brightness ----------------------
  readonly property real onBrightness:     1.0
  readonly property real dimmedBrightness: 0.0

  readonly property var deckColor: Helpers.colorForDeck(module.deckIdx)

  Browser {
    name: "browser"
    fullScreenColor: module.deckColor
    prepListColor: module.deckColor
  }
  ButtonGestures { name: "browser_load_gestures" }

  property bool showPreviewBlinker: false
  Blinker { name: "browser_preview_blinker"; cycle: 300; defaultBrightness: module.onBrightness; blinkBrightness: module.dimmedBrightness; color: module.deckColor; autorun: true }
  Lighter { name: "dimmed_lighter"; color: module.deckColor; brightness: module.dimmedBrightness }

  AppProperty { id: loadPreviewProp;    path: "app.traktor.browser.preview_player.load" }
  AppProperty { id: unloadPreviewProp;  path: "app.traktor.browser.preview_player.unload" }

  WiresGroup {

    enabled: module.active

    Wire { from: "%surface%.browse.view";         to: "browser.full_screen"; enabled: !module.temporaryFullScreen }
    Wire { from: "%surface%.browse.view";         to: "browser.temporary_full_screen"; enabled: module.temporaryFullScreen }

    Wire { from: "%surface%.browse.add_to_list";  to: "browser.jump_to_prep_list"; enabled: module.shift }
    Wire { from: "%surface%.browse.add_to_list";  to: "browser.add_remove_from_prep_list"; enabled: !module.shift }

    // enable favortie browsing
    Wire
    {
      from: "%surface%.browse.favorite"
      to: ButtonScriptAdapter
      {
        onPress:
        {
          if (module.encoderMode == module.listMode)
          {
            module.encoderMode = module.favoritesMode;
            brightness = module.onBrightness;
          }
        }
        onRelease:
        {
          if (module.encoderMode == module.favoritesMode)
          {
            module.encoderMode = module.listMode;
            brightness = module.dimmedBrightness;
          }
        }
        brightness: module.dimmedBrightness
        color: module.deckColor
      }
    }

    // Load/unload current track to preview play and enable encoder seek
    Wire
    {
      enabled: module.temporaryPreview

      from: "%surface%.browse.preview"
      to: ButtonScriptAdapter
      {
        onPress:
        {
          if (module.encoderMode == module.listMode)
          {
            loadPreviewProp.value = true;
            module.showPreviewBlinker = true;
            module.encoderMode = module.previewPlayerMode;
          }
        }
        onRelease:
        {
          if (module.encoderMode == module.previewPlayerMode)
          {
            unloadPreviewProp.value = true;
            module.showPreviewBlinker = false;
            module.encoderMode = module.listMode;
          }
        }
        output: false
      }
    }
    Wire
    {
      enabled: !module.temporaryPreview

      from: "%surface%.browse.preview"
      to: ButtonScriptAdapter
      {
        onPress:
        {
          if (module.encoderMode == module.listMode)
          {
            loadPreviewProp.value = true;
            module.showPreviewBlinker = true;
            module.encoderMode = module.previewPlayerMode;
          }
          else if (module.encoderMode == module.previewPlayerMode)
          {
            unloadPreviewProp.value = true;
            module.showPreviewBlinker = false;
            module.encoderMode = module.listMode;
          }
        }
        output: false
      }
    }

    Wire { from: "%surface%.browse.preview.led"; to: "dimmed_lighter"; enabled: !module.showPreviewBlinker }
    Wire { from: "%surface%.browse.preview.led"; to: "browser_preview_blinker"; enabled: module.showPreviewBlinker }

    // Shift
    Wire
    {
      from: "%surface%.shift"
      to: ButtonScriptAdapter
      {
        onPress:
        {
          module.shift = true;
          if (module.encoderMode == module.listMode)
          {
            module.encoderMode = module.treeMode;
          }
        }
        onRelease:
        {
          module.shift = false;
          if (module.encoderMode == module.treeMode)
          {
            module.encoderMode = module.listMode;
          }
        }
      }
    }

    // list mode
    WiresGroup
    {
      enabled: module.encoderMode == module.listMode

      Wire { from: "%surface%.browse.encoder"; to: "browser.list_navigation" }
      Wire { from: "%surface%.browse.encoder.push"; to: "browser_load_gestures.input" }
      Wire { from: "browser_load_gestures.single_click"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckIdx + ".load.selected"; output: false } }
      Wire { from: "browser_load_gestures.double_click"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckIdx + ".load_secondary.selected"; output: false } }
    }

    // favourites mode
    Wire
    {
      enabled: module.encoderMode == module.favoritesMode

      from: "%surface%.browse.encoder"
      to: "browser.favorites_navigation"
    }

    // tree mode
    Wire
    {
      enabled: module.encoderMode == module.treeMode

      from: "%surface%.browse.encoder"
      to: "browser.tree_navigation"
    }

    // preview mode
    Wire
    {
      enabled: module.encoderMode == module.previewPlayerMode

      from: "%surface%.browse.encoder"
      to: RelativePropertyAdapter { path: "app.traktor.browser.preview_player.seek"; step: 0.01; mode: RelativeMode.Stepped }
    }
  }
}
