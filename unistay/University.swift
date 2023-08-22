//
//  Universities.swift
//  unistay
//
//  Created by Gustavo Amaro on 22/08/23.
//

import SwiftUI

struct Universitiy: View {
    var universitydata: UniversityData
    var size: CGFloat
    var padding: CGFloat
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image("Image").resizable().aspectRatio(contentMode: .fill).frame(width: size * 0.35, height: size * 0.35).scaleEffect(1.25).clipped().cornerRadius(20)
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Image(systemName: "location.circle.fill")
                    styledText(type: "Regular", size: 14, content: AccommodationData.location)
                }
                HStack {
                    styledText(type: "Regular", size: 14, content: "\(AccommodationData.currency) \(AccommodationData.rent)")
                    styledText(type: "Regular", size: 13, content: "/month").opacity(0.7)
                }
                HStack {
                    Image(systemName: "star.fill").resizable().aspectRatio(contentMode: .fit).frame(width: 14)
                    styledText(type: "Regular", size: 14, content: "\(AccommodationData.rating)")
                }

            }
        }.padding(.all, 16).background(Color("Gray")).cornerRadius(20).padding(.all, padding)
    }
}

/*struct Universities_Previews: PreviewProvider {
    static var previews: some View {
        Universities()
    }
}*/
