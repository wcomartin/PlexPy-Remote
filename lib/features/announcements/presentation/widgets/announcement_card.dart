import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/color_palette_helper.dart';

class AnnouncementCard extends StatelessWidget {
  final int id;
  final String date;
  final String title;
  final String body;
  final String actionUrl;
  final int lastReadAnnouncementId;

  const AnnouncementCard({
    Key key,
    @required this.id,
    @required this.date,
    @required this.title,
    @required this.body,
    @required this.actionUrl,
    @required this.lastReadAnnouncementId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        onTap: isNotEmpty(actionUrl)
            ? () async {
                launch(actionUrl);
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (id > lastReadAnnouncementId)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Container(
                              height: 13,
                              width: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    PlexColorPalette.gamboge.withOpacity(0.9),
                              ),
                            ),
                          ),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        date,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Text(
                      body,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (isNotEmpty(actionUrl))
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: FaIcon(
                    FontAwesomeIcons.externalLinkAlt,
                    size: 20,
                    color: TautulliColorPalette.not_white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}