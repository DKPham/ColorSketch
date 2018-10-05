//
//  PictureCollectionViewCell.swift
//  ColorSketch
//
//  Created by Duy Pham on 10/5/18.
//  Copyright © 2018 Duy Khac. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    var picture: Picture? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        nameLabel.text = picture?.name
        if let imageData = picture?.image {
            pictureImageView.image = UIImage(data: imageData)
        }
    }
}
