//
//  fullDetailsOfNewsViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/4/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class fullDetailsOfNewsViewController: UIViewController {
    //MARK: Properties
    
    //Story content:
    var titleContent: String = ""
    var content: String = ""
    var created: String = ""
    var age: String = ""
    var acknowledged: String = ""
    var favorite: String = ""
    
    //Images content
    var id: String = ""
    var url: String = ""
    var story_id: String = ""
    
    
    @IBOutlet weak var textContent: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var acknowledgeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleContent
        let convertHtmltoString = content.htmlToString
        textContent.text = convertHtmltoString
        designButton()
        downloadImg()

        
        //textContent.sizeToFit()
//        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height+100)

        // Do any additional setup after loading the view.
    }
    func downloadImg(){
        let url = URL(string: self.url)
        image.downloadImage(from: url!)
    }

    func designButton(){
        if(self.favorite == "0"){
            likeButton.setImage(UIImage(named: "Like.png"), for: .normal)
            likeButton.setTitle("Like", for: .normal)
            likeButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            likeButton.setImage(UIImage(named: "Liked.png"), for: .normal)
            likeButton.setTitle("Liked", for: .normal)
            likeButton.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        
        if(self.acknowledged == "0"){
            acknowledgeButton.setImage(UIImage(named: "Acknowledge.png"), for: .normal)
            acknowledgeButton.setTitle("Acknowledge", for: .normal)
            acknowledgeButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            acknowledgeButton.setImage(UIImage(named: "Acknowledged.png"), for: .normal)
            acknowledgeButton.setTitle("Acknowledged", for: .normal)
            acknowledgeButton.setTitleColor(UIColor.systemBlue, for: .normal)
        }
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
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
