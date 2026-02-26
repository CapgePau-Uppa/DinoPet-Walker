import 'package:dinopet_walker/models/DinoType.dart';
import 'package:dinopet_walker/models/LifeStage.dart';
import 'package:flutter/material.dart';
import '../models/DinoPet.dart';

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
        1: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_1.png',
        3: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_3.png',
        5: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_5.png',
        7: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_7.png',
        9: 'assets/images/dinos/blue_dinos/baby/bleu_bebe_9.png',
      },
      LifeStage.child: {
        11: 'assets/images/dinos/blue_dinos/child/bleu_child_11.png',
        24: 'assets/images/dinos/blue_dinos/child/bleu_child_24.png',
      },
      LifeStage.teenager: {
        26: 'assets/images/dinos/blue_dinos/ado/bleu_teen_26_39.png',
      },
      LifeStage.adult: {
        41: 'assets/images/dinos/blue_dinos/adult/bleu_adult_41_51.png',
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
      LifeStage.baby: {1: 'assets/images/dino_vert_bebe.png'},
      LifeStage.child: {11: 'assets/images/dino_vert_bebe.png'},
      LifeStage.teenager: {26: 'assets/images/dino_vert_bebe.png'},
      LifeStage.adult: {41: 'assets/images/dino_vert_bebe.png'},
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
        1: 'assets/images/dinos/orange_dinos/baby/orange_bebe_1.png',
        3: 'assets/images/dinos/orange_dinos/baby/orange_bebe_2.png',
        5: 'assets/images/dinos/orange_dinos/baby/orange_bebe_3.png',
        7: 'assets/images/dinos/orange_dinos/baby/orange_bebe_4.png',
        10: 'assets/images/dinos/orange_dinos/baby/orange_bebe_5.png',
      },
      LifeStage.child: {
        11: 'assets/images/dinos/orange_dinos/child/orange_child_1.png',
        15: 'assets/images/dinos/orange_dinos/child/orange_child_1.png',
        20: 'assets/images/dinos/orange_dinos/child/orange_child_1.png',
        25: 'assets/images/dinos/orange_dinos/child/orange_child_1.png'
      },
      LifeStage.teenager: {
        26: 'assets/images/dinos/orange_dinos/teenager/orange_teenager_1.png',
        33: 'assets/images/dinos/orange_dinos/teenager/orange_teenager_2.png',
        40: 'assets/images/dinos/orange_dinos/teenager/orange_teenager_3.png',
      },
      LifeStage.adult: {
        41: 'assets/images/dinos/orange_dinos/adult/orange_adult_1.png',
        45: 'assets/images/dinos/orange_dinos/adult/orange_adult_2.png',
        48: 'assets/images/dinos/orange_dinos/adult/orange_adult_3.png',
      },
    },
  ),
];
