//
//  ViewController.swift
//  CombineByMVVM-Sample
//
//  Created by 木元健太郎 on 2022/08/27.
//

import UIKit
import Combine

final class ViewController: UIViewController {
    
    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    private let cell = "Cell"
    private let viewModel: ViewModelType = ViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet weak var todoTableView: UITableView! {
        didSet {
            todoTableView.delegate = self
            todoTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
        bindOutput()
    }
    
    @objc private func tappedAddButton() {
        viewModel.input.addTodo(text: todoTextField.text)
        todoTextField.text = ""
    }
    
    
    private func bindOutput() {
        viewModel.output.completionSubject.sink {  [weak self] completion in
            self?.todoTableView.reloadData()
        }.store(in: &subscriptions)
        
        viewModel.output.errorSubject.sink { [weak self] error in
            let alert = UIAlertController(title: "エラー", message: .none, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            self?.present(alert, animated: true)
        }.store(in: &subscriptions)
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.output.todoModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath)
        cell.textLabel?.text = viewModel.output.todoModel[indexPath.row].title
        return cell
    }
}
