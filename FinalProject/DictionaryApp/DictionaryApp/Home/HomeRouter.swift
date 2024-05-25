//
//  HomeRouter.swift
//  DictionaryApp
//
//  Created by Zeynep Özcan on 18.05.2024.
//

import Foundation
import UIKit
import DictionaryAPI

protocol HomeRouterProtocol: AnyObject {
    func navigateToDetail(from view: HomeViewControllerProtocol, with word: String, wordElement: WordElement)
}

class HomeRouter: HomeRouterProtocol {
    static func createModule() -> UIViewController {
        let viewController = HomeViewController()
        let interactor: HomeInteractorProtocol = HomeInteractor()
        let router: HomeRouterProtocol = HomeRouter()
        let presenter: HomePresenterProtocol & HomeInteractorOutputProtocol = HomePresenter(view: viewController, interactor: interactor, router: router)
        
        viewController.presenter = presenter
        interactor.presenter = presenter
        
        return viewController
    }
    
    
    func navigateToDetail(from view: HomeViewControllerProtocol, with word: String, wordElement: WordElement) {
        print("HomeRouter: Creating detail module with word: \(word)") // Debug

        let detailVC = DetailRouter.createModule(with: word, wordElement: wordElement)
        detailVC.modalPresentationStyle = .fullScreen
        if let viewController = view as? UIViewController {
            viewController.present(detailVC, animated: true, completion: nil)
        }
    }

}


