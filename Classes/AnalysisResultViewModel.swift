//
//  AnalysisResultViewModel.swift
//  Pods
//
//  Created by Pedro Spim Costa on 15/01/21.
//

import Foundation
import Vision

protocol AnalysisResultViewModelDelegate {
    func atualizaEstadoClassificacao(estado: String)
}

@available(iOS 11.0, *)
class AnalysisResultViewModel {
    var delegate: AnalysisResultViewModelDelegate?
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {

            let model = try VNCoreMLModel(for: MobileNetV2().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                
                self.delegate?.atualizaEstadoClassificacao(estado: "Impossível classificar imagem.\n\(error!.localizedDescription)")
                return
            }
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                self.delegate?.atualizaEstadoClassificacao(estado: "Nada reconhecido.")
            } else {
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    return String(format: "%.1f%% %@", classification.confidence * 100, classification.identifier)
                }
                self.delegate?.atualizaEstadoClassificacao(estado: descriptions.joined(separator: "\n"))
            }
        }
    }
    
    func updateClassifications(for image: UIImage) {
        // self.delegate?.atualizaEstadoClassificacao(estado: "Classificando...")
        
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            do {
                try handler.perform([self.classificationRequest])
            } catch {

                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
}
