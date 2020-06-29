import Foundation

struct Movie: Codable {
  var title: String
  var imdbId: String
  var plot: String?
  var year: String?
  var writer: String?
  var director: String?

  var poster: String

  enum CodingKeys: String, CodingKey {
    case title = "Title"
    case year = "Year"
    case poster = "Poster"
    case imdbId = "imdbID"
    case plot = "Plot"
    case writer = "Writer"
    case director = "Director"
  }
}
