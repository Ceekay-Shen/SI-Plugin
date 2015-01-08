/*
//��Source Insight���
v0.9.0

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
//
//5��svn���
//log diff blace explorer
//
//6��ע��
//����ע��
//Doxygen�ĵ�ע�ͣ�������
//6���������Ctrl+Enter
//
//7���ļ�����
//�ļ��л�Ctrl+d
*/

#define IF_KEY 1
#define FOR_KEY 2
#define WHILE_KEY 3

/*********************Start Base Functions*********************/

/*
* �����������ַ�����������word���ǿ��ַ�λ��
*
*/

//���� str1��n�γ��ֵ�λ�ã�����
macro strstr(str,str1,n)
{
    len = strlen(str)
    len1 = strlen(str1)
    i = 0

    times = 0
    while( i <= len - len1 )
    {
        strrmp = strmid(str,i,i+len1)
        if( strrmp == str1 )
        {
            times = times + 1
            if( times >= n )
            {
                return i+1;
            }
        }
        i = i + 1;
    }

    return -1;
}
//���� str1��n�γ��ֵ�λ�ã�����
macro strrstr(str,str1,n)
{
    len = strlen(str)
    len1 = strlen(str1)
    i = len - len1

    times = 0
    while( i >= 0 )
    {
        strrmp = strmid(str,i,i+len1)
        if( strrmp == str1 )
        {
            times = times + 1
            if( times >= n )
            {
                return i+1;
            }
        }
        i = i - 1;
    }

    return -1;
}
macro strreplace(str, old,new)
{
    len = strlen(str)
    i = 0
    while( i < len )
    {
        if( str[i] == old )
        {
            str[i] = new
        }
        i = i + 1
    }

    return str
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
macro GetLeftWord(ich, sz)
{
    wordinfo = "" // create a "wordinfo" structure
    
    chTab = CharFromAscii(9)
    
    // scan backwords over white space, if any
    ich = ich - 1;
    if (ich >= 0)
        while (sz[ich] == " " || sz[ich] == chTab)
        {
            ich = ich - 1;
            if (ich < 0)
                break;
        }
    
    // scan backwords to start of word    
    ichLim = ich + 1;
    asciiA = AsciiFromChar("A")
    asciiZ = AsciiFromChar("Z")
    while (ich >= 0)
    {
        ch = toupper(sz[ich])
        asciiCh = AsciiFromChar(ch)

        //ֻ��ȡ�ַ���# { / *��Ϊ����
        if ((asciiCh < asciiA || asciiCh > asciiZ) 
           && !IsNumber(ch)
           && ( ch != "#" && ch != "{" && ch != "/" && ch != "*"))
            break;

        ich = ich - 1;
    }
    
    ich = ich + 1
    wordinfo.key = strmid(sz, ich, ichLim)
    wordinfo.ich = ich
    wordinfo.ichLim = ichLim;
    
    return wordinfo
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
macro GetEndBlankPos(linebuf)
{
    ich = strlen(linebuf) - 1
    while (linebuf[ich] == " " || linebuf[ich] == "\t")
    {
        ich = ich - 1
    }
    ich = ich + 1
    return ich
}
/*********************End Base Functions*********************/

/*
* ������
*
*/

//tab���Զ���ȫ����
macro tabCompletion()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    linebuf = GetBufLine(hbuf, sel.lnFirst);
    linebufLen = strlen(linebuf)

    if( sel.ichFirst != sel.ichLim || sel.lnFirst != sel.lnLast )
    {
        //ѡ��ģʽ,����4���ո�
        oldSel = sel
        line = oldSel.lnFirst
        while( line <= oldSel.lnLast )
        {
            sel.ichFirst = 0
            sel.ichLim = 0
            sel.lnFirst = line
            sel.lnLast = line
            SetWndSel(hwnd, sel)
            SetBufSelText(hbuf, "    ")
            line = line + 1
        }
        //��ԭѡ��״̬
        oldSel.ichFirst = oldSel.ichFirst + 4
        oldSel.ichLim = oldSel.ichLim + 4
        SetWndSel(hwnd, oldSel)

        stop
    }

    //��ȫģʽ
    word = GetLeftWord(sel.ichFirst, linebuf)

    key = word.key
    lnblanks = GetBeginBlank(linebuf)
    ln = sel.lnFirst

    //������
    if ( jumpOut()==true )
    {
        //���������������ŵ�
        // ����"/* code */"��
        return
    }
    else if( CompleteKeyword(key) == true )
    {
        return
    }
    else if( JumpNextArgs(key) == true )
    {
        return
    }
    else if( key == "{" )
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
    // else if( CompleteWord() )
    // {
    //     return
    // }
    else
    {
        //
        Tab
        return
    }
}

macro CompleteKeyword(key)
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)

    linebuf = GetBufLine(hbuf, sel.lnFirst);
    linebufLen = strlen(linebuf)
    lnblanks = GetBeginBlank(linebuf)
    ln = sel.lnFirst

    if (key == "inc" )
    {
         sel.ichFirst = sel.ichFirst - 3
         SetWndSel(hwnd, sel)
         SetBufSelText(hbuf, "#include \"\"")
         sel.ichFirst = sel.ichFirst + 10
         sel.ichLim = sel.ichFirst
         SetWndSel(hwnd, sel)
         return true
    }
    else if (key == "tra" )
    {
         sel.ichFirst = sel.ichFirst - 3
         SetWndSel(hwnd, sel)
         SetBufSelText(hbuf, "trace(\"\");")
         sel.ichFirst = sel.ichFirst + 7
         sel.ichLim = sel.ichFirst
         SetWndSel(hwnd, sel)
         return true
    }
    else if( key == "pri" )
    {
        SetBufSelText(hbuf, "ntf(\"\");")
        sel.ichFirst = sel.ichFirst + 5
        sel.ichLim = sel.ichFirst
        SetWndSel(hwnd, sel)
        return true
    }
    else if( key == "main" )
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
        return true
    }
    else if( key == "if" || key == "while" || key == "for" || key == "elif" )
    {
        if( key == "elif" )
        {
            sel.ichFirst = sel.ichFirst - 4
            SetWndSel(hwnd, sel)
            SetBufSelText(hbuf, "else if(  )")
            sel.ichFirst = sel.ichFirst + 7
        }
        else if( key == "for" )
        {
            SetBufSelText(hbuf, "()")
            sel.ichFirst = sel.ichFirst - 1
        }
        else if( key == "for" )
        {
            SetBufSelText(hbuf, "()")
            sel.ichFirst = sel.ichFirst - 1
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
        return true
    }
    else if( key == "else" || key == ")")
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
        return true
    }

    return false
}

