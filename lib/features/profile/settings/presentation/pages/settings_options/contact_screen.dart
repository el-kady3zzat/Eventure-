import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryDark,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: kWhite,
                      size: 21.w,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  Text("CONTACT US",
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: kWhite)),
                  Spacer(),
                ],
              ),
              SizedBox(height: 25.h),
              Text(
                "Get in touch with us!",
                style: TextStyle(
                  color: kButton,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Have questions or feedback? Reach out to us through any of the methods below.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kGrey,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 20.h),

              _buildContactItem(Icons.phone, "Phone", "0123 456 7890"),
              _buildContactItem(Icons.email, "Email", "support@eventure.com"),
              _buildContactItem(Icons.language, "Website", "www.eventure.com"),

              SizedBox(height: 20.h),

              // Message Form
              _buildTextField("Your Name"),
              SizedBox(height: 15.h),
              _buildTextField("Your Email"),
              SizedBox(height: 15.h),
              _buildTextField("Your Message", maxLines: 4),
              SizedBox(height: 20.h),

              // Send Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Send Message",
                    style: TextStyle(fontSize: 18.sp, color: kWhite),
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // Social Media Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.facebook),
                  SizedBox(width: 15.w),
                  _buildSocialIcon(Icons.email),
                  SizedBox(width: 15.w),
                  _buildSocialIcon(Icons.language),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String detail) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Icon(icon, color: kButton, size: 28.w),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: kGrey, fontSize: 16.sp),
              ),
              Text(
                detail,
                style: TextStyle(color: kWhite, fontSize: 18.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return TextField(
      style: TextStyle(color: kWhite),
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: kGrey, fontSize: 16.sp),
        filled: true,
        fillColor: kDetails,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return CircleAvatar(
      backgroundColor: kGrey,
      child: Icon(icon, color: kButton),
    );
  }
}
