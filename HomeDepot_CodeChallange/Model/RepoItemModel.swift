//
//  RepoItemModel.swift
//  HomeDepot_CodeChallange
//
//  Created by  MyMac on 4/27/18.
//  Copyright © 2018 asdf. All rights reserved.
//
import Foundation

struct RepoItem : Codable{
    
    let repoName : String?
    let repoDescription : String?
    let repoCreated_at : String?
    let repoLicense : License?
    
    private enum CodingKeys: String, CodingKey
    {
        case repoName = "name"
        case repoDescription = "description"
        case repoCreated_at = "created_at"
        case repoLicense = "license"
    }
}

struct License: Codable{
    let key : String?
    let name : String?
    let spdx_id : String?
    let url : String?
    
}


