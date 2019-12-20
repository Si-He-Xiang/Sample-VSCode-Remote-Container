#!/bin/bash

SH_FOLDER=$(dirname "${BASH_SOURCE[0]}")
[[ ${SH_FOLDER} != "/"* ]] && SH_FOLDER=$PWD/${SH_FOLDER}

function exit_if_error(){
    if [ "$1" == "0" ];then echo "  "$OUT;else echo -e '\n发生错误\n';exit $1;fi
}

while getopts "t:s" arg
do
    case $arg in
        t)
            TARGET=${OPTARG};;
        s)
            NOBUILD="-s";;
    esac
done
shift $(($OPTIND - 1))
[[ -z ${TARGET} ]] && TARGET='prod'

DESC="WEEDFS镜像"
IMAGE_NAME="shx/seaweedfs:prod"
DOCKERFILE_NAME="Dockerfile"
BUILD_PATH=$SH_FOLDER
echo "[${DESC}]"
echo "  ${DESC}构建路径: "${BUILD_PATH}
echo "  开始构建${DESC}"
docker build -t ${IMAGE_NAME} -f ${BUILD_PATH}/${DOCKERFILE_NAME} ${BUILD_PATH}
exit_if_error $?
echo -e "  ${DESC}构建完毕 ( image-name: ${IMAGE_NAME} )\n"


# DESC="文件服务镜像"
# IMAGE_NAME="shx/app-fstore:prod"
# DOCKERFILE_NAME="prod.Dockerfile"
# BUILD_PATH=$SH_FOLDER/build
# APP_SRC_PATH=${SH_FOLDER}/../src
# echo "[${DESC}]"
# echo "  ${DESC}构建路径: "${BUILD_PATH}
# echo "  开始构建${DESC}"

# rsync -q -av --delete $APP_SRC_PATH/*-requirements.txt ${SH_FOLDER}/build/temp \
# && rsync -q -av --copy-dirlinks --delete --exclude="pages" --exclude="node_modules" --exclude=".git" --exclude="deploy" --exclude="*.pyc" $APP_SRC_PATH/* ${SH_FOLDER}/build/temp/app
# exit_if_error $?

# if [ -d $APP_SRC_PATH/pages/vue ];then
#     if [ ! -d $APP_SRC_PATH/pages/vue/dist ] || [ -z ${NOBUILD} ];then
#         cd $APP_SRC_PATH/pages/vue \
#         && cnpm i \
#         && npm run build \
#         && cd -
#         exit_if_error $?
#     fi
#     rsync -q -av $APP_SRC_PATH/pages/vue/dist/. ${SH_FOLDER}/build/temp/pages 
#     exit_if_error $?
# fi

# docker build -t ${IMAGE_NAME} -f ${BUILD_PATH}/${DOCKERFILE_NAME} ${BUILD_PATH}
# exit_if_error $?
# echo -e "  ${DESC}构建完毕 ( image-name: ${IMAGE_NAME} )\n"
# rm -rf ${SH_FOLDER}/build/temp


