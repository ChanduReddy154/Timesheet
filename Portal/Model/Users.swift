//
//  Users.swift
//  Portal
//
//  Created by Chandu Reddy on 22/01/21.
//

import Foundation

struct Users {
    var userName : String
    var userEmail : String
    var userPassword : String
    var safeEmail : String {
            var safeEmailAddress = userEmail.replacingOccurrences(of: ".", with: "-")
            safeEmailAddress = safeEmailAddress.replacingOccurrences(of: "@", with: "-")
            return safeEmailAddress
        }

}
