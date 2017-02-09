//
//  ViewController.swift
//  Test
//
//  Created by Wiem Ben Rim on 9/10/16.
//  Copyright © 2016 Wiem Ben Rim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


protocol FlickrPhotoDownloadDelegate {
    func finishedDownloading(_ photos:[Photo])
}

class ViewController: UIViewController  {
    let API_KEY = "3f2df9036a11ce44b5648929835b2bc6"
    let URL = "https://api.flickr.com/services/rest/"
    var collectionView: UICollectionView!
    var delegate:FlickrPhotoDownloadDelegate?
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        Alamofire.request(URL, method: .get , parameters: ["method": "flickr.photos.search", "api_key": API_KEY, "tags" : "Birthday" ,"privacy_filter":1, "format":"json", "nojsoncallback": 1], encoding: URLEncoding.default, headers: nil)
//        Alamofire.request(.GET, URL, parameters:  ["method": "flickr.photos.search", "api_key": API_KEY, "tags" : "Birthday" ,"privacy_filter":1, "format":"json", "nojsoncallback": 1])
                .responseJSON { (response) in
                    switch response.result {
                        case .success:
                            let jsonData:JSON = JSON(response.result.value!)
                            print(jsonData)
                            let photosDict = jsonData["photos"]
                            let photoArray = photosDict["photo"]
                            for item in photoArray  {
                                let id = item.1["id"].stringValue
                                let farm = item.1["farm"].stringValue
                                let server = item.1["server"].stringValue
                                let secret = item.1["secret"].stringValue
                                let title = item.1["title"].stringValue
                                let photo = Photo(id:id, title:title, farm:farm, secret: secret, server: server)
                                self.photos.append(photo)
                            }
                            
                            self.delegate?.finishedDownloading(self.photos)
                            self.initCollectionView()
                        
                        case .failure(let error):
                            print(error)
                    }
                }

    }

    func initCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 60, left: 2, bottom: 0, right: 2)

        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/4)
       
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "Cell")
        
        self.view.addSubview(collectionView)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        cell.imageView = UIImageView()
        cell.imageView.frame.size = cell.frame.size
        let url = photo.imageURL
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            let data = try? Data(contentsOf: url as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
            DispatchQueue.main.async(execute: {
                cell.imageView.image = UIImage(data: data!)
                cell.addSubview(cell.imageView)
            });
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let length = (UIScreen.main.bounds.width)/2.05
        return CGSize(width: length,height: length);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo:Photo? = photos[indexPath.row]
        if let photo = photo {
            let detailViewController = DetailViewController()
            detailViewController.photo = photo
            detailViewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 255/255, alpha: 0.1)
            detailViewController.modalPresentationStyle = .overCurrentContext
            present(detailViewController, animated: true, completion: nil)
        }
    }
    

}




