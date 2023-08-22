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
    @State var insets: Edge.Set
    var padding: CGFloat
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image("University").resizable().aspectRatio(contentMode: .fill).frame(width: size * 0.35, height: size * 0.35).scaleEffect(1.25).clipped().cornerRadius(20)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    //Image(systemName: "location.circle.fill")
                    styledText(type: "Regular", size: 14, content: universitydata.name)
                }
                HStack {
                    Image(systemName: "location.circle.fill")
                    styledText(type: "Regular", size: 14, content: universitydata.location)
                }
                HStack {
                    styledText(type: "Regular", size: 14, content: "\(universitydata.amountOfAccommodations) accommodations")
                    
                }
                /*HStack {
                    styledText(type: "Regular", size: 14, content: "Click here to see the uni's profile")
                }*/

            }
        }.padding(.all, 14).background(Color("Gray")).cornerRadius(20).padding(insets, padding)
    }
}

/*struct Universities_Previews: PreviewProvider {
    static var previews: some View {
        Universities()
    }
}*/
