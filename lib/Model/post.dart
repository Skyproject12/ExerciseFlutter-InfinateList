import 'package:equatable/equatable.dart';

// create model for response the api 
class Post extends Equatable {
  final int id;
  final String title;
  final String body; 
  const Post({this.id, this.title, this.body}); 
  // temp the data into array
  @override
  List<Object> get props => [id, title, body]; 
  // to Sgring the post id 
  @override
  String toString() => 'Post {id: $id}';
}
