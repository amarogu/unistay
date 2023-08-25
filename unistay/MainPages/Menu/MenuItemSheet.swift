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
        
        ZStack(alignment: .top) {
            Form {
                
                if(!fields.isEmpty) {
                    Section {
                        ForEach(fields, id: \.self) {
                            field in
                            ZStack(alignment: .leading) {
                                if states[fields.firstIndex(of: field)!].isEmpty { styledText(type: "Regular", size: 13, content: field).foregroundColor(Color("BodyEmphasized")) }
                                TextField("", text: $states[fields.firstIndex(of: field)!], onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13)).tint(Color("Body"))
                            }
                        }
                        Button(action: {
                            
                        }) {
                            styledText(type: "Regular", size: 14, content: "Forgot your password?").foregroundColor(Color("BodyEmphasized"))
                        }
                        
                    }.listRowBackground(Color("SearchBar"))
                }
                
                Section {
                    Button(action: {
                        
                    }) {
                        styledText(type: "Semibold", size: 14, content: action).foregroundColor(Color("BodyEmphasized"))
                    }
                }.listRowBackground(Color("SearchBar"))
            }.padding(.top, upper).scrollContentBackground(.hidden).foregroundColor(.blue).background(Color("BackgroundColor"))
            VStack {
                HStack {
                    HStack {
                        styledText(type: "Semibold", size: 20, content: sheetTitle)
                        Image(systemName: titleIcon)
                    }
                    Spacer()
                    Button(action: {
                        showingData.toggle()
                    }) {
                        styledText(type: "Semibold", size: 16, content: "Done").foregroundColor(.accentColor)
                    }
                }
                if(!description.isEmpty) {
                    HStack {
                        styledText(type: "Regular", size: 14, content: description)
                        Spacer()
                    }.padding(.top, 2)
                }
            }.padding(.top, 32).padding(.horizontal, 20).background(GeometryReader {
                geo in
                Color("BackgroundColor").onAppear {
                    upper = geo.size.height
                }
            })
            
        }
    }
    
    
    /*struct MenuItemSheet_Previews: PreviewProvider {
        static var previews: some View {
            MenuItemSheet(fields: ["Current password", "New password", "Confirm new password"], states: ["", "", ""])
        }
    }*/
}
