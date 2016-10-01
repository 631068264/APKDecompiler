APK Decompiler
==============

The APK Decompile just a script to use some **tools** for decompiling APK to its Java src or resources.

Tools
-----
- apktool : Version 2.2.0
- dex2Jar : Version 2.0
- jd-core-java : Version 1.2


Supported Platforms
-------------------
**Mac**(Because I build this on Mac) and I think it can work on most of **UNIX os**.


Usage
-----
```
usage: 
    chmod a+x apk.sh
    ./apk.sh <options> <APK-file-path> [output-dir]
    
options:
    -r,--resource   Extracting resources from APK file.
    -s,--src		Extracting JAR file from APK and get the Java files
    -p,--project    Generate Android project with Gradle
    -h,--help		Prints this help message
    
default:
    output-dir      The output directory is optional.The default will be 
                    use output/APK-name , output/res-output or 
                    output/src-output under the root of this project.
                    
```

Example
-------
```
./apk.sh -r ../apk.apk
You can get the resources in output/res-output under the root of this project.
```