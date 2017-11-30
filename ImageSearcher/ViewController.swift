//
//  ViewController.swift
//  ImageSearcher
//
//  Created by Phoenix on 29.11.17.
//  Copyright © 2017 Phoenix_Dev. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    //MARK: - Properties
    let reusableCell = "CellID"
    let apikey = "pz2zmxgff7wn8ybutguteh98"
    
    // create property for search view
    let searchView = SearchView()
    
    var realm: Realm!
    
    lazy var historyArr: Results<HistoryItem> = {
        // get data from the database
        self.realm.objects(HistoryItem.self)
    }()
    
    //MARK: - Configuration
    
    func configNavBar() {
        navigationItem.title = "Image Searcher"
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.barTintColor = searchView.barColor
        navBar?.isTranslucent = false
        navBar?.isOpaque = false
    }

    
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // creates an instance of the Realm
        createRealm()

        view = searchView
        configNavBar()
        settingCollectionView()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        imageCache.removeAllObjects()
    }
    
    private func createRealm() {
        do {
            let realm = try Realm()
            self.realm = realm
        } catch let error {
            print("Created Realm is failed with error: ", error)
        }
    }
    
    private func settingCollectionView() {
        
        // register custom class for collection view cell
        searchView.historyCollectionView.register(HistoryCell.self, forCellWithReuseIdentifier: reusableCell)
        
        // set delegates
        searchView.historyCollectionView.delegate = self
        searchView.historyCollectionView.dataSource = self
        searchView.searchBar.delegate = self
    }
    
    func getSearchingImage(_ text: String) {
        let baseURL = "https://api.gettyimages.com/v3/search/images?phrase="
        let urlStr = baseURL + text
        
        // with the Optional Type, you can use "guard else", but in this case it is more convenient to work with "if"
        
        if let url = URL(string: urlStr) {
            
            // create object of URLRequest
            var request = URLRequest(url: url)
            
            // set a pair key: value "Api-Key: xxxxxx" for header
            request.setValue(apikey, forHTTPHeaderField: "Api-Key")
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    print("Fail with error: \(error)")
                    return
                }
                
                if let result = data {
                    do {
                        
                        // convert the received data in the dictionary
                        let resultJSON = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String: Any]

                        // get images array
                        let images = resultJSON["images"] as! [Any]
                        
                        // check whether the array is not empty
                        if !images.isEmpty {
                            
                            // get the first image
                            let firstImage = images.first as! [String: Any]
                            
                            // get image url
                            let dispSizes = firstImage["display_sizes"] as! [Any]
                            let info = dispSizes.first as! [String: Any]
                            let imageURL = info["uri"] as! String
                            
                            DispatchQueue.main.async {
                                
                                // add new item to history
                                self.addRequestResultToRealmBase(text, imageURL: imageURL)
                            }
                        } else {
                            
                            // if an empty output messages on the screen
                            DispatchQueue.main.async {
                                self.showAlert()
                            }
                        }
                        
                        
                    } catch let err {
                        print("Fail: \(err)")
                    }
                }
            }).resume()
            
        }
    }
    
    func addRequestResultToRealmBase(_ requestText: String, imageURL: String) {
        
        do {
            try self.realm.write {
                // create a new history object
                let newHistoryItem = HistoryItem()
                
                // set the property of object
                newHistoryItem.requestText = requestText
                newHistoryItem.imageUrl = imageURL
                
                // add the new object to database
                realm.add(newHistoryItem)
                print("add new item success")
            }
            
        } catch let error {
            print("Created Realm is failed with error: ", error)
        }
        
        // update info in collection view
        searchView.historyCollectionView.reloadData()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "No search results", message: "On your query results not found", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

//MARK: - UICollectonViewDataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCell, for: indexPath) as! HistoryCell
        
        // to display the latest queries first, place objects in reverse order
        // and get the one history object
        let historyItem = historyArr.reversed()[indexPath.item]
        
        // show information in history view
        cell.backgroundColor = UIColor.white
        cell.dateLabel.text = dateFormat(historyItem.searchDate)
        cell.requestLabel.text = historyItem.requestText
        
        // to save traffic, we cache loading images
        cell.imageView.loadImageUseingCacheWith(urlString: historyItem.imageUrl)
        
        
        searchView.activityIndicator.stopAnimating()
        return cell
    }
    
    func dateFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY HH:mm:ss"
        return "\(formatter.string(from: date))"
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 8, 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchView.searchBar.resignFirstResponder()
    }
    
}

//MARK: - UISerachbarDelegate

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("start searching with text \(searchBar.text!)")
        
        if let text = searchBar.text {
            getSearchingImage(text)
            searchView.activityIndicator.startAnimating()
        }
        
        searchBar.resignFirstResponder()
    }
}
