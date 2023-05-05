//
//  DashboardViewController.swift
//  TheLib
//
//  Created by Ideas2it on 01/04/23.
//

import UIKit
import PDFKit

class DashboardViewController: UIViewController {

    var myBook : MyBookViewController!
    var userBookViewModel = UserBookViewModel()
    var userViewModel = UserViewModel()
    var bookViewModel = BookViewModel()
    var userBooks : [UserBook] = []
    var allBooks : [Book] = []
    var filteredBooks: [Book] = []
    var selectedIndex : IndexPath?
    let emptyLabel = UILabel()
    var email = String()

    @IBOutlet weak var booksTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.layer.cornerRadius = 35
        button.backgroundColor = .systemBlue
        let image = UIImage(systemName: "plus",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 32,
                                                                           weight: .medium))
        button.setImage(image , for: .normal)
        button.tintColor = .white
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userEmail = UserDefaults.standard.string(forKey: "userEmail") {
            print("****************************\(userEmail)*************************************")
            email = userEmail
        }
        
        self.view.addSubview(floatingButton)
        emptyLabel.textAlignment = .center
        emptyLabel.text = setText(text: "oops")
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        floatingButton.addTarget(self,
                                 action:#selector(goToAddBook),
                                 for: .touchUpInside)
        
        navigationItem.title = setText(text: "dashboard")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didMenuPressed))
        registerBookTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }
    
    @objc func didMenuPressed() {
        slideMenuController()?.openLeft()
    }
    
    private func registerBookTable() {
        booksTable.dataSource = self
        booksTable.delegate = self
        booksTable.estimatedRowHeight = 310
        booksTable.register(UINib(nibName: "BookTableViewCell", bundle: nil),
                            forCellReuseIdentifier: "BookTableViewCell")
    }
    
    func updateUI(){
        let user = userViewModel.fetchUserByEmail(email: self.email)
        
        userBooks = userBookViewModel.fetchMyBook(email: self.email)
        
        if let books = userBooks.map ({$0.toBook}) {
            allBooks = books
        }
        
//        allBooks =
//        user?.books?.allObjects as! [Book]
        
//        allBooks = user?.bookOf
//        let userBook = user?.bookOf
//        allBooks =
//        allBooks = bookViewModel.fetchBook(bookId: userBook?.book_id)
        
//        userBooks = userBookViewModel.fetchMyBook(email: self.email)
        
//        allBooks = userBooks.map { $0.book }
        
//        let bookIds = allBooks.map { $0.book_id }
//        userBooks.map { $0.book_id }
//        let books = bookViewModel.fetchAllBooks()
//        allBooks = books.filter{bookIds.contains($0.book_id)}
        
        if 0 == allBooks.count {
            booksTable.isHidden = true
        } else {
            booksTable.isHidden = false
            emptyLabel.isHidden = true
        }
        self.booksTable.reloadData()
    }
    
    @objc func goToAddBook() {
        let addBook = self.storyboard?.instantiateViewController(withIdentifier: "AddBookViewScreen") as! AddBookViewController
        self.navigationController?.pushViewController(addBook, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        floatingButton.frame = CGRect(x: view.frame.size.width - 100,
                                      y: view.frame.size.height - 100,
                                      width: 70, height: 70)
    }
    
    private func setText(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 0 != filteredBooks.count {
            return self.filteredBooks.count
        } else {
            return self.allBooks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as! BookTableViewCell
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
        cell.bookTitle.font = Constants.bookTitleFont
        var selectedBookStatus = String()
        
        if let selectedBookIndex = userBooks.firstIndex(where: {$0.book_id == book.book_id}) {
            if let sts = userBooks[selectedBookIndex].status {
                selectedBookStatus = sts
            }
        }
        cell.statusLabel.text = selectedBookStatus
        cell.statusLabel.font = Constants.statusLableFont
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pdfViewVC = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewScreen") as! PDFViewController
        self.navigationController?.pushViewController(pdfViewVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let book = self.allBooks[indexPath.row]
        
        if editingStyle == .delete {
            book.is_deleted = true
        }
        bookViewModel.saveBook()
        self.updateUI()
        booksTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
                completionHandler(true)
            }
            let swipeAction = UISwipeActionsConfiguration(actions: [delete])
            swipeAction.performsFirstActionWithFullSwipe = false
            return swipeAction
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
        var bookStatus = BookStatus.readNone.rawValue
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedBook = self.allBooks[sender.tag]
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
        cell.statusLabel.text = bookStatus
        if let selectedBookIndex = userBooks.firstIndex(where: {$0.book_id == selectedBook.book_id}) {
            userBooks[selectedBookIndex].status = bookStatus
        }
        userBookViewModel.saveUserBook()
        booksTable.reloadData()
        self.selectedIndex = nil
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
}

