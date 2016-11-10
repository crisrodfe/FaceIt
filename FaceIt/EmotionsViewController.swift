//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by CS193p Instructor.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController
{
    fileprivate let emotionalFaces: Dictionary<String,FacialExpression> =
    [
        "angry" : FacialExpression(eyes: .closed, eyeBrows: .furrowed, mouth: .frown),
        "happy" : FacialExpression(eyes: .open, eyeBrows: .normal, mouth: .smile),
        "worried" : FacialExpression(eyes: .open, eyeBrows: .relaxed, mouth: .smirk),
        "mischievious" : FacialExpression(eyes: .open, eyeBrows: .furrowed, mouth: .grin)
    ]

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        var destinationvc = segue.destination 
        
        if let navcon = destinationvc as? UINavigationController //Si a lo que se accede en el segue es un NavigationController buscará lo que hay dentro del él, no buscamos preparar un NavController en si mismo si no lo que contiene.
        {
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
    
        if let facevc = destinationvc as? FaceViewController //Nos aseguramos de que trabajamos con un controlador tipo FaceViewController
        {
            if let identifier = segue.identifier //Accedemos al identifier y nos aseguramos de que no es nil
            {
                if let expression = emotionalFaces[identifier]
                {
                    facevc.expression = expression
                    if let sendingButton = sender as? UIButton //Accedemos al boton con el que hemos provocado el segue y le ponemos su texto al titulo de la nueva pantalla
                    {
                        facevc.navigationItem.title = sendingButton.currentTitle
                    }
                }
            }
        }
    }

    let instance = getEmotionsMVCinstanceCount()
}
