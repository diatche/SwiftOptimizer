//
//  math.swift
//  swix
//
//  Created by Scott Sievert on 7/11/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

// fft, ifft, dot product, haar wavelet
func dot(x: matrix2d, y: matrix2d) -> matrix2d{
    let (Mx, Nx) = x.shape
    let (My, Ny) = y.shape
    assert(Nx == My, "Matrix sizes not compatible for dot product")
    let z = zeros((Mx, Ny))
    
    dot_objc(!x, !y, !z, Mx.cint, Ny.cint, Nx.cint)
    
    return z
}


func fft(x: matrix) -> (matrix, matrix){
    let N:CInt = x.n.cint
    let yr = zeros(N.int)
    let yi = zeros(N.int)
    fft_objc(!x, N, !yr, !yi);
    
    return (yr, yi)
}
func ifft(yr: matrix, yi: matrix) -> matrix{
    let N = yr.n
    let x = zeros(N)
    ifft_objc(!yr, !yi, N.cint, !x);

    return x
}