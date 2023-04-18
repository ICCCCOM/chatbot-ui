PROJECTNAME=ChatUI #每个项目一个名称
echo 'start build project name:'
echo ${PROJECTNAME}
NEWIMAGENAME=${PROJECTNAME}_${BUILD_ID} #这个是最终打包镜像的名称
TEMPNAME=${PROJECTNAME}.${BUILD_ID} #这个是临时名称，主要是在镜像打包之后需要区别旧名称，旧名称要全部停止然后删除
OLDCONTAINER=`docker ps -a | awk '/ChatUI_[0-9]+/{print $1}' | sort | sort -u` # 把所有这个项目的旧容器找出来后面要删除
OLDCONTAINERCOUNT=`docker ps -a | awk '/ChatUI_[0-9]+/{print $1}' | sort | sort -u | wc -l` #旧容器的数量，用来判断，如果有才删除，没有的话删除会报错
echo 'old container:'
echo $OLDCONTAINER
OLDIMAGE=`docker images | awk '/ChatUI_[0-9]+/{print $1}' | sort | sort -u` # 把所有这个项目的旧镜像找出来后面要用来删除
OLDIMAGECOUNT=`docker images | awk '/ChatUI_[0-9]+/{print $1}' | sort | sort -u | wc -l` #旧镜像的数量，用来判断，如果有才删除，没有的话删除会报错
echo 'old images:'
echo $OLDIMAGE
docker build -t ${TEMPNAME} ${WORKSPACE}
if [ $OLDCONTAINERCOUNT -gt 0 ]; then
	docker stop $OLDCONTAINER
    docker rm $OLDCONTAINER
fi
if [ $OLDIMAGECOUNT -gt 0 ]; then
	docker rmi $OLDIMAGE
fi
docker image tag $TEMPNAME $NEWIMAGENAME
docker rmi $TEMPNAME:latest
docker run --name $NEWIMAGENAME -p 8081:80 -d $NEWIMAGENAME