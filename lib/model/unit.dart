enum ResistanceUnit {
  KILOGRAMS,
  POUNDS
}

extension ResistanceUnitExtension on ResistanceUnit {
  String get name {
    switch(this) {
      case ResistanceUnit.KILOGRAMS:
        return 'kg';
      case ResistanceUnit.POUNDS:
        return 'lb';
      default:
        return null;
    }
  }
}

enum DepthUnit {
  MILLIMETERS,
  INCHES
}

extension DepthUnitExtension on DepthUnit {
  String get name {
    switch(this) {
      case DepthUnit.MILLIMETERS:
        return 'mm';
      case DepthUnit.INCHES:
        return 'in';
      default:
        return null;
    }
  }
}