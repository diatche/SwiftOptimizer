//
//  twoD-ops.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

func make_operator(lhs: matrix2d, op: String, rhs: matrix2d)->matrix2d{
    assert(lhs.shape.0 == rhs.shape.0, "Sizes must match!")
    assert(lhs.shape.1 == rhs.shape.1, "Sizes must match!")
    
    var result = zeros_like(lhs) // real result
    let lhsM = lhs.flat
    let rhsM = rhs.flat
    var resM:matrix = zeros_like(lhsM) // flat matrix
    if op=="+" {resM = lhsM + rhsM}
    else if op=="-" {resM = lhsM - rhsM}
    else if op=="*" {resM = lhsM * rhsM}
    else if op=="/" {resM = lhsM / rhsM}
    else if op=="<" {resM = lhsM < rhsM}
    else if op==">" {resM = lhsM > rhsM}
    else if op==">=" {resM = lhsM >= rhsM}
    else if op=="<=" {resM = lhsM <= rhsM}
    result.flat.grid = resM.grid
    return result
}
func make_operator(lhs: matrix2d, op: String, rhs: Double)->matrix2d{
    var result = zeros_like(lhs) // real result
//    var lhsM = asmatrix(lhs.grid) // flat
    let lhsM = lhs.flat
    var resM:matrix = zeros_like(lhsM) // flat matrix
    if op=="+" {resM = lhsM + rhs}
    else if op=="-" {resM = lhsM - rhs}
    else if op=="*" {resM = lhsM * rhs}
    else if op=="/" {resM = lhsM / rhs}
    else if op=="<" {resM = lhsM < rhs}
    else if op==">" {resM = lhsM > rhs}
    else if op==">=" {resM = lhsM >= rhs}
    else if op=="<=" {resM = lhsM <= rhs}
    result.flat.grid = resM.grid
    return result
}
func make_operator(lhs: Double, op: String, rhs: matrix2d)->matrix2d{
    var result = zeros_like(rhs) // real result
//    var rhsM = asmatrix(rhs.grid) // flat
    let rhsM = rhs.flat
    var resM:matrix = zeros_like(rhsM) // flat matrix
    if op=="+" {resM = lhs + rhsM}
    else if op=="-" {resM = lhs - rhsM}
    else if op=="*" {resM = lhs * rhsM}
    else if op=="/" {resM = lhs / rhsM}
    else if op=="<" {resM = lhs < rhsM}
    else if op==">" {resM = lhs > rhsM}
    else if op==">=" {resM = lhs >= rhsM}
    else if op=="<=" {resM = lhs <= rhsM}
    result.flat.grid = resM.grid
    return result
}

// DOT PRODUCT
infix operator *! {associativity none precedence 140}
func *! (lhs: matrix2d, rhs: matrix2d) -> matrix2d{
    return dot(lhs, y: rhs)}
// SOLVE
infix operator !/ {associativity none precedence 140}
func !/ (lhs: matrix2d, rhs: matrix) -> matrix{
    return solve(lhs, b: rhs)}
// EQUALITY
func ~== (lhs: matrix2d, rhs: matrix2d) -> Bool{
    return (rhs.flat ~== lhs.flat)}

/// ELEMENT WISE OPERATORS
// PLUS
infix operator + {associativity none precedence 140}
func + (lhs: matrix2d, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: "+", rhs: rhs)}
func + (lhs: Double, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: "+", rhs: rhs)}
func + (lhs: matrix2d, rhs: Double) -> matrix2d{
    return make_operator(lhs, op: "+", rhs: rhs)}
// MINUS
infix operator - {associativity none precedence 140}
func - (lhs: matrix2d, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: "-", rhs: rhs)}
func - (lhs: Double, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: "-", rhs: rhs)}
func - (lhs: matrix2d, rhs: Double) -> matrix2d{
    return make_operator(lhs, op: "-", rhs: rhs)}
// TIMES
infix operator * {associativity none precedence 140}
func * (lhs: matrix2d, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: "*", rhs: rhs)}
func * (lhs: Double, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: "*", rhs: rhs)}
func * (lhs: matrix2d, rhs: Double) -> matrix2d{
    return make_operator(lhs, op: "*", rhs: rhs)}
// DIVIDE
infix operator / {associativity none precedence 140}
func / (lhs: matrix2d, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: "/", rhs: rhs)
}
func / (lhs: Double, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: "/", rhs: rhs)}
func / (lhs: matrix2d, rhs: Double) -> matrix2d{
    return make_operator(lhs, op: "/", rhs: rhs)}
// LESS THAN
infix operator < {associativity none precedence 140}
func < (lhs: matrix2d, rhs: Double) -> matrix2d{
    return make_operator(lhs, op: "<", rhs: rhs)}
func < (lhs: matrix2d, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: "<", rhs: rhs)}
func < (lhs: Double, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: "<", rhs: rhs)}
// GREATER THAN
infix operator > {associativity none precedence 140}
func > (lhs: matrix2d, rhs: Double) -> matrix2d{
    return make_operator(lhs, op: ">", rhs: rhs)}
func > (lhs: matrix2d, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: ">", rhs: rhs)}
func > (lhs: Double, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: ">", rhs: rhs)}
// GREATER THAN OR EQUAL
infix operator >= {associativity none precedence 140}
func >= (lhs: matrix2d, rhs: Double) -> matrix2d{
    return make_operator(lhs, op: "=>", rhs: rhs)}
func >= (lhs: matrix2d, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: "=>", rhs: rhs)}
func >= (lhs: Double, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: "=>", rhs: rhs)}
// LESS THAN OR EQUAL
infix operator <= {associativity none precedence 140}
func <= (lhs: matrix2d, rhs: Double) -> matrix2d{
    return make_operator(lhs, op: "=>", rhs: rhs)}
func <= (lhs: matrix2d, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: "=>", rhs: rhs)}
func <= (lhs: Double, rhs: matrix2d) -> matrix2d{
    return make_operator(lhs, op: "=>", rhs: rhs)}