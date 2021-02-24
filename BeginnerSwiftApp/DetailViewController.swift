//
//  DetailViewController.swift
//  BeginnerSwiftApp
//
//  Created by Akdag on 24.02.2021.
//

import UIKit

class DetailViewController: UIViewController {

    var imageView = UIImageView()
    var selectedPhoto : Photo?
   
    func getDocumentDirectory()-> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    override  func loadView() {
        view = UIView()
        view.backgroundColor = .systemTeal
        navigationItem.largeTitleDisplayMode = .never
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let photo = selectedPhoto {
            let path = getDocumentDirectory().appendingPathComponent(photo.fileName)
            imageView.image = UIImage(contentsOfFile: path.path)
        }
    }
    
    

 

}
