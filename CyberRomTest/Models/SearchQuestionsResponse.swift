import Foundation

struct SearchQuestionsResponse: Decodable {
    
    struct Item: Decodable {
        
        struct Owner: Decodable {
            let profileImage: String?
            let displayName: String?
        }
        
        let title: String
        let owner: Owner?
        let answerCount: Int
        let creationDate: Int
        let link: String
    }
    
    let items: [Item]
}
