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
    var body: some View {
        VStack(alignment: .center) {
            Image("University").resizable().aspectRatio(contentMode: .fill).frame(width: size * 0.35, height: size * 0.35).scaleEffect(1.25).clipped().cornerRadius(20)
            VStack(alignment: .leading) {
                HStack {
                    Text(universitydata.name).customStyle(size: 14)
                }
                HStack {
                    Image(systemName: "location.circle.fill")
                    Text(universitydata.location).customStyle(size: 14)
                }
                HStack {
                    Text("\(universitydata.amountOfAccommodations) accommodations").customStyle(size: 14)
                    
                }
            }
        }.frame(maxWidth: .infinity).padding(.all, 14).background(Color("Gray")).cornerRadius(20)
    }
}
