enum FingerConfiguration {
  INDEX,
  MIDDLE,
  RING,
  PINKIE,
  INDEX_MIDDLE,
  MIDDLE_RING,
  RING_PINKIE,
  INDEX_MIDDLE_RING,
  MIDDLE_RING_PINKIE,
  INDEX_MIDDLE_RING_PINKIE,
}

extension FingerConfigurationExtension on FingerConfiguration {
  String get name {
    switch(this) {
      case FingerConfiguration.INDEX:
        return 'Index';
      case FingerConfiguration.MIDDLE:
        return 'Middle';
      case FingerConfiguration.RING:
        return 'Ring';
      case FingerConfiguration.PINKIE:
        return 'Pinkie';
      case FingerConfiguration.INDEX_MIDDLE:
        return 'Index/Middle';
      case FingerConfiguration.MIDDLE_RING:
        return 'Middle/Ring';
      case FingerConfiguration.RING_PINKIE:
        return 'Ring/Pinkie';
      case FingerConfiguration.INDEX_MIDDLE_RING:
        return 'Index/Middle/Ring';
      case FingerConfiguration.MIDDLE_RING_PINKIE:
        return 'Middle/Ring/Pinkie';
      case FingerConfiguration.INDEX_MIDDLE_RING_PINKIE:
        return 'Index/Middle/Ring/Pinkie';
      default:
        return null;
    }
  }

  String get abbreviation {
    switch(this) {
      case FingerConfiguration.INDEX:
        return 'I';
      case FingerConfiguration.MIDDLE:
        return 'M';
      case FingerConfiguration.RING:
        return 'R';
      case FingerConfiguration.PINKIE:
        return 'P';
      case FingerConfiguration.INDEX_MIDDLE:
        return 'I/M';
      case FingerConfiguration.MIDDLE_RING:
        return 'M/R';
      case FingerConfiguration.RING_PINKIE:
        return 'R/P';
      case FingerConfiguration.INDEX_MIDDLE_RING:
        return 'I/M/R';
      case FingerConfiguration.MIDDLE_RING_PINKIE:
        return 'M/R/P';
      case FingerConfiguration.INDEX_MIDDLE_RING_PINKIE:
        return 'I/M/R/P';
      default:
        return null;
    }
  }
}