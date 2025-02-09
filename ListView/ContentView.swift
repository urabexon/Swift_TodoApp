//
//  ContentView.swift
//  ListView
//
//  Created by Hiroki Urabe on 2025/02/09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FirstView()
    }
}

struct FirstView: View {
    // "TasksData"というキーでUserDefaultsに保存されたものを監視
    @AppStorage("TasksData") private var tasksData: Data = Data()
    // タスクを入れておくための配列
    @State var tasksArray: [Task] = []
    // 画面生成時にtasksDataをデコードした値をtasksArrayに入れる
    init() {
        if let decodedTasks = try? JSONDecoder().decode([Task].self, from: tasksData) {
            _tasksArray =  State(initialValue: decodedTasks)
             print(tasksArray)
        }
    }
    
    var body: some View {
        NavigationStack {
            // "Add New Task"の文字をタップするとSecondViewへ遷移するようにリンクを設定
            NavigationLink(destination: SecondView(tasksArray: $tasksArray).navigationTitle("Add Task")) {
                Text("Add New Task")
                    .font(.system(size: 20, weight: .bold))
                    .padding()
            }
            List {
                // tasksArrayの中身をリストに表示
                ForEach(tasksArray) { task in
                    Text(task.taskItem)
                }
                // リストの並び替え時の処理を設定
                .onMove(perform: { from, to in
                    replaceRow(from, to)
                })
            }
            // ナビゲーションバーに編集ボタンを追加
            .toolbar(content: {
                EditButton()
            })
            .navigationTitle("Task List")
        }
        .padding()
    }
    // 並び替え処理と並び替え後の保存
    func replaceRow(_ from: IndexSet, _ to: Int) {
        tasksArray.move(fromOffsets: from, toOffset: to) // 配列内での並び替え
        if let encodedArray = try? JSONEncoder().encode(tasksArray) {
            tasksData = encodedArray // エンコードできたらAppStorageに渡す(保存・更新)
        }
    }
}
                     
// タスク追加画面用の構造体
struct SecondView: View {
    // 前の画面に戻るための変数dismissを定義
    @Environment(\.dismiss) private var dismiss
    // テキストフィールドに入力された文字を格納する変数
    @State private var task: String = ""
    // タスクの配列
    @Binding var tasksArray: [Task]
    var body: some View {
        TextField("Enter your task", text: $task)
            .textFieldStyle(.roundedBorder)
            .padding()
        
        Button {
            // ボタンを押した時の処理
            addTask(newTask: task) // 入力されたタスクの保存
            task = ""              // テキストフィールドを初期化
            print(tasksArray)      // tasksArrayの中身をコンソールに出力
        } label: {
            Text("Add")
        }
        .buttonStyle(.borderedProminent)
        .tint(.orange)
        .padding()
        Spacer() // スペースを埋める
    }
    
    // タスクの追加
    func addTask(newTask: String) {
        // テキストフィールドに入力された値が空白じゃない
        if !newTask.isEmpty {
            // Taskをつくって一時的な配列arrayに追加
            let task = Task(taskItem: newTask)
            var array = tasksArray
            array.append(task)
            
            // エンコードがうまくいったらUserDefaultsに保存する
            if let encodedData = try? JSONEncoder().encode(array) {
                UserDefaults.standard.setValue(encodedData, forKey: "TasksData")
                tasksArray = array
                dismiss() // 前の画面に戻る
            }
        }
    }
}


#Preview {
    ContentView()
}

// SecondViewをプレビューするための記述
#Preview("Second View") {
    SecondView(tasksArray: FirstView().$tasksArray)
}
