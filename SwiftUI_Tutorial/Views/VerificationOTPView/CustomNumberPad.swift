//
//  CustomNumberPad.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 23/12/2021.
//

import SwiftUI

struct CustomNumberPad: View {
    @Binding var codes : [String]
    
    var body : some View{
        
        VStack(alignment: .leading,spacing: 20){
            
            ForEach(datas){i in
                
                HStack(spacing: self.getspacing()){
                    
                    ForEach(i.row){j in
                        
                        Button(action: {
                            
                            if j.value == "delete.left.fill"{
                                
                                self.codes.removeLast()
                            }
                            else{
                                
                                self.codes.append(j.value)
                                
                                if self.codes.count == 4{
                                    
                                    print(self.getCode())
                                    
                                    // use this code for verification and post the notification when the code is verified....
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name("Success"), object: nil)
                                    
                                    self.codes.removeAll()
                                }
                            }
                            
                        }) {
                            
                            if j.value == "delete.left.fill"{
                                
                                Image(systemName: j.value).font(.body).padding(.vertical)
                            }
                            else{
                                
                                Text(j.value).font(.title).fontWeight(.semibold).padding(.vertical)
                            }
                            
                            
                        }
                    }
                }
                
            }
            
        }.foregroundColor(.white)
    }
    
    func getspacing()->CGFloat{
        
        return UIScreen.main.bounds.width / 3
    }
    
    func getCode()->String{
        
        var code = ""
        
        for i in self.codes{
            
            code += i
            
        }
        
        return code.replacingOccurrences(of: " ", with: "")
    }
}

struct CustomNumberPad_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView()
    }
}
