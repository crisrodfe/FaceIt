//
//  Apuntes.swift
//  FaceIt
//
//  Created by Cristina Rodriguez Fernandez on 5/6/16.
//  Copyright © 2016 CrisRodFe. All rights reserved.
//

import Foundation

/*
 -----Definir un path. Dibujar un triangulo:---- CLASE UIBEZIERPATH
 let path = UIBezierPath()
 path.moveToPoint(CGPoint(80,50))
 path.addLineToPoint(CGPoint(140,150))
 path.addLineToPoint(CGPoint(10,150))
 
 path.closePath()
 
 UIColor.greenColor().setFil()
 UIColor.redColor().setStroke()
 
 path.linewidth = 3.0
 path.fill()
 path.stroke()
 
 ----FORMAS----
 let roundPath = UIBEzierPath(roundedRect:aCGRect, cornerRadious: aCGFloat)
 
 
 Para dibujar texto sin usar UILabel
 let text = NSAttributedString("Hello")
 text.drawAtPoint(aCGPoint)
 let textSize : CGSIze = text.size //Para saber el tamaño que tendrá, el espacio que ocupará
 
 
 ---GESTOS----
 Hay una libreria para cada uno de ellos.
 
 Clase UIGestureRecognizer. Es una clase abstracta. Se instanciarán sus subclases.
 Pasos: - se le añade e un UIView un gesture recognizer,
        - handler que implemente la accion que descandena el gesto
 Hay vistas que tiene sus propios gestos como las ScrollViews
 Ejemplo para un gesto pan:
    @IBOutlet weak var pannableView: UIView{
        didSet{ //Este metodo es llamado solamente una vez cuando el sistema relaciona esta vista
            let recognizer = UIPanGEstureRecognizer ( dos argumentos
                    target: self, quien va a manejar el gesto una vez que se ha reconocido, en este caso el controller
                    action: #selector (ViewController.pan(_:)) el método al que se llama, generalmente UiView o ViewController, _: significa que tiene un argumento, pero nos da igual el nombre que tenga. Será el que tengamos implementado en nuestro Controller.
                )
             pannableView.addGestureRecognizer(recognizer)
    }
 }
 
 **Handler**
 Cada subclase tiene metodos especiales para manejar el tipo de gesto.POr ejemplo UIPanGestureRecognizer tiene tres métodos:
    - func translationInView(UIView) -> CGPoint que se acumula desde que empieza el gesto, lo lejos que se ha movido el dedo
    - func velocityInView(UiView) -> CGPoint lo rapido que se mueve el dedo
    - func setTranslation(CGPoint, inView: UIView) lo setearemos a cero si queremos resetear el movimiento acumulado
 Tambien tienen informacion de su estadoo
    - var state : UigestureRecognizerState { get } ----> .Possible, .Recognized, .Began, .Changed, .Ended
 
 En el Controller pondremos el handler:
    func pan(gesture: UIPanGestureRecognizer{
    switch gesture.state {
        case .Changed: falltrough --esto significa que se tiene que ejecutar el codigo que sigue
        case .Ended:
            let tranlation = gesture.translationInView(pannableView)
            gesture.setTranslation(CGPointZero, inView: pannableView)
        default: break }}
 
 
 Podemos crear MVC cuyas vistas sean otros MVC. Pero solo veremos MVC ya creado por iOS como por ejemplo: 
 - UITabController: deja al usuario elegir entre diferentes MVC, la barra de abajo tiene iconos con los diferentes submenus, que ofrecen cada uno un contenido
 
 - UISplitViewController: pone ddos MVC uno al lado del otro. El de la izquierda es el Master ViewController y el de la derecha es el Detail ViewController
 
 - UINavigationController: es como un monton de MVCs dentro de un NavigationController que va mostrando uno u otro (como en los Settings del iPhone)
 
********
 Segue: cuando hacemos que un MVC llame a otro MVC. Hay cuatro tipos principales:
 - show segue: mostrará un NAvigation Controller. Modal.
 - show detail segue: mostrará el Detail de un SplitView o mostrará un Navigation Controller.
 - modal segue: se adueña de toda la pantalla mientras el mvc se está mostrando
 - popover segue: el mvc aparece en una pequeña pantalla
 
 Segues siempre crean una nueva instancia de un MVC, hay reemplazo.
 
 Pueden hacerse con codigo pero se suele hacer en modo grafico(cntrl+drag y escogemos el tipo)
 
 Nos referiremos al segue en codigo con el nombre que le demos en su Identifier.
 
 
 
 Para preparar un segue el siguiente metodo tiene que ser llamado desde el Controller que lo causa.
    
    func prepareForSegue (segue: UIStoryBoardSegue, sender: AnyObject?){
        if let identifier = segue.identifier {
            switch identifier {
                case "Show graph":
                    if let vc = segue.destinationViewController as? GraphController {
                        vc.property1 =.... Podremos acceder a los metodos y propiedades que le hayamos definido como publicas
                        vc.callMethodToSetItUp....
                    }
                default: break
        }
 }
 
Esto sucede antes de que los Outlets sean creados, no podemos modificar nada de la interfaz en ese metodo.
 

 
VIEW CONTROLLER LIFECYCLE
 Es una serie de metodos que seran llamados a lo largo del tiempo.
 * Creacion del MVC: generalmente se hara siempre a traves del storyboard no con codigo.
    - Preparacion si vienen de un segue.
    - Se settean los outlets.
    - Aparicion o desaparicion. POr ejemplo cuando sacamos y metemos el master de un NavigationController
    - Cambios geometricos. Como por ejemplo en la rotacion (portrait vs landscape)
    - Situaciones de poca memoria.
 
 func viewDidLoad(){ super.viewDidLoad()}: es llamado despues de la instanciacion y del seteo de outlets. Pondremos mucho codigo de configuracion/setup, mejor que en nuestro init ya que tendremos lot outlets cargados. 
     Aqui haremos los updates de nuestro UI desde nuestro modelo
    Tenemos que tener cuidado con la gemoetria porque no esta configurada. NO podremos hacer por ejemplo calculos con los bordes.
    Aqui no estaremos seguros si estamos en una pantalla de iphone o ipad, etc.
 
 func viewWillAppear(animated: Bool){}: aqui pondremos codigo que cambie nuestra UI mientras nuestro MVC no esta mostrandose. Podemos poner aqui operaciones de codigo pesadas, posiblemente en otra thread. 
    Lo Calculos de geometria es mejor que tampoco los pongamos aqui.
    Tambien hay un viewDidAppear()
 
 func viewWillDisappear(animated: Bool){}: cuando el MVC desaparece, por ejmplo aqui podremos parar una animacion, o para de usar el gyro, etc.
 
 func viewDidDisappear(){}: Este metodo junto con el anterior puede ser llamado una y otra vez.
 
 Si queremos algo relacionado con la geometria usaremos:
    viewWillLayoutSubViews() y tambien el Did
    Son llamados cuando rotamos la pantalla por ejemplo. Pero tmbien en otras ocasiones.
 
 Autorotation:
    - la mejor forma de controlarlo es con las constraints del storyboard
 
 Pero si queremos acceder a la animacion de la rotacion:
    func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator: UIViewControllerTransitionCoordinator)
 
 didRecieveMemoryWrning se llama cuando hay poca memoria, generalmente no deberia usarse, no hay que llegar a ese punto pero puede pasar al trabajar con imagenes y sonidos
 
 */