//
//  DashboardViewController.swift
//  TheLib
//
//  Created by Ideas2it on 01/04/23.
//
import UIKit
import PDFKit

class DashboardViewController: UIViewController {
    var userBookViewModel = UserBookViewModel()
    var userViewModel = UserViewModel()
    var bookViewModel = BookViewModel()
    var userBooks : [UserBook] = []
    var allBooks : [Book] = []
    var myBooks : [Book] = []
    var filteredAllBooks: [Book] = []
    var filteredMyBooks: [Book] = []
    var selectedIndex : IndexPath?
    let addBookImage = UIImageView()
    var email = String()
    
    var defaultBooks : [Book] = []

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var allBookSearchBar: UISearchBar!
    @IBOutlet weak var allBooksTable: UITableView!
    @IBOutlet weak var myBookSearchBar: UISearchBar!
    @IBOutlet weak var myBooksTable: UITableView!
    
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
        
        registerBookTable()
        getDefaultBooks()
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        myBooksTable.isHidden = true
        myBookSearchBar.isHidden = true
        
        if let userEmail = UserDefaults.standard.string(forKey: "userEmail") {
            print("****************************\(userEmail)*************************************")
            email = userEmail
        }
        
        addBookImage.image = UIImage(systemName: "plus")
        addBookImage.center = view.center
        addBookImage.isHidden = true
        view.addSubview(addBookImage)
        self.view.addSubview(floatingButton)
        
        floatingButton.addTarget(self,
                                 action:#selector(goToAddBook),
                                 for: .touchUpInside)
        floatingButton.isHidden = true
        
