//
//  ViewController.swift
//  FaceIt
//
//  Created by Cristina Rodriguez Fernandez on 5/6/16.
//  Copyright © 2016 CrisRodFe. All rights reserved.
//

import UIKit


class FaceViewController: UIViewController
{
    //El modelo que vamos a usar. //Si cambia alguna de las propiedades ,alguno de los argumentos, necesitaremos cambiar nuestra vista
    var expression = FacialExpression(eyes: .closed, eyeBrows: .relaxed, mouth: .smirk) {
        didSet {
            updateUI() // Model changed, so update the View
        }
    }
    
    // View
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                    target: faceView, //Como cambia la escala, no cambia el modelo la propia vista lo manejará
                    action: #selector(FaceView.changeScale(_:))
                ))
            
            //Para cambiar el gestod e la boca no vamos a cambiar la curvatura si no nuestro modelo. El manejador estará en nuestro controlador, aqui, y será este el que modifique el modelo.
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self,
                action: #selector(FaceViewController.increaseHappiness)
            )
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self,
                action: #selector(FaceViewController.decreaseHappiness)
            )
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            
            faceView.addGestureRecognizer(UIRotationGestureRecognizer(
                target: self,
                action: #selector(FaceViewController.changeBrows(_:))
                ))
            
            
            updateUI()
        }
    }
    
    
    // here the Controller is doing its job
    // of interpreting the Model (expression) for the View (faceView)
    
    fileprivate func updateUI() {
        if faceView != nil
        {
            switch expression.eyes {
            case .open: faceView.eyesOpen = true
            case .closed: faceView.eyesOpen = false
            case .squinting: faceView.eyesOpen = false
            }
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0 //En caso de no encontrar la expxresion en el diccionario pondremos 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
    
    //Diccionarios con los valores de cada tipo.
    fileprivate var mouthCurvatures = [FacialExpression.Mouth.frown:-1.0,
                                   .grin:0.5,.smile:1.0,
                                   .smirk:-0.5,
                                   .neutral:0.0 ]
    fileprivate var eyeBrowTilts = [FacialExpression.EyeBrows.relaxed:0.5,
                                .furrowed:-0.5,
                                .normal:0.0]
    
    // MARK: Gesture Handlers
    
    // gesture handler for swipe to increase happiness
    // changes the Model (which will, in turn, updateUI())
    func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    // gesture handler for swipe to decrease happiness
    // changes the Model (which will, in turn, updateUI())
    func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    // gesture handler for taps
    //
    // toggles the open/closed state of the eyes in the Model
    // and all changes to the Model automatically updateUI()
    // (see the didSet for the Model var expression above)
    // so our faceView will also change its eyes
    //
    // this handler was added directly in the storyboard
    // by dragging a UITapGestureHandler onto the faceView
    // then ctrl-dragging from the tap gesture
    // (at the top of the scene in the storyboard)
    // here to our Controller
    // (so there's no need to call addGestureRecognizer)
    
    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer)
    {
        if recognizer.state == .ended
        {
            switch expression.eyes
            {
                case .open: expression.eyes = .closed
                case .closed: expression.eyes = .open
                case .squinting: break // we don't know how to toggle "Squinting"
            }
        }
    }
    
    fileprivate struct Animation
    {
         static let ShakeAngle = CGFloat(M_PI/6)
         static let ShakeDuration = 0.5
    }
    
    @IBAction func headShake(_ sender: UITapGestureRecognizer)
    {
        UIView.animate (
            withDuration: Animation.ShakeDuration,
            animations:
            {
                self.faceView.transform = self.faceView.transform.rotated(by: Animation.ShakeAngle)
            },
            completion: { finished in
                //Cuando acabe de girar, lo giramos hacia el otro lado y que vuelva al centro
                if finished {
                    UIView.animate(
                        withDuration: Animation.ShakeDuration,
                        animations: {
                            self.faceView.transform = self.faceView.transform.rotated(by: -Animation.ShakeAngle*2)
                        },
                        completion: { finished in
                            if finished {
                                UIView.animate(
                                    withDuration: Animation.ShakeDuration,
                                    animations: {
                                        self.faceView.transform = self.faceView.transform.rotated(by: Animation.ShakeAngle)
                                    },
                                    completion: { finished in
                                        if finished {
                                            
                                        }
                                    }
                                )
                            }
                        }
                    )
                }
            }
        )
    }
    
    
    @IBAction func changeBrows(_ recognizer: UIRotationGestureRecognizer)
    {
        switch recognizer.state {
        case .changed,.ended:
            if recognizer.rotation > CGFloat(M_PI/4) {
                expression.eyeBrows = expression.eyeBrows.moreRelaxedBrow()
                recognizer.rotation = 0.0
            } else if recognizer.rotation < -CGFloat(M_PI/4) {
                expression.eyeBrows = expression.eyeBrows.moreFurrowedBrow()
                recognizer.rotation = 0.0
            }
        default:
            break
        }
    }


    let instance = getFaceMVCinstanceCount()
}
