/*
//��Source Insight���v0.1
//�˲���ںϸ����������
//�޸�ʹ�����ڴ󻪣�����з�����Ч��
//
//2014��5��17��
//
//
//���ܣ�
//1��tab��
//�Զ���ȫ����if else while for 
//trace include main
//2�����뺯����
//InsertFuncName
//InsertPoint
//4������ƶ�
//���ף���β
//ע��
//5��svn���
//log diff blace explorer
//
//doxyen
//6���������Ctrl+Enter
//
//7���ļ�����
//�ļ��л�Ctrl+d
*/

#define IF_KEY 1
#define FOR_KEY 2
#define WHILE_KEY 3


//tab���Զ���ȫ����
macro tabCompletion()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    curLinebuf = GetBufLine(hbuf, sel.lnFirst);
    curLineLen = strlen(curLinebuf)

    if( CheckTab() == true )
    {
        //tab��
        stop
    }

    left = GetLeftNoBlank(sel.ichFirst, curLinebuf)
    right = GetRightNoBlank(sel.ichFirst, curLinebuf)
    begin = GetBeginNoBlank(sel.ichFirst, curLinebuf)

    cmd = left.name
    lnblanks = GetBeginBlank(curLinebuf)
    ln = sel.lnFirst
    //������
    if ( jumpOut()==true )
    {
        //���������������ŵ�
        return
    }
    else if (cmd == "inc" )
    {
         sel.ichFirst = sel.ichFirst - 3
         SetWndSel(hwnd, sel)
         SetBufSelText(hbuf, "#include \"\"")
         sel.ichFirst = sel.ichFirst + 10
         sel.ichLim = sel.ichFirst
         SetWndSel(hwnd, sel)
         return
    }
    else if (cmd == "tra" )
    {
         sel.ichFirst = sel.ichFirst - 3
         SetWndSel(hwnd, sel)
         SetBufSelText(hbuf, "trace(\"\");")
         sel.ichFirst = sel.ichFirst + 7
         sel.ichLim = sel.ichFirst
         SetWndSel(hwnd, sel)
         return
    }
    else if( cmd == "pri" )
    {
        SetBufSelText(hbuf, "ntf(\"\");")
        sel.ichFirst = sel.ichFirst + 5
        sel.ichLim = sel.ichFirst
        SetWndSel(hwnd, sel)
        return
    }
    else if( cmd == "main" )
    {
        sel.ichFirst = sel.ichFirst - 4
        ln = sel.lnFirst
        SetWndSel(hwnd, sel)
        SetBufSelText(hbuf,"int main(int argc, char* argv[])")
        InsBufLine(hbuf, ln + 1, "{")
        InsBufLine(hbuf, ln + 2, "    ")
        InsBufLine(hbuf, ln + 3, "    ")
        InsBufLine(hbuf, ln + 4, "    return 0;")
        InsBufLine(hbuf, ln + 5, "}")
        sel.ichFirst = sel.ichFirst + 4
        sel.ichLim = sel.ichLim
        sel.lnFirst = ln + 2
        sel.lnLast = sel.lnFirst
        SetWndSel(hwnd,sel)
        return
    }
    else if( cmd == "if" || cmd == "while" || cmd == "for" || cmd == "elif" )
    {
        if( cmd == "elif" )
        {
            sel.ichFirst = sel.ichFirst - 4
            SetWndSel(hwnd, sel)
            SetBufSelText(hbuf, "else if(  )")
            sel.ichFirst = sel.ichFirst + 7
        }
        else
        {
            SetBufSelText(hbuf, "(  )")
        }

		InsBufLine(hbuf, ln + 1, lnblanks # "{");
		InsBufLine(hbuf, ln + 2, lnblanks # "    /* code */");
		InsBufLine(hbuf, ln + 3, lnblanks # "}");

        sel.ichFirst = sel.ichFirst + 2
        sel.ichLim = sel.ichFirst
        sel.lnLast = sel.lnFirst
        SetWndSel(hwnd, sel)
        return
    }
    else if( cmd == "else" || cmd == ")")
    {
        linecur = GetBufLine(hbuf, ln);
        line1 = GetBufLine(hbuf, ln+1);
        line2 = GetBufLine(hbuf, ln+2);
        line3 = GetBufLine(hbuf, ln+3);

        szLine1 = lnblanks # "{"
        szLine2 = lnblanks # "    /* code */"
        szLine3 = lnblanks # "}"

        sel.ichFirst = strlen(lnblanks) + 4
        if( line1 == szLine1 && line2 == szLine2 && line3 == szLine3 )
        {
            sel.ichLim = sel.ichFirst + 10
        }
        else if( line1 == szLine1 )
        {
            sel.ichLim = sel.ichFirst
        }
        else if( cmd == "else" )
        {
            InsBufLine(hbuf, ln + 1, szLine1);
            InsBufLine(hbuf, ln + 2, szLine2);
            InsBufLine(hbuf, ln + 3, szLine3);
            sel.ichLim = sel.ichFirst + 10
        }


        sel.lnFirst = ln + 2
        sel.lnLast = sel.lnFirst
        SetWndSel(hwnd, sel)
        return
    }
	else if( cmd == "{" )
	{
		InsBufLine(hbuf, ln+1, lnblanks # "    ");
		InsBufLine(hbuf, ln + 2, lnblanks # "}");
		sel.lnFirst = ln + 1
		sel.lnLast = sel.lnFirst
        sel.ichFirst = sel.ichFirst + 4
        sel.ichLim = sel.ichFirst
        SetWndSel(hwnd, sel)
        return
	}
    else
    {
        //
        Tab
        return
    }
}
macro CheckTab()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    curLinebuf = GetBufLine(hbuf, sel.lnFirst);
    len = strlen(curLinebuf)

    if( sel.ichFirst != sel.ichLim )
    {
        line = sel.lnFirst
        lnFirst = sel.lnFirst
        lnLast = sel.lnLast
        ichFirst = sel.ichFirst
        ichLim = sel.ichLim
        while( line <= lnLast )
        {
            if(line == lnFirst )
            {
                sel.ichLim = ichFirst
            }
            else
            {
                sel.ichFirst = 0
                sel.ichLim = 0
            }
            sel.lnFirst = line
            sel.lnLast = line
            SetWndSel(hwnd, sel)
            SetBufSelText(hbuf, "    ")
            line = line + 1
        }
        sel.lnFirst = lnFirst
        sel.lnLast = lnLast
        sel.ichFirst = ichFirst + 4
        sel.ichLim = ichLim + 4
        SetWndSel(hwnd, sel)

        return true
    }
    else if( sel.ichFirst == 0 )
    {
        Tab
        return true
    }
    else if( sel.ichFirst == len && (curLinebuf[sel.ichFirst-1] == " "
            || curLinebuf[sel.ichFirst-1] == "\t") ) 
    {
        Tab
        return true
    }

    return false
}
//
macro GetLeftNoBlank(ich, linebuf)
{
    chTab = CharFromAscii(9)
    while (ich > 0)
    {
        ich = ich - 1;
        if (linebuf[ich] == " " || linebuf[ich] == chTab)
        {
            continue
        }
        else
        {
            break
        }
    }

    asciiA = AsciiFromChar("A")
    asciiZ = AsciiFromChar("Z")
    ch = toupper(linebuf[ich])
    asciiCh = AsciiFromChar(ch)
    symbol = ""
    if( asciiCh < asciiA || asciiCh > asciiZ )
    {
        //�Ƿ��ţ�ֱ���˳�
        symbol.name = linebuf[ich]
        symbol.ichFirst = ich
        return symbol
    }

    //��������
    ichLim = ich + 1
    while (ich >= 0)
    {
        ch = toupper(linebuf[ich])
        asciiCh = AsciiFromChar(ch)

        //������ĸ���˳�
        if (asciiCh < asciiA || asciiCh > asciiZ)
            break;

        ich = ich - 1;
    }
    ichFirst = ich + 1
    symbol = ""
    symbol.name = strmid(linebuf,ichFirst,ichLim)
    symbol.ichFirst = ichFirst
    return symbol
}

macro GetRightNoBlank(ich, linebuf)
{
    chTab = CharFromAscii(9)
    len = strlen(linebuf)

    while (ich < len-1)
    {
        ich = ich + 1;
        if (linebuf[ich] == " " || linebuf[ich] == chTab)
        {
            continue
        }
        else
        {
            break
        }
    }

    symbol = ""
    if( ich == len-1 )
    {
        symbol.name = ""
        symbol.ichFirst = -1
    }
    else
    {
        //�ұ�ֻ����һ���ַ�
        symbol.name = linebuf[ich]
        symbol.ichFirst = ich
    }

    return symbol
}
macro GetBeginNoBlank(ich, linebuf)
{
    chTab = CharFromAscii(9)

    ich1 = ich
    len = strlen(linebuf)
    ich = 0
    while (ich < ich1 && ich < len)
    {
        if (linebuf[ich] == " " || linebuf[ich] == chTab)
        {
            ich = ich + 1;
            continue
        }
        else
        {
            break
        }
    }
    if( ich == ich1 )
    {
        ich = ich -1
    }
    if( ich < 0 )
    {
        ich = 0
    }

    asciiA = AsciiFromChar("A")
    asciiZ = AsciiFromChar("Z")
    ch = toupper(linebuf[ich])
    asciiCh = AsciiFromChar(ch)

    if( asciiCh < asciiA || asciiCh > asciiZ )
    {
        //�Ƿ��ţ�ֱ���˳�
        symbol = ""
        symbol.name = linebuf[ich]
        symbol.ichFirst = ich
        return symbol
    }

    //��������
    ichFirst = ich
    while ( ich <= ich1 && ich < len)
    {
        ch = toupper(linebuf[ich])
        asciiCh = AsciiFromChar(ch)

        //������ĸ���˳�
        if (asciiCh < asciiA || asciiCh > asciiZ)
            break;

        ich = ich + 1;
    }
    ichLim = ich
    symbol = ""
    symbol.name = strmid(linebuf,ichFirst,ichLim)
    symbol.ichFirst = ichFirst
    return symbol
}
macro GetBeginBlank(linebuf)
{
    ich = 0
    while (linebuf[ich] == " " || linebuf[ich] == "\t")
    {
        ich = ich + 1
    }
    lineblanks = strmid(linebuf,0,ich)
    return lineblanks
}

macro jumpOut()
{
    kuo = 1;
    dou = 2;
    mao = 4;

    hwnd = GetCurrentWnd()
    hbuf = GetWndBuf(hwnd)
    sel = GetWndSel(hwnd)
    
    szLine = GetBufLine(hbuf, sel.lnFirst);
    lineLen = strlen(szLine)
    index = sel.ichFirst
    state = 0
    blank = 0
    while( index < lineLen )
    {
        c = szLine[index]
        if( c == "\"" )
        {
            state = state + mao;
        }
        else if( c == ";" )
        {
            state = state + dou;
        }
        else if( c == ")" )
        {
           state = state + kuo;
        }
        else if( c == " " || c == "\t" )
        {
            blank = blank + 1
        }
        else
        {
            return false
        }
        index = index + 1
    }

    if( state == kuo )
    {
        sel.ichFirst = sel.ichFirst + 1
    }
    else if( state == mao + kuo + dou )
    {
        sel.ichFirst = sel.ichFirst + 1
    }
    else if( state == kuo + dou )
    {
        sel.ichFirst = sel.ichFirst + 2
    }
    else if( state == mao )
    {
        sel.ichFirst = sel.ichFirst + 1
    }
    else
    {
        return false
    }

    sel.ichFirst = sel.ichFirst + blank
    sel.ichLim = sel.ichFirst
    SetWndSel(hwnd,sel) 

    return true
}

//��ת������ Ctrl + a
macro jumpLineStart()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    szLine = GetBufLine(hbuf, sel.lnFirst);
    index = 0
    while( index < strlen(szLine) && (szLine[index] == " " || szLine[index] == "\t") )
    {
        index = index + 1;
    }
    sel.ichFirst = index
    sel.ichLim = index
    SetWndSel(hwnd, sel)
}
//��ת����β Ctrl + e
macro jumpLineEnd()
{
   hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    szLine = GetBufLine(hbuf, sel.lnFirst);
    index = strlen(szLine) - 1
    while( index >= 0 && (szLine[index] == " " || szLine[index] == "\t") )
    {
        index = index - 1;
    }
    index = index + 1
    sel.ichFirst = index
    sel.ichLim = index
    SetWndSel(hwnd, sel)
}
macro IsWord(ch)
{
    asciiA = AsciiFromChar("A")
    asciiZ = AsciiFromChar("Z")
    ch = toupper(ch)
    asciiCh = AsciiFromChar(ch)

    if( asciiCh >= asciiA && asciiCh <= asciiZ )
    {
        return true
    }
    else
    {
        return false
    }
}
macro IsSymbol(ch)
{
    if( IsWord(ch) == true || ch == "_" || IsNumber(ch) )
    {
        return true
    }
    else
    {
        return false
    }
}
macro GoLeft()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop

    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    linebuf = GetBufLine(hbuf,sel.lnFirst)
    ichFirst = sel.ichFirst
    lnFirst = sel.lnFirst

    ichFirst = ichFirst - 1
    if( ichFirst < 0 )
    {
        lnFirst = lnFirst - 1
        if(lnFirst < 0)
        {
            ichFirst = 0
            lnFirst = 0
        }
        else
        {
            linebuf = GetBufLine(hbuf,lnFirst)
            ichFirst = strlen(linebuf)
        }

        sel.ichFirst = ichFirst
        sel.ichLim = ichFirst
        sel.lnFirst = lnFirst
        sel.lnLast = lnFirst
        SetWndSel(hwnd, sel)
        return
    }
    hasword = false
    while( ichFirst >= 0 )
    {
        ch = linebuf[ichFirst]

        if( hasword == false && IsSymbol(ch) == false )
        {
            ichFirst = ichFirst - 1
        }
        else if( IsSymbol(ch) )
        {
            hasword = true
            ichFirst = ichFirst - 1
        }
        else
        {
            break
        }
    }
    if( hasword == true )
    {
        ichFirst = ichFirst + 1
    }
    sel.ichFirst = ichFirst
    sel.ichLim = sel.ichFirst
    SetWndSel(hwnd, sel)
}
macro GoRight()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop

    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    linebuf = GetBufLine(hbuf,sel.lnFirst)
    len = strlen(linebuf)
    maxline = GetBufLineCount(hbuf)
    ichFirst = sel.ichFirst
    lnFirst = sel.lnFirst

    ichFirst = ichFirst + 1
    if( ichFirst > len )
    {
        lnFirst = lnFirst + 1
        if(lnFirst > maxline)
        {
            ichFirst = len
            lnFirst = maxline
        }
        else
        {
            ichFirst = 0
        }

        sel.ichFirst = ichFirst
        sel.ichLim = ichFirst
        sel.lnFirst = lnFirst
        sel.lnLast = lnFirst
        SetWndSel(hwnd, sel)
        return
    }
    hasword = false
    while( ichFirst < len )
    {
        ch = linebuf[ichFirst]

        if( hasword == false && IsSymbol(ch) == false )
        {
            ichFirst = ichFirst + 1
        }
        else if( IsSymbol(ch) )
        {
            hasword = true
            ichFirst = ichFirst + 1
        }
        else
        {
            break
        }
    }
    sel.ichFirst = ichFirst
    sel.ichLim = sel.ichFirst
    SetWndSel(hwnd, sel)
}
macro GoUp5()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop

    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    sel.lnFirst = sel.lnFirst - 5
    if( sel.lnFirst < 0 )
    {
        sel.lnFirst = 0
    }
    sel.lnLast = sel.lnFirst
    topline = GetWndVertScroll(hwnd)
    SetWndSel(hwnd,sel)
    ScrollWndToLine(hwnd,topline-5)
}
macro GoDown5()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop

    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    lnFirst = sel.lnFirst

    lnFirst = lnFirst + 5
    if( lnFirst >= GetBufLineCount(hbuf) )
    {
        lnFirst = GetBufLineCount(hbuf) - 1
    }
    topline = GetWndVertScroll(hwnd)
    if topline + GetWndLineCount(hwnd) < GetBufLineCount(hbuf)
        ScrollWndToLine(hwnd,topline + 5)

    sel.lnFirst = lnFirst
    sel.lnLast = sel.lnFirst
    SetWndSel(hwnd,sel)
}

