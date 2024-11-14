import 'movies_connector/movies.dart';

extension GetCurrentUserUserFavoriteMoviesMovieExtension
    on GetCurrentUserUserFavoriteMoviesMovie {
  ListMoviesMovies get toListMoviesMovies => ListMoviesMovies(
      id: id,
      title: title,
      imageUrl: imageUrl,
      description: description,
      genre: genre,
      rating: rating,
      releaseYear: releaseYear,
      tags: tags);
}

extension GetCurrentUserUserWatchedMoviesMovieExtension
    on GetCurrentUserUserWatchedMoviesMovie {
  ListMoviesMovies get toListMoviesMovies => ListMoviesMovies(
      id: id,
      title: title,
      imageUrl: imageUrl,
      description: description,
      genre: genre,
      rating: rating,
      releaseYear: releaseYear,
      tags: tags);
}

extension SearchAllMoviesMatchingTitleExtension
    on SearchAllMoviesMatchingTitle {
  ListMoviesMovies get toListMoviesMovies => ListMoviesMovies(
        id: id,
        title: title,
        imageUrl: imageUrl,
        genre: genre,
        rating: rating,
      );
}

extension SearchAllMoviesMatchingDescriptionExtension
    on SearchAllMoviesMatchingDescription {
  ListMoviesMovies get toListMoviesMovies => ListMoviesMovies(
        id: id,
        title: title,
        imageUrl: imageUrl,
        genre: genre,
        rating: rating,
      );
}