        navigationItem.title = setText(text: "dashboard")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didMenuPressed))
        updateUI()
    }
    
    @objc func segmentChanged() {
        let segmentIndex = segmentedControl.selectedSegmentIndex
        
        switch segmentIndex {
        case 0:
            allBooksTable.isHidden = false
            allBookSearchBar.isHidden = false
            allBookSearchBar.placeholder = "Search from All Book"
            floatingButton.isHidden = true
            myBookSearchBar.isHidden = true
            myBooksTable.isHidden = true
            self.updateUI()
            break
        case 1:
            allBooksTable.isHidden = true
            allBookSearchBar.isHidden = true
            myBooksTable.isHidden = false
            myBookSearchBar.isHidden = false
            myBookSearchBar.placeholder = "Search from your Book"
            floatingButton.isHidden = false
            self.updateUI()
            break
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }
    
    @objc func didMenuPressed() {
        slideMenuController()?.openLeft()
    }
    
    private func registerBookTable() {
        allBooksTable.estimatedRowHeight = 310
        allBooksTable.register(UINib(nibName: "AllBookTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "AllBookTableViewCell")
        
        myBooksTable.estimatedRowHeight = 310
        myBooksTable.register(UINib(nibName: "BookTableViewCell", bundle: nil),
                            forCellReuseIdentifier: "BookTableViewCell")
    }
    
    func updateUI(){
        userBooks = userBookViewModel.fetchMyBook(email: self.email)
        
        if 0 == allBooks.count {
            allBooks = defaultBooks
        } else {
            allBooks = bookViewModel.fetchAllBooks()
        }
        self.myBooksTable.reloadData()
        self.allBooksTable.reloadData()
    }
    
    func getDefaultBooks() {
        guard let path = Bundle.main.path(forResource: "defaultBooks", ofType: "json"),
              let jsonData = try? Data(contentsOf: URL(filePath: path)) else {
            print("Error while geting the json data")
            return
        }
        
        var loadBooks = [Book]()
        
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            {
                if let jsonArray = json["books"] as? [[String: Any]]
                {
                    for array in jsonArray {
                        guard let bookTitle = array["title"] as? String,
                              let authorName = array["author"] as? String,
                              let category = array["category"] as? String,
                              let image = array["image"] as? String else {
                            return
                        }
                        
                        let book = Book(context: bookViewModel.context)
                        book.title = bookTitle
                        book.author = authorName
                        book.catagory = category
                        book.book_image = UIImage(named: image)?.jpegData(compressionQuality: 1.0)
                        
                        loadBooks.append(book)
                    }
                    defaultBooks = loadBooks
                }
            }
        } catch {
            print("Error while parsing the json data to book data")
        }
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
        var rowCount = 0
        
        if tableView == allBooksTable {
            rowCount = filteredAllBooks.isEmpty ? allBooks.count : filteredAllBooks.count
        } else {
            rowCount = filteredMyBooks.isEmpty ? userBooks.count : filteredMyBooks.count
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var book = Book()
        
        if tableView == allBooksTable {
            let allBookCell = tableView.dequeueReusableCell(withIdentifier: "AllBookTableViewCell", for: indexPath) as! AllBookTableViewCell
            
            if 0 != filteredAllBooks.count {
                book = filteredAllBooks[indexPath.row]
            } else {
                book = allBooks[indexPath.row]
                allBookCell.bookTitle.text = book.title
                
                if let imageData = book.book_image, let image = UIImage(data: imageData) {
                    allBookCell.bookImage.image = image
                }
                allBookCell.authorLable.text = book.author
                
                if book.created_by == self.email {
                    allBookCell.addButton.isEnabled = false
                } else {
                    allBookCell.addButton.isEnabled = true
                    allBookCell.addButton.tag = indexPath.row
                    allBookCell.addButton.addTarget(self, action: #selector(addToMyBooks(_:)), for: .touchUpInside)
                }
            }
            return allBookCell
        } else {
            let myBookCell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as! BookTableViewCell
            
            if 0 != filteredMyBooks.count {
                book = filteredMyBooks[indexPath.row]
            } else {
                if let book = userBooks[indexPath.row].books {
                    if let imageData = book.book_image, let image = UIImage(data: imageData) {
                        myBookCell.bookImage.image = image
                    }
                    myBookCell.bookTitle.text = book.title
                    myBookCell.bookTitle.font = Constants.bookTitleFont
                    var selectedBookStatus = String()
                    
                    if let selectedBookIndex = userBooks.firstIndex(where: {$0.book_id == book.book_id}) {
                        if let sts = userBooks[selectedBookIndex].status {
                            selectedBookStatus = sts
                        }
                    }
                    myBookCell.statusLabel.text = selectedBookStatus
                    myBookCell.statusLabel.font = Constants.statusLableFont
                    myBookCell.tag = indexPath.row
                    myBookCell.downBtn.tag = indexPath.row
                    myBookCell.downBtn.addTarget(self,
                                           action: #selector(didDropDownPressed(sender:)),
                                           for: .touchUpInside)
                    
                    if let currentIndex = self.selectedIndex, currentIndex == indexPath {
                        myBookCell.menuView.isHidden = false
                        
                        
                        myBookCell.opt1.setTitle(BookStatus.reading.rawValue, for: .normal)
                        myBookCell.opt1.tag = myBookCell.tag
                        myBookCell.opt1.addTarget(self,
                                            action: #selector(changeStatus(sender:)),
                                            for: .touchUpInside)
                        myBookCell.opt2.setTitle(BookStatus.wantToRead.rawValue, for: .normal)
                        myBookCell.opt2.tag = myBookCell.tag
                        myBookCell.opt2.addTarget(self,
                                            action: #selector(changeStatus(sender:)),
                                            for: .touchUpInside)
                        myBookCell.opt3.setTitle(BookStatus.readAlready.rawValue, for: .normal)
                        myBookCell.opt3.tag = myBookCell.tag
                        myBookCell.opt3.addTarget(self,
                                            action: #selector(changeStatus(sender:)),
                                            for: .touchUpInside)
                        
                        myBookCell.opt1.setTitleColor(UIColor.black, for: .normal)
                        myBookCell.opt2.setTitleColor(UIColor.black, for: .normal)
                        myBookCell.opt3.setTitleColor(UIColor.black, for: .normal)

                        switch selectedBookStatus {
                        case BookStatus.reading.rawValue:
                            myBookCell.opt1.setTitleColor(Constants.selctedItemColor, for: .normal)
                            break
                        case BookStatus.wantToRead.rawValue:
                            myBookCell.opt2.setTitleColor(Constants.selctedItemColor, for: .normal)
                            break
                        case BookStatus.readAlready.rawValue:
                            myBookCell.opt3.setTitleColor(Constants.selctedItemColor, for: .normal)
                            break
                        default:
                            break
                        }
                    } else {
                        myBookCell.menuView.isHidden = true
                    }
                }
            }
            return myBookCell
        }
    }
    
    @objc func addToMyBooks(_ sender: UIButton) {
        let bookToAdd = allBooks[sender.tag]
        let userBook = UserBook(context: userBookViewModel.ubContext)
        userBook.book_id = bookToAdd.book_id
        userBook.user_email = self.email
        userBook.status = BookStatus.wantToRead.rawValue
        userBook.books = bookToAdd
        userBookViewModel.saveUserBook()
        myBooksTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pdfViewVC = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewScreen") as! PDFViewController
        self.navigationController?.pushViewController(pdfViewVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == myBooksTable {
            if editingStyle == .delete {
                userBookViewModel.deleteMyBook(book: userBooks[indexPath.row])
                self.userBooks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            self.updateUI()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == myBooksTable {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
                completionHandler(true)
            }
            let swipeAction = UISwipeActionsConfiguration(actions: [delete])
            swipeAction.performsFirstActionWithFullSwipe = false
            return swipeAction
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    @objc func didDropDownPressed(sender: UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
                
        if let ip = self.selectedIndex, ip == indexpath {
            self.selectedIndex = nil
        } else {
            self.selectedIndex = indexpath
        }
        myBooksTable.reloadData()
    }
    
    @objc func changeStatus(sender: UIButton) {
        var bookStatus = BookStatus.wantToRead.rawValue
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedBook = self.allBooks[sender.tag]
        let cell = myBooksTable.cellForRow(at: indexPath) as! BookTableViewCell
        
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
        myBooksTable.reloadData()
        self.selectedIndex = nil
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == allBookSearchBar {
            filteredAllBooks = searchText.isEmpty ? allBooks : allBooks.filter({ (book: Book) -> Bool in
                var bookName = String()
                if let myBookName = book.title {
                    bookName = myBookName
                }
                return bookName.range(of: searchText, options: .caseInsensitive) != nil
            })
            allBooksTable.reloadData()
        } else {
            myBooks = userBooks.map({$0.books!})
            filteredMyBooks = searchText.isEmpty ? myBooks : myBooks.filter({ (book: Book) -> Bool in
                var bookName = String()
                if let myBookName = book.title {
                    bookName = myBookName
                }
                return bookName.range(of: searchText, options: .caseInsensitive) != nil
            })
            myBooksTable.reloadData()
        }
    }
}

