//
//  MockHistoryCell.swift
//  DictionaryAppTests
//
//  Created by Zeynep Özcan on 25.05.2024.
//

import Foundation
@testable import DictionaryApp
@testable import DictionaryAPI


class MockHistoryTableCell: HistoryCellPresenterProtocol {
    var a = false
    
    var labelText: String!
    var recentSearches = [String]()
    
    func clearSearchHistory() {
        a = true
    }
    
    
    func numberOfRecentSearches() -> Int {
        a = true
        return 1
    }
    
    func recentSearch(at index: Int) -> String {
        a = true
        return ""
        
    }
    
    func configureCell(_ cell: HistoryTableCellProtocol, with word: String) {
        a = true
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
        a = true
    }
    

    
    

    
    

    
}
