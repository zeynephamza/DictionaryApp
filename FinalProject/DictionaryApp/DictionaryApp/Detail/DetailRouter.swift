import UIKit
import DictionaryAPI

protocol DetailRouterProtocol: AnyObject {
    static func createModule(with word: String, wordElement: WordElement) -> UIViewController
    func navigateToDetail(from view: DetailViewControllerProtocol, with word: String, wordElement: WordElement)
}

class DetailRouter: DetailRouterProtocol {

    // Detail page starts here.
    static func createModule(with word: String, wordElement: WordElement) -> UIViewController {
        let viewController = DetailViewController()
        let interactor: DetailInteractorProtocol = DetailInteractor()
        let router: DetailRouterProtocol = DetailRouter()
        let presenter: DetailPresenterProtocol & DetailInteractorOutputProtocol = DetailPresenter(view: viewController, interactor: interactor, router: router, word: word, wordElement: wordElement)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return viewController
    }
    func navigateToDetail(from view: DetailViewControllerProtocol, with word: String, wordElement: WordElement) {
        print("DetailRouter: Creating detail module with word: \(word)") 
        
        let detailVC = DetailRouter.createModule(with: word, wordElement: wordElement)
        detailVC.modalPresentationStyle = .fullScreen
        if let viewController = view as? UIViewController {
            viewController.present(detailVC, animated: true, completion: nil)
        }
        
    }
}
