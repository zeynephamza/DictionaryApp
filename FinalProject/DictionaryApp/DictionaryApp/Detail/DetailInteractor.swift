//
//  DetailInteractor.swift
//  DictionaryApp
//
//  Created by Zeynep Özcan on 19.05.2024.
//

import Foundation
import DictionaryAPI

protocol DetailInteractorProtocol: AnyObject {
    var presenter: DetailInteractorOutputProtocol? { get set }
    func fetchWordDetail(for word: String)
}

protocol DetailInteractorOutputProtocol: AnyObject {
    func didFetchWordDetail(_ word: WordElement)
    func didFailToFetchWordDetail(with error: Error)
    func didFetchSynonymDetail(_ wordElement: WordElement) 
}

class DetailInteractor: DetailInteractorProtocol {
    weak var presenter: DetailInteractorOutputProtocol?
    let service: WordServiceProtocol = WordService()

    
    func fetchWordDetail(for word: String) {
        service.fetchWordData(for: word) { [weak self] result in
            switch result {
            case .success(let wordElement):
                self?.presenter?.didFetchWordDetail(wordElement)
                self?.presenter?.didFetchSynonymDetail(wordElement) 
            case .failure(let error):
                self?.presenter?.didFailToFetchWordDetail(with: error)
            }
        }
    }
}

