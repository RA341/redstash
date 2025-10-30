import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redstash/config/service.dart';

const prefKeyBasepath = "basepath";

class AppLocalSettings {
  final String basepath;

  AppLocalSettings({required this.basepath});
}

final prefs = PreferencesService.instance.preferences;

final localSettingsProvider =
    NotifierProvider<AppLocalSettingsNotifier, AppLocalSettings>(
      AppLocalSettingsNotifier.new,
    );

class AppLocalSettingsNotifier extends Notifier<AppLocalSettings> {
  @override
  AppLocalSettings build() => loadValue();

  AppLocalSettings loadValue() {
    var basepath = "";
    if (kIsWeb) {
      basepath = "/";
    } else {
      basepath = prefs.getString(prefKeyBasepath) ?? "";
    }

    if (!basepath.endsWith("/")) {
      basepath += "/";
    }

    return AppLocalSettings(basepath: basepath);
  }

  void refetch() {
    state = loadValue();
  }

  void saveUrl(String url) {
    prefs.setString(prefKeyBasepath, url);
    refetch();
  }
}
