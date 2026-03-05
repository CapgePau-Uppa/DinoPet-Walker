enum LifeStage {
  baby,
  child,
  teenager,
  adult;

  String get getName {
    switch (this) {
      case LifeStage.baby:
        return 'Bébé';
      case LifeStage.child:
        return 'Enfant';
      case LifeStage.teenager:
        return 'Adolescent';
      case LifeStage.adult:
        return 'Adulte';
    }
  }

  int get minLevel {
    switch (this) {
      case LifeStage.baby:
        return 1;
      case LifeStage.child:
        return 11;
      case LifeStage.teenager:
        return 26;
      case LifeStage.adult:
        return 41;
    }
  }

  int get maxLevel {
    switch (this) {
      case LifeStage.baby:
        return 10;
      case LifeStage.child:
        return 25;
      case LifeStage.teenager:
        return 40;
      case LifeStage.adult:
        return 50;
    }
  }

  LifeStage? get nextStage {
    if (this == LifeStage.adult) return null;
    return LifeStage.values[index + 1];
  }
}
