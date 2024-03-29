import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:is_firebase_test_lab_activated/is_firebase_test_lab_activated.dart';

class Analytics {
  static Mixpanel? instance;

  static Future<Mixpanel> init() async {
    instance ??= await Mixpanel.init("09a8489cc7aa57b32a5a31d6e0740db8",
        optOutTrackingDefault: false, trackAutomaticEvents: true);
    instance?.setServerURL("https://api-eu.mixpanel.com");
    final bool isFirebaseTestLabActivated =
        await IsFirebaseTestLabActivated.isFirebaseTestLabActivated;
    if (isFirebaseTestLabActivated) {
      instance?.registerSuperProperties({'FirebaseTest': true});
    }
    // instance?.setLoggingEnabled(true);
    return instance!;
  }

  static void t(event, [data]) {
    instance?.track(event, properties: data);
  }
}
