//
//  File.swift
//  XMLParseDemo
//
//  Created by Dnyaneshwar on 11/01/21.
//

import Foundation
import CoreData

protocol  getDataFromCoreDataDelegate  {
    func getDataFromCoredata(temp: [Movie])
}

class ConfigManager: NSObject {
    static let shared = ConfigManager()
    var movies: [Movie] = []
    var delegateCustom : getDataFromCoreDataDelegate?
}

extension ConfigManager {
    
    func getAlbumData() {
        CoreDataManager.shared.fetchAllData { (object) in
            object.forEach { (obj) in
                guard let title = obj.value(forKey: "mtitle") as? String else { return }
                guard let link = obj.value(forKey: "mlinkurl") as? String else { return }
                guard let albumURL = obj.value(forKey: "malbumURL") as? String else { return }
                let book = Movie(title: title, imageLinkUrl: link, albumURL: albumURL)
                self.movies.append(book)
            }
            self.delegateCustom?.getDataFromCoredata(temp: movies)
        }
    }
 
    func checkLocalData() -> Int {
        let result = CoreDataManager.shared.fetchData()
        return result
    }
}
