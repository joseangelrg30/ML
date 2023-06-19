//
//  SearchViewModel.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func viewModel(_ viewModel: SearchViewModel, didSelect product: MLSearchResults.Product)
    func viewModelShouldDisplayError(_ viewModel: SearchViewModel, error: MLErrors)
}

protocol SearchViewModelDisplayDelegate: AnyObject {
    func viewModelDidRequestReload(_ viewModel: SearchViewModel)
}

class SearchViewModel: NSObject {
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isSearchButtonEnabled: Bool = false
    @Published private(set) var totalResults: String? = ""
    @Published private(set) var limit: String? = ""

    private var searchText: String? = ""
    private var cellViewModels = [SearchResultCellViewModel]()
    
    weak var delegate: SearchViewModelDelegate?
    weak var displayDelegate: SearchViewModelDisplayDelegate?

    func performSearch() {
        guard let text = searchText else {
            return
        }
        
        isLoading = true
        let webService = WebService(urlString: "https://api.mercadolibre.com/sites/MLA/search")
        webService.search(with: text) { [weak self] (searchResults, error) in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.delegate?.viewModelShouldDisplayError(self, error: error)
                }
            } else {
                let cellModels = searchResults?.results.map {
                    let searchModel = SearchResultCellViewModel(product: $0)
                    searchModel.delegate = self
                    return searchModel
                }
                
                DispatchQueue.main.async {
                    self.totalResults = "Total \(searchResults?.paging.total ?? 0)"
                    self.limit = "Mostrando \(searchResults?.paging.limit ?? 0)"
                    self.cellViewModels = cellModels ?? [SearchResultCellViewModel]()
                    self.displayDelegate?.viewModelDidRequestReload(self)
                    self.isLoading = false
                }
            }
        }
    }
}

// MARK: - Public Methods
extension SearchViewModel {
    var totalCellViewModels: Int {
        return cellViewModels.count
    }
    
    func cellViewModel(at indexPath: IndexPath) -> SearchResultCellViewModel? {
        guard cellViewModels.indices.contains(indexPath.row) else {
            return nil
        }
        return cellViewModels[indexPath.row]
    }
}

// MARK: - Handlers
extension SearchViewModel {
    func handleSearch() {
        //print("perform search of \(String(describing: searchText))")
        performSearch()
    }
    
    func handleEditSearch(search: String) {
        searchText = search
        
        if let searchTxt = searchText {
            isSearchButtonEnabled = searchTxt.trimmingCharacters(in: .whitespaces).count > 2
        }
    }
}

// MARK: - SearchResultCellViewModelDelegate
extension SearchViewModel: SearchResultCellViewModelDelegate {
    func viewModel(_ viewModel: SearchResultCellViewModel, didSelect product: MLSearchResults.Product) {
        //print("selected product \(product)")
        delegate?.viewModel(self, didSelect: product)
    }
}
