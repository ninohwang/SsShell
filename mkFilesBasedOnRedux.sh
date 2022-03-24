# 定义颜色变量
PINK='\e[1;35m' # 粉红
GREEN='\e[1;32m' # 绿
BLUE='\e[1;34m' # 蓝
YELLOW='\e[1;33m' # 黄
RED='\e[1;31m' # 红
RES='\e[0m' # 清除颜色

dirName=$1

# fileNameHead=${1^}
fileNameHead=$(echo "$1" | sed -r 's/(^|_|-)(\w)/\U\2/g')

# 处理路径中冗余 `\/`
HdlPathBySed='s/((\/)(\/)+)/\2/g'

# 这里为空也不影响之后的路径拼接
pathToDetail=$4

fileNameActions=$fileNameHead"Actions"
fileNameModel=$fileNameHead"Model"

# 引入表征布尔值的变量
BoolTag=1

if [[ "$2" =~ ^\-v$ || "$2" =~ ^\-\-view$ ]];then
    fileNameView=$fileNameHead"View"
elif [[ "$2" == "" || "$2" =~ ^\-\-+$ ]];then # 允许 --, ---, ----有效
    fileNameView=$fileNameHead
else 
    BoolTag=0
fi


function mkFile() { # 函数声明

    # if [ "$dirName" == "" -o "$dirName" == "--" -o "$dirName" == "-" ];then
    if [ "$dirName" == "" ] || [[ "$dirName" =~ ^\-.* && ! "$dirName" =~ ^\-h$ && ! "$dirName" =~ ^\-\-help$ ]];then
        echo -e "未输入合法文件名！执行此脚本需要一个以上入参。或者输入$RED --help -h$RES 查看提示"

    elif [ "$dirName" == "--help" -o "$dirName" == "-h" ];then

#         cat <<- EOF
#             sh <thisShell>.sh <fileName> <-v|--> <-f|--> <pathTo|-->
#             ...
#             -v, --view  组件文件以 `view` 结尾，eg: NameView.js
#             ...
# EOF

# ▲ 如上尝试输出多行文本都报错 `Vim: 警告: 输出不是到终端(屏幕)`，**且不会退出此报错**，暂时这两个问题都不知解决 —— 知道前一个问题了，为双引号字符串中的反引号的使用；但是如何退出任然不知；

#         cat <<- EOF
# sh <thisShell>.sh <fileName> <-v|--> <-f|--> <pathTo|-->
#     fileName    你想要建立的文件（目录）群
#     -v, --view  组件文件以 view 结尾，eg: NameView.js
#     -f, --func, --fs, --funcs  模板使用函数式组件; fs 表征模板下为具名函数 （s: specific
#     pathTo      决定多极目录
# EOF

        echo -e "sh <thisShell>.sh <fileName> <-v|--> <-f|--> <pathTo|-->
    $RED fileName$RES    你想要建立的文件（目录）群
    $RED -v, --view$RES  组件文件以 view 结尾，eg: NameView.js
    $RED -f, --func, --fs, --funcs$RES  模板使用函数式组件; fs 表征模板下为具名函数 （s: specific
    $RED pathTo$RES      决定多极目录"

    elif [ $BoolTag -eq 0 ];then
        echo "短命令非法！请严格输入 -v 或 -f 或 -fs 或 --view 或 --func 或 --funcs 或占位：-- 或 ---"

    else
        # 若需要输出目录创建过程 `mkdir -v`
        mkdir -p src/{view/$pathToDetail/$dirName,actions/$pathToDetail/$dirName,reducer/$pathToDetail/$dirName}
        touch src/{view/$pathToDetail/$dirName/{$fileNameView".js",$fileNameView".scss"},actions/$pathToDetail/$dirName/$fileNameActions".js",reducer/$pathToDetail/$dirName/$fileNameModel".js"}
        
        # 预定基本代码段 `echo >>` 表示追加; 若直接 echo $varStr, 则会丢失掉文本换行信息
        # 因为如下写入文本到指定文件位置，而正则处理冗余路径似乎比较慢，所以如下三行还是不使用变量 pathView / pathModel
        echo "$contentView" >src/view/$pathToDetail/$dirName/$fileNameView".js"
        echo "$contentActions" >src/actions/$pathToDetail/$dirName/$fileNameActions".js"
        echo "$contentModel" >src/reducer/$pathToDetail/$dirName/$fileNameModel".js"

        # 不过使用正则处理路径输入如`///path///to///detail///`后速度有所下降, 所以如下的正则替换只用于服务控制台友好输出提示
        pathView=$(echo src/view/$pathToDetail/$dirName/$fileNameView.js | sed -r $HdlPathBySed)
        pathModel=$(echo src/reducer/$pathToDetail/$dirName/$fileNameModel.js | sed -r $HdlPathBySed)
        
        # echo 出当前新建文件名，以允许命令窗口点击文件地址打开编辑窗口
        echo -e "====请稍后在 $RED src/reducer/index.js $RES 中引入新建 $RED$fileNameModel$RES 文件===="
        echo "====点击以下文本，打开窗口==="
        echo -e "path:$PINK$pathView$RES"
        echo -e "path:$GREEN$pathModel$RES"
        echo -e "path:$BLUE$pathActions$RES"

    fi
}

