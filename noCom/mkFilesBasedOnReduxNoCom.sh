
PINK='\e[1;35m'
GREEN='\e[1;32m'
BLUE='\e[1;34m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
RES='\e[0m'
dirName=$1

fileNameHead=$(echo "$1" | sed -r 's/(^|_|-)(\w)/\U\2/g')

HdlPathBySed='s/((\/)(\/)+)/\2/g'

pathToDetail=$4

fileNameActions=$fileNameHead"Actions"
fileNameModel=$fileNameHead"Model"

BoolTag=1

if [[ "$2" =~ ^\-v$ || "$2" =~ ^\-\-view$ ]];then
    fileNameView=$fileNameHead"View"
elif [[ "$2" == "" || "$2" =~ ^\-\-+$ ]];then
    fileNameView=$fileNameHead
else 
    BoolTag=0
fi


function mkFile() {
   
    if [ "$dirName" == "" ] || [[ "$dirName" =~ ^\-.* && ! "$dirName" =~ ^\-h$ && ! "$dirName" =~ ^\-\-help$ ]];then
        echo -e "未输入合法文件名！执行此脚本需要一个以上入参。或者输入$RED --help -h$RES 查看提示"

    elif [ "$dirName" == "--help" -o "$dirName" == "-h" ];then

        echo -e "sh <thisShell>.sh <fileName> <-v|--> <-f|--> <pathTo|-->
    $RED fileName$RES    你想要建立的文件（目录）群
    $RED -v, --view$RES  组件文件以 view 结尾，eg: NameView.js
    $RED -f, --func, --fs, --funcs$RES  模板使用函数式组件; fs 表征模板下为具名函数 （s: specific
    $RED pathTo$RES      决定多极目录"

    elif [ $BoolTag -eq 0 ];then
        echo "短命令非法！请严格输入 -v 或 -f 或 -fs 或 --view 或 --func 或 --funcs 或占位：-- 或 ---"

    else
       
        mkdir -p src/{view/$pathToDetail/$dirName,actions/$pathToDetail/$dirName,reducer/$pathToDetail/$dirName}
        touch src/{view/$pathToDetail/$dirName/{$fileNameView".js",$fileNameView".scss"},actions/$pathToDetail/$dirName/$fileNameActions".js",reducer/$pathToDetail/$dirName/$fileNameModel".js"}
        
       
       
        echo "$contentView" >src/view/$pathToDetail/$dirName/$fileNameView".js"
        echo "$contentActions" >src/actions/$pathToDetail/$dirName/$fileNameActions".js"
        echo "$contentModel" >src/reducer/$pathToDetail/$dirName/$fileNameModel".js"

       
        pathView=$(echo src/view/$pathToDetail/$dirName/$fileNameView.js | sed -r $HdlPathBySed)
        pathModel=$(echo src/reducer/$pathToDetail/$dirName/$fileNameModel.js | sed -r $HdlPathBySed)
        
       
        echo -e "====请稍后在 $RED src/reducer/index.js $RES 中引入新建 $RED$fileNameModel$RES 文件===="
        echo "====点击以下文本，打开窗口==="
        echo -e "path:$PINK$pathView$RES"
        echo -e "path:$GREEN$pathModel$RES"
        echo -e "path:$BLUE$pathActions$RES"

    fi
}

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

elif [[ "$3" == "" || "$3" =~ ^\-\-+$ ]];then
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


contentActions=$(cat<<EOF
// 可在脚本中 `contentActions=` 赋值处初始化你的模板
EOF
)

contentModel=$(cat<<EOF
// 可在脚本中 `contentModel=` 赋值处初始化你的模板
EOF
)

mkFile