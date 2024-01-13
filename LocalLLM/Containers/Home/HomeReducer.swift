//
//  HomeReducer.swift
//  LocalLLM
//
//  Created by Michael Jach on 11/01/2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct HomeReducer {
  var body: some Reducer<HomeState, HomeAction> {
    Reduce { state, action in
      switch action {
      case .onPromptChange(let prompt):
        state.prompt = prompt
        return .none
        
      case .submitPrompt:
        state.responses.append("\n→ " + state.prompt + "\n\n")
        state.isLoading = true
        state.contexts = state.contexts.map { item in
          if item.id == state.menuSelection {
            return MenuItem(id: item.id, name: state.prompt)
          }
          return item
        }

        let prompt = state.prompt
        let llamaContext = state.llamaContext
        state.prompt = ""
        return .run { send in
          await withTaskGroup(of: Void.self) { group in
            group.addTask {
              await self.startStreaming(
                send: send,
                prompt: prompt,
                llamaContext: llamaContext
              )
            }
          }
        }
        
      case .addResponse(let response):
        state.isLoading = false
        state.responses.append(response)
        return .none
        
      case .createContext:
        do {
          let url = Bundle.main.url(forResource: "ggml-model-q4_0", withExtension: "bin")!
          state.llamaContext = try LlamaContext.create_context(path: url.path())
          let llamaContext = state.llamaContext
          return .none
        }
        catch {
          return .none
        }
        
      case .menuSelectionChanged(let selection):
        state.menuSelection = selection
        return .none
      }
    }
  }
  
  private func startStreaming(send: Send<Action>, prompt: String, llamaContext: LlamaContext?) async {
    do {
      if let llamaContext = llamaContext {
        await llamaContext.completion_init(text: prompt)
        
        while await llamaContext.n_cur < llamaContext.n_len {
          let result = await llamaContext.completion_loop()
          await send(.addResponse(response: result))
        }
      }
    } catch let error {
      print(error)
    }
  }
}
