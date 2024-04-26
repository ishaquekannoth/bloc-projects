import 'package:blocprojects/posts/bloc/post_bloc.dart';
import 'package:blocprojects/posts/view/posts_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) =>
              PostBloc(httpClient: Client())..add(PostFetched()),
          child: const PostsList(),
        ),
      ),
    );
  }
}
