//
//  TableViewCell.swift
//  On The Map
//
//  Created by Fernando Marins on 11/10/22.
//

import UIKit
import SnapKit

final class TableViewCell: UITableViewCell {
    
    lazy var locationLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    lazy var linkLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(locationLabel)
        addSubview(linkLabel)
        addContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContraints() {
        locationLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }
        
        linkLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
    }
}
