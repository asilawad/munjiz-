import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import 'app_button.dart';
import 'soft_card.dart';

/// Shown when every task of today is completed: confetti + success card.
class CelebrationDialog extends StatefulWidget {
  const CelebrationDialog({super.key});

  @override
  State<CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<CelebrationDialog> {
  late final ConfettiController _confetti = ConfettiController(
    duration: AppDurations.confetti,
  );

  @override
  void initState() {
    super.initState();
    _confetti.play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confetti,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: AppColors.confetti,
            numberOfParticles: AppConfig.confettiParticles,
            gravity: AppConfig.confettiGravity,
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.dialogMaxWidth,
            ),
            child: Padding(
              padding: AppDimensions.screenPadding,
              child: SoftCard(
                padding: AppDimensions.dialogPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: AppDimensions.celebrationIconCircle,
                      height: AppDimensions.celebrationIconCircle,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent,
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        size: AppDimensions.iconHero,
                        color: AppColors.onAccent,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceMd),
                    Text(
                      AppStrings.celebrationTitle,
                      style: text.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spaceXs),
                    Text(
                      AppStrings.celebrationMessage,
                      style: text.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spaceXl),
                    AppButton(
                      label: AppStrings.celebrationAction,
                      style: AppButtonStyle.accent,
                      onPressed: () => Get.back<void>(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
