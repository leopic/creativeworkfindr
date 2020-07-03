import UIKit

extension CreativeWorkListViewController: UITableViewDelegate {
  fileprivate typealias Factory = TableViewAnimationFactory

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard !UIAccessibility.isReduceMotionEnabled else { return }
    animator.animation = Factory.makeFadeAnimation(duration: 0.5, delayFactor: 0.05)
    animator.animate(cell: cell, at: indexPath, in: tableView)
  }
}
