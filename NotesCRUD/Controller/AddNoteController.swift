//
//  ViewController.swift
//  NotesCRUD
//
//  Created by Apple on 16/11/1944 Saka.
//

import UIKit
import FirebaseFirestore

class AddNoteController: UIViewController {
    
    let db = Firestore.firestore()
   
    @IBOutlet weak var titleTextField: UITextField!
    
    
    @IBOutlet weak var descriptionTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationControllerBar()
    
    }

    @objc func addNote(){
        guard let title = titleTextField.text , let description = descriptionTextField.text else{ return }
     
        let data: [String: Any] = ["title":title ,"description":description]
        
        db.collection("notes").addDocument(data: data) { error in
            if error != nil{
                return
            }
            
            self.navigationController?.popViewController(animated: true)
            
      
        }
    }
    
    func navigationControllerBar(){
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Notes"
     
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title : "Save" , style: .plain, target: self, action: #selector(addNote))
        
        
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        }
    

}
