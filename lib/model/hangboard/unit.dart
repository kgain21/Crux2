enum ResistanceUnit {
  KILOGRAMS,
  POUNDS
}

extension ResistanceUnitExtension on ResistanceUnit {
  String get abbreviation {
    switch(this) {
      case ResistanceUnit.KILOGRAMS:
        return 'kg';
      case ResistanceUnit.POUNDS:
        return 'lb';
      default:
        return null;
    }
  }
  String get name {
    switch(this) {
      case ResistanceUnit.KILOGRAMS:
        return 'Kilograms';
      case ResistanceUnit.POUNDS:
        return 'Pounds';
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
  String get abbreviation {
    switch(this) {
      case DepthUnit.MILLIMETERS:
        return 'mm';
      case DepthUnit.INCHES:
        return 'in';
      default:
        return null;
    }
  }
  String get name {
    switch(this) {
      case DepthUnit.MILLIMETERS:
        return 'Millimeters';
      case DepthUnit.INCHES:
        return 'Inches';
      default:
        return null;
    }
  }
}