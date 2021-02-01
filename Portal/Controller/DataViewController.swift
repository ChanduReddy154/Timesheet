//
//  ViewController.swift
//  Portal
//
//  Created by Chandu Reddy on 22/01/21.
//

import UIKit
import Firebase


class DataViewController: UIViewController {
@IBOutlet var tableView: UITableView!
    
   // @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var backgrndView: UIView!
    var projectArray = [TimesheetData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
       // backgroundView.layer.cornerRadius = 40
        //backgroundView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        updateProjectDetails()
        noMsglabel.isHidden = true
    }
    
    let noMsglabel : UILabel = {
        let label = UILabel()
        label.text = "No Timesheets"
        label.frame = CGRect(x: 50, y: 150, width: 100, height: 50)
        return label
    }()
    func updateProjectDetails() {
        let ref1 = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref1.child("Users").child(uid!).child("TimesheetData").queryOrderedByKey().observe(.value) { [self] (snapshot) in
            projectArray.removeAll()
            if let snapshotData = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshotData {
                    if let mainDict = snap.value as? [String : AnyObject] {
                        let pTitle = mainDict["ProjectTitle"] as! String
                        let pDate = mainDict["Date"] as! String
                        let pDesc = mainDict["ProjectDescription"] as! String
                        let pStatus = mainDict["ProjectStatus"] as! String
                        let pWrkHrs = mainDict["WorkingHours"] as! String
                       // print(pTitle)
                        self.projectArray.append(TimesheetData(projectTitle: pTitle, currentDate: pDate, projectDescription: pDesc, projectStatus: pStatus, workingHours: pWrkHrs))
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }
                }
            }
        }
    }
    
//    @IBAction func deleteButtonTapped(_ sender: Any) {
//        deleteProjectDetails()
//    }
    
    func deleteProjectDetails() {
        let ref1 = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref1.child("Users").child(uid!).child("TimesheetData").childByAutoId().setValue(nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let nav = UINavigationController(rootViewController: RegistrationLoginViewController())
           nav.title = FirebaseAuth.Auth.auth().currentUser?.displayName
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated : false)
        }
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Are You Sure You Want To LogOut", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            do {
                try FirebaseAuth.Auth.auth().signOut()
                    self.navigationController?.popToRootViewController(animated: true)
            }catch {
                print("Error failed while signing out")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
}
extension DataViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataItems = projectArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimeSheetTableViewCell
        cell.updateTimesheet(timesheetData: dataItems)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height))
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: 50, height: 50))
        label.text = "TEST TEXT"
        label.textColor = UIColor.black
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 30
        self.view.addSubview(view)

        return view
    }
    
}



