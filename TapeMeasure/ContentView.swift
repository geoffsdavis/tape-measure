//
//  ContentView.swift
//  TapeMeasure
//
//  Created by Geoff Davis on 7/14/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        StageContainerView()
            .background(Color.black)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StageContainerView()
    }
}
