# 开始

`````text
-generator
├── prompt
│   ├── main
│   │   └── main.md
│   ├── <module-name>
│   │   └── <module-name>.md
│   └── ...
│
└── template
    ├── main
    │   ├── *.html
    │   └── ...
    ├── <module-name>
    │   ├── *.html
    │   └── ...
    └── ...

```

````text
-参考上面的结构，在根目录generator，这个文件夹下有两个子文件夹 ， prompt 和 template ， 这两个子文件夹会包含若干的子文件夹，例如main，prompt的main文件夹会包含一个main.md,这是对main模块的需求说明，同理，template也会包含一个main文件夹，main文件夹会包含若干的html文档，这是设计文档导出的模版文件，你需要做的是根据这些需求
文档和模版生成flutter的工程，给ios和安卓用的。
`````
