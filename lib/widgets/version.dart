import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionLabel extends StatefulWidget {
  const VersionLabel({Key? key}) : super(key: key);

  @override
  State<VersionLabel> createState() => _VersionLabelState();
}

class _VersionLabelState extends State<VersionLabel> {
  String versionLabel = '';

  getInfoAndUpdate() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      versionLabel = info.version;
    });
  }

  @override
  void initState() {
    getInfoAndUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text('Versión $versionLabel'),
    );
  }
}
