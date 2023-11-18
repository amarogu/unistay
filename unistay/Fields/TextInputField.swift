//
//  TextInputField.swift
//  unistay
//
//  Created by Gustavo Amaro on 17/09/23.
//

import SwiftUI

struct TextInputField: View {
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var isFocused: Bool
    
    @Binding var input: String
    var placeholderText: LocalizedStringKey
    var placeholderIcon: String
    
    var required: Bool
    
    var padding: CGFloat = 28
    
    @State var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Image(systemName: placeholderIcon).font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                ZStack(alignment: .topLeading) {
                    if input.isEmpty { HStack {
                        Text(placeholderText).customStyle(size: 13).padding(.leading, padding)
                        Spacer()
                        if required && !(placeholderText == "Password" || placeholderText == "Confirm your password") {
                            Circle().frame(width: 4.25, height: 4.25).foregroundColor(.red)
                        }
                    } }
                    if placeholderText == "Password" || placeholderText == "Confirm your password" {
                        HStack {
                            if isPasswordVisible {
                                TextField(text: $input, label: {}).font(.custom("Eina03-Regular", size: 13)).foregroundColor(Color("BodyEmphasized")).padding(.leading, padding).textInputAutocapitalization(.never).autocorrectionDisabled()
                            } else {
                                SecureField(text: $input, label: {}).font(.custom("Eina03-Regular", size: 13)).foregroundColor(Color("BodyEmphasized")).padding(.leading, padding).textInputAutocapitalization(.never).autocorrectionDisabled().textContentType(.newPassword)
                            }
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye" : "eye.slash").font(.system(size: 14))
                            }
                        }
                    } else {
                        TextField(text: $input, axis: placeholderText == "Send a message" || placeholderText == "Update your bio" ? .vertical : .horizontal, label: {}).font(.custom("Eina03-Regular", size: 13)).foregroundColor(Color("BodyEmphasized")).keyboardType(placeholderText == "Rent" ? .numberPad : .default).padding(.leading, padding).textInputAutocapitalization(.never).autocorrectionDisabled()
                    }
                    //styledText(type: "Regular", size: 16, content: "*").foregroundColor(.red).frame(maxWidth: .infinity, alignment: .topTrailing)
                }
            }
        }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).frame(maxWidth: .infinity).onTapGesture {
            isFocused = true
        }
    }
}
