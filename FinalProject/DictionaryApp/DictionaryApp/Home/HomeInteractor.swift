//
//  HomeInteractor.swift
//  DictionaryApp
//
//  Created by Zeynep Özcan on 18.05.2024.
//

import Foundation
import DictionaryAPI

protocol HomeInteractorProtocol: AnyObject {
    var presenter: HomeInteractorOutputProtocol? { get set }
    func fetchWordData(for word: String)
    func fetchWord(for word: String, completion: @escaping (Result<WordElement, Error>) -> Void)
}

protocol HomeInteractorOutputProtocol: AnyObject {
    func didFetchWordData(_ wordElement: WordElement)
    func didFailToFetchWordData(with error: Error)
}

final class HomeInteractor {
    var output: HomeInteractorOutputProtocol?
    weak var presenter: HomeInteractorOutputProtocol?
    let service: WordServiceProtocol = WordService()
}

extension HomeInteractor: HomeInteractorProtocol {
    //fetching word data using api service
    func fetchWordData(for word: String) {
        service.fetchWordData(for: word){ [weak self] result in
            switch result {
            case .success(let wordElement):
                self?.presenter?.didFetchWordData(wordElement)
                
            case .failure(let error):
                self?.presenter?.didFailToFetchWordData(with: error)
            }
        }
    }
    
    func fetchWord(for word: String, completion: @escaping (Result<WordElement, Error>) -> Void) {
        
        // API call is made here, which returns result using completion
        service.fetchWordData(for: word){ [weak self] result in
            switch result {
            case .success(_):
                completion(result)
                
            case .failure(let error):
                self?.presenter?.didFailToFetchWordData(with: error)
            
            }
        }
    }
}
