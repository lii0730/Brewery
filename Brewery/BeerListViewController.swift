//
//  BeerListViewController.swift
//  Brewery
//
//  Created by LeeHsss on 2022/02/06.
//

import UIKit

class BeerListViewController: UITableViewController {
    var beerList = [Beer]()
    var currentPage = 1
    var dataTasks = [URLSessionTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: UINavigationBar Custom
        title = "패캠브루어리"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //MARK: UITableView 설정
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        //MARK: Pagination?
        tableView.prefetchDataSource = self
        
        fetchBeer(of: currentPage)
    }
}

//MARK: UITableView DataSource, Delegate
extension BeerListViewController: UITableViewDataSourcePrefetching {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else { return UITableViewCell() }
        print("Rows: \(indexPath.row)")
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailViewController()
        detailViewController.beer = selectedBeer
        self.show(detailViewController, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // MARK: 미리 불러오는 역할?
        guard currentPage != 1 else { return }
        
        indexPaths.forEach {
            if($0.row + 1) / 25 + 1 == currentPage {
                self.fetchBeer(of: currentPage)
            }
        }
    }
}

//MARK: Data fetching
extension BeerListViewController {
    private func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
              dataTasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil else { return } // 같은 URL이 없다면
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else { print("ERROR: URLSESSION data Task \(error?.localizedDescription)")
                      return
                  }
            
            switch response.statusCode {
            case (200...299):
                self.beerList += beers
                self.currentPage += 1
                
                // GCD
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case (400...499):
                print("Client Error \(response.statusCode)")
            case (500...599):
                print("Server Error \(response.statusCode)")
            default:
                print("ERROR!")
                
                
            }
        }
        
        dataTask.resume()
        dataTasks.append(dataTask)
    }
}
