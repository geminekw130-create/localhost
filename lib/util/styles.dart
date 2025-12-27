import 'package:flutter/material.dart';
import 'package:get/get.dart';

const sfProLight = TextStyle(
  fontFamily: 'SFProText',
  fontWeight: FontWeight.w300,
);

const textRegular = TextStyle(
  fontFamily: 'SFProText',
  fontWeight: FontWeight.w400,
);

const textMedium = TextStyle(
  fontFamily: 'SFProText',
  fontWeight: FontWeight.w500,
);

const textSemiBold = TextStyle(
  fontFamily: 'SFProText',
  fontWeight: FontWeight.w600,
);

const textBold = TextStyle(
  fontFamily: 'SFProText',
  fontWeight: FontWeight.w700,
);

const textHeavy = TextStyle(
  fontFamily: 'SFProText',
  fontWeight: FontWeight.w900,
);

const textRobotoRegular = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w400,
);

const textRobotoMedium = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
);

const textRobotoBold = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w700,
);

const textRobotoBlack = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w900,
);

/// 🔍 Sombra para campos de busca
List<BoxShadow>? searchBoxShadow = Get.isDarkMode
    ? null
    : [
        const BoxShadow(
          offset: Offset(0, 4),
          color: Color(0x1A000000),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ];

/// 📦 Sombra padrão para cards
List<BoxShadow>? cardShadow = Get.isDarkMode
    ? null
    : [
        BoxShadow(
          offset: const Offset(0, 6),
          blurRadius: 12,
          spreadRadius: 0,
          color: Colors.black.withOpacity(0.08),
        ),
      ];

/// 🌫️ Sombra leve (uso geral)
List<BoxShadow>? shadow = Get.isDarkMode
    ? [
        BoxShadow(
          offset: const Offset(0, 2),
          blurRadius: 6,
          spreadRadius: 0,
          color: Colors.black.withOpacity(0.3),
        ),
      ]
    : [
        BoxShadow(
          offset: const Offset(0, 4),
          blurRadius: 8,
          spreadRadius: 0,
          color: Colors.black.withOpacity(0.06),
        ),
      ];
