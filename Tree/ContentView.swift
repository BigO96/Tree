//
//  ContentView.swift
//  Tree
//
//  Created by Oscar Epp on 4/8/24.
//

import SwiftUI

struct ContentView: View {
    @State private var inputKey = ""
    @StateObject private var tree = ObservableRedBlackTree()

    var body: some View {
        VStack {
            TextField("Enter Node Key", text: $inputKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Insert") {
                if let key = Int(inputKey) {
                    tree.insert(key: key)
                }
                inputKey = ""
            }
            .padding()
            .disabled(inputKey.isEmpty)

            ScrollView {
                NodeView(node: tree.tree.root)
                    .id(tree.version)
            }
        }
    }
}


struct NodeView: View {
    var node: TreeNode?
    var depth: Int = 0 // Added depth property to track the level of each node
    
    var body: some View {
        VStack {
            if let node = node, node.key != -1 {
                Circle()
                    .fill(node.color == "red" ? Color.red : Color.black)
                    .frame(width: 30, height: 30)
                    .overlay(Text("\(node.key)")
                        .foregroundColor(.white))
                
                let spacing = max(10 - CGFloat(depth) * 2, 2)
                
                HStack(spacing: spacing) {
                    if let leftNode = node.left, leftNode.key != -1 {
                        NodeView(node: leftNode, depth: depth + 1)
                    }
                    if let rightNode = node.right, rightNode.key != -1 {
                        NodeView(node: rightNode, depth: depth + 1)
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
