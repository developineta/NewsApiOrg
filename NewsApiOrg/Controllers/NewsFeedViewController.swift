//
//  ViewController.swift
//  NewsApiOrg
//
//  Created by ineta.magone on 19/11/2021.
//

import UIKit

class NewsFeedViewController: UIViewController {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var newsItems: [NewsItem] = []
    var searchResult = "apple"
    //put your newsapi.org apikey here
    var apiKey = "36f8222e4fde493c9c19b181cb2c8e32"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Apple News"
        handleGetData()
    }

    func handleGetData(){
        let jsonUrl = "https://newsapi.org/v2/everything?q=\(searchResult)&from=2021-11-19&to=2021-11-05&sortBy=popularity&apiKey=\(apiKey)"
        
        guard let url = URL(string: jsonUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        URLSession(configuration: config).dataTask(with: urlRequest) { (dataNews, response, err)  in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            guard let data = dataNews else {
                print(String(describing: err))
                return
            }
            do{
                let jsonData = try JSONDecoder().decode(Articles.self, from: data)
                self.newsItems = jsonData.articles
                DispatchQueue.main.async {
                    print("jsonData of Articles: ", jsonData)
                    self.tableViewOutlet.reloadData()
                }
            }catch{
                print("Catch err:", error)
            }
        //"complete URLSession(configuration: to print(jsonData of Articles)"
        }.resume()
    }
}
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsFeedTableViewCell else { return UITableViewCell()}
        let newsArticle = newsItems[indexPath.row]
        cell.setupUI(withDataFrom: newsArticle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    
    }
// MARK: - Navigation

    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath =  tableViewOutlet.indexPathForSelectedRow {
            let detailVC = segue.destination as! NewsFeedDetailViewController
            detailVC.newsArticle = newsItems[indexPath.row]
        }
    }*/
}
