//
//  DetailPresenter.swift
//  DictionaryApp
//
//  Created by Zeynep Özcan on 19.05.2024.
//
import Foundation
import DictionaryAPI

protocol DetailPresenterProtocol: AnyObject {
    var view: DetailViewControllerProtocol? { get set }
    var interactor: DetailInteractorProtocol? { get set }
    var router: DetailRouterProtocol? { get set }
    var word: String { get set }
    var wordElement: WordElement { get set }
    
    func viewDidLoad()
    func didFetchWordDetail(_ wordElement: WordElement)
    func didFailToFetchWordDetail(with error: Error)
    func didTapOnSynonym(_ synonym: String)
    func didFetchSynonymDetail(_ wordElement: WordElement)
}
class DetailPresenter: DetailInteractorOutputProtocol {
    var wordElement: WordElement
    
    weak var view: DetailViewControllerProtocol?
    var interactor: DetailInteractorProtocol?
    var router: DetailRouterProtocol?
    var word: String

    init(view: DetailViewControllerProtocol, interactor: DetailInteractorProtocol, router: DetailRouterProtocol, word: String, wordElement: WordElement?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.word = word
        self.wordElement = wordElement!
    }

    func viewDidLoad() {
        view?.displayWordDetails(wordElement)
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    
    func didFetchWordDetail(_ wordElement: WordElement) {
        view?.displayWordDetails(wordElement)
    }
    
    func didFailToFetchWordDetail(with error: Error) {
        view?.displayError(error.localizedDescription)
    }
    
    func didTapOnSynonym(_ synonym: String) {
        interactor?.fetchWordDetail(for: synonym)
    }
    
    func didFetchSynonymDetail(_ wordElement: WordElement) {
        router?.navigateToDetail(from: view!, with: wordElement.word ?? "", wordElement: wordElement)
    }
}
