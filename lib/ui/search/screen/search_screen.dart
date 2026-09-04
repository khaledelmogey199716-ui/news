import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_c19/core/remote/network/api_manager.dart';
import 'package:news_c19/core/resources/app_constants.dart';
import 'package:news_c19/core/resources/assets_manager.dart';
import 'package:news_c19/core/resources/colors_manager.dart';
import 'package:news_c19/core/resources/strings_manager.dart';
import 'package:news_c19/model/articles_response/Article.dart';
import 'package:news_c19/model/articles_response/Articles_response.dart';
import 'package:news_c19/model/show_article_details.dart';
import 'package:news_c19/ui/articles/article_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<Article> _articles = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _articles = [];
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      var response = await ApiManager.dio.get("/v2/everything", queryParameters: {
        "apiKey": AppConstants.apiKey,
        "q": query,
      });

      if (response.statusCode == 200) {
        ArticlesResponse articlesResponse = ArticlesResponse.fromJson(response.data);
        setState(() {
          _articles = articlesResponse.articles ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "Something went wrong";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "No Internet Connection or Error occurred";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: REdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    _search(value);
                  });
                },
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                      color: ColorsManager.lightPrimaryColor,
                    ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: ColorsManager.lightPrimaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: ColorsManager.lightPrimaryColor),
                  ),
                  hintText: StringsManager.search,
                  hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp,
                      ),
                  prefixIcon: Padding(
                    padding: REdgeInsets.only(
                      left: 16.w,
                      right: 8.w,
                    ),
                    child: SvgPicture.asset(
                      AssetsManager.search,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    maxWidth: 100.w,
                    maxHeight: 150.h,
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      _searchController.clear();
                      _search("");
                    },
                    child: Padding(
                      padding: REdgeInsets.only(
                        left: 21.5.w,
                        right: 21.5.w,
                      ),
                      child: SvgPicture.asset(
                        AssetsManager.close,
                        width: 13.5.w,
                        height: 13.5.h,
                        colorFilter: ColorFilter.mode(
                          ColorsManager.lightPrimaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  suffixIconConstraints: BoxConstraints(
                    maxWidth: 100.w,
                    maxHeight: 150.h,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : _articles.isEmpty
                          ? const Center(child: Text("No articles found"))
                          : ListView.separated(
                              padding: REdgeInsets.only(
                                left: 16.w,
                                right: 16.w,
                                bottom: 16.h
                              ),
                              itemBuilder: (context, index) {
                                return ArticleItem(
                                  _articles[index],
                                  () {
                                    ShowArticleDetails.show(context,_articles[index]);
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(height: 16.h),
                              itemCount: _articles.length,
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
