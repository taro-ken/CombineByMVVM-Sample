//
//  ViewModel.swift
//  CombineByMVVM-Sample
//
//  Created by 木元健太郎 on 2022/08/27.
//

import Foundation
import Combine

protocol ViewModelInput {
    func addTodo(text: String?)
}

protocol ViewModelOutput {
    var todoModel: [TodoModel] { get }
    var completionSubject: PassthroughSubject<Void,Never> { get }
    var errorSubject: PassthroughSubject<Void,Never> { get }
}

protocol ViewModelType {
  var input: ViewModelInput { get }
  var output: ViewModelOutput { get }
}

final class ViewModel: ViewModelInput, ViewModelOutput, ViewModelType {
    
    var input: ViewModelInput { return self }
    var output: ViewModelOutput { return self }
    
    // Input
    func addTodo(text: String?) {
        if text == "" {
            errorSubject.send(())
            return
        }
        let todo = TodoModel(title: text)
        todoModel.append(todo)
        completionSubject.send(())
    }
    
    
    
    // OutPut
    var todoModel: [TodoModel] = []
    
    var completionSubject = PassthroughSubject<Void, Never>()
    var errorSubject = PassthroughSubject<Void, Never>()
    
}
