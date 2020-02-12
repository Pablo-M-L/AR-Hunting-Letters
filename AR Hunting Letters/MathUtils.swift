//
//  MathUtils.swift
//  AR Hunting Letters
//
//  Created by admin on 02/12/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreGraphics

//funciones que dados dos puntos los une, los resta, los multiplica
func + (firstPoint:CGPoint, secondPoint:CGPoint) ->CGPoint{
    return CGPoint(x: firstPoint.x + secondPoint.x, y: firstPoint.y + secondPoint.y)
}

func += ( firstPoint: inout CGPoint, secondPoint: CGPoint){
    firstPoint = firstPoint + secondPoint
}

func - (firstPoint:CGPoint, secondPoint:CGPoint) ->CGPoint{
    return CGPoint(x: firstPoint.x - secondPoint.x, y: firstPoint.y - secondPoint.y)
}

func -= ( firstPoint: inout CGPoint, secondPoint: CGPoint){
    firstPoint = firstPoint - secondPoint
}

func * (firstPoint:CGPoint, secondPoint:CGPoint) ->CGPoint{
    return CGPoint(x: firstPoint.x * secondPoint.x, y: firstPoint.y * secondPoint.y)
}

func *= ( firstPoint: inout CGPoint, secondPoint: CGPoint){
    firstPoint = firstPoint * secondPoint
}

//multiplica cada coordenada del punto por el scalar.
func * (point:CGPoint, scalar:CGFloat) ->CGPoint{
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

//dados un punto y un scalar, los multiplica y los devuelve como parametro. un punto por un vector es un punto.
func *= ( point: inout CGPoint, scalar: CGFloat){
    point = point * scalar
}

func / (firstPoint:CGPoint, secondPoint:CGPoint) ->CGPoint{
    return CGPoint(x: firstPoint.x * secondPoint.x, y: firstPoint.y * secondPoint.y)
}

func /= ( firstPoint: inout CGPoint, secondPoint: CGPoint){
    firstPoint = firstPoint * secondPoint
}

//divide cada coordenada del punto por el scalar.
func / (point:CGPoint, scalar:CGFloat) ->CGPoint{
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

//dados un punto y un scalar, los divide y los devuelve como parametro. un punto por un vector es un punto.
func /= ( point: inout CGPoint, scalar: CGFloat){
    point = point / scalar
}

//#if -- #endif es un puente.
//solo se ejecutará si la app corre en 32 bits ya que no tienen las funciones atan2 ni sqrt.
//en 32bits no existe los CGFloat.
#if !(arch(x86_64) || arch(arm64))

    func atan2(y: CGFloat, x: CGFloat)-> CGFloat{
        return CGFloat(atan2f(Float(y), Float(x)))
    }

    func sqrt(a:CGFloat) -> CGFloat{
        return CGFloat(sqrtf(Float(a)))
    }

#endif

extension CGPoint{
    //longitud de un vector.
    func lenght() ->CGFloat{
        return sqrt(x*x + y*y)
    }
    
    //normalizacion de un vector.
    //normalizacion de un vector es tener un vector o un punto, de longitud 1.
    //devuelve vector dividido por su longitud.
    func normalize() ->CGPoint{
        return self / lenght()
    }
    
    //calcular el angulo que forma el punto con la horizontal
    var angle: CGFloat{
        return atan2(y,x)
    }
}

let π = CGFloat(Double.pi)

//gira el zombie en el sentido que tenga que girar menos.
func shortesAngleBetween(angle1:CGFloat, angle2:CGFloat) ->CGFloat{
    let twoπ = 2.0 * π
    //los resultados siempre estaran entre 0 y 2π. a partir swift 3 no se puede usar el modulo % con Floats o Double.
    var angle = (angle2 - angle1).truncatingRemainder(dividingBy: twoπ)
    //escogemos el recorrido mas corto para girar.
    if angle >= π{
        angle -= twoπ
    }
    if angle <= -π{
        angle += twoπ
    }
    //esta funcicion asegura que el angulo se encuentra entre -π y π, y por tanto sabrá hacia donde debe rotar con menor diferencia respecto a su posicion original.
    return angle
    
}

//calcular distancia entre dod cgpoint.
func distanceBetweenPoints(p1: CGPoint ,p2: CGPoint)-> CGFloat {
    //vector de la distancia entre los dos puntos que corresponden al centro de dos nodos.
    let distanceVector = p1 - p2
    //obtenemos la longitud del vector.
    let distance = distanceVector.lenght()
    
    return distance
    
    }


//extension que devuelve el signo del Float.
extension CGFloat{
    func sign() -> CGFloat {
        return (self >= 0) ? 1.0 : -1.0
    }
}

