//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Ilya Belyaev on 06/10/2019.
//  Copyright © 2019 UApps. All rights reserved.
//

import UIKit


protocol ListDetailViewControllerDelegate: class {
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    
    func listDetailViewController(_ controller: ListDetailViewController,didFinishEditing: Checklist)
    
    func listDetailViewController(_ controller: ListDetailViewController,didFinishAdding: Checklist)
}


class  ListDetailViewController: UITableViewController, UITextFieldDelegate,
                                 IconPickerViewControllerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    
    var iconName = "Folder"
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let checklist = checklistToEdit {
            
            textField.text = checklist.name
            
            title = "Edit Checklist"
            
            doneBarButton.isEnabled = true
            
            iconName = checklist.iconName
        }
        
        iconImage.image = UIImage(named: iconName)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    
    
    @IBAction func cancel() {
        
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    
    
    @IBAction func done() {
        
        if let checklist = checklistToEdit {
            
            checklist.name = textField.text!
            
            checklist.iconName = iconName
            
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        }
        else {
            
            let checklist = Checklist(textField.text!,iconName)
            
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return indexPath.section == 1 ? indexPath : nil
    }
    
    
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range:NSRange,
                   replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        
        let stringRange = Range(range,in: oldText)!
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        doneBarButton.isEnabled = false
        
        return true
    }
    
    
    
    @IBOutlet weak var iconImage: UIImageView!
    
    
    
    func iconPicker(_ picker: IconPickerViewController,
                    didPick iconName: String) {
        
        self.iconName = iconName
        
        iconImage.image = UIImage(named: iconName)
        
        navigationController?.popViewController(animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        
        let controller = segue.destination as! IconPickerViewController
        
        controller.delegate = self
    }
    
}
