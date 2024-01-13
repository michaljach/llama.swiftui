//
//  HomeState.swift
//  LocalLLM
//
//  Created by Michael Jach on 11/01/2024.
//

import ComposableArchitecture

struct HomeState: Equatable {
  var isLoading = false
  var menuSelection: MenuItem.ID? = 0
  var contexts: [MenuItem] = [MenuItem(id: 0, name: "Empty context")]
  var llamaContext: LlamaContext?
  var prompt: String = ""
  var responses: [String] = []
}
