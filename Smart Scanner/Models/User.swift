//
//  User.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 15/8/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import Foundation

public struct User: Codable {
    public let _id: String
    public let name: String
    public let email: String
    public let notes: String
    public let nameCardImage: String
    public let hash: String
    public let addresses: [String]
    public let phoneNumbers: [String]
    
}
