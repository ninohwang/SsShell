# 关于 | about

## `mkFilesBasedOnRedux.sh`

### 命令行效果示意

1.
```shell
$ sh mkFilesBasedOnRedux.sh --help
sh <thisShell>.sh <fileName> <-v|--> <-f|--> <pathTo|-->
     fileName    你想要建立的文件（目录）群
     -v, --view  组件文件以 view 结尾，eg: NameView.js
     -f, --func, --fs, --funcs  模板使用函数式组件; fs 表征模板下为具名函数 （s: specific
     pathTo      决定多极目录
```

2.
```shell
$ sh mkFilesBasedOnRedux.sh tik-tok-main -v -fs path/to/detail2
====请稍后在  src/reducer/index.js  中引入新建 TikTokMainModel 文件====
====点击以下文本，打开窗口===
path:src/view/path/to/detail2/tik-tok-main/TikTokMainView.js
path:src/reducer/path/to/detail2/tik-tok-main/TikTokMainModel.js
path:src/actions/path/to/detail2/tik-tok-main/TikTokMainActions.js
```

### upd
- 更改缩进为空格符；添加第四个入参 pathToDetail
- 支持中划线命名
- 路径去除冗余的(\/\/), 命令窗口友好输出

### test: 
alias: 如下的 mf4rdx 是 `sh thisShell.sh` 的别名
- `mf4rdx`
- `mf4rdx  `
- `mf4rdx --`
- `mf4rdx -h` | `mf4rdx --help`
- `mf4rdx some-comp-prev`
- `mf4rdx someComp`
- `mf4rdx someComp - -`
- `mf4rdx someComp -- --`    
- `mf4rdx someComp ------ -----------------------`
- `mf4rdx someComp -x` | `mf4rdx someComp --xhere`
- `mf4rdx someComp -- -x` | `mf4rdx someComp -- --xhere`
- `mf4rdx othComp -v` | `mf4rdx othComp -v --` | `mf4rdx othComp -v -f`
- `mf4rdx someComp -- -f`
- `mf4rdx someComp -- -fs`
- `mf4rdx heyPorsche -- -f song/nelly`
- `mf4rdx heyPorsche -- -f /song/nelly`
- `mf4rdx hide-one -v -fs /////path////to////detail//////////`

### 说明：
- 此脚本仅适用于该项目下简单的 src/view src/reducer src/actions 相关文件的创建 🎈可以自己自定义更改脚本
- 约定第一个传入的变量用以创建指定目录
- 调用如 `sh <thisShell>.sh <fileName> <-v> <-f> <pathTo>` (-v: 如输入 "demo", 则会创建"Demo.js 文件"；输入 "demo -v", 则会创建"DemoView.js"文件; -f 创建的是函数式组件)
- 使用 eg: sh mkFilesBasedOnRedux.sh demo
- eg2: `sh mkFilesBasedOnRedux.sh demo -v -f`
- eg3: `sh mkFilesBasedOnRedux.sh demo -- -f`
- eg4: `sh x.sh demo -- -- /foo`
- eg5: `sh x.sh demo -- -- foo`
- eg6: `sh x.sh demo -- -- /foo/bar`

# 关于 | about

## `mkYe.sh`

### 期望
- 一般可见这样的目录结构，新建组件文件夹 eg: comp-side
- 其下有 index.ts (非组件定义，用作向外导出) ; CompSide.tsx; AppendOne.tsx

### mayTodo
- bash 下操作，添加文本到已存在文件的指定的某一行，场景： 比如在 comp-side 已有的 index.ts 中，新加一组件 CompOth.tsx，则自动在 index.ts 下 import 语句末尾加上 `import CompOth from './CompOth'` 以及 export 语句中加上 `CompOth,` 的具名导出

### 调用形如
- `mkYe comp-side -v -s <path-to>`
- `mkYe comp-append-one -- -s <path-to> -a`

```markdown
src
  view | pages
    comp-side
        index.ts
        CompSide.tsx
        AppendOne.tsx
```

### test
alias: 如下的 mkYe 是 `sh thisShell.sh` 的别名
- `mkYe`
- `mkYe  `
- `mkYe --`
- `mkYe -h` | `mkYe --help`
- `mkYe home-tree`
- `mkYe home-tree - -`
- `mkYe home-tree -- --`    
- `mkYe home-tree ------ ---------------------`
- `mkYe home-tree -x` | `mkYe home-tree --xhere`
- `mkYe home-tree -- -x`
- `mkYe home-tree -v` | `mkYe home-tree -v --` | 
- `mkYe home-tree -v -s`
- 
- `mkYe may-prev -v -s par/sub`
- `mkYe may-cur -- -- par/sub/may-prev -a`
- `mkYe may-then -- -- par/sub/may-prev -a`
- `mkYe may-next -- -- par/sub/may-prev` (如此可能是误输入)
- `mkYe may-oth -- -- par/oth -a` (如此可能是误输入)
- `mkYe may-oth-help -- -- par/oth -a` (如此可能是误输入)
- `mkYe hide-one -v -s /////path////to////detail//////////`
- `mkYe hide-par -- -- //////path///to///detail////hide-one -a`

