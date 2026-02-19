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
    id: 'tresa',
    name: 'Tresa',
    description: 'Un dinosaure rose passionné et déterminé.',
    outColor: const Color.fromARGB(255, 255, 215, 246),
    innerColor: const Color(0xFFF8BBD0),
    assetPaths: {
      LifeStage.baby: {1: 'assets/images/dino_vert_bebe.png'},
      LifeStage.child: {11: 'assets/images/dino_vert_bebe.png'},
      LifeStage.teenager: {26: 'assets/images/dino_vert_bebe.png'},
      LifeStage.adult: {41: 'assets/images/dino_vert_bebe.png'},
    },
  ),
];
