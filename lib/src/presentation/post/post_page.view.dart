import 'package:easy_localization/easy_localization.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../domain/entities/entities.dart';
import '../../foundation/common/common.dart';
import '../../foundation/themes/theme.dart';
import '../../injected.dart';
import 'post_page.vm.dart';

final addPostTitleKey = UniqueKey();
final addPostBodyKey = UniqueKey();

class PostPage extends ConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(postViewModelProvider.notifier);

    return GestureDetector(
      onTap: () => vm.onUnfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.postsPageTitle).tr(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              FormView(),
              SizedBox(height: 10),
              Expanded(child: PostsItemList()),
            ],
          ),
        ),
      ),
    );
  }
}

class FormView extends ConsumerWidget {
  const FormView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(postViewModelProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            key: addPostTitleKey,
            focusNode: vm.postTitleFocusNode,
            controller: vm.postTitleController,
            decoration: InputDecoration(
              labelText: LocaleKeys.postsTitlePlaceholder.tr(),
            ),
            onSubmitted: (_) => vm.onSubmitted(context),
          ),
        ),
        Expanded(
          child: TextField(
            key: addPostBodyKey,
            focusNode: vm.postBodyFocusNode,
            controller: vm.postBodyController,
            decoration: InputDecoration(
              labelText: LocaleKeys.postsBodyPlaceholder.tr(),
            ),
            onSubmitted: (_) => vm.onSubmitted(context),
          ),
        )
      ],
    );
  }
}

class PostsItemList extends ConsumerWidget {
  const PostsItemList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final state = ref.watch(postViewModelProvider.select((_) => _.posts));

    return state.when(
      data: (posts) {
        if (posts.isEmpty) {
          return SizedBox(
            width: 0.7.sw,
            height: 0.7.sw,
            child: EmptyWidget(
              image: null,
              packageImage: PackageImage.Image_3,
              title: LocaleKeys.postsNoPosts.tr(),
              subTitle: LocaleKeys.postsNoPostsSub.tr(),
              titleTextStyle: const TextStyle(
                fontSize: 22,
                color: Color(0xff9da9c7),
                fontWeight: FontWeight.w500,
              ),
              subtitleTextStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xffabb8d6),
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: posts.length,
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, i) => PostsItem(
            post: posts[i],
            theme: theme,
          ),
        );
      },
      loading: () => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: ListView.builder(
          itemCount: 6,
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              height: 150.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      error: (e, _) => Center(child: Text(e.toString())),
    );
  }
}

class PostsItem extends StatelessWidget {
  final PostEntity post;
  final AppTheme theme;
  const PostsItem({
    super.key,
    required this.post,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: ListTile(
        title: Text(
          post.title,
          style: theme.textTheme.h60,
        ),
        isThreeLine: true,
        style: ListTileStyle.drawer,
        subtitle: Text(post.body, style: theme.textTheme.h40),
      ),
    );
  }
}
