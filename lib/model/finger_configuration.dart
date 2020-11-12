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
}