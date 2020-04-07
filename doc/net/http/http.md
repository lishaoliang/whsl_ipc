# HTTP协议

## 一、路由

|   根路径   | 默认端口  |   类型  |   备注    |
|:--------- |:--------- |:--------- |:--------- |
| /luaflv   | 80        | 长连接    | 音视频流媒体流 |
| /luanspp  | 80        | 长连接    | 音视频流媒体流,事件流|
| /luajson  | 80        | 短连接    | 会话控制协议 |
| /         | 80        | 短连接    | web静态主页 |
| /*        | 80        | 短连接    | www静态文件下载 |

* 保留路由: "/lua*"

## 二、码流

|   类型   | 请求路径  |
|:------- |:--------- |
| HTTP-FLV主码流  | http://192.168.1.247:80/luaflv/chnn0/idx0 |
| HTTP-FLV子码流  | http://192.168.1.247:80/luaflv/chnn0/idx1 |
| HTTP-NSPP主码流 | http://192.168.1.247:80/luanspp/chnn0/idx0 |
| HTTP-NSPP子码流 | http://192.168.1.247:80/luanspp/chnn0/idx1 |

### 3.1 [HTTP-FLV](../http-flv/http_flv.md)
### 3.2 [HTTP-NSPP](../http-nspp/http_nspp.md)


## 三、WWW静态网页



## 四、控制协议
