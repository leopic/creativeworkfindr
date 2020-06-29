import Foundation

struct Book: Codable {
  var title: String

  var key: String

  var notes: String?
  var longSummary: [String]?

  var _year: Int?
  var publishDate: String?

  var authors: [[String: String]]?

  var coverImages: [String: String]?
  var coverId: Int?

  enum CodingKeys: String, CodingKey {
    case title
    case _year = "first_publish_year"
    case publishDate = "publish_date"
    case authors = "authors"
    case coverId = "cover_i"
    case coverImages = "cover"
    case notes
    case key
  }
}
