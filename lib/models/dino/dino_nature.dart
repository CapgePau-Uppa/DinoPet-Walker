enum Nature {
  terrestre,
  aquatic, 
  runner,    
  cyclist,   
  mountain,  
  warrior,   
  explorer,  
}

extension DinoNature on Nature {
  String get label {
    switch (this) {
      case Nature.aquatic:  return 'Aquatique';
      case Nature.runner:   return 'Coureur';
      case Nature.cyclist:  return 'Cycliste';
      case Nature.mountain: return 'Montagnard';
      case Nature.warrior:  return 'Guerrier';
      case Nature.explorer: return 'Explorateur';
      case Nature.terrestre:  return 'Terrestre';
    }
  }

}