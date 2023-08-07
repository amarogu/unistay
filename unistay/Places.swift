//
//  Places.swift
//  unistay
//
//  Created by Gustavo Amaro on 07/08/23.
//

import SwiftUI

struct Places: View {
    @State private var searchText = ""
    // @State private var searchText3 = "a"
    @State var text: String = ""
    @State private var selectedFilters: [String] = []
    var filterOptions = ["option", "option 1", "option 2", "option 3"]
    @State private var isMenuOpen = false
    var viewOptions = ["Recommended", "Saved", "Connected"]
    @State private var selectedView: String = "Recommended"
    
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                styledText(type: "Bold", size: 30, content: "Accommodations")
                Spacer()
                Menu {
                    //Button(action: {}, label: {Text("Button")})
                    ForEach(filterOptions, id: \.self) {
                        option in
                        Button(action: {
                            if(selectedFilters.contains(option)) {
                                selectedFilters.remove(at: selectedFilters.firstIndex(of: option) ?? -1)
                            } else {
                                selectedFilters.append(option)
                            }
                        }) {
                            Label(option, systemImage: selectedFilters.contains(option) ? "checkmark": "")
                        }
                    }
                    
                } label: {
                    Label(title: {Text("")}, icon: {Image(systemName: "line.3.horizontal.decrease").font(.system(size: 24)).foregroundColor(/*@START_MENU_TOKEN@*/Color("BodyEmphasized")/*@END_MENU_TOKEN@*/)})
                }
            }
            Spacer()
            /*SearchBar(searchText: $searchText).padding(.all, 10).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("SearchBar")/*@END_MENU_TOKEN@*/).cornerRadius(5)*/
            SearchBar(
                placeholder: Text("Search accommodations, locations...").foregroundColor(Color(UIColor(named: "BodyEmphasized")!)).font(.custom("Eina03-Regular", size: 13)),
                text: $text
            ).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
            Spacer()
            HStack() {
                ForEach(viewOptions, id: \.self) {
                    option in
                    Button(action: {
                        selectedView = option
                    }, label: {
                        styledText(type: "Semibold", size: 18, content: option).foregroundColor(selectedView == option ? Color("BodyEmphasized") : Color("BodyEmphasized").opacity(0.7))
                    })
                }
                Spacer()
            }.frame(maxWidth: .infinity)
        }
    }
    
    struct Places_Previews: PreviewProvider {
        static var previews: some View {
            Places()
        }
    }
}
