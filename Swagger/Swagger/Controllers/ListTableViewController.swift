//
//  ListTableViewController.swift
//  Swagger
//
//  Created by MAC13 on 13.04.2023.
//

import UIKit

class ListTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var imagepicker: UIImagePickerController!
    private var id: Int!
    private var resultData: MyResponse!
    private var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.loadContent {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            networkManager.postImage(image: pickedImage, id: id)
        }
        dismiss(animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func pullToRefresh(_ sender: Any) {
        networkManager.loadContent {
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkManager.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemViewCell
        let item = networkManager.items[indexPath.row]
        cell.configure(url: item.image, imageView: cell.imageItem)
        cell.nameItem.text = item.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        imagepicker.allowsEditing = true
        id = networkManager.items[indexPath.row].id
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagepicker.sourceType = .camera
            self.tableView.reloadData()
        } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagepicker.sourceType = .photoLibrary
            self.tableView.reloadData()
        } else {
            return
        }
        self.tableView.reloadData()
        present(imagepicker, animated: true)
    }
}
