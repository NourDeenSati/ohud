import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../components/mushaf_app_bar.dart';
import '../components/mushaf_page.dart';
import '../components/operator_button.dart';
import '../core/functions.dart';
import '../page_bloc/page_cubit.dart';
import '../page_bloc/page_states.dart';

class OnePageView extends StatefulWidget {
  const OnePageView({
    super.key,
    required this.pageNumber,
    required this.studentId,
  });

  final int pageNumber;
  final String studentId;

  @override
  State<OnePageView> createState() => _OnePageViewState();
}

class _OnePageViewState extends State<OnePageView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return PageCubit(
              () => InitialOnePageState(pageNumber: widget.pageNumber),
          widget.studentId,
        );
      },
      child: BlocListener<PageCubit, PageStates>(
        listener: (BuildContext context, state) {
          if (state is FailToStartPage) {
            Navigator.pop(context);

            Get.snackbar(
              "خطأ",
              state.error,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Get.theme.colorScheme.errorContainer,
              colorText: Get.theme.colorScheme.onErrorContainer,
            );
          }
          if (state is FailurePageState) {
            Get.snackbar(
              "خطأ",
              state.error,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Get.theme.colorScheme.errorContainer,
              colorText: Get.theme.colorScheme.onErrorContainer,
            );
          }
          if (state is CompletedListenState) {
            Navigator.pop(context);
            Get.snackbar(
              "تم حفظ التسميع",
              "التقييم ${state.result}",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Get.theme.colorScheme.onPrimary,
              colorText: Get.theme.colorScheme.onPrimaryContainer,
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: mushafAppBar(context: context),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  MushafPage(),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.01),
                  BlocBuilder<PageCubit, PageStates>(
                    builder: (context, state) {
                      return Text(
                        context.read<PageCubit>().studentName,
                        textDirection: TextDirection.rtl,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(fontSize:context.read<PageCubit>().surNames().length>10?13: 16),
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.008),

                  BlocBuilder<PageCubit, PageStates>(
                    builder: (BuildContext context, state) {
                      if (context
                          .read<PageCubit>()
                          .isCurrent) {
                        return OperatorButton(
                          onPressed: () {
                            AppFunctions.showQuranDialog(
                              context,
                              "هل تريد حفظ الصفحة",
                                  () {
                                context.read<PageCubit>().savePageTest();
                                print(context
                                    .read<PageCubit>()
                                    .notes);
                              },
                              context.read<PageCubit>().tajweedNotes(),
                              context.read<PageCubit>().tashkeelNotes(),

                              context.read<PageCubit>().hafezNotes(),
                            );
                          },
                          text: "حفظ التسميع",

                          enable: true,
                        );
                      }
                      return SizedBox();
                    },
                    buildWhen: (p, c) => c is ChangeListenState,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

