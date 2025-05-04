import 'package:firebase_analytics/firebase_analytics.dart';


class MyAnalyticsHelper {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> navigatorEvent (info) async {
    await analytics.logEvent(name: 'navigator_ke_${info}');
    print('Send Event : navigator_ke_${info}');
  }
}