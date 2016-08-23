//
//  initing.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

// SLOW PARTS: array(doubles). not a huge deal

func zeros(N: Int) -> matrix{
    return matrix(n: N)
}
func ones(N: Int) -> matrix{
    return matrix(n: N)+1
}
func arange(max: Double, x exclusive:Bool = true) -> matrix{
    let x = arange(0, max: max, x:exclusive)
    return x
}
func arange(min: Double, max: Double, x exclusive: Bool = true) -> matrix{
    var pad = 0
    if !exclusive {pad = 1}
    let N = max.int - min.int + pad
    let x = zeros(N)
    let xP = matrixToPointer(x)
    let minP = CDouble(min)
    
    linspace_objc(xP, (N+pad).cint, (minP), 1.0)
    return x
}
func linspace(min: Double, max: Double, num: Int=50) -> matrix{
    let x = zeros(num+1)
    let xP = matrixToPointer(x)
    linspace_objc(xP, num.cint, min.cdouble, ((max-min)/Double(num)).double)
    return x
}
func array(numbers: Double...) -> matrix{
    var x = zeros(numbers.count)
    var i = 0
    for number in numbers{
        x[i] = number
        i += 1
    }
    return x
}
func repeated(x: matrix, N:Int, how:String="matrix") -> matrix{
    let y = zeros(x.n * N)
    _ = matrixToPointer(x)
    _ = matrixToPointer(y)
    CVWrapper.repeated(!x, to:!y, n_x:x.n.cint, n_repeat:N.cint)
    var z = zeros((x.n, N))
    z.flat = y
    if how=="matrix" {z = transpose(z)}
    else if how=="elements" {}
    return z.flat
}
func copy(x: matrix, y: matrix){
    cblas_dcopy(x.n.cint, !x, 1.cint, !y, 1.cint)
}




