macro JumpNextArgs(key)
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)

    linebuf = GetBufLine(hbuf, sel.lnFirst);
    linebufLen = strlen(linebuf)

    hnewbuf = GetOrCreateBuf("*Functions-Line*")
    ClearBuf(hnewbuf)
    AppendBufLine(hnewbuf, linebuf)

    //�̵㵱ǰ���Ƿ��Ǻ�������
    isfunc = SearchInBuf(hnewbuf, "[a-zA-Z_0-9]+\\s+[a-zA-Z_0-9]+(.*)", 0, 0,0,1,0)
    // Msg(isfunc)
    if( isfunc != "" )
    {
        return false
    }
    // isfunc = SearchInBuf(hnewbuf, "[(\\.)|(->)]*[a-zA-Z_0-9]+([a-zA-Z_0-9\\s,\\*/=->\\.]*)", 0, 0,0,1,0)
    isfunc = SearchInBuf(hnewbuf, "[a-zA-Z_0-9]+(.*)", 0, 0,0,1,0)
    // Msg(isfunc)

    //���Ǻ�������
    if( isfunc == "" )
        return false
    if( linebuf[isfunc.ichFirst-1] == ":" )
        return false


    //�Ҳ���
    // result = SearchInBuf(hnewbuf,"[a-zA-Z_0-9]+\\s+[\\*|&]*\\s*[a-zA-Z_0-9]+\\s*=*\\s*[a-zA-Z_0-9]*", 0, sel.ichFirst+1,0,1,0)
    
    result = SearchInBuf(hnewbuf,"(.*,", 0, sel.ichFirst,0,1,0)
    if( result == "" )
    {
        result = SearchInBuf(hnewbuf,",.*,", 0, sel.ichFirst,0,1,0)
    }
    if( result == "" )
    {
        result = SearchInBuf(hnewbuf,",.*)", 0, sel.ichFirst,0,1,0)            
    }
    if( result == "" )
    {
        result = SearchInBuf(hnewbuf,"(.*)", 0, sel.ichFirst,0,1,0)            
    }

    // Msg(result)
    if( result != "" )
    {
        //ѡ�в���
        result.ichFirst = result.ichFirst + 1
        result.ichLim = result.ichLim - 1
        result.lnFirst = sel.lnFirst
        result.lnLast = sel.lnLast
        SetWndSel(hWnd,result)
        return true
    }

    return false
}

macro BackspaceEx()
{
    hwnd = GetCurrentWnd()
    hbuf = GetWndBuf(hwnd)
    sel = GetWndSel(hwnd)
    linebuf = GetBufLine(hbuf, sel.lnFirst)

    if( sel.fExtended == 1 || sel.ichFirst == 0 || sel.ichFirst == strlen(linebuf) )
    {
        //ɾ������ַ�
        Backspace
        Stop
    }


    a = linebuf[sel.ichFirst-1]
    b = linebuf[sel.ichFirst]
    c = linebuf[sel.ichFirst+1]

    //ƥ����Ŷ�
    symbols = "\"\"''()<>{}[]"
    len = strlen(symbols)
    index = 0
    while( index < len )
    {
        if( a == symbols[index] )
        {
            Backspace
            if( b == symbols[index+1])
                Delete_Character
            else if( b == " " && c == symbols[index+1] )
            {
                Delete_Character
                Delete_Character
            }

            Stop
        }
        index = index + 2
    }

    //ɾ��һ���ַ�
    Backspace
}
macro jumpOut()
{
    hwnd = GetCurrentWnd()
    hbuf = GetWndBuf(hwnd)
    sel = GetWndSel(hwnd)

    linebuf = GetBufLine(hbuf, sel.lnFirst)
    linebufLen = strlen(linebuf)
    ichFirst = sel.ichFirst;


    if( sel.ichFirst == linebufLen )
    {
        //����β����ת��code��
        line = sel.lnFirst + 1
        while( line <= sel.lnFirst + 2 )
        {
            linebuf = GetBufLine(hbuf, line)
            pos = strstr(linebuf,"* code *",1)
            if( pos != -1 )
            {
                sel.ichFirst = pos - 2
                sel.ichLim = pos + 8
                sel.lnFirst = line
                sel.lnLast = line
                SetWndSel(hwnd,sel)

                return true
            }
            line = line + 1
        }
    }
    else
    {
        //����ð�������ŵ�����
        right = strmid(linebuf,ichFirst,linebufLen)
        gothere = 0
        if( right == "\");" || right == ")" )
        {
            gothere = 1;
        }
        else if( right == ");" || right == " )" )
        {
            gothere = 2;
        }

        if( gothere != 0 )
        {
            sel.ichFirst = sel.ichFirst + gothere
            sel.ichLim = sel.ichFirst
            SetWndSel(hwnd,sel) 
            return true
        }
    }
    return false
}

