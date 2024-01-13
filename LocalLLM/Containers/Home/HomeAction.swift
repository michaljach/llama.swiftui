//
//  HomeAction.swift
//  LocalLLM
//
//  Created by Michael Jach on 11/01/2024.
//

enum HomeAction {
  case onPromptChange(prompt: String)
  case submitPrompt
  case addResponse(response: String)
  case createContext
  case menuSelectionChanged(Int?)
}
