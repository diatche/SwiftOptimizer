//
//  conversion.swift
//  swix
//
//  Created by Scott Sievert on 7/11/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

//func matrixToPointer(x: matrix)->UnsafePointer<Double>{
//    // sustains since objc rewrites raw memory!
//    return UnsafePointer<Double>(x.grid)
//}
//func matrixToPointer(x: [Int])->UnsafePointer<Int>{
//    return UnsafePointer<Int>(x)
//}
//func pointerToMatrix(xPC: UnsafePointer<Double>, N: CInt) -> matrix{
//    let x = zeros(N.int)
//    let xP = matrixToPointer(x)
//    copy_objc(xPC, xP, N);
//    return x
//}
//func pointerTo2DMatrix(xPC: UnsafePointer<Double>, N: CInt, M:CInt) -> matrix2d{
//    var x = zeros((N.int, M.int))
//    var xP = matrixToPointer(x.flat)
//    copy_objc(xPC, xP, N*M);
//    return x
//}
//
///// use !x to get the address. I tried &x but that doesn't work in beta3.
//prefix func ! (x: matrix) -> UnsafePointer<Double> {
//    return matrixToPointer(x)
//}
//prefix func ! (x: matrix2d) -> UnsafePointer<Double> {
//    return matrixToPointer(x.flat)
//}


func matrixToPointer(x: matrix)->UnsafeMutablePointer<Double>{
    // sustains since objc rewrites raw memory!
    return UnsafeMutablePointer<Double>(x.grid)
}
func matrixToPointer(x: [Int])->UnsafeMutablePointer<Int>{
    return UnsafeMutablePointer<Int>(x)
}
func pointerToMatrix(xPC: UnsafeMutablePointer<Double>, N: CInt) -> matrix{
    let x = zeros(N.int)
    let xP = matrixToPointer(x)
    copy_objc(xPC, xP, N);
    return x
}
func pointerTo2DMatrix(xPC: UnsafeMutablePointer<Double>, N: CInt, M:CInt) -> matrix2d{
    let x = zeros((N.int, M.int))
    let xP = matrixToPointer(x.flat)
    copy_objc(xPC, xP, N*M);
    return x
}

/// use !x to get the address. I tried &x but that doesn't work in beta3.
prefix func ! (x: matrix) -> UnsafeMutablePointer<Double> {
    return matrixToPointer(x)
}
prefix func ! (x: matrix2d) -> UnsafeMutablePointer<Double> {
    return matrixToPointer(x.flat)
}