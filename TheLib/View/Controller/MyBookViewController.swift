//
//  MyBookViewController.swift
//  TheLib
//
//  Created by Ideas2it on 04/04/23.
//
import UIKit

class MyBookViewController: UIViewController {

    var status = BookStatus.allCases
    var books = [Book]()
    var bookViewModel = BookViewModel()
    var userBookViewModel = UserBookViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    var array = [[String : String]]()
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userEmail = UserDefaults.standard.string(forKey: "userEmail") {
            print("****************************\(userEmail)*************************************")
            email = userEmail
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyBookTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "MyBookTableViewCell")
        
        navigationItem.title = setText(text: "mybook")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didMenuPressed))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchBookCount()
    }
    
    @objc func didMenuPressed() {
        slideMenuController()?.openLeft()
    }
    
    private func setText(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
    func fetchBookCount(){
        let userBooks = userBookViewModel.fetchMyBook(email: self.email)
        
        var book = Book()
        for userBook in userBooks {
            if let bookId = userBook.book_id {
                if let Rbook = bookViewModel.fetchBook(bookId: bookId) {
                    book = Rbook
                }
            }
            self.books.append(book)
        }
        
        let currentlyReading = userBooks.filter { $0.status == BookStatus.reading.rawValue}
        let readAlready = userBooks.filter { $0.status == BookStatus.readAlready.rawValue}
        let wantToRead  = userBooks.filter { $0.status == BookStatus.wantToRead.rawValue}
        
        array = [["title":BookStatus.reading.rawValue, "count":"\(currentlyReading.count)"],
                 ["title":BookStatus.readAlready.rawValue, "count":"\(readAlready.count)"],
                 ["title":BookStatus.wantToRead.rawValue, "count":"\(wantToRead.count)"]]
        self.tableView.reloadData()
    }
}

extension MyBookViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookTableViewCell", for: indexPath) as! MyBookTableViewCell
        let object = array[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.titleLable.text = object["title"]
        cell.countLable.text = object["count"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOption = array[indexPath.row]
        let title = selectedOption["title"] ?? BookStatus.wantToRead.rawValue
        let bookStatus = BookStatus(rawValue: title)
 
        let bookDetail = storyboard?.instantiateViewController(withIdentifier: "bookDetailScreen") as! BookDetailViewController
        
        switch bookStatus {
        case .reading:
            bookDetail.bookStatus = .reading
            self.navigationController?.pushViewController(bookDetail, animated: true)
            break
        case .wantToRead:
            bookDetail.bookStatus = .wantToRead
            self.navigationController?.pushViewController(bookDetail, animated: true)
            break
        case .readAlready:
            bookDetail.bookStatus = .readAlready
            self.navigationController?.pushViewController(bookDetail, animated: true)
            break
        default:
            bookDetail.bookStatus = .wantToRead
            self.navigationController?.pushViewController(bookDetail, animated: true)
            break
        }
        
    }
}
