//
//  UITableViewRepresentableView.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 14/05/2022.
//

import SwiftUI

struct UITableViewRepresentableView<Data, Row: View>: UIViewRepresentable {
    private let content: (Data) -> Row
        let data: [Data]
        let loadMore: () -> Void
        
        init(_ data: [Data], _ loadMore: @escaping () -> Void, _ content: @escaping (Data) -> Row) {
            self.data = data
            self.loadMore = loadMore
            self.content = content
        }
        
        func updateUIView(_ uiView: UITableView, context: Context) {
            context.coordinator.data = self.data // Add or append data
            uiView.reloadData()
        }
        
        func makeUIView(context: Context) -> UITableView {
            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.separatorStyle = .none
            tableView.rowHeight = UITableView.automaticDimension
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
            let loadMore: () -> Void

            init(_ data: [Data], _ loadMore: @escaping () -> Void, _ content: @escaping (Data) -> Row) {
                self.data = data
                self.loadMore = loadMore
                self.content = content
            }

            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return self.data.count
            }

            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HostingCell<Row> else {
                    return UITableViewCell()
                }
                let data = self.data[indexPath.row]
                let view = content(data)
                DispatchQueue.main.async {
                    if indexPath.row == self.data.count - 1 {
                        self.loadMore()
                    }
                }
                tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
                tableViewCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                tableViewCell.setup(with: view)
                return tableViewCell
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

struct UITableViewRepresentable_Previews: PreviewProvider {
    static let numbers = Array(0...100)
    static var previews: some View {
        UITableViewRepresentableView(numbers, loadMore) { number in
            HStack {
                Text("This is number \(number)")
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color("background")))
            .padding()
        }
    }
    
    static func loadMore() {
        
    }
}
