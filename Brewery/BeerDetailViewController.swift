//
//  BeerDetailViewController.swift
//  Brewery
//
//  Created by LeeHsss on 2022/02/06.
//

import UIKit

class BeerDetailViewController: UITableViewController {
    var beer: Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = beer?.name ?? "이름 없는 맥주"
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BeerDetailListCell")
        tableView.rowHeight = UITableView.automaticDimension
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        let headerView = UIImageView(frame: frame)
        let imageURL = URL(string: beer?.image_url ?? "")
        
        headerView.contentMode = .scaleAspectFit
        headerView.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeHolder"))
        
        tableView.tableHeaderView = headerView
    }
}

//MARK: TableView DataSource, Delegate
extension BeerDetailViewController {
    
    //MARK: Section의 갯수
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    //MARK: 하위 Section의 갯수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            return beer?.food_pairing?.count ?? 0
        default:
            return 1
        }
    }
    
    //MARK: Section의 타이틀 설정
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ID"
        case 1:
            return "Description"
        case 2:
            return "Brewers Tip"
        case 3:
            let isFoodParingEmpty = beer?.food_pairing?.isEmpty ?? true
            return isFoodParingEmpty ? nil : "Food Paring"
            
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "BeerDetailListCell") // 각 섹션별 cell 정의
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = String(describing: beer?.id ?? 0)
            return cell
        case 1:
            cell.textLabel?.text = beer?.description ?? "설명없는 맥주"
            return cell
        case 2:
            cell.textLabel?.text = beer?.brewers_tips ?? "팁 없는 맥주"
            return cell
        case 3:
            cell.textLabel?.text = beer?.food_pairing?[indexPath.row] ?? ""
            return cell
        default:
            return cell
            
        }
    }
}
