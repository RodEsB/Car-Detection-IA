import SwiftUI
import AVFoundation
import Vision
import CoreML
import Foundation


struct ModelView: View {
    @Binding var presentSheet : Bool
    
    var body: some View {
        VStack{
            HStack{
                
                Text("Point the Camera at a Car...")
                    .foregroundStyle(.black)
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                
                Spacer()
                Image(systemName: "x.square.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundStyle(Color.gray)/*.opacity(0.5)*/
                .onTapGesture {
                    presentSheet = false
                }
                
            }
            .padding(10)
            Spacer()
            
            RealTimeCameraView()
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .padding(10)
            Spacer()
            
        }
        .onDisappear{
            presentSheet = false
        }
        .background(Color(hex: "CF0505"))
        
    }
}

struct RealTimeCameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraViewController {
        CameraViewController()
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let detectionOverlay = CALayer()
    
    // Color label mapping
    let colorLabels: [Int: String] = [
        0: "Black",
        1: "Blue",
        2: "Green",
        3: "Red",
        4: "White",
        5: "Yellow"
    ]
    
    // Dictionary to store smoothed bounding boxes
    private var boundingBoxBuffer: [String: CGRect] = [:]
    private let smoothingFactor: CGFloat = 0.7 // Adjust this for more or less smoothing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCamera()
        setupDetectionOverlay()
    }
    
    func setupCamera() {
        captureSession.sessionPreset = .high
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            fatalError("No camera available")
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            captureSession.addInput(videoInput)
        } catch {
            fatalError("Error configuring camera input: \(error.localizedDescription)")
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraFrameProcessingQueue"))
        videoOutput.alwaysDiscardsLateVideoFrames = true
        captureSession.addOutput(videoOutput)
        
        // Add the preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        
        // Start the camera session on a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func setupDetectionOverlay() {
        detectionOverlay.frame = view.bounds
        detectionOverlay.masksToBounds = true
        view.layer.addSublayer(detectionOverlay)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        performDetection(on: pixelBuffer)
    }
    
    func performDetection(on pixelBuffer: CVPixelBuffer) {
        guard let model = try? CarDetectionModel(configuration: MLModelConfiguration()),
              let visionModel = try? VNCoreMLModel(for: model.model) else {
            return
        }
        
        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
            DispatchQueue.main.async {
                self?.drawBoundingBoxes(for: results)
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Error performing detection: \(error)")
        }
    }
    
    func drawBoundingBoxes(for observations: [VNRecognizedObjectObservation]) {
        detectionOverlay.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        guard let previewLayer = previewLayer else { return }
        
        for observation in observations {
            guard observation.confidence > 0.2 else { continue } // Filter low-confidence results
            
            let boundingBox = observation.boundingBox
            let transformedBoundingBox = previewLayer.layerRectConverted(fromMetadataOutputRect: boundingBox)
            let identifier = observation.labels.first?.identifier ?? "unknown"
            
            // Smooth bounding box using previous value
            let smoothedBoundingBox: CGRect
            if let previousBox = boundingBoxBuffer[identifier] {
                smoothedBoundingBox = CGRect(
                    x: smoothingFactor * previousBox.origin.x + (1 - smoothingFactor) * transformedBoundingBox.origin.x,
                    y: smoothingFactor * previousBox.origin.y + (1 - smoothingFactor) * transformedBoundingBox.origin.y,
                    width: smoothingFactor * previousBox.width + (1 - smoothingFactor) * transformedBoundingBox.width,
                    height: smoothingFactor * previousBox.height + (1 - smoothingFactor) * transformedBoundingBox.height
                )
            } else {
                smoothedBoundingBox = transformedBoundingBox
            }
            boundingBoxBuffer[identifier] = smoothedBoundingBox
            
            // Map model output to color labels
            let label = getColorLabel(from: identifier)
            
            // Draw bounding box
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = smoothedBoundingBox
            shapeLayer.borderColor = UIColor.red.cgColor
            shapeLayer.borderWidth = 2.0
            detectionOverlay.addSublayer(shapeLayer)
            
            // Add label
            let textLayer = CATextLayer()
            textLayer.string = "\(label) (\(String(format: "%.2f", observation.confidence)))"
            textLayer.fontSize = 14
            textLayer.foregroundColor = UIColor.white.cgColor
            textLayer.backgroundColor = UIColor.red.withAlphaComponent(0.7).cgColor
            textLayer.frame = CGRect(
                x: smoothedBoundingBox.origin.x,
                y: smoothedBoundingBox.origin.y - 20,
                width: 150,
                height: 20
            )
            detectionOverlay.addSublayer(textLayer)
        }
    }
    
    func getColorLabel(from identifier: String) -> String {
        guard let index = Int(identifier), let label = colorLabels[index] else {
            return "unknown"
        }
        return label
    }
}

