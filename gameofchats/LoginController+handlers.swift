//
//  LoginController+handlers.swift
//  gameofchats
//
//  Created by Umoru Joseph on 11/11/16.
//  Copyright © 2016 Umoru Joseph. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func handleProfileViewImage(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //if let editedImage = info
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profielImageView.image = selectedImage
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel picker")
        dismiss(animated: true, completion: nil)
    }
    
    func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("form is valid")
            return
        }
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (usr, err) in
            if let error = err {
                print(error.localizedDescription)
            }
            
            guard let uid = usr?.uid else {
                return
            }
            
            //sucessfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profileImages").child("\(imageName).jpeg")
            
            if let profileImage = self.profielImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1){
            
            //if let uploadData = UIImageJPEGRepresentation(self.profielImageView.image!, 0.1){
            
            //if let uploadData = UIImagePNGRepresentation(self.profielImageView.image!){
                storageRef.put(uploadData, metadata: nil, completion: { (metaData, errorrr) in
                    if let error = errorrr {
                        print(error.localizedDescription)
                    }
                    
                    if let profileImageUrl = metaData?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabase(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
            
            
            
            

            
        })
        
    }
    
    private func registerUserIntoDatabase(uid: String, values: [String : AnyObject]){
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values, withCompletionBlock: { (errr, ref) in
            if let error = errr {
                print(error.localizedDescription)
            }
            //self.messageController?.fetchUserAndSetupNavBarTitle()
            //self.messageController?.navigationItem.title = values["name"] as? String
            let user = User()
            user.setValuesForKeys(values)
            //potential crash of keys dpnt match
            
            self.messageController?.setupNavBarWithUser(user: user)
            
            
            self.dismiss(animated: true, completion: nil)
        })
    }
}
