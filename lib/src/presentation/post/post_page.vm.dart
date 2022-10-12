import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usercases/usercases.dart';
import '../../foundation/helper/helper.dart';
import '../../injected.dart';

class PostState {
  final AsyncValue<List<PostEntity>> posts;
  const PostState({this.posts = const AsyncLoading()});
}

class PostViewModel extends StateNotifier<PostState> {
  final PostList _postList;
  final ToastHelper _toast;
  PostViewModel({
    required PostList postList,
    required ToastHelper toast,
  })  : _postList = postList,
        _toast = toast,
        super(const PostState()) {
    init();
  }

  TextEditingController postTitleController = TextEditingController();
  TextEditingController postBodyController = TextEditingController();

  FocusNode postTitleFocusNode = FocusNode();
  FocusNode postBodyFocusNode = FocusNode();

  Future<void> init() async {
    await _postList.load();
    state = PostState(posts: AsyncValue.data(_postList.posts));
  }

  void onUnfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  Future<void> onSubmitted(BuildContext context) async {
    if (postTitleController.text.isEmpty) {
      postTitleFocusNode.requestFocus();
      return;
    }
    if (postBodyController.text.isEmpty) {
      postBodyFocusNode.requestFocus();
      return;
    }
    context.loaderOverlay.show();
    final isAdded = await _postList.add(
      postTitleController.text,
      postBodyController.text,
    );
    if (!isAdded) {
      context.loaderOverlay.hide();
      _toast.showLong('Add post fail');
      return;
    }
    postTitleController.clear();
    postBodyController.clear();
    state = PostState(posts: AsyncValue.data(_postList.posts));
    context.loaderOverlay.hide();
  }

  @override
  void dispose() {
    postTitleController.dispose();
    postBodyController.dispose();
    postTitleFocusNode.dispose();
    postBodyFocusNode.dispose();
    logD('Dispose $runtimeType');
    super.dispose();
  }
}

final postViewModelProvider =
    StateNotifierProvider.autoDispose<PostViewModel, PostState>((ref) {
  final postList = ref.read(postListProvider);
  final toast = ref.read(toastProvider);
  return PostViewModel(postList: postList, toast: toast);
});
