//
//  DetailViewController.swift
//  Test
//
//  Created by Wiem Ben Rim on 9/11/16.
//  Copyright © 2016 Wiem Ben Rim. All rights reserved.
//

import UIKit
import Haneke

class DetailViewController: UIViewController {
    
    var photo:Photo?
    var imageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
       
        
        if let photo = photo {
            
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
            imageView?.hnk_setImage(from: photo.imageURL)
            view.addSubview(imageView!)
            
            let tapGestureRecogonizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.close))
            view.addGestureRecognizer(tapGestureRecogonizer)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- viewDidLayoutSubviews
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        let size = view.bounds.size
        let imageSize = CGSize(width: size.width,height: size.width)
        imageView?.frame = CGRect(x: 0.0, y: (size.height - imageSize.height)/2.0, width: imageSize.width, height: imageSize.height)
        
    }
    // MARK:- close
    func close() {
        dismiss(animated: true, completion: nil)
    }
}
