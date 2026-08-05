import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
class ArticleItem extends StatelessWidget {
  const   ArticleItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary
        )
      ),
      child: Column(
        spacing: 10.h,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGVk6k1ZvTtrKfHVWKT4ypAnF1V4QWNgay9vqAlnJGKGbEShNmKl2j9oOj&s=10")),
          Text("40-year-old man falls 200 feet to his death while canyoneering at national park",style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 16.sp
          ),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("By : Jon Haworth",style: Theme.of(context).textTheme.titleSmall,),
              Text(timeago.format(DateTime.now().subtract(Duration(minutes: 15))),style: Theme.of(context).textTheme.titleSmall,),
            ],
          )
        ],
      ),
    );
  }
}
