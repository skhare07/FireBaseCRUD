//
//  UpdateNoteController.swift
//  NotesCRUD
//
//  Created by Apple on 16/11/1944 Saka.
//

import UIKit
import FirebaseFirestore

class UpdateNoteController : UIViewController{
    
    let db = Firestore.firestore()
    
    var selectedNote : Notes?
    
    
    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTF.text = selectedNote?.title
        descriptionTextField.text = selectedNote?.description
        configureNavigationController()
    
    }
    
    
    @IBAction func updateButtom(_ sender: UIButton) {
    
        
        if let title = titleTF.text , let description = descriptionTextField.text , let id = selectedNote?.id{
        
            let newData :[String : Any] = ["title":title , "description": description]
            
            
            db.collection("notes").document(id).setData(newData) { error in
                if error != nil {
                    print("Error: \(error?.localizedDescription)")
                    
                }else{
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc func deleteNote(){
        if let id = selectedNote?.id {
            db.collection("notes").document(id).delete { error in
                if error != nil{
                    return
                }
            }
            navigationController?.popViewController(animated: true)

        }
    }
    
    func configureNavigationController(){
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Update"
     
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title : "Delete" , style: .plain, target: self, action: #selector(deleteNote))
        
        navigationItem.rightBarButtonItem?.tintColor = .white
        
    }
}
