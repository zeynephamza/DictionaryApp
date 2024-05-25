//
//  HistoryCellPresenter.swift
//  DictionaryApp
//
//  Created by Zeynep Özcan on 19.05.2024.
//

import Foundation

protocol HistoryCellPresenterProtocol{
    func addRecentSearch(_ search: String)
    func numberOfRecentSearches() -> Int
    func recentSearch(at index: Int) -> String
    func configureCell(_ cell: HistoryTableCellProtocol, with word: String)
    func clearSearchHistory()
    func loadSearchHistory()

}

class HistoryCellPresenter{
    private var recentSearches: [String] = []
    private let userDefaultsKey = "SearchHistory"
    
    init() {
        loadSearchHistory()
    }
    
    func clearSearchHistory() {
        recentSearches.removeAll()
        saveSearchHistory()
    }
    
    private func saveSearchHistory() {
        UserDefaults.standard.set(recentSearches, forKey: userDefaultsKey)
    }


}

extension HistoryCellPresenter: HistoryCellPresenterProtocol{
    func numberOfRecentSearches() -> Int {
        return recentSearches.count
    }
    
    func recentSearch(at index: Int) -> String {
        return recentSearches[index]
    }
    
    func configureCell(_ cell: HistoryTableCellProtocol, with word: String) {
        cell.setHistoryLabel(word)
    }
    func addRecentSearch(_ searchText: String) {
        
        if recentSearches.contains(searchText){
            guard var existingIndx = recentSearches.firstIndex(of: searchText) else { return }
            recentSearches.remove(at: existingIndx)
        }
        
        
        recentSearches.insert(searchText, at: 0) //insert at the beginning
        if recentSearches.count > 5 {
            recentSearches.removeLast() //remove from the last
        }
        UserDefaults.standard.set(recentSearches, forKey: "SearchHistory") // Save to UserDefaults
    
    }
    func loadSearchHistory() {
        if let savedSearches = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] {
            recentSearches = savedSearches
        }
    }

}
