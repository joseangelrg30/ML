//
//  AppCoordinator.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()    
    var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        runAppLaunch()
    }
    
}

// MARK: - Flows
private extension AppCoordinator {
    
    func runAppLaunch() {
        let viewModel = SearchViewModel()
        viewModel.delegate = self
        
        let viewController = SearchViewController.makeFromStoryboard()
        viewController.viewModel = viewModel
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func runDetailWithProduct(with product: MLSearchResults.Product) {
        let viewModel = DetailViewModel(product: product)
        viewModel.delegate = self

        let viewController = DetailProductViewController.makeFromStoryboard()
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func runShowError(with error: MLErrors) {
        let title: String
        let message: String
        let titleForDismissButton: String
        
        switch error {
            case .couldNotConnectToServer:
                title = "Error"
                message = "Could not connect to server"
                titleForDismissButton = "OK"
            case .invalidRequestURLStringError:
                title = "Error"
                message = "Invalid request url"
                titleForDismissButton = "OK"
            case .responseModelParsingError:
                title = "Error"
                message = "There was an error while retrieving the information"
                titleForDismissButton = "OK"
        }
        
        let viewModel = AlertViewModel(alertTitle: title, alertMessage: message, alertAction: titleForDismissButton)
        viewModel.delegate = self
        
        let alertController = AlertReportController.makeFromStoryboard()
        alertController.viewModel = viewModel
        alertController.modalPresentationStyle = .overFullScreen
        alertController.modalTransitionStyle = .crossDissolve
        navigationController.present(alertController, animated: true, completion: nil)
    }

}

// MARK: SearchViewModelDelegate
extension AppCoordinator: SearchViewModelDelegate {
    func viewModelShouldDisplayError(_ viewModel: SearchViewModel, error: MLErrors) {
        runShowError(with: error)
    }
    
    func viewModel(_ viewModel: SearchViewModel, didSelect product: MLSearchResults.Product) {
        runDetailWithProduct(with: product)
    }
}

// MARK: AlertViewModelDelegate
extension AppCoordinator: AlertViewModelDelegate {
    func viewDidTapInDefaultAction(_ viewModel: AlertViewModel) {
        if let viewController = navigationController.visibleViewController as? AlertReportController {
            viewController.dismiss(animated: true)
        }
    }
}

// MARK: DetailViewModelDelegate
extension AppCoordinator: DetailViewModelDelegate {
    func viewModelShouldDisplayError(_ viewModel: DetailViewModel, error: MLErrors) {
        runShowError(with: error)
    }
}
