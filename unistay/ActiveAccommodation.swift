//
//  ActiveAccommodation.swift
//  unistay
//
//  Created by Gustavo Amaro on 02/10/23.
//

import SwiftUI

struct ActiveAccommodation: View {
    @State private var currentPage: Int = 0
    @State private var listOfPages: [AccommodationImage] = []
    @State private var fakedPages: [AccommodationImage] = []

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            if !fakedPages.isEmpty {
                TabView(selection: $currentPage) {
                    ForEach(fakedPages.indices, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(fakedPages[index].color.gradient)
                            .frame(width: 300, height: size.height)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .overlay(alignment: .bottom) {
                    PageControl(numberOfPages: listOfPages.count, currentPage: $currentPage)
                        .offset(y: -15)
                }
            }
        }
        .frame(height: 400)
        .onAppear {
            guard fakedPages.isEmpty else { return }
            for color in [Color.red, Color.blue, Color.yellow, Color.primary, Color.brown] {
                listOfPages.append(.init(color: color))
            }
            createCarousel(true)
        }
    }
    
    func createCarousel(_ setFirstPageAsCurrentPage: Bool = false) {
        fakedPages.removeAll()
        fakedPages.append(contentsOf: listOfPages)
    }
}


#Preview {
    ActiveAccommodation()
}
