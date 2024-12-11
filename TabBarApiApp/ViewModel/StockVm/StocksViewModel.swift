//
//  StocksViewModel.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


//
//  StocksViewModel.swift
//  ApiParsingMVVM
//
//  Created by Muralidhar reddy Kakanuru on 12/5/24.
//

// StocksViewModel.swift (Refactored ViewModel)
import Foundation
import UIKit

class StocksViewModel {
    private var data: [stockArticle] = []
    private let sourceData: GitData = DataGit.shared
    
    var didUpdateData: (() -> ())?
    
    func fetchStocks() {
        sourceData.getData(url: ServerConstants.baseURL) { [weak self] (result: Stocks) in
            self?.data = result.articles
            self?.didUpdateData?()  
        }
    }
    
    func numberOfRows() -> Int {
        return data.count
    }
    
    func getArticle(at index: Int) -> stockArticle {
        return data[index]
    }
    
    func getImage(for url: String, completion: @escaping (UIImage?) -> Void) {
        sourceData.getImage(url: url, completion: completion)
    }
}
