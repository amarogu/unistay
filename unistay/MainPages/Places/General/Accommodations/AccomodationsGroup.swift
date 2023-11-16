//
//  AccomodationsGroup.swift
//  unistay
//
//  Created by Gustavo Amaro on 09/08/23.
//

import SwiftUI
import MapKit

struct AccomodationsGroup: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var size: CGFloat
    var tabSize: CGFloat
    var selectionSize: CGFloat
    @Binding var pub: [AccommodationResponse?]
    @Binding var searchText: String
    @Binding var pickedLocCoordinates: [CLLocationDegrees?]
    @GestureState var isPressed = false
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack(alignment: .top) {
                    if pub.isEmpty {
                        Text("No accommodations found with the selected filters.").customStyle(size: 14).padding(.top, 30)
                        Spacer()
                    } else {
                        VStack {
                            ForEach(pub, id: \.self) { pubItem in
                                if ((pub.firstIndex(of: pubItem)! + 1) % 2 != 0) {
                                    Button(action: {
                                        
                                    }) {
                                        Accomodation(pub: pubItem, size: size, padding: size <= 400 ? 3 : 8)
                                    }.scaleEffect(isPressed ? 0.8 : 1).animation(.easeInOut, value: isPressed).simultaneousGesture(LongPressGesture().updating($isPressed) {
                                        currentState, gestureState, transaction in
                                        gestureState = currentState
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    })
                                }
                            }
                        }
                        Spacer()
                        VStack {
                            ForEach(pub, id: \.self) { pubItem in
                                if ((pub.firstIndex(of: pubItem)! + 1) % 2 == 0) {
                                    Button(action: {
                                        
                                    }) {
                                        Accomodation(pub: pubItem, size: size, padding: size <= 400 ? 3 : 8)
                                    }.scaleEffect(isPressed ? 0.8 : 1).animation(.easeInOut, value: isPressed).simultaneousGesture(LongPressGesture().updating($isPressed) {
                                        currentState, gestureState, transaction in
                                        gestureState = currentState
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    })
                                }
                            }
                        }.padding(.top, 30)
                    }
                }.padding(.bottom, tabSize).padding(.top, selectionSize - 30)
            }
        }.tint(Color("BodyEmphasized"))
    }
}
