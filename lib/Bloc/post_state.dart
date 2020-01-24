import 'package:equatable/equatable.dart';

import 'package:infinate_list/Model/post.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

// inisialisasi awal
class PostUninitialized extends PostState {}

// kerika error
class PostError extends PostState {}

// get the parameter to send into display 
class PostLoaded extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;

  const PostLoaded({
    this.posts,
    this.hasReachedMax,
  });

// defination constructor
  PostLoaded copyWith({ 
    // display of list 
    List<Post> post,
    bool hasReachedMa,
  }) {
    return PostLoaded(
      posts: post ?? posts,
      hasReachedMax: hasReachedMa ?? hasReachedMax,
    );
  }

  @override
  List<Object> get props => [posts, hasReachedMax];

  @override
  String toString() =>
      'PostLoaded { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}