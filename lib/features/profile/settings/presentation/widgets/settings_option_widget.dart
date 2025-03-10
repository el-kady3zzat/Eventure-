import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function? fun;

  const SettingsOption({required this.icon, required this.title, this.fun, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (fun != null) {
          fun!();
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.size(p: 20, l: 40),
          vertical: SizeConfig.size(p: 6, l: 10),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: kDetails,
            borderRadius: BorderRadius.circular(SizeConfig.size(p: 20, l: 25)),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: kWhite,
              radius: SizeConfig.size(p: 20, l: 25),
              child: Icon(icon, color: kHeader, size: SizeConfig.size(p: 20, l: 24)),
            ),
            title: Text(
              title,
              style: TextStyle(color: kWhite, fontSize: SizeConfig.size(p: 15, l: 18)),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: kButton,
              size: SizeConfig.size(p: 17, l: 20),
            ),
          ),
        ),
      ),
    );
  }
}
