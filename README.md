# creativeworkfindr
iOS UIKit based app to fetch movies and books 

Problems solved:
- Network concurrency: up to 20 network requests are being fired at the same time
- Using a common protocol, `CreativeWork`, to represent both movies and book instances
- Using a `SearchController` on a UITableView
