//
//  RepoWebserviceManager.swift
//  HomeDepot_CodeChallange
//
//  Created by  MyMac on 4/27/18.
//  Copyright © 2018 asdf. All rights reserved.
//

import UIKit
import Foundation

struct RepoWebserviceManager{
    
    /**
     * API to get repo list
     */
    static func getRepoList(url: String, completionHandler: @escaping ((_ schoolsInfo:[RepoItem]?, _ error:Error?) -> Void)) {
        let session = URLSession.shared
        let task = session.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard response != nil else{return}
            guard let data = data else {
                print("Invalid response")
                return
            }
            do{
                let jsonStr = try JSONDecoder().decode([RepoItem].self, from: data)
                #if DEBUG
                print(jsonStr)
                #endif

                completionHandler(jsonStr, nil)
            } catch {
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
 }
}
