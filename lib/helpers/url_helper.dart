import 'package:url_launcher/url_launcher.dart';

import '../services/analytics_service.dart';

openUrlCallback(url) {
  return () {
    launchUrl(Uri.parse(url ?? ''), mode: LaunchMode.externalApplication);
    Analytics.t("External url", {"url": url});
  };
}
