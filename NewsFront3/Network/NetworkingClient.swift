//
//  NetworkingClient.swift
//  NewsFront3
//
//  Created by Reyvie Bautista on 11/14/19.
//  Copyright © 2019 ReyvieB. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingClient{
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
    
    func execute(_ url: URL, params: Parameters, completion: @escaping WebServiceResponse){
//        let urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "PUT"
//        AF.request(urlRequest)
        
        AF.request(url, method: .post, parameters: params).validate().responseJSON { response in
            if let error = response.error{
                completion(nil, error)
            } else if let jsonArray = response.value  {
                completion(jsonArray as? [[String : Any]], nil)
            } else if let jsonDict = response.value as? [String: Any] {
                completion([jsonDict], nil)
            }
        }
        
        

        
        
    }
    
}
