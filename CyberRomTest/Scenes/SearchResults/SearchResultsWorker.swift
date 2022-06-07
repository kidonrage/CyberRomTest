import UIKit

final class SearchResultsWorker {
    
    // MARK: - Private Properties
    private let defaultSession = URLSession(configuration: .default)
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    private var searchDataTask: URLSessionDataTask?
    
    // MARK: - Public Methods
    func searchForQuestions(byQuery query: String?, completion: @escaping (SearchQuestionsResponse?, Error?) -> Void) {
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
                
                do {
                    let decodedResponse = try jsonDecoder.decode(SearchQuestionsResponse.self, from: data)
                    completion(decodedResponse, error)
                } catch {
                    print("Error decoding response", error)
                    completion(nil, error)
                }
            }
            
            searchDataTask?.resume()
        }
    }
}
