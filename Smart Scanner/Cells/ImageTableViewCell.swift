//
//  ImageTableViewCell.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 2/8/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    lazy var nameCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        contentView.addSubview(nameCardImageView)
        backgroundColor = .clear
        selectionStyle = .none
        nameCardImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        nameCardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        nameCardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        nameCardImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        nameCardImageView.heightAnchor.constraint(equalTo: nameCardImageView.widthAnchor, multiplier: 2.125/3.370).isActive = true
//        nameCardImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
//        nameCardImageView.heightAnchor.constraint(equalTo: nameCardImageView.widthAnchor, multiplier: 2.125/3.370).isActive = true
    }

    func configure(with image: UIImage) {
        self.nameCardImageView.image = image
    }
}

class ImageZoomView: UIScrollView, UIScrollViewDelegate {
    var imageView: UIImageView!
    var gestureRecognizer: UITapGestureRecognizer!
    
    convenience init(frame: CGRect, image: UIImage) {
        self.init(frame: frame)
        
        // Creates the image view and adds it as a subview to the scroll view
        imageView = UIImageView(image: image)
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        setupScrollView()
        setupGestureRecognizer()
    }
    
    func setupScrollView() {
        delegate = self
        minimumZoomScale = 1.0
        maximumZoomScale = 2.0
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // Sets up the gesture recognizer that receives double taps to auto-zoom
    func setupGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleDoubleTap() {
        if zoomScale == 1 {
            zoom(to: zoomRectForScale(maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }
    
    // Calculates the zoom rectangle for the scale
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}

