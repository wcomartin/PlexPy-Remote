import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/time_format_helper.dart';
import '../../domain/entities/user_table.dart';

class UsersDetails extends StatelessWidget {
  final UserTable user;

  const UsersDetails({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          user.friendlyName,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'STREAMED ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: TautulliColorPalette.not_white,
                ),
              ),
              TextSpan(
                text: user.lastSeen != null
                    ? '${TimeFormatHelper.timeAgo(user.lastSeen)}'
                    : 'never',
                style: TextStyle(
                  color: PlexColorPalette.gamboge,
                ),
              ),
            ],
          ),
        ),
        _playsAndDuration(),
      ],
    );
  }

  RichText _playsAndDuration() {
    Map<String, int> durationMap =
        TimeFormatHelper.durationMap(Duration(seconds: user.duration));

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'PLAYS ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: TautulliColorPalette.not_white,
            ),
          ),
          TextSpan(
            text: user.plays.toString(),
            style: TextStyle(
              color: PlexColorPalette.gamboge,
            ),
          ),
          TextSpan(text: '   '),
          if (durationMap['day'] > 1 ||
              durationMap['hour'] > 1 ||
              durationMap['min'] > 1 ||
              durationMap['sec'] > 1)
            TextSpan(
              text: 'DURATION ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: TautulliColorPalette.not_white,
              ),
            ),
          if (durationMap['day'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['day'].toString(),
                  style: TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' days ',
                  style: TextStyle(
                    color: TautulliColorPalette.not_white,
                  ),
                ),
              ],
            ),
          if (durationMap['hour'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['hour'].toString(),
                  style: TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' hrs ',
                  style: TextStyle(
                    color: TautulliColorPalette.not_white,
                  ),
                ),
              ],
            ),
          if (durationMap['min'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['min'].toString(),
                  style: TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' mins',
                  style: TextStyle(
                    color: TautulliColorPalette.not_white,
                  ),
                ),
              ],
            ),
          if (durationMap['day'] < 1 &&
              durationMap['hour'] < 1 &&
              durationMap['min'] < 1 &&
              durationMap['sec'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['sec'].toString(),
                  style: TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' secs',
                  style: TextStyle(
                    color: TautulliColorPalette.not_white,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