//��ת������ Ctrl + a
macro jumpLineStart()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    
    linebuf = GetBufLine(hbuf, sel.lnFirst);
    right = TrimLeft(linebuf)
    pos = strlen(linebuf) - strlen(right)
    //�����ǰλ����������ˣ�������0
    if( pos == sel.ichFirst )
        pos = 0

    sel.ichFirst = pos
    sel.ichLim = pos
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

    linebuf = GetBufLine(hbuf, sel.lnFirst);
    left = TrimRight(linebuf)
    pos = strlen(left)
    //�����ǰλ����������ˣ�������0
    if( pos == sel.ichFirst )
        pos = strlen(linebuf)

    sel.ichFirst = pos
    sel.ichLim = pos
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

////////////////////////////////////////////////////////
//////////////////////// VimMode ///////////////////////
macro FindInLine()
{
    hWnd = GetCurrentWnd()
    sel = GetWndSel(hWnd)

    hbuf = GetCurrentBuf();
    ln = GetBufLnCur( hbuf )
    linebuf = GetBufLine(hbuf,ln)

    key = GetKey()
    ch = CharFromKey(key)
    ch = toupper(ch)

    index = sel.ichFirst
    len = strlen(linebuf)
    while( index < len )
    {
        if( toupper(linebuf[index]) == ch )
            break

        index = index + 1
    }

    if( index < len )
    {
        sel.ichFirst = index
        sel.ichLim = sel.ichFirst
        SetWndSel(hWnd, sel)
    }
}

macro VimMode()
{
    hbuf = GetCurrentBuf();
    while(1)
    {
        // Wait for the next key press and return the key code.
        key = GetKey()
        
        // Map the key code into a simple character.
        //
        // If you only need a simple character, you can 
        // call GetChar() instead of GetKey + CharFromKey
        ch = CharFromKey(key)
        
        //����ƶ�
        if( ch == "h" )
            Cursor_Left
        else if( ch == "j" )
            Cursor_Down
        else if( ch == "k" )
            Cursor_Up
        else if( ch == "l" )
            Cursor_Right
        else if( ch == "f" )
            FindInLine
        else
            stop
    }
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
        str = "trace(\"" # symbolname # ">>> \\n\");"
    }
    else
    {
        classname = strmid(symbolname,0,index)
        funcname = strmid(symbolname,index+1,len)
        str = "trace(\"" # classname # "::" # funcname # ">>> \\n\");"
    }
    SetBufSelText(hbuf, str)
    sel.ichFirst = sel.ichFirst + strlen(str) - 5
    sel.ichLim = sel.ichFirst
    SetWndSel(hwnd, sel)
}

