enum Hold {
  FULL_CRIMP,
  HALF_CRIMP,
  JUGS,
  OPEN_HAND,
  WIDE_PINCH,
  MEDIUM_PINCH,
  NARROW_PINCH,
  POCKET,
  SLOPER,
}

extension HoldExtension on Hold {
  String get name {
    switch(this) {
      case Hold.FULL_CRIMP:
        return 'Full Crimp';
      case Hold.HALF_CRIMP:
        return 'Half Crimp';
      case Hold.JUGS:
        return 'Jugs';
      case Hold.OPEN_HAND:
        return 'Open Hand';
      case Hold.WIDE_PINCH:
        return 'Wide Pinch';
      case Hold.MEDIUM_PINCH:
        return 'Medium Pinch';
      case Hold.NARROW_PINCH:
        return 'Narrow Pinch';
      case Hold.POCKET:
        return 'Pocket';
      case Hold.SLOPER:
        return 'Sloper';
      default:
        return null;
    }
  }
}