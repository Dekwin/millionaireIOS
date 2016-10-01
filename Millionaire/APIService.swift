//
//  APIService.swift
//  Millionaire
//
//  Created by Igor Kasyanenko on 20.04.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIService {
    
    static func fetchData(fromSavedUrl url: URL,parameters:[String: AnyObject], callback: ((JSON?, NSError?) -> Void)?) {
        
        
        Alamofire.request( url, method: .post, parameters: parameters).responseJSON { (response) -> Void in
         
            guard response.result.value != nil else
            {
                print(response.result.error);
                callback?(nil, response.result.error as NSError?);
                return;
            }
            
            
            callback?(JSON(response.result.value!),nil);
            
            
        }
        
    }
    
    /*
    func encrypt(callback: (error:NSError,hash:String)->Void) {
        Alamofire.request(.GET, url,parameters: parameters).responseJSON { (response) -> Void in
            
            guard let value = response.result.value else
            {
                callback?(nil, response.result.error);
                return;
            }
            
            
            callback?(JSON(response.result.value!),nil);
            
            
        }

    }*/
    
   
    
}
