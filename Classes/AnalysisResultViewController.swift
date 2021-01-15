//
//  AnalysisResultViewController.swift
//  Pods
//
//  Created by Pedro Spim Costa on 14/01/21.
//

import UIKit
import Vision

@available(iOS 11.0, *)
class AnalysisResultViewController: UIViewController {
    
    @IBOutlet weak var uiResultImageView: UIImageView!
    
    @IBOutlet weak var uiResulLabel: UILabel!
    
    @IBOutlet weak var uiConfidenceLabel: UILabel!

    
    //private var results:  [VNClassificationObservation]
    private var imageToLoad: UIImage?
    
    let viewModel: AnalysisResultViewModel = AnalysisResultViewModel()

    init(image: UIImage) {
        let bundle = Bundle(for: AnalysisResultViewController.self)
        super.init(nibName: "AnalysisResultViewController", bundle: bundle)
        
        self.imageToLoad = image
        self.viewModel.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = imageToLoad else { return }
        
        uiResultImageView.image = imageToLoad
        
        viewModel.updateClassifications(for: image)
        
        configSetup()
        
    }

    func configSetup(){

        uiResultImageView.layer.shadowColor = UIColor.black.cgColor
        uiResultImageView.layer.shadowOpacity = 1
        uiResultImageView.layer.shadowOffset = .zero
        uiResultImageView.layer.shadowRadius = 7
        
    }
    
}


@available(iOS 11.0, *)
extension AnalysisResultViewController: AnalysisResultViewModelDelegate {
    
    func atualizaEstadoClassificacao(estado:String){
        self.uiConfidenceLabel.text = estado
        
    }
    
}
