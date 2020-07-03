import UIKit

class CreativeWorkDetailViewController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var authorYearLabel: UILabel!
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var detailsButton: UIButton!

  @IBAction func didTapOnDetailsButton(_ sender: Any) {
    guard let url = work.url,
      UIApplication.shared.canOpenURL(url) else {
      return
    }

    UIApplication.shared.open(url)
  }

  var work: CreativeWork! {
    didSet {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }

        self.titleLabel.text = self.work.title
        self.authorYearLabel.text = "\(self.work.creator), \(self.work.year ?? "N/A")"
        self.summaryLabel.text = "\(self.work is Movie ? "Plot:" : "Summary:") \(self.work.summary)"

        if let thumbnailURL = self.work.thumbnailURL {
          self.image.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "no-image"))
        }

        self.detailsButton.heightAnchor.constraint(equalToConstant: 0.0).isActive = self.work.url == nil
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = false
  }
}
