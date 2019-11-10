import UIKit


protocol itemDetailViewControllerDelegate : class {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    
    func itemDetailViewController(_ controller: ItemDetailViewController,
                                  didFinishAdding item: ChecklistItem)
    
    func itemDetailViewController(_ controller: ItemDetailViewController,
                                  didFinishEditing item: ChecklistItem)
}


class ItemDetailViewController: UITableViewController,UITextFieldDelegate {
    
    weak var delegate : itemDetailViewControllerDelegate?
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var itemToEdit: ChecklistItem?
    
    @IBOutlet weak var shouldRemindSwitch : UISwitch!
    
    @IBOutlet weak var dueDateLabel : UILabel!
    
    var datePickerVisible = false
    
    var dueDate = Date()
    
    @IBOutlet weak var datePickerCell : UITableViewCell!
    
    @IBOutlet weak var datePicker : UIDatePicker!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            
            title = "Edit Item"
            
            textField.text = item.text
            
            doneBarButton.isEnabled = true
            
            shouldRemindSwitch.isOn = item.shouldRemind
            
            dueDate = item.dueDate
        }
        
        updateDueDate()
    }


    
    @IBAction func cancel() {
        
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    
    
    @IBAction func done() {
        
        if let item = itemToEdit {
            
            item.text = textField.text!
            
            item.shouldRemind = shouldRemindSwitch.isOn
            
            item.dueDate = dueDate
            
            item.scheduleLocalNotification()
            
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        }
        else {
            
            let item = ChecklistItem()
            
            item.text = textField.text!
            
            item.shouldRemind = shouldRemindSwitch.isOn
            
            item.dueDate = dueDate
            
            item.scheduleLocalNotification()
        
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
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
    
    
    
    func updateDueDate() {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        
        formatter.timeStyle = .short
        
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    
    
    func showDatePicker() {
        
        datePickerVisible = true
        
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        
        datePicker.setDate(dueDate, animated: false)
        
        dueDateLabel.textColor = dueDateLabel.tintColor
    }
    
    
    
    func hideDatePicker() {
        
        if datePickerVisible {
            
            datePickerVisible = false
        
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
        
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
        
            dueDateLabel.textColor = UIColor.black
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        }
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        if section == 1  && datePickerVisible {
            return 3
        }
        else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 && indexPath.row == 2 {
            return 400
        }
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        textField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            
            if !datePickerVisible {
                showDatePicker()
            }
            else {
                hideDatePicker()
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        }
        else {
            return nil
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                            indentationLevelForRowAt indexPath: IndexPath) -> Int {
        
        var newIndexPath = indexPath
        
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: 1)
        }
        
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    
    
    @IBAction func dataChanged(_ datePicker:UIDatePicker) {
        
        dueDate = datePicker.date
        
        updateDueDate()
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        hideDatePicker()
    }
    
    
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        
        textField.resignFirstResponder()
        
        if switchControl.isOn {
            
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: [.alert,.sound]) {
                granted,error in
            }
        }
    }
    
}
