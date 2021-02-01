//
//  DatabaseManager.swift
//  Portal
//
//  Created by Chandu Reddy on 22/01/21.
//

import Foundation
import Firebase
import FirebaseDatabase


final class DataBaseManager {
    
    static let shared = DataBaseManager()
    
    var ref1 = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    func insertUser(with User: Users) {
       // let key =   ref1.childByAutoId().key
       let values = [
            "FullName" : User.userName,
            "Email" : User.safeEmail,
            "Password" : User.userPassword
        ]
        ref1.child("Users").child(uid!).child("Users Data").setValue(values)
//        withCompletionBlock: { error, _ in
//            guard error == nil else {
//                print("Failed to write to the data base")
//                completion(false)
//                return
//            }
//            completion(true)
//        })

}
}

extension DataBaseManager {
    func insertTimesheet(with timeSheet : TimesheetData) {
        ref1.child("Users").child(uid!).child("TimesheetData").childByAutoId().setValue([
            "ProjectTitle" : timeSheet.projectTitle,
            "Date" : timeSheet.currentDate,
            "ProjectDescription" : timeSheet.projectDescription,
            "ProjectStatus" : timeSheet.projectStatus,
            "WorkingHours" : timeSheet.workingHours
        ])
    }
}





