//
//  BeerListCell.swift
//  Brewery
//
//  Created by LeeHsss on 2022/02/06.
//

import UIKit
import SwiftUI
import SnapKit
import Kingfisher

class BeerListCell: UITableViewCell {
    let beerImageView = UIImageView()
    let nameLabel = UILabel()
    let taglineLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [beerImageView, nameLabel, taglineLabel].forEach {
            contentView.addSubview($0)
        }
        
        beerImageView.contentMode = .scaleAspectFit
        nameLabel.font = .systemFont(ofSize: 10, weight: .bold)
        nameLabel.numberOfLines = 2
        
        taglineLabel.font = .systemFont(ofSize: 14, weight: .light)
        taglineLabel.textColor = .systemBlue
        taglineLabel.numberOfLines = 0
        
        beerImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.top.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(120)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(beerImageView.snp.trailing).offset(10)
            $0.bottom.equalTo(beerImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        taglineLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
    }
    
    func configure(with beer: Beer) {
        let imageURL = URL(string: beer.image_url ?? "")
        beerImageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "placeHolder"))
        nameLabel.text = beer.name ?? "이름 없는 맥주"
        taglineLabel.text = beer.taglineString
        
        //MARK: 오른쪽 꺽새 표현
        accessoryType = .disclosureIndicator
        //MARK: Cell 클릭해도 회색 음영 표시 안됨
        selectionStyle = .none
        
    }
}
