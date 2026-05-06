import 'package:dinopet_walker/models/dino/dino_nature.dart';
import 'package:dinopet_walker/models/dino/dino_type.dart';
import 'package:dinopet_walker/models/dino/life_stage.dart';
import 'package:flutter/material.dart';

//ce fichier contient la liste de tous les DinoPet disponibles

final List<DinoType> availableDinos = [
  DinoType(
    id: 'rexy',
    name: 'Rexy',
    description: 'Un dinosaure bleu curieux et énergique qui adore explorer.',
    outColor: const Color(0xFFE0F2F1),
    innerColor: const Color(0xFFB2DFDB),
    assetPaths: {
      LifeStage.baby: {
        1: {
          Nature.terrestre:
              'assets/images/dinos/blue_dinos/baby/bleu_bebe_1.png',
          Nature.runner:
              'assets/images/dinos/blue_dinos/baby/runner/bleu_bebe_1_runner.png',
          Nature.aquatic:
              'assets/images/dinos/blue_dinos/baby/aquatic/bleu_bebe_1_aquatic.png',
          Nature.cyclist:
              'assets/images/dinos/blue_dinos/baby/cyclist/bleu_bebe_1_cyclist.png',
          Nature.mountain:
              'assets/images/dinos/blue_dinos/baby/mountain/bleu_bebe_1_mountain.png',
          Nature.warrior: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_1.png',
          Nature.explorer:
              'assets/images/dinos/blue_dinos/baby/bleu_bebe_1.png',
        },
        3: {
          Nature.terrestre:
              'assets/images/dinos/blue_dinos/baby/bleu_bebe_3.png',
          Nature.runner: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_3.png',
          Nature.aquatic: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_3.png',
          Nature.cyclist: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_3.png',
          Nature.mountain:
              'assets/images/dinos/blue_dinos/baby/bleu_bebe_3.png',
          Nature.warrior: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_3.png',
          Nature.explorer:
              'assets/images/dinos/blue_dinos/baby/bleu_bebe_3.png',
        },
        5: {
          Nature.terrestre:
              'assets/images/dinos/blue_dinos/baby/bleu_bebe_5.png',
          Nature.runner: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_5.png',
          Nature.aquatic: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_5.png',
          Nature.cyclist: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_5.png',
          Nature.mountain:
              'assets/images/dinos/blue_dinos/baby/bleu_bebe_5.png',
          Nature.warrior: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_5.png',
          Nature.explorer:
              'assets/images/dinos/blue_dinos/baby/bleu_bebe_5.png',
        },
        7: {
          Nature.terrestre:
              'assets/images/dinos/blue_dinos/baby/bleu_bebe_7.png',
          Nature.runner: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_7.png',
          Nature.aquatic: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_7.png',
          Nature.cyclist: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_7.png',
          Nature.mountain:
              'assets/images/dinos/blue_dinos/baby/bleu_bebe_7.png',
          Nature.warrior: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_7.png',
          Nature.explorer:
              'assets/images/dinos/blue_dinos/baby/bleu_bebe_7.png',
        },
        9: {
          Nature.terrestre:
              'assets/images/dinos/blue_dinos/baby/bleu_bebe_9.png',
          Nature.runner: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_9.png',
          Nature.aquatic: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_9.png',
          Nature.cyclist: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_9.png',
          Nature.mountain:
              'assets/images/dinos/blue_dinos/baby/bleu_bebe_9.png',
          Nature.warrior: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_9.png',
          Nature.explorer:
              'assets/images/dinos/blue_dinos/baby/bleu_bebe_9.png',
        },
      },
      LifeStage.child: {
        11: {
          Nature.terrestre:
              'assets/images/dinos/blue_dinos/child/bleu_child_11.png',
          Nature.runner:
              'assets/images/dinos/blue_dinos/child/bleu_child_11.png',
          Nature.aquatic:
              'assets/images/dinos/blue_dinos/child/bleu_child_11.png',
          Nature.cyclist:
              'assets/images/dinos/blue_dinos/child/bleu_child_11.png',
          Nature.mountain:
              'assets/images/dinos/blue_dinos/child/bleu_child_11.png',
          Nature.warrior:
              'assets/images/dinos/blue_dinos/child/bleu_child_11.png',
          Nature.explorer:
              'assets/images/dinos/blue_dinos/child/bleu_child_11.png',
        },
        24: {
          Nature.terrestre:
              'assets/images/dinos/blue_dinos/child/bleu_child_24.png',
          Nature.runner:
              'assets/images/dinos/blue_dinos/child/bleu_child_24.png',
          Nature.aquatic:
              'assets/images/dinos/blue_dinos/child/bleu_child_24.png',
          Nature.cyclist:
              'assets/images/dinos/blue_dinos/child/bleu_child_24.png',
          Nature.mountain:
              'assets/images/dinos/blue_dinos/child/bleu_child_24.png',
          Nature.warrior:
              'assets/images/dinos/blue_dinos/child/bleu_child_24.png',
          Nature.explorer:
              'assets/images/dinos/blue_dinos/child/bleu_child_24.png',
        },
      },
      LifeStage.teenager: {
        26: {
          Nature.terrestre:
              'assets/images/dinos/blue_dinos/ado/bleu_teen_26_39.png',
          Nature.runner:
              'assets/images/dinos/blue_dinos/ado/bleu_teen_26_39.png',
          Nature.aquatic:
              'assets/images/dinos/blue_dinos/ado/bleu_teen_26_39.png',
          Nature.cyclist:
              'assets/images/dinos/blue_dinos/ado/bleu_teen_26_39.png',
          Nature.mountain:
              'assets/images/dinos/blue_dinos/ado/bleu_teen_26_39.png',
          Nature.warrior:
              'assets/images/dinos/blue_dinos/ado/bleu_teen_26_39.png',
          Nature.explorer:
              'assets/images/dinos/blue_dinos/ado/bleu_teen_26_39.png',
        },
      },
      LifeStage.adult: {
        41: {
          Nature.terrestre:
              'assets/images/dinos/blue_dinos/adult/bleu_adult_41_51.png',
          Nature.runner:
              'assets/images/dinos/blue_dinos/adult/bleu_adult_41_51.png',
          Nature.aquatic:
              'assets/images/dinos/blue_dinos/adult/bleu_adult_41_51.png',
          Nature.cyclist:
              'assets/images/dinos/blue_dinos/adult/bleu_adult_41_51.png',
          Nature.mountain:
              'assets/images/dinos/blue_dinos/adult/bleu_adult_41_51.png',
          Nature.warrior:
              'assets/images/dinos/blue_dinos/adult/bleu_adult_41_51.png',
          Nature.explorer:
              'assets/images/dinos/blue_dinos/adult/bleu_adult_41_51.png',
        },
      },
    },
  ),

  DinoType(
    id: 'valerio',
    name: 'Valério',
    description: 'Un dinosaure vert courageux qui aime les défis.',
    outColor: const Color(0xFFD1FFBD),
    innerColor: const Color(0xFFA5D6A7),
    assetPaths: {
      LifeStage.baby: {
        1: {
          Nature.terrestre: 'assets/images/dino_vert_bebe.png',
          Nature.runner: 'assets/images/dino_vert_bebe.png',
          Nature.aquatic: 'assets/images/dino_vert_bebe.png',
          Nature.cyclist: 'assets/images/dino_vert_bebe.png',
          Nature.mountain: 'assets/images/dino_vert_bebe.png',
          Nature.warrior: 'assets/images/dino_vert_bebe.png',
          Nature.explorer: 'assets/images/dino_vert_bebe.png',
        },
      },
      LifeStage.child: {
        11: {
          Nature.terrestre: 'assets/images/dino_vert_bebe.png',
          Nature.runner: 'assets/images/dino_vert_bebe.png',
          Nature.aquatic: 'assets/images/dino_vert_bebe.png',
          Nature.cyclist: 'assets/images/dino_vert_bebe.png',
          Nature.mountain: 'assets/images/dino_vert_bebe.png',
          Nature.warrior: 'assets/images/dino_vert_bebe.png',
          Nature.explorer: 'assets/images/dino_vert_bebe.png',
        },
      },
      LifeStage.teenager: {
        26: {
          Nature.terrestre: 'assets/images/dino_vert_bebe.png',
          Nature.runner: 'assets/images/dino_vert_bebe.png',
          Nature.aquatic: 'assets/images/dino_vert_bebe.png',
          Nature.cyclist: 'assets/images/dino_vert_bebe.png',
          Nature.mountain: 'assets/images/dino_vert_bebe.png',
          Nature.warrior: 'assets/images/dino_vert_bebe.png',
          Nature.explorer: 'assets/images/dino_vert_bebe.png',
        },
      },
      LifeStage.adult: {
        41: {
          Nature.terrestre: 'assets/images/dino_vert_bebe.png',
          Nature.runner: 'assets/images/dino_vert_bebe.png',
          Nature.aquatic: 'assets/images/dino_vert_bebe.png',
          Nature.cyclist: 'assets/images/dino_vert_bebe.png',
          Nature.mountain: 'assets/images/dino_vert_bebe.png',
          Nature.warrior: 'assets/images/dino_vert_bebe.png',
          Nature.explorer: 'assets/images/dino_vert_bebe.png',
        },
      },
    },
  ),

  DinoType(
    id: 'falcon',
    name: 'Falcon',
    description: 'Un dinosaure rose passionné et déterminé.',
    outColor: const Color(0xFFFFCC80),
    innerColor: const Color(0xFFFF9800),
    assetPaths: {
      LifeStage.baby: {
        1: {
          Nature.terrestre: 'assets/images/dinos/orange_dinos/baby/orange_bebe_1.png',
          Nature.runner: 'assets/images/dinos/orange_dinos/baby/orange_bebe_1.png',
          Nature.aquatic: 'assets/images/dinos/orange_dinos/baby/orange_bebe_1.png',
          Nature.cyclist: 'assets/images/dinos/orange_dinos/baby/orange_bebe_1.png',
          Nature.mountain: 'assets/images/dinos/orange_dinos/baby/orange_bebe_1.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_1.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_1.png',
        },
        3: {
          Nature.terrestre: 'assets/images/dinos/orange_dinos/baby/orange_bebe_2.png',
          Nature.runner:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_2.png',
          Nature.aquatic:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_2.png',
          Nature.cyclist:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_2.png',
          Nature.mountain:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_2.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_2.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_2.png',
        },
        5: {
          Nature.terrestre: 'assets/images/dinos/orange_dinos/baby/orange_bebe_3.png',
          Nature.runner:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_3.png',
          Nature.aquatic:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_3.png',
          Nature.cyclist:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_3.png',
          Nature.mountain:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_3.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_3.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_3.png',
        },
        7: {
          Nature.terrestre: 'assets/images/dinos/orange_dinos/baby/orange_bebe_4.png',
          Nature.runner:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_4.png',
          Nature.aquatic:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_4.png',
          Nature.cyclist:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_4.png',
          Nature.mountain:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_4.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_4.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_4.png',
        },
        10: {
          Nature.terrestre:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_5.png',
          Nature.runner:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_5.png',
          Nature.aquatic:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_5.png',
          Nature.cyclist:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_5.png',
          Nature.mountain:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_5.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_5.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/baby/orange_bebe_5.png',
        },
      },
      LifeStage.child: {
        11: {
          Nature.terrestre:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.runner:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.aquatic:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.cyclist:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.mountain:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
        },
        15: {
          Nature.terrestre:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.runner:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.aquatic:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.cyclist:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.mountain:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
        },
        20: {
          Nature.terrestre:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.runner:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.aquatic:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.cyclist:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.mountain:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
        },
        25: {
          Nature.terrestre:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.runner:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.aquatic:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.cyclist:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.mountain:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/child/orange_child_1.png',
        },
      },
      LifeStage.teenager: {
        26: {
          Nature.terrestre:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_1.png',
          Nature.runner:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_1.png',
          Nature.aquatic:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_1.png',
          Nature.cyclist:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_1.png',
          Nature.mountain:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_1.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_1.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_1.png',
        },
        33: {
          Nature.terrestre:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_2.png',
          Nature.runner:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_2.png',
          Nature.aquatic:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_2.png',
          Nature.cyclist:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_2.png',
          Nature.mountain:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_2.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_2.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_2.png',
        },
        40: {
          Nature.terrestre:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_3.png',
          Nature.runner:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_3.png',
          Nature.aquatic:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_3.png',
          Nature.cyclist:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_3.png',
          Nature.mountain:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_3.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_3.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/teenager/orange_teenager_3.png',
        },
      },
      LifeStage.adult: {
        41: {
          Nature.terrestre:
              'assets/images/dinos/orange_dinos/adult/orange_adult_1.png',
          Nature.runner:
              'assets/images/dinos/orange_dinos/adult/orange_adult_1.png',
          Nature.aquatic:
              'assets/images/dinos/orange_dinos/adult/orange_adult_1.png',
          Nature.cyclist:
              'assets/images/dinos/orange_dinos/adult/orange_adult_1.png',
          Nature.mountain:
              'assets/images/dinos/orange_dinos/adult/orange_adult_1.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/adult/orange_adult_1.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/adult/orange_adult_1.png',
        },
        45: {
          Nature.terrestre:
              'assets/images/dinos/orange_dinos/adult/orange_adult_2.png',
          Nature.runner:
              'assets/images/dinos/orange_dinos/adult/orange_adult_2.png',
          Nature.aquatic:
              'assets/images/dinos/orange_dinos/adult/orange_adult_2.png',
          Nature.cyclist:
              'assets/images/dinos/orange_dinos/adult/orange_adult_2.png',
          Nature.mountain:
              'assets/images/dinos/orange_dinos/adult/orange_adult_2.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/adult/orange_adult_2.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/adult/orange_adult_2.png',
        },
        48: {
          Nature.terrestre:
              'assets/images/dinos/orange_dinos/adult/orange_adult_3.png',
          Nature.runner:
              'assets/images/dinos/orange_dinos/adult/orange_adult_3.png',
          Nature.aquatic:
              'assets/images/dinos/orange_dinos/adult/orange_adult_3.png',
          Nature.cyclist:
              'assets/images/dinos/orange_dinos/adult/orange_adult_3.png',
          Nature.mountain:
              'assets/images/dinos/orange_dinos/adult/orange_adult_3.png',
          Nature.warrior:
              'assets/images/dinos/orange_dinos/adult/orange_adult_3.png',
          Nature.explorer:
              'assets/images/dinos/orange_dinos/adult/orange_adult_3.png',
        },
      },
    },
  ),
];
