//
//  ViewModel.swift
//  XMLParseDemo
//
//  Created by Dnyaneshwar on 11/01/21.
//

import Foundation
import UIKit

protocol  getDataDelegate  {
    func getDataFromAnotherVC(temp: [Movie])
}

class Constant {
    let baseURL = "https://rss.itunes.apple.com/api/v1/in/apple-music/top-songs/all/25/explicit.atom"
}

//1 - Setup my viewModel that inherits from NSObject
class MovieViewModel: NSObject,XMLParserDelegate {
   
    var parser = XMLParser()
    var elementName : String = String()
    var title = String()
    var imageURL = String()
    var albumURL = String()
    var movies: [Movie] = []
    var delegateCustom : getDataDelegate?
    
    // MARK: - This function is what directly accesses the apiClient to make the API call
    func getXMLDataFromServer() {
        parser = XMLParser(contentsOf:(NSURL(string:Constant().baseURL))! as URL)!
        parser.delegate = self
        parser.parse()
        // Data passing through delegate
        self.delegateCustom?.getDataFromAnotherVC(temp: movies)
    }  
    
    // MARK: - values to display in our table view controller
    func numberOfItemsToDisplay(in section: Int) -> Int {
        return movies.count
    }
    
    // MARK: - XMLParser Delegate Methods
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
         if (elementName as NSString).isEqual(to: "entry") {
            title = String()
            imageURL = String()
            albumURL = String()
        }
        if let href = attributeDict["href"] as? String {
            if href != Constant().baseURL {
                albumURL = href
            }
            
        }
        self.elementName = elementName
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print(albumURL)
        if elementName == "entry" {
            let book = Movie(title: title, imageLinkUrl: imageURL,albumURL:albumURL)
             movies.append(book)
        }
    }
     
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
           let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
           
           if (!data.isEmpty) {
               if self.elementName == "title" {
                   title += data
               } else if self.elementName == "im:image" {
                   imageURL += data
               }else if self.elementName == "im:artist" {
                albumURL += data
            }
           }
       }
}
















