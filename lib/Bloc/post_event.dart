import 'package:equatable/equatable.dart'; 
abstract class PostEvent extends Equatable{ 
  @override 
  List<Object> get props => [];
} 
// menampilkan seluruh data 
class Fetch extends PostEvent{}