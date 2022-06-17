
/**
 * 与app通信插件（需要放在网页最前面！！！）
 * 
 * 发送的消息仅支持json字符串, 包含三个字段
 * - name: string 必填。不能重复的ID。
 * - message: string 必填。发送的消息。
 * 
 * 如果接收到app的消息中id不为空，web端则会通过innerBus分发对应事件(web端需要提前监听此事件)
 * 
 */
var ryJSBridge = (function (innerBus, listenName, appChannel) {

  // 订阅发布系统
  

  // id用户回调事件定位
  var messageSendCount = 0

  /**
   * 注册提供给app调用的方法
   */
  window[listenName] = function (message) {
    
    try {
      res = JSON.parse(message)
    } catch(err){
      res = {
        name: 'parseError',
        message: '报错了 =>' + message
      }
    }

    innerBus.emit(res.name, message)
  }

  /**
   * 向app发送消息
   * @param {string} message 事件ID，用于消息回复时，判断是否是对发出的指令
   * @param {string} message 传递的数据
   */
  function channel (name, message) { 
    var sendToApp = window[appChannel]
    if(!sendToApp) {
      console.error('app未提供与web通信的 "'+ appChannel + '" 方法');
      return;
    }
    const msg = JSON.stringify({
      name,
      message
    })
    sendToApp.postMessage(msg);
  }

  /**
   * 向app发送消息（不需要等待回复的）
   * @param {string} message 传递的数据
   */
  function send (message) {
    messageSendCount++
    channel('', message)
  }

  /**
   * 向app发送消息（要等待异步回复）
   * @param {string} message 传递的数据
   * @return Promise<string>
   */
  async function asyncMessage (message) {
    return new Promise(function (resolve) {
      messageSendCount++
      var listenMessageId = 'autoId-' + messageSendCount
      innerBus.once(listenMessageId, resolve)
      channel(listenMessageId, message)
    })
  }

  return {
    send,
    asyncMessage,
  }
})(iBus, 'RyListenAppEvent', 'RyH5AppChannel');