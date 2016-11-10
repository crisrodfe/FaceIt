//
//  BlinkingFaceViewController.swift
//  FaceIt
//
//  Created by Cristina Rodriguez Fernandez on 18/7/16.
//  Copyright © 2016 CrisRodFe. All rights reserved.
//

import UIKit

class BlinkingFaceViewController: FaceViewController
{

    var blinking: Bool = false
        {
        didSet {
            startBlink()
        }
    }
    
    
    fileprivate struct BlinkRate
    {
        static let ClosedDUration = 0.4
        static let OpenDuration = 2.5
    }
    
    func startBlink()
    {
        if blinking
        {
            //FaceView es una propiedad heredada de FaceViewController
            faceView.eyesOpen = false
            
            //Despues de un momento, volver a abrirlos:
            Timer.scheduledTimer(
                timeInterval: BlinkRate.ClosedDUration,
                target: self,
                selector: #selector(BlinkingFaceViewController.endBlink),
                userInfo: nil,
                repeats: false)
        }
    
    }
    
    func endBlink()
    {
        faceView.eyesOpen = true
        
        Timer.scheduledTimer(
            timeInterval: BlinkRate.ClosedDUration,
            target: self,
            selector: #selector(BlinkingFaceViewController.startBlink),
            userInfo: nil,
            repeats: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        blinking = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        blinking = false
        
    }
}
