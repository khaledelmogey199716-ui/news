import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_c19/core/resources/app_constants.dart';
import 'package:news_c19/ui/articles/articles_list.dart';

class ArticlesWidget extends StatelessWidget {
  const ArticlesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: AppConstants.dummySources.length,
      child: Padding(
        padding: REdgeInsets.all(24),
        child: Column(
          spacing: 24.h,
          children: [
            TabBar(
                isScrollable: true,
                tabs: AppConstants.dummySources.map((source) => Tab(text: source,),).toList()),
            Expanded(
              child: TabBarView(
                  children:AppConstants.dummySources.map((source) => ArticlesList(),).toList()
              ),
            )
          ],
        ),
      ),
    );
  }
}
