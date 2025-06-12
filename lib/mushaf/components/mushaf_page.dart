import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/line.dart';
import '../page_bloc/page_cubit.dart';
import '../page_bloc/page_states.dart';
import 'word_widget.dart';

class MushafPage extends StatelessWidget {
  const MushafPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit,PageStates>(
      builder: (context,state) {
        if(state is LoadingPageState){
          return Center(child: CircularProgressIndicator());
        }
        final int pageNumber=context.read<PageCubit>().pageNumber;
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            vertical: pageNumber <= 2 ? 110 : 36,
            horizontal: pageNumber <= 2 ? 60 : 16,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/mushaf_assets/frame${pageNumber <= 2 ? "1" : ""}.jpg",
              ),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: FittedBox(
            fit:BoxFit.fill,
            child: Column(
              mainAxisAlignment:
              pageNumber <= 2
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
            
              children: List.generate(
                context.read<PageCubit>().pageLines.length,
                    (index) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child:
                  context
                      .read<PageCubit>()
                      .pageLines[index]
                      .lineType ==
                      LineTypes.surahName
                      ? Container(
                    height: 30,
                    width: double.infinity,
                    decoration:
                    pageNumber > 2
                        ? BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "assets/mushaf_assets/ayah_frame.png",
                        ),
                      ),
                    )
                        : null,
                    child: Center(
                      child: Text(
                        context
                            .read<PageCubit>()
                            .pageLines[index]
                            .words[0],
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: "uthmani",
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                      : FittedBox(
                    fit:
                    context
                        .read<PageCubit>()
                        .pageLines[index]
                        .isCenter
                        ? BoxFit.scaleDown
                        : BoxFit.contain,
                    child: Row(
                      children: List.generate(
                        context
                            .read<PageCubit>()
                            .pageLines[index]
                            .words
                            .length,
                            (wordIndex) => WordWidget(
                          word:
                          context
                              .read<PageCubit>()
                              .pageLines[index]
                              .words
                              [wordIndex],
                          canPress:
                          context
                              .read<PageCubit>()
                              .pageLines[index]
                              .lineType ==
                              LineTypes.normalLine,
                          wordOrder:
                          context
                              .read<PageCubit>()
                              .pageLines[index]
                              .words
                              .length -
                              1 -
                              wordIndex,
                          lineNumber: index,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
