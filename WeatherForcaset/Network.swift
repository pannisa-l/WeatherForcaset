//
//  Network.swift
//  WeatherForcaset
//
//  Created by nisa.eem on 3/14/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class Network {
    static func requestWithParameter(url:String ,method: HTTPMethod, headers: HTTPHeaders? = nil ,params: [String: Any]?, success: @escaping (_ value: AnyObject?, _ error: Error?)-> Void) {
        
        let url = URL(string: url)
        
        Alamofire.AF.request(url!, method: method , parameters: params, headers: headers).responseData() { (response) in
            params?.forEach({print("Key: \($0.key) , Value: \($0.value)")})
            switch response.result {
            case .success(let json):
                success(json as AnyObject, nil)
                break
                
            case .failure(let error):
                success(nil, error)
                break
            }
        }
    }
 
}
