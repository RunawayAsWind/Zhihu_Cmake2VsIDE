# CMake 最低版本号要求
cmake_minimum_required (VERSION 2.6)


MACRO(SUBDIRLIST result rootdir)

	if (IS_DIRECTORY ${rootdir})              
        LIST(APPEND ${result} ${rootdir})
		
		file(GLOB ALL_SUB RELATIVE ${rootdir} ${rootdir}/*) # 获得当前目录下的所有文件，存在ALL_SUB列表中

		FOREACH(sub ${ALL_SUB})
			SUBDIRLIST(${result} ${rootdir}/${sub})
		ENDFOREACH()
    endif()
	
ENDMACRO()

MACRO(SUBCODELIST result rootdir)

	file(GLOB temp "${rootdir}/*.h" "${rootdir}/*.hpp" "${rootdir}/*.cpp" "${rootdir}/*.c")
	
	if (NOT (${rootdir} STREQUAL ${PROJECT_SOURCE_DIR}))  
		string(REPLACE "${PROJECT_SOURCE_DIR}" "" groupname ${rootdir})
		string(REPLACE "/" "\\" groupname ${groupname})
		message(${groupname})
		list(LENGTH temp len)
		if (${len} STRGREATER 0)  
			message(${len})
			source_group(${groupname} FILES ${temp})
		endif()
	else()
		source_group("/" FILES ${temp})
	endif()
	
	LIST(APPEND ${result} ${temp})
	
ENDMACRO()

function(FolderTra_GetFileAndDir result rootdir)
	file(GLOB all LIST_DIRECTORIES true ${rootdir}/*)
	set(${result} ${all} PARENT_SCOPE)
endfunction()

function(FolderTra_GetFile result rootdir)
	file(GLOB allfile LIST_DIRECTORIES false ${rootdir}/*)
	set(${result} ${allfile} PARENT_SCOPE)
endfunction()

function(FolderTra_GetDir result rootdir)
	file(GLOB all LIST_DIRECTORIES true ${rootdir}/*)
	foreach(fileordir ${all})
		if (IS_DIRECTORY ${fileordir})    
			LIST(APPEND alldir ${fileordir})
		endif()
	endforeach()
	set(${result} ${alldir} PARENT_SCOPE)
endfunction()

function(FolderTraRCS_GetFileAndDir result rootdir)
	file(GLOB_RECURSE all LIST_DIRECTORIES true ${rootdir}/*)
	set(${result} ${all} PARENT_SCOPE)
endfunction()

function(FolderTraRCS_GetFile result rootdir)
	file(GLOB_RECURSE allfile LIST_DIRECTORIES false ${rootdir}/*)
	set(${result} ${allfile} PARENT_SCOPE)
endfunction()

function(FolderTraRCS_GetDir result rootdir)
	file(GLOB_RECURSE all LIST_DIRECTORIES true ${rootdir}/*)
	foreach(fileordir ${all})
		if (IS_DIRECTORY ${fileordir})    
			LIST(APPEND alldir ${fileordir})
		endif()
	endforeach()
	set(${result} ${alldir} PARENT_SCOPE)
endfunction()



function(FolderTra_GetCode result rootdir)
	file(GLOB allcode "${rootdir}/*.h" "${rootdir}/*.hpp" "${rootdir}/*.cpp" "${rootdir}/*.c")
	set(${result} ${allcode} PARENT_SCOPE)
endfunction()

function(FolderTraRCS_GetCode result rootdir)
	file(GLOB_RECURSE allcode "${rootdir}/*.h" "${rootdir}/*.hpp" "${rootdir}/*.cpp" "${rootdir}/*.c")
	set(${result} ${allcode} PARENT_SCOPE)
endfunction()

function(SrcCodeGroup rootdir)
	FolderTraRCS_GetDir(dirlist ${rootdir})
	LIST(APPEND dirlist ${rootdir})

	foreach(dir ${dirlist})
		file(GLOB dircode "${dir}/*.h" "${dir}/*.hpp" "${dir}/*.cpp" "${dir}/*.c")
		if (NOT (${dir} STREQUAL ${rootdir}))  
			string(REPLACE "${rootdir}" "" groupname ${dir})
			string(REPLACE "/" "\\" groupname ${groupname})
			list(LENGTH dircode len)
			if (${len} STRGREATER 0)  
				source_group(${groupname} FILES ${dircode})
			endif()
		else()
			source_group("\\" FILES ${dircode})
		endif()
	endforeach()
endfunction()


# 项目信息
project (Demo)

include("${PROJECT_SOURCE_DIR}/CMakeHelp/PathHelp.cmake")

message("\n")
message("Traversal folder--File And Dir")
FolderTra_GetFileAndDir(TEST1 ${PROJECT_SOURCE_DIR})
foreach(f ${TEST1})
   message("${f}")
endforeach()

message("\n")
message("Traversal folder--Only File")
FolderTra_GetFile(TEST2 ${PROJECT_SOURCE_DIR})
foreach(f ${TEST2})
   message("${f}")
endforeach()

message("\n")
message("Traversal folder--Only Dir")
FolderTra_GetDir(TEST3 ${PROJECT_SOURCE_DIR})
foreach(f ${TEST3})
   message("${f}")
endforeach()

#
message("\n")
message("Traversal folder RCS--File And Dir")
FolderTraRCS_GetFileAndDir(TEST4 ${PROJECT_SOURCE_DIR})
foreach(f ${TEST4})
   message("${f}")
endforeach()

message("\n")
message("Traversal folder RCS--Only File")
FolderTraRCS_GetFile(TEST5 ${PROJECT_SOURCE_DIR})
foreach(f ${TEST5})
   message("${f}")
endforeach()

message("\n")
message("Traversal folder RCS--Only Dir")
FolderTraRCS_GetDir(TEST6 ${PROJECT_SOURCE_DIR})
foreach(f ${TEST6})
   message("${f}")
endforeach()

message("\n")
message("Traversal folder--Only Code")
FolderTra_GetCode(TEST7 ${PROJECT_SOURCE_DIR})
foreach(f ${TEST7})
   message("${f}")
endforeach()

message("\n")
message("Traversal folder RCS--Only Code")
FolderTraRCS_GetCode(TEST8 ${PROJECT_SOURCE_DIR})
foreach(f ${TEST8})
   message("${f}")
endforeach()

message("\n")
message("SrcCodeGroup")
SrcCodeGroup(${PROJECT_SOURCE_DIR})
message("\n")
 
include_directories(${TEST6})

# 指定生成目标
add_executable (Demo ${TEST8})



