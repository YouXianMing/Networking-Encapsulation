# Networking-Encapsulation

![demo.gif](http://images.cnitblog.com/blog/607542/201409/231942047644298.gif)

> 特点

* 用`依赖倒置原则`设计的网络类API,隔离AFNetworking使用细节,方便后续升级管理(2.x与3.x系列共用一个抽象父类接口).
* 实现层遵循`迪米特法则`,看官如果要考虑到项目后续的维护性(比如升级AFNetworking的版本而不修改任何的代码),请不要添加多余的属性和方法,这是为了你好.

> 说明

* 2.x 版本暂停更新
* 3.x 版本长期更新
* AFNetworking-Deprecated为弃用版本

