  import XCTest

  @testable import CreativeWorkFindr

  class CreativeWorkStoreTests: XCTestCase {
    func testEmptyResults() {
      let movieListProvider = MockWorkListProvider(results: [])
      let bookListProvider = MockWorkListProvider(results: [])
      let mockListOperationProvider = MockListOperationProvider(movieProvider: movieListProvider, bookProvider: bookListProvider)
      let mockFetchMovieOperationProvider = MockFetchMovieOperationProvider()
      let mockFetchBookOperationProvider = MockFetchBookOperationProvider()
      let store = CreativeWorkStore(listOperationProvider: mockListOperationProvider, fetchMovieOperationProvider: mockFetchMovieOperationProvider, fetchBookOperationProvider: mockFetchBookOperationProvider)

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
      let bookListProvider = MockWorkListProvider(results: [])
      let mockListOperationProvider = MockListOperationProvider(movieProvider: movieListProvider, bookProvider: bookListProvider)
      let mockFetchMovieOperationProvider = MockFetchMovieOperationProvider()
      let mockFetchBookOperationProvider = MockFetchBookOperationProvider()
      let store = CreativeWorkStore(listOperationProvider: mockListOperationProvider, fetchMovieOperationProvider: mockFetchMovieOperationProvider, fetchBookOperationProvider: mockFetchBookOperationProvider)

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
      let mockListOperationProvider = MockListOperationProvider(movieProvider: movieListProvider, bookProvider: bookListProvider)
      let mockFetchMovieOperationProvider = MockFetchMovieOperationProvider()
      let mockFetchBookOperationProvider = MockFetchBookOperationProvider()
      let store = CreativeWorkStore(listOperationProvider: mockListOperationProvider, fetchMovieOperationProvider: mockFetchMovieOperationProvider, fetchBookOperationProvider: mockFetchBookOperationProvider)

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
      let mockListOperationProvider = MockListOperationProvider(movieProvider: movieListProvider, bookProvider: bookListProvider)
      let book = Book(title: "my book", key: "123")
      let mockFetchBookOperationProvider = MockFetchBookOperationProvider(provider: MockBookProvider(book: book))
      let movie = Movie(title: "my movie", imdbId: "456", poster: "http://url.com/logo.png")
      let mockFetchMovieOperationProvider = MockFetchMovieOperationProvider(provider: MockMovieProvider(movie: movie))
      let store = CreativeWorkStore(listOperationProvider: mockListOperationProvider, fetchMovieOperationProvider: mockFetchMovieOperationProvider, fetchBookOperationProvider: mockFetchBookOperationProvider)

      switch store.find(byTerm: "two results") {
      case .failure(_):
        XCTFail(".find failed to return valid results")
      case .success(let works):
        XCTAssertFalse(works.movies.isEmpty, "books are not empty?")
        XCTAssertFalse(works.books.isEmpty, "books are not empty?")
      }
    }
  }

  // #MARK: Helpers
  fileprivate class MockWorkListProvider: AsyncOperation, CreativeWorkListProvider {
    var result: Result<[String], CreativeWorkFindrError>!

    init(results: [String]? = nil, error: CreativeWorkFindrError? = nil) {
      if let error = error {
        self.result = .failure(error)
      }

      if let results = results {
        self.result = .success(results)
      }
    }

    override func main() {
      finish()
    }
  }

  fileprivate class MockMovieProvider: AsyncOperation, MovieProvider {
    var result: Result<Movie, CreativeWorkFindrError>!

    init(movie: Movie? = nil, error: CreativeWorkFindrError? = nil) {
      if let error = error {
        self.result = .failure(error)
      }

      if let movie = movie {
        self.result = .success(movie)
      }
    }

    override func main() {
      finish()
    }
  }

  fileprivate class MockBookProvider: AsyncOperation, BookProvider {
    var result: Result<Book, CreativeWorkFindrError>!

    init(book: Book? = nil, error: CreativeWorkFindrError? = nil) {
      if let error = error {
        self.result = .failure(error)
      }

      if let book = book {
        self.result = .success(book)
      }
    }

    override func main() {
      finish()
    }
  }

  fileprivate struct MockListOperationProvider: ListOperationProvidable {
    var movieProvider: MockWorkListProvider = MockWorkListProvider()
    var bookProvider: MockWorkListProvider = MockWorkListProvider()

    func fetchMovieListOperation(searchTerm: String) -> CreativeWorkListProvider {
      movieProvider
    }

    func fetchBookListOperation(searchTerm: String) -> CreativeWorkListProvider {
      bookProvider
    }
  }

  fileprivate struct MockFetchBookOperationProvider: FetchBookOperationProvidable {
    var provider: MockBookProvider = MockBookProvider()

    func fetchBookOperation(openLibraryId: String) -> BookProvider {
      provider
    }
  }

  fileprivate struct MockFetchMovieOperationProvider: FetchMovieOperationProvidable {
    var provider: MockMovieProvider = MockMovieProvider()

    func fetchMovieOperation(imdbId: String) -> MovieProvider {
      provider
    }
  }
