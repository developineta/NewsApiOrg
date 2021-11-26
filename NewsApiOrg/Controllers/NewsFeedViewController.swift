//
//  ViewController.swift
//  NewsApiOrg
//
//  Created by ineta.magone on 19/11/2021.
//

import SDWebImage
import UIKit

class NewsFeedViewController: UIViewController {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var newsItems: [NewsItem] = []
    var searchResult = "apple"
    // newsapi.org apikey here
    var apiKey = "36f8222e4fde493c9c19b181cb2c8e32"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Apple News"
        handleGetData()
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        basicAlert(title: "News Feed Info", message: "Press plane icon to update News Feed articles")
    }
    
    @IBAction func updateDataTapped(_ sender: Any) {
        handleGetData()
    }
    
    func activityIndicator(animated: Bool){
        DispatchQueue.main.async {
            if animated{
                self.activityIndicatorView.isHidden = false
                self.activityIndicatorView.startAnimating()
            }else{
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func handleGetData(){
        activityIndicator(animated: true)
        let jsonUrl = "https://newsapi.org/v2/everything?q=\(searchResult)&from=2021-11-19&to=2021-11-05&sortBy=popularity&apiKey=\(apiKey)"
        
        guard let url = URL(string: jsonUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        //urlsession
        URLSession(configuration: config).dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                print((error?.localizedDescription)!)
                self.basicAlert(title: "Error!", message: "\(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let data = data else {
                self.basicAlert(title: "Error!", message: "Something weng wrong, no data.")
                return
            }
            
            do{
                let jsonData = try JSONDecoder().decode(Articles.self, from: data)
                self.newsItems = jsonData.articles
                DispatchQueue.main.async {
                    print("self.newsItems:", self.newsItems)
                    self.tableViewOutlet.reloadData()
                    self.activityIndicator(animated: false)
                }
            }catch{
                print("err:", error)
            }
        }.resume()
    }
}
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsFeedTableViewCell else {return UITableViewCell()}
        
        let item = newsItems[indexPath.row]
        cell.titleLabel.text = item.title // viewCell names.text to
        cell.titleLabel.numberOfLines = 0
        cell.articleImage.sd_setImage(with:URL(string: item.urlToImage), placeholderImage: UIImage(named: "news.png"))
        
        // Formatting date to display correctly
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: item.publishedAt) {
            formatter.dateFormat = "dd/MM/yyyy"
            cell.dateLabel.text = "Published at : \(formatter.string(from: date))"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storybord = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storybord.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {return}
        let item = newsItems[indexPath.row]
        vc.newsImage = item.urlToImage
        vc.titleString = item.title
        vc.webUrlString = item.url
        vc.contentString = item.description
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
