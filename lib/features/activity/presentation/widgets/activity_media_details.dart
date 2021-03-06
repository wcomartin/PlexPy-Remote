import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/clean_data_helper.dart';
import '../../../../core/helpers/ip_address_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/geo_ip.dart';
import '../bloc/geo_ip_bloc.dart';

class ActivityMediaDetails extends StatefulWidget {
  final BoxConstraints constraints;
  final ActivityItem activity;
  final String tautulliId;

  const ActivityMediaDetails({
    Key key,
    @required this.constraints,
    @required this.activity,
    @required this.tautulliId,
  }) : super(key: key);

  @override
  _ActivityMediaDetailsState createState() => _ActivityMediaDetailsState();
}

class _ActivityMediaDetailsState extends State<ActivityMediaDetails> {
  @override
  void initState() {
    super.initState();
    context.read<GeoIpBloc>().add(
          GeoIpLoad(
            tautulliId: widget.tautulliId,
            ipAddress: widget.activity.ipAddress,
            settingsBloc: context.read<SettingsBloc>(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();
    final SettingsLoadSuccess settingsLoadSuccess = settingsBloc.state;

    return Column(
      children: _buildList(
        constraints: widget.constraints,
        activity: widget.activity,
        maskSensitiveInfo: settingsLoadSuccess.maskSensitiveInfo,
      ),
    );
  }
}

List<Widget> _buildList({
  @required BoxConstraints constraints,
  @required ActivityItem activity,
  @required bool maskSensitiveInfo,
}) {
  List<Widget> rows = [];

  bool isPublicIp = false;
  try {
    isPublicIp = IpAddressHelper.isPublic(activity.ipAddress);
  } catch (_) {}

  _buildRows(
    constraints: constraints,
    rowLists: ActivityMediaDetailsCleaner.product(activity),
  ).forEach((row) {
    rows.add(row);
  });

  _buildRows(
    constraints: constraints,
    rowLists: ActivityMediaDetailsCleaner.player(activity),
  ).forEach((row) {
    rows.add(row);
  });

  _buildRows(
    constraints: constraints,
    rowLists: ActivityMediaDetailsCleaner.quality(activity),
  ).forEach((row) {
    rows.add(row);
  });

  if (activity.optimizedVersion == 1) {
    _buildRows(
      constraints: constraints,
      rowLists: ActivityMediaDetailsCleaner.optimized(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  if (activity.syncedVersion == 1) {
    _buildRows(
      constraints: constraints,
      rowLists: ActivityMediaDetailsCleaner.synced(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  rows.add(
    const SizedBox(
      height: 15,
    ),
  );

  _buildRows(
    constraints: constraints,
    rowLists: ActivityMediaDetailsCleaner.stream(activity),
  ).forEach((row) {
    rows.add(row);
  });

  _buildRows(
    constraints: constraints,
    rowLists: ActivityMediaDetailsCleaner.container(activity),
  ).forEach((row) {
    rows.add(row);
  });

  if (activity.mediaType != 'track') {
    _buildRows(
      constraints: constraints,
      rowLists: ActivityMediaDetailsCleaner.video(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  if (activity.mediaType != 'photo') {
    _buildRows(
      constraints: constraints,
      rowLists: ActivityMediaDetailsCleaner.audio(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  if (activity.mediaType != 'track' && activity.mediaType != 'photo') {
    _buildRows(
      constraints: constraints,
      rowLists: ActivityMediaDetailsCleaner.subtitles(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  rows.add(
    const SizedBox(
      height: 15,
    ),
  );

  _buildRows(
    constraints: constraints,
    rowLists: ActivityMediaDetailsCleaner.location(
      activity,
      maskSensitiveInfo,
    ),
  ).forEach((row) {
    rows.add(row);
  });

  if (activity.relayed == 1) {
    _buildRows(
      constraints: constraints,
      rowLists: ActivityMediaDetailsCleaner.locationDetails(type: 'relay'),
    ).forEach((row) {
      rows.add(row);
    });
  }

  // Build the GeoIP data row
  if (isPublicIp) {
    rows.add(
      BlocBuilder<GeoIpBloc, GeoIpState>(
        builder: (context, state) {
          if (state is GeoIpSuccess) {
            if (state.geoIpMap.containsKey(activity.ipAddress)) {
              GeoIpItem geoIpItem = state.geoIpMap[activity.ipAddress];
              if (activity.relayed == 0 &&
                  geoIpItem != null &&
                  geoIpItem.code != 'ZZ') {
                final List locationDetails =
                    ActivityMediaDetailsCleaner.locationDetails(
                  type: 'ip',
                  city: geoIpItem.city,
                  region: geoIpItem.region,
                  code: geoIpItem.code,
                  maskSensitiveInfo: maskSensitiveInfo,
                )[0];

                return _ActivityMediaDetailsRow(
                  constraints: constraints,
                  left: locationDetails[0],
                  right: locationDetails[1],
                );
              }
              return const SizedBox(height: 0, width: 0);
            }
            return _ActivityMediaDetailsRow(
              constraints: constraints,
              left: '',
              right: Row(
                children: [
                  const Text(LocaleKeys.media_details_location_error).tr(),
                ],
              ),
            );
          }
          return _ActivityMediaDetailsRow(
            constraints: constraints,
            left: '',
            right: Row(
              children: [
                SizedBox(
                  height: 19,
                  width: 19,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: const Text(LocaleKeys.media_details_location_loading)
                      .tr(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildRows(
    constraints: constraints,
    rowLists: ActivityMediaDetailsCleaner.bandwidth(activity),
  ).forEach((row) {
    rows.add(row);
  });

  return rows;
}

List<Widget> _buildRows({
  @required BoxConstraints constraints,
  @required List rowLists,
}) {
  List<Widget> rows = [];

  rowLists.forEach((row) {
    rows.add(
      _ActivityMediaDetailsRow(
        constraints: constraints,
        left: row[0],
        right: row[1],
      ),
    );
  });
  return rows;
}

class _ActivityMediaDetailsRow extends StatelessWidget {
  final BoxConstraints constraints;
  final String left;
  final Widget right;

  const _ActivityMediaDetailsRow({
    Key key,
    @required this.constraints,
    this.left,
    @required this.right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
        bottom: 5,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: constraints.maxWidth / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          left ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      right,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
