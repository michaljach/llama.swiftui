//
//  HomeView.swift
//  LocalLLM
//
//  Created by Michael Jach on 11/01/2024.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
  let store: StoreOf<HomeReducer>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationSplitView {
        List(selection: viewStore.binding(
          get: \.menuSelection,
          send: { .menuSelectionChanged($0) }
        )) {
          ForEach(viewStore.contexts) { context in
            NavigationLink(value: context.id) {
              Text(context.name)
            }
          }
        }
      } detail: {
        VStack(spacing: 0) {
          ScrollView {
            HStack {
              Text(viewStore.responses.joined(separator: ""))
                .fontDesign(.monospaced)
                .fontWeight(.medium)
               
              Spacer()
            }
            .padding(24)
            
            if viewStore.isLoading {
              HStack {
                ProgressView()
                Spacer()
              }
              .padding(.horizontal, 24)
            }
          }
          
          TextField("what's on your mind ?", text: viewStore.binding(
            get: \.prompt,
            send: HomeAction.onPromptChange
          ))
          .disabled(viewStore.isLoading)
          .padding()
          .clipShape(RoundedRectangle(cornerRadius: 13))
          .overlay(
            RoundedRectangle(cornerRadius: 13)
              .stroke(Color("ColorBackground"), lineWidth: 2)
          )
          .padding(24)
          .submitLabel(.send)
          .onSubmit {
            viewStore.send(.submitPrompt)
          }
        }
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              
            } label: {
              Image("icon-add")
            }
          }
        }
        .onAppear {
          viewStore.send(.createContext)
        }
      }
    }
  }
}

#Preview {
  HomeView(
    store: Store(
      initialState: HomeState(
        isLoading: true,
        menuSelection: 0,
        responses: ["Hello"]
      )) {
        HomeReducer()
      }
  )
}
