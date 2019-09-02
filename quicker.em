/* 
 * ��ȡ�ļ�������չ����·�����ļ������Ϣ
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
 * ���´�������ʾ��ǰ�༭�ļ���·�����ļ���
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

	SetBufDirty(hbuftemp, FALSE);	// don��t bother asking to save
	hwnd = NewWnd(hbuftemp)	// ��ʾ���
}

/*
  * ��������: ����������û���Ϣ
  * ���û�������Ϣд��ע���
  * ע���·����HKEY_CURRENT_USER/Software/Source Dynamics/Source Insight/3.0
  */
macro SaveUserInfo( )
{
	//д���û���
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

	//д�뵥λ��
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

	//д���ҵ��ĵ���·��
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

//����ע��
macro CodeComments()
{
	hwnd=GetCurrentWnd()
	selection=GetWndSel(hwnd)
	LnFirst=GetWndSelLnFirst(hwnd)//ȡ�����к�
	LnLast=GetWndSelLnLast(hwnd)//ȡĩ���к�
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
		buf=GetBufLine(hbuf,Ln)//ȡLn��Ӧ����
	 	if(buf=="")//��������
	 	{
		 	Ln=Ln+1
			continue
 		}
	 	if(StrMid(buf,0,1)=="/")//��Ҫȡ��ע��,��ֹֻ�е��ַ�����
	 	{
			if(StrMid(buf,1,2)=="/")
			{
				PutBufLine(hbuf,Ln,StrMid(buf,2,Strlen(buf)))
			}
		}
		if(StrMid(buf,0,1)!="/")//��Ҫ���ע��
		{
			PutBufLine(hbuf,Ln,Cat("//",buf))
		}
		Ln=Ln+1
	}
SetWndSel( hwnd, selection )
}

