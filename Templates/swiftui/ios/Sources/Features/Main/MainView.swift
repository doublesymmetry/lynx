//
//  MainView.swift
//  Lynx
//
//  Created by David Chavez on 13.11.20.
//  Copyright © 2020 Double Symmetry UG. All rights reserved.
//

import SwiftUI
import shared

struct MainView: View {
    @ObservedObject var viewModelWrapper = MainViewModel.Wrapper()

    var body: some View {
        Text(viewModelWrapper.fact)
            .padding([.leading, .trailing])
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
