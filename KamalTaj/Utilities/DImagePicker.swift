//
//  DImagePicker.swift
//  Nemosyn
//
//  Created by Kondaiah V on 12/24/18.
//  Copyright © 2018 com. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

// protocol...
protocol DImagePickerDelegate: class {
    func imagePickerDidSelected(image: UIImage)
    func imagePickerDidCancel()
}

// class...
class DImagePicker: NSObject {
    
    // instance
    static let shared = DImagePicker()
    
    // variables
    weak var delegate: DImagePickerDelegate?
    weak var view_ctrl: UIViewController?
    private let image_picker = UIImagePickerController()
    private var is_edit: Bool = false
    
    // private
    private override init() {}
    
    // alert...
    func addAlertViewCtrl(isEdit: Bool) -> Void {
        
        // edit...
        is_edit = isEdit
        
        // alert...
        let alert_ctrl = UIAlertController.init(title: "Choose from", message: nil, preferredStyle: .actionSheet)
        alert_ctrl.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert: UIAlertAction) in
            self.cameraPermission()
        }))
        alert_ctrl.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (alert: UIAlertAction) in
            self.photoLibraryPermission()
        }))
        alert_ctrl.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
            
        }))
        view_ctrl?.present(alert_ctrl, animated: true, completion: nil)
    }
}

extension DImagePicker {
    
    // MARK:- Helpers
    private func imagePickerFromCamera() -> Void {
        
        // images from camera...
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            image_picker.sourceType = .camera
            image_picker.allowsEditing = is_edit
            image_picker.delegate = self
            view_ctrl?.present(image_picker, animated: true, completion: nil)
        } else {
            
            // no source alert...
            let alert_ctrl = UIAlertController.init(title: "Alert !", message: "Camera source not available", preferredStyle: .alert)
            alert_ctrl.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            view_ctrl?.present(alert_ctrl, animated: true, completion: nil)
        }
    }
    
    private func imagePickerFromPhotos() -> Void {
        
        // images from photos...
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            DispatchQueue.main.async {
                self.image_picker.sourceType = .photoLibrary
                self.image_picker.allowsEditing = self.is_edit
                self.image_picker.delegate = self
                self.view_ctrl?.present(self.image_picker, animated: true, completion: nil)
            }
        } else {
            
            // no source alert...
            let alert_ctrl = UIAlertController.init(title: "Alert !", message: "Photo Library source not available", preferredStyle: .alert)
            alert_ctrl.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            view_ctrl?.present(alert_ctrl, animated: true, completion: nil)
        }
    }
    
    // MARK:- Permissions
    private func cameraPermission() {
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            // The user has previously granted access to the camera.
            self.imagePickerFromCamera()
            
        case .denied, .restricted:
            // The user can't grant access due to restrictions.
            self.accessAppOpenSettings(title_msg: "Camera Permission Unavailable.")
            
        case .notDetermined:
            // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.imagePickerFromCamera()
                }
            }
            
        default:
            break
        }
    }
    
    private func photoLibraryPermission() {
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // The user has previously granted access to the library.
            self.imagePickerFromPhotos()
            
        case .denied, .restricted:
            // The user can't grant access due to restrictions.
            self.accessAppOpenSettings(title_msg: "Library Permission Unavailable.")
            
        case .notDetermined:
            // The user has not yet been asked for library access.
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized {
                    
                    // photo library access given...
                    self.imagePickerFromPhotos()
                }
            })
        default:
            break
        }
    }
    
    private func accessAppOpenSettings(title_msg: String) {
        
        // permission not available
        let alert_ctrl = UIAlertController (title: title_msg, message: "Please check to see if device settings doesn't allow", preferredStyle: .alert)
        alert_ctrl.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (alert: UIAlertAction) in
            
            // open setting page...
            let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url as URL)
                }
            }
        }))
        alert_ctrl.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        view_ctrl?.present(alert_ctrl , animated: true, completion: nil)
    }
}

extension DImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let picked_Image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("Image edit picked : \(picked_Image)")
            self.delegate?.imagePickerDidSelected(image: picked_Image)
        }
        else if let picked_Image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("Image original picked : \(picked_Image)")
            self.delegate?.imagePickerDidSelected(image: picked_Image)
        }
        else {
            print("Image not selected error...!")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.delegate?.imagePickerDidCancel()
        picker.dismiss(animated: true, completion: nil)
    }
}


