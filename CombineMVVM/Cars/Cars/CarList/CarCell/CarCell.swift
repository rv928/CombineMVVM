//
//  CarCell.swift
//  Cars
//
//  Created by Ravi Vora on 25/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import UIKit
import Kingfisher
import Combine

class CarCell: UITableViewCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    let gradientLayer = CAGradientLayer()
    
    
    static let identifier = "CarCell"
    
    var viewModel: CarCellViewModel! {
        didSet {
            setUpViewModel()
        }
    }
    
    private func setUpViewModel() {
        titleLabel.text = viewModel.title
        descLabel.text = viewModel.description
        dateLabel.text = viewModel.dateTime
        
        let scale = UIScreen.main.scale
        
        let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: self.bannerImageView.frame.size.width * scale, height: self.bannerImageView.frame.size.height * scale), mode: .aspectFill)
        
        if viewModel.imageURL != "" {
            let imageUrlString = viewModel.imageURL
            let cache = ImageCache.default
            let cacheType: CacheType = cache.imageCachedType(forKey: imageUrlString)
            
            if cacheType == .disk {
                let cacheDiskImage: UIImage = cache.retrieveImageInDiskCache(forKey: imageUrlString)!
                self.bannerImageView.image = cacheDiskImage
            } else if cacheType == .memory {
                let cacheMemoryImage: UIImage = cache.retrieveImageInMemoryCache(forKey: imageUrlString)!
                self.bannerImageView.image = cacheMemoryImage
            } else {
                if let url = URL(string: imageUrlString), UIApplication.shared.canOpenURL(url) {
                    
                    self.bannerImageView.kf.setImage(
                        with: url,
                        options: [
                            .backgroundDecode,
                            .processor(resizingProcessor),
                            .cacheOriginalImage
                        ],
                        completionHandler: { image, error, cacheType, imageURL in
                            
                            if error != nil {
                            }
                    })
                }
            }
        } else {
            self.bannerImageView.image = UIImage(named: UIConstant.Images.noImageLarge)
        }
        let colorSet = [UIColor.clear,
                        UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)]
        let location = [0.5, 0.6]
        self.bannerImageView.addGradient(with: gradientLayer, colorSet: colorSet, locations: location)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = self.bounds
    }
}
