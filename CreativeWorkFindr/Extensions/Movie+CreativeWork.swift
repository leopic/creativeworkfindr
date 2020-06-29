import Foundation

extension Movie: CreativeWork {
  var summary: String {
    plot ?? "N/A"
  }

  var creator: String {
    writer ?? director ?? "N/A"
  }

  var url: URL? {
    nil
  }

  var thumbnailURL: URL? {
    URL(string: poster)
  }
}
