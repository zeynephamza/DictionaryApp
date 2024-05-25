//
//  HomePresenter.swift
//  DictionaryApp
//
//  Created by Zeynep Özcan on 18.05.2024.
//

import Foundation
import DictionaryAPI

protocol HomePresenterProtocol: AnyObject {
    var view: HomeViewControllerProtocol? { get set }
    var interactor: HomeInteractorProtocol? { get set }
    var router: HomeRouterProtocol? { get set }

    func searchWord(_ word: String)
    func navigateToDetail(with word: String, wordElement: WordElement)
    func searchWord(_ word: String, completion: @escaping (WordElement) -> Void)
    
}


class HomePresenter: HomePresenterProtocol, HomeInteractorOutputProtocol {
    
    weak var view: HomeViewControllerProtocol?
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?

    init(view: HomeViewControllerProtocol, interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func searchWord(_ word: String, completion: @escaping (WordElement) -> Void) {
        interactor?.fetchWord(for: word) { result in
            switch result {
            case .success(let wordElement):
                completion(wordElement)
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }

    func searchWord(_ word: String) {
        interactor?.fetchWordData(for: word)
    }
    

    func didFetchWordData(_ wordData: WordElement) {
        view?.showWordDefinition(wordData)
    }

    func didFailToFetchWordData(with error: Error) {
        view?.showError(error.localizedDescription)
    }

    func navigateToDetail(with word: String, wordElement: WordElement) {
        router?.navigateToDetail(from: view!, with: word, wordElement: wordElement)
    }
}
