//
//  AddBookViewController.swift
//  TheLib
//
//  Created by Ideas2it on 04/04/23.
//
import UIKit

class AddBookViewController: UIViewController {
    
    // Outer layer of the Add book card
    @IBOutlet weak var containerStack: UIStackView!
    @IBOutlet weak var bookImage : UIImageView!
    @IBOutlet weak var addImage : UIButton!
    @IBOutlet weak var bookTitleTF: UITextField!
    @IBOutlet weak var bookDescriptionTF: UITextField!
    // category view which contains the Lable and a drop down button to select the category for the book
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLable: UILabel!
    @IBOutlet weak var dropDownBtn: UIButton!
//    // which contains the list of category to set to book
//    @IBOutlet weak var menuView: UIView!
//    @IBOutlet weak var menuTable: UITableView!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var categories = Category.allCases
//    [Category]()
    var toggle: Bool = false
    let userViewModel = UserViewModel()
    var bookViewModel = BookViewModel()
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userEmail = UserDefaults.standard.string(forKey: "userEmail") {
            print("****************************\(userEmail)*************************************")
            email = userEmail
        }
        
        //Book Image
        bookImage.layer.borderColor = UIColor.black.cgColor
        bookImage.layer.borderWidth = Constants.borderWidth
        bookImage.layer.cornerRadius = Constants.cornerRadius

        //Add Image Button
        addImage.setTitle(setText(text: "addImage"), for: .normal)
        addImage.addTarget(self,
                           action: #selector(didAddImagePressed),
                           for: .touchUpInside)
        
        //Book Title
        bookTitleTF.placeholder = setText(text: "bookTitle")
        
        //Book Description
        bookDescriptionTF.placeholder = setText(text: "description")
        
        //CategoryView
        categoryView.layer.borderWidth = 1
        categoryView.layer.borderColor = Constants.shadowColor
        
        // Category Lable
        categoryLable.text = "select the category"
        
        // Drop Down Button
        dropDownBtn.tintColor = Constants.logoTintColor
        dropDownBtn.addTarget(self, action: #selector(didDropDownPressed), for: .touchUpInside)
        
        //MenuPicker
        categoryPicker.isHidden = true
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
//        menuTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //Save Button
        saveButton.setTitle(setText(text: "save"), for: .normal)
        saveButton.layer.shadowRadius = Constants.shadowRadius
        saveButton.layer.shadowOpacity = Constants.shadowOpacity
        saveButton.layer.shadowOffset = Constants.shadowOffset
        saveButton.addTarget(self,
                             action: #selector(saveBookDetails),
                             for: .touchUpInside)
        
        // Cancel Button
        cancelBtn.setTitle(setText(text: "cancel"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(didClosePressed), for: .touchUpInside)
        
        // Hamburger Image for Side menu
        navigationItem.title = setText(text: "addBook")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didMenuPressed))
    }
    
    // Opens the side menu when clicking on the Hambuger Button
    @objc func didMenuPressed() {
        slideMenuController()?.openLeft()
    }
    
    // Poping the Add book view when clicking on the Cancel button
    @objc func didClosePressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Opens the Image Picker view
    @objc func didAddImagePressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    // Open and Hides the Drop down menu to select the category
    @objc func didDropDownPressed() {
        if !toggle {
            toggle = true
            categoryPicker.isHidden = false
        } else {
            toggle = false
            categoryPicker.isHidden = true
        }
    }
    
    // Saves the Book to core data
    @objc func saveBookDetails() {
        setBookDetails()
         self.navigationController?.popViewController(animated: true)
    }
    
    // Setting up the Book details to the Book Object to store it in the core data
    func setBookDetails() {
        var myBookImage = Data()
        
        if let image = bookImage.image, let imageData = image.pngData(), !imageData.isEmpty {
            myBookImage = imageData
        } else {
            self.showAlert(alertTitle: setText(text:"imageError"),
                           alertMessage: setText(text: "imageMessage"),
                           actionTitle: setText(text: "ok"))
            return;
        }
        
        var mybooktitle = String()
        if let bookTitle = bookTitleTF.text, bookTitle.count > 0 {
            mybooktitle = bookTitle
        } else {
            self.showAlert(alertTitle: setText(text: "bookTitle"),
                           alertMessage: setText(text: "titleMessage"),
                           actionTitle: setText(text: "ok"))
            return;
        }
        
        var myCategory = String()
        if let category = categoryLable.text, category.count > 0 {
            myCategory = category
        } else {
            self.showAlert(alertTitle: setText(text: "selectCategory"),
                           alertMessage: setText(text: "categoryMessage"),
                           actionTitle: setText(text: "ok"))
        }
        
        if !mybooktitle.isEmpty && !myBookImage.isEmpty && !myCategory.isEmpty {
            saveBook(image: myBookImage, title: mybooktitle, category: myCategory)
        } else {
             print("not saving the data")
        }
    }
    
    // Creating and saving the Book for the User
    private func saveBook(image: Data, title: String, category: String) {
//        var books = [UserBook]()
//        let user = User(context: bookViewModel.context)
        let book = Book(context: bookViewModel.context)
        let bookId = UUID().uuidString
        book.book_image = image
        book.title = title
        book.book_description = bookDescriptionTF.text
        book.author = getAuthorName(email: self.email)
        book.catagory = category
        book.book_id = bookId
        book.created_by = self.email
        let date  = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = setText(text: "dateFormat")
        book.created_date = date
        book.updated_date = date
        bookViewModel.saveBook()
        
        // Adding a Book and user details to the UserBook entity
        let userBookViewModel = UserBookViewModel()
        let userBook = UserBook(context: userBookViewModel.context)
        userBook.user_email = self.email
        userBook.book_id = bookId
        userBook.status = BookStatus.wantToRead.rawValue
        userBook.books = book
//        books.append(userBook)
        userBookViewModel.saveUserBook()
        
//        user.userBook = NSSet(array: books)
//        userViewModel.saveUser()
    }
    
}

// Selecting category
//extension AddBookViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.categories.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = categories[indexPath.row].rawValue
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        categoryLable.text = categories[indexPath.row].rawValue
//        menuView.isHidden = true
//        toggle = false
//    }
//}

// Selecting category throgh Picker View
extension AddBookViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryLable.text = categories[row].rawValue
        categoryPicker.isHidden = true
        toggle = false
    }
}

// Image Picker Delegate to show the Image picker view
extension AddBookViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController
                            .InfoKey(rawValue: "UIImagePickerControllerEditedImage")]
                                        as? UIImage {
            bookImage.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension AddBookViewController { 
    
    private func setText(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
    // Getting the Author's Name by the email in the Book Entity
    private func getAuthorName(email: String) -> String {
        var author =  User()
        let userViewModel = UserViewModel()
        if let user = userViewModel.fetchUserByEmail(email: email) {
            author = user
        }
        return author.name ?? "Not found"
    }
}
