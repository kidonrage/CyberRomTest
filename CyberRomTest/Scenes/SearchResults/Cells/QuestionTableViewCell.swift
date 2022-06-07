import UIKit

final class QuestionTableViewCell: UITableViewCell {
    
    // MARK: - Static
    static let reuseId = "QuestionTableViewCell"

    // MARK: - IBOutlets
    @IBOutlet private(set) weak var questionTitleLabel: UILabel!
    @IBOutlet private(set) weak var authorPhotoImageView: RemoteImageView!
    @IBOutlet private(set) weak var authorNicknameLabel: UILabel!
    @IBOutlet private(set) weak var dateLabel: UILabel!
    @IBOutlet private(set) weak var answersCountLabel: UILabel!
    
    // MARK: - Public methods
    func configureUI(with config: UIConfig) {
        questionTitleLabel.text = config.questionTitle
        authorPhotoImageView.setImage(from: config.authorImageURL)
        authorNicknameLabel.text = config.authorNickname
        dateLabel.text = config.date
        answersCountLabel.text = config.answersCount
    }
}

// MARK: - UIConfig
extension QuestionTableViewCell {
    
    struct UIConfig {
        let questionTitle: String
        let authorImageURL: URL?
        let authorNickname: String
        let date: String
        let answersCount: String
    }
}
