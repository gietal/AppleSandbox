
const log = (msg) => {
  const p = document.createElement('p')
  p.textContent = msg
  document.querySelector('#log').append(p)
}

// the name has to match the registered userContentController
// webkit.messageHandlers.<name>.onMessage
// webkit.messageHandlers.<name>.postMessage

// to receive messages from native
webkit.messageHandlers.bridge.onMessage = (msg) => {
  log('msg from native:' + msg)
}

document.querySelector('button').addEventListener('click', () => {
  log('button Clicked')
  // send messages to native
    
    // cant convert
//  webkit.messageHandlers.bridge.postMessage('{"msg": "hello?", "key1": "val1", "id": ' + Date.now() + '}')
//    webkit.messageHandlers.handler2.postMessage('{"msg": "hello?", "key1": "val2", "id": ' + Date.now() + '}')
//    webkit.messageHandlers.bridge.postMessage('{"key1": "val1"}')
    webkit.messageHandlers.bridge.postMessage({"key1": "val1"})
})
