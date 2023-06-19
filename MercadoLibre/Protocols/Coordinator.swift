//
//  Coordinator.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import UIKit

public protocol Coordinator: AnyObject {
    
    /// The child coordinators managed by the coordinator.
    var childCoordinators: [Coordinator] { get set }
    
    /// The navigation controller used as a root view controller by the coordinator.
    var navigationController: UINavigationController { get set }
    
    /// Starts the coordinator.
    func start()
}

// MARK: - Public (Helpers)
public extension Coordinator {
    
    /// Removes the provided child coordinator if found in `childCoordinators`.
    /// - Parameter child: The child coordinator to be removed.
    func removeChildCoordinator(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
