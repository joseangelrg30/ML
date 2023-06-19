//
//  SearchViewController.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var showingLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    private var bindings = Bindings()

    var viewModel: SearchViewModel! {
        didSet {
            viewModel.displayDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Buscar Producto"
        self.navigationItem.largeTitleDisplayMode = .always

        guard viewModel != nil else {
            assertionFailure("`viewModel` is required for `\(Self.self)` to work.")
            return
        }
        
        viewModel?.$totalResults
            .assign(to: \.text, on: totalLabel)
            .store(in: &bindings)
        
        viewModel?.$limit
            .assign(to: \.text, on: showingLabel)
            .store(in: &bindings)
        
        viewModel?.$isSearchButtonEnabled
            .assign(to: \.isEnabled, on: searchButton)
            .store(in: &bindings)
        
        viewModel?.$isLoading
            .sink { [loadingView] in
                loadingView?.isHidden = !$0
            }
            .store(in: &bindings)
    }
}

// MARK: - StoryboardInitializable
extension SearchViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "SearchView"
    }
}

// MARK: - Actions
extension SearchViewController {
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        viewModel.handleSearch()
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func didEditTextField(_ sender: UITextField){
        viewModel.handleEditSearch(search: sender.text ?? "")
    }
}

// MARK: - SearchViewModelDisplayDelegate
extension SearchViewController: SearchViewModelDisplayDelegate {
    func viewModelDidRequestReload(_ viewModel: SearchViewModel) {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCellViewModels
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = viewModel.cellViewModel(at: indexPath) else {
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
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel.cellViewModel(at: indexPath) else {
            return
        }
        
        if let configurable = cell as? CellViewModelConfigurable {
            configurable.configureWillDisplayCell(cellViewModel: cellViewModel)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel.cellViewModel(at: indexPath) else {
            return
        }

        cellViewModel.handleSelection()
    }
}
