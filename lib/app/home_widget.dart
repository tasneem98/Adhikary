import 'package:home_widget/home_widget.dart';

class HomeWidgetProvider {
  // Home Widget data
  static const String _appGroupId = "group.homeScreenApp";
  static const String _iOSWidgetName = "ZekrWidget";
  static const String _androidWidgetName = "ZekrWidget";
  static const String _dataKey = "the_zekr";

  static Future<void> updateWidget(String randomZekr) async {
    // Save widget zekr
    await HomeWidget.saveWidgetData(_dataKey, randomZekr);

    // Update widget
    await HomeWidget.updateWidget(
      name: _iOSWidgetName,
      androidName: _androidWidgetName,
    );
  }

  static Future<void> init() async {
    // Init Home Widget
    await HomeWidget.setAppGroupId(_appGroupId);
  }
}
