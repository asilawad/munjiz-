import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Central layout tokens: spacing, radii, sizes, shadows, font sizes.
/// Raw numbers are not allowed in views or widgets.
abstract final class AppDimensions {
  // Spacing
  static const double spaceXxs = 4;
  static const double spaceXs = 8;
  static const double spaceSm = 12;
  static const double spaceMd = 16;
  static const double spaceLg = 20;
  static const double spaceXl = 24;
  static const double spaceXxl = 32;

  // Paddings
  static const EdgeInsets screenPadding = EdgeInsets.all(spaceMd);
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(
    horizontal: spaceMd,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(spaceMd);
  static const EdgeInsets pillPadding = EdgeInsets.symmetric(
    horizontal: spaceMd,
  );
  static const EdgeInsets badgePadding = EdgeInsets.symmetric(
    horizontal: spaceXs,
    vertical: spaceXxs,
  );
  static const EdgeInsets dialogPadding = EdgeInsets.all(spaceXl);
  static const EdgeInsets listPadding = EdgeInsets.only(
    left: spaceMd,
    right: spaceMd,
    bottom: fabListInset,
  );
  static const EdgeInsets tileGap = EdgeInsets.only(bottom: spaceSm);
  static const EdgeInsets sectionHeaderPadding = EdgeInsets.symmetric(
    vertical: spaceXs,
  );
  static const double fabListInset = 96;

  // Radius
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusPill = 100;
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );
  static const BorderRadius borderRadiusPill = BorderRadius.all(
    Radius.circular(radiusPill),
  );

  // Icons
  static const double iconXs = 14;
  static const double iconSm = 18;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconHero = 44;

  // Borders, shadows, alpha
  static const double borderWidth = 1;
  static const double borderWidthSelected = 2;
  static const double elevationNone = 0;
  static const double softAlpha = 0.12;
  static const List<BoxShadow> cardShadow = <BoxShadow>[
    BoxShadow(color: AppColors.shadow, blurRadius: 20, offset: Offset(0, 6)),
  ];

  // Typography
  static const double fontXs = 12;
  static const double fontSm = 14;
  static const double fontMd = 16;
  static const double fontLg = 18;
  static const double fontXl = 22;
  static const double fontXxl = 28;
  static const double lineHeight = 1.4;

  // Components
  static const double contentMaxWidth = 640;
  static const double logoSize = 44;
  static const double buttonHeight = 52;
  static const double searchHeight = 52;
  static const double pillHeight = 40;
  static const double fabSize = 60;
  static const double checkboxSize = 28;
  static const double checkboxRadius = 8;
  static const double checkboxHitPadding = 6;
  static const double dayStripHeight = 78;
  static const double dayCardWidth = 56;
  static const double categoryCircleSize = 52;
  static const double categoryChipWidth = 64;
  static const double weekdayCircleSize = 40;
  static const double progressBarHeight = 10;
  static const double countBadgeSize = 26;
  static const double detailIconBox = 40;
  static const double dialogIconCircle = 64;
  static const double stateIconCircle = 96;
  static const double celebrationIconCircle = 88;
  static const double snackCheckSize = 36;
  static const double dialogMaxWidth = 360;

  // Animation offsets
  static const Offset leavingSlide = Offset(0, 0.4);
  static const double sectionChevronTurns = 0.5;
}
