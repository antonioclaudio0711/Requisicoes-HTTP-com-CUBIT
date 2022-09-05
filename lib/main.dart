import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:requisicaohttpcubit/cubit/posts_cubit.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) =>
            PostsCubit(httpClient: http.Client())..fetchAllPosts(),
        child: const PostsPage(title: 'Exemplo de requisições HTTP com CUBIT'),
      ),
    );
  }
}

class PostsPage extends StatelessWidget {
  const PostsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: _Content(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.select((PostsCubit cubit) => cubit.state.status);

    switch (status) {
      case PostsStatus.initial:
        return const SizedBox();

      case PostsStatus.loading:
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );

      case PostsStatus.failure:
        return const Center(
          child: Text("Erro ao buscar posts!"),
        );

      case PostsStatus.success:
        return const _PostList();
    }
  }
}

class _PostList extends StatelessWidget {
  const _PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final posts = context.select((PostsCubit cubit) => cubit.state.posts!);
    return ListView(
      children: [
        for (final post in posts) ...[
          ListTile(
            title: Text(post.title),
            subtitle: Text(
              post.body,
              maxLines: 2,
            ),
          ),
          const Divider(),
        ]
      ],
    );
  }
}