//����ע����ȥע�͹���
macro MultiLineComment()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    lnFirst = GetWndSelLnFirst(hwnd)      //ȡ�����к�
    lnLast = GetWndSelLnLast(hwnd)      //ȡĩ���к�
    ichFirst = sel.ichFirst
    ichLim = sel.ichLim
    hbuf = GetCurrentBuf()

    isComment = true      //Ĭ��ע�͹�

    //�ȼ���Ƿ���ע�͹�
    line = lnFirst
    while( line <= lnLast )
    {
        linebuf = GetBufLine(hbuf,line)
        lineLen = strlen(linebuf)

        szRight = TrimLeft(linebuf)
        rightLen = strlen(szRight)
        if(  rightLen < 2 )
        {
            isComment = false
            break
        }

        if( strmid(szRight,0,2) == "//" )
        {
            line = line + 1
            continue
        }
        else
        {
            isComment = false
            break
        }
    }

    if( isComment )
    {
        //ȥ��ע��
        line = lnFirst
        lnFirstPos = 2 //��һ��������2��
        while(line <= lnLast)
        {
            linebuf = GetBufLine(hbuf,line)
            lineLen = strlen(linebuf)
            szRight = TrimLeft(linebuf)
            rightLen = strlen(szRight)

            leftLen = lineLen - rightLen
            pos = leftLen + 2
            newbuf = ""
            if( rightLen > 2 && szRight[2] == " ")
            {
                pos = pos + 1
                if( line == lnFirst )
                    lnFirstPos = lnFirstPos + 1
            }
            if( leftLen > 0 )
                newbuf = newbuf # strmid(linebuf, 0,leftLen)
            newbuf = newbuf # strmid(linebuf, pos,lineLen)
            DelBufLine(hbuf,line)
            InsBufLine(hbuf,line,newbuf)

            line = line + 1
        }
        sel.ichFirst = ichFirst - lnFirstPos
        sel.ichLim = ichLim - lnFirstPos
        SetWndSel(hwnd, sel)
    }
    else
    {
        //����ע��

        //��������ߵķǿ��ַ�
        minFirst = 9999
        line = Lnfirst
        while( line <= lnLast )
        {
            linebuf = GetBufLine(hbuf,line)
            lineLen = strlen(linebuf)
            szRight = TrimLeft(linebuf)
            rightLen = strlen(szRight)
            if( rightLen == 0 )   //���в�����
            {
                minFirst = 0
                break
            }
            if( lineLen - rightLen < minFirst )
            {
                minFirst = lineLen - rightLen
            }
            line = line + 1
        }
        //����ע��"// "
        line = lnFirst
        while( line <= lnLast )
        {
            linebuf = GetBufLine(hbuf,line)

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
macro JumpToFile(filename)
{
    ifile = 0
    hproj = GetCurrentProj()
    ifileMax = GetProjFileCount (hproj)
    while (ifile < ifileMax )
    {
        file1 = GetProjFileName (hproj, ifile)
        // Msg(file1)

        len1 = strlen(file1)
        len = strlen(filename)
        
        if( len1 < len )
        {    
            ifile = ifile + 1
            continue
        }
        if( strmid(file1,len1-len,len1) == filename )
        {
            break
        }
        ifile = ifile + 1
    }

    if( ifile < ifileMax )
    {
        fbuf = OpenBuf(file1)
        SetCurrentBuf(fbuf)
    }
}
macro JumpCpp()
{
    hwnd = GetCurrentWnd()
    hbuf = GetCurrentBuf()
    bufname = GetBufName(hbuf)
    pos = strrstr(bufname,"\\",2)
    //û���ҵ�����ȡȫ���ַ���
    if( pos == -1 )
    {
        pos = 0
    }

    filename = strmid(bufname,pos,strlen(bufname))
    len = strlen(filename)

    if( filename[len-2] == "." && filename[len-1] == "h" )
    {
        dstfile = strmid(filename,0,len-1) # "cpp"
    }
    else
    {
        dstfile = strmid(filename,0,len-3) # "h"
    }

    JumpToFile(dstfile)
}

///\brief ��Ӻ���Doxygenע��
///\param ��
///\return ��
macro AddFuncDoc()
{
    // Get a handle to the current file buffer and the name
    // and location of the current symbol where the cursor is.
    hbuf = GetCurrentBuf()
    ln = GetBufLnCur( hbuf )

    buf = GetBufLine(hbuf,ln)
    blanks = GetBeginBlank(buf)
    InsBufLine( hbuf, ln, blanks # "/**" )
    InsBufLine( hbuf, ln + 1, blanks # " * \@brief " )
    InsBufLine( hbuf, ln + 2, blanks # " * \@param " )
    InsBufLine( hbuf, ln + 3, blanks # " * \@return " )
    InsBufLine( hbuf, ln + 4, blanks # " */" )
 
    // put the insertion point inside the header comment
    SetBufIns( hbuf, ln+1, strlen(blanks) + 10 )
}

macro AddDetailDoc()
{
    hbuf = GetCurrentBuf()
    ln = GetBufLnCur( hbuf )

    buf = GetBufLine(hbuf,ln)
    blanks = GetBeginBlank(buf)
    ln = ln + 1;InsBufLine( hbuf, ln, blanks # "//! " )
    line = ln
    ln = ln + 1;InsBufLine( hbuf, ln, "" )
    ln = ln + 1;InsBufLine( hbuf, ln, blanks # "//! " )
    ln = ln + 1;InsBufLine( hbuf, ln, blanks # "//! " )
 
    // put the insertion point inside the header comment
    SetBufIns( hbuf, line, strlen(blanks) + 4 )
}
macro AddBreifDoc()
{
    hbuf = GetCurrentBuf()
    ln = GetBufLnCur( hbuf )

    buf = GetBufLine(hbuf,ln)
    blanks = GetBeginBlank(buf)
    InsBufLine( hbuf, ln, blanks # "//! " )
 
    // put the insertion point inside the header comment
    SetBufIns( hbuf, ln, strlen(blanks) + 4 )
}
macro AddMemberDoc()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = GetBufLnCur( hbuf )

    buf = GetBufLine(hbuf,ln)
    pos = GetEndBlankPos(buf) + 1

    sel.ichFirst = pos
    sel.ichLim = pos
    SetWndSel(hwnd, sel)
    //SetBufSelText(hbuf, "/**<  */")
    SetBufSelText(hbuf, "///< ")
    SetBufIns( hbuf, ln, pos + 5 )
}
macro AddFileHeaderDoc()
{
    hbuf = GetCurrentBuf()
    ln = 0
    InsBufLine( hbuf, ln,    "/*" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *  ********************************************************************************")
    ln = ln + 1;InsBufLine( hbuf, ln,    " *                                     Challenger" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *                          Digital Video Recoder xp" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *   (c) Copyright 1992-2004, ZheJiang Dahua Information Technology Stock CO.LTD." )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *                            All Rights Reserved" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *  File        : Challenger.cpp" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *  Description : " )
    line = ln
    ln = ln + 1;InsBufLine( hbuf, ln,    " *  Create      : 2005/3/9      WHF     Create the file" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *  ********************************************************************************" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " */" )
    ln = ln + 1;InsBufLine( hbuf, ln,    "" )

    // put the insertion point inside the header comment
    SetBufIns( hbuf, line, 20 )
}

/*   C L O S E _   O T H E R S _   W I N D O W S   */
/*-------------------------------------------------------------------------
    Close all but the current window.  Leaves any other dirty 
    file windows open too.
-------------------------------------------------------------------------*/
macro Close_Others_Windows()
{
    hCur = GetCurrentWnd();
    hNext = GetNextWnd(hCur);
    while (hNext != 0 && hCur != hNext)
    {
        hT = GetNextWnd(hNext);
        hbuf = GetWndBuf(hNext);
        if (!IsBufDirty(hbuf))
            CloseBuf(hbuf)
        hNext = hT;
    }
}

/**
 * @brief ѡ�и���
 * @details [long description]
 * @return [description]
 */
macro CopyWord_Str()
{
    hwnd = GetCurrentWnd()
    Sel = GetWndSel(hwnd)

    //ѡ�񵥴ʻ����ַ���
    if( Sel.fExtended == false )
    {
        Select_Word
    }
    else
    {
        hbuf = GetCurrentBuf()
        ln = GetBufLnCur( hbuf )
        linebuf = GetBufLine(hbuf,ln)
        len = strlen(linebuf)

        if( Sel.ichFirst == 0 || Sel.ichLim == len )
        {
            return
        }
        else if( linebuf[Sel.ichFirst-1] == "\"" && linebuf[Sel.ichLim+1] == "\"" )
        {
            return
        }
        else
        {
            // left = strmid(linebuf,0,Sel.ichFirst)
            // leftPos = -1
            // while( left != "" )
            // {
            //     leftPos = strrstr(left,"\"", 1)
            //     if( leftPos == 0 )
            //         break
            //     else if( left[leftPos-1] == "\\" )
            //     {
            //         left = strmid(left,0,leftPos)
            //         leftPos = -1
            //     }
            //     else
            //         break
            // }
            // right = strmid(linebuf, Sel.ichLim, len)
            // rightPos = -1
            // while( right != "" )
            // {
            //     rightPos = strstr(right,"\"", 1)
            //     if( leftPos == 0 )
            //         break
            //     else if( right[rightPos+1] == "\\" )
            //     {
            //         right = strmid(right,rightPos,strlen(right))
            //         rightPos = -1
            //     }
            //     else
            //         break
            // }
            left = strmid(linebuf,0,Sel.ichFirst)
            leftPos = strrstr(left,"\"", 1)
            right = strmid(linebuf, Sel.ichLim, len)
            rightPos = strstr(right,"\"", 1)
            if( leftPos != -1 && rightPos != -1 )
            {
                Sel.ichFirst = leftPos
                Sel.ichLim = Sel.ichLim + rightPos - 1
                SetWndSel(hwnd,Sel)
            }
        }
    }
    //����
    Copy
}
macro CopyLine_ToNext()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    ichFirst = sel.ichFirst

    hbuf = GetCurrentBuf()
    ln = GetBufLnCur( hbuf )
    linebuf = GetBufLine(hbuf,ln)

    InsBufLine (hbuf, ln+1, linebuf);
    
    sel.lnFirst = ln+1
    sel.lnLast = sel.lnFirst
    SetWndSel(hwnd,sel)
}

macro Delword_or_Copy()
{
    Select_Word
    Paste
}

macro OpenBaseProj()
{
    OpenProj("\\\\10.30.21.200\\UserDesktop01\\17417\\MyDoc\\Source Insight\\Projects\\Base\\Base")
}


macro JumpBlock()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = GetBufLnCur( hbuf )
    linebuf = GetBufLine(hbuf,ln)
    len = strlen(linebuf)

    // Msg(linebuf)

    if( sel.ichFirst < len && linebuf[sel.ichFirst] != "}" )
    {
        Block_Down
    }
    else
    {
        Block_Up
    }
}
macro SelectBlockEx()
{
    Select_Block
}
macro CopyPrevFilePath()
{
    hwnd = GetCurrentWnd()
    hbuf = GetCurrentBuf()
    hNext = GetNextWnd(hwnd)
    nextBuf = GetWndBuf(hNext)
    nextbufName = GetBufName(nextBuf)

    bufname = strreplace(nextbufName,"\\", "/")
    // Msg(bufname)

    pos = strrstr(bufname,"Dahua3.0",1)
    if( pos != -1 )
    {
        filepath = strmid(bufname,pos+8,strlen(bufname))
        // Msg(filepath)
        SetBufSelText(hbuf, filepath)
        return
    }

    pos = strrstr(bufname,"HeadFiles",1)
    if( pos != -1 )
    {
        filepath = strmid(bufname,pos+9,strlen(bufname))
        // Msg(filepath)
        SetBufSelText(hbuf, filepath)
        return
    }

    //
    pos = strrstr(bufname,"Include",1)
    if( pos != -1 )
    {
        filepath = strmid(bufname,pos+7,strlen(bufname))
        // Msg(filepath)
        SetBufSelText(hbuf, filepath)
        return
    }

    SetBufSelText(hbuf,bufname)
}

//������ת������֧��ͷ�ļ���ת
macro JumpToDefinitionEx()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    linebuf = GetBufLine(hbuf,sel.lnFirst)
    
    //���ȴ���ͷ�ļ���ת
    key = "#include"
    len = strlen(key)
    linebuf = TrimLeft(linebuf) //��߿ո�ȥ��

    if( len < strlen(linebuf) )
    {
        if( strmid(linebuf,0,len) == key )
        {
            pos1 = strstr(linebuf,"\"",1)
            pos2 = strstr(linebuf,"\"",2)
            if( pos1 != -1 && pos2 != -1 )
            {
                dstfile = strmid(linebuf,pos1, pos2-1)
                dstfile = strreplace(dstfile,"/", "\\")
                // Msg(dstfile)
                JumpToFile(dstfile)
            }
            //��
            return
        }
    }

    //��Ĭ�Ϸ�ʽ���������ת
    Jump_To_Definition
}

//end dahua.em



/****************************************************************************
 *  Ver:    1.13
 *  Date:   2002.9.18
 *  Author: suqiyuan
 * ================================
 * �����м����������������֧�ֺ���:
 * ʹ����Щ�����ض�Ӧ�ļ��Ϳ�����
 *
 * ���ع�ϵ����:
 * EM_delete:            DELETE
 * EM_backspace:         BACKSPACE
 * EM_CursorUp:          �����Ϸ������
 * EM_CursorDown:        �����·������
 * EM_CursorLeft:        �����������
 * EM_CursorRight:       �����ҷ������
 * EM_SelectWordLeft:    Shift + ��
 * EM_SelectWordRight:   Shift + ��
 * EM_SelectLineUp:      Shift + ��
 * EM_SelectLineUp:      Shift + ��
 ****************************************************************************/
 
 //For keyboard delete
 Macro EM_delete()
 {
    //get current character
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop
    ln      = GetWndSelLnFirst(hWnd)
    lnLast  = GetWndSelLnLast(hWnd)
    lnCnt   = lnLast - ln + 1
    sel     = GetWndSel(hWnd)
    ich     = GetWndSelIchFirst(hWnd)
    ichLim = GetWndSelIchLim(hWnd)
    hBuf    = GetWndBuf(hWnd)
    curLine = GetBufLine(hBuf,ln)

    //Msg("Now Select lines:@lnCnt@,Line @ln@ index @ich@ to line @lnLast@ index @ichLim@")
    if((lnCnt > 1) || ((lnCnt==1)&&(ichLim>ich)))//ѡ����ǿ�
    {
        //Msg("Selection is One BLOCK.")
        curLine = GetBufLine(hBuf,ln)
        if(ich>0)
        {
            index = 0
            while(index < ich)
            {
                ch = curLine[index]
                if(SearchCharInTab(ch))
                    index = index + 1
                else
                    index = index + 2
            }
            //��������ں����м䣬������ǰ����һ���ֽ�
            sel.ichFirst = ich - (index-ich)
        }
        curLine = GetBufLine(hBuf,lnLast)
        len     = GetBufLineLength(hBuf,lnLast)
        index   = 0
        while(index < ichLim && index < len)
        {
            ch = curLine[index]
            if(SearchCharInTab(ch))
                index = index + 1
            else
                index = index + 2
        }
        sel.ichLim = index
        if(ichLim>len)
            sel.ichLim = ichLim
        SetWndSel(hWnd,sel)
        //Msg("See the block selected is adjusted now.")
        Delete_Character
    }
    else//ѡ��Ĳ��ǿ�
    {
        //Msg("Selection NOT block.")
        curChar = curLine[ich]
        //�������ĩ,Ӧ���ܹ�ʹ����һ��������β
        if(ich == strlen(curLine))
        {
            Delete_Character
            stop
        }
        //Msg("Not at the end of line.")
        flag    = SearchCharInTab(curChar)
        //Msg("Current char:@curChar@,Valid flag:@flag@")
        if(flag)
        {
            //Msg("Byte location to delete:@ich@,Current char:@curChar@")
            DelCharOfLine(hWnd,ln,ich,1)
        }
        else
        {
            /*�����ʵ�ַ�����������:�����׿�ʼ��,�����Table�е�,��һ����
             *�������,�Ӷ�����,һֱ����ǰ�ַ�,������ôɾ��
             *�����������ļٶ�,��ǰ��û�а�����ֵ�����
             */
            index = 0
            word  = 0
            byte  = 0
            len   = strlen(curLine)
            while(index < ich)
            {
                ch   = curLine[index]
                flag = SearchCharInTab(ch)
                if(flag)
                {
                    index = index + 1
                    byte  = byte + 1
                }
                else
                {
                    index = index + 2
                    word  = word + 1
                }
            }
            //index = ich + 1,current cursor is in the middle of word
            //                or in the front of byte
            //index = ich,current cursor is NOT in the front of word
            nich = 2*(word-(index-ich)) + byte
            //Msg("Start deleting position:@ich@,word:@word@,byte:@byte@")
            DelCharOfLine(hWnd,ln,nich,2)
            if((index-ich) && !flag && (ich != len-1))//����һ������ĩβ�ĺ����м�
                Cursor_Left
        }
    }
}

//For keyboard backspace <-
Macro EM_backspace()
{
    //get current character
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop
    sel     = GetWndSel(hWnd)
    ln      = sel.lnFirst
    ich     = sel.ichFirst
    if(ich < 0)
        stop
    lnLast  = GetWndSelLnLast(hWnd)
    lnCnt   = lnLast - ln + 1
    ichLim = GetWndSelIchLim(hWnd)

    //Msg("Now Select lines:@lnCnt@,Line @ln@ index @ich@ to line @lnLast@ index @ichLim@")
    if((lnCnt > 1) || ((lnCnt==1)&&(ichLim>ich)))//ѡ����ǿ�,ֱ��ɾ��������Ŀ�
    {
        EM_delete
    }
    else
        {if(ich == 0)
        {
            Backspace
            stop
        }
        hBuf    = GetWndBuf(hWnd)
        curLine = GetBufLine(hBuf,ln)

        index = 0
        flag  = 0  // 1-byte,0-word
        byte = 0
        word = 0
        while(index < ich)
        {
            ch   = curLine[index]
            flag = SearchCharInTab(ch)
            if(flag)
                {
                    byte  = byte + 1
                    index = index + 1
                }
            else
                {
                    word  = word + 1
                    index = index + 2
                }
        }
        if(flag)//char before cursor is in table
        {
            //Msg("char before cursor is in table,byte!")
            Backspace
        }
        else if(!flag && (index-ich))//current cursor is in the middle of word
        {
            //Msg("current cursor is in the middle of word.")
            DelCharOfLine(hWnd,ln,ich-1,2)
            if(!(sel.ichFirst == strlen(curLine)-1))
                Cursor_Left
        }
        else if(!flag && !(index-ich))//Current cursor is after a word
        {
            //Msg("Current cursor is after a word.")
            DelCharOfLine(hWnd,ln,ich-2,2)
            if(sel.ichFirst != strlen(curLine))
            {
                Cursor_Left
                Cursor_Left
            }
        }
    }
}

Macro SearchCharInTab(curChar)
{
     /* Total 97 chars */
    AsciiChar = AsciiFromChar(curChar)
    //Msg("Current char in SearchCharInTab():@curChar@.")
    if(AsciiChar >= 32 && AsciiChar <= 126)
        return 1
    //Msg("Current Char(@curChar@) NOT between space and ~")
    if(AsciiChar == 9)//Tab
        return 1
    //Msg("Current Char(@curChar@) NOT Tab")
    if(AsciiChar == 13)//CR
        return 1
    //Msg("Current Char(@curChar@) Not CR")
    return 0
}

Macro DelCharOfLine(hWnd,ln,ich,count)
{
    if(hWnd == 0)
        stop
    sel     = GetWndSel(hWnd)
    hBuf    = GetWndBuf(hWnd)
    if(hBuf == 0)
        stop
    if(ln > GetBufLineCount(hBuf))
        stop
    szLine = GetBufLine(hBuf,ln)
    len    = strlen(szLine)
    if(ich >  len)
        stop

    NewLine = ""
    if(ich > 0)
    {
        NewLine = NewLine # strmid(szLine,0,ich)
    }
    if(ich+count < len)
    {
        ichLim = len
        NewLine = NewLine # strmid(szLine,ich+count,ichLim)
    }
    /**/
    //Msg("Current line:@szLine@")
    //Msg("Replaced as:@NewLine@")
    /**/
    PutBufLine(hBuf,ln,NewLine)
    SetWndSel(hWnd, sel)
}


//���ƹ��
macro EM_CursorUp()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop

    hbuf = GetCurrentBuf()

    //�ƶ����
    Cursor_Up

    //����ƶ�����Ĺ��λ��
    hwnd = GetWndhandle(hbuf)
    sel = GetWndSel(hwnd)
    str = GetBufline(hbuf, sel.lnFirst)

    flag = StrChinChk(str, sel.ichFirst)
    //���λ�������ַ�֮������ǰ�ƶ�һ���ַ�
    if (flag == True)
    {
        Cursor_Left
    }
}

//���ƹ��
macro EM_CursorDown()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop

    hbuf = GetCurrentBuf()

    //�ƶ����
    Cursor_Down

    //����ƶ�����Ĺ��λ��
    hwnd = GetWndhandle(hbuf)
    sel = GetWndSel(hwnd)
    str = GetBufline(hbuf, sel.lnFirst)

    flag = StrChinChk(str, sel.ichFirst)
    //���λ�������ַ�֮������ǰ�ƶ�һ���ַ�
    if (flag == True)
    {
        Cursor_Right
    }
}


//���ƹ��
macro EM_CursorRight()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop

    hbuf = GetCurrentBuf()

    //�ƶ����
    Cursor_Right

    //����ƶ�����Ĺ��λ��
    hwnd = GetWndhandle(hbuf)
    sel = GetWndSel(hwnd)
    str = GetBufline(hbuf, sel.lnFirst)

    flag = StrChinChk(str, sel.ichFirst)
    //���λ�������ַ�֮������ǰ�ƶ�һ���ַ�(�����ʱ��������ƶ�һ���ַ�)
    if (flag == True)
    {
        Cursor_Right
    }
}

//���ƹ��
macro EM_CursorLeft()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop

    hbuf = GetCurrentBuf()

    //�ƶ����
    Cursor_Left

    //����ƶ�����Ĺ��λ��
    hwnd = GetWndhandle(hbuf)
    sel = GetWndSel(hwnd)
    str = GetBufline(hbuf, sel.lnFirst)

    flag = StrChinChk(str, sel.ichFirst)
    //���λ�������ַ�֮������ǰ�ƶ�һ���ַ�(�����ʱ��������ƶ�һ���ַ�)
    if (flag == True)
    {
        Cursor_Left
    }
}

//����ѡ���ַ�
macro EM_SelectWordLeft()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop
    hbuf = GetCurrentBuf()

    //ִ������
    Select_Char_Left

    hwnd = GetWndhandle(hbuf)
    //selold = GetWndSel(hwnd)
    sel = GetWndSel(hwnd)
    //ln = GetBufLnCur(hbuf)

    /*
    if (selold.ichFirst == sel.ichFirst && sel.lnFirst == selold.lnFirst)
        curinhead = 1
    else
        curinhead = 0
    */
    str = GetBufline(hbuf, sel.lnFirst)
    hdflag = StrChinChk(str, sel.ichFirst)

    str = GetBufline(hbuf, sel.lnLast)
    bkflag = StrChinChk(str, sel.ichLim)

    if (hdflag == TRUE || bkflag == TRUE)
    {
        Select_Char_Left
    }
}

//����ѡ���ַ�
macro EM_SelectWordRight()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop
    hbuf = GetCurrentBuf()

    //ִ������
    Select_Char_Right

    hwnd = GetWndhandle(hbuf)
    //selold = GetWndSel(hwnd)
    sel = GetWndSel(hwnd)
    //ln = GetBufLnCur(hbuf)

    /*
    if (selold.ichFirst == sel.ichFirst && sel.lnFirst == selold.lnFirst)
        curinhead = 1
    else
        curinhead = 0
    */
    str = GetBufline(hbuf, sel.lnFirst)
    hdflag = StrChinChk(str, sel.ichFirst)

    str = GetBufline(hbuf, sel.lnLast)
    bkflag = StrChinChk(str, sel.ichLim)

    if (hdflag == TRUE || bkflag == TRUE)
    {
        Select_Char_Right
    }
}

//����ѡ���ַ�
macro EM_SelectLineUp()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop
    hbuf = GetCurrentBuf()

    //ִ������
    Select_Line_Up

    hwnd = GetWndhandle(hbuf)
    //selold = GetWndSel(hwnd)
    sel = GetWndSel(hwnd)
    //ln = GetBufLnCur(hbuf)

    /*
    if (selold.ichFirst == sel.ichFirst && sel.lnFirst == selold.lnFirst)
        curinhead = 1
    else
        curinhead = 0
    */
    str = GetBufline(hbuf, sel.lnFirst)
    hdflag = StrChinChk(str, sel.ichFirst)

    str = GetBufline(hbuf, sel.lnLast)
    bkflag = StrChinChk(str, sel.ichLim)

    if (hdflag == TRUE || bkflag == TRUE)
    {
        Select_Char_Right
    }
}

//����ѡ���ַ�
macro EM_SelectLineDown()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop
    hbuf = GetCurrentBuf()

    //ִ������
    Select_Line_Down

    hwnd = GetWndhandle(hbuf)
    //selold = GetWndSel(hwnd)
    sel = GetWndSel(hwnd)
    //ln = GetBufLnCur(hbuf)

    /*
    if (selold.ichFirst == sel.ichFirst && sel.lnFirst == selold.lnFirst)
        curinhead = 1
    else
        curinhead = 0
    */
    str = GetBufline(hbuf, sel.lnFirst)
    hdflag = StrChinChk(str, sel.ichFirst)

    str = GetBufline(hbuf, sel.lnLast)
    bkflag = StrChinChk(str, sel.ichLim)

    if (hdflag == TRUE || bkflag == TRUE)
    {
        Select_Char_Right
    }
}

//���ַ���str��lnλ���м��
//�����ż���������ַ��򷵻�FALSE
//����������������ַ��򷵻�TRUE
macro StrChinChk(str, ln)
{
    tm  = 0
    flag = False
    len  = strlen(str)
    while (tm < ln)
    {
        if (str[tm] != "")
            ascstr = asciifromchar(str[tm])
        else
            ascstr = 0

        //�����ַ�ASCII > 128
        if (ascstr > 128)
            flag = !flag

        tm = tm + 1
        if (tm >= len)
            break
    }
    return flag
}

// �ڹ����в��Ұ������,����"macro OpenorNewBuf(szfile)"
macro FindHalfChcharInProj()
{
    hprj = GetCurrentProj()
    if (hprj == 0)
        stop
    ifileMax = GetProjFileCount(hprj)
    
    hOutBuf = OpenorNewBuf("HalfChch.txt")
    if (hOutBuf == hNil)
    {
        Msg("Can't Open file:HalfChchar.txt")
        stop
    }
    AppendBufLine(hOutBuf, ">>��������б�>>")
    
    ifile = 0
    while (ifile < ifileMax)
    {
        filename = GetProjFileName(hprj, ifile)
        hbuf = OpenBuf(filename)
        if (hbuf != 0)
        {
            StartMsg("@filename@ is being processing. . . press ESC to cancel.")
            iTotalLn = GetBufLineCount(hbuf)
            iCurLn = 0
            while (iCurLn < iTotalLn)
            {
                str = GetBufline(hbuf, iCurLn)
                flag = StrChinChk(str, strlen(str))
                if (flag == True)
                {
                    // ���ڰ������,��¼�ļ������к�
                    iOutLn = iCurLn + 1
                    outstr = cat(filename, "(@iOutLn@) : ")
                    outstr = cat(outstr, str)
                    AppendBufLine(hOutBuf, outstr)
                    SetSourceLink(hOutBuf,GetBufLineCount(hOutBuf)-1,filename,iCurLn)
                }
                iCurLn = iCurLn + 1
            }
            EndMsg()
        }
        ifile = ifile + 1
    }
    //SetCurrentBuf(hOutBuf)
    //Go_To_First_Link
}

// ���û��szfileָ�����ļ���,���½�,�����,������BUFF���
macro OpenorNewBuf(szfile)
{
    hout = GetBufHandle(szfile)
    if (hout == hNil)
    {
        hout = OpenBuf(szfile)
        if (hout == hNil)
        {
            hout = NewBuf(szfile)
            NewWnd(hout)
        }
    }
    return hout
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
