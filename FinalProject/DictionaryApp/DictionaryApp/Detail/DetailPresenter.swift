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
}
class DetailPresenter: DetailPresenterProtocol, DetailInteractorOutputProtocol {
    var wordElement: DictionaryAPI.WordElement
    
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
        /*
        if let wordElement = wordElement {
            view?.displayWordDetails(wordElement)
        } else {
            interactor?.fetchWordDetail(for: word)
        }
         */
        view?.displayWordDetails(wordElement)
            
    }
}


extension DetailPresenter {
    func didFetchWordDetail(_ wordElement: WordElement) {
        view?.displayWordDetails(wordElement)
    }
    
    func didFailToFetchWordDetail(with error: Error) {
        view?.displayError(error.localizedDescription)
    }
}
/*
extension DetailPresenter: DetailInteractorOutputProtocol {
    func didFetchWordDetail(_ wordElement: WordElement) {
        print("DetailPresenter: didFetchWordDetail")
        view?.displayWordDetails(wordElement)
    }
    
    func didFailToFetchWordDetail(with error: Error) {
        print("DetailPresenter: didFailToFetchWordDetail")
        view?.displayError(error.localizedDescription)
    }
}*/
