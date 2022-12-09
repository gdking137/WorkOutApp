//
//  ViewController.swift
//  DoItList
//
//  Created by Songhee Yim on 12/8/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem? //optional?
    
    var tasks = [Task](){
        didSet{
            self.saveTasks()
        }
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        //self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self , action: #selector(doneButtonTap())
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks()
        // Do any additional setup after loading the view.
    }

    //selector type으로 전달할 method는 @objc
    //object c 호환성
    @objc func doneButtonTap(){
        self.navigationItem.leftBarButtonItem = self.editButton         //edit button이 원래대로 돌아오게함
        self.tableView.setEditing(false, animated: true)                //뷰가 에딧모드에서 나오게하기
    }
    
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else {return}
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
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
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)   //삭제되는 셀이 어떤건지 알려주는 method
        tableView.deleteRows(at: <#T##[IndexPath]#>, with: .automatic) //셀이 테이블 뷰에서 삭제된다
        if self.tasks.isEmpty{      //모든 셀이 삭제되면
            self.doneButtonTap()    //편집 모드를 빠져나온다
        }
    */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if self.tasks.isEmpty {
            self.doneButtonTap()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { //원래 있던곳
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {         //어디로 이동했는지 알려줌
        var tasks = self.tasks//배열을 재정렬
        let task = tasks[sourceIndexPath.row]
        task.remove(at.sourceIndexPath.row)
        tasks.insert(task, at:destinationIndexPath.row)//이동할위치를 넘겨준다
        self.tasks = tasks //할일 배열도 재정렬
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
