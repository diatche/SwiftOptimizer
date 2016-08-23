//
//  initing.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

// the matrix definition and related functions go here

// SLOW PARTS: argwhere, x[matrix, range] set, modulo operator

func toArray(seq: Range<Int>) -> matrix {
    // improve with [1]
    // [1]:https://gist.github.com/nubbel/d5a3639bea96ad568cf2
    let start:Double = seq.startIndex.double * 1.0
    let end:Double   = seq.endIndex.double * 1.0
    let s = arange(start, max: end, x:true)
    return s
}

struct matrix {
    let n: Int
    var count: Int
    var grid: [Double]
    init(n: Int) {
        self.n = n
        self.count = n
        grid = Array(count: n, repeatedValue: 0.0)
    }
    func indexIsValidForRow(index: Int) -> Bool {
        return index >= 0 && index < n
    }
    subscript(index: Int) -> Double {
        get {
            assert(indexIsValidForRow(index), "Index out of range")
            return grid[index]
        }
        set {
            assert(indexIsValidForRow(index), "Index out of range")
            grid[index] = newValue
        }
    }
    subscript(r: Range<Int>) -> matrix {
        get {
            // assumes that r is not [0, 1, 2, 3...] not [0, 2, 4...]
            return self[toArray(r)]
        }
        set {
            self[toArray(r)].grid = newValue.grid}
    }
    subscript(r: matrix) -> matrix {
        get {
            //assert((r%1.0) ~== zeros_like(r))
            let y = zeros(r.n)
            index_objc(!self, !y, !r, r.n.cint)
            return y
        }
        set {
            //assert((r % 1.0) ~== zeros_like(r))
            _ = 0
            // FOR LOOP in C
            // asked stackoverflow question at [1]
            // [1]:http://stackoverflow.com/questions/24727674/modify-select-elements-of-an-array
            index_xa_b_objc(!self, !r, !newValue, r.n.cint)
        }
    }
}

func asmatrix(x: [Double]) -> matrix{
    var y = zeros(x.count)
    y.grid = x
    return y
}

func println(x: matrix, prefix:String="matrix([", postfix:String="])", newline:String="\n", format:String="%.3f", printWholeMatrix:Bool=false){
    print(prefix)
    var suffix = ", "
    var printed = false
    for i in 0..<x.n{
        if i==x.n-1 { suffix = "" }
        if printWholeMatrix || (x.n)<16 || i<3 || i>(x.n-4){
            print(NSString(format: format+suffix, x[i]))
        }else if printed == false{
            printed = true
            print("..., ")
        }
    }
    print(postfix)
    print(newline)
}
func print(x: matrix, prefix:String="matrix([", postfix:String="])", format:String="%.3f", printWholeMatrix:Bool=false){
    println(x, prefix:prefix, postfix:postfix, newline:"", format:format, printWholeMatrix:printWholeMatrix)
}
func zeros_like(x: matrix) -> matrix{
    return zeros(x.n)
}
/// argwhere(x < 2) or argwhere(x < y) works as more or less as expected. returns an array of type double (bug, todo)
func argwhere(idx: matrix) -> matrix{
    // counts non-zero elements, return array of doubles (which can be indexed!).
    let i = arange(Double(idx.n))
    let sum = sum_objc(!idx, idx.n.cint)
    let args = zeros(Int(sum))
    find_objc(!idx, !args, !i, idx.n.cint)
    return args
}

// RANGE. | for exclusive range, ! for inclusive range. | chosen for similiarity with Python, ! chosen because ! has a dot, closer to ...
infix operator | {associativity none precedence 140}
func | (lhs: Int, rhs: Int) -> Range<Int>{
    return lhs..<rhs
}
infix operator ! {associativity none precedence 140}
func ! (lhs: Int, rhs: Int) -> Range<Int>{
    return lhs...rhs
}


















