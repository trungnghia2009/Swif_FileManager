///https://fxstudio.dev/file-manager-trong-10-phut-swift/

//
//  ViewController.swift
//  FileManager
//
//  Created by trungnghia on 11/10/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    private let fileManger = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Read file from Bundle.main.url
        if let imageURL = getFilePathFromBundle(name: "girl", type: "jpg"),
           let data = try? Data(contentsOf: imageURL, options: .mappedIfSafe) {
            imageView1.image = UIImage(data: data)
        }
        
        if let txtURL = getFilePathFromBundle(name: "note", type: "txt"),
           let data = try? Data(contentsOf: txtURL, options: .mappedIfSafe) {
            let content = String(data: data, encoding: .utf8)
            print("Content File: \(content ?? "N/A")")
        }
        
        // Basic to get Document Directory
        print("getDocumentsDirectory(): \(getDocumentsDirectory())")
        print("getDocumentFilePath(fileName:): \(getDocumentFilePath(fileName: "LocalData/FileName.txt"))")
        
        // Check file exist
        checkFileExist(fileName: "LocalData/FileName.txt")
        
        // From URL extension
        let url = getDocumentFilePath(fileName: "FileName.txt")
        url.checkFileExist()
        
        // Read file from Document Directory
        let _ = readFile(fileName: "note.txt")
        
        // Write file then read
        let fileName = "girl.jpg"
        guard let dataURL = getFilePathFromBundle(name: "girl", type: "jpg"),
              let data = try? Data(contentsOf: dataURL, options: .mappedIfSafe) else { return }
        writeFile(to: fileName, content: data)
        
        if let imageData = readFile(fileName: fileName) {
            imageView2.image = UIImage(data: imageData)
        }
        
        // Get file Attributes
        getFileAttributes(fileName: "girl.jpg")
    }
    
    // MARK: File Path
    private func getFilePathFromBundle(name: String, type: String) -> URL? {
        let url = Bundle.main.url(forResource: name, withExtension: type)
        return url
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getDocumentFilePath(fileName: String) -> URL {
        let documentPath = getDocumentsDirectory()
        let filePath = documentPath.appendingPathComponent(fileName)
        return filePath
    }
    
    @discardableResult
    private func checkFileExist(fileName: String) -> Bool {
        let filePath = getDocumentFilePath(fileName: fileName)
        let fileManger = FileManager.default
        
        if fileManger.fileExists(atPath: filePath.path) {
            print("FILE: \(fileName) is AVAILABLE")
            return true
        } else {
            print("FILE: \(fileName) NOT AVAILABLE")
            return false
        }
    }
    
    // MARK: File Handle
    func readFile(fileName: String) -> Data? {
        if checkFileExist(fileName: fileName) {
            let filePath = getDocumentFilePath(fileName: fileName)
            do {
                let data = try Data(contentsOf: filePath)
                return data
            } catch {
                print("Can not read file")
                return nil
            }
        } else {
            print("readFile(fileName:): File not available.")
            return nil
        }
    }
    
    @discardableResult
    func writeFile(to fileName: String, content: Data) -> Bool {
        if checkFileExist(fileName: fileName) {
            print("writeFile(): \(fileName) existed")
            return true
        }
        
        let filePath = getDocumentFilePath(fileName: fileName)
        
        do {
            try content.write(to: filePath)
            print("writeFile() successfully")
            return true
        } catch {
            print("Can not write file")
            return false
        }
    }
    
    func getFileAttributes(fileName: String) {
        let fileSupperManPath = getDocumentFilePath(fileName: fileName).path
        do {
            let fileManager = FileManager.default
            let attributes = try fileManager.attributesOfItem(atPath: fileSupperManPath)
            print("File Attributes:")
            for item in attributes {
                print(item)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func moveFile(atPath: String, toPath: String) {
        do {
            try fileManger.moveItem(atPath: atPath, toPath: toPath)
        } catch {
            print("Cannot move file, \(error)")
        }
    }
    
    func copyFile(atPath: String, toPath: String) {
        do {
            try fileManger.copyItem(atPath: atPath, toPath: toPath)
        } catch {
            print("Cannot copy item from \(atPath) to \(toPath)")
        }
    }
    
    func removeFile(atPath: String) {
        do {
            try fileManger.removeItem(atPath: atPath)
        } catch {
            print("Cannot remove item at \(atPath)")
        }
    }

}



extension URL    {
    
    @discardableResult
    func checkFileExist() -> Bool {
        let path = self.path
        if (FileManager.default.fileExists(atPath: path))   {
            print("FILE AVAILABLE")
            return true
        }else        {
            print("FILE NOT AVAILABLE")
            return false;
        }
    }
}
