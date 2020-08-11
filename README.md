# whsl ipc项目
whsl ipc项目是基于海思hi35xx等系列芯片，针对工业相机等领域的音视频处理软件。

## 声明
* 本文档为非正式文档，仅供技术参考。
* 如有差异，请以官方正式文档为准。

## 规划
### [2018年规划](./images/whsl_ipc_2018.jpg)


## 框架流程
### [Arm环境文件结构](./doc/opt/opt.md)
### [Lua脚本文件结构](./doc/src_lua/src_lua.md)
### [项目模块组织](./doc/framework/fw_modules.md)
### [软件启动流程]
### [socket流程]
### [音视频流程]

## 网络协议
[协议描述](https://github.com/lishaoliang/l_sdk_doc)


## 流媒体
* 保留路由: "/lua*"

|   根路径   | 默认端口  |   类型  |   备注    |
|:--------- |:--------- |:--------- |:--------- |
| /luaflv   | 80        | 长连接    | 音视频流媒体流 |
| /luanspp  | 80        | 长连接    | 音视频流媒体流,事件流|
| /luajson  | 80        | 短连接    | 会话控制协议 |
| /         | 80        | 短连接    | web静态主页 |
| /*        | 80        | 短连接    | www静态文件下载 |

|   码流类型   | 请求路径  |
|:----------- |:--------- |
| RTSP主码流      | rtsp://192.168.1.247:80/chnn0/idx0 |
| RTSP子码流      | rtsp://192.168.1.247:80/chnn0/idx1 |
| HTTP-FLV主码流  | http://192.168.1.247:80/luaflv/chnn0/idx0 |
| HTTP-FLV子码流  | http://192.168.1.247:80/luaflv/chnn0/idx1 |

### [NSPP私有协议](./doc/net/nspp/nspp.md)
### [RTSP协议](./doc/net/rtsp/rtsp.md)
### [HTTP协议](./doc/net/http/http.md)
### [HTTP-FLV协议](./doc/net/http-flv/http_flv.md)
### [HTTP-NSPP私有协议](./doc/net/http-nspp/http_nspp.md)

## Demo模拟软件
* Windows7, Windows10 命令行环境
* 相对目录：./l_lua

```
cd ./l_lua
.\ipcamera.exe .\ipc\ipc.lua
```

* 模拟器默认端口: 3456
* 网页地址: http://127.0.0.1:3456

## 其他
### 1. [GitHub仓库](https://github.com/lishaoliang/whsl_ipc), [码云镜像](https://gitee.com/lishaoliang/whsl_ipc)
### 2. [客户端SDK](https://github.com/lishaoliang/l_sdk_doc), [客户端SDK(码云镜像)](https://gitee.com/lishaoliang/l_sdk_doc)
### 3. [版本修改记录](./doc/版本修改记录.md)
### 4. [功能表](./doc/软件功能.xlsx)

## Apache License,Version 2.0

Copyright (c) 2019 武汉舜立软件

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
