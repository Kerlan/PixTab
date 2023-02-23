//
//  ImageCollectionViewCell.swift
//  Pixtab
//
//  Created by Kerlan PLUMASSEAU on 23/02/2023.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var heartImageView: UIImageView!
    
    func configure(image: UIImage, isSelected: Bool) {
        heartImageView.isHidden = !isSelected
        imageImageView.image = image
        
        if isSelected {
            imageImageView.alpha = 0.5
        } else {
            imageImageView.alpha = 1
        }
    }
}
