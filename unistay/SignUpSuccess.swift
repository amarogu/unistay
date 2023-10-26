//
//  SignUpSuccess.swift
//  unistay
//
//  Created by Gustavo Amaro on 27/09/23.
//

import SwiftUI

struct SignUpSuccess: View {
    @State var show: Bool = false
    @State var present: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
                ZStack {
                    Color("BackgroundColor")
                    VStack(spacing: 10) {
                        Text("Successfully registered")
                            .customStyle(type: "Semibold", size: 24)
                            .frame(width: 0.85 * width)
                            .multilineTextAlignment(.center)
                        Text("Want an advanced configuration? Click here to control exactly how you want UniStay to behave")
                            .customStyle(size: 14)
                            .multilineTextAlignment(.center)
                            .frame(width: 0.8 * width)
                        
                        
                            HStack {
                                Text("Swipe down to go back to login")
                                    .customStyle(size: 14, color: "Body")
                                    .underline()
                                Image(systemName: "chevron.down").foregroundColor(Color("Body")).font(.system(size: 14))
                            }
                        Image(systemName: "checkmark.circle").font(.system(size: 24)).foregroundColor(.green).padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(self.show ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.5)) {
                            self.show = true
                        }
                    }
                }.ignoresSafeArea(.all).navigationBarBackButtonHidden(true)
        }
    }
}
