//
//  ContentView.swift
//  KaMPKit-SwiftUI
//
//  Created by David Chavez on 01.10.20.
//  Copyright © 2020 Double Symmetry UG. All rights reserved.
//

import SwiftUI
import shared

extension Breed: Identifiable {}

class ViewModelWrapper: ObservableObject {
    @Published var data: [Breed] = []
    @Published var errorMessage: String?

    lazy var log = KoinIOS().get(objCClass: Kermit.self, parameter: "ContentView") as! Kermit

    lazy var viewModel = BreedViewModel(
        onSummaryUpdate: { [weak self] summary in
            self?.log.d(withMessage: {"View updating with \(summary.allItems.count) breeds"})
            self?.data = summary.allItems
        },
        onErrorUpdate: { [weak self] error in
            self?.log.d(withMessage: {"Displaying error \(error)"})
            self?.errorMessage = error
        }
    )
}

struct ContentView: View {
    @ObservedObject var viewModelWrapper = ViewModelWrapper()

    var body: some View {
        let showAlert = Binding<Bool>(
            get: { self.viewModelWrapper.errorMessage != nil },
            set: { _ in self.viewModelWrapper.errorMessage = nil }
        )

        return List(viewModelWrapper.data) { breed in
            Text(breed.name)
            Spacer()
            Image(systemName: breed.favorite == 0 ? "heart" : "heart.fill")
                .onTapGesture {
                    viewModelWrapper.viewModel.updateBreedFavorite(breed: breed)
                }
        }.alert(isPresented: showAlert) {
            Alert(title: Text("Error"), message: Text(viewModelWrapper.errorMessage!), dismissButton: .default(Text("Dismiss")))
        }.onAppear {
            viewModelWrapper.viewModel.fetchBreeds()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
