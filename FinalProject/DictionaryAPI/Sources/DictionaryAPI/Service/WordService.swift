import Foundation
import Alamofire

public protocol WordServiceProtocol {
    func fetchWordData(for word: String, completion: @escaping (Result<WordElement, Error>) -> Void)
}

public class WordService: WordServiceProtocol {
    
    public init() {}
    
    public func fetchWordData(for word: String, completion: @escaping (Result<WordElement, Error>) -> Void) {
        
        let url = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
        let url2 = "https://api.datamuse.com/words?rel_syn=\(word)"
        
        guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let encodedURL2 = url2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        DispatchQueue.global(qos: .utility).async {
            AF.request(encodedURL).responseDecodable(of: Word.self) { response in
                switch response.result {
                case .success(let dictionaryEntries):
                    guard var entry = dictionaryEntries.first else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No entries found"])))
                        return
                    }
                    
                    AF.request(encodedURL2).responseDecodable(of: [WordElement].self) { response in
                        switch response.result {
                        case .success(let dictionaryEntriesSyn):
                            let synonyms = dictionaryEntriesSyn.prefix(MAX_NUM).compactMap { $0.word }
                            entry.synonyms_api = Array(synonyms)
                            completion(.success(entry))
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
