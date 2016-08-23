//
//  oneD_math.swift
//  swix
//
//  Created by Scott Sievert on 6/11/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//


import Foundation
import Accelerate


// SLOW PARTS: almost everything
//  to speed up first: abs, sign, norm, rand, randn

/// applies the function to every element of an array and takes only that argument. This is just a simple for-loop. If you want to use some custom fancy function, define it yourself.
func apply_function(function: Double->Double, x: matrix) -> matrix{
    var y = zeros(x.count)
    for i in 0..<x.count{
        y[i] = function(x[i])
    }
    return y
}
func sin(x: matrix) -> matrix{
    return apply_function(sin, x: x)
}
func cos(x: matrix) -> matrix{
    return apply_function(cos, x: x)
}
func tan(x: matrix) -> matrix{
    return apply_function(tan, x: x)
}
/// log_e(.)
func log(x: matrix) -> matrix{
    let y = apply_function(log, x: x)
    return y
}
func abs(x: matrix) -> matrix{
    return apply_function(abs, x: x)
}
func sqrt(x: matrix) -> matrix{
    let y = apply_function(sqrt, x: x)
    return y
}
func round(x: matrix) -> matrix{
    return apply_function(round, x: x)
}
func floor(x: matrix) -> matrix{
    let y = apply_function(floor, x: x)
    return y
}
func ceil(x: matrix) -> matrix{
    let y = apply_function(ceil, x: x)
    return y
}
func sign(x: Double) -> Double{
    if x < 0{
        return -1
    } else{
        return 1
    }
}
func sign(x: matrix)->matrix{
    return apply_function(sign, x: x)
}
func pow(x: matrix, power: Double) -> matrix{
    var y = zeros(x.count)
    for i in 0..<x.count{
        y[i] = pow(x[i], power)
    }
    return y
}
func sum(x: matrix) -> Double{
    _ = zeros(x.count)
    var s: Double = 0
    for i in 0..<x.count{
        s = x[i] + s
    }
    return s
}
func avg(x: matrix) -> Double{
    let y: Double = sum(x)
    
    return y / x.count.double
}
func std(x: matrix) -> Double{
    let y: Double = avg(x)
    let z = x - y
    return sqrt(sum(pow(z, power: 2) / x.count.double))
}
/// variance used since var is a keyword
func variance(x: matrix) -> Double{
    let y: Double = avg(x)
    let z = x - y
    return sum(pow(z, power: 2) / x.count.double)
}
func norm(x: matrix, type:String="l2") -> Double{
    if type=="l2"{ return sqrt(sum(pow(x, power: 2)))}
    if type=="l1"{ return sum(abs(x))}
    if type=="l0"{
        var count = 0.0
        for i in 0..<x.n{
            if x[i] != 0{
                count += 1
            }
        }
        return count
    }
    
    assert(false, "type of norm unrecongnized")
    return -1.0
}
func cumsum(x: matrix) -> matrix{
    let N = x.count
    var y = zeros(N)
    for i in 0..<N{
        if i==0      { y[i] = x[0]          }
        else if i==1 { y[i] = x[0] + x[1]   }
        else         { y[i] = x[i] + y[i-1] }
    }
    return y
}
func rand() -> Double{
    return Double(arc4random()) / pow(2, 32)
}
func rand(N: Int) -> matrix{
    var x = zeros(N)
    for i in 0..<N{
        x[i] = rand()
    }
    return x
}
func randn() -> Double{
    let u:Double = rand()
    let v:Double = rand()
    let x = sqrt(-2*log(u))*cos(2*pi*v);
    return x
}
func randn(N: Int, mean: Double=0, sigma: Double=1) -> matrix{
    var x = zeros(N)
    for i in 0..<N{
        x[i] = randn()
    }
    let y = (x * sigma) + mean;
    return y
}
func min(x: matrix, absValue:Bool=false) -> Double{
    // absValue not implemeted yet
    _ = inf
    let xP = matrixToPointer(x)
    let minC = min_objc(xP, x.n.cint)
    return minC
}
func max(x: matrix, absValue:Bool=false) -> Double{
    // absValue not implemeted yet
    let xP = matrixToPointer(x)
    let maxC = max_objc(xP, x.n.cint);
    return maxC
}









