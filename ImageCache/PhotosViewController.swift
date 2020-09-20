//
//  ViewController.swift
//  ImageCache
//
//  Created by Akhadjon Abdukhalilov on 9/20/20.
//  Copyright © 2020 Akhadjon Abdukhalilov. All rights reserved.

import UIKit

class PhotosViewController: UIViewController {

//MARK:Properties
//
    private let cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue =  DispatchQueue.global(qos: .utility)
    
    lazy var operationQueue :OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        queue.underlyingQueue = self.utilityQueue
        return queue
    }()

    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: ImageViewCell.identifier)
        collectionView.backgroundColor = .red
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
//MARK:Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
//MARK:UISetup
    
    private func setupView(){
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (view.frame.width-2)/3, height: (view.frame.width-2)/2)
        return layout
    }
    
    
 //MARK: Image Loading
    
    private func loadImage(completion:@escaping (UIImage?)->() ){
        self.operationQueue.addOperation {
            let url = URL(string: "https://picsum.photos/200/300")!
            guard let data = try? Data(contentsOf: url) else {return}
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 500
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.identifier, for: indexPath) as! ImageViewCell
        return cell
    }
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let vc = ImageViewController()
        navigationController?.pushViewController(vc, animated: true)
          
    }
  
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? ImageViewCell else {return}
        let itemNumber = NSNumber(value: indexPath.item)
        
        if let cachedImage = self.cache.object(forKey: itemNumber){
            cell.photoImageView.image = cachedImage
        }else{
            self.loadImage { [weak self](image) in
                guard let self = self , let image = image else{return}
                cell.photoImageView.image = image
                self.cache.setObject(image, forKey: itemNumber)
            }
        }
    }
}
