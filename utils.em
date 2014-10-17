/* Utils.em - a small collection of useful editing macros */



/*-------------------------------------------------------------------------
	I N S E R T   H E A D E R

	Inserts a comment header block at the top of the current function. 
	This actually works on any type of symbol, not just functions.

	To use this, define an environment variable "MYNAME" and set it
	to your email name.  eg. set MYNAME=raygr
-------------------------------------------------------------------------*/
macro InsertHeader()
{
	// Get the owner's name from the environment variable: MYNAME.
	// If the variable doesn't exist, then the owner field is skipped.
	szMyName = getenv(MYNAME)
	
	// Get a handle to the current file buffer and the name
	// and location of the current symbol where the cursor is.
	hbuf = GetCurrentBuf()
	szFunc = GetCurSymbol()
	ln = GetSymbolLine(szFunc)

	// begin assembling the title string
	sz = "/*   "
	
	/* convert symbol name to T E X T   L I K E   T H I S */
	cch = strlen(szFunc)
	ich = 0
	while (ich < cch)
		{
		ch = szFunc[ich]
		if (ich > 0)
			if (isupper(ch))
				sz = cat(sz, "   ")
			else
				sz = cat(sz, " ")
		sz = Cat(sz, toupper(ch))
		ich = ich + 1
		}
	
	sz = Cat(sz, "   */")
	InsBufLine(hbuf, ln, sz)
	InsBufLine(hbuf, ln+1, "/*-------------------------------------------------------------------------")
	
	/* if owner variable exists, insert Owner: name */
	if (strlen(szMyName) > 0)
		{
		InsBufLine(hbuf, ln+2, "    Owner: @szMyName@")
		InsBufLine(hbuf, ln+3, " ")
		ln = ln + 4
		}
	else
		ln = ln + 2
	
	InsBufLine(hbuf, ln,   "    ") // provide an indent already
	InsBufLine(hbuf, ln+1, "-------------------------------------------------------------------------*/")
	
	// put the insertion point inside the header comment
	SetBufIns(hbuf, ln, 4)
}


/* InsertFileHeader:

   Inserts a comment header block at the top of the current function. 
   This actually works on any type of symbol, not just functions.

   To use this, define an environment variable "MYNAME" and set it
   to your email name.  eg. set MYNAME=raygr
*/

macro InsertFileHeader()
{
	szMyName = getenv(MYNAME)
	
	hbuf = GetCurrentBuf()

	InsBufLine(hbuf, 0, "/*-------------------------------------------------------------------------")
	
	/* if owner variable exists, insert Owner: name */
	InsBufLine(hbuf, 1, "    ")
	if (strlen(szMyName) > 0)
		{
		sz = "    Owner: @szMyName@"
		InsBufLine(hbuf, 2, " ")
		InsBufLine(hbuf, 3, sz)
		ln = 4
		}
	else
		ln = 2
	
	InsBufLine(hbuf, ln, "-------------------------------------------------------------------------*/")
}



// Inserts "Returns True .. or False..." at the current line
macro ReturnTrueOrFalse()
{
	hbuf = GetCurrentBuf()
	ln = GetBufLineCur(hbuf)

	InsBufLine(hbuf, ln, "    Returns True if successful or False if errors.")
}



/* Inserts ifdef REVIEW around the selection */
macro IfdefReview()
{
	IfdefSz("REVIEW");
}


/* Inserts ifdef BOGUS around the selection */
macro IfdefBogus()
{
	IfdefSz("BOGUS");
}


/* Inserts ifdef NEVER around the selection */
macro IfdefNever()
{
	IfdefSz("NEVER");
}


// Ask user for ifdef condition and wrap it around current
// selection.
macro InsertIfdef()
{
	sz = Ask("Enter ifdef condition:")
	if (sz != "")
		IfdefSz(sz);
}
macro blame()
{
  filename = GetBufName (GetCurrentBuf ())
  path = strmid(filename,0,getFileName(filename));
  cmdline = cat(cat("cmd /C \"TortoiseProc.exe /command:blame /path:\"",filename),"\"\"")
  RunCmdLine (cmdline, path, 0);
}

