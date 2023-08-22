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
                HStack(alignment: .top) {

                    VStack {
                        ForEach(universities, id: \.self) { university in
                            if ((universities.firstIndex(of: university)! + 1) % 2 != 0) {
                                Universitiy(universitydata: university, size: size, insets: Edge.Set.trailing, padding: size <= 400 ? 7 : 10).padding(.bottom, 20)
                            }
                        }
                    }
                    //Spacer()
                    VStack {
                        ForEach(universities, id: \.self) { university in
                            if ((universities.firstIndex(of: university)! + 1) % 2 == 0) {
                                Universitiy(universitydata: university, size: size, insets: Edge.Set.leading, padding: size <= 400 ? 7 : 10).padding(.bottom, 20)
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
