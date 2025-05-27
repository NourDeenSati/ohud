import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/mushaf_app_bar.dart';
import '../components/mushaf_page.dart';
import '../components/operator_button.dart';
import '../components/waiting_widget.dart';
import '../core/functions.dart';
import '../page_bloc/page_cubit.dart';
import '../page_bloc/page_states.dart';

class MultiPageView extends StatelessWidget {
  const MultiPageView({
    super.key,
    required this.startPage,
    required this.endPage,
    required this.studentId,
  });

  final int startPage;
  final int endPage;
  final String studentId;

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();

    return BlocProvider(
      create: (BuildContext context) {
        return PageCubit(
          () => InitialMultiPageState(startPage: startPage),
          studentId,
        );
      },
      child: Scaffold(
        appBar: mushafAppBar(context: context),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width,
                child: BlocBuilder<PageCubit, PageStates>(
                  builder: (context, state) {
                    if (state is LoadingPageState) {
                      return WaitingWidget();
                    }
                    return PageView.builder(
                      reverse: true,
                      onPageChanged: (page) {
                        context.read<PageCubit>().changeToPage(number: page);
                      },
                      controller: controller,
                      itemBuilder: (context, snapshot) {
                        return MushafPage();
                      },
                      itemCount: (endPage + 1) - startPage,
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              BlocBuilder<PageCubit, PageStates>(
                builder: (BuildContext context, state) {
                  return OperatorButton(
                    onPressed: () {
                      AppFunctions.showQuranDialog(
                        context,
                        "هل تريد حفظ الصفحة",
                        () {
                          context.read<PageCubit>().savePageTest();
                          print(context.read<PageCubit>().notes);
                        },
                        context.read<PageCubit>().hafezNotes(),
                        context.read<PageCubit>().tashkeelNotes(),
                        context.read<PageCubit>().tajweedNotes(),
                      );
                    },
                    text: "حفظ التسميع",

                    enable: true,
                  );
                },
                buildWhen: (p, c) => false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
