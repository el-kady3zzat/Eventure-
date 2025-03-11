import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class Address extends StatelessWidget {
  final String address;
  final String location;
  const Address({super.key, required this.address, required this.location});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;

    return Card(
      margin: REdgeInsets.symmetric(vertical: 16),
      color: kSecondaryDark,
      child: Padding(
        padding: REdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: SizeConfig.size(p: 50.h, l: 90.h),
          child: Row(
            children: [
              Icon(
                Icons.place_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Text(
                address,
                style: TextStyle(
                  fontSize: SizeConfig.size(p: 12.sp, l: 5.sp),
                  color: Colors.white,
                ),
              )),
              SizedBox(
                height: SizeConfig.size(p: 45.h, l: 80.h),
                width: SizeConfig.size(p: 45.h, l: 80.h),
                child: Card(
                  color: kButton,
                  child: IconButton(
                    onPressed: () => openGoogleMaps(context),
                    icon: Icon(
                      Icons.map_outlined,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openGoogleMaps(context) async {
    final Uri googleMapsUrl = Uri.parse(location);
    try {
      await launchUrl(googleMapsUrl);
    } catch (e) {
      UI.errorSnack(context, 'events.gmaps_error'.tr());
    }
  }
}
