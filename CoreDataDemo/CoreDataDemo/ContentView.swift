//
//  ContentView.swift
//  CoreDataDemo
//
//  Created by Hau Nguyen on 17/08/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var model = dataModel()
    var body: some View {
        NavigationView{
            VStack {
                List(model.data, id: \.objectID){ obj in
                    Text(model.getValue(obj: obj))
                }
                
                HStack(spacing: 15) {
                    TextField("Data core", text: $model.text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {model.writeData()}) {
                        Text("Save")
                    }
                }.padding()
            }
            .navigationBarTitle("Core Data")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

class dataModel: ObservableObject {
    @Published var data: [NSManagedObject] = []
    @Published var text = ""
    let context = persistentContainer.viewContext
    
    init() {
        readData()
    }
    
    func readData() {
        let request = NSFetchRequest<NSFetchRequestResult> (entityName: "Data")
        
        do {
            let result = try context.fetch(request)
            
            self.data = result as! [NSManagedObject]
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func writeData() {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Data", into: context)
        entity.setValue(text, forKey: "value")
        
        do {
            try context.save()
            
            self.data.append(entity)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func updateData() {
        
    }
    
    func deleteData() {
        
    }
    
    func getValue(obj: NSManagedObject)-> String {
        return obj.value(forKey: "value") as! String
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
