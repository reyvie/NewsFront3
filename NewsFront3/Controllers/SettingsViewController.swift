//
//  SettingsViewController.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/6/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    let tagImage = ["TeamChamps", "PHP", "Radio", "Newsroom", "Mobile", "DotNet", "Runners", "Paddlers", "SQA", "Human Resources", "Clinic"]
    var statusSwitch = [false, false, true, true,true, true,true, true,true, true, true ]
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingsTableViewCell
        
        cell.tagLabelBtn.setImage(UIImage(named: tagImage[indexPath.row] + ".png"), for: UIControl.State.normal)
        
        cell.tagLabelBtn.setTitle(tagImage[indexPath.row], for: .normal)
        cell.tagSwitch.isOn = statusSwitch[indexPath.row]
        
        return (cell)
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            //tableView.deselectRow(at: indexPath, animated: true)

            
    //        let vc = storyboard?.instantiateViewController(withIdentifier: "LikeViewController")
    //
    //        self.navigationController?.pushViewController(vc!, animated: true)
            
        }
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
