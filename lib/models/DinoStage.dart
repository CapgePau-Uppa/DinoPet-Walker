enum DinoStage {
  bebe(
    id: 0,
    label: 'Bébé',
    imagePath: 'assets/images/dino_vert_bebe.png',
    height: 120.0,
  ),
  enfant(
    id: 1,
    label: 'Enfant',
    imagePath: 'assets/images/dino_vert_enfant.png',
    height: 150.0,
  ),
  adolescent(
    id: 2,
    label: 'Adolescent',
    imagePath: 'assets/images/dino_vert_adolescent.png',
    height: 180.0,
  ),
  adulte(
    id: 3,
    label: 'Adulte',
    imagePath: 'assets/images/dino_vert_adulte.png',
    height: 220.0,
  );

  final int id;
  final String label;
  final String imagePath;
  final double height;

  const DinoStage({
    required this.id,
    required this.label,
    required this.imagePath,
    required this.height,
  });

  static DinoStage getDinoStageFromLevel(int level) {
    if (level < 10) return DinoStage.bebe;
    if (level < 25) return DinoStage.enfant;
    if (level < 50) return DinoStage.adolescent;
    return DinoStage.adulte;
  }
}
