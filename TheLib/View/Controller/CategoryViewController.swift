//
//  CategoryViewController.swift
//  TheLib
//
//  Created by Ideas2it on 25/04/23.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryTable: UITableView!
    var categories = Category.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTable.register(UITableViewCell.self,
                               forCellReuseIdentifier: "cell")
        
        // Hamburger Image for
        navigationItem.title = setText(text: "category")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didMenuPressed))
    }
    
    @objc func didMenuPressed() {
        slideMenuController()?.openLeft()
    }
    
    private func setText(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = categories[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedRow = categories[indexPath.row]
        
        let categoryBook = storyboard?.instantiateViewController(withIdentifier: "CategoryBookScreen") as! CategoryBookViewController
        
        switch selectedRow {
        case .history:
            categoryBook.category = .history
            self.navigationController?.pushViewController(categoryBook, animated: true)
            break
        case .biography:
            categoryBook.category = .biography
            self.navigationController?.pushViewController(categoryBook, animated: true)
            break
        case .comedy:
            categoryBook.category = .comedy
            self.navigationController?.pushViewController(categoryBook, animated: true)
            break
        case .horror:
            categoryBook.category = .horror
            self.navigationController?.pushViewController(categoryBook, animated: true)
            break
        case .love:
            categoryBook.category = .love
            self.navigationController?.pushViewController(categoryBook, animated: true)
            break
        case .poetry:
            categoryBook.category = .poetry
            self.navigationController?.pushViewController(categoryBook, animated: true)
            break
        case .sifi:
            categoryBook.category = .sifi
            self.navigationController?.pushViewController(categoryBook, animated: true)
            break
        }
    }
}
