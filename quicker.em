/* 
 * 获取文件名、扩展名、路径等文件相关信息
 */
macro filenamehandle(string)
{
	i = 0
	size = strlen(string)
	dotpos = -1
	backlashpos = -1
	pathinfo = nil 

	while(i < size)
	{
		if((string[size - 1 - i] == ".") && (dotpos == -1))
		{
			dotpos = i
		}
		if((string[size - 1 - i] == "\\")&&(backlashpos == -1))
		{
			backlashpos = i
		}
		i = i + 1
	}

	if(backlashpos < dotpos)
	{
		dotpos = 0;
	}

	if(backlashpos == -1)
	{
		pathinfo.path = ""
		pathinfo.filename = string
	}
	else
	{
		pathinfo.path = strmid(string, 0, size - backlashpos)
		pathinfo.filename = strmid(string, size - backlashpos, size)
	}

	filenamesize = strlen(pathinfo.filename)
	if(dotpos == -1)
	{
		pathinfo.filenamebase = pathinfo.filename
		pathinfo.extension = ""
	}
	else
	{
		pathinfo.filenamebase = strmid(pathinfo.filename, 0, filenamesize - dotpos - 1) 
		pathinfo.extension = strmid(pathinfo.filename, filenamesize - dotpos - 1, filenamesize)
	}

	return pathinfo
}

/*
 * 在新窗口中显示当前编辑文件的路径及文件名
 */
macro GetCurFileInfo ()
{
	hbuf = GetCurrentBuf()
	bufName = GetBufName(hbuf)
	//bufName = tolower(bufName)

	fileinfo = filenamehandle(bufName)
	filename = fileinfo.filename 
	//filename = tolower(filename)

	path = fileinfo.path 
	//path = tolower(path)

	filenamebase = fileinfo.filenamebase 
	//filenamebase = tolower(filenamebase)

	extension = fileinfo.extension 
	//extension = tolower(extension)

	ln = GetBufLnCur(hbuf)
	ln= ln + 1;

	hbuftemp = NewBuf("TEMPBUF")	// create output buffer
	if(hbuftemp == 0)
	{
		stop
	}

	AppendBufLine(hbuftemp, "filepath: @bufName@")
	AppendBufLine(hbuftemp, "filename: @filename@")
	AppendBufLine(hbuftemp, "coruse  : @ln@")

	SetBufDirty(hbuftemp, FALSE);	// don’t bother asking to save
	hwnd = NewWnd(hbuftemp)	// 显示结果
}

/*
  * 函数功能: 建立或更改用户信息
  * 将用户输入信息写入注册表
  * 注册表路径：HKEY_CURRENT_USER/Software/Source Dynamics/Source Insight/3.0
  */
macro SaveUserInfo( )
{
	//写入用户名
	szMyName = getreg(UserName)
	if(strlen(szMyName) == hNil)
	{
		szMyName = Ask("Enter your name:")
		setreg(UserName, szMyName)
	}
	else
	{
		szMyName = Ask("Current name is \"@szMyName@\", Enter new name:")
		setreg(UserName, szMyName)
	}

	//写入单位名
	szCorp = getreg(Corporation)
	if(strlen(szCorp) == hNil)
	{
		szCorp = Ask("Enter your Corporation:")
		setreg(Corporation, szCorp)
	}
	else
	{
		szCorp = Ask("Current Corp. is \"@szCorp@\", Enter new Corporation:")
		setreg(Corporation, szCorp)
	}

	//写入我的文档的路径
	szDocPath = getreg(MyDocument)
	if(strlen(szDocPath) == hNil)
	{
		szDocPath = Ask("Enter My Document Path:")
		setreg(MyDocument, szDocPath)
	}
	else
	{
		szDocPath = Ask("My Document path is \"@szDocPath@\", Enter new Path:")
		setreg(MyDocument, szDocPath)
	}
}

//多行注释
macro CodeComments()
{
	hwnd=GetCurrentWnd()
	selection=GetWndSel(hwnd)
	LnFirst=GetWndSelLnFirst(hwnd)//取首行行号
	LnLast=GetWndSelLnLast(hwnd)//取末行行号
	hbuf=GetCurrentBuf()
	if(GetBufLine(hbuf,0)=="//magic-number:tph85666031")
	{
 		stop
	}
	Ln=Lnfirst
	buf=GetBufLine(hbuf,Ln)
	len=strlen(buf)
	while(Ln<=Lnlast)
	{
		buf=GetBufLine(hbuf,Ln)//取Ln对应的行
	 	if(buf=="")//跳过空行
	 	{
		 	Ln=Ln+1
			continue
 		}
	 	if(StrMid(buf,0,1)=="/")//需要取消注释,防止只有单字符的行
	 	{
			if(StrMid(buf,1,2)=="/")
			{
				PutBufLine(hbuf,Ln,StrMid(buf,2,Strlen(buf)))
			}
		}
		if(StrMid(buf,0,1)!="/")//需要添加注释
		{
			PutBufLine(hbuf,Ln,Cat("//",buf))
		}
		Ln=Ln+1
	}
	SetWndSel( hwnd, selection )
}

macro strstr(str1,str2)
{
	i = 0
	j = 0
	len1 = strlen(str1)
	len2 = strlen(str2)
	if((len1 == 0) || (len2 == 0))
	{
		return 0xffffffff
	}
	while( i < len1)
	{
		if(str1[i] == str2[j])
		{
			while(j < len2)
			{
				j = j + 1
				if(str1[i+j] != str2[j]) 
				{
					break
				}
			}     
			if(j == len2)
			{
				return i
			}
			j = 0
		}
		i = i + 1      
	}  
	return 0xffffffff
}

macro SearchForward()
{
	LoadSearchPattern("#", 1, 0, 1);
	Search_Forward
}

