import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/data_unit_format_helper.dart';
import '../../../../core/helpers/string_format_helper.dart';
import '../../../../core/widgets/media_type_icon.dart';
import '../../domain/entities/synced_item.dart';

class SyncedItemsDetails extends StatelessWidget {
  final SyncedItem syncedItem;

  const SyncedItemsDetails({
    Key key,
    @required this.syncedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                syncedItem.syncTitle,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  color: TautulliColorPalette.not_white,
                ),
              ),
              Text(
                syncedItem.user,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: TautulliColorPalette.not_white,
                ),
              ),
              Text(
                syncedItem.deviceName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: TautulliColorPalette.not_white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${StringFormatHelper.capitalize(syncedItem.state)}${syncedItem.itemCompleteCount > 0 ? " · " : ""}${syncedItem.itemCompleteCount > 0 ? syncedItem.itemCompleteCount : ""} ${syncedItem.itemCompleteCount <= 0 ? "" : syncedItem.itemCompleteCount == 1 ? "item" : "items"}${syncedItem.totalSize > 0 ? " · " : ""}${syncedItem.totalSize > 0 ? DataUnitFormatHelper.prettyFilesize(syncedItem.totalSize) : ""}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      color: TautulliColorPalette.not_white,
                    ),
                  ),
                  MediaTypeIcon(
                    mediaType: syncedItem.mediaType,
                    iconColor: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}