//
//  Accomodations.swift
//  unistay
//
//  Created by Gustavo Amaro on 08/08/23.
//

import SwiftUI

struct Accomodations: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image("Image").resizable().aspectRatio(contentMode: .fill).frame(width: 150, height: 150).scaleEffect(1.25).clipped().cornerRadius(20)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "location.circle.fill")
                    styledText(type: "Regular", size: 14, content: "New York City, NY")
                }
                HStack {
                    styledText(type: "Regular", size: 14, content: "USD 1.100")
                    styledText(type: "Regular", size: 13, content: "/month").opacity(0.7)
                }
                HStack {
                    Image(systemName: "star.fill").resizable().aspectRatio(contentMode: .fit).frame(width: 14)
                    styledText(type: "Regular", size: 14, content: "4.5")
                }

            }
        }.padding(.all, 16).background(Color("Gray")).cornerRadius(20)
    }
}

struct Accomodations_Previews: PreviewProvider {
    static var previews: some View {
        Accomodations()
    }
}
