import 'dart:convert';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedEventCard extends StatelessWidget {
  final String asset;
  final String title;
  final String date;
  final String time;

  const SavedEventCard({
    Key? key,
    required this.asset,
    required this.title,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? kPrimaryDark : kWhite;

    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).orientation == Orientation.landscape
              ? 15.h
              : 10.h,
          left: 15.w,
          right: 15.w,
          bottom: MediaQuery.of(context).orientation == Orientation.landscape
              ? 70.h
              : 38.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25.r)),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10.r,
            offset: Offset(0.w, 5.h),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.r),
                    child: Image.memory(
                      base64Decode(asset),
                      height: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 100.h
                          : 180.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 13.h,
                    right: 13.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? EdgeInsets.all(8).w
                          : EdgeInsets.all(15).w,
                      child: Icon(Icons.edit_outlined,
                          size: 18.w, color: kSecondaryDark),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: -35.h,
            left: 10.w,
            right: 10.w,
            child: Container(
              margin: EdgeInsets.only(left: 5.w, right: 5.w),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: kSecondaryDark,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: kWhite,
                          fontSize: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 13.sp
                              : 17.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 4.h
                              : 8.h),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: kWhite,
                              size: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? 8.w
                                  : 12.w),
                          SizedBox(width: 5.w),
                          Text(date,
                              style: TextStyle(
                                  color: kWhite,
                                  fontSize:
                                      MediaQuery.of(context).orientation ==
                                              Orientation.landscape
                                          ? 8.sp
                                          : 10.sp)),
                          SizedBox(width: 10.w),
                          Icon(Icons.access_time,
                              color: kWhite,
                              size: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? 8.w
                                  : 14.w),
                          SizedBox(width: 5.w),
                          Text(time,
                              style: TextStyle(
                                  color: kWhite,
                                  fontSize:
                                      MediaQuery.of(context).orientation ==
                                              Orientation.landscape
                                          ? 8.sp
                                          : 10.sp)),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: kDetails,
                      backgroundColor: kButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    ),
                    onPressed: () {},
                    child: Text("Chat",
                        style: TextStyle(
                            color: kSecondaryDark,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
