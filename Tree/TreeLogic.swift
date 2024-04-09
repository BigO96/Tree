//
//  TreeLogic.swift
//  Tree
//
//  Created by Oscar Epp on 4/8/24.
//

import Foundation

class ObservableRedBlackTree: ObservableObject {
    @Published var tree: RedBlackTree
    @Published var version: Int = 0

    init() {
        self.tree = RedBlackTree()
    }

    func insert(key: Int) {
        tree.insert(key: key)
        self.objectWillChange.send()
        version += 1
    }
}

class TreeNode {
    var key: Int
    var parent: TreeNode?
    var color: String
    var left: TreeNode?
    var right: TreeNode?
    var depth: Int

    init(key: Int, depth: Int = 0, position: Int = 0) {
        self.key = key
        self.parent = nil
        self.color = "red"
        self.left = nil
        self.right = nil
        self.depth = depth
    }
}


class RedBlackTree {
    var NIL: TreeNode
    var root: TreeNode

    init() {
        self.NIL = TreeNode(key: -1)
        self.NIL.color = "black"
        self.NIL.left = nil
        self.NIL.right = nil

        self.root = self.NIL
        
        insert(key: 10)
        insert(key: 5)
        insert(key: 15)
        
        insert(key: 30)
        insert(key: 20)
        
        insert(key: 40)
        insert(key: 2)
        insert(key: 8)

        insert(key: 1)
        insert(key: 9)
        insert(key: 3)
        insert(key: 7)


    }
}

/// Left Rotate & Right Rotate
extension RedBlackTree {
    func leftRotate(_ x: TreeNode) {
        guard let y = x.right else { return }
        x.right = y.left
        
        if y.left !== NIL {
            y.left?.parent = x
        }
        
        y.parent = x.parent
        
        if x.parent == nil {
            self.root = y
        } else if x === x.parent?.left {
            x.parent?.left = y
        } else {
            x.parent?.right = y
        }
        
        y.left = x
        x.parent = y
    }

    func rightRotate(_ x: TreeNode) {
        guard let y = x.left else { return }
        x.left = y.right
        
        if y.right !== NIL {
            y.right?.parent = x
        }
        
        y.parent = x.parent
        
        if x.parent == nil {
            self.root = y
        } else if x === x.parent?.right {
            x.parent?.right = y
        } else {
            x.parent?.left = y
        }
        
        y.right = x
        x.parent = y
    }
}

/// Insert function
extension RedBlackTree {
    func insert(key: Int) {
        let z = TreeNode(key: key)
        z.depth = 0
        
        var y = self.NIL
        var x = self.root
        
        while x !== self.NIL {
            y = x
            if z.key < x.key {
                x = x.left ?? self.NIL
            } else {
                x = x.right ?? self.NIL
            }
        }
        
        z.parent = y
        if y === self.NIL {
            self.root = z
            z.depth = 0
        } else {
            if z.key < y.key {
                y.left = z
            } else {
                y.right = z
            }
            z.depth = y.depth + 1
        }
        
        z.left = self.NIL
        z.right = self.NIL
        z.color = "red"
    
        insertFixup(node: z)
    }

    
    private func insertFixup(node: TreeNode) {
        var z = node
        while z.parent?.color == "red" {
            if z.parent === z.parent?.parent?.left {
                let y = z.parent?.parent?.right ?? self.NIL
                if y.color == "red" {
                    z.parent?.color = "black"
                    y.color = "black"
                    z.parent?.parent?.color = "red"
                    z = z.parent?.parent ?? self.NIL
                } else {
                    if z === z.parent?.right {
                        z = z.parent ?? self.NIL
                        self.leftRotate(z)
                    }
                    z.parent?.color = "black"
                    z.parent?.parent?.color = "red"
                    if let grandParent = z.parent?.parent {
                        self.rightRotate(grandParent)
                    }
                }
            } else {
                let y = z.parent?.parent?.left ?? self.NIL
                if y.color == "red" {
                    z.parent?.color = "black"
                    y.color = "black"
                    z.parent?.parent?.color = "red"
                    z = z.parent?.parent ?? self.NIL
                } else {
                    if z === z.parent?.left {
                        z = z.parent ?? self.NIL
                        self.rightRotate(z)
                    }
                    z.parent?.color = "black"
                    z.parent?.parent?.color = "red"
                    if let grandParent = z.parent?.parent {
                        self.leftRotate(grandParent)
                    }
                }
            }
        }
        self.root.color = "black"
    }
}


