import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/blocs/book_btn/book_btn_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

class BookBtn extends StatelessWidget {
  final String eventId;
  final int seats;
  final int registeredUsersCount;
  const BookBtn({
    super.key,
    required this.eventId,
    required this.seats,
    required this.registeredUsersCount,
  });

  @override
  Widget build(BuildContext context) {
    late bool hasSeats;
    late bool isInBook;
    return BlocConsumer<BookBtnBloc, BookBtnState>(
      listener: (context, state) {
        if (state is BookBtnError) {
          UI.errorSnack(context, state.msg);
        }
      },
      builder: (context, state) {
        SizeConfig.mContext = context;

        if (state is BookBtnLoading) {
          return SizedBox(
            height: SizeConfig.size(p: 15.h, l: 20.h),
            width: 40.w,
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              colors: [kButton],
            ),
          );
        } else if (state is BookBtnLoaded) {
          hasSeats = registeredUsersCount < seats;
          isInBook = state.eventsId.contains(eventId);
          return ElevatedButton(
            style:
                ButtonStyle(backgroundColor: WidgetStatePropertyAll(kButton)),
            child: Text(
              isInBook
                  ? 'events.cancel'.tr()
                  : hasSeats
                      ? 'events.book'.tr()
                      : 'events.full'.tr(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.size(p: 12.sp, l: 6.sp),
              ),
            ),
            onPressed: () {
              _updateBook(context, isInBook);
            },
          );
        }
        return SizedBox();
      },
    );
  }

  void _updateBook(BuildContext context, bool isInBook) async {
    final seatsState =
        await context.read<BookBtnBloc>().checkSeatsAvailability(eventId);

    // If user Registered then remove
    if (context.mounted && isInBook) {
      context.read<BookBtnBloc>().add(RemoveFromBookIds(eventId));
    }
    // If user NOT Registered and event has seats then add
    else if (context.mounted && !isInBook && seatsState) {
      context.read<BookBtnBloc>().add(AddToBookIds(eventId));
    }
    // If user NOT Registered and event has No seats then show message
    else {
      if (context.mounted) {
        UI.infoSnack(context, 'events.available_seats_completed'.tr());
      }
    }
  }
}
