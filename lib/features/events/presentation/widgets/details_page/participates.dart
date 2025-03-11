import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/blocs/users_images/users_images_bloc.dart';
import 'package:eventure/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Participates extends StatelessWidget {
  final String eventId;
  const Participates({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UsersImagesBloc>()
        ..add(
          LoadUsersImages(eventId: eventId),
        ),
      child: Padding(
        padding: REdgeInsets.symmetric(vertical: 16),
        child: BlocBuilder<UsersImagesBloc, UsersImagesState>(
          builder: (context, state) {
            bool isLoading = false;
            List<String> usersImages = [];
            if (state is UsersImagesLoading) {
              isLoading = true;
            } else if (state is UsersImagesLoaded) {
              usersImages = state.images;
            }
            return usersImages.isNotEmpty
                ? Skeletonizer(
                    enabled: isLoading,
                    child: AnimatedAvatarStack(
                      height: SizeConfig.size(p: 40.h, l: 50.h),
                      width: SizeConfig.size(p: 0.4.sw, l: 0.5.sh),
                      avatars: [
                        for (var img in usersImages)
                          img.isNotEmpty
                              ? CachedNetworkImageProvider(img)
                              : AssetImage('assets/images/logo.webp'),
                      ],
                      borderColor: kPrimaryLight,
                      borderWidth: 2.0,
                    ),
                  )
                : SizedBox(
                    height: SizeConfig.size(p: 40.h, l: 50.h),
                    child: Center(
                      child: Text(
                        'events.no_participates'.tr(),
                        style: TextStyle(
                          fontSize: SizeConfig.size(p: 14.sp, l: 6.sp),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
