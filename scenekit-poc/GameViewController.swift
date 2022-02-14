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
    @IBOutlet weak var sceneView: SCNView!

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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/blank.scn")!

        let box = SCNNode()
        box.geometry = SCNBox(width: 1, height: 1, length: 3, chamferRadius: 0)
        box.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/check.png")
        scene.rootNode.addChildNode(box)
        print("box.pivot:", box.pivot)
        box.pivot =  SCNMatrix4MakeTranslation(3, 0, 0)
        print("box.pivot:", box.pivot)
        box.runAction(.repeatForever(.rotateBy(x: 0, y: .pi / 2, z: 0, duration: 2)))

        let camera = SCNNode()
        camera.camera = SCNCamera()
        scene.rootNode.addChildNode(camera)
        camera.runAction(.move(by: .init(0, 10, 10), duration: 0))
        camera.runAction(.rotateBy(x: -.pi / 4, y: 0, z: 0, duration: 0))

        // set the scene to the view
        sceneView.scene = scene

        // allows the user to manipulate the camera
        sceneView.allowsCameraControl = true

        // show statistics such as fps and timing information
        sceneView.showsStatistics = true

        // configure the view
        sceneView.backgroundColor = UIColor.black
    }
}
