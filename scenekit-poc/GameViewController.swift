//
//  GameViewController.swift
//  scenekit-poc
//
//  Created by gurrium on 2022/02/10.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    private var scnView: SCNView {
        // retrieve the SCNView
        view as! SCNView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/blank.scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: -40, z: 30)
        cameraNode.eulerAngles = .init(Float.pi / 4, 0, 0)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)

        let plane = SCNNode()
        plane.geometry = SCNPlane(width: 50, height: 50)
        plane.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/check.png")
        plane.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(10, 10, 0)
        plane.geometry?.firstMaterial?.diffuse.wrapS = .repeat
        plane.geometry?.firstMaterial?.diffuse.wrapT = .repeat
        scene.rootNode.addChildNode(plane)

        let box = SCNNode()
        box.geometry = SCNBox(width: 5, height: 2, length: 2, chamferRadius: 0)
        scene.rootNode.addChildNode(box)
        box.runAction(.moveBy(x: -20, y: 0, z: 2, duration: 0))
        box.runAction(.repeatForever(.sequence([
            .moveBy(x: 40, y: 0, z: 0, duration: 2),
            .moveBy(x: -40, y: 0, z: 0, duration: 2)
        ])))
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
