//
//  WordService.swift
//
//
//  Created by Zeynep Özcan on 18.05.2024.
//

import Foundation
import Alamofire


public protocol WordServiceProtocol{
    
    func fetchWordData(for word: String, completion: @escaping (Result<WordElement, Error>) -> Void)
}

public class WordService: WordServiceProtocol {
    
    public init(){}
    
    public func fetchWordData(for word: String, completion: @escaping (Result<WordElement, any Error>) -> Void)   {
        print(word)
        let url = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
        _ = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        _ = DispatchQueue.global(qos: .utility)
        
        AF.request(url).responseDecodable(of: Word.self){ response in
            switch response.result {
            case .success(let dictionaryEntries):
                var entry: WordElement?
                entry = dictionaryEntries.first
                completion(.success(entry!))
            
            case .failure(let error):
                print("Error: \(error)")
            }
            
        }
    }
}

