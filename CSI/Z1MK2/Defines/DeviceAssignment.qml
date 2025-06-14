pragma Singleton

import QtQuick 2.0

QtObject {
  // Constants to describe deck pair assignments
  readonly property int decks_a_b: 0
  readonly property int decks_c_d: 1

  function leftDeckIdx(assignment)
  {
    switch (assignment)
    {
      case decks_a_b:
        return 1; // A

      case decks_c_d:
        return 3; // C
    }
  }

  function rightDeckIdx(assignment)
  {
    switch (assignment)
    {
      case decks_a_b:
        return 2; // B

      case decks_c_d:
        return 4; // D
    }
  }
} 
