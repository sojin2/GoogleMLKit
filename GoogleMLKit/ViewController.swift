//
//  ViewController.swift
//  GoogleMLKit
//
//  Created by 김소진 on 2023/08/18.
//

import MLKitFaceDetection
import MLKitVision
import UIKit

class ViewController: UIViewController {
    
    private lazy var faceDetectorOption: FaceDetectorOptions = {
      let option = FaceDetectorOptions()
      option.contourMode = .all
      return option
    }()
    
    private lazy var faceDetector = FaceDetector.faceDetector(options: faceDetectorOption)
    
    override func viewDidLoad() {
      super.viewDidLoad()
    }
    
    func runFaceContourDetection(with image: UIImage) {
      let visionImage = VisionImage(image: image)
      faceDetector.process(visionImage) { features, error in
        self.processResult(from: features, error: error)
      }
    }
    
    func processResult(from faces: [Face]?, error: Error?) {
      removeDetectionAnnotations()
      guard let faces = faces else {
        return
      }

      for feature in faces {
        let transform = self.transformMatrix()
      }
    }
    
    private func transformMatrix() -> CGAffineTransform {
      guard let image = imageView.image else { return CGAffineTransform() }
      let imageViewWidth = imageView.frame.size.width
      let imageViewHeight = imageView.frame.size.height
      let imageWidth = image.size.width
      let imageHeight = image.size.height

      let imageViewAspectRatio = imageViewWidth / imageViewHeight
      let imageAspectRatio = imageWidth / imageHeight
      let scale =
        (imageViewAspectRatio > imageAspectRatio)
        ? imageViewHeight / imageHeight : imageViewWidth / imageWidth

      // Image view's `contentMode` is `scaleAspectFit`, which scales the image to fit the size of the
      // image view by maintaining the aspect ratio. Multiple by `scale` to get image's original size.
      let scaledImageWidth = imageWidth * scale
      let scaledImageHeight = imageHeight * scale
      let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
      let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)

      var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
      transform = transform.scaledBy(x: scale, y: scale)
      return transform
    }
    
}
