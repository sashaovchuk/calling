import Foundation
import PushKit
import Capacitor
import CallKit
/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CallingPlugin)
public class CallingPlugin: CAPPlugin, CXProviderDelegate {
    private let implementation = Calling()
    var callAnsweredHandler: ((Bool) -> Void)?
    var voIPToken: String = ""
    var voIPTokenHandler: ((Bool) -> Void)?

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }

    // Для витяжки VoIP токена
    @objc func getVoIPToken(_ call: CAPPluginCall) {
        self.voipRegistration()
        print("WORKKK \(voIPToken)")
        self.voIPTokenHandler = { [self] answered in
            if answered {
                call.resolve(["token": voIPToken])
            } else {
                call.reject("token is empty")
            }
        }
    }

    func voipRegistration() {
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue:DispatchQueue.main)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
    }

    public func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let parts = pushCredentials.token.map { String(format: "%02.2hhx", $0) }
        voIPToken = parts.joined()
        if ((voIPToken.count) != 0) {
            voIPTokenHandler?(true)
        } else {
            voIPTokenHandler?(false)
        }
    }

    // Для подій дзвінка
    @objc public func providerDidReset(_ provider: CXProvider) {

    }
    public func provider(_: CXProvider, perform action: CXStartCallAction) {
        print("CXStartCallAction")
        action.fulfill()
    }
    public func provider(_: CXProvider, perform action: CXAnswerCallAction) {
        print("CXAnswerCallAction()")
        callAnsweredHandler?(true)
        action.fulfill()
    }
    public func provider(_: CXProvider, perform action: CXEndCallAction) {
        print("CXEndCallAction()")
        callAnsweredHandler?(false)
        action.fulfill()
    }


    // Вхідний дзвінок
    @available(iOS 14.0, *)
    @objc func incomingCall(_ call: CAPPluginCall) {
        let user = call.getString("username") ?? ""
        let isVideo = call.getBool("video") ?? false

        let config = CXProviderConfiguration(localizedName: "Dober")
        config.supportsVideo = true
        config.supportedHandleTypes = [.emailAddress, .phoneNumber, .generic]
        let provider = CXProvider(configuration: config)
        provider.setDelegate(self, queue: nil)

        let id = UUID()
        let callController = CXCallController()
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: user)
        update.hasVideo = isVideo
        provider.reportNewIncomingCall(with: id, update: update) { error in
            if let error = error {
                print(String(describing: error))
                call.reject("Incoming Call NOT work")
                return
            } else {
                print("Incoming Call work")

                self.callAnsweredHandler = { answered in
                    if answered {
                        call.resolve(["status": "accepted"])

                        // Для цього потім треба буде зробити ще одну функцію
                        let endCallAction = CXEndCallAction(call: id)
                        let transaction = CXTransaction(action: endCallAction)
                        callController.request(transaction) { error in
                            if let error = error {
                                print(String(describing: error))
                                // Обробте помилку під час завершення дзвінка, якщо потрібно
                                return
                            } else {
                                print("Call ended")
                                // Виконайте необхідні дії після завершення дзвінка
                                return
                            }
                        }
                        //

                    } else {
                        call.resolve(["status": "decline"])
                    }
                }
                return
            }
        }
    }

    // Вихідний дзвінок
    @available(iOS 14.0, *)
    @objc func outcomingCall(_ call: CAPPluginCall) {
        let user = call.getString("username") ?? ""
        let isVideo = call.getBool("video") ?? false

        let config = CXProviderConfiguration(localizedName: "Dober")
        config.supportsVideo = true
        config.supportedHandleTypes = [.emailAddress, .phoneNumber, .generic]
        let provider = CXProvider(configuration: config)
        let callController = CXCallController()
        provider.setDelegate(self, queue: nil)

        let id = UUID()
        print("id ->", id, UUID())

        let handle = CXHandle(type: .generic, value: user)
        let action = CXStartCallAction(call: id, handle: handle)
        action.isVideo = isVideo
        let transaction = CXTransaction(action: action)
        callController.request(transaction) { error in
            if let error = error {
                print(String(describing: error))
                call.reject("Outcoming Call NOT work")
            } else {
                print("Outcoming Call work")
                call.resolve(["status": "accepted"])

                // Для цього потім треба буде зробити ще одну функцію
                let endCallAction = CXEndCallAction(call: id)
                let transaction = CXTransaction(action: endCallAction)
                callController.request(transaction) { error in
                    if let error = error {
                        print(String(describing: error))
                        // Обробте помилку під час завершення дзвінка, якщо потрібно
                        return
                    } else {
                        print("Call ended")
                        // Виконайте необхідні дії після завершення дзвінка
                        return
                    }
                }
                //

            }
        }

        provider.reportOutgoingCall(with: id, startedConnectingAt: nil)
    }
}
