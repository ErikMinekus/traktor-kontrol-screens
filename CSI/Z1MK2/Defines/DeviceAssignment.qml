pragma Singleton

import CSI 1.0
import QtQuick 2.0

QtObject {

  function leftDeckIdx(assignment)
  {
    switch (assignment)
    {
      case DecksAssignment.AB:
        return 1; // A

      case DecksAssignment.CD:
        return 3; // C

      default:
        return 1; // A
    }
  }

  function rightDeckIdx(assignment)
  {
    switch (assignment)
    {
      case DecksAssignment.AB:
        return 2; // B

      case DecksAssignment.CD:
        return 4; // D

      default:
        return 2; // B
    }
  }
} 
