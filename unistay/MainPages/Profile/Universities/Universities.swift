//
//  Universities.swift
//  unistay
//
//  Created by Gustavo Amaro on 22/08/23.
//

import SwiftUI

struct UniversityData: Hashable {
    var id: UUID = UUID()
    var name: String
    var location: String
    var amountOfAccommodations: Int
}

struct Universities: View {
    var universities: [UniversityData] = [
        .init(name: "Stanford University", location: "Stanford, California", amountOfAccommodations: 16), .init(name: "Stanford University", location: "Stanford, California", amountOfAccommodations: 16), .init(name: "Stanford University", location: "Stanford, California", amountOfAccommodations: 16)]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var size: CGFloat
    //var tabSize: CGFloat
    var selectionSize: CGFloat
    var body: some View {
        
            ScrollView {
                HStack(alignment: .top, spacing: 8) {

                    VStack(spacing: 20) {
                        ForEach(universities, id: \.self) { university in
                            if ((universities.firstIndex(of: university)! + 1) % 2 != 0) {
                                Universitiy(universitydata: university, size: size)
                            }
                        }
                    }
                    Spacer()
                    VStack(spacing: 20) {
                        ForEach(universities, id: \.self) { university in
                            if ((universities.firstIndex(of: university)! + 1) % 2 == 0) {
                                Universitiy(universitydata: university, size: size)
                            }
                        }
                    }.padding(.top, 30)
                    
                }//.padding(.top, 20)
            }
        }
}

/*struct Universities_Previews: PreviewProvider {
    static var previews: some View {
        Universities()
    }
}*/
