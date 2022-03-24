# 若自定义组件在 pages 下面，全局替换 `view` 为 `pages`

# 定义颜色变量
PINK='\e[1;35m' # 粉红
GREEN='\e[1;32m' # 绿
BLUE='\e[1;34m' # 蓝
YELLOW='\e[1;33m' # 黄
RED='\e[1;31m' # 红
RES='\e[0m' # 清除颜色

# 标准缩进
RETRACT='\ \ \ \ '

# 对中划线/下划线命名 一律转为驼峰式; 以及管道符的使用; 
# 以及 sed 命令下正则的使用

dirName=$1
fileNameHead=$( echo "$1" | sed -r 's/(^|-|_)(\w)/\U\2/g' )

# 处理路径中冗余 `\/`
HdlPathBySed='s/((\/)(\/)+)/\2/g'

viewProps=$fileNameHead"Props"

pathToDetail=$4

# 引入表征布尔值的变量
BoolTag=1

# AppendTag=1
if [ "$5" == "-a" -o "$5" == "--append" ];then
    AppendTag=1
else 
    AppendTag=0
fi

if [[ "$2" =~ ^\-v$ || "$2" =~ ^\-\-view$ ]];then
    fileNameView=$fileNameHead"View"
elif [[ "$2" == "" || "$2" =~ ^\-\-+$ ]];then # 允许 --, ---, ----有效
    fileNameView=$fileNameHead
else 
    BoolTag=0
fi

if ! ([ $AppendTag -eq 1 ] || [[ "$5" == "" || "$5" =~ ^\-\-+$ ]]);then
    BoolTag=0
fi

mkFile() { # 函数声明

    # if [ "$dirName" == "" -o "$dirName" == "--" -o "$dirName" == "-" ];then
    if [ "$dirName" == "" ] || [[ "$dirName" =~ ^\-.* && ! "$dirName" =~ ^\-h$ && ! "$dirName" =~ ^\-\-help$ ]];then
        echo -e "未输入合法文件名！执行此脚本需要一个以上入参。或者输入$RED --help -h$RES 查看提示"

    elif [ "$dirName" == "--help" -o "$dirName" == "-h" ];then

        echo -e "sh <thisShell>.sh <fileName> <-v|--> <-s|--> <pathTo|--> <-a|-->
    $RED fileName$RES    你想要建立的文件（目录）群
    $RED -v, --view$RES  组件文件以 view 结尾，eg: NameView.tsx
    $RED -s, --spec$RES  s 表征模板下为具名函数导出
    $RED pathTo$RES      决定多极目录
    $RED -a, --append$RES 不额外创建目录，只在 <pathTo> 指定路径下新建文件（同时 index.ts 存在前提下被更新）
    "

    elif [ $BoolTag -eq 0 ];then
        echo "短命令非法！请严格输入 -v 或 -s 或 -a 或 --view 或 --spec 或 --append 或占位：-- 或 ---"

    else

        contentIndexHead="import $fileNameView from './$fileNameView'"
        
        if [ $AppendTag -eq 1 ];then
            echo "添加文件到路径 src/view/$pathToDetail 下"
            mkdir -p src/view/$pathToDetail
            touch src/view/$pathToDetail/$fileNameView".tsx"  # 此时不再创建 index.ts 以及 .scss 同名组件文件

            opI=src/view/$pathToDetail/index.ts
            opC=src/view/$pathToDetail/$fileNameView".tsx"
            
            contentIndexTail=$fileNameView"," # contentIndexTail 此时用作插入 index.ts 文件的倒数第二行；默认始终将 contentIndexHead 插入 index.ts 文件的第一行

            sed -i "1i $contentIndexHead" $opI # maytodo 这里能否也用到管道符传递呢？

            sed -i "\$i $RETRACT$contentIndexTail" $opI # 注意这里对第一个 `$` 的转义

        else
            mkdir -p src/view/$pathToDetail/$dirName
            touch src/view/$pathToDetail/$dirName/{$fileNameView".tsx",$fileNameView".scss",index.ts}

            opI=src/view/$pathToDetail/$dirName/index.ts
            opC=src/view/$pathToDetail/$dirName/$fileNameView".tsx"

            contentIndexTail=$(cat<<MKYE
export {
    $fileNameView,
}
MKYE
)
            echo -e "$contentIndexHead\n\n$contentIndexTail" >$opI
        fi

        echo "$contentView" >$opC
        
        # 使用正则处理路径输入如`///path///to///detail///`后速度有所下降, 所以如下的正则替换只用于服务控制台友好输出提示
        pathView=$( echo $opC | sed -r $HdlPathBySed )

        #echo 出当前新建文件名，以允许命令窗口点击文件地址打开编辑窗口
        echo "====点击以下文本，打开窗口==="
        echo -e "path:$PINK$pathView$RES"

    fi
}

# 初始化 contentView

if [ "$3" == "-s" -o "$3" == "--spec" ];then
    contentView=$(cat<<MKYE
import React, {useEffect} from 'react'

interface $viewProps {
    Style?: React.CSSProperties,
}

const $fileNameView: React.FC<$viewProps> = props => {
    useEffect(() => {

    }, [])

    return (
        
    )
}

export default $fileNameView
MKYE
)
elif [[ "$3" == "" || "$3" =~ ^\-\-+$ ]];then
    contentView=$(cat<<MKYE
import React, {useEffect} from 'react'

interface $viewProps {
    Style?: React.CSSProperties,
}

export default (props: $viewProps): React.FC => {
    useEffect(() => {

    }, [])

    return (

    )
}
MKYE
)
else
    BoolTag=0
fi

mkFile
