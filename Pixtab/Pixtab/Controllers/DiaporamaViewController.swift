//
//  DiaporamaViewController.swift
//  Pixtab
//
//  Created by Kerlan PLUMASSEAU on 23/02/2023.
//

import UIKit

class DiaporamaViewController: UIViewController {
    @IBOutlet weak var imageView: UIView!
    
    var currentImageView: UIImageView = UIImageView()
    var nextImageView: UIImageView = UIImageView()
    var currentImageindex: Int = 0
    var imageDatas: [ImageData] = ImageFavoris.data
    var runAnimation: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(currentImageView)
        view.addSubview(nextImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImageViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        runAnimation = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currentImageView.frame = imageView.frame
        nextImageView.frame = imageView.frame
    }
    
    func animateImageViews() {
        if !runAnimation { return }
        
        swap(&currentImageView, &nextImageView)
        nextImageView.image = imageDatas[currentImageindex].image
        currentImageindex = (currentImageindex + 1) % imageDatas.count
        UIView.animate(withDuration: 1.5, animations: {
            self.currentImageView.alpha = 0
            self.nextImageView.alpha = 1
            }, completion: { _ in
            self.animateImageViews()
        })
    }
}
