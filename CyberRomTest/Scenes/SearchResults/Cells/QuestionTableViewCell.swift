import UIKit

final class QuestionTableViewCell: UITableViewCell {
    
    static let reuseId = "QuestionTableViewCell"

    @IBOutlet private(set) weak var questionTitleLabel: UILabel!
    @IBOutlet private(set) weak var authorPhotoImageView: UIImageView!
    @IBOutlet private(set) weak var authorNicknameLabel: UILabel!
    @IBOutlet private(set) weak var dateLabel: UILabel!
    @IBOutlet private(set) weak var answersCountLabel: UILabel!
    
    func configureUI(with config: UIConfig) {
        questionTitleLabel.text = config.questionTitle
        if let authorImagePath = config.authorImagePath,
           let authorImageURL = URL(string: authorImagePath)
        {
            authorPhotoImageView.load(url: authorImageURL)
        }
        authorNicknameLabel.text = config.authorNickname
        dateLabel.text = config.date
        answersCountLabel.text = config.answersCount
    }
}

extension QuestionTableViewCell {
    
    struct UIConfig {
        let questionTitle: String
        let authorImagePath: String?
        let authorNickname: String
        let date: String
        let answersCount: String
    }
}
