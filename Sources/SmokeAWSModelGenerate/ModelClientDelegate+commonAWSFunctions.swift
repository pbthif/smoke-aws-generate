// Copyright 2019-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.
// A copy of the License is located at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// or in the "license" file accompanying this file. This file is distributed
// on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
// express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//
// ModelClientDelegate+commonAWSFunctions.swift
// SmokeAWSModelGenerate
//

import Foundation
import ServiceModelCodeGeneration
import ServiceModelEntities
import ServiceModelGenerate
import CoralToJSONServiceModel

extension ModelClientDelegate {
    func addAWSClientCommonFunctions(fileBuilder: FileBuilder, baseName: String,
                                     clientAttributes: AWSClientAttributes,
                                     codeGenerator: ServiceModelCodeGenerator<TargetSupportType>,
                                     targetsAPIGateway: Bool,
                                     contentType: String,
                                     sortedOperations: [(String, OperationDescription)],
                                     defaultInvocationTraceContext: InvocationTraceContextDeclaration,
                                     entityType: ClientEntityType) {
        addAWSClientInitializerAndMembers(fileBuilder: fileBuilder,
                                          baseName: baseName,
                                          clientAttributes: clientAttributes,
                                          codeGenerator: codeGenerator,
                                          targetsAPIGateway: targetsAPIGateway,
                                          contentType: contentType,
                                          sortedOperations: sortedOperations,
                                          defaultInvocationTraceContext: defaultInvocationTraceContext,
                                          entityType: entityType)
        
        addAWSClientDeinitializer(fileBuilder: fileBuilder,
                                  baseName: baseName,
                                  clientAttributes: clientAttributes,
                                  codeGenerator: codeGenerator,
                                  targetsAPIGateway: targetsAPIGateway,
                                  contentType: contentType,
                                  entityType: entityType)
        
        if entityType.isGenerator {
            addAWSClientGeneratorWithReporting(
                fileBuilder: fileBuilder, baseName: baseName,
                codeGenerator: codeGenerator, targetsAPIGateway: targetsAPIGateway,
                contentType: contentType)
            
            addClientGeneratorWithTraceContext(
                fileBuilder: fileBuilder, baseName: baseName,
                codeGenerator: codeGenerator, targetsAPIGateway: targetsAPIGateway,
                contentType: contentType)
            
            addAWSClientGeneratorWithLogger(
                fileBuilder: fileBuilder, baseName: baseName,
                codeGenerator: codeGenerator, targetsAPIGateway: targetsAPIGateway,
                invocationTraceContext: clientAttributes.defaultInvocationTraceContext, contentType: contentType)
        }
        
        if case .configurationObject = entityType {
            fileBuilder.appendLine("""
                
                internal func createHTTPOperationsClient(eventLoopOverride: EventLoop? = nil) -> HTTPOperationsClient {
                    return HTTPOperationsClient(
                        endpointHostName: self.endpointHostName,
                        endpointPort: self.endpointPort,
                        contentType: self.contentType,
                        clientDelegate: self.clientDelegate,
                        timeoutConfiguration: self.timeoutConfiguration,
                        eventLoopProvider: .shared(eventLoopOverride ?? self.eventLoopGroup),
                        connectionPoolConfiguration: self.connectionPoolConfiguration)
                }
                """)
        }
    }
}
