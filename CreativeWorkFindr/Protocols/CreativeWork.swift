import Foundation

protocol CreativeWork {
  var title: String { get }
  var year: String? { get }
  var summary: String { get }
  var thumbnailURL: URL? { get }
  var creator: String { get }
  var url: URL? { get }
}
