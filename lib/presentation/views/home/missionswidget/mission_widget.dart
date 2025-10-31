import 'package:flutter/material.dart';
import 'package:nubo/presentation/utils/card_custom/card_custom.dart';
import 'package:nubo/presentation/views/home/missionswidget/mission_item.dart';
import 'package:nubo/config/constants/enviroments.dart';

class MissionsSection extends StatelessWidget {
  const MissionsSection({super.key,
  this.onSeeAll,});

  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    const itemSpacing = 16.0;

    return CardCustom(
      title: 'Misiones',
      actionText: 'Ver misiones',
      enableShadow: false,
      onAction: onSeeAll, 
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    child: MissionItemCard(
                      iconAsset: recycleSvg,
                      title: 'Reciclar plásticos'
                    ),
                  ),
                  SizedBox(width: itemSpacing),
                  Expanded(
                    child: MissionItemCard(
                      iconAsset: lightingSvg,
                      title: 'Realiza un eco-quiz'
                    ),
                  ),
                  SizedBox(width: itemSpacing),
                  Expanded(
                    child: MissionItemCard(
                      iconAsset: trashSvg,
                      title: 'Crea tu rincón de reciclaje'
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
