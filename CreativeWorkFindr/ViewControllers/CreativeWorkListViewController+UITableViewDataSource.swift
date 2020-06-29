import UIKit

fileprivate typealias Section = CreativeWorkListViewController.Section

extension CreativeWorkListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard state == .completed else { return nil }

    switch Section(rawValue: section) {
    case .books:
      return results.books.isEmpty ? nil : "Books"
    case .movies:
      return results.movies.isEmpty ? nil : "Movies"
    default:
      return nil
    }
  }

  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    guard state == .completed else { return nil }

    switch Section(rawValue: section) {
    case .books:
      return results.books.isEmpty ? nil : "Total: \(results.books.count)"
    case .movies:
      return results.movies.isEmpty ? nil : "Total: \(results.movies.count)"
    default:
      return nil
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    Section.allCases.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var rowCount = 0

    switch state {
    case .notStarted:
      tableView.setEmptyView(title: "Looks pretty empty around here", message: "Start looking for creative works")
    case .inProgress:
      tableView.setEmptyView(title: "Search in progress", message: "Please wait...")
    case .failed:
      tableView.setEmptyView(title: "Error", message: "There was an error retrieving your results")
    case .completed:
      if results.books.isEmpty && results.movies.isEmpty {
        tableView.setEmptyView(title: "No results", message: "Please try something else")
        return 0
      } else {
        tableView.restore()
        rowCount = section == Section.books ? results.books.count : results.movies.count
      }
    }

    return rowCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "creativeWorkCell") as? CreativeWorkCell else {
      return UITableViewCell()
    }

    cell.work = indexPath.section == Section.books ? results.books[indexPath.row] : results.movies[indexPath.row]
    return cell
  }
}
