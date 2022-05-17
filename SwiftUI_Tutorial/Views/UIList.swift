//
//  UIList.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 15/05/2022.
//

import SwiftUI

struct UIList: UIViewRepresentable {

    var rows: [String]

    func makeUIView(context: Context) -> UITableView {
        let collectionView = UITableView(frame: .zero, style: .plain)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        collectionView.register(HostingCell.self, forCellReuseIdentifier: "Cell")
        return collectionView
    }

    func updateUIView(_ uiView: UITableView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(rows: rows)
    }

    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {

        var rows: [String]

        init(rows: [String]) {
            self.rows = rows
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            self.rows.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HostingCell

            let view = Text(rows[indexPath.row])
                    .frame(height: 50).background(Color.blue)
            
            // create & setup hosting controller only once
            if tableViewCell.host == nil {
                let controller = UIHostingController(rootView: AnyView(view))
                tableViewCell.host = controller
                
                let tableCellViewContent = controller.view!
                tableCellViewContent.translatesAutoresizingMaskIntoConstraints = false
                tableViewCell.contentView.addSubview(tableCellViewContent)
                tableCellViewContent.topAnchor.constraint(equalTo: tableViewCell.contentView.topAnchor).isActive = true
                tableCellViewContent.leftAnchor.constraint(equalTo: tableViewCell.contentView.leftAnchor).isActive = true
                tableCellViewContent.bottomAnchor.constraint(equalTo: tableViewCell.contentView.bottomAnchor).isActive = true
                tableCellViewContent.rightAnchor.constraint(equalTo: tableViewCell.contentView.rightAnchor).isActive = true
            } else {
                // reused cell, so just set other SwiftUI root view
                tableViewCell.host?.rootView = AnyView(view)
            }
            tableViewCell.setNeedsLayout()
            return tableViewCell
        }
    }
    
    class HostingCell: UITableViewCell { // just to hold hosting controller
        var host: UIHostingController<AnyView>?
    }
}

struct TestUIList: View {
    var body: some View {
        UIList(rows: generateRows())
    }
    
    func generateRows() -> [String] {
        (0..<100).reduce([]) { $0 + ["Row \($1)"] }
    }
}

struct UIList_Previews: PreviewProvider {
    static var previews: some View {
        TestUIList()
    }
}
