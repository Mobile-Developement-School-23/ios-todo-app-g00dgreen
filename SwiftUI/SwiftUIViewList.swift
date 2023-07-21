//
//  SwiftUIViewList.swift
//  ToDoList
//
//  Created by Артем Макар on 22.07.23.
//

import SwiftUI

struct ContentView: View {
   @State var items: [ToDoForSwiftUI] = [
           ToDoForSwiftUI(
               text: """
               1
               2
               3
               4
               """,
               importance: .unimportant,
               deadline: Date(),
               isDone: false
           ),
           ToDoForSwiftUI(
            text: """
            1
            2
            """,
               importance: .common,
               deadline: nil,
               isDone: true
           ),
           ToDoForSwiftUI(
               text: "кукарача",
               importance: .important,
               deadline: Date(),
               isDone: false
           )
       ]

    var body: some View {
            NavigationView {
                ZStack {
                    TasksListView(items: $items)
                        .navigationTitle("Мои дела")
                        .navigationBarTitleDisplayMode(.large)
                    NewTaskButton()
                }
            }
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

    struct NewTaskButton: View {
        var body: some View {
            VStack {
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color(UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)))
                    .frame(width: 44, height: 44)
            }
        }
    }

struct TasksListView: View {
    @Binding var items: [ToDoForSwiftUI]

    var body: some View {
        List {
            let headerInfoCell = HeaderView(doneTasks: getDoneTasksCount())
            Section(header: headerInfoCell) {
                ForEach($items) { $item in
                    TaskCell(item: $item, done: item.isDone)
                        .onChange(of: item) { newValue in
                            updateElement(newValue)
                        }
                }
                NewTaskCell()
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1)))
        .listStyle(.insetGrouped)
    }

    func getDoneTasksCount() -> Int {
        items.filter { $0.isDone == true }.count
    }

    private func updateElement(_ item: ToDoForSwiftUI) {
        items.removeAll(where: { $0.id == item.id })
        items.append(item)
    }
}
struct NewTaskCell: View {
    var body: some View {
        HStack {
            Text("Новое")
                .foregroundColor(Color(.gray))
        }
        .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 10))
    }
}

struct NewTaskCell_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskCell()
    }
}

struct TaskCell: View {
    @Binding var item: ToDoForSwiftUI
    @State var done: Bool

    var body: some View {
        HStack {
            DoneImageView(done: $done, importance: item.importance)
                .onChange(of: done) { newValue in
                    let newItem = ToDoForSwiftUI(id: item.id,
                                           text: item.text,
                                           importance: item.importance,
                                           deadline: item.deadline,
                                           isDone: newValue,
                                           creationDate: item.creationDate,
                                           changeDate: item.modificationDate)
                    item = newItem
                }
            VStack(alignment: .leading) {
                ItemView(importance: item.importance, text: item.text, isDone: item.isDone)
                if item.deadline != nil {
                    Label("\(deadLineConfig())", systemImage: "calendar")
                        .foregroundColor(Color(.gray))
                        .labelStyle(.titleAndIcon)
                }
            }
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundColor(Color(.gray))
        }
    }
    func deadLineConfig() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_US_POSIX")
        dateFormatter.dateFormat = "dd MMMM"
        let result = dateFormatter.string(from: item.deadline!)
        return result
    }
}

struct DoneImageView: View {
    @Binding var done: Bool
    var importance: ImportanceForSwiftUI = .common

    var body: some View {
        Image(getImage())
    }

    private func getImage() -> String {
        if done {
            return "done"
        } else {
            if importance == .important {
                return "importance"
            } else {
                return "none"
            }
        }
    }
}

struct ItemView: View {
    let importance: ImportanceForSwiftUI
    let text: String
    let isDone: Bool

    var body: some View {
        switch importance {
        case .unimportant:
            Text(text)
                .foregroundColor(Color(.black))
                .lineLimit(3)
                .strikethrough(isDone, pattern: .dash, color: .black)
        case .common:
            Text(text)
                .strikethrough(isDone, pattern: .dash, color: .black)
                .foregroundColor(Color(.black))
                .lineLimit(3)
        case .important:
            Label(text, image: "image1")
                .foregroundColor(Color(.black))
                .labelStyle(.titleAndIcon)
                .lineLimit(3)
                .strikethrough(isDone, pattern: .dash, color: .black)
        }
    }
}
struct HeaderView: View {
    var doneTasks = 0

    var body: some View {
        HStack {
            Text("Выполнено — \(doneTasks)")
                .foregroundColor(Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)))
            Spacer()
            Button("Показать") {
                print("заглушка")
            }
            .fontWeight(.regular)
        }
        .padding(.bottom, 8)
        .textCase(.none)
    }
}
