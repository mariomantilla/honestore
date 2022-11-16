import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelManager {
  static Mixpanel? instance;

  static Future<Mixpanel> init() async {
    instance ??= await Mixpanel.init("09a8489cc7aa57b32a5a31d6e0740db8",
        optOutTrackingDefault: false, trackAutomaticEvents: true);
    instance?.setLoggingEnabled(true);
    return instance!;
  }
}
