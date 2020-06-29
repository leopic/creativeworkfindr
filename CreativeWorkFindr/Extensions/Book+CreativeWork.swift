import Foundation

extension Book: CreativeWork {
  var creator: String {
    author
  }

  var summary: String {
    if let firstOption = longSummary?.first {
      return firstOption.trimmingCharacters(in: .whitespaces)
    }

    if let fallback = notes {
      return fallback.replacingOccurrences(of: "Source title:", with: "").trimmingCharacters(in: .whitespaces)
    }

    return "N/A"
  }

  var url: URL? {
    URL(string: "https://openlibrary.org\(key)")
  }

  var thumbnailURL: URL? {
    if let largeImage = coverImages?["large"] {
      return URL(string: largeImage)
    }

    if let coverId = coverId {
      return URL(string: "https://covers.openlibrary.org/b/id/\(coverId).jpg")
    }

    return Bundle.main.url(forResource: "no-image", withExtension: ".jpg")
  }

  var author: String {
    return authors?.first?["name"] ?? "Unknown"
  }

  var year: String? {
    if let firstOption = _year {
      return String(firstOption).trimmingCharacters(in: .whitespaces)
    }

    if let publishDate = publishDate,
      let year = publishDate.split(separator: ",").last {
      return String(year).trimmingCharacters(in: .whitespaces)
    }

    return nil
  }
}
