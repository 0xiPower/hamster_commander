
frok: 本项目是东北大学软件学院“仓颉社区软件工程”课程教学项目，用于介绍仓颉语言的多种关键特性。

<div align="center">
<h1>hamster_commander</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.0.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.55.3-brightgreen" style="display: inline-block;" />
</p>

## <img alt="" src="./doc/readme-image/readme-icon-introduction.png" style="display: inline-block;" width=3%/> 1 介绍

### 1.1 项目特性

本项目是东北大学软件学院“[仓颉社区软件工程](https://www.bilibili.com/video/BV18b4se5E1i/)”课程教学项目，用于介绍仓颉语言的多种关键特性。

![](cover.png)

### 1.2 分支说明

`main` 分支采用仓颉0.55.3版本，与2024年秋季课程采用的仓颉版本一致。

以四位数字_四位数字开头的分支如 `1400_0200_ioc` 大体上与课程的章节相对应，但有部分章节无法做到完美对应，仅供参考。

`564` 分支采用仓颉0.56.4版本。

## <img alt="" src="./doc/readme-image/readme-icon-framework.png" style="display: inline-block;" width=3%/> 2 架构

### 2.1 项目结构

```shell
.
├── CHANGELOG.md
├── cjpm.lock
├── cjpm.toml
├── doc
│   └── readme-image
│       ├── readme-icon-compile.png
│       ├── readme-icon-contribute.png
│       ├── readme-icon-framework.png
│       └── readme-icon-introduction.png
├── README.MD
└── src
    ├── commander.cj
    ├── main.cj
    ├── models
    │   └── history.cj
    ├── services
    │   ├── command_service_constant
    │   │   └── command_service_constant.cj
    │   ├── file_history_store.cj
    │   ├── i_command_service.cj
    │   ├── i_history_store.cj
    │   ├── secret_store.cj
    │   └── spark_command_service.cj
    └── test
        ├── commander_test.cj
        ├── commander_test.cj.macrocall
        ├── secret_store_test.cj.macrocall
        └── services
            ├── file_history_store_test.cj
            ├── file_history_store_test.cj.macrocall
            ├── secret_store_test.cj
            └── secret_store_test.cj.macrocall
```

### 2.2 接口说明

* `Commander` ：提供所有功能的统一调用API。
* `ICommandService` ：大模型命令生成服务接口。
* `SparkCommandService` ：星火大模型命令服务。
* `IHistoryStore` ：历史命令存储服务接口。
* `FileHistoryStore` ：基于文件的命令存储服务。
* `SecretStore` ：密钥存储。

## <img alt="" src="./doc/readme-image/readme-icon-compile.png" style="display: inline-block;" width=3%/> 3 使用说明

### 3.1 编译构建（Win/Linux）

```
cjpm update
cjpm build
```

### 3.2 功能示例

设置密钥：

```
cjpm run --run-args "set-key-secret [key] [secret]"
```

生成命令：

```
cjpm run --run-args "list all files in the current folder"
```

列出历史命令：

```
cjpm run --run-args list
```

其他命令请参考主函数。

## <img alt="" src="./doc/readme-image/readme-icon-contribute.png" style="display: inline-block;" width=3%/> 4 参与贡献

本项目由 [SIGCANGJIE / 仓颉兴趣组](https://gitcode.com/SIGCANGJIE) 实现并维护。技术支持和意见反馈请提Issue。

本项目采用Apache License Version 2.0，欢迎给我们提交PR，欢迎参与任何形式的贡献。

本项目committer：[@zhangyin-gitcode](https://gitcode.com/zhangyin_gitcode)
