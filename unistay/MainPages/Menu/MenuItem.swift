//
//  MenuItem.swift
//  unistay
//
//  Created by Gustavo Amaro on 18/08/23.
//

import SwiftUI

/*extension View {
    func customFullScreen<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(FullScreenModifier(isPresented: isPresented, content: content))
    }
}

struct FullScreenModifier<V: View>: ViewModifier {
    @Binding var isPresented: Bool
    let content: () -> V

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                self.content()
                    .edgesIgnoringSafeArea(.all)
                    .transition(.move(edge: .bottom))
                    .onTapGesture { self.isPresented = false }
            }
        }
    }
}*/

/*struct FullScreenModal: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("dismiss") {
                     
                        dismiss()
                    
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("BackgroundColor"))
    }
}*/

/*struct MenuSheetItem: View {
    var body: some View {
        VStack {
            styledText(type: "regular", size: 16, content: "Done").foregroundColor(Color("BodyEmphasized"))
        }
    }
}*/

struct MenuItem: View {
    @Environment(\.dismiss) var dismiss
    @Binding var menuItemData: MenuItemData
    @State private var showingData: Bool = false
    var itemFields: [Any] = []
    @Binding var isLoggedIn: Bool
    @State var backToLogin: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor")
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        styledText(type: "Regular", size: 16, content: menuItemData.title)
                        Image(systemName: menuItemData.titleIcon)
                    }.padding(.bottom, 10)
                    HStack(alignment: .center) {
                        if (menuItemData.options.count == 1 && !menuItemData.singleAction) {
                            //menuItemData.
                            Button(action: {
                                showingData.toggle()
                            }) {
                                styledText(type: "Regular", size: 16, content: menuItemData.options[menuItemData.selectedItem]).foregroundColor(Color("Body")).underline()
                                Image(systemName: menuItemData.descIcon).foregroundColor(Color("Body"))
                            }.sheet(isPresented: $showingData) {
                                MenuItemSheet(showingData: $showingData, titleIcon: menuItemData.descIcon, sheetTitle: menuItemData.sheetTitle ?? "", description: menuItemData.sheetDescription ?? "", action: menuItemData.action ?? "", fields: menuItemData.sheetFields ?? [], states: menuItemData.sheetStates ?? [])
                            }.presentationBackground(Color("BackgroundColorLighter"))
                        } else if !menuItemData.singleAction {
                            Menu {
                                ForEach(menuItemData.options, id: \.self) {
                                    option in
                                    Button(action: {
                                        menuItemData.selectedItem = menuItemData.options.firstIndex(of: option)!
                                    }) {
                                        Label(option, systemImage: menuItemData.selectedItem == menuItemData.options.firstIndex(of: option)! ? "checkmark" : "")
                                    }
                                }
                            } label: {
                                styledText(type: "Regular", size: 16, content: menuItemData.options[menuItemData.selectedItem]).foregroundColor(Color("Body")).underline()
                                Image(systemName: menuItemData.descIcon).foregroundColor(Color("Body"))
                            }
                        } else {
                            Button(action: {
                                SessionManager.shared.isLoggedIn = false
                                self.isLoggedIn = false
                                backToLogin = true
                            }) {
                                styledText(type: "Regular", size: 16, content: menuItemData.options[0]).foregroundColor(Color("Body")).underline()
                            }
                        }
                        Spacer()
                        NavigationLink(destination: Login(isLoggedIn: $isLoggedIn), isActive: $backToLogin) {
                            EmptyView()
                        }
                    }.frame(maxWidth: .infinity)
                }.padding(.bottom, 45)
            }
        }
    }
}


/*struct MenuItem_Previews: PreviewProvider {
    static var previews: some View {
        MenuItem()
    }
}*/
