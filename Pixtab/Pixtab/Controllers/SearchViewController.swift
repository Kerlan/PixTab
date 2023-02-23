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
    @IBOutlet weak var pagingStackView: UIStackView!
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    
    private var pageNb: Int = 1
    private var imageDatas: [ImageData] = []
    
    @IBAction func foundImages(_ sender: Any) {
        pageNb = 0
        fetchImages(direction: 1)
    }
    
    @IBAction func goPrevPage(_ sender: Any) {
        fetchImages(direction: -1)
    }
    
    @IBAction func goNextPage(_ sender: Any) {
        fetchImages(direction: 1)
    }
    
    func fetchImages(direction: Int) {
        guard let search: String = searchTextField.text else {
            return
        }
        
        setPaging(direction: direction)
        showActivityIndicator(animated: true)
        ApiService.shared.fetchImages(search: search, page: "\(pageNb)") { (status, message, data)  in
            if status, let data = data {
                self.imageDatas = data
                self.imageCollectionView.reloadData()
            } else {
                // gestion d'erreur
            }
            self.showActivityIndicator(animated: false)
        }
    }
    
    func setPaging(direction: Int) {
        if direction < 0 && pageNb > 1{
            pageNb -= 1
        } else {
            pageNb += 1
        }
        if pageNb == 1 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
        pageNbLabel.text = "\(pageNb)"
        pagingStackView.isHidden = false
    }
    
    func showActivityIndicator(animated: Bool) {
        if animated {
            loadingActivityIndicatorView.startAnimating()
            loadingActivityIndicatorView.isHidden = false
            pagingStackView.isHidden = true
        } else {
            loadingActivityIndicatorView.stopAnimating()
            loadingActivityIndicatorView.isHidden = true
            pagingStackView.isHidden = false
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDatas.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchImageCell", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(image: imageDatas[indexPath.row].image, isSelected: imageDatas[indexPath.row].isSelected)
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setFavorisImages(row: indexPath.row)
        collectionView.reloadData()
    }
    
    func setFavorisImages(row: Int) {
        imageDatas[row].isSelected = !imageDatas[row].isSelected
        if imageDatas[row].isSelected {
            ImageFavoris.data.append(imageDatas[row])
        } else {
            ImageFavoris.data.removeAll { (data) in
                if data.id == imageDatas[row].id {
                    return true
                } else {
                    return false
                }
            }
        }
    }
}
