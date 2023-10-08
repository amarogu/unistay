//
//  ActiveAccommodation.swift
//  unistay
//
//  Created by Gustavo Amaro on 02/10/23.
//

import SwiftUI

struct ActiveAccommodation: View {
    @State private var currentPage: Int = 0
    @State private var listOfPages: [UIImage?] = []
    @State private var fakedPages: [UIImage?] = []
    var pub: AccommodationResponse?
    @State var images: [UIImage?]
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            ZStack(alignment: .top) {
                Color("BackgroundColor").ignoresSafeArea(.all)
                VStack(alignment: .leading) {
                    if let pubTitle = pub?.title {
                        Text(pubTitle).customStyle(type: "Semibold", size: 30)
                    }
                    VStack {
                        if !fakedPages.isEmpty {
                            TabView(selection: $currentPage) {
                                ForEach(fakedPages.indices, id: \.self) { index in
                                    Image(uiImage: fakedPages[index] ?? UIImage()).resizable().aspectRatio(contentMode: .fill).frame(width: size.width * 0.95, height: size.width * 0.75).scaleEffect(1.25).clipped().cornerRadius(5).tag(index)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .overlay(alignment: .bottom) {
                                PageControl(numberOfPages: listOfPages.count, currentPage: $currentPage)
                                    .offset(y: 0)
                            }
                        }
                    }.frame(maxHeight: size.width * 0.75)
                }
            }
        }
        .onAppear {
            guard fakedPages.isEmpty else { return }
            for image in images {
                listOfPages.append(image)
            }
            createCarousel(true)
        }
    }
    
    func createCarousel(_ setFirstPageAsCurrentPage: Bool = false) {
        fakedPages.removeAll()
        fakedPages.append(contentsOf: listOfPages)
    }
}
