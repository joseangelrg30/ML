//
//  AlertViewModel.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 17/06/23.
//

import Foundation

protocol AlertViewModelDelegate: AnyObject {
    func viewDidTapInDefaultAction(_ viewModel: AlertViewModel)
}

class AlertViewModel: NSObject {
    @Published private(set) var alertTitle: String?
    @Published private(set) var alertMessage: String?
    @Published private(set) var alertAction: String?
    
    weak var delegate: AlertViewModelDelegate?

    init(alertTitle: String? = nil, alertMessage: String? = nil, alertAction: String? = nil) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.alertAction = alertAction
    }
}

// MARK: - Handlers
extension AlertViewModel {
    func handleTapInOKButton() {
        delegate?.viewDidTapInDefaultAction(self)
    }
}
