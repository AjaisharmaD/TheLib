//
//  CategoryBookViewController.swift
//  TheLib
//
//  Created by Ideas2it on 25/04/23.
//

import UIKit

class CategoryBookViewController: UIViewController {
    
    @IBOutlet weak var booksTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var category : Category!
    var allBooks = [Book]()
    var filteredBooks = [Book]()
    let bookViewModel = BookViewModel()
    let userBookViewModel = UserBookViewModel()
    var email = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userEmail = UserDefaults.standard.string(forKey: "userEmail") {
            print("****************************\(userEmail)*************************************")
            email = userEmail
        }
        
        navigationItem.title = setText(text: category.rawValue)
        
        booksTable.register(UINib(nibName: "AllBookTableViewCell", bundle: nil),
                            forCellReuseIdentifier: "AllBookTableViewCell")
        self.updateUI()
        self.fetchBooks()
    }
    
    func updateUI() {
        allBooks = bookViewModel.fetchAllBooks()
        
        if 0 == allBooks.count {
            booksTable.isHidden = true
        } else {
            booksTable.isHidden = false
        }
        self.booksTable.reloadData()
    }
    
    private func setText(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
    func fetchBooks(){
        allBooks = bookViewModel.fetchByCategory(category: category)
        booksTable.reloadData()
    }
}

extension CategoryBookViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 0 != filteredBooks.count {
            return filteredBooks.count
        } else {
            return allBooks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllBookTableViewCell",
                                                 for: indexPath) as! AllBookTableViewCell
        var book = Book()
        if 0 != filteredBooks.count {
            book = filteredBooks[indexPath.row]
        } else {
            book = allBooks[indexPath.row]
        }
        
        if let imageData = book.book_image, let image = UIImage(data: imageData) {
            cell.bookImage.image = image
        }
        cell.bookTitle.text = book.title
        cell.authorLable.text = book.author
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self,
                                 action: #selector(addBookToMyBook),
                                 for: .touchUpInside)
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBooks = searchText.isEmpty ? allBooks : allBooks.filter({ (book: Book) -> Bool in
            var bookName = String()
            
            if let myBookName = book.title {
                bookName = myBookName
            }
            return bookName.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        booksTable.reloadData()
    }
    
    @objc func addBookToMyBook(_ sender: UIButton) {
        print("Pressed")
        let bookToAdd = allBooks[sender.tag]
        let userBook = UserBook(context: userBookViewModel.context)
        userBook.user_email = self.email
        userBook.book_id = bookToAdd.book_id
        userBookViewModel.saveUserBook()
    }
}
