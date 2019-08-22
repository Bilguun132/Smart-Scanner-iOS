//
//  SettingsNameCardTableViewCell.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 6/8/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit

class SettingsNameCardTableViewCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = Theme.labelTextColor
        label.numberOfLines = 0
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = Theme.labelTextColor?.withAlphaComponent(0.8)
        label.text = "Tap to register to be able to save your name cards securely on the cloud and share accross your devices."
        label.numberOfLines = 0
        return label
    }()
    
    lazy var cardImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = UIStackView.Distribution.fillProportionally
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        backgroundColor = .clear
        selectionStyle = .none
        
        let guide = safeAreaLayoutGuide
        contentView.addSubview(verticalStackView)
        contentView.addSubview(cardImage)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(detailLabel)
        NSLayoutConstraint.activate([
            cardImage.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -8),
            cardImage.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            cardImage.widthAnchor.constraint(equalToConstant: 120),
            cardImage.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            cardImage.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -16),
            
            verticalStackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: cardImage.leadingAnchor, constant: -8),
            verticalStackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            verticalStackView.topAnchor.constraint(equalTo: guide.topAnchor)
            ])
    }
    
    func configure(with name: String?, and image: UIImage?) {
        nameLabel.text = name ?? "Not Registered"
        cardImage.image = image ?? UIImage(named: "empty_namecard")
        nameLabel.textColor = Theme.labelTextColor
        detailLabel.textColor = Theme.labelTextColor?.withAlphaComponent(0.8)
    }
}
