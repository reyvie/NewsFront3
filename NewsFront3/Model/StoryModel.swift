//
//  UserModel.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/18/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import Foundation

struct StoryModel{
    //Story content:
    var title: String
    var content: String
    var created: String
    var age: String
    var acknowledged: String
    var favorite: String
    
    
    
    //Images content
    
    var id: String
    var url: String
    var story_id: String
    
//    init(jsonData: JSON){
//        
//        self.title = jsonData["Story"]["title"].stringValue
//        self.content = jsonData["Story"]["content"].stringValue
//        self.created = jsonData["Story"]["created"].stringValue
//        self.age = jsonData["Story"]["age"].stringValue
//        self.acknowledged = jsonData["Story"]["acknowledged"].stringValue
//        self.favorite = jsonData["Story"]["favorite"].stringValue
//        
//        self.id = jsonData["Images"]["id"].stringValue
//        self.url = jsonData["Images"]["url"].stringValue
//        self.story_id = jsonData["Images"]["story_id"].stringValue
//        
//    }
}
