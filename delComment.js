// ref: https://www.jianshu.com/p/02fd3a471c45
// ref: https://newbedev.com/writefile-no-such-file-or-directory
// ref: https://stackoverflow.com/questions/34811222/writefile-no-such-file-or-directory
// oth: 为啥我先全局安装了 pnpm add -g mkdirp; 运行（node del.js）找不到 mkdirp, 然后 npm i -g mkdirp (此时拒绝安装了)(所以还需要 pnpm remove -g mkdirp)
var fs = require('fs')
const mkdirp = require('mkdirp')
var path = require('path')

/** 目标遍历的文件夹 */
// var fileRootPath = path.resolve('./src')
var fileRootPath = path.resolve('./')

/** 遍历的文件类型 */
var fileTypes = ['sh', 'shell']

/** 注释reg */
// var commentRegExp = /(\/\*([\s\S]*?)\*\/|([^:]|^)\/\/(.*)$)/gm
// var commentRegExp = /([^:]|^)\#(.*)$/gm // note (.*) 或许不包含 \r\n

const commentRegExp = /([^:]|^)\#(.*)(\r){0,1}(\n){0,1}$/gm

function commentReplace(match, multi, multiText, singlePrefix) {
    // return singlePrefix || ''
    // TODO: 如何是删除整行且不保留换行符
    return ''
}

const writeFileSyncX = async (path, pathFile, content) => {
    await mkdirp(path)
    fs.writeFileSync(pathFile, content);
}

/** 遍历文件夹里的文件 */
function fileReplace(filePath) {
    //根据文件路径读取文件，返回文件列表
    fs.readdir(filePath, function (err, files) {
        if (err) {
            console.warn(err)
        } else {
            //遍历读取到的文件列表
            files.forEach(function (filename) {
                //获取当前文件的绝对路径
                var filedir = path.join(filePath, filename)
                const [fileHeadX, fileTypeX] = filename.split('.')
                const filePathX = `${filePath}/noCom`
                const fileNoComDir = path.join(filePathX, `${fileHeadX}NoCom.${fileTypeX}`)
                //根据文件路径获取文件信息，返回一个fs.Stats对象
                fs.stat(filedir, function (eror, stats) {
                    if (eror) {
                        console.warn('获取文件stats失败')
                    } else {
                        var isFile = stats.isFile() //是文件
                        var isDir = stats.isDirectory() //是文件夹
                        if (isFile) {
                            const fileType = filedir.split('.')[1]
                            if (fileTypes.indexOf(fileType) == -1) {
                                return
                            }
                            console.log(filedir)

                            var content = fs.readFileSync(filedir, 'utf-8')
                            // 去除注释后的文本
                            content = content.replace(commentRegExp, commentReplace)
                            // 覆盖原文件内容
                            // fs.writeFileSync(filedir, content)
                            writeFileSyncX(filePathX, fileNoComDir, content)
                            console.log('success')
                        }

                        // if (isDir) {
                        //     fileReplace(filedir) //递归，如果是文件夹，就继续遍历该文件夹下面的文件
                        // }
                    }
                })
            })
        }
    })
}

fileReplace(fileRootPath)
