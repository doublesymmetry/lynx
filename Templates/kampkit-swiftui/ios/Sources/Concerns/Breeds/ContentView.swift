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

class NativeViewModelWrapper: ObservableObject {
    @Published var data: [Breed] = []
    @Published var errorMessage: String?

    lazy var log = KoinIOS().get(objCClass: Kermit.self, parameter: "ViewController") as! Kermit

    lazy var adapter: NativeViewModel = NativeViewModel(
        viewUpdate: { [weak self] summary in
            self?.log.d(withMessage: {"View updating with \(summary.allItems.count) breeds"})
            self?.data = summary.allItems
        }, errorUpdate: { [weak self] error in
            self?.log.d(withMessage: {"Displaying error \(error)"})
            self?.errorMessage = error
        }
    )
}

struct ContentView: View {
    @ObservedObject var viewModel = NativeViewModelWrapper()

    var body: some View {
        let showAlert = Binding<Bool>(
            get: { self.viewModel.errorMessage != nil },
            set: { _ in self.viewModel.errorMessage = nil }
        )

        return List(viewModel.data) { breed in
            Text(breed.name)
            Spacer()
            Image(systemName: breed.favorite == 0 ? "heart" : "heart.fill")
                .onTapGesture {
                    viewModel.adapter.updateBreedFavorite(breed: breed)
                }
        }.alert(isPresented: showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage!), dismissButton: .default(Text("Dismiss")))
        }.onAppear {
            viewModel.adapter.getBreedsFromNetwork()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
