//
//  MenuItemSheet.swift
//  unistay
//
//  Created by Gustavo Amaro on 19/08/23.
//

import SwiftUI



struct MenuItemSheet: View {
    @Binding var showingData: Bool
    var titleIcon: String
    var sheetTitle: String
    var description: String
    var action: String
    var fields: [String]
    @State var states: [String]
    //var placeholder: Text
    //@State private var states: []
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @State private var upper: CGFloat = 0
    var body: some View {
        ZStack {
            Color("BackgroundColor")
            VStack {
                VStack {
                    HStack {
                        HStack {
                            Text(sheetTitle).customStyle(type: "Semibold", size: 20)
                            Image(systemName: titleIcon)
                        }
                        Spacer()
                        Button(action: {
                            showingData.toggle()
                        }) {
                            Text("Done").customStyle(type: "Semibold", size: 16, color: "AccentColor")
                        }
                    }
                    if(!description.isEmpty) {
                        HStack {
                            Text(description).customStyle(size: 14)
                            Spacer()
                        }.padding(.top, 2)
                    }
                }.padding(.top, 32).padding(.horizontal, 20)
                Form {
                    if(!fields.isEmpty) {
                        Section {
                            ForEach(fields, id: \.self) {
                                field in
                                ZStack(alignment: .leading) {
                                    if states[fields.firstIndex(of: field)!].isEmpty { Text(field).customStyle(size: 13) }
                                    TextField("", text: $states[fields.firstIndex(of: field)!], onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13)).tint(Color("Body"))
                                }
                            }
                            Button(action: {
                                
                            }) {
                                Text("Forgot your password").customStyle(size: 14)
                            }
                            
                        }.listRowBackground(Color("SearchBar"))
                    }
                    
                    Section {
                        Button(action: {
                            
                        }) {
                            Text(action).customStyle(size: 14)
                        }
                    }.listRowBackground(Color("SearchBar"))
                }.padding(.top, upper).scrollContentBackground(.hidden).foregroundColor(.blue).background(Color("BackgroundColor"))
                
                
            }
        }
    }
    
    
    /*struct MenuItemSheet_Previews: PreviewProvider {
        static var previews: some View {
            MenuItemSheet(fields: ["Current password", "New password", "Confirm new password"], states: ["", "", ""])
        }
    }*/
}
