//
//  CellViewModel.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import Foundation

/// Provides a UITableViewCell or UICollectionViewCell reuse identifier.
protocol CellIdentifiable: AnyObject {
    var cellIdentifier: String { get }
}

/// A generic view model type for view controllers to work with.
protocol CellViewModel: CellIdentifiable {
    
}

/// For view controllers to configure various cell view models in a generic way.
protocol CellViewModelConfigurable {
    /// Called from `tableView:cellForRowAt:` or `collectionView:cellForItemAtIndexPath:`
    func configure(cellViewModel: CellViewModel)
    
    /// Called from `tableView:willDisplayCell:forItemAtIndexPath:` or `collectionView:willDisplayCell:forItemAtIndexPath:`
    func configureWillDisplayCell(cellViewModel: CellViewModel)

    /// Called from `tableView(_:didEndDisplaying:forRowAt:)` or `collectionView(_:didEndDisplaying:forItemAt:)`
    func configureDidEndDisplaying(cellViewModel: CellViewModel)
}

// MARK: Default Implementation
extension CellViewModelConfigurable {
    func configure(cellViewModel: CellViewModel) {}
    
    func configureWillDisplayCell(cellViewModel: CellViewModel) {}
    
    func configureDidEndDisplaying(cellViewModel: CellViewModel) {}
}
