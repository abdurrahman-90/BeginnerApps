//
//  ViewController.swift
//  BeginnerSwiftApp
//
//  Created by Akdag on 24.02.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        navigationItem.leftBarButtonItem = editButtonItem
        load()
    }
    func save(){
        let jsonEncoder = JSONEncoder()
        if let saveData = try? jsonEncoder.encode(photos){
            UserDefaults.standard.set(saveData , forKey: "save")
        }else{
            print("Unable to save photos")
        }
    }
    
    func load(){
        let defaults = UserDefaults.standard
        if let savePhotos = defaults.object(forKey: "save") as? Data{
            let jsonDecoder = JSONDecoder()
            do{
                photos = try jsonDecoder.decode([Photo].self, from: savePhotos)
            }catch{
                print("Failed to load photos")
            }
        }
    }
    
    func getDocumentdirectory()-> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = photos[indexPath.row].caption
        
        return  cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.selectedPhoto = photos[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(editing, animated: true)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            photos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        tableView.reloadData()
        save()
    }
    
    
}
extension ViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    @objc func addPhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentdirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        dismiss(animated: true, completion: nil)
        
        let ac = UIAlertController(title: "Caption", message: "Choose a caption for the photo", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self , weak ac] action in
            guard let caption = ac?.textFields?[0].text else{return}
            let photo = Photo(fileName: imageName, caption: caption)
            self?.photos.append(photo)
            self?.save()
            self?.tableView.reloadData()
        }))
        present(ac, animated: true)
        
        
    }
}

