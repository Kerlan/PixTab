//
//  SearchViewController.swift
//  Pixtab
//
//  Created by Kerlan PLUMASSEAU on 23/02/2023.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageNbLabel: UILabel!
    @IBOutlet weak var favorisBarButtonItem: UIBarButtonItem!
    
    private var pageNb: Int = 1
    private var imageDatas: [ImageData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func foundImages(_ sender: Any) {
        fetchImages()
    }
    
    @IBAction func goPrevPage(_ sender: Any) {
        if pageNb != 1 {
            pageNb -= 1
            fetchImages()
        }
    }
    
    @IBAction func goNextPage(_ sender: Any) {
        pageNb += 1
        fetchImages()
    }
    
    func fetchImages() {
        guard let search: String = searchTextField.text else {
            return
        }
        guard let page: String = pageNbLabel.text else {
            return
        }
        ApiService.shared.fetchImages(search: search, page: page) { (status, message, data)  in
            if status, let data = data {
                self.imageDatas = data
                print(self.imageDatas.count)
                self.imageCollectionView.reloadData()
            } else {
                // gestion d'erreur
            }
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDatas.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(image: imageDatas[indexPath.row].image, isSelected: imageDatas[indexPath.row].isSelected)
        return cell
    }
}
