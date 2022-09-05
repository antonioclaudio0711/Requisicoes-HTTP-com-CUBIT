import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:requisicaohttpcubit/models/post_model.dart';
import 'package:http/http.dart' as http;

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit({required this.httpClient}) : super(const PostsState());

  final http.Client httpClient;

  Future<void> fetchAllPosts() async {
    emit(
      PostsState(posts: state.posts, status: PostsStatus.loading),
    );
    try {
      await Future.delayed(
        const Duration(seconds: 2),
      );
      final response = await httpClient.get(
        Uri.http(
          'jsonplaceholder.typicode.com',
          '/posts',
        ),
      );
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as List;
        final posts = body.map(
          (dynamic json) {
            return Post(
                id: json['id'] as int,
                title: json['title'] as String,
                body: json['body'] as String);
          },
        ).toList();
        emit(
          PostsState(posts: posts, status: PostsStatus.success),
        );
      }
    } on Exception {
      emit(
        PostsState(posts: state.posts, status: PostsStatus.failure),
      );
    }
  }
}
