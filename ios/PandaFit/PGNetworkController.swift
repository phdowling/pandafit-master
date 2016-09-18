//
//  PGNetworkController.swift
//  PandaFit
//
//  Created by Felix Sonntag on 17/09/16.
//  Copyright © 2016 Felix Sonntag. All rights reserved.
//

import UIKit
import Alamofire

class PGNetworkController: NSObject {        
    
    let baseUrl = "http://ec2-52-39-53-104.us-west-2.compute.amazonaws.com/"
    
    func getPandaState(name: String, completion:@escaping (Panda) -> Void) -> Void {
        Alamofire.request("\(baseUrl)score/\(name)").responseJSON { response in
            print("Got state, result: \(response.result)")
            switch response.result{
            case .success:
                if let JSON = response.result.value {
                    let dict = JSON as! NSDictionary
                    let panda = Panda(name: name, score: dict.value(forKey: "score") as! Int)
                    completion(panda)
                }

            case .failure:
                print("Request failed")
                
            }
        }
    }

    func postSteps(name: String, numberSteps: Int) {
        let parameters: Parameters = [
            "numSteps": numberSteps
        ]
        print(parameters)
        Alamofire.request("\(baseUrl)steps/\(name)", method: .post, parameters: parameters, encoding: JSONEncoding.default).response { (response) in
            print("Posted steps.")
        }
    }
}
