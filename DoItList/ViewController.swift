//
//  ViewController.swift
//  DoItList
//
//  Created by Songhee Yim on 12/8/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tasks = [Task]()
    
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "things to do", message: nil, preferredStyle: .alert)
        let registerButton = UIAlertAction(title: "register", style: .default, handler: { [weak self ]_ in
            
            guard let title = alert.textFields?[0].text else { return }
            let task = Task(title: title, done: false)
            self?.tasks.append(task) //할일이 추가됨
            self?.tableView.reloadData()
            //debugPrint("\(alert.textFields?[0].text)")
            
        })
        let cancelButton = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "insert things to do"
        })
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)//셀을 재사용. 1000개면 5개만 보여주기
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
}//UITableViewDataSource 쓸려면 이 꼭 두개의 메소드는 구현해야한다
