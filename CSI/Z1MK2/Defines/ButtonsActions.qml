pragma Singleton

import QtQuick 2.0

// Constants for Hotcues Button actions
QtObject {
    readonly property int select_channel_fx_filter:   0
    readonly property int select_eq_mode:             1
    readonly property int select_stems_mode:          2
    readonly property int toggle_channel_fx:          3
    readonly property int temporary_channel_fx:       4
    readonly property int prelisten:                  5
    readonly property int shift:                      6
    readonly property int play:                       7
    readonly property int sync:                       8
    readonly property int cue:                        9
    readonly property int skip_to_start:             10
    readonly property int nudge_bwd:                 11
    readonly property int nudge_fwd:                 12
}
