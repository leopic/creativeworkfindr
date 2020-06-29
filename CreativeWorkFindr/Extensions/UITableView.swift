import UIKit

// Taken from https://medium.com/@mtssonmez/handle-empty-tableview-in-swift-4-ios-11-23635d108409
extension UITableView {
  func setEmptyView(title: String, message: String) {
    let marginLarge: CGFloat = 20.0
    let marginSmall: CGFloat = 8.0

    let emptyView = UIView(frame: CGRect(x: center.x, y: center.y, width: bounds.size.width, height: bounds.size.height))

    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    if #available(iOS 13.0, *) {
      titleLabel.textColor = .label
    } else {
      titleLabel.textColor = .black
    }
    titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
    titleLabel.alpha = 0
    emptyView.addSubview(titleLabel)
    titleLabel.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 20).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
    titleLabel.text = title

    let messageLabel = UILabel()
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    if #available(iOS 13.0, *) {
      messageLabel.textColor = .secondaryLabel
    } else {
      messageLabel.textColor = .darkGray
    }
    messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
    emptyView.addSubview(messageLabel)
    messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: marginSmall).isActive = true
    messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: marginLarge).isActive = true
    messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -marginLarge).isActive = true
    messageLabel.text = message
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    messageLabel.alpha = 0

    UIView.animate(withDuration: 0.4) {
      titleLabel.alpha = 1
      messageLabel.alpha = 1
    }

    // The only tricky part is here:
    backgroundView = emptyView
    separatorStyle = .none
  }

  func restore() {
    backgroundView = nil
    separatorStyle = .singleLine
  }
}
