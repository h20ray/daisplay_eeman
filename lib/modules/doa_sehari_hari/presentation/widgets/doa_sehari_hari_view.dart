import 'package:flutter/material.dart';
import 'package:quran_app/common/extensions/text_theme_extension.dart';
import 'package:quran_app/common/themes/text_styles.dart';
import 'package:quran_app/common/widgets/spacing.dart';
import 'package:quran_app/modules/doa_sehari_hari/data/domain/doa_daily.dart';

class DoaSehariHariView extends StatelessWidget {
  const DoaSehariHariView({
    super.key,
    required this.doaDaily,
  });

  final List<DoaDaily> doaDaily;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: doaDaily.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              title: Text(
                doaDaily[index].title ?? '',
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              iconColor: Theme.of(context).colorScheme.onSurface,
              childrenPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                Text(
                  doaDaily[index].arabic ?? '',
                  style: AppTextStyles.arabicText,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
                const EemanSpacing.vertical8(),
                Text(
                  doaDaily[index].latin ?? '',
                  style: context.bodySmall?.copyWith(
                    height: 1.5,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const EemanSpacing.vertical8(),
                Divider(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.3),
                ),
                const EemanSpacing.vertical8(),
                Text(
                  doaDaily[index].translation ?? '',
                  style: context.bodySmall?.copyWith(
                    height: 1.5,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const EemanSpacing.vertical8(),
              ],
            ),
          ),
        );
      },
    );
  }
}