macro TrimString(szLine)
{
    szLine = TrimLeft(szLine)
    szLIne = TrimRight(szLine)
    return szLine
}

macro TrimLeft(szLine)
{
    nLen = strlen(szLine)
    if(nLen == 0)
    {
        return szLine
    }
    nIdx = 0
    while( nIdx < nLen )
    {
        if( ( szLine[nIdx] != " ") && (szLine[nIdx] != "\t") )
        {
            break
        }
        nIdx = nIdx + 1
    }
    return strmid(szLine,nIdx,nLen)
}

macro TrimRight(szLine)
{
    nLen = strlen(szLine)
    if(nLen == 0)
    {
        return szLine
    }
    nIdx = nLen
    while( nIdx > 0 )
    {
        nIdx = nIdx - 1
        if( ( szLine[nIdx] != " ") && (szLine[nIdx] != "\t") )
        {
            break
        }
    }
    return strmid(szLine,0,nIdx+1)
}

macro CommentContent (hbuf,ln,szPreStr,szContent,isEnd)
{
    szLeftBlank = szPreStr
    iLen = strlen(szPreStr)
    k = 0
    while(k < iLen)
    {
        szLeftBlank[k] = " ";
        k = k + 1;
    }

    hNewBuf = newbuf("clip")
    if(hNewBuf == hNil)
        return       
    SetCurrentBuf(hNewBuf)
    PasteBufLine (hNewBuf, 0)
    lnMax = GetBufLineCount( hNewBuf )
    szTmp = TrimString(szContent)

    //判断如果剪贴板是0行时对于有些版本会有问题，要排除掉
    if(lnMax != 0)
    {
        szLine = GetBufLine(hNewBuf , 0)
	    ret = strstr(szLine,szTmp)
	    if(ret == 0)
	    {
	        /*如果输入窗输入的内容是剪贴板的一部分说明是剪贴过来的取剪贴板中的内
	          容*/
	        szContent = TrimString(szLine)
	    }
	    else
	    {
	        lnMax = 1
	    }	    
    }
    else
    {
        lnMax = 1
    }    
    szRet = ""
    nIdx = 0
    while ( nIdx < lnMax) 
    {
        if(nIdx != 0)
        {
            szLine = GetBufLine(hNewBuf , nIdx)
            szContent = TrimLeft(szLine)
               szPreStr = szLeftBlank
        }
        iLen = strlen (szContent)
        szTmp = cat(szPreStr,"#");
        if( (iLen == 0) && (nIdx == (lnMax - 1))
        {
            InsBufLine(hbuf, ln, "@szTmp@")
        }
        else
        {
            i = 0
            //以每行75个字符处理
            while  (iLen - i > 75 - k )
            {
                j = 0
                while(j < 75 - k)
                {
                    iNum = szContent[i + j]
                    if( AsciiFromChar (iNum)  > 160 )
                    {
                       j = j + 2
                    }
                    else
                    {
                       j = j + 1
                    }
                    if( (j > 70 - k) && (szContent[i + j] == " ") )
                    {
                        break
                    }
                }
                if( (szContent[i + j] != " " ) )
                {
                    n = 0;
                    iNum = szContent[i + j + n]
                    //如果是中文字符只能成对处理
                    while( (iNum != " " ) && (AsciiFromChar (iNum)  < 160))
                    {
                        n = n + 1
                        if((n >= 3) ||(i + j + n >= iLen))
                             break;
                        iNum = szContent[i + j + n]
                    }
                    if(n < 3)
                    {
                        //分段后只有小于3个的字符留在下段则将其以上去
                        j = j + n 
                        sz1 = strmid(szContent,i,i+j)
                        sz1 = cat(szPreStr,sz1)                
                    }
                    else
                    {
                        //大于3个字符的加连字符分段
                        sz1 = strmid(szContent,i,i+j)
                        sz1 = cat(szPreStr,sz1)
                        if(sz1[strlen(sz1)-1] != "-")
                        {
                            sz1 = cat(sz1,"-")                
                        }
                    }
                }
                else
                {
                    sz1 = strmid(szContent,i,i+j)
                    sz1 = cat(szPreStr,sz1)
                }
                InsBufLine(hbuf, ln, "@sz1@")
                ln = ln + 1
                szPreStr = szLeftBlank
                i = i + j
                while(szContent[i] == " ")
                {
                    i = i + 1
                }
            }
            sz1 = strmid(szContent,i,iLen)
            sz1 = cat(szPreStr,sz1)
            if((isEnd == 1) && (nIdx == (lnMax - 1))
            {
                sz1 = cat(sz1," */")
            }
            InsBufLine(hbuf, ln, "@sz1@")
        }
        ln = ln + 1
        nIdx = nIdx + 1
    }
    closebuf(hNewBuf)
    return ln - 1
}
macro FuncHeadCommentEN(hbuf, ln, szFunc, szMyName,newFunc)
{
    iIns = 0
    if(newFunc != 1)
    {
        symbol = GetSymbolLocationFromLn(hbuf, ln)
        if(strlen(symbol) > 0)
        {
            hTmpBuf = NewBuf("Tempbuf")
                
            //将文件参数头整理成一行并去掉了注释
            szLine = GetFunctionDef(hbuf,symbol)            
            iBegin = symbol.ichName
            
            //取出返回值定义
            szTemp = strmid(szLine,0,iBegin)
            szTemp = TrimString(szTemp)
            szRet =  GetFirstWord(szTemp)
            if(symbol.Type == "Method")
            {
                szTemp = strmid(szTemp,strlen(szRet),strlen(szTemp))
                szTemp = TrimString(szTemp)
                if(szTemp == "::")
                {
                    szRet = ""
                }
            }
            if(toupper (szRet) == "MACRO")
            {
                //对于宏返回值特殊处理
                szRet = ""
            }
            
            //从函数头分离出函数参数
            nMaxParamSize = GetWordFromString(hTmpBuf,szLine,iBegin,strlen(szLine),"(",",",")")
            lnMax = GetBufLineCount(hTmpBuf)
            ln = symbol.lnFirst
            SetBufIns (hbuf, ln, 0)
        }
    }
    else
    {
        lnMax = 0
        szRet = ""
        szLine = ""
    }
    InsBufLine(hbuf, ln, "/*****************************************************************************")
    InsBufLine(hbuf, ln+1, " Prototype    : @szFunc@")
    InsBufLine(hbuf, ln+2, " Description  : ")
    oldln  = ln 
    szIns = " Input        : "
    if(newFunc != 1)
    {
        //对于已经存在的函数输出输入参数表
        i = 0
        while ( i < lnMax) 
        {
            szTmp = GetBufLine(hTmpBuf, i)
            nLen = strlen(szTmp);
            
            //对齐参数后面的空格，实际是对齐后面的参数的说明
            szBlank = CreateBlankString(nMaxParamSize - nLen + 2)
            szTmp = cat(szTmp,szBlank)
            ln = ln + 1
            szTmp = cat(szIns,szTmp)
            InsBufLine(hbuf, ln+2, "@szTmp@")
            iIns = 1
            szIns = "                "
            i = i + 1
        }    
        closebuf(hTmpBuf)
    }
    if(iIns == 0)
    {       
            ln = ln + 1
            InsBufLine(hbuf, ln+2, " Input        : None")
    }
    InsBufLine(hbuf, ln+3, " Output       : None")
    InsBufLine(hbuf, ln+4, " Return Value : @szRet@")
//    InsBufLine(hbuf, ln+5, " Calls        : ")
//    InsBufLine(hbuf, ln+6, " Called By    : ")
    InsbufLIne(hbuf, ln+5, " ");
    
    SysTime = GetSysTime(1);
    sz1=SysTime.Year
    sz2=SysTime.month
    sz3=SysTime.day

    InsBufLine(hbuf, ln + 6, "  History        :")
    InsBufLine(hbuf, ln + 7, "  1.Date         : @sz1@/@sz2@/@sz3@")
    InsBufLine(hbuf, ln + 8, "    Author       : @szMyName@")
    InsBufLine(hbuf, ln + 9, "    Modification : Created function")
    InsBufLine(hbuf, ln + 10, "")    
    InsBufLine(hbuf, ln + 11, "*****************************************************************************/")
    if ((newFunc == 1) && (strlen(szFunc)>0))
    {
        InsBufLine(hbuf, ln+12, "UINT32_T  @szFunc@( # )")
        InsBufLine(hbuf, ln+13, "{");
        InsBufLine(hbuf, ln+14, "    #");
        InsBufLine(hbuf, ln+15, "}");
        SearchForward()
    }        
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    sel.ichFirst = 0
    sel.ichLim = sel.ichFirst
    sel.lnFirst = ln + 14
    sel.lnLast = ln + 14        
    szContent = Ask("Description")
    DelBufLine(hbuf,oldln + 2)
    setWndSel(hwnd,sel)
    newln = CommentContent(hbuf,oldln + 2," Description  : ",szContent,0) - 2
    ln = ln + newln - oldln
    if ((newFunc == 1) && (strlen(szFunc)>0))
    {
        //提示输入函数返回值名
        szRet = Ask("Please input return value type")
        if(strlen(szRet) > 0)
        {
            PutBufLine(hbuf, ln+4, " Return Value : @szRet@")            
            PutBufLine(hbuf, ln+12, "@szRet@ @szFunc@( # )")
            SetbufIns(hbuf,ln+12,strlen(szRet)+strlen(szFunc) + 3
        }
        szFuncDef = ""
        isFirstParam = 1
        sel.ichFirst = strlen(szFunc)+strlen(szRet) + 3
        sel.ichLim = sel.ichFirst + 1

        //循环输入新函数的参数
      /*while (1)
        {
            szParam = ask("Please input parameter")
            szParam = TrimString(szParam)
            szTmp = cat(szIns,szParam)
            szParam = cat(szFuncDef,szParam)
            sel.lnFirst = ln + 12
            sel.lnLast = ln + 12
            setWndSel(hwnd,sel)
            sel.ichFirst = sel.ichFirst + strlen(szParam)
            sel.ichLim = sel.ichFirst
            oldsel = sel
            
            if(szTmp == "")
            	return ln + 17
            	
            if(isFirstParam == 1)
            {
                PutBufLine(hbuf, ln+2, "@szTmp@")
                isFirstParam  = 0
            }
            else
            {
                ln = ln + 1
                InsBufLine(hbuf, ln+2, "@szTmp@")
                oldsel.lnFirst = ln + 12
                oldsel.lnLast = ln + 12        
            }
            SetBufSelText(hbuf,szParam)
            szIns = "                "
            szFuncDef = ", "
            oldsel.lnFirst = ln + 14
            oldsel.lnLast = ln + 14
            oldsel.ichFirst = 4
            oldsel.ichLim = 5
            setWndSel(hwnd,oldsel)
        }*/
    }
    return ln + 17
}

/*
*新建立一个函数
*/
macro FunctionHeaderCreate()
{
	hwnd = GetCurrentWnd()
	if (hwnd == 0)
		stop
	sel = GetWndSel(hwnd)
	ln = sel.lnFirst
	hbuf = GetWndBuf(hwnd)
	language = getreg(LANGUAGE)
	
//	if(language != 1)
//	{
//		language = 0
//	}
		
	szMyName = getreg(UserName)
	if(strlen( szMyName ) == 0)
	{
		szMyName = Ask("Enter your name:")
		setreg(MYNAME, szMyName)
	}
//	nVer = GetVersion()
	lnMax = GetBufLineCount(hbuf)
	if(ln != lnMax)
	{
		szNextLine = GetBufLine(hbuf,ln)
		if( (strstr(szNextLine,"(") != 0xffffffff) || (nVer != 2 ))
		{
			symbol = GetCurSymbol()
			if(strlen(symbol) != 0)
			{            
				/*if(language == 0)
				{
					FuncHeadCommentCN(hbuf, ln, symbol, szMyName,0)
				}
				else*/
				{                
					FuncHeadCommentEN(hbuf, ln, symbol, szMyName,0)
				}
				return
			}
		}
	}

	/*if(language == 0 )
	{
		szFuncName = Ask("请输入函数名称:")
		FuncHeadCommentCN(hbuf, ln, szFuncName, szMyName, 1)
	}
	else*/
	{
		szFuncName = Ask("Please input function name")
		FuncHeadCommentEN(hbuf, ln, szFuncName, szMyName, 1)

	}
}


macro GetFunctionList(hbuf,hnewbuf)
{
    isymMax = GetBufSymCount (hbuf)
    isym = 0
    //依次取出全部的但前buf符号表中的全部符号
    while (isym < isymMax) 
    {
        symbol = GetBufSymLocation(hbuf, isym)
        if(symbol.Type == "Class Placeholder")
        {
	        hsyml = SymbolChildren(symbol)
			cchild = SymListCount(hsyml)
			ichild = 0
	    	while (ichild < cchild)
			{
				childsym = SymListItem(hsyml, ichild)
                AppendBufLine(hnewbuf,childsym.symbol)
				ichild = ichild + 1
			}
	        SymListFree(hsyml)
        }
        if(strlen(symbol) > 0)
        {
            if( (symbol.Type == "Method") || 
                (symbol.Type == "Function") || ("Editor Macro" == symbol.Type) )
            {
                //取出类型是函数和宏的符号
                symname = symbol.Symbol
                //将符号插入到新buf中这样做是为了兼容V2.1
                AppendBufLine(hnewbuf,symname)
               }
           }
        isym = isym + 1
    }
}

macro GetFileName(sz)
{
    i = 1
    szName = sz
    iLen = strlen(sz)
    if(iLen == 0)
      return ""
    while( i <= iLen)
    {
      if(sz[iLen-i] == "\\")
      {
        szName = strmid(sz,iLen-i+1,iLen)
        break
      }
      i = i + 1
    }
    return szName
}

macro InsertFileList(hbuf,hnewbuf,ln)
{
    if(hnewbuf == hNil)
    {
        return ln
    }
    isymMax = GetBufLineCount (hnewbuf)
    isym = 0
    while (isym < isymMax) 
    {
        szLine = GetBufLine(hnewbuf, isym)
        InsBufLine(hbuf,ln,"              @szLine@")
        ln = ln + 1
        isym = isym + 1
    }
    return ln 
}
macro InsertFileHeaderEN(hbuf, ln,szName,szContent)
{
    
    hnewbuf = newbuf("")
    if(hnewbuf == hNil)
    {
        stop
    }
    GetFunctionList(hbuf,hnewbuf)
    InsBufLine(hbuf, ln + 0,  "/******************************************************************************")
    InsBufLine(hbuf, ln + 1,  "")
    InsBufLine(hbuf, ln + 2,  "  Copyright (C), 2001-2019, xxx Co., Ltd.")
    InsBufLine(hbuf, ln + 3,  "")
    InsBufLine(hbuf, ln + 4,  " ******************************************************************************")
    sz = GetFileName(GetBufName (hbuf))
    InsBufLine(hbuf, ln + 5,  "  File Name     : @sz@")
    InsBufLine(hbuf, ln + 6,  "  Version       : Initial Draft")
    InsBufLine(hbuf, ln + 7,  "  Author        : @szName@")
    SysTime = GetSysTime(1)
    sz=SysTime.Year
    sz1=SysTime.month
    sz3=SysTime.day
    InsBufLine(hbuf, ln + 8,  "  Created       : @sz@/@sz1@/@sz3@")
    InsBufLine(hbuf, ln + 9,  "  Last Modified :")
    szTmp = "  Description   : "
    nlnDesc = ln
    iLen = strlen (szContent)
    InsBufLine(hbuf, ln + 10, "  Description   : @szContent@")
    InsBufLine(hbuf, ln + 11, "")
    
    //插入函数列表
    ln = InsertFileList(hbuf,hnewbuf,ln + 12) - 12
    closebuf(hnewbuf)
    InsBufLine(hbuf, ln + 12, "  History       :")
    InsBufLine(hbuf, ln + 13, "  1.Date        : @sz@/@sz1@/@sz3@")
    InsBufLine(hbuf, ln + 14, "    Author      : @szName@")
    InsBufLine(hbuf, ln + 15, "    Modification: Created file")
    InsBufLine(hbuf, ln + 16, "")
    InsBufLine(hbuf, ln + 17, "******************************************************************************/")
    InsBufLine(hbuf, ln + 20, "")
    InsBufLine(hbuf, ln + 21, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 22, " * Debug switch Section                          *")
    InsBufLine(hbuf, ln + 23, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 24, "")
    InsBufLine(hbuf, ln + 25, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 26, " * Include File Section                 *")
    InsBufLine(hbuf, ln + 27, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 28, "")
    InsBufLine(hbuf, ln + 29, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 30, " * Macro Define Section                 *")
    InsBufLine(hbuf, ln + 31, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 32, "")
    InsBufLine(hbuf, ln + 33, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 34, " * Struct Define Section               *")
    InsBufLine(hbuf, ln + 35, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 36, "")
    InsBufLine(hbuf, ln + 37, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 38, " * Prototype Declare Section              *")
    InsBufLine(hbuf, ln + 39, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 40, "")
    
//    InsBufLine(hbuf, ln + 39, "/*----------------------------------------------*")
//    InsBufLine(hbuf, ln + 40, " * constants                                    *")
//    InsBufLine(hbuf, ln + 41, " *----------------------------------------------*/")
//    InsBufLine(hbuf, ln + 42, "")
//    InsBufLine(hbuf, ln + 43, "/*----------------------------------------------*")
//    InsBufLine(hbuf, ln + 44, " * macros                                       *")
//    InsBufLine(hbuf, ln + 45, " *----------------------------------------------*/")
//    InsBufLine(hbuf, ln + 46, "")
//    InsBufLine(hbuf, ln + 47, "/*----------------------------------------------*")
//    InsBufLine(hbuf, ln + 48, " * routines' implementations                    *")
//    InsBufLine(hbuf, ln + 49, " *----------------------------------------------*/")
//    InsBufLine(hbuf, ln + 50, "")
    if(iLen != 0)
    {
        return
    }
    
    //如果没有功能描述内容则提示输入
    szContent = Ask("Description")
    SetBufIns(hbuf,nlnDesc + 14,0)
    DelBufLine(hbuf,nlnDesc +10)
    
    //注释输出处理,自动换行
    CommentContent(hbuf,nlnDesc + 10,"  Description   : ",szContent,0)
}
macro FileHeaderCreate()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    ln = 0
    hbuf = GetWndBuf(hwnd)
    language = getreg(LANGUAGE)
    if(language != 1)
    {
        language = 0
    }
    szMyName = getreg(MYNAME)
    if(strlen( szMyName ) == 0)
    {
        szMyName = Ask("Enter your name:")
        setreg(MYNAME, szMyName)
    }
       SetBufIns (hbuf, 0, 0)
/*    if(language == 0)
    {
        InsertFileHeaderCN( hbuf,ln, szMyName,"" )
    }
    else */
    {
        InsertFileHeaderEN( hbuf,ln, szMyName,"" )
    }
}

macro GetFileNameNoExt(sz)
{
    i = 1
    szName = sz
    iLen = strlen(sz)
    j = iLen 
    if(iLen == 0)
      return ""
    while( i <= iLen)
    {
      if(sz[iLen-i] == ".")
      {
         j = iLen-i 
      }
      if( sz[iLen-i] == "\\" )
      {
         szName = strmid(sz,iLen-i+1,j)
         return szName
      }
      i = i + 1
    }
    szName = strmid(sz,0,j)
    return szName
}

macro GetFileNameExt(sz)
{
    i = 1
    j = 0
    szName = sz
    iLen = strlen(sz)
    if(iLen == 0)
      return ""
    while( i <= iLen)
    {
      if(sz[iLen-i] == ".")
      {
         j = iLen-i 
         szExt = strmid(sz,j + 1,iLen)
         return szExt
      }
      i = i + 1
    }
    return ""
}

macro HeadIfdefStr(sz)
{
    hwnd = GetCurrentWnd()
    lnFirst = GetWndSelLnFirst(hwnd)
    hbuf = GetCurrentBuf()
    InsBufLine(hbuf, lnFirst, "")
    InsBufLine(hbuf, lnFirst, "#define @sz@")
    InsBufLine(hbuf, lnFirst, "#ifndef @sz@")
    iTotalLn = GetBufLineCount (hbuf)                
    InsBufLine(hbuf, iTotalLn, "#endif /* @sz@ */")
    InsBufLine(hbuf, iTotalLn, "")
}

macro GetLeftWord(szLine,ichRight)
{
    if(ich == 0)
    {
        return ""
    }
    ich = ichRight
    while(ich > 0)
    {
        if( (szLine[ich] == " ") || (szLine[ich] == "\t")
            || ( szLine[ich] == ":") || (szLine[ich] == "."))

        {
            ich = ich - 1
            ichRight = ich
        }
        else
        {
            break
        }
    }    
    while(ich > 0)
    {
        if(szLine[ich] == " ")
        {
            ich = ich + 1
            break
        }
        ich = ich - 1
    }
    return strmid(szLine,ich,ichRight)
}

macro SkipCommentFromString(szLine,isCommentEnd)
{
    RetVal = ""
    fIsEnd = 1
    nLen = strlen(szLine)
    nIdx = 0
    while(nIdx < nLen )
    {
        //如果当前行开始还是被注释，或遇到了注释开始的变标记，注释内容改为空格�
        if( (isCommentEnd == 0) || (szLine[nIdx] == "/" && szLine[nIdx+1] == "*"))
        {
            fIsEnd = 0
            while(nIdx < nLen )
            {
                if(szLine[nIdx] == "*" && szLine[nIdx+1] == "/")
                {
                    szLine[nIdx+1] = " "
                    szLine[nIdx] = " " 
                    nIdx = nIdx + 1 
                    fIsEnd  = 1
                    isCommentEnd = 1
                    break
                }
                szLine[nIdx] = " "
                
                //如果是倒数第二个则最后一个也肯定是在注释内
//                if(nIdx == nLen -2 )
//                {
//                    szLine[nIdx + 1] = " "
//                }
                nIdx = nIdx + 1 
            }    
            
            //如果已经到了行尾终止搜索
            if(nIdx == nLen)
            {
                break
            }
        }
        
        //如果遇到的是//来注释的说明后面都为注释
        if(szLine[nIdx] == "/" && szLine[nIdx+1] == "/")
        {
            szLine = strmid(szLine,0,nIdx)
            break
        }
        nIdx = nIdx + 1                
    }
    RetVal.szContent = szLine;
    RetVal.fIsEnd = fIsEnd
    return RetVal
}

macro CreateClassPrototype(hbuf,ln,symbol)
{
    isLastLine = 0
    fIsEnd = 1
    hOutbuf = GetCurrentBuf()
    szLine = GetBufLine (hbuf, symbol.lnName)
    sline = symbol.lnFirst     
    szClassName = symbol.Symbol
    ret = strstr(szLine,szClassName)
    if(ret == 0xffffffff)
    {
        return ln
    }
    szPre = strmid(szLine,0,ret)
    szLine = strmid(szLine,symbol.ichName,strlen(szLine))
    szLine = cat(szPre,szLine)
    //去掉注释的干扰
    RetVal = SkipCommentFromString(szLine,fIsEnd)
    fIsEnd = RetVal.fIsEnd
    szNew = RetVal.szContent
    szLine = cat("    ",szLine)
    szNew = cat("    ",szNew)
    while((isLastLine == 0) && (sline < symbol.lnLim))
    {   
        i = 0
        j = 0
        iLen = strlen(szNew)
        while(i < iLen)
        {
            if(szNew[i]=="(")
            {
               j = j + 1;
            }
            else if(szNew[i]==")")
            {
                j = j - 1;
                if(j <= 0)
                {
                    //函数参数头结束
                    isLastLine = 1  
                    //去掉最后多余的字符
        	        szLine = strmid(szLine,0,i+1);
                    szLine = cat(szLine,";")
                    break
                }
            }
            i = i + 1
        }
        InsBufLine(hOutbuf, ln, "@szLine@")
        ln = ln + 1
        sline = sline + 1
        if(isLastLine != 1)
        {              
            //函数参数头还没有结束再取一行
            szLine = GetBufLine (hbuf, sline)
            //去掉注释的干扰
            RetVal = SkipCommentFromString(szLine,fIsEnd)
	        szNew = RetVal.szContent
	        fIsEnd = RetVal.fIsEnd
        }                    
    }
    return ln
}

macro CreateFuncPrototype(hbuf,ln,szType,symbol)
{
    isLastLine = 0
    hOutbuf = GetCurrentBuf()
    szLine = GetBufLine (hbuf,symbol.lnName)
    //去掉注释的干扰
    RetVal = SkipCommentFromString(szLine,fIsEnd)
    szNew = RetVal.szContent
    fIsEnd = RetVal.fIsEnd
    szLine = cat("@szType@ ",szLine)
    szNew = cat("@szType@ ",szNew)
    sline = symbol.lnFirst     
    while((isLastLine == 0) && (sline < symbol.lnLim))
    {   
        i = 0
        j = 0
        iLen = strlen(szNew)
        while(i < iLen)
        {
            if(szNew[i]=="(")
            {
               j = j + 1;
            }
            else if(szNew[i]==")")
            {
                j = j - 1;
                if(j <= 0)
                {
                    //函数参数头结束
                    isLastLine = 1  
                    //去掉最后多余的字符
        	        szLine = strmid(szLine,0,i+1);
                    szLine = cat(szLine,";")
                    break
                }
            }
            i = i + 1
        }
        InsBufLine(hOutbuf, ln, "@szLine@")
        ln = ln + 1
        sline = sline + 1
        if(isLastLine != 1)
        {              
            //函数参数头还没有结束再取一行
            szLine = GetBufLine (hbuf, sline)
            szLine = cat("         ",szLine)
            //去掉注释的干扰
            RetVal = SkipCommentFromString(szLine,fIsEnd)
	        szNew = RetVal.szContent
	        fIsEnd = RetVal.fIsEnd
        }                    
    }
    return ln
}

/*
*	创建一个头文件
*/
macro CreateNewHeaderFile()
{
	hbuf = GetCurrentBuf()
	language = getreg(LANGUAGE)
	/*if(language != 1)
	{
		language = 0
	}*/
	language = 1
	szName = getreg(UserName)
	if(strlen( szName ) == 0)
	{
		szMyName = Ask("Enter your name:")
		setreg(MYNAME, szMyName)
	}
	isymMax = GetBufSymCount(hbuf)
	isym = 0
	ln = 0
	
	//获得当前没有后缀的文件名
	sz = ask("Please input header file name")
	szFileName = GetFileNameNoExt(sz)
	szExt = GetFileNameExt(sz)        
	szPreH = toupper (szFileName)
	szPreH = cat("__",szPreH)
	szExt = toupper(szExt)
	szPreH = cat(szPreH,"_@szExt@__")
	hOutbuf = NewBuf(sz) // create output buffer
	if (hOutbuf == 0)
		stop

	SetCurrentBuf(hOutbuf)
//	InsertCPP(hOutbuf,0)
	HeadIfdefStr(szPreH)
	szContent = GetFileName(GetBufName (hbuf))
	
	/*if(language == 0)
	{
		szContent = cat(szContent," 的头文件")

		//插入文件头说明
		InsertFileHeaderCN(hOutbuf,0,szName,szContent)
	}
	else */
	{
		szContent = cat(szContent," header file")

		//插入文件头说明
		InsertFileHeaderEN(hOutbuf,0,szName,szContent)        
	}

	lnMax = GetBufLineCount(hOutbuf)
	if(lnMax > 4)
	{
		ln = lnMax -4
	}
	else
	{
		return
	}
	hwnd = GetCurrentWnd()
	if (hwnd == 0)
		stop
		
	sel = GetWndSel(hwnd)
	sel.lnFirst = ln
	sel.ichFirst = 0
	sel.ichLim = 0
	SetBufIns(hOutbuf,ln,0)
	szType = Ask ("Please prototype type : extern or static")
	
	//搜索符号表取得函数名
	while (isym < isymMax) 
	{
	    isLastLine = 0
	    symbol = GetBufSymLocation(hbuf, isym)
	    fIsEnd = 1
	    if(strlen(symbol) > 0)
	    {
	        if(symbol.Type == "Class Placeholder")
	        {
			hsyml = SymbolChildren(symbol)
			cchild = SymListCount(hsyml)
			ichild = 0
			szClassName = symbol.Symbol
			InsBufLine(hOutbuf, ln, "}")
			InsBufLine(hOutbuf, ln, "{")
			InsBufLine(hOutbuf, ln, "class @szClassName@")
			ln = ln + 2
		    	while (ichild < cchild)
			{
				childsym = SymListItem(hsyml, ichild)
				childsym.Symbol = szClassName
				ln = CreateClassPrototype(hbuf,ln,childsym)
				ichild = ichild + 1
			}
			SymListFree(hsyml)
			InsBufLine(hOutbuf, ln + 1, "")
			ln = ln + 2
	        }
	        else if( symbol.Type == "Function" )
	        {
			ln = CreateFuncPrototype(hbuf,ln,szType,symbol)
	        }
	        else if( symbol.Type == "Method" ) 
	        {
			szLine = GetBufline(hbuf,symbol.lnName)
			szClassName = GetLeftWord(szLine,symbol.ichName)
			symbol.Symbol = szClassName
			ln = CreateClassPrototype(hbuf,ln,symbol)            
	        }
	    }
	    isym = isym + 1
	}
	sel.lnLast = ln 
	SetWndSel(hwnd,sel)
}

macro InsertCFileEN(hbuf, ln,szName,szContent)
{
    
    hnewbuf = newbuf("")
    if(hnewbuf == hNil)
    {
        stop
    }
    GetFunctionList(hbuf,hnewbuf)
    InsBufLine(hbuf, ln + 0,  "/******************************************************************************")
    InsBufLine(hbuf, ln + 1,  "")
    InsBufLine(hbuf, ln + 2,  "  Copyright (C), 2001-2019, xxx Co., Ltd.")
    InsBufLine(hbuf, ln + 3,  "")
    InsBufLine(hbuf, ln + 4,  " ******************************************************************************")
    sz = GetFileName(GetBufName (hbuf))
    InsBufLine(hbuf, ln + 5,  "  File Name     : @sz@")
    InsBufLine(hbuf, ln + 6,  "  Version       : Initial Draft")
    InsBufLine(hbuf, ln + 7,  "  Author        : @szName@")
    SysTime = GetSysTime(1)
    sz=SysTime.Year
    sz1=SysTime.month
    sz3=SysTime.day
    InsBufLine(hbuf, ln + 8,  "  Created       : @sz@/@sz1@/@sz3@")
    InsBufLine(hbuf, ln + 9,  "  Last Modified :")
    szTmp = "  Description   : "
    nlnDesc = ln
    iLen = strlen (szContent)
    InsBufLine(hbuf, ln + 10, "  Description   : ")
    InsBufLine(hbuf, ln + 11, "")
    
    //插入函数列表
    ln = InsertFileList(hbuf,hnewbuf,ln + 12) - 12
    closebuf(hnewbuf)
    InsBufLine(hbuf, ln + 12, "  History       :")
    InsBufLine(hbuf, ln + 13, "  1.Date        : @sz@/@sz1@/@sz3@")
    InsBufLine(hbuf, ln + 14, "    Author      : @szName@")
    InsBufLine(hbuf, ln + 15, "    Modification: Created file")
    InsBufLine(hbuf, ln + 16, "")
    InsBufLine(hbuf, ln + 17, "******************************************************************************/")
    InsBufLine(hbuf, ln + 18, "")
    InsBufLine(hbuf, ln + 19, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 20, " * Debug switch Section                          *")
    InsBufLine(hbuf, ln + 21, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 22, "")
    InsBufLine(hbuf, ln + 23, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 24, " * Include File Section                            *")
    InsBufLine(hbuf, ln + 25, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 26, "")
    InsBufLine(hbuf, ln + 27, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 28, " * Macro Define Section                         *")
    InsBufLine(hbuf, ln + 29, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 30, "")
    InsBufLine(hbuf, ln + 31, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 32, " * Struct Define Section                         *")
    InsBufLine(hbuf, ln + 33, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 34, "")
    InsBufLine(hbuf, ln + 35, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 36, " * Prototype Declare Section                 *")
    InsBufLine(hbuf, ln + 37, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 38, "")
    InsBufLine(hbuf, ln + 39, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 40, " * Global Variable Declare Section         *")
    InsBufLine(hbuf, ln + 41, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 42, "")
    InsBufLine(hbuf, ln + 43, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 44, " * File Static Variable Define Section      *")
    InsBufLine(hbuf, ln + 45, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 46, "")
    InsBufLine(hbuf, ln + 47, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 48, " * Function Define Section                     *")
    InsBufLine(hbuf, ln + 49, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 50, "")

    if(iLen != 0)
    {
        return
    }
    
}

/*
*	创建一个.c文件
*/
macro CreateNewCFile()
{
	hbuf = GetCurrentBuf()
	language = getreg(LANGUAGE)
	/*if(language != 1)
	{
		language = 0
	}*/
	language = 1
	szName = getreg(UserName)
	if(strlen( szName ) == 0)
	{
		szMyName = Ask("Enter your name:")
		setreg(MYNAME, szMyName)
	}
	isymMax = GetBufSymCount(hbuf)
	isym = 0
	ln = 0
	
	//获得当前没有后缀的文件名
	sz = ask("Please input header file name")
	szFileName = GetFileNameNoExt(sz)
	szExt = GetFileNameExt(sz)        
	szPreH = toupper (szFileName)
	szPreH = cat("__",szPreH)
	szExt = toupper(szExt)
	szPreH = cat(szPreH,"_@szExt@__")
	hOutbuf = NewBuf(sz) // create output buffer
	if (hOutbuf == 0)
		stop
		
	SetCurrentBuf(hOutbuf)
	szContent = GetFileName(GetBufName (hbuf))	
	//插入文件头说明
	InsertCFileEN(hOutbuf,0,szName,szContent)    
}


macro InsertCFileEN_zgmicro(hbuf, ln,szName,szContent)
{
    
	hnewbuf = newbuf("")
	if(hnewbuf == hNil)
	{
	    stop
	}
	GetFunctionList(hbuf,hnewbuf)
	InsBufLine(hbuf, ln + 0,  "/*------------------------------------------------------------------------------")
	InsBufLine(hbuf, ln + 1,  "                    COPYRIGHT (C) 2009, Vimicro Corporation")
	InsBufLine(hbuf, ln + 2,  "                              ALL RIGHTS RESERVED")
	InsBufLine(hbuf, ln + 3,  "")
	InsBufLine(hbuf, ln + 4,  "This source code has been made available to you by VIMICRO on an AS-IS basis.")
	InsBufLine(hbuf, ln + 5,  "Anyone receiving this source code is licensed under VIMICRO copyrights to use")
	InsBufLine(hbuf, ln + 6,  "it in any way he or she deems fit, including copying it, modifying it,")
	InsBufLine(hbuf, ln + 7,  "compiling it, and redistributing it either with or without modifications. Any")
	InsBufLine(hbuf, ln + 8,  "person who transfers this source code or any derivative work must include the")
	InsBufLine(hbuf, ln + 9,  "VIMICRO copyright notice and this paragraph in the transferred software.")
       InsBufLine(hbuf, ln + 10,  "")        
                
    sz = GetFileName(GetBufName (hbuf))
    InsBufLine(hbuf, ln + 11,  "  File Name     : @sz@")
    InsBufLine(hbuf, ln + 12,  "  Version       : Initial Draft")
    InsBufLine(hbuf, ln + 13,  "  Author        : @szName@")
    SysTime = GetSysTime(1)
    sz=SysTime.Year
    sz1=SysTime.month
    sz3=SysTime.day
    InsBufLine(hbuf, ln + 14,  "  Created       : @sz@/@sz1@/@sz3@")
    InsBufLine(hbuf, ln + 15,  "  Last Modified :")
    szTmp = "  Description   : "
    nlnDesc = ln
    iLen = strlen (szContent)
    InsBufLine(hbuf, ln + 16, "  Description   : ")
    InsBufLine(hbuf, ln + 17, "")
    
    InsBufLine(hbuf, ln + 18, "  History       :")
    InsBufLine(hbuf, ln + 19, "  1.Date        : @sz@/@sz1@/@sz3@")
    InsBufLine(hbuf, ln + 20, "    Author      : @szName@")
    InsBufLine(hbuf, ln + 21, "    Modification: Created file")
    InsBufLine(hbuf, ln + 22, "")
    InsBufLine(hbuf, ln + 23, "------------------------------------------------------------------------------*/")
    InsBufLine(hbuf, ln + 24, "")
    InsBufLine(hbuf, ln + 25, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 26, " * Debug switch Section                          *")
    InsBufLine(hbuf, ln + 27, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 28, "")
    InsBufLine(hbuf, ln + 29, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 30, " * Include File Section                            *")
    InsBufLine(hbuf, ln + 31, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 32, "")
    InsBufLine(hbuf, ln + 33, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 34, " * Macro Define Section                         *")
    InsBufLine(hbuf, ln + 35, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 36, "")
    InsBufLine(hbuf, ln + 37, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 38, " * Struct Define Section                         *")
    InsBufLine(hbuf, ln + 39, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 40, "")
    InsBufLine(hbuf, ln + 41, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 42, " * Prototype Declare Section                 *")
    InsBufLine(hbuf, ln + 43, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 44, "")
    InsBufLine(hbuf, ln + 45, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 46, " * Global Variable Declare Section         *")
    InsBufLine(hbuf, ln + 47, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 48, "")
    InsBufLine(hbuf, ln + 49, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 50, " * File Static Variable Define Section      *")
    InsBufLine(hbuf, ln + 51, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 52, "")
    InsBufLine(hbuf, ln + 53, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 54, " * Function Define Section                     *")
    InsBufLine(hbuf, ln + 55, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 56, "")

    if(iLen != 0)
    {
        return
    }
    
}
/*
*	创建一个公司定义的.c文件
*/
macro CreateNewCFile_zgmicro()
{
	hbuf = GetCurrentBuf()
	language = getreg(LANGUAGE)
	/*if(language != 1)
	{
		language = 0
	}*/
	language = 1
	szName = getreg(UserName)
	if(strlen( szName ) == 0)
	{
		szMyName = Ask("Enter your name:")
		setreg(MYNAME, szMyName)
	}
	isymMax = GetBufSymCount(hbuf)
	isym = 0
	ln = 0
	
	//获得当前没有后缀的文件名
	sz = ask("Please input header file name")
	szFileName = GetFileNameNoExt(sz)
	szExt = GetFileNameExt(sz)        
	szPreH = toupper (szFileName)
	szPreH = cat("__",szPreH)
	szExt = toupper(szExt)
	szPreH = cat(szPreH,"_@szExt@__")
	hOutbuf = NewBuf(sz) // create output buffer
	if (hOutbuf == 0)
		stop
		
	SetCurrentBuf(hOutbuf)
	szContent = GetFileName(GetBufName (hbuf))	
	//插入文件头说明
	InsertCFileEN_zgmicro(hOutbuf,0,szName,szContent)   
}
