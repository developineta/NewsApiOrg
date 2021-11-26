//
//  DetailViewController.swift
//  NewsApiOrg
//
//  Created by ineta.magone on 20/11/2021.
//

import SDWebImage
import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var savedItems = [Items]() // CoreData
    var managedObjectContext: NSManagedObjectContext?
    
    var webUrlString = String() // 'read full article' button
    var titleString = String()
    var contentString = String()
    var newsImage = String()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleString
        contentTextView.text = contentString
        newsImageView.sd_setImage(with: URL(string: newsImage), placeholderImage: UIImage(named: "news.png"))
        
        //access here AppDelegate then put persistanceContainer on context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
    }
    
    func loadData(){
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        do{
            let result = try managedObjectContext?.fetch(request)
            savedItems = result!
        }catch{
            fatalError("Error in loading core data item")
        }
    }
    
    func saveData(){
        do{
            try managedObjectContext?.save()
            basicAlert(title: savedTitle, message: savedMessage)
        }catch{
            fatalError("Error in saving in core data item")
        }
    }
    
    let savedTitle: String! = "News article saved!"
    let savedMessage = "Please go to saved tab bar to see saved articles"
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let newItem = Items(context: self.managedObjectContext!)
        newItem.image = newsImage
        newItem.newsTitle = titleString
        newItem.url = webUrlString
        newItem.newsContent = contentString
        
        if !newsImage.isEmpty{
            newItem.image = newsImage
        }
        
        self.savedItems.append(newItem)
        saveData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc: WebViewController = segue.destination as! WebViewController
        vc.urlString = webUrlString
        vc.urlString = webUrlString
    }
}




