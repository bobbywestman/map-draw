//
//  ViewController+Upload.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/27/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    @IBAction func uploadButtonClick(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.modalPresentationStyle = .currentContext
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate {
    // must implement for UIImagePickerController
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            selectImage(image)
        }
        
        picker.dismiss(animated: true, completion: {
            
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // reset selector position before dismissing, so that it doesnt jump around
        resetSelectorPosition()

        picker.dismiss(animated: true, completion: { [weak self] in
            // need to do this after transition as well, in case orientation changes during transition
            self?.resetSelectorPosition()
        })
    }
}
