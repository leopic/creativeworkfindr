import UIKit

class CreativeWorkListViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  var results = (books: [Book](), movies: [Movie]())
  var state: SearchState = .notStarted {
    didSet {
      updateResults()
    }
  }

  private let searchController = UISearchController(searchResultsController: nil)
  private let store = CreativeWorkStore()

  enum Section: Int, CaseIterable {
    case books = 1
    case movies = 0
  }

  enum SearchState {
    case notStarted
    case inProgress
    case completed
    case failed
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search CreativeWorks"
    searchController.searchBar.delegate = self

    definesPresentationContext = true

    tableView.dataSource = self

    navigationItem.searchController = searchController
    navigationItem.title = "CreativeWorkFindr"
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let vc = segue.destination as? CreativeWorkDetailViewController,
      let indexPath = tableView.indexPathForSelectedRow,
      segue.identifier == "showCreativeWorkDetail" else { return }

    vc.work = indexPath.section == Section.books ? results.books[indexPath.row] : results.movies[indexPath.row]
  }

  private func updateResults() -> Void {
    DispatchQueue.main.async { [weak self] in
      self?.tableView.reloadData()
    }
  }

  func clearResults() -> Void {
    results = (books: [Book](), movies: [Movie]())
    updateResults()
  }

  func loadResults(forTerm: String) -> Void {
    state = .inProgress

    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }

      switch self.store.find(byTerm: forTerm) {
      case .failure(let error):
        print("Error: \(error.description)")
        self.state = .failed
      case .success(let works):
        self.results = works
        self.state = .completed
      }
    }
  }
}
