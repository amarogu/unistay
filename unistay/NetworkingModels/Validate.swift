//
//  Validate.swift
//  unistay
//
//  Created by Gustavo Amaro on 03/10/23.
//

import SwiftUI

class Validate: ObservableObject {
    @Published var validationError: String = ""
    func validateBio(bio: String) -> Bool {
        let bio = bio
        if bio.count < 15 {
            validationError = "The bio needs to be at least 15 characters long"
            return false
        } else {
            return true
        }
    }

    func validateSignUp(inputs: [String], isToggled: Binding<Bool>) -> Bool {
        let username = inputs[0]
        let email = inputs[1]
        let emailConfirm = inputs[2]
        let password = inputs[3]
        let passwordConfirm = inputs[4]
        if username.count < 3 || username.count > 20 {
            validationError = "The username needs to be 3 to 20 characters long"
            return false
        }
        if email != emailConfirm {
            validationError = "The e-mail addresses do not match"
            return false
        }
        if password != passwordConfirm {
            validationError = "The passwords do not match"
            return false
        }
        if email.count < 5 || email.count > 50 || !email.contains("@") {
            validationError = "The e-mail address is not valid"
            return false
        }
        if password.count < 8 || password.count > 50 {
            validationError = "The password does not fit the criteria"
            return false
        }
            
        validationError = ""
        return true
    }

    func hasProfileImage(profileImage: UIImage?) -> Bool {
        if let _ = profileImage {
            validationError = ""
            return true
        } else {
            validationError = "Please insert a profile picture"
            return false
        }
    }

    func hasMultipleImages(images: [UIImage]) -> Bool {
        if images.count > 2 {
            validationError = ""
            return true
        } else {
            validationError = "You need to insert at least three images"
            return false
        }
    }

    func validateLocation(loc: String) -> Bool {
        if loc.isEmpty {
            validationError = "You need to insert a location"
            return false
        } else {
            validationError = ""
            return true
        }
    }

    func validatePublication(title: String, desc: String, rent: String) -> Bool {
        if title.count <= 5 {
            validationError = "You need to isnert a title that is bigger than 5 characters"
            return false
        }
        
        if title.count >= 25 {
            validationError = "Your title cannot be longer than 25 characters"
            return false
        }
        
        if desc.count <= 60 {
            validationError = "Your publication description needs to be at least 60 characters long"
            return false
        }
        
        if desc.count >= 600 {
            validationError = "Your description cannot be longer than 600 characters"
            return false
        }
        
        if Int(rent)! <= 200 {
            validationError = "Your rent value seems too low."
            return false
        }
        
        if Int(rent)! >= 10000 {
            validationError = "Your rent value seems too big"
            return false
        }
        
        validationError = ""
        return true
    }

}
