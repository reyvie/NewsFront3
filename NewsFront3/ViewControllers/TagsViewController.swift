//
//  TagsViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/7/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let images = ["TeamChamps Image", "PHP Image", "Radio Image", "Newsroom Image", "Mobile Image", "DotNet Image"]
    let icon = ["TeamChamps", "PHP", "Radio", "Newsroom", "Mobile", "DotNet"]
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagsCollectionViewCell
        let cellIndex = indexPath.item
        cell.tagImage.image = UIImage(named: images[cellIndex] + ".jpg")
        cell.tagIcon.image = UIImage(named: icon[cellIndex] + ".png")
        cell.tagLabel.text = icon[cellIndex]
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 0.0
        cell.layer.borderWidth = 0.5
        
//        cell.layer.shadowColor = UIColor.lightGray.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        cell.layer.shadowRadius = 6.0
//        cell.layer.shadowOpacity = 1.0
//        cell.layer.masksToBounds = false
//        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
//        cell.layer.backgroundColor = UIColor.clear.cgColor

        
        return cell
    }
               

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
