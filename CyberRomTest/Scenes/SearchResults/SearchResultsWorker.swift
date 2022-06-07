import UIKit

class SearchResultsWorker {
    
    private let defaultSession = URLSession(configuration: .default)
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    private var searchDataTask: URLSessionDataTask?
    
    func searchForQuestions(byQuery query: String?, completion: @escaping ([Question]?, Error?) -> Void) {
        searchDataTask?.cancel()
        
        guard let query = query, !query.isEmpty else {
            completion(nil, nil)
            return
        }
        
        if var urlComponents = URLComponents(string: "https://api.stackexchange.com/2.2/search") {
            urlComponents.query = "order=desc&sort=activity&site=stackoverflow&intitle=\(query)"
            
            guard let url = urlComponents.url else {
                return
            }
            
            searchDataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.searchDataTask = nil
                }
                
                guard let data = data,
                      let networkResponse = response as? HTTPURLResponse,
                      networkResponse.statusCode == 200,
                      let jsonDecoder = self?.jsonDecoder
                else {
                    completion(nil, nil)
                    return
                }
                
                var foundQuestions: [Question]?
                do {
                    let decodedResponse = try jsonDecoder.decode(Response.self, from: data)
                    foundQuestions = decodedResponse.items
                } catch {
                    print("Error decoding response", error)
                    completion(foundQuestions, error)
                }
                
                completion(foundQuestions, error)
            }
            
            searchDataTask?.resume()
        }
    }
}