# mayTo
### todo
1. 可优化：项目引入路径别名前提下，准确初始化 `"[path/to]/$fileNameActions.js"` `"[path/to]/utils/BaseUtil`
2. 若需要脚本执行时允许文件夹为中划线风格，而文件名为驼峰式 `sh <thisShell>.sh name-cafe`
3. 命令的规范判断
4. BoolTag 的引入，一些执行语句其实可以跳过
### mayTodo:
- 正则，如对中划线转驼峰式的需求：
- 标准：echo hello-april_month | sed -r 's/(^|-|_)(\w)/\U\2/g'
- 其中 `\2` 表达的是（\w）匹配所指；
- bash（linux) 命令下正则细节暂模糊，如
- \U\2 的顺序; \U 大小写; \1\U\2 和 \U\1\2 [直觉：表示操作的命令放在最前面] 比如 
  - \u 操作的大小写区别 `sed -r 's/(^|-|_)(\w)/\u\1\2/g'])` , `sed -r 's/(^|-|_)(\w)/\U\1\2/g'`

### mayTodo: 
0. 惊觉 redux 样板代码下，脚本生成**函数式组件时**或应使用 redux / react-redux 提供的 useXxx hook; 而不用再 `connect(map1,map2)(Comp)` 了, 忘了。
1. 文件名的合法判断；
1. 暂不清楚 shell 脚本书写时 if 判断的语法细节，比如（圆扩/单中括号/双中括号）`[ "$dirName" == "" ] || [[ "$dirName" =~ ^\-.* ]]`
2. 表达式中空格有无的语法，比如赋值操作，比如判断操作;
3. 三元表达式的写法...
4. 是否有作用域，如 if 下声明的变量[直觉：没有;更正：这个得看 Shell 下局部作用域变量的定义，暂不了解，或相关 `local`]；以及是否允许变量（如 contentView 等**长字符串**变量的初始化）写在最后甚至函数调用之后[直觉: 允许;更正，似乎无提前，脚本似从上到下读取执行,自己脚本中虽然把 `contentView` 的初始化放到了最后，但是也是放在了函数调用之前。暂未确认]，而可脚本运行时（或之前）就已经声明提前
5. 有看过相等判断，考虑到输入为空的情况下：所以有写法如 `"$foo"x == ""x` 以避免报错，但是本脚本下几次更改下来已经试不出其使用场景，如控制台直接输入`sh x.sh` 或者 `sh x.sh    ` 都不会有意外报错或警告了？
6. js/ts 的缩进空格自己偏向于2空格的缩进风格，后续是否可以脚本短命令中可控？
7. 快速删除此脚本中的冗余注释，或者还是用脚本执行 🎈
8. 短命令另种形式的支持 eg: `sh x.sh -m <fileName> -vft` 
        (思路：区别对待单中划线紧跟字母的标识，允许其符合多个短命令且无视顺序，如 ls -ahl，然后对于非中划线开头的命令需要有前置命令)：形如： 
        `sh x.sh --makeFile <fileName> -vf --path <pathTo>` 
        `sh x.sh -m <fileName> -vf -p <pathTo>` 
        `sh x.sh -p <pathTo> -m <fileName> -fv`
        ；另此时，自定的 -fs 就不再适合这个约定下使用了
9. BoolTag 的引入，一些执行语句其实可以跳过 （如 contentView 等变量的赋值）
10. 如果有 echo 到具名文件的操作，则这之前不再需要额外的 touch 创建文件操作
11. 基于路径别名准确初始化 `"[path/to]/$fileNameActions.js" 时，还需要用上路径拼贴合并多余的 `\/\/`
    或还是利用 sed 正则处理： 
        `echo view/par//sub///ext | sed -r 's/((\/)(\/)+)/\2/g'` $>>    `view/par/sub/ext`
```sh
HdlPathBySed='s/((\/)(\/)+)/\2/g'

p1=$( echo ///hello/path//sub///ext | sed -r $HdlPathBySed )
echo $p1
```
12. 这两个 sh 脚本的功能后期或应用 nodejs 实现？