# 初始化： contentView
pathActions=$(echo src/actions/$pathToDetail/$dirName/$fileNameActions.js | sed -r $HdlPathBySed)

if [ "$3" == "-f" -o "$3" == "--func" ];then
    contentView=$(cat<<EOF
import React, {useEffect} from "react";
import _ from "lodash";
import moment from "moment";
import {bindActionCreators} from "redux";
import {connect} from "react-redux";

import $fileNameActions from "@$pathActions";

import styles from "./$fileNameView.scss";

export default connect(
    state => ({
        viewModel: state.$fileNameModel,
    }),
    dispatch => ({
        actions: bindActionCreators($fileNameActions, dispatch),
    })
)((props) => {

    useEffect(() => {

    }, []);

    return (

    );
});
EOF
)

elif [ "$3" == "-fs" -o "$3" == "--funcs" ];then
    contentView=$(cat<<EOF
import React, {useEffect} from "react";
import _ from "lodash";
import moment from "moment";
import {bindActionCreators} from "redux";
import {connect} from "react-redux";

import $fileNameActions from "@$pathActions";

import styles from "./$fileNameView.scss";

const $fileNameView = (props) => {

    useEffect(() => {

    }, []);

    return (

    );
}

export default connect(
    state => ({
        viewModel: state.$fileNameModel,
    }),
    dispatch => ({
        actions: bindActionCreators($fileNameActions, dispatch),
    })
)($fileNameView);
EOF
)

elif [[ "$3" == "" || "$3" =~ ^\-\-+$ ]];then # 允许 --, ---, ----有效
    contentView=$(cat<<EOF
import React, {Component} from "react";
import _ from "lodash";
import moment from "moment";
import {bindActionCreators} from "redux";
import {connect} from "react-redux";

import $fileNameActions from "@$pathActions";

import styles from "./$fileNameView.scss";

class $fileNameView extends Component {

    componentDidMount() {

    }

    render() {
        return(

        );
    }
}

export default connect(
    state => ({
        viewModel: state.$fileNameModel,
    }),
    dispatch => ({
        actions: bindActionCreators($fileNameActions, dispatch),
    })
)($fileNameView);
EOF
)
else 
    BoolTag=0
fi


# 初始化： contentActions
contentActions=$(cat<<EOF
// 可在脚本中 `contentActions=` 赋值处初始化你的模板
EOF
)

# 初始化： contentModel
contentModel=$(cat<<EOF
// 可在脚本中 `contentModel=` 赋值处初始化你的模板
EOF
)

mkFile # 函数调用
