//
//  ImageAnalyzerService.swift
//  Pods
//
//  Created by Pedro Spim Costa on 14/01/21.
//

import UIKit
import CoreML
import Vision

public protocol ImageAnalyzerService {
    func analyzeImage(image: UIImage, navigationController: UINavigationController, failure: @escaping (_ error: String) -> Void)
}

@available(iOS 12.0, *)
public class ImageAnalyzer: ImageAnalyzerService {
    
    
    public init() {}
    
    public func analyzeImage(image: UIImage, navigationController: UINavigationController, failure: @escaping (_ error: String) -> Void) {
        
        let vc = AnalysisResultViewController(image: image)
        //let analysisDetailViewController = AnalysisDetailViewController(image: image, results: results)
        navigationController.pushViewController(vc, animated: true)
        
    }
    
}

