import 'package:url_launcher/url_launcher.dart';

openUrlCallback(url) {
  return () {
    launchUrl(Uri.parse(url ?? ''), mode: LaunchMode.externalApplication);
  };
}
