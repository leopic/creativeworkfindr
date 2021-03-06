import UIKit
import SDWebImage

class CreativeWorkCell: UITableViewCell {
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var thumbnail: UIImageView!

  var work: CreativeWork! {
    didSet {
      self.titleLabel.text = self.work.title
      self.yearLabel.text = self.work.year
      self.summaryLabel.text = "\(self.work is Movie ? "Plot:" : "Summary:") \(self.work.summary)"

      guard let thumbnailURL = self.work.thumbnailURL else { return }
      self.thumbnail.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "no-image"))
    }
  }
}
