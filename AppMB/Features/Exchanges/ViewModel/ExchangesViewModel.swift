//
//  ExchangesViewModel.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

final class ExchangesViewModel: ExchangesViewModelProtocol {
    
    // MARK: - Public Properties
    
    weak var delegate: ExchangesViewModelDelegate?
    
    // MARK: - Private Properties
    
    private let manager: MarketManagerProtocol
    private var exchanges: [ExchangeInfoModel] = []
    private var filteredExchanges: [ExchangeInfoModel] = []
    private var currentSearch: String = ""
    
    // Pagination
    private let pageSize = 20
    private let maxItems = 100
    private var isFetchInProgress = false
    private var hasReachedEnd = false
    
    // MARK: - Initializer
    
    init(manager: MarketManagerProtocol = MarketManager()) {
        self.manager = manager
    }
    
    // MARK: - Public Methods
    
    @MainActor
    func fetchExchanges() async {
        guard !isFetchInProgress else { return }
        
        hasReachedEnd = false
        isFetchInProgress = true
        delegate?.loading(isLoading: true)
        
        do {
            let fetchedExchanges = try await manager.fetchExchanges(start: 1, limit: pageSize)
            isFetchInProgress = false
            delegate?.loading(isLoading: false)
            exchanges = fetchedExchanges
            if fetchedExchanges.count < pageSize || exchanges.count >= maxItems {
                hasReachedEnd = true
            }
            applyFilters()
        } catch {
            isFetchInProgress = false
            delegate?.loading(isLoading: false)
            delegate?.onExchangesFetchError(StringHelper.errorTitleSorry, StringHelper.errorLoadMessage)
        }
    }
    
    @MainActor
    func loadMoreExchanges() async {
        guard !isFetchInProgress && !hasReachedEnd && exchanges.count < maxItems && currentSearch.isEmpty else { return }
        
        isFetchInProgress = true
        let nextStart = exchanges.count + 1
        let remaining = maxItems - exchanges.count
        let limit = min(pageSize, remaining)
        
        if limit <= 0 {
            hasReachedEnd = true
            isFetchInProgress = false
            return
        }
        
        delegate?.loadingMore(isLoading: true)
        
        do {
            let newExchanges = try await manager.fetchExchanges(start: nextStart, limit: limit)
            isFetchInProgress = false
            delegate?.loadingMore(isLoading: false)
            
            if newExchanges.isEmpty {
                hasReachedEnd = true
                return
            }
            
            exchanges.append(contentsOf: newExchanges)
            if newExchanges.count < limit || exchanges.count >= maxItems {
                hasReachedEnd = true
            }
            applyFilters()
        } catch {
            isFetchInProgress = false
            delegate?.loadingMore(isLoading: false)
        }
    }

    @MainActor
    func search(search: String) {
        currentSearch = search
        applyFilters()
    }
    
    // MARK: - Private Methods
    
    private func applyFilters() {
        var result = exchanges
        
        // Apply Search Filter First
        if !currentSearch.isEmpty {
            result = result.filter { 
                $0.name.lowercased().contains(currentSearch.lowercased()) ||
                $0.slug.lowercased().contains(currentSearch.lowercased())
            }
        }
        
        // Apply Sort: Largest Volume first (descending)
        result.sort { 
            let vol1 = $0.spotVolumeUSD ?? 0
            let vol2 = $1.spotVolumeUSD ?? 0
            return vol1 > vol2 
        }
        
        let totalVolume = exchanges.compactMap { $0.spotVolumeUSD }.reduce(0, +)
        delegate?.onTotalVolumeUpdate(totalVolume)
        
        filteredExchanges = result
        delegate?.onExchangesFetchSuccess(filteredExchanges)
    }
}
