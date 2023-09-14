//
//  LaunchView.swift
//  unistay
//
//  Created by Gustavo Amaro on 23/08/23.
//

import SwiftUI

public struct RemoveFocusOnTapModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
#if os (iOS)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
#elseif os(macOS)
            .onTapGesture {
                DispatchQueue.main.async {
                    NSApp.keyWindow?.makeFirstResponder(nil)
                }
            }
#endif
    }
}

extension View {
    public func removeFocusOnTap() -> some View {
        modifier(RemoveFocusOnTapModifier())
    }
}

struct Field: View {
    var placeholder: Text?
    @Binding var textValue: String?
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    var icon: String?
    @FocusState private var isFocused: Bool
    var fieldType: String?
    @Binding var presented: Bool?
    @Binding var croppedImage: UIImage?
    var menuContent: [String]?
    @State var menuSelection: String?
    var body: some View {
        fieldView(for: fieldType!)
    }
    @ViewBuilder
    private func fieldView (for type: String) -> some View {
        switch type {
        case "text":
            VStack {
                HStack {
                    Image(systemName: icon!).font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                    ZStack(alignment: .leading) {
                        if textValue!.isEmpty { placeholder }
                        TextField("", text: Binding<String>(
                            get: { self.textValue ?? "" },
                            set: { newValue in self.textValue = newValue }
                        ), onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13)).textInputAutocapitalization(.never).focused($isFocused)
                    }
                }
            }.frame(maxWidth: .infinity).onTapGesture {
                isFocused = true
            }
        case "emptyImg":
            Button(action: {
                presented!.toggle()
            }) {
                HStack {
                    Image(systemName: "person.crop.circle.badge.plus").font(.system(size: 14))
                    styledText(type: "Regular", size: 13, content: "Click here to insert a profile picture")
                    Spacer()
                }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.bottom, 4)
            }.cropImagePicker(crop: .circle, show: Binding<Bool>(
                get: {self.presented ?? false},
                set: {newValue in self.presented = newValue}
            ), croppedImage: $croppedImage)
        case "selectedImg":
            Button(action: {
                presented!.toggle()
            }) {
                if let croppedImage {
                    Image(uiImage: croppedImage).resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 40)
                } else {
                    HStack {
                        Image(systemName: "person.crop.circle.badge.plus").font(.system(size: 14))
                        styledText(type: "Regular", size: 13, content: "Click here to insert a profile picture")
                        Spacer()
                    }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
                }
            }.cropImagePicker(crop: .circle, show: Binding<Bool>(
                get: {self.presented ?? false},
                set: {newValue in self.presented = newValue}
            ), croppedImage: $croppedImage)
        case "menu":
            Menu {
                ForEach(menuContent!, id: \.self) {
                    item in
                    Button(action: {
                        menuSelection = item
                    }) {
                        Label(item, systemImage: menuSelection == item ? "checkmark" : "")
                    }
                }
            } label: {
                HStack {
                    Image(systemName: icon!).font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                    placeholder
                    Spacer()
                    Image(systemName: "chevron.down").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                }
            }
        default:
            EmptyView()
        }
    }
}