macro diff()
{

  filename = GetBufName (GetCurrentBuf ())
  path = strmid(filename,0,getFileName(filename));
  cmdline = cat(cat("cmd /C \"TortoiseProc.exe /command:diff /path:\"",filename),"\"\"")
  //cmdline = cat(cat("TortoiseProc.exe /command:diff /path:\"",filename),"\"")
  RunCmdLine (cmdline, path, 0);

}

macro log()
{
  filename = GetBufName (GetCurrentBuf ())

  path = strmid(filename,0,getFileName(filename));
  cmdline = cat(cat("cmd /C \"TortoiseProc.exe /command:log /path:\"",filename),"\"\"")
  //cmdline = cat(cat("TortoiseProc.exe /command:diff /path:\"",filename),"\"")
  RunCmdLine (cmdline, path, 0);
}

macro explorer()
{
  filename = GetBufName (GetCurrentBuf ())
  path = strmid(filename,0,getFileName(filename));
  cmdline = cat(cat("explorer /select,\"",filename),"\"");
  RunCmdLine (cmdline, path, 0);
}


macro getFileName(str)
{//µ¹Ðò²éÕÒ"\"
  pos = strlen(str) - 1;
  while(pos >= 0)
  { 
    if(strmid (str,pos, pos+1) == "\\")
      return pos;
    pos = pos - 1;
  }
}

macro InsertCPlusPlus()
{
	IfdefSz("__cplusplus");
}


// Wrap ifdef <sz> .. endif around the current selection
macro IfdefSz(sz)
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#ifdef @sz@")
	InsBufLine(hbuf, lnLast+2, "#endif /* @sz@ */")
}


// Delete the current line and appends it to the clipboard buffer
macro KillLine()
{
	hbufCur = GetCurrentBuf();
	lnCur = GetBufLnCur(hbufCur)
	hbufClip = GetBufHandle("Clipboard")
	AppendBufLine(hbufClip, GetBufLine(hbufCur, lnCur))
	DelBufLine(hbufCur, lnCur)
}


// Paste lines killed with KillLine (clipboard is emptied)
macro PasteKillLine()
{
	Paste
	EmptyBuf(GetBufHandle("Clipboard"))
}



// delete all lines in the buffer
macro EmptyBuf(hbuf)
{
	lnMax = GetBufLineCount(hbuf)
	while (lnMax > 0)
		{
		DelBufLine(hbuf, 0)
		lnMax = lnMax - 1
		}
}


// Ask the user for a symbol name, then jump to its declaration
macro JumpAnywhere()
{
	symbol = Ask("What declaration would you like to see?")
	JumpToSymbolDef(symbol)
}

	
// list all siblings of a user specified symbol
// A sibling is any other symbol declared in the same file.
macro OutputSiblingSymbols()
{
	symbol = Ask("What symbol would you like to list siblings for?")
	hbuf = ListAllSiblings(symbol)
	SetCurrentBuf(hbuf)
}


// Given a symbol name, open the file its declared in and 
// create a new output buffer listing all of the symbols declared
// in that file.  Returns the new buffer handle.
macro ListAllSiblings(symbol)
{
	loc = GetSymbolLocation(symbol)
	if (loc == "")
		{
		msg ("@symbol@ not found.")
		stop
		}
	
	hbufOutput = NewBuf("Results")
	
	hbuf = OpenBuf(loc.file)
	if (hbuf == 0)
		{
		msg ("Can't open file.")
		stop
		}
		
	isymMax = GetBufSymCount(hbuf)
	isym = 0;
	while (isym < isymMax)
		{
		AppendBufLine(hbufOutput, GetBufSymName(hbuf, isym))
		isym = isym + 1
		}

	CloseBuf(hbuf)
	
	return hbufOutput

}

