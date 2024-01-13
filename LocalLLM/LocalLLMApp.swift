//
//  LocalLLMApp.swift
//  LocalLLM
//
//  Created by Michael Jach on 04/01/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct LocalLLMApp: App {
  var body: some Scene {
    WindowGroup {
      HomeView(
        store: Store(initialState: HomeState()) {
          HomeReducer()
        }
      )
    }
  }
}
