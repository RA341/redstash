import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redstash/config/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final basepath = prefs.getString(prefKeyBasepath);
    return AppLocalSettings(basepath: basepath ?? "");
  }

  void refetch() {
    state = loadValue();
  }

  void saveUrl(String url) {
    prefs.setString(prefKeyBasepath, url);
    refetch();
  }
}
