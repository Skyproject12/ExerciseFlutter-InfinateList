import 'package:equatable/equatable.dart'; 
import 'package:infinate_list/Model/model.dart';
import 'package:infinate_list/Model/post.dart'; 
abstract class PostState extends Equatable { 
  const PostState();  
  @override 
  List<Object> get props => []; 
}

// call fungsi error 
class PostError extends PostState{ 
  final String error;
  const PostError ({  
    this.error
  }); 
}

class PostUninitialized extends PostState{ 

} 
class PostLoaded extends PostState{ 
  final List<Post> post; 
  final bool hasReachedMax; 
  const PostLoaded ({  
    this.post, 
    this.hasReachedMax
  }); 
  PostLoaded copyWith({ 
    List<Post> posts, 
    bool hasReachedmax,
  }){ 
    return PostLoaded(  
      // menampung data dalam sebuah array 
      post: posts ?? this.post,  
      // mengecek apakah size aplikasi sudah mencapai maximum 
      hasReachedMax: hasReachedmax ?? this.hasReachedMax 
    );
  }

  @override 
  List<Object> get props => [post, hasReachedMax]; 

  @override 
  String toString()=> 
  'PostLoaded {posts: ${post.length}, hasReachedmax: $hasReachedMax}';
}