//
//  MovieViewController.swift
//  XMLParseDemo
//
//  Created by Dnyaneshwar on 12/01/21.
//

import UIKit
import CoreData

class MovieViewController: UIViewController,XMLParserDelegate,getDataDelegate,getDataFromCoreDataDelegate {

    @IBOutlet weak var movieTableView: UITableView!
    let viewModel = MovieViewModel()
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigManager.shared.delegateCustom  = self
        self.checkedData()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK :- Check if data is store in coredata if not call API.
    func checkedData(){
        ConfigManager.shared.checkLocalData() == 0 ? getAlbumList() : ConfigManager.shared.getAlbumData()
    }
    func getAlbumList() {
        viewModel.delegateCustom = self
        viewModel.getXMLDataFromServer()
    }
    
    func getDataFromCoredata(temp: [Movie]){
        self.movies = temp
        print(temp.count)
    }
    
    func getDataFromAnotherVC(temp: [Movie]) {
        self.movies = temp
        self.insertValuesInCoredata(temp: temp)
    }
    
    func insertValuesInCoredata(temp : [Movie]){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let userEntity = NSEntityDescription.entity(forEntityName: AlbumConfiguration.entityName(), in: managedContext)!
            
            for item in self.movies{
                let movie = NSManagedObject(entity: userEntity, insertInto: managedContext)
                movie.setValue(item.title, forKeyPath: "mtitle")
                movie.setValue(item.imageLinkUrl, forKeyPath: "mlinkurl")
                movie.setValue(item.albumURL, forKeyPath: "malbumURL")
            }
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }

    }
     
}

extension MovieViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = self.movieTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCellNew
        let movie = self.movies[indexPath.row]
        cell.setConfigureData(rowModel: movie)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie  = self.movies[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        vc?.albumURLStr = movie.albumURL
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
