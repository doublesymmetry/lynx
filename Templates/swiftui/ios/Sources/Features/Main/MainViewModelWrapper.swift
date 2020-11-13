//
//  MainViewModelWrapper.swift
//  Lynx
//
//  Created by David Chavez on 13.11.20.
//  Copyright © 2020 Double Symmetry UG. All rights reserved.
//

import shared

extension MainViewModel {
    class Wrapper: ObservableObject {
        lazy var viewModel = MainViewModel()
        private let log = KoinIOS().logger(tag: "MainViewModelWrapper")

        @Published var fact: String = ""

        init() {
            log.i { "Initialized" }
            viewModel.fact.addObserver { [weak self] fact in
                self?.fact = fact as String? ?? ""
            }

            viewModel.fetchFact()
        }
    }
}
