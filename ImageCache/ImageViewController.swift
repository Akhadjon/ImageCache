//
//  ImageViewController.swift
//  ImageCache
//
//  Created by Akhadjon Abdukhalilov on 9/20/20.
//  Copyright © 2020 Akhadjon Abdukhalilov. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

   
    
    lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupVeiws()
    }
    

    private func setupVeiws(){
        view.addSubview(imageView)
        loadImage { [weak self](image) in
            guard let self = self, let image = image else{return}
            self.imageView.image = image
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }
    
    private func loadImage(completion:@escaping (UIImage?)->() ){
               let url = URL(string: "https://picsum.photos/200/300")!
               guard let data = try? Data(contentsOf: url) else {return}
               let image = UIImage(data: data)
               DispatchQueue.main.async {
                   completion(image)
               }
         }
       

   

}
