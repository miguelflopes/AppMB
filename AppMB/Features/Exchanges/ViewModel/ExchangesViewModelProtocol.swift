//
//  ExchangesViewModelProtocol.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

protocol ExchangesViewModelProtocol {
    
    // MARK: - Properties
    
    var delegate: ExchangesViewModelDelegate? { get set }
    
    // MARK: - Methods
    
    @MainActor func fetchExchanges() async
    @MainActor func loadMoreExchanges() async
    @MainActor func search(search: String)
}
