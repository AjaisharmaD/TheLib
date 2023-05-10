//
//  BookDetailViewController.swift
//  TheLib
//
//  Created by Ideas2it on 12/04/23.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var booksTable: UITableView!
    
    var bookStatus : BookStatus = .wantToRead
    var userBooks : [UserBook] = []
    var bookList = [Book]()
    var selectedIndex : IndexPath?
    var bookViewModel = BookViewModel()
    var userBookViewModel = UserBookViewModel()
    let emptyLabel = UILabel()
    var email = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userEmail = UserDefaults.standard.string(forKey: "userEmail") {
            print("****************************\(userEmail)*************************************")
            email = userEmail
        }
        
        booksTable.delegate = self
        booksTable.dataSource = self
        booksTable.register(UINib(nibName: "BookTableViewCell", bundle: nil),
                            forCellReuseIdentifier: "BookTableViewCell")
        
        // List is Empty Warning Label
        emptyLabel.textAlignment = .center
        emptyLabel.text = setText(text: "oops")
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        self.fetchBooks()
        if 0 == userBooks.count {
            booksTable.isHidden = true
        } else {
            booksTable.isHidden = false
            emptyLabel.isHidden = true
        }
    }
    
    private func setText(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
    func fetchBooks(){
        userBooks = userBookViewModel.fetchMyBook(email: self.email)
        
//        let bookIds = userBooks.map { $0.book }
//        var book = Book()
//        for userBook in userBooks {
//            if let bookId = userBook.book_id {
//                if let Rbook = bookViewModel.fetchBook(bookId: bookId) {
//                    book = Rbook
//                    bookList.append(book)
//                }
//            }
//        }
        booksTable.reloadData()
    }

}
extension BookDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as! BookTableViewCell
        var selectedBookStatus = String()
        let book = userBooks[indexPath.row].books
        if let imageData = book?.book_image, let image = UIImage(data: imageData) {
            cell.bookImage.image = image
        }
        cell.bookTitle.font = Constants.bookTitleFont
        if let title = book?.title {
            cell.bookTitle.text = title
        }
        cell.statusLabel.font = Constants.statusLableFont
        
        if let selectedBookIndex = userBooks.firstIndex(where: {$0.book_id == book?.book_id}) {
            if let sts = userBooks[selectedBookIndex].status {
                selectedBookStatus = sts
            }
        }
        cell.statusLabel.text = selectedBookStatus
        cell.tag = indexPath.row
        cell.downBtn.tag = indexPath.row
        cell.downBtn.addTarget(self,
                               action: #selector(didDropDownPressed(sender:)),
                               for: .touchUpInside)
        
        if let currentIndex = self.selectedIndex, currentIndex == indexPath {
            cell.menuView.isHidden = false
            
            cell.opt1.setTitle(BookStatus.reading.rawValue, for: .normal)
            cell.opt1.tag = cell.tag
            cell.opt1.addTarget(self,
                                action: #selector(changeStatus(sender:)),
                                for: .touchUpInside)
            cell.opt2.setTitle(BookStatus.wantToRead.rawValue, for: .normal)
            cell.opt2.tag = cell.tag
            cell.opt2.addTarget(self,
                                action: #selector(changeStatus(sender:)),
                                for: .touchUpInside)
            cell.opt3.setTitle(BookStatus.readAlready.rawValue, for: .normal)
            cell.opt3.tag = cell.tag
            cell.opt3.addTarget(self,
                                action: #selector(changeStatus(sender:)),
                                for: .touchUpInside)
            
            cell.opt1.setTitleColor(UIColor.black, for: .normal)
            cell.opt2.setTitleColor(UIColor.black, for: .normal)
            cell.opt3.setTitleColor(UIColor.black, for: .normal)
            
            // Highlighting the Selected status
            switch selectedBookStatus {
            case BookStatus.reading.rawValue:
                cell.opt1.setTitleColor(Constants.selctedItemColor, for: .normal)
                break
            case BookStatus.wantToRead.rawValue:
                cell.opt2.setTitleColor(Constants.selctedItemColor, for: .normal)
                break
            case BookStatus.readAlready.rawValue:
                cell.opt3.setTitleColor(Constants.selctedItemColor, for: .normal)
                break
            default:
                break
            }
        } else {
            cell.menuView.isHidden = true
        }
        return cell
    }
    
    @objc func didDropDownPressed(sender: UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        
        if let ip = self.selectedIndex, ip == indexpath {
            self.selectedIndex = nil
        } else {
            self.selectedIndex = indexpath
        }
        booksTable.reloadData()
    }
    
    @objc func changeStatus(sender: UIButton) {
        var bookStatus = BookStatus.wantToRead.rawValue
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedBook = self.userBooks[sender.tag].books
        let cell = booksTable.cellForRow(at: indexPath) as! BookTableViewCell
        
        switch sender {
        case cell.opt1:
            bookStatus = BookStatus.reading.rawValue
            break
        case cell.opt2:
            bookStatus = BookStatus.wantToRead.rawValue
            break
        case cell.opt3:
            bookStatus = BookStatus.readAlready.rawValue
            break
        default:
            break
        }
        cell.statusLabel.text = "Hi"
//        bookStatus
        if let selectedBookIndex = userBooks.firstIndex(where: {$0.book_id == selectedBook?.book_id}) {
            userBooks[selectedBookIndex].status = bookStatus
        }
        self.selectedIndex = nil
        userBookViewModel.saveUserBook()
        self.fetchBooks()
    }
}
