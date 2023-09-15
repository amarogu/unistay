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

struct TextInputField: View {
    @Binding var text: String
    var placeholder: Text
    //@Binding var textValue: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    var icon: String
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon).font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                ZStack(alignment: .leading) {
                    if text.isEmpty { placeholder }
                    TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13)).textInputAutocapitalization(.never).focused($isFocused)
                }
            }
            }.frame(maxWidth: .infinity).onTapGesture {
                isFocused = true
            }
    }
}
