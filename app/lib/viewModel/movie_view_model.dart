import 'package:app/models/movie.dart';
class MovieViewModel {
  final Movie movie;
  MovieViewModel({required this.movie});
  String get title {
    return this.movie.title;
  }
  String get poster {
    return this.movie.posterUrl;
  }
}