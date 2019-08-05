//
//  CardCell.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 31/7/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    private let cardAspectRatioMultipler = 2.125 / 3.370
    
    lazy var scannedCard: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        image.layer.borderColor = Theme.labelTextColor!.withAlphaComponent(0.8).cgColor
        image.layer.borderWidth = 1
        return image
    }()
    
    lazy var contactName: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.labelTextColor
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(scannedCard)
//        addSubview(contactName)
        NSLayoutConstraint.activate([
            // image view
            scannedCard.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scannedCard.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scannedCard.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scannedCard.heightAnchor.constraint(equalTo: scannedCard.widthAnchor, multiplier: CGFloat(cardAspectRatioMultipler)),
            
//            contactName.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
//            contactName.centerXAnchor.constraint(equalTo: scannedCard.centerXAnchor)
            ])
    }
    
    func configure(with model: NameCard) {
        contactName.text = model.name
        if let imageData = model.cardImage {
            let image = UIImage(data: imageData)
            scannedCard.image = image
        }
    }
}
