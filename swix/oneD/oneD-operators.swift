//
//  oneD-functions.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

func make_operator(lhs:matrix, op:String, rhs:matrix) -> matrix{
    assert(lhs.n == rhs.n, "Sizes must match!")
    _ = zeros(lhs.n) // lhs[i], rhs[i]
    _ = zeros(lhs.n)
    _ = zeros(lhs.n)
    
    // see [1] on how to integrate Swift and accelerate
    // [1]:https://github.com/haginile/SwiftAccelerate
    var result = zeros(lhs.n)
    copy(lhs, y: result)
    let N = lhs.n
    if op=="+"
        {cblas_daxpy(N.cint, 1.0.cdouble, !rhs, 1.cint, !result, 1.cint);}
    else if op=="-"
        {cblas_daxpy(N.cint, -1.0.cdouble, !rhs, 1.cint, !result, 1.cint);}
    else if op=="*"
        {vDSP_vmulD(!lhs, 1, !rhs, 1, !result, 1, vDSP_Length(lhs.grid.count))}
    else if op=="/"
        {vDSP_vdivD(!rhs, 1, !lhs, 1, !result, 1, vDSP_Length(lhs.grid.count))}
    else if op=="<" || op==">" || op==">=" || op=="<="{
        result = zeros(lhs.n)
        CVWrapper.compare(!lhs, with: !rhs, using:op, into: !result, ofLength: lhs.n.cint)
        // since opencv uses images which use 8-bit values
        result /= 255
    }
    else {assert(false, "Operator not recongized!")}
    return result
}
func make_operator(lhs:matrix, op:String, rhs:Double) -> matrix{
    var array = zeros(lhs.n)
    var right = [rhs]
    if op == "%"
        {mod_objc(!lhs, rhs, !array, lhs.n.cint);
    } else if op == "*"
        {mul_scalar_objc(!lhs, rhs.cdouble, !array, lhs.n.cint)}
    else if op == "+"
        {vDSP_vsaddD(!lhs, 1, &right, !array, 1, vDSP_Length(lhs.grid.count))}
    else if op=="/"
        {vDSP_vsdivD(!lhs, 1, &right, !array, 1, vDSP_Length(lhs.grid.count))}
    else if op=="-"
        {array = make_operator(lhs, op: "-", rhs: ones(lhs.n)*rhs)}
    else if op=="<" || op==">" || op=="<=" || op==">="{
        CVWrapper.compare(!lhs, withDouble:rhs.cdouble, using:op, into:!array, ofLength:lhs.n.cint)
        array /= 255
    }
    else {assert(false, "Operator not recongnized! Error with the speedup?")}
    return array
}
func make_operator(lhs:Double, op:String, rhs:matrix) -> matrix{
    var array = zeros(rhs.n) // lhs[i], rhs[i]
    let l = ones(rhs.n) * lhs
    if op == "*"
        {array = make_operator(rhs, op: "*", rhs: lhs)}
    else if op == "+"{
        array = make_operator(rhs, op: "+", rhs: lhs)}
    else if op=="-"
        {array = -1 * make_operator(rhs, op: "-", rhs: lhs)}
    else if op=="/"{
        array = make_operator(l, op: "/", rhs: rhs)}
    else if op=="<"{
        array = make_operator(rhs, op: ">", rhs: lhs)}
    else if op==">"{
        array = make_operator(rhs, op: "<", rhs: lhs)}
    else if op=="<="{
        array = make_operator(rhs, op: ">=", rhs: lhs)}
    else if op==">="{
        array = make_operator(rhs, op: "<=", rhs: lhs)}
    else {assert(false, "Operator not reconginzed")}
    return array
}

// EQUALITY
infix operator ~== {associativity none precedence 140}
func ~== (lhs: matrix, rhs: matrix) -> Bool{
    assert(lhs.n == rhs.n, "`+` only works on arrays of equal size")
    if max(abs(lhs - rhs)) > 1e-6{
        return false
    } else{
        return true
    }
}
func ~== (lhs: matrix, rhs: matrix) -> matrix{
    // sees where two matrices are about equal, for use with argwhere
    return make_operator(lhs, op: "~==", rhs: rhs)
}

// NICE ARITHMETIC
func += (inout x: matrix, right: Double){
    x = x + right
}
func *= (inout x: matrix, right: Double){
    x = x * right
}
func -= (inout x: matrix, right: Double){
    x = x - right
}
func /= (inout x: matrix, right: Double){
    x = x / right
}

// MOD
infix operator % {associativity none precedence 140}
func % (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, op: "%", rhs: rhs)}
// PLUS
infix operator + {associativity none precedence 140}
func + (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, op: "+", rhs: rhs)}
func + (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, op: "+", rhs: rhs)}
func + (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, op: "+", rhs: rhs)}
// MINUS
infix operator - {associativity none precedence 140}
func - (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, op: "-", rhs: rhs)}
func - (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, op: "-", rhs: rhs)}
func - (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, op: "-", rhs: rhs)}
// TIMES
infix operator * {associativity none precedence 140}
func * (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, op: "*", rhs: rhs)}
func * (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, op: "*", rhs: rhs)}
func * (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, op: "*", rhs: rhs)}
// DIVIDE
infix operator / {associativity none precedence 140}
func / (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, op: "/", rhs: rhs)
    }
func / (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, op: "/", rhs: rhs)}
func / (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, op: "/", rhs: rhs)}
// LESS THAN
infix operator < {associativity none precedence 140}
func < (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, op: "<", rhs: rhs)}
func < (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, op: "<", rhs: rhs)}
func < (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, op: "<", rhs: rhs)}
// GREATER THAN
infix operator > {associativity none precedence 140}
func > (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, op: ">", rhs: rhs)}
func > (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, op: ">", rhs: rhs)}
func > (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, op: ">", rhs: rhs)}
// GREATER THAN OR EQUAL
infix operator >= {associativity none precedence 140}
func >= (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, op: ">=", rhs: rhs)}
func >= (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, op: ">=", rhs: rhs)}
func >= (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, op: ">=", rhs: rhs)}
// LESS THAN OR EQUAL
infix operator <= {associativity none precedence 140}
func <= (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, op: "<=", rhs: rhs)}
func <= (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, op: "<=", rhs: rhs)}
func <= (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, op: "<=", rhs: rhs)}






























