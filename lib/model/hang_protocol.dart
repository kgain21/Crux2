enum HangProtocol {
  REPEATERS,
  MAX_HANGS,
  NO_HANGS,
  NONE
}

extension HangProtocolExtension on HangProtocol {
  String get name {
    switch(this) {
      case HangProtocol.REPEATERS:
        return 'Repeaters';
      case HangProtocol.MAX_HANGS:
        return 'Max Hangs';
      case HangProtocol.NO_HANGS:
        return 'No Hangs';
      case HangProtocol.NONE:
        return 'None';
      default:
        return null;
    }
  }
}