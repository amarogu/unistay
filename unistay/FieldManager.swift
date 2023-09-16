//
//  ImageFields.swift
//  unistay
//
//  Created by Gustavo Amaro on 15/09/23.
//

import SwiftUI

struct FieldManager: View {
    var content: String?
    var currentStepFields: [String]
    @Binding var inputs: [[String]]
    var icons: [[String]]
    var currentStep: Int
    @State var croppedImage: UIImage?
    var type: String
    @Binding var isToggleOn: Bool
    var body: some View {
        if type == "image" {
            if croppedImage != nil {
                HStack {
                    ForEach(currentStepFields, id: \.self) {
                        (field: String) in
                        if field == content {
                            PicField(croppedImage: $croppedImage, content: [field, icons[currentStep][currentStepFields.firstIndex(of: field)!]]).padding(.bottom, 4)
                        } else {
                            TextInputField(text: $inputs[currentStep][currentStepFields.firstIndex(of: field)!], placeholder: styledText(type: "Regular", size: 13, content: field), icon: icons[currentStep][currentStepFields.firstIndex(of: field)!]).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.bottom, 4)
                        }
                    }
                }
            } else {
                ForEach(currentStepFields, id: \.self) {
                    field in
                    if field == content {
                        PicField(croppedImage: $croppedImage, content: [field, icons[currentStep][currentStepFields.firstIndex(of: field)!]]).padding(.bottom, 4)
                    } else {
                        TextInputField(text: $inputs[currentStep][currentStepFields.firstIndex(of: field)!], placeholder: styledText(type: "Regular", size: 13, content: field), icon: icons[currentStep][currentStepFields.firstIndex(of: field)!]).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.bottom, 4)
                    }
                }
            }
        }
        if type == "general" {
            ForEach(currentStepFields, id: \.self) {
                field in
                if field == "Sign up as a publisher account" {
                    ToggleField(isToggleOn: $isToggleOn, field: field).padding(.bottom, 4)
                    
                } else if field == "Type" {
                    MenuField(items: ["On-campus", "Off-campus", "Homestay"], menuSelection: "On-campus", icon: icons[currentStep][currentStepFields.firstIndex(of: field)!], placeholder: styledText(type: "Regular", size: 13, content: field)).padding(.bottom, 4)
                    ToggleField(isToggleOn: $isToggleOn, field: field).padding(.bottom, 4)
                    
                } else if field == "Publication visibility" {
                    MenuField(items: ["Public", "Private"], menuSelection: "Public", icon: icons[currentStep][currentStepFields.firstIndex(of: field)!], placeholder: styledText(type: "Regular", size: 13, content: field)).padding(.bottom, 4)
                    ToggleField(isToggleOn: $isToggleOn, field: field).padding(.bottom, 4)
                } else {
                    TextInputField(text: $inputs[currentStep][currentStepFields.firstIndex(of: field)!], placeholder: styledText(type: "Regular", size: 13, content: field), icon: icons[currentStep][currentStepFields.firstIndex(of: field)!]).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.bottom, 4)
                }
            }
        }
    }
}

