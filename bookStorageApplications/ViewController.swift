//
//  ViewController.swift
//  bookStorageApplications
//
//  Created by Amarvir Mac on 27/01/21.
//  Copyright © 2021 Amarvir Mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textFields: [UITextField]!
    var books: [BookData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        print(filePath)
        
        loadData()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        
        view.addGestureRecognizer(gesture)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc func tapGesture(gesture:UITapGestureRecognizer){
        
        
    }
    
    
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        if textFields[0].text == "" || textFields[1].text == "" || textFields[2].text == "" || textFields[3].text == "" {
            
        }else{
        
            let title = textFields[0].text ?? ""
            let author = textFields[1].text ?? ""
            let pages = Int(textFields[2].text!) ?? 00
            let year = Int(textFields[3].text!) ?? 0000
            
            let book = BookData(title: title, author: author, pages: pages, year: year)
            books.append(book)
            
            textFields[0].text = ""
            textFields[1].text = ""
            textFields[2].text = ""
            textFields[3].text = ""
            
        
        }
    }
    
    func getFilePath() -> String{
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = documentPath.appending("/Data.txt")
        return filePath
    }
    
    
    func loadData(){
        books = [BookData]()
        
        let filePath = getFilePath()
        do{
        let fileContent = try String(contentsOfFile: filePath)
        let contentArray  = fileContent.components(separatedBy: "\n")
            for content in contentArray{
                let con = content.components(separatedBy: ",")
                if con.count == 4 {
                    books.append(BookData(title: con[0], author: con[1], pages: Int(con[2])!, year: Int(con[3])!))
                }
            }
        
        }catch{
            print(error)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let booksTVC = segue.destination as? BooksTVC {
            booksTVC.books = books
        }
    }
    
    @objc func saveData(){
        let filePath = getFilePath()
        
        var string = ""
        for book in books{
            string = "\(string)\(book.title),\(book.author),\(book.pages),\(book.year)\n"
        }
        
        do{
            try string.write(toFile: filePath, atomically: true, encoding: .utf8)
            
        }catch{
            print(error)
        }
        
    }
}

