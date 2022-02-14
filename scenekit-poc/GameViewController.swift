//
//  GameViewController.swift
//  scenekit-poc
//
//  Created by gurrium on 2022/02/10.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SpeedController {
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var speedControlSlider: UISlider!

    weak var delegate: SpeedControllee?

    private let boxInitialPosition = SCNVector3(x: -20, y: 2, z: 0)

    private var box: SCNNode = {
        let box = SCNNode()
        box.geometry = SCNBox(width: 5, height: 2, length: 2, chamferRadius: 0)

        return box
    }()

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

        setup()
    }

    @IBAction func onSliderValueChanged() {
        delegate?.onSpeedChanged(speed: Double(speedControlSlider.value))
    }

    private func setup() {
        delegate = self
        setupViews()
    }

    private func setupViews() {
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/blank.scn")!

        let plane = SCNNode()
        plane.runAction(.rotateBy(x: -.pi / 2, y: 0, z: 0, duration: .zero))
        plane.geometry = SCNPlane(width: 50, height: 50)
        plane.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/check.png")
        plane.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(10, 10, 0)
        plane.geometry?.firstMaterial?.diffuse.wrapS = .repeat
        plane.geometry?.firstMaterial?.diffuse.wrapT = .repeat
        scene.rootNode.addChildNode(plane)

        scene.rootNode.addChildNode(box)
        box.runAction(.move(to: boxInitialPosition, duration: .zero))

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        box.addChildNode(cameraNode)
        cameraNode.runAction(.group([
            .moveBy(x: -30, y: 30, z: 0, duration: 0),
            .rotateBy(x: 0, y: -.pi / 2, z: 0, duration: 0),
            .rotateBy(x: 0, y: 0, z: -.pi / 4, duration: 0)
        ]))

        sceneView.scene = scene
        sceneView.showsStatistics = true
        sceneView.backgroundColor = .black
    }
}

extension GameViewController: SpeedControllee {
    func onSpeedChanged(speed: Double) {
        let distance = Double(abs(boxInitialPosition.x * 2))
        box.removeAllActions()
        box.runAction(.sequence([
            .move(to: boxInitialPosition, duration: .zero),
            .repeatForever(.sequence([
                .move(by: .init(distance, 0, 0), duration: distance / speed),
                .move(to: boxInitialPosition, duration: distance / speed)
            ]))
        ]))
    }
}

protocol SpeedController {
    var delegate: SpeedControllee? { get set }
}

protocol SpeedControllee: AnyObject {
    /// - Parameters:
    ///   - velocity: [point/sec]
    func onSpeedChanged(speed: Double)
}
