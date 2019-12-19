# sl ipc项目开发及二次开发指南

## 一、概述
sl ipc项目是基于海思hi35xx等系列芯片，针对工业相机等领域的音视频处理。

### 1.1 开发环境
```
* 主芯片：hi3516av100, hi3516av200, hi3519v101等
* ARM架构：ARMv7 Processor rev 5 (v7l), ARMv7 Processor rev 2 (v7l)等
* 操作系统：linux-3.x
```

### 1.2 开发语言

#### 1.2.1 C语言
```
* 负责系统、硬件相关部分
* 负责性能热点部分
* 负责基础组件、模块实现
```

#### 1.2.1 Lua语言
```
* 负责主调度流程
* 负责业务逻辑
* 与C语言形成互补关系，补充C不擅长的领域
* 降低研发难度与研发周期
```

## 二、网络协议
### 1. [NSPP私有协议](./blob/master/doc/net/nspp/nspp.md)
### 3. [HTTP协议](./blob/master/doc/net/http/nspp.md)
### 2. [RTSP协议](./blob/master/doc/net/rtsp/rtsp.md)
### 4. [HTTP-FLV协议](./blob/master/doc/net/http-flv/http_flv.md)
### 5. [HTTP-NSPP私有协议](./blob/master/doc/net/http-nspp/http_nspp.md)

## 三、客户端开发



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
