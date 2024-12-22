//
//  Cloudinary.swift
//  LocalEventOrg
//
//  Created by Hasan Abdulrazaq on 21/12/2024.
//

import Foundation
import Cloudinary
import UIKit

let config = CLDConfiguration(cloudName:"dljksxgv7",apiKey: "119476735785725",apiSecret: "4fVDU9BC2DpVc0go1DpGQh4H0es")
let cloudinary = CLDCloudinary(configuration: config)

func uploadImage(image: UIImage) {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

    cloudinary.createUploader().upload(data: imageData, uploadPreset: "Evently", completionHandler:  { (result, error) in
        if error != nil {
            print("Upload failed: (error)")
        } else if let result = result {
            let imageUrl = result.secureUrl
            print("Upload successful: \(imageUrl!)")
            print("Upload successful: (result.secureUrl!)")
        }
    })
}
