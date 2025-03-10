import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Img extends StatelessWidget {
  final String url;
  const Img({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;

    return SizedBox(
      height: SizeConfig.size(p: 180.h, l: 340.h),
      width: !SizeConfig.isPortrait() ? 550.h : 1.sw,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: isValidUrl(url)
              ? CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (context, txt) {
                    return Skeletonizer(
                      child: Image.asset(
                        'assets/images/event_bg.png',
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                )
              : url.isNotEmpty && url.length % 4 == 0
                  ? Image.memory(
                      base64Decode(url),
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/event_bg.png',
                      fit: BoxFit.cover,
                    ),
        ),
      ),
    );
  }

  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }
}