macro checkEnv()
{
		//�汾�ж�,3.5056���³���֧��
		ProVer = GetProgramInfo ();
		if(ProVer.versionMinor < 50 || ProVer.versionBuild < 56)
		{
			Msg("����Source Insight�汾̫�ͣ�����ʹ�ô˹��ߣ��밲װ3.50.0060�����ϰ档");
			stop
		}
		
		initGlobal();//��ʼ��ȫ�ֱ���
		
		hProj = GetCurrentProj ();
		dir_proj = GetProjDir (hProj);

		//Ѱ�Ҵ���Ŀ¼
		depend_file = cat(dir_proj, "\\Build\\depend");
		
		//depend�ļ�������,˵�������source insight���̲���һ���ļ��У���ѯ��
		if(0 == ifExist(depend_file) )
		{	
			dir_proj = searchDir();
		}
		
		if(-1 == dir_proj )
		{
			dir_proj = Ask("�����뵱ǰ���̵Ĵ���Ŀ¼����'D:\\Code\\P_2011.05.04_XQ_2.608'�������б�ܡ�");
		}

		//���ݺ����б��ļ�,����Ѿ����ڵĻ�������
		con_file = cat(dir_proj, "\\clsList");
		clearCondition(hProj,con_file);
		//syncProj (hProj);
		Msg("��ǰ���������еĺ꣬�ָ���Ĭ��״̬��Ҫ�������û���������ȷ�����������ָ�Ĭ�ϣ����ȡ���������Ͻǵ�'X'��ť��");		
		
		//��depend�ļ�д������		
		depend_file = cat(dir_proj, "\\Build\\depend");
		cmd_count = writeDependFile(depend_file)
		
		//��depend_ti�ļ�д������
		depend_file = cat(dir_proj, "\\Build\\depend_ti");
		writeDependFile(depend_file)

		modiFile();
		
		Msg("���ȱ������Ĺ��̣���������ٰ�ȷ��!");

		//�򹤳���ӻ�������
		con_file = cat(dir_proj, "\\define");
		addCondition(hProj,con_file);

		//��depend�ļ������linux����
		depend_file = cat(dir_proj, "\\Build\\depend");
		ln = lineOfFile(depend_file, GetEnv("cmd_str0"));
		deleteCommand(depend_file, ln, cmd_count);

		depend_file = cat(dir_proj, "\\Build\\depend_ti");
		ln = lineOfFile(depend_file, GetEnv("cmd_str0"));
		deleteCommand(depend_file, ln, cmd_count);

		con_file = cat(dir_proj, "\\define");
		if(0 != ifExist(con_file))
		{
			//syncProj (hProj);
						
			Msg("���������Ѿ��趨��");			
		}
		else
		{
			Msg("���Ƿ�δ���롢���ߴ���·�������ֻ���û�б���ʱ__make:Nothing to be done for 'all'?����ǣ�������ļ������²�����");
		}
		
		//�����м��ļ�,������´β�������,������clsList����������������			
		com_str = cat("cmd /C \"del ",cat(dir_proj, "\\clsList\""));
		RunCmdLine (com_str, dir_proj, 1);		
		
		com_str = cat("cmd /C \"ren ",cat(dir_proj, "\\define clsList\""));
		RunCmdLine (com_str, dir_proj, 1);
}

//ȡ�е�����,����ȡ"version=2.6"�е�"version",��������Ⱥţ��򷵻�ԭ�ַ�����
macro nameOf(str)
{
	pos=0;
	while(pos<strlen (str))
	{
		if(strmid (str,pos, pos+1) == "=")
			break;
		pos = pos + 1;
	}
	return strmid (str,0,pos);
}

//ȡ��ʽ��ֵ,����ȡ"version=2.6"�е�"2.6"����������Ⱥţ��򷵻�"0"
macro valueOf(str)
{
	pos=0;
	while(pos<strlen (str))
	{
		if(strmid (str,pos, pos+1) == "=")
			break;
		pos = pos + 1;
	}

	if(strlen(str) == pos)
		return "0";
	else
		return strmid (str,pos+1,strlen (str));
}

//�ж��ļ��Ƿ����,0��������,1�������
macro ifExist(file)
{
	hbuf = OpenBuf(file);
	if(0 == hbuf )
	{
		return 0;
	}
	else
	{
		CloseBuf(hbuf);
		return 1;
	}
}

