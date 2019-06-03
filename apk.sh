#!/bin/bash

function help
{
  echo "APK Decompiler"
  echo
  echo "usage: ./apk.sh <options> <APK-file-path> [output-dir]"
  echo ""
  echo "options:"
  echo " -r,--resource		Extracting resources from APK file."
  echo " -s,--src		    Extracting JAR file from APK and get the Java files"
  echo " -p,--project		Generate Gradle-based Android project"
  echo " -h,--help		    Prints this help message"
  echo
}
function resource
{
    mkdir -p ${resOutputDir}
    echo
    echo "Extracting resources from APK file"
    apktoolPath=${projectDir}/apktool
    chmod a+x ${apktoolPath}/apktool.sh
    sh ${apktoolPath}/apktool.sh d ${apkfile} -f -o ${resOutputDir}
    rm -rf ${resOutputDir}/smali
    rm -rf ${resOutputDir}/apktool.yml
    mv ${resOutputDir}/original/META-INF ${resOutputDir}/META-INF
    rm -rf ${resOutputDir}/original
}
function src
{
    mkdir -p ${srcOutputDir}
    echo
    echo "Extracting JAR file from APK and get the Java files"
    dex2jarPath=${projectDir}/dex2jar
    chmod a+x ${dex2jarPath}/*.bat ${dex2jarPath}/*.sh
    echo
    echo "Begin use dex2jar"
    sh ${dex2jarPath}/d2j-dex2jar.sh -o ${outputDir}/output.jar ${apkfile}
    echo
    echo "Begin use jd-core"
    #java -jar ${projectDir}/jd-core-java/jd-core-java-1.2.jar ${outputDir}/output.jar ${srcOutputDir}
    cd ${srcOutputDir} && jar xvf ${outputDir}/output.jar && cd ..
    # rm -f ${outputDir}/output.jar
}
getResource=false
getRrc=false
generateProject=false
# Check all of the possible options
case $1 in
    -r |--resource )        getResource=true
                            ;;
    -s |--src )         	getRrc=true
                            ;;
    -p | --project )        generateProject=true
                            ;;
    -h | --help )           help
                            ;;
esac


projectDir=`pwd`
apk=".apk"


fullPath=$2
filePath=${fullPath##*/}
apkName=${filePath%".apk"}

# Prepare outputDir
outputDir=$3
if [ -z $outputDir ]
then
    outputDir=${projectDir}/output
else
    outputDir=${outputDir}/output
fi
rm -rf ${projectDir}/output
rm -rf ${outputDir}
mkdir -p ${outputDir}

# Prepare apk
if [ -z $fullPath ]
then
    help
    exit;
else
    echo "Begin to decompile $2"
    apkfile=${outputDir}/${apkName}${apk}
    cp ${fullPath} ${apkfile}
    resOutputDir=${outputDir}/res-output
    srcOutputDir=${outputDir}/src-output
fi

#Execute
if [[ "${getResource}" == true ]];
then
    resource
fi

if [[ "${getRrc}" == true ]];
then
    src
fi

if [[ "${generateProject}" == true ]];
then
    resource
    src
    echo
    echo "Generate Gradle-based Android project"
    baseDir=${outputDir}/${apkName}
    mkdir -p ${baseDir}/gradle
    mkdir -p ${baseDir}/gradle/wrapper
    mkdir -p ${baseDir}/app
    mkdir -p ${baseDir}/app/libs
    mkdir -p ${baseDir}/app/src
    mkdir -p ${baseDir}/app/src/main
    mkdir -p ${baseDir}/app/src/main/java

    mv  ${srcOutputDir}/* ${baseDir}/app/src/main/java
    mv  ${resOutputDir}/* ${baseDir}/app/src/main

    cp -r ${projectDir}/files/project/* ${baseDir}/
    cp -r ${projectDir}/files/wrapper/* ${baseDir}/gradle/wrapper
    cp -r ${projectDir}/files/module/* ${baseDir}/app

    rm -rf ${srcOutputDir}
    rm -rf ${resOutputDir}
fi


rm -f ${apkfile}
