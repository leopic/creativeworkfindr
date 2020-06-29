import Foundation

extension Int {
  static func ==(lhs: Int, rhs: CreativeWorkListViewController.Section) -> Bool {
    lhs == rhs.rawValue
  }
}
