  import XCTest

  @testable import CreativeWorkFindr

  class CreativeWorkStoreTests: XCTestCase {
    func testEmptyResults() {
      let movieListProvider = MockWorkListProvider()
      let bookListProvider = MockWorkListProvider()
      let bookProvider = MockBookProvider()
      let movieProvider = MockMovieProvider()
      let store = CreativeWorkStore(bookListProvider: bookListProvider, bookProvider: bookProvider, movieListProvider: movieListProvider, movieProvider: movieProvider)

      switch store.find(byTerm: "query that yields no results") {
      case .failure(_):
        XCTFail(".find failed to return an empty result set")
      case .success(let works):
        XCTAssertTrue(works.movies.isEmpty, ".find failed to return an empty movie list")
        XCTAssertTrue(works.books.isEmpty, ".find failed to return an empty book list")
      }
    }

    func testIgnoresErrorOnSingleDataSource() {
      let movieListProvider = MockWorkListProvider(error: .errorFetchingMovieList)
      let bookListProvider = MockWorkListProvider()
      let bookProvider = MockBookProvider()
      let movieProvider = MockMovieProvider()
      let store = CreativeWorkStore(bookListProvider: bookListProvider, bookProvider: bookProvider, movieListProvider: movieListProvider, movieProvider: movieProvider)

      switch store.find(byTerm: "no results, but an error fetching movies") {
      case .failure(_):
        XCTFail(".find failed to ignore an error on a datasource")
      case .success(let works):
        XCTAssertTrue(works.movies.isEmpty, ".find failed to return an empty movie list")
        XCTAssertTrue(works.books.isEmpty, ".find failed to return an empty book list")
      }
    }

    func testSurfacesErrorWhenBothDataSourcesFail() {
      let movieListProvider = MockWorkListProvider(error: .errorFetchingMovieList)
      let bookListProvider = MockWorkListProvider(error: .errorFetchingBookList)
      let bookProvider = MockBookProvider()
      let movieProvider = MockMovieProvider()
      let store = CreativeWorkStore(bookListProvider: bookListProvider, bookProvider: bookProvider, movieListProvider: movieListProvider, movieProvider: movieProvider)

      switch store.find(byTerm: "no results, errors on both datasources") {
      case .failure(let error):
        XCTAssertEqual(error, .generalFailure)
      case .success(_):
        XCTFail(".find failed to return an error when both datasources failed")
      }
    }

    func testValidResults() {
      let movieListProvider = MockWorkListProvider(results: ["123"])
      let bookListProvider = MockWorkListProvider(results: ["456"])
      let bookProvider = MockBookProvider()
      bookProvider.book = Book(title: "my book", key: "123")
      let movieProvider = MockMovieProvider()
      movieProvider.movie = Movie(title: "my movie", imdbId: "456", poster: "https://google.com/logo.png")
      let store = CreativeWorkStore(bookListProvider: bookListProvider, bookProvider: bookProvider, movieListProvider: movieListProvider, movieProvider: movieProvider)

      switch store.find(byTerm: "two results") {
      case .failure(_):
        XCTFail(".find failed to return valid results")
      case .success(let works):
        XCTAssertFalse(works.movies.isEmpty, "books are not empty?")
        XCTAssertFalse(works.books.isEmpty, "books are not empty?")
      }
    }
  }

  fileprivate class MockWorkListProvider: AsyncOperation, CreativeWorkListProvider {
    var error: CreativeWorkFindrError?
    var results = [String]()

    init(results: [String] = [], error: CreativeWorkFindrError? = nil) {
      self.results = results
      self.error = error
    }

    override func main() {
      finish()
    }
  }

  fileprivate class MockMovieProvider: AsyncOperation, MovieProvider {
    var movie: Movie!
    var error: CreativeWorkFindrError?

    override func main() {
      finish()
    }
  }

  fileprivate class MockBookProvider: AsyncOperation, BookProvider {
    var book: Book!
    var error: CreativeWorkFindrError?

    override func main() {
      finish()
    }
  }
