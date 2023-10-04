//
//  Accomodations.swift
//  unistay
//
//  Created by Gustavo Amaro on 08/08/23.
//

import SwiftUI

struct Accomodation: View {
    var pub: AccommodationResponse?
    var size: CGFloat
    var padding: CGFloat
    var body: some View {
        NavigationLink(destination: ActiveAccommodation(), label: {
            VStack(alignment: .center, spacing: 20) {
                Image("Image").resizable().aspectRatio(contentMode: .fill).frame(width: size * 0.35, height: size * 0.35).scaleEffect(1.25).clipped().cornerRadius(20)
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        Image(systemName: "location.circle.fill")
                        
                        Text(pub?.title ?? "").customStyle(size: 14)
                    }
                    HStack {
                        
                        Text("\(pub?.currency ?? "") \(pub?.rent ?? 0)").customStyle(size: 14)
                        Text("/month").customStyle(size: 13).opacity(0.7)
                    }
                    HStack {
                        Image(systemName: "star.fill").resizable().aspectRatio(contentMode: .fit).frame(width: 14)
                        
                        Text(String(format: "%.1f", 5)).customStyle(size: 14)
                    }

                }
            }.padding(.all, 16).background(Color("Gray")).cornerRadius(20).padding(.vertical, 6)
        })
    }
}