macro InsertPoint()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop

    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    SetBufSelText(hbuf, "tracepoint();");

    linebuf = GetBufLine(hbuf,sel.lnFirst)
    lnblanks = GetBeginBlank(linebuf)
    InsBufLine(hbuf, sel.lnFirst + 1, lnblanks);
    sel.lnFirst = sel.lnFirst + 1
    sel.lnLast = sel.lnFirst
    SetWndSel(hwnd, sel)
}
macro InsertFuncName()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop

    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    symbolname = GetCurSymbol()
	index = 0
	len = strlen(symbolname)
	while( index < len )
	{
		if( symbolname[index] == "." )
			break
		index = index + 1
	}
    if( index == len)
    {
        str = "trace(\"" # symbolname # ">>> \");"
    }
    else
    {
        classname = strmid(symbolname,0,index)
        funcname = strmid(symbolname,index+1,len)
        str = "trace(\"" # classname # "::" # funcname # ">>> \");"
    }
    SetBufSelText(hbuf, str)
    sel.ichFirst = sel.ichFirst + strlen(str) - 3
    sel.ichLim = sel.ichFirst
    SetWndSel(hwnd, sel)
}

macro MultiLineComment()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    LnFirst = GetWndSelLnFirst(hwnd)      //ȡ�����к�
    LnLast = GetWndSelLnLast(hwnd)      //ȡĩ���к�
    ichFirst = sel.ichFirst
    ichLim = sel.ichLim
    hbuf = GetCurrentBuf()

    //�ȼ���Ƿ���ע�͹�
    line = lnFirst
    while( line <= lnLast )
    {
        buf = GetBufLine(hbuf,line)
        blanks = GetBeginBlank(buf)
        ichFirst = strlen(blanks)
        len = strlen(buf)
        if( ichFirst+3 > len )
            break

        if( strmid(buf,ichFirst,ichFirst+3) == "// " )
        {
            line = line + 1
            continue
        }
        else
        {
            break
        }
    }
    //ȥ��ע��
    if( line == lnLast + 1 )
    {
        line = lnFirst
        while(line <= lnLast)
        {
            buf = GetBufLine(hbuf,line)
            blanks = GetBeginBlank(buf)
            ichFirst = strlen(blanks)
            len = strlen(buf)
            newbuf = strmid(buf, ichFirst+3,len)
            DelBufLine(hbuf,line)
            InsBufLine(hbuf,line,blanks # newbuf)
            line = line + 1
        }
        sel.ichFirst = ichFirst
        sel.ichLim = ichLim - 3
        sel.lnFirst = lnFirst
        sel.lnLast = lnLast
        SetWndSel(hwnd, sel)
        SetWndSel(hwnd, sel)
        return
    }

    //����ע��
    minFirst = 9999
    line = Lnfirst
    while( line <= lnLast )
    {
        buf = GetBufLine(hbuf, line)
        len = strlen(buf)
        index = 0
        //��������ߵķǿ��ַ�
        while( index <= len )
        {
            if( buf[index] != " " && buf[index] != "    ")
            {
                break
            }
            index = index + 1
        }

        if( index < minFirst )
        {
            minFirst = index
        }
        line = line + 1
    }
    line = lnFirst
    while( line <= lnLast )
    {
        sel.ichFirst = minFirst
        sel.ichLim = minFirst
        sel.lnFirst = line
        sel.lnLast = line
        SetWndSel(hwnd, sel)
        SetBufSelText(hbuf, "// ")
        line = line + 1
    }
    sel.ichFirst = ichFirst + 3
    sel.ichLim = ichLim + 3
    sel.lnFirst = lnFirst
    sel.lnLast = lnLast
    SetWndSel(hwnd, sel)
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
macro RunExe()
{

}

///\brief ��Ӻ���ͷע��
///\param in  
///\param out 
///\return 
macro AddFuncHeader()
{
    SysTime = GetSysTime( 0 )
    date    = StrMid( SysTime, 6, 19 )
 
    // Get a handle to the current file buffer and the name
    // and location of the current symbol where the cursor is.
    hbuf = GetCurrentBuf()
 
    if( hbuf == hNil )
    {
        return 1
    }
 
    ln = GetBufLnCur( hbuf )
    InsBufLine( hbuf, ln + 1, "///\\brief " )
    InsBufLine( hbuf, ln + 2, "///\\param in " )
    InsBufLine( hbuf, ln + 3, "///\\param out " )
    InsBufLine( hbuf, ln + 4, "///\\return " )
 
    // put the insertion point inside the header comment
    SetBufIns( hbuf, ln+1, 11 )
}
macro strrstr(str,str1)
{
    len = strlen(str)
    len1 = strlen(str1)
    i = len - len1

    while( i > 0 )
    {
        strrmp = strmid(str,i,i+len1)
        if( strrmp == str1 )
        {
            return i+1;
        }
        i = i - 1;
    }

    return -1;
}
macro JumpCpp()
{
    hwnd = GetCurrentWnd()
    hbuf = GetCurrentBuf()
    bufname = GetBufName(hbuf)
    pos = strrstr(bufname,"\\")

    filename = strmid(bufname,pos,strlen(bufname))
    len = strlen(filename)

    if( filename[len-2] == "." && filename[len-1] == "h" )
    {
        file = strmid(filename,0,len-1) # "cpp"
    }
    else
    {
        file = strmid(filename,0,len-3) # "h"
    }

    ifile = 0
    hproj = GetCurrentProj()
    ifileMax = GetProjFileCount (hproj)
    while (ifile < ifileMax )
    {
        file1 = GetProjFileName (hproj, ifile)
        len1 = strlen(file1)
        len = strlen(file)
        
        if( len1 < len )
        {    
            ifile = ifile + 1
            continue
        }
        if( strmid(file1,len1-len,len1) == file )
        {
            break
        }
        ifile = ifile + 1
    }

    fbuf = OpenBuf(file1)
    SetCurrentBuf(fbuf)
}