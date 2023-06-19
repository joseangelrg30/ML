//
//  DetailProductViewController.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import UIKit

class DetailProductViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var attributesTableView: DynamicHeightTableView!

    private var bindings = Bindings()

    var viewModel: DetailViewModel! {
        didSet {
            viewModel.displayDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        guard viewModel != nil else {
            assertionFailure("`viewModel` is required for `\(Self.self)` to work.")
            return
        }

        viewModel?.$productTitle
            .assign(to: \.text, on: titleView)
            .store(in: &bindings)
        
        viewModel?.$price
            .assign(to: \.text, on: priceLabel)
            .store(in: &bindings)

        viewModel?.$isLoading
            .sink { [loadingView] in
                loadingView?.isHidden = !$0
            }
            .store(in: &bindings)

        viewModel.handleViewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Invalidate the collection view layout on device rotation
        collectionView.collectionViewLayout.invalidateLayout()
        
        // Get the currently visible index path
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        let firstVisibleIndexPath = visibleIndexPaths.first
        
        // Perform additional layout updates if needed
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.collectionView.collectionViewLayout.invalidateLayout()
            self?.collectionView.reloadData()
            
            if let selectedIndexPath = firstVisibleIndexPath {
                self?.collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: false)
            }
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.flashScrollIndicators()
    }
}

// MARK: - StoryboardInitializable
extension DetailProductViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "DetailView"
    }
}

// MARK: - DetailViewModelDisplayDelegate
extension DetailProductViewController: DetailViewModelDisplayDelegate {
    func viewModelDidRequestReload(_ viewModel: DetailViewModel) {
        collectionView.reloadData()
        attributesTableView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension DetailProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalPictures
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellViewModel = viewModel.cellViewModel(at: indexPath) else {
            return UICollectionViewCell()
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModel.cellIdentifier, for: indexPath)
        if let configurable = cell as? CellViewModelConfigurable {
            configurable.configure(cellViewModel: cellViewModel)
        }

        return cell

    }    
}

// MARK: - UICollectionViewDelegate
extension DetailProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel.cellViewModel(at: indexPath) else {
            return
        }
        
        if let configurable = cell as? CellViewModelConfigurable {
            configurable.configureWillDisplayCell(cellViewModel: cellViewModel)
        }
    }
}

extension DetailProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UITableViewDataSource
extension DetailProductViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalAttributes
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = viewModel.attributeCellViewModel(at: indexPath) else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath)
        if let configurable = cell as? CellViewModelConfigurable {
            configurable.configure(cellViewModel: cellViewModel)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension DetailProductViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel.attributeCellViewModel(at: indexPath) else {
            return
        }
        
        if let configurable = cell as? CellViewModelConfigurable {
            configurable.configureWillDisplayCell(cellViewModel: cellViewModel)
        }
    }
}
