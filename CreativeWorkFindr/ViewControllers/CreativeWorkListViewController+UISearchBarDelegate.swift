import UIKit

extension CreativeWorkListViewController: UISearchBarDelegate {
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    guard let text = searchBar.text,
      CreativeWorkStore.validateSearch(term: text) else { return }
    loadResults(forTerm: text)
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    state = .notStarted
    clearResults()
  }
}
