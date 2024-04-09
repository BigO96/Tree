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
                NodeView(node: tree.tree.root, depth: 0)
                    .id(tree.version)
                    .padding(.top, 20)
            }
        }
    }
}

struct NodeView: View {
    var node: TreeNode?
    var depth: Int

    @State private var showingNodeDetails = false

    private let baseSpacing: CGFloat = 50
    private let nodeSize: CGFloat = 25

    var body: some View {
        VStack {
            if let node = node, node.key != -1 {
                Circle()
                    .fill(node.color == "red" ? Color.red : Color.black)
                    .frame(width: nodeSize, height: nodeSize)
                    .overlay(Text("\(node.key)").font(.caption).foregroundColor(.white))
                    .offset(y: node.key == 15 ? -20 : 0)
                    .padding(.bottom, 10)
                    .onTapGesture {
                        self.showingNodeDetails = true
                    }
                    .alert(isPresented: $showingNodeDetails) {
                        Alert(title: Text("Node Details"), message: Text("Depth: \(depth)"), dismissButton: .default(Text("OK")))
                    }

                HStack(spacing: max(baseSpacing / CGFloat(pow(2, Double(depth))), 15)) {
                    if let leftChild = node.left, leftChild.key != -1 {
                        NodeView(node: leftChild, depth: depth + 1)
                    }

                    if node.left == nil || node.right == nil {
                        Spacer()
                    }

                    if let rightChild = node.right, rightChild.key != -1 {
                        NodeView(node: rightChild, depth: depth + 1)
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
