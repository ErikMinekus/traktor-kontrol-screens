import QtQuick 2.0

QtObject {

  function convertToTimeString(inSeconds)
  {
    var neg = (inSeconds < 0);
    var roundedSec = Math.floor(inSeconds);

    if (neg)
    {
      roundedSec = -roundedSec;
    }

    var sec = roundedSec % 60;
    var min = (roundedSec - sec) / 60;
      
    var secStr = sec.toString();
    if (sec < 10) secStr = "0" + secStr;
      
    var minStr = min.toString();
    if (min < 10) minStr = "0" + minStr;
    
    return (neg ? "-" : "") + minStr + ":" + secStr;
  }

  function computeRemainingTimeString(length, elapsed)
  {
    return ((elapsed > length) ? convertToTimeString(0) : convertToTimeString( Math.floor(elapsed) - Math.floor(length)));
  }
}
