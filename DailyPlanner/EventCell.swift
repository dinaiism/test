
import UIKit

class EventCell: UITableViewCell {
  
    lazy var eventLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        selectionStyle = .none
        contentView.addSubview(eventLabel)
        
        NSLayoutConstraint.activate([
            eventLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            eventLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            eventLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eventLabel.text = nil
        backgroundColor = .clear
    }
}
