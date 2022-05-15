//
//  TableViewRepresentableView.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 15/05/2022.
//

import SwiftUI

struct TableViewRepresentableView<Data, Row: View>: UIViewRepresentable {
    private let content: (Data) -> Row
        let data: [Data]
        let loadMore: (() -> Void)?
        
        init(_ data: [Data], _ loadMore: (() -> Void)? = nil, _ content: @escaping (Data) -> Row) {
            self.data = data
            self.loadMore = loadMore
            self.content = content
        }
        
        func updateUIView(_ uiView: UITableView, context: Context) {
            context.coordinator.data.append(contentsOf: self.data) // Add or append data
            uiView.reloadData()
        }
        
        func makeUIView(context: Context) -> UITableView {
            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.estimatedRowHeight = 10
            tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorStyle = .none
            tableView.delegate = context.coordinator
            tableView.dataSource = context.coordinator
            tableView.register(HostingCell<Row>.self, forCellReuseIdentifier: "Cell")
            return tableView
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(data, loadMore, content)
        }
        
        class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {

            let content: (Data) -> Row
            var data: [Data]
            let loadMore: (() -> Void)?

            init(_ data: [Data], _ loadMore: (() -> Void)? = nil, _ content: @escaping (Data) -> Row) {
                self.data = data
                self.loadMore = loadMore
                self.content = content
            }

            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return self.data.count
            }

            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HostingCell<Row> else {
                    let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
                    return cell
                }
                let data = self.data[indexPath.row]
                let view = content(data)
                DispatchQueue.global(qos: .background).async {
                    if indexPath.row == self.data.count - 1 {
                        self.loadMore?()
                    }
                }
                tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
                tableViewCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                tableViewCell.setup(with: view)
                return tableViewCell
            }
            
            func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                if indexPath.row == 0 {
                    return 80
                } else {
                    return UITableView.automaticDimension
                }
            }
        }
        
        private class HostingCell<Content: View>: UITableViewCell {
            var host: UIHostingController<Content>?
            
            func setup(with view: Content) {
                if host == nil {
                    let controller = UIHostingController(rootView: view)
                    host = controller

                    guard let content = controller.view else { return }
                    content.translatesAutoresizingMaskIntoConstraints = false
                    contentView.addSubview(content)
                    content.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
                    content.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
                    content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
                    content.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
                } else {
                    host?.rootView = view
                }
                setNeedsLayout()
            }
        }
}

class IntModel: Codable {
    init(number: Int = 0) {
        self.number = number
    }
    var id = UUID()
    var number: Int = 0
}

struct DemoTableViewRepresentableView: View {
    @State var numbers: [IntModel] = [
        IntModel(number: 1),
        IntModel(number: 2),
        IntModel(number: 3),
        IntModel(number: 4),
        IntModel(number: 5),
        IntModel(number: 6),
        IntModel(number: 7),
        IntModel(number: 8),
        IntModel(number: 9),
        IntModel(number: 10)
    ]
    
    var body: some View {
        TableViewRepresentableView(numbers, loadMore) { number in
            HStack {
                Text("This is number \(number.number)")
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.gray))
            .padding()
        }
        .overlay(
            Button(action: {
                let dataNumbers: [IntModel] =
                [
                    IntModel(number: 1),
                    IntModel(number: 2),
                    IntModel(number: 3),
                    IntModel(number: 4),
                    IntModel(number: 5),
                    IntModel(number: 6),
                    IntModel(number: 7),
                    IntModel(number: 8),
                    IntModel(number: 9),
                    IntModel(number: 10)
                ]
                self.numbers = dataNumbers
            }) {
                Text("Delete")
                    .foregroundColor(Color.blue)
                    .padding(.bottom, 65)
                    .padding(.trailing, 20)
            }, alignment: .bottomTrailing
        )
        .navigationBarHidden(true)
    }
    
    func loadMore() {
        let dataNumbers: [IntModel] =
        [
            IntModel(number: 1),
            IntModel(number: 2),
            IntModel(number: 3),
            IntModel(number: 4),
            IntModel(number: 5),
            IntModel(number: 6),
            IntModel(number: 7),
            IntModel(number: 8),
            IntModel(number: 9),
            IntModel(number: 10)
        ]
        self.numbers.append(contentsOf: dataNumbers)
    }
}

struct TableViewRepresentableView_Previews: PreviewProvider {
    
    static var previews: some View {
        DemoTableViewRepresentableView()
    }
    
}
