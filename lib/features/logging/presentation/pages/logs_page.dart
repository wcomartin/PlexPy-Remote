import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../bloc/load_logs_bloc.dart';
import '../widgets/log_table.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({Key key}) : super(key: key);

  static const routeName = '/logs';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LogsBloc>(
      create: (context) => di.sl<LogsBloc>()..add(LogsLoad()),
      child: const _LogsPageContent(),
    );
  }
}

class _LogsPageContent extends StatefulWidget {
  const _LogsPageContent({Key key}) : super(key: key);

  @override
  _LogsPageContentState createState() => _LogsPageContentState();
}

class _LogsPageContentState extends State<_LogsPageContent> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(LocaleKeys.logs_page_title).tr(),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 'export') {
                // var status = await Permission.storage.status;
                if (await Permission.storage.request().isGranted) {
                  context.read<LogsBloc>().add(LogsExport());
                }
              }
              if (value == 'clear') {
                return _showClearLogsDialog(
                  context: context,
                  clearLogs: () => context.read<LogsBloc>().add(LogsClear()),
                );
              }
              return null;
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text(LocaleKeys.logs_export).tr(),
                value: 'export',
              ),
              PopupMenuItem(
                child: const Text(LocaleKeys.logs_clear).tr(),
                value: 'clear',
              ),
            ],
          ),
        ],
      ),
      // drawer: AppDrawer(),
      body: BlocConsumer<LogsBloc, LogsState>(
        listener: (context, state) {
          if (state is LogsSuccess) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
          if (state is LogsExportInProgress) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: PlexColorPalette.shark,
                content: const Text(LocaleKeys.logs_exported).tr(),
                action: SnackBarAction(
                  label: LocaleKeys.button_access_logs.tr(),
                  onPressed: () async {
                    await launch(
                      'https://github.com/Tautulli/Tautulli-Remote/wiki/Features#logs',
                    );
                  },
                  textColor: TautulliColorPalette.not_white,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LogsFailure) {
            return Center(
              child: const Text(
                LocaleKeys.logs_failed,
                style: TextStyle(fontSize: 18),
              ).tr(),
            );
          }
          if (state is LogsExportInProgress) {
            return LogTable(
              logs: state.logs,
              refreshCompleter: _refreshCompleter,
            );
          }
          if (state is LogsSuccess) {
            return LogTable(
              logs: state.logs,
              refreshCompleter: _refreshCompleter,
            );
          }

          return const SizedBox(height: 0, width: 0);
        },
      ),
    );
  }
}

Future _showClearLogsDialog({
  @required BuildContext context,
  @required Function clearLogs,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          LocaleKeys.logs_clear_dialog_title,
        ).tr(),
        actions: <Widget>[
          TextButton(
            child: const Text(LocaleKeys.button_cancel).tr(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(LocaleKeys.button_confirm).tr(),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              clearLogs();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
