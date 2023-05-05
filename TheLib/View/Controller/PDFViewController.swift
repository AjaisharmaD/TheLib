//
//  PDFViewController.swift
//  TheLib
//
//  Created by Ideas2it on 04/05/23.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = setText(text: "pdf")
        
        let pdfViewer = PDFView(frame: view.bounds)
        pdfViewer.autoScales = true
        view.addSubview(pdfViewer)
        
        guard let filePath = Bundle.main.path(forResource: "Attitude is Everything", ofType: "pdf") else { return }
        
        let pdfDoc = PDFDocument(url: URL(filePath: filePath))
        pdfViewer.document = pdfDoc
    }
    
    private func setText(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
}
