//
//  AllBookViewController.swift
//  TheLib
//
//  Created by Ideas2it on 21/04/23.
//

import UIKit

class AllBookViewController: UIViewController {
    
    @IBOutlet weak var allBooksTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allBooks = [Book]()
    let bookViewModel = BookViewModel()
    let userBookViewModel = UserBookViewModel()
    var filteredBooks = [Book]()
    var email = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userEmail = UserDefaults.standard.string(forKey: "userEmail") {
            print("****************************\(userEmail)*************************************")
            email = userEmail
        }
        
        allBooksTable.register(UINib(nibName: "AllBookTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "AllBookTableViewCell")
        
        navigationItem.title = setText(text: "allbooks")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didMenuPressed))
        self.updateUI()
    }
    
    @objc func didMenuPressed() {
        slideMenuController()?.openLeft()
    }
    
    func updateUI() {
        allBooks = bookViewModel.fetchAllBooks()
        
        if 0 == allBooks.count {
            allBooksTable.isHidden = true
        } else {
            allBooksTable.isHidden = false
        }
        self.allBooksTable.reloadData()
    }
    
    private func setText(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
}

extension AllBookViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 0 != filteredBooks.count {
            return filteredBooks.count
        } else {
            return allBooks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllBookTableViewCell", for: indexPath) as! AllBookTableViewCell
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
        allBooksTable.reloadData()
    }
    
    @objc func addBookToMyBook(_ sender: UIButton) {
        let bookToAdd = allBooks[sender.tag]
//        bookToAdd.user_email = self.email
        var userBook = UserBook(context: userBookViewModel.context)
        userBook.book_id = bookToAdd.book_id
        userBook.user_email = self.email
        userBookViewModel.saveUserBook()
    }
}
