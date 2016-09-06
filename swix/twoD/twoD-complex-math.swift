//
//  twoD-complex-math.swift
//  swix
//
//  Created by Scott Sievert on 7/15/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation

func svd(x: matrix2d) -> (matrix2d, matrix, matrix2d){
    let (m, n) = x.shape
    let nS = m < n ? m : n // number singular values
    let sigma = zeros(nS)
    let vt = zeros((n,n))
    var u = zeros((m,m))

    var xx = zeros_like(x)
    xx.flat = x.flat
    xx = transpose(xx)
    let xP = matrixToPointer(xx.flat)
    let sP = matrixToPointer(sigma)
    let vP = matrixToPointer(vt.flat)
    let uP = matrixToPointer(u.flat)
    
    svd_objc(xP, m.cint, n.cint, sP, vP, uP);
    
    // to get the svd result to match Python
    let v = transpose(vt)
    u = transpose(u)

    return (u, sigma, v)
}
func inv(x: matrix2d) -> matrix2d{
    assert(x.shape.0 == x.shape.1, "To take an inverse of a matrix, the matrix must be square. If you want the inverse of a rectangular matrix, use psuedoinverse.")
    let y = zeros((x.shape.1, x.shape.0))
    copy(x.flat, y: y.flat)
    inv_objc(!y, x.shape.0.cint, x.shape.1.cint);
    return y
}
func solve(A: matrix2d, b: matrix) -> matrix{
    let (m, n) = A.shape
    assert(b.n == m, "Ax = b, A.rows == b.n. Sizes must match which makes sense mathematically")
    assert(n == m, "Matrix must be square -- dictated by OpenCV")
    let x = zeros(n)
    CVWrapper.solve(!A, b:!b, x:!x, m:m.cint, n:n.cint)
    return x
}










