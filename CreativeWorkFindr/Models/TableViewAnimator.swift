import UIKit

// Based on https://www.vadimbulavin.com/tableviewcell-display-animation/

typealias TableViewAnimation = (UITableViewCell, IndexPath, UITableView) -> Void

final class TableViewAnimator {
  var animation: TableViewAnimation?

  private var animatedCellList = [IndexPath]()

  init(animation: TableViewAnimation? = nil) {
    self.animation = animation
  }

  func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) -> Void {
    guard !animatedCellList.contains(indexPath),
          let animation = animation else { return }

    animation(cell, indexPath, tableView)
    animatedCellList.append(indexPath)
  }

  func reset() -> Void {
    animatedCellList.removeAll()
  }
}
