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
    
    var labelText: String!
    var recentSearches = [String]()
    
    
    func addRecentSearch(_ searchText: String) {
        if recentSearches.contains(searchText){
            guard let existingIndx = recentSearches.firstIndex(of: searchText) else { return }
            recentSearches.remove(at: existingIndx)
        }
        recentSearches.insert(searchText, at: 0) //insert at the beginning
        if recentSearches.count > 5 {
            recentSearches.removeLast() //remove from the last
        }
    }
    
    func clearSearchHistory() {
        
    }
    
    func numberOfRecentSearches() -> Int {
        return recentSearches.count
    }
    
    func recentSearch(at index: Int) -> String {
        return recentSearches[index]
        
    }
    
    func configureCell(_ cell: HistoryTableCellProtocol, with word: String) {
        
    }
    
    func loadSearchHistory() {
        
    }
    

    
    

    
    

    
}
