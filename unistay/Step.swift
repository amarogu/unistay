//
//  TestLaunchView.swift
//  unistay
//
//  Created by Gustavo Amaro on 24/08/23.
//

import SwiftUI

struct Step: View {
    @Binding var inputs: [[String]]
    var fields: [[String]]
    var icons: [[String]]
    @State var titleHeight: CGFloat = 0
    @State var subtitleHeight: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    @Binding var currentStep: Int
    var validate: () -> String
    @State var error: String
    var call: () -> Void
    var links: Bool
    var body: some View {
        GeometryReader {
            geo in
            let width = geo.size.width
            NavigationView {
                ZStack {
                    Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                    VStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Spacer()
                            styledText(type: "Bold", size: 22, content: "UniStay").background(GeometryReader {
                                geo in
                                Color.clear.onAppear {
                                    subtitleHeight = geo.size.height
                                }
                                
                            }).frame(height: 0).padding(.bottom, 4)
                            styledText(type: "Bold", size: 34, content: "Log In").background(GeometryReader {
                                geo in
                                Color.clear.onAppear {
                                    titleHeight = geo.size.height
                                }
                                
                            }).frame(height: titleHeight).padding(.bottom, 12)
                            let currentStepFields = fields[currentStep]
                            ForEach(currentStepFields, id: \.self) {
                                field in
                                Field(placeholder: styledText(type: "Regular", size: 13, content: field), text: $inputs[currentStep][currentStepFields.firstIndex(of: field)!], icon: icons[currentStep][currentStepFields.firstIndex(of: field)!])
                            }
                            Button(action: {
                                let validate = validate()
                                if validate.isEmpty && currentStep == 2 {
                                    call()
                                } else {
                                    error = validate
                                }
                            }) {
                                HStack(alignment: .center) {
                                    styledText(type: "Semibold", size: 14, content: "Continue").foregroundColor(Color("AccentColor"))
                                    Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                                }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1))//.cornerRadius(5)
                            }
                            if links {
                                NavigationLink(destination: ForgotYourPassword()) {
                                    HStack {
                                        styledText(type: "Regular", size: 14, content: "Forgot your password?").foregroundColor(Color("BodyEmphasized")).underline().padding(.vertical, 4)
                                    }
                                }
                                
                                NavigationLink(destination: SignUpView()) {
                                    HStack {
                                        styledText(type: "Regular", size: 14, content: "Create an account").foregroundColor(Color("BodyEmphasized")).underline().padding(.vertical, 4)
                                        Image(systemName: "person.badge.plus").foregroundColor(Color("BodyEmphasized"))
                                    }
                                }
                            }
                            if(!error.isEmpty) {
                                styledText(type: "regular", size: 13, content: error)
                            }
                            ForEach(inputs[0], id: \.self) {
                                user in
                                Text(user)
                            }
                            Spacer()
                            
                        }.frame(maxWidth: width * 0.8)
                    }.frame(maxWidth: .infinity)
                }
            }.tint(Color("BodyEmphasized"))
        }
        
        }

    }
