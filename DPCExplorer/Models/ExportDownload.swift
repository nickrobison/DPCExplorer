//
//  ExportDownload.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/17/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation

class ExportDownload {
    let output: JobOutputModel
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?

    init(output: JobOutputModel) {
        self.output = output
    }
}