//�����ض��������ļ��е������
macro lineOfFile(file, str)
{
	if(0 == ifExist(file))
	{
		return 0;
	}
	else
	{
		hbuf = OpenBuf (file);
		ln_cnt = GetBufLineCount(hbuf);
		ln = 0;	
		while(ln<ln_cnt)
		{
			if(str == GetBufLine (hbuf, ln))
				return ln;
				
			ln = ln + 1;
		}
		CloseBuf (hbuf);		
		return 0;

	}
}

//��Ҫд��depend�ļ�������д��ϵͳ�Ļ��������
//����ȫ�ֱ���ʹ��,�����Ժ���ĳ���
macro initGlobal()
{
	PutEnv("cmd_count", "10");//��Ҫ�������������
	
	putEnv("cmd_str0","\t-\@echo Collecting condition variables......");
	
	putEnv("cmd_str1","\t-\@find ../../ -name *.cpp -exec grep -E '#endif|#ifdef|(\\s+|\\t+)defined|#elif' {} \\; > ../../tmp ;cat ../../tmp|sed -r '/\\//d'|sed -r 's/\\|\\||&&/\\n/g' >../../tmp_0");
	putEnv("cmd_str2","\t-\@cat ../../tmp_0|sed -r 's/#endif|#elif|#ifdef|#if\\s|defined//g'|sed -r 's/\\\\|!|\\(|\\)//g'|sed -r '/\\/|=|>|<|^\\s*$$$//d'|sed -r 's/\\s*|\\t*//g'|sort|uniq > ../../tmp0");
	
	putEnv("cmd_str3","\t-\@cat ../../tmp|grep -E -o '.*\\/\\/'|sed -r 's/\\/\\///g'|sed -r 's/\\|\\||&&/\\n/g'|sed -r 's/#endif|#elif|#ifdef|#if\\s|defined//g'|sed -r 's/!|\\(|\\)//g' >../../tmp_0");
	putEnv("cmd_str4","\t-\@cat ../../tmp_0|sed -r '/\\/|=|>|<|^\\s*$$$//d'|sed -r 's/\\s*|\\t*//g'|sort|uniq >> ../../tmp0;cat ../../tmp0|sed -r '/^\s*[0-9]*\s*$$$//d'|sed -r '/^\\s*[0-9]+\\s*$$$//d'|sort|uniq >../../defined.all");
	
	putEnv("cmd_str5","\t-\@echo $(CFLAGS)|grep -E -o '\\-D.*'|sed -r 's/(-D|-U)/\\n/g'|sed -r 's/\\s*=\\s*1//g'|sed -r 's/\\\"//g' >../../tmpp1;echo $(CFLAGS)|grep -E '\\-U[^ ]+' -o|sed -r 's/-U//g'>../../defined.undef;grep -v -f ../../defined.undef ../../tmpp1 >../../tmp1;");
	putEnv("cmd_str6","\t-\@cat ../../tmp1|sed -r '/=|^\\s*$$$//d'|sed -r 's/\\s*|\\t*//g'|sed -r 's/(.*)/^\\1$$$//'|sort|uniq >../../defined.noequal");
	putEnv("cmd_str7","\t-\@cat ../../tmp1|sed -r '/^\\s*$$$//d'|grep -E '='|sed -r 's/\\s*|\\t*//g'|sort|uniq >../../defined.equal");
	
	putEnv("cmd_str8","\t-\@grep -v -f ../../defined.noequal  ../../defined.all|sed -r 's/(.*)/\\1=0/' > ../../define;cat ../../defined.noequal|sed -r 's/\\^//'|sed -r 's/\\$$$//=1/' >> ../../define;cat ../../defined.equal >> ../../define");
	
	putEnv("cmd_str9","\t-\@rm ../../tmp* ../../defined.*");
	
}

//���ļ���ln��д������,�������Ѵ��ļ��ľ�������ز������������
macro writeCommand(file, ln)
{
	cmdLnCnt = GetEnv("cmd_count");// 10;

	if(0 == file && ln == 0)
	{
		return 
	}
	else if(0 == ifExist(file))
	{
		return cmdLnCnt;
	}
	else
	{
		hbuf = OpenBuf (file);

		i = cmdLnCnt - 1;
		while(i >= 0)
		{
			InsBufLine (hbuf, ln, GetEnv(cat("cmd_str",i)));
			i = i - 1;
		}
		
		SaveBuf (hbuf);	
		CloseBuf (hbuf);

		return cmdLnCnt;
	}
}

