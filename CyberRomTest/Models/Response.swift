import Foundation

struct Response: Decodable {
    
    let items: [Question]
}

struct Question: Decodable {
    
    struct Owner: Decodable {
        let profileImage: String?
        let displayName: String?
    }
    
    let title: String
    let owner: Owner?
    let answerCount: Int
    let creationDate: Int
}
