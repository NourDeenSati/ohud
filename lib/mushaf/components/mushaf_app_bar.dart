import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../page_bloc/page_cubit.dart';
import '../page_bloc/page_states.dart';

PreferredSizeWidget mushafAppBar({required BuildContext context}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    actionsPadding: EdgeInsets.symmetric(horizontal: 12),
    actions: [
      BlocBuilder<PageCubit, PageStates>(
        builder: (context, state) {
          return PopupMenuButton<String>(
            initialValue: context.read<PageCubit>().currentDate,
            icon: const Icon(Icons.menu,color: Colors.black,), // ☰ Menu icon
            onSelected: (value) {
              context.read<PageCubit>().updateCurrentDate(value);

            },
            itemBuilder: (BuildContext context) {
              return List.generate(
                context.read<PageCubit>().datesValues.length,
                (index) =>  PopupMenuItem(
                  value: context.read<PageCubit>().datesValues[index],
                  child: Text(context.read<PageCubit>().datesValues[index],textDirection: TextDirection.ltr,),
                ),
              );
            },
          );
        },
      ),
      BlocBuilder<PageCubit, PageStates>(
        builder: (context, state) {
          return Text(
            "رقم الصفحة : ${context.read<PageCubit>().pageNumber}",
            textDirection: TextDirection.rtl,
            overflow: TextOverflow.ellipsis,

            style: TextStyle(fontSize:context.read<PageCubit>().surNames().length>10?13: 16),
          );
        },
      ),
      Spacer(),
      BlocBuilder<PageCubit, PageStates>(
        builder: (context, state) {
          return Text(
            "سورة : ${context.read<PageCubit>().surNames()}",
            textDirection: TextDirection.rtl,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize:context.read<PageCubit>().surNames().length>10?13: 16),
          );
        },
      ),
      BlocBuilder<PageCubit, PageStates>(
        builder: (context, state) {
          if (context.read<PageCubit>().isCurrent) {
            return IconButton(
              onPressed: () {
                context.read<PageCubit>().removeLastNoteOfPage();
              },
              icon: Icon(Icons.restart_alt),
              color: Colors.black,
            );
          }
          return SizedBox();
        },
        buildWhen: (p, c) => c is ChangeListenState,
      ),
    ],
  );
}
