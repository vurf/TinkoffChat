//
//  PhotosVIewController.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 5/1/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

class PhotosViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    weak var collectionPickerDelegate: IPhotosViewControllerDelegate?
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    private var photosFacade: IPhotosFacade
    private var dataSource: [PhotoDisplayModel] = []
    
    init(photosFacade: IPhotosFacade) {
        self.photosFacade = photosFacade
        super.init(nibName: "PhotosViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Yellow flowers"
        self.collectionView.register(UINib(nibName: PhotoCollectionViewCell.idenfitifier, bundle:nil), forCellWithReuseIdentifier: PhotoCollectionViewCell.idenfitifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicatorView.startAnimating()
        self.photosFacade.fetchYellowFlowers()
    }
}

// MARK: - IPhotoModelDelegate
extension PhotosViewController: IPhotoModelDelegate {
    func setup(dataSource: [PhotoDisplayModel]) {
        self.dataSource = dataSource
        
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    func show(error message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.idenfitifier, for: indexPath) as? PhotoCollectionViewCell {
            
            let photoDisplayModel = self.dataSource[indexPath.item]
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.photosFacade.fetchImage(urlString: photoDisplayModel.webformatUrl) { (image) in
                    if let image = image {
                        DispatchQueue.main.async {
                            cell.configure(image: image, photoDisplayModel: photoDisplayModel)
                        }
                    }
                }
            }
            
            return cell
        }
        
        return PhotoCollectionViewCell(frame: CGRect.zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell: PhotoCollectionViewCell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
        
            guard let image = cell.imageView.image else {
                return
            }
            
            self.collectionPickerDelegate?.collectionPickerController(self, didFinishPickingImage: image)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = self.sectionInsets.left * (self.itemsPerRow + 1)
        let availableWidth = self.view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return self.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return self.sectionInsets.left
    }
    
}
