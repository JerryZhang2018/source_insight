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

