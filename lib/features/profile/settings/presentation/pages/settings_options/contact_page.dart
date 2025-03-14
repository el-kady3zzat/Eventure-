import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});
  void _callNumber(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print("Could not open the dialer.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? kPrimaryDark : kWhite;
    final textColor = isDarkMode ? kWhite : kPrimaryDark;
    final detailsColor = isDarkMode ? kPreIcon : kPrimaryDark;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: isLandscape
              ? _buildLandscapeLayout(textColor, detailsColor, context)
              : _buildPortraitLayout(textColor, detailsColor, context),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
      Color textColor, Color detailsColor, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildAppBar(textColor, context),
        SizedBox(height: 15.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(25.r),
          child: Image.asset(
            'assets/images/contact.jpg',
            height: 240.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 20.h),
        _buildTitleAndDescription(textColor, detailsColor, context),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _callNumber("+201255955940");
              },
              child: _buildSupportCard(
                  icon: Icons.phone_iphone,
                  title: 'contact.call'.tr(),
                  subtitle: "(+20) 125 595 5940",
                  context: context),
            ),
            SizedBox(
              width: 20.w,
            ),
            GestureDetector(
              onTap: () async {
                //      final Uri emailUri = Uri(
                //   scheme: 'mailto',
                //   path: "event@gmail.com", // The email address
                //   queryParameters: {
                //     'subject': 'Support Request', // Optional: Pre-fill subject
                //   },
                // );

                // if (await canLaunchUrl(emailUri)) {
                //   await launchUrl(emailUri);
                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text('Could not open email app')),
                //   );
                // }
              },
              child: _buildSupportCard(
                  icon: Icons.mail,
                  title: 'contact.mail'.tr(),
                  subtitle: "event@gmail.com",
                  context: context),
            ),
          ],
        ),
      ],
    );
  }

  /// **Landscape Layout (Overflow Fixed)**
  Widget _buildLandscapeLayout(
      Color textColor, Color detailsColor, BuildContext context) {
    return Column(
      children: [
        _buildAppBar(textColor, context),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.r),
                    child: Image.asset(
                      'assets/images/contact.jpg',
                      height: 200.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  _buildTitleAndDescription(textColor, detailsColor, context),
                ],
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSmallSupportCard(
                    icon: Icons.phone_iphone,
                    title: 'contact.call'.tr(),
                    subtitle: "(+20) 125 595 5940",
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  _buildSmallSupportCard(
                    icon: Icons.mail,
                    title: 'contact.mail'.tr(),
                    subtitle: "event@gmail.com",
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitleAndDescription(
      Color textColor, Color detailsColor, BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5.h),
        Text(
          'contact.title'.tr(),
          style: TextStyle(
            fontSize:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? 12.sp
                    : 20.sp,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          'contact.description'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? 9.sp
                    : 16.sp,
            color: detailsColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(Color textColor, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20.h),
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: textColor,
            size: MediaQuery.of(context).orientation == Orientation.landscape
                ? 15.w
                : 21.w,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Spacer(),
        Text('settings_screen.contact_us'.tr(),
            style: TextStyle(
                fontSize:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 12.sp
                        : 17.sp,
                fontWeight: FontWeight.bold,
                color: textColor)),
        Spacer(),
      ],
    );
  }

  Widget _buildSupportCard(
      {required IconData icon,
      required String title,
      required String subtitle,
      required BuildContext context}) {
    return Container(
      width: 150.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: kDetails,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: kPrimaryDark,
            radius: 22.w, // Adjusted size
            child: Icon(icon, color: kButton, size: 26.w),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: kWhite,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: kGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallSupportCard(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: kDetails,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: kPrimaryDark,
              radius: 20.w,
              child: Icon(icon, color: kButton, size: 20.w),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: kWhite,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 8.sp,
                color: kGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
