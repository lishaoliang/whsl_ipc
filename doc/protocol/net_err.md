## 附录1、SDK错误码

* 系统错误码范围[0, 4095]

|  16进制  | 10进制值  |   备注    |
|:---------:|:--------- |:--------- |
| 0x0000   | 0         | 成功 |
| 0x0001   | 1         | SDK未初始化, 或初始化错误 |
| 0x0002   | 2         | 等待超时 |
| 0x0003   | 3         | 参数错误 |
| 0x0004   | 4         | 打开失败或没有打开对应的对象 |
| 0x0005   | 5         | 无数据,或没有新数据刷新 |

## 附录2、协议错误码

* 协议错误码范围[4096,32767]
* 协议错误码起始 B = 4096
* 协议错误码结束 E = 32767

|  相对值  | 10进制值  |   备注    |
|:---------:|:--------- |:--------- |
| B + 1    | 4097      | 不支持的协议命令 |
| B + 2    | 4098      | 未找到; 没找到数据,配置项,网页等 |
| B + 3    | 4099      | 协议参数错误 |
