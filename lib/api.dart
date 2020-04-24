import 'package:talita/image_config.dart';

class Api {
  static String _api_key = '1b088d94b2b672e43fb86e45f714d3ea';
  String _token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYjA4OGQ5NGIyYjY3MmU0M2ZiODZlNDVmNzE0ZDNlYSIsInN1YiI6IjVlOWQ3NDVkNGE0YmZjMDAyM2Q3YmRjMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.5qp_0lbmQ6EzNE14LAkFrmFuMEDpdgUuthlLBoeSnQw';
  String _api_base = 'https://api.themoviedb.org/3/';
  String _api_cartoons = 'discover/movie?api_key=$_api_key&with_genres=16';
  String _guest_session = 'authentication/guest_session/new?api_key=$_api_key';

  String getCartoonsEndpoint() => _api_base + _api_cartoons;
  String getPopularCartoonsEndpoint({int pageIndex = 1}) {
    String popular_cartoons =
        'discover/movie?api_key=$_api_key&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=true&page=$pageIndex&with_genres=16';
    return _api_base + popular_cartoons;
  }

  String getLatestCartoonsEndpoint({int pageIndex = 1}) {
    String latest_cartoons =
        'discover/movie?api_key=$_api_key&language=en-US&sort_by=release_date.desc&include_adult=false&include_video=true&page=$pageIndex&with_genres=16';
    return _api_base + latest_cartoons;
  }

  String getTopRatedCartoonsEndpoint({int pageIndex = 1}) {
    String top_rated_cartoons =
        'discover/movie?api_key=$_api_key&language=en-US&sort_by=vote_average.desc&include_adult=false&include_video=true&page=$pageIndex&with_genres=16';
    return _api_base + top_rated_cartoons;
  }

// https://api.themoviedb.org/3/movie/920?api_key=1b088d94b2b672e43fb86e45f714d3ea&language=en-US

  String getMovieDetailsEndpoint(String movieId) =>
      _api_base + 'movie/$movieId?api_key=$_api_key&language=en-US';

// https://api.themoviedb.org/3/movie/{movie_id}/videos?api_key=1b088d94b2b672e43fb86e45f714d3ea&language=en-US

  String getMovieVideos(String movieId) =>
      _api_base + 'movie/$movieId/videos?api_key=$_api_key&language=en-US';

  String getPosterUrl({String path, String size = PosterSizes.original}) =>
      ImageConfig.base_url + size + path;

  String getCastAndCrewEndPoint(String movieId) =>
      _api_base + "movie/$movieId/credits?api_key=$_api_key";
}

// {
//   "genres": [
//     {
//       "id": 28,
//       "name": "Action"
//     },
//     {
//       "id": 12,
//       "name": "Adventure"
//     },
//     {
//       "id": 16,
//       "name": "Animation"
//     },
//     {
//       "id": 35,
//       "name": "Comedy"
//     },
//     {
//       "id": 80,
//       "name": "Crime"
//     },
//     {
//       "id": 99,
//       "name": "Documentary"
//     },
//     {
//       "id": 18,
//       "name": "Drama"
//     },
//     {
//       "id": 10751,
//       "name": "Family"
//     },
//     {
//       "id": 14,
//       "name": "Fantasy"
//     },
//     {
//       "id": 36,
//       "name": "History"
//     },
//     {
//       "id": 27,
//       "name": "Horror"
//     },
//     {
//       "id": 10402,
//       "name": "Music"
//     },
//     {
//       "id": 9648,
//       "name": "Mystery"
//     },
//     {
//       "id": 10749,
//       "name": "Romance"
//     },
//     {
//       "id": 878,
//       "name": "Science Fiction"
//     },
//     {
//       "id": 10770,
//       "name": "TV Movie"
//     },
//     {
//       "id": 53,
//       "name": "Thriller"
//     },
//     {
//       "id": 10752,
//       "name": "War"
//     },
//     {
//       "id": 37,
//       "name": "Western"
//     }
//   ]
// }
