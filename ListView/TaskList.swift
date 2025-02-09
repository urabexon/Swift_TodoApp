//
//  TaskList.swift
//  ListView
//
//  Created by 卜部大輝 on 2025/02/09.
//

import Foundation

struct ExampleTask {
    let taskList = [
        "掃除",
        "洗濯",
        "料理",
        "買い物",
        "読書",
        "運動"
    ]
}

//　エンコードとデコード可能なようにCodableに準拠
struct Task: Codable, Identifiable {
    var id = UUID() // ユニークIDを自動生成
    var taskItem: String
}
