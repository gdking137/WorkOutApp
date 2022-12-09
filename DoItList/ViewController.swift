//
//  ViewController.swift
//  DoItList
//
//  Created by Songhee Yim on 12/8/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tasks = [Task](){
        didSet{
            self.saveTasks()
        }
    }
        
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks()
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
    
    
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title":$0.title,
                "done": $0.done
            ]
        }
        let userDefaults = UserDefaults.standard //singleton 한회 instance에만 존재함
        userDefaults.set(data, forKey: "tasks") // userDefaults에 "할일"들이 저장됨
    }
    
    func loadTasks(){
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else {return}
        self.tasks = data.compactMap{
            guard let title = $0["title"] as? String else{return nil}
            guard let done = $0["done"] as? Bool else {return nil}
            return Task(title:title, done: done)
        }
    }
    
    
    
    /*
    func loadTasks(){
        let userDefaults = UserDefaults.standard //userDefaults에 접근하는 방식
        guard let data = userDefaults.object(forKey: "tasks") as?[[String: Any]] else {return}
        self.tasks = data.compactMap{
            guard let title = $0["title"] as? String else{return nil}
            guard let done = $0["done"] as? String else {return nil}
            return Task(title: title, done: done)
        }
        //저장된 "할일을" 로드함
    }
     */
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)//셀을 재사용. 1000개면 5개만 보여주기
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        if task.done {
            cell.accessoryType = .checkmark
        } else{
            cell.accessoryType = .none
        }
        return cell
    }
}//UITableViewDataSource 쓸려면 이 꼭 두개의 메소드는 구현해야한다


extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