//���ļ���ɾ����,����ln�������Լ�֮���count��,����ɾ����������
macro deleteCommand(file,ln,count)
{
	if(0 == ifExist(file) || ln == 0)
	{
		return 0;
	}
	else
	{
		hbuf = OpenBuf(file);
		if(ln + count< GetBufLineCount(hbuf))
		{
			i = count - 1;
			while(i >= 0)
			{
				DelBufLine (hbuf, ln + i);
				i = i - 1;
			}	
			SaveBuf (hbuf);	
		}
		
		CloseBuf(hbuf);
		return count;
	}
}

//��depend�ļ�д��linux����(������ȡ���Լ�����),���ز������������
macro writeDependFile(depend_file)
{
	str = GetEnv("cmd_str0");//��־����
	ln = lineOfFile(depend_file,str);

	if(0 == ln)//�ļ���������
	{	
		str = "\t$(AR) crus $\@ $(OBJS)";//����libapp.a�Ĺ��̵ı�־��
		ln_lib = lineOfFile(depend_file,str);
		if(0 != ln_lib)//���������libapp.a�Ĺ���
		{
			return writeCommand(depend_file,ln_lib + 1);
		}
		else
		{
			str = "\t\@echo $(CFLAGS)";//Challenge�Ĺ��̵ı�־��
			ln_ch = lineOfFile(depend_file,str);

			return writeCommand(depend_file,ln_ch + 1);
		}		
	}
	else
	{	//������Ϊ0��0ʱ��writeCommand�������ļ��������ز��������������
		//��ô����Ϊ����������ﷵ���ļ����Ѿ�����������������
		//checkEnv�������ָ�depend�ļ�
		return 9;//writeCommand(0, 0);
	}
}

//����file�����ݣ���hProj��ӻ�������
macro addCondition(hProj, file)
{	
	if(0 == ifExist(file))
	{
		return 0;
	}
	else
	{
		hbuf = OpenBuf(file);
		
		ln_cnt = GetBufLineCount(hbuf);
		ln = 0;
		while(ln<ln_cnt)
		{
			str = GetBufLine(hbuf, ln);
			
			if(str != " ")	
				AddConditionVariable(hProj ,nameOf(str), valueOf(str));
				
			ln = ln + 1;
		}
		
		CloseBuf (hbuf);
		return ln;
	}
}

//��������ڣ�file�ļ�ָ���Ļ�������,����ɾ�����ı�����
macro clearCondition(hProj,file)
{
	if(0 == ifExist(file))
	{
		return 0;
	}
	else
	{
		hbuf = OpenBuf(file);
		ln_cnt = GetBufLineCount (hbuf);
		ln = 0;
		while(ln<ln_cnt)
		{
			str = GetBufLine(hbuf, ln);
			DeleteConditionVariable(hProj ,nameOf(str));
			ln = ln + 1;
		}
		
		CloseBuf (hbuf);
		return ln;
	}
}

//�����Լ��������·��
macro searchDir()
{
	hbuf = GetCurrentBuf ();
	dir_str = GetBufName (hbuf);
	pos = strlen(dir_str) - 1;
	while(pos > 0)
	{
		while(pos > 0)
		{
			if(strmid (dir_str, pos, pos + 1) == "\\")
				break;
			pos = pos - 1;
		}
		if(ifExist(cat(strmid(dir_str, 0, pos ),"\\Build\\depend")))
			break;
		pos = pos - 1;
	}
	if(pos > 0)
		return strmid(dir_str, 0, pos );
	else
		return -1;
}
//����make:nothing to been done for all;�����
macro modiFile()
{
	hbuf = GetCurrentBuf ();
	ln_cnt = GetBufLineCount (hbuf);

	if(GetBufLine (hbuf, ln_cnt - 1) == "  ")
		DelBufLine (hbuf, ln_cnt - 1);
	else
		AppendBufLine (hbuf, "  ");

	SaveBuf (hbuf);
}