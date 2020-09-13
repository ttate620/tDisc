//
//  test.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 7/15/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import SwiftUI

struct test: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear{
             API().getCourses()
        }
       
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
