import Foundation

/// Данные для отображения вопроса в компактном виде
struct ShallowQuestionViewModel {
    
    let title: String
    let ownerNickname: String
    let ownerAvatarURL: URL?
    let answerCount: String
    let creationDate: String
}
