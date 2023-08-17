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
    var size: CGFloat
    var tabSize: CGFloat
    @State private var selectionSize: CGFloat = 0
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
            }.padding(.bottom, 14).padding(.horizontal, size <= 400 ? 3 + 12 : 8 + 12)
            Spacer()
            /*SearchBar(searchText: $searchText).padding(.all, 10).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("SearchBar")/*@END_MENU_TOKEN@*/).cornerRadius(5)*/
            SearchBar(
                placeholder: Text("Search accommodations, locations...").foregroundColor(Color(UIColor(named: "BodyEmphasized")!)).font(.custom("Eina03-Regular", size: 13)),
                text: $text
            ).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.bottom, 14).padding(.horizontal, size <= 400 ? 3 + 12 : 8 + 12)
            Spacer()
            ZStack(alignment: .top) {
                
                if(selectedView == "Saved") {
                    //Accomodation()
                    AccomodationsGroup(size: size, tabSize: tabSize, selectionSize: selectionSize)
                } else if(selectedView == "Recommended") {
                    AccomodationsGroup(size: size, tabSize: tabSize, selectionSize: selectionSize)
                } else {
                    AccomodationsGroup(size: size, tabSize: tabSize, selectionSize: selectionSize)
                }
                
                Selection(selectedView: $selectedView).padding(.bottom, 44).background(GeometryReader {
                    geo in
                    LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").opacity(0)]), startPoint: .top, endPoint: .bottom).onAppear {
                        selectionSize = geo.size.height
                    }
                }).padding(.horizontal, size <= 400 ? 3 + 12 : 8 + 12)
                
            }
        }.frame(maxWidth: .infinity)
        }
    }
    
    /*struct Places_Previews: PreviewProvider {
        static var previews: some View {
            Places()
        }
    }*/

