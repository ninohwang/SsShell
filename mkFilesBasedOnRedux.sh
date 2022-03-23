# upd: 更改缩进为空格符；添加第四个入参 pathToDetail

# todo: 1 可优化：项目引入路径别名前提下，准确初始化 `"[path/to]/$fileNameActions.js"` `"[path/to]/utils/BaseUtil`
# todo: 2 若需要脚本执行时允许文件夹为中划线风格，而文件名为驼峰式 `sh <thisShell>.sh name-cafe`
# todo: 3 命令的规范判断
# todo: 4 BoolTag 的引入，一些执行语句其实可以跳过

# mayTodo: 1 文件名的合法判断；
# mayTodo: 1 暂不清楚 shell 脚本书写时 if 判断的语法细节，比如（圆扩/单中括号/双中括号）`[ "$dirName" == "" ] || [[ "$dirName" =~ ^\-.* ]]`
# mayTodo: 2 表达式中空格有无的语法，比如赋值操作，比如判断操作;
# mayTodo: 3 三元表达式的写法...
# mayTodo: 4 是否有作用域，如 if 下声明的变量[直觉：没有]；以及是否允许变量（如 contentView 等**长字符串**变量的初始化）写在最后甚至函数调用之后[直觉: 允许]，而可脚本运行时（或之前）就已经声明提前
# mayTodo: 5 有看过相等判断，考虑到输入为空的情况下：所以有写法如 `"$foo"x == ""x` 以避免报错，但是本脚本下几次更改下来已经试不出其使用场景，如控制台直接输入`sh x.sh` 或者 `sh x.sh    ` 都不会有意外报错或警告了？
# mayTodo: 6 js/ts 的缩进空格自己偏向于2空格的缩进风格，后续是否可以脚本短命令中可控？
# mayTodo: 7 快速删除此脚本中的冗余注释，或者还是用脚本执行 🎈
# mayTodo: 8 短命令另种形式的支持 eg: `sh x.sh -m <fileName> -vft` 
#               (思路：区别对待单中划线紧跟字母的标识，允许其符合多个短命令且无视顺序，如 ls -ahl，然后对于非中划线开头的命令需要有前置命令)：形如： 
#               `sh x.sh --makeFile <fileName> -vf --path <pathTo>` 
#               `sh x.sh -m <fileName> -vf -p <pathTo>` 
#               `sh x.sh -p <pathTo> -m <fileName> -fv`
#               ；另此时，自定的 -fs 就不再适合这个约定下使用了
# mayTodo: 9 BoolTag 的引入，一些执行语句其实可以跳过 （如 contentView 等变量的赋值）

# alias: 如下的 mf4rdx 是 `sh thisShell.sh` 的别名
# test: `mf4rdx`
# test: `mf4rdx  `
# test: `mf4rdx --`
# test: `mf4rdx -h` | `mf4rdx --help`
# test: `mf4rdx someComp`
# test: `mf4rdx someComp -- --`    
# test: `mf4rdx someComp ------ -----------------------`
# test: `mf4rdx someComp -x` | `mf4rdx someComp --xhere`
# test: `mf4rdx someComp -- -x` | `mf4rdx someComp -- --xhere`
# test: `mf4rdx othComp -v` | `mf4rdx othComp -v --` | `mf4rdx othComp -v -f`
# test: `mf4rdx someComp -- -f`
# test: `mf4rdx someComp -- -fs`
# test: `mf4rdx heyPorsche -- -f song/nelly`
# test: `mf4rdx heyPorsche -- -f /song/nelly`

# 说明：
# 此脚本仅适用于该项目下简单的 src/view src/reducer src/actions 相关文件的创建 🎈可以自己自定义更改脚本
# 约定第一个传入的变量用以创建指定目录
# 调用如 `sh <thisShell>.sh <fileName> <-v> <-f> <pathTo>` (-v: 如输入 "demo", 则会创建"Demo.js 文件"；输入 "demo -v", 则会创建"DemoView.js"文件; -f 创建的是函数式组件)
# 使用 eg: sh mkFilesBasedOnRedux.sh demo
# eg2: sh mkFilesBasedOnRedux.sh demo -v -f
# eg3: sh mkFilesBasedOnRedux.sh demo -- -f

# eg4: sh x.sh demo -- -- /foo
# eg5: sh x.sh demo -- -- foo
# eg6: sh x.sh demo -- -- /foo/bar

# 定义颜色变量
PINK='\e[1;35m' # 粉红
GREEN='\e[1;32m' # 绿
BLUE='\e[1;34m' # 蓝
YELLOW='\e[1;33m' # 黄
RED='\e[1;31m' # 红
RES='\e[0m' # 清除颜色

dirName=$1
fileNameHead=${1^}

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
        
        #预定基本代码段 `echo >>` 表示追加; 若直接 echo $varStr, 则会丢失掉文本换行信息
        echo "$contentView" >src/view/$pathToDetail/$dirName/$fileNameView".js"
        echo "$contentActions" >src/actions/$pathToDetail/$dirName/$fileNameActions".js"
        echo "$contentModel" >src/reducer/$pathToDetail/$dirName/$fileNameModel".js"

        #echo 出当前新建文件名，以允许命令窗口点击文件地址打开编辑窗口
        echo -e "====请稍后在 $RED src/reducer/index.js $RES 中引入新建 $RED$fileNameModel$RES 文件===="
        echo "====点击以下文本，打开窗口==="
        echo -e "path:$PINK src/view/$pathToDetail/$dirName/$fileNameView.js $RES"
        echo -e "path:$GREEN src/reducer/$pathToDetail/$dirName/$fileNameModel.js $RES"
        echo -e "path:$BLUE src/actions/$pathToDetail/$dirName/$fileNameActions.js $RES"

    fi
}

# 初始化： contentView
if [ "$3" == "-f" -o "$3" == "--func" ];then
    contentView=$(cat<<EOF
import React, {useEffect} from "react";
import _ from "lodash";
import moment from "moment";
import {bindActionCreators} from "redux";
import {connect} from "react-redux";

import $fileNameActions from x"[path/to]/$fileNameActions.js"

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

import $fileNameActions from x"[path/to]/$fileNameActions.js"

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

import $fileNameActions from x"[path/to]/$fileNameActions.js"

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
import _ from "lodash";

import BaseUtil from x"[path/to]/utils/BaseUtil";

const TYPE = BaseUtil.getFileNameWithPath(__filename, BaseUtil.ACTIONS, 10);

function init(){
    return (dispatch, getState) => {
        
    }
}

export default {
    init,
}
EOF
)

# 初始化： contentModel
contentModel=$(cat<<EOF
import _ from "lodash";

import BaseUtil from x"[path/to]/utils/BaseUtil";

const TYPE = BaseUtil.getFileNameWithPath(__filename, BaseUtil.REDUCER, 8);

const initState = {

};

export default function $fileNameModel(state = initState, action) {
    switch (action.type) {
        case TYPE:
            return BaseUtil.mergeDeep(state, action.payload);
        case TYPE + "update":
            return {
                ...state,
                ...action.payload,
            };
        default:
            return state;
    }
}
EOF
)

mkFile # 函数调用
