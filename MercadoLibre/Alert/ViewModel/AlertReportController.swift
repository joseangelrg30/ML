//
//  AlertReportController.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 17/06/23.
//

import UIKit

class AlertReportController: UIViewController {
    @IBOutlet weak var alertContainerView: UIView!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertMessage: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    var viewModel: AlertViewModel!
    
    private var bindings = Bindings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard viewModel != nil else {
            assertionFailure("`viewModel` is required for \(Self.self) to work.")
            return
        }
        
        alertContainerView.layer.cornerRadius = 8.0
        
        viewModel.$alertAction
            .sink { [actionButton] in
                actionButton?.setTitle($0, for: .normal)
            }.store(in: &bindings)
        
        viewModel.$alertTitle
            .assign(to: \.text, on: alertTitle)
            .store(in: &bindings)
        
        viewModel.$alertMessage
            .assign(to: \.text, on: alertMessage)
            .store(in: &bindings)

    }
    
    @IBAction func tapInDefaultAction() {
        viewModel.handleTapInOKButton()
    }
    
}

extension AlertReportController: StoryboardInitializable {
    static var storyboardName: String {
        return "Alert"
    }
}
