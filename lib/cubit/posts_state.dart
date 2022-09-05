part of 'posts_cubit.dart';

enum PostsStatus {
  initial,
  loading,
  success,
  failure,
}

class PostsState extends Equatable {
  const PostsState({
    this.status = PostsStatus.initial,
    this.posts,
  });

  final PostsStatus status;
  final List<Post>? posts;

  @override
  List<Object?> get props => [status, posts];
}
