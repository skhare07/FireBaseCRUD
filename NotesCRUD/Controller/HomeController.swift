//
//  AddNote.swift
//  NotesCRUD
//
//  Created by Apple on 16/11/1944 Saka.
//

import UIKit
import FirebaseFirestore

class HomeController : UIViewController{
   
    var tableView : UITableView!
   
    let db = Firestore.firestore()
    var notesArray = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationControllerBar()
        configureTableView()
        fetchNotes()
        
    }
    
  func configureTableView(){
    
    tableView = UITableView()
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    view.addSubview(tableView)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
 
    tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

   
}
    @objc func goToAddNoteController(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
       
        let addNoteVC = storyboard.instantiateViewController(identifier: "AddNoteController") as! AddNoteController
        navigationController?.pushViewController(addNoteVC, animated: true)
        
    }


    func navigationControllerBar(){
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Home"
     
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add" , style: .plain, target: self, action: #selector(goToAddNoteController))
        
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        
    }

    func fetchNotes(){
        
        db.collection("notes").addSnapshotListener { [weak self] querySnapshot, error in
            
            if error != nil {
                return
            }
            
            
            guard let snapShot = querySnapshot else {return}
            
            self?.notesArray.removeAll()

            snapShot.documents.forEach { document in
                
                let dataDictionary = document.data()
                
                let title = dataDictionary["title"] as? String ?? ""
                let description = dataDictionary["description"] as? String ?? ""
                let id = document.documentID
                let newNotes = Notes(title: title, description: description, id: id)
                self?.notesArray.append(newNotes)
                
                print("Title ", title)
                print("Description ", description)
                
                print("ID: ", id)
            }
            self?.tableView.reloadData()
        }

        }
    }
    
    
extension HomeController : UITableViewDelegate , UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = notesArray[indexPath.row].title
        
        return cell
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let updateVC = storyboard.instantiateViewController(identifier: "UpdateNoteController") as! UpdateNoteController
       
        updateVC.selectedNote = notesArray[indexPath.row]
        
        self.navigationController?.pushViewController(updateVC, animated: true)
        
        print("selected index : \(indexPath.row)")

    }
}
