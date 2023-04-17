000100200721        // **************************************************************************
000200200326        //  CUSTOMER20 READ BY NATIVE LANGUAGE (ILE RPG)
000300200709        //  CONTACTS20 ROW RETRIEVED WITH EMBEDDED SQL
000400200709        //  DETAIL REPORT LINE INCLUDES INFORMATION FROM CUSTOMER20 AND CONTACTS20
000500190313        //  SUMMARRY REPORT INFORMATION RETRIEVED WITH EMBEDDED SQL STATEMENTS
000600190314
000700190313           DCL-F PHNREPORT PRINTER OFLIND(*IN01) ;
000800200326           DCL-F CUSTOMER20 DISK(*EXT) KEYED USAGE(*INPUT)
000900200326                 RENAME(CUSTOMER20:CUSTR);
001000200719           // data structure for host variables from CONTACTS20
001100200719           DCL-DS CONTACTS20 EXT END-DS;
001101200719
001200200719           // Standalone fields for indicator variables
001300200719           DCL-S INDLastCDate BINDEC(4:0);
001400200719           DCL-S INDNextCDate BINDEC(4:0);
001500190314
001600190314           DCL-S Dummy  Zoned(1);
001700190314
001800190314        //**************************************************************************
001900190314        //*                        ***   M A I N   R O U T I N E   ***
002000190314        //**************************************************************************
002100190314
002200070119                EXSR SummaryInfo;
002300200709                WRITE NEWPAGE;
002400200326                READ CUSTOMER20;
002500070119                DOW NOT %EOF;
002600070119                    EXSR SQLSelect;
002601200720                    IF PHNLDC = OldestDate;
002602200720                      HIGHLIGHT = '<-------';
002603200720                    ELSE;
002604200720                      HIGHLIGHT = ' ';
002605200720                    ENDIF;
002700190313                    IF *IN01 = *ON;
002800200709                       Write NEWPAGE;
002900190313                       *IN01 = *OFF;
003000070119                    ENDIF;
003100200709                    Write RPTLINE;
003200200326                   READ CUSTOMER20;
003300070119                ENDDO;
003400190313                Write SUMMARY;
003500070119                *INLR = *ON;
003600070119                RETURN;
003601200720
003700080923        //**********************************************************************
003800080923        //   S Q L S E L E C T   S U B R O U T I N E
003900080923   //   //********************************************************************
004000080923   //                  BEGSR    SQLSelect ;
004100080923   //    // A row from the contacts table that has the same customer number as t
004200200326   //    // read from the CUSTOMER20 file is retrieved to find out the last date
004300080923   //    // phone number, comments and the salesperson number.
004400080923   //
004500080923   //    //  The call back interval is added to the last date called to determin
004600080923   //    //  next date to call.  Since null values may be stored in the last dat
004700080923   //    // indicator variables are used.
004800200719
004801200720                           EXEC SQL
004802200720                             SELECT PHNLDC + PHNCIT DAYS, PHNLDC, CSTPHN,
004900200720                                    PHNCOM, CSTSLN
005000200720                             INTO :NEXTCDATE :INDNEXTCDATE, :PHNLDC
005100200720                                  :INDLastCDate, :CSTPHN, :PHNCOM, :CSTSLN
005200200720                               FROM BCI433LIB/CONTACTS20
005300200720                               WHERE CSTNUM = :CSTNUM;
005400190314
005500200720                             SELECT;
005600200720                               WHEN SQLSTATE = '00000';
005700200720                                 Dummy = 0;
005800200720                               WHEN SQLSTATE = '02000';
005900200720                                 CstPhn = 'Not Found';
006000200720                                 NEXTCDATE = D'9999-09-09';
006100200720                                 PhnLDC = D'9999-09-09';
006200200720                                 PhnCom = *ALL'*';
006300200720                                 CstSln = *ALL'*';
006400200720                               WHEN %Subst(SQLState :1 :2) = '01';
006500200720                                 NEXTCDATE = D'9999-09-09';
006600200720                                 PhnLDC = D'9999-09-09';
006601200720                                 PhnCom = *ALL'*';
006602200720                                 CstSln = *ALL'*';
006603200720                                 CstPhn = *ALL'*';
006604200720                               OTHER;
006605200720                                 CstPhn = *ALL'*';
006606200720                                 NEXTCDATE = D'9999-09-09';
006607200720                                 PhnLDC = D'9999-09-09';
006608200720                                 PhnCom = *ALL'*';
006609200720                                 CstSln = *ALL'*';
006610200720                               ENDSL;
006611200720
006612200720                               IF IndLastCDate = -1;
006700200720                                 CSTPHN = 'UNKNOWN DATE';
006701200720                                 NEXTCDATE = D'9999-09-09';
006702200720                                 PHNLDC = D'9999-09-09';
006703200720                               ELSE;
006704200720                                 IF IndLastCDate <> 0;
006800200720                                   CSTPHN = 'DATE PROBLEM';
006801200720                                   NEXTCDATE = D'9999-09-09';
006802200720                                   PHNLDC = D'9999-09-09';
006803200720                                 ENDIF;
006804200720                               ENDIF;
006900080923                         ENDSR ;
006901200720
007000080923        //**********************************************************************
007100080923        // S U M M A R Y I N F O   S U B R O U T I N E
007200080923        //**********************************************************************
007300080923                         BEGSR  SummaryInfo;
007400200709        //  D E T E R M I N E   T O T A L S   F O R   CONTACTS20 & CUSTOMER20
007500200719                           EXEC SQL
007501200719                             SELECT COUNT(*) INTO :CONTACTT
007502200719                               FROM BCI433LIB/CONTACTS20;
007503200719
007600200719                             IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
007601200719                               CONTACTT = -99999;
007602200719                             ENDIF;
007700190314
007800200719                           EXEC SQL
007900200719                             SELECT COUNT(*) INTO :CUSTOMERT
008000200720                               FROM BCI433LIB/CUSTOMER20;
008100190314
008200200719                             IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
008201200719                               CUSTOMERT = -99999;
008202200719                             ENDIF;
008300190314
008400200719
009000190314        // D E T E R M I N E   N U M B E R   O F   U N K N O W N   LAST   DATE CALLED
009100200719                           EXEC SQL
009101200719                             SELECT COUNT(*) INTO :UNKNOWNT
009200200719                               FROM BCI433LIB/CONTACTS20
009300200719                               WHERE CstLastCallDate IS NULL;
009400190314
009500200719                             IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
009501200719                               UNKNOWNT = -99999;
009502200719                             ENDIF;
009600190314
009700200719
010100080923        //  D E T E R M I N E   O L D E S T   &  M O S T   R E C E N T  L A S T
010200200719                           EXEC SQL
010300200719                             SELECT MIN(PHNLDC) INTO :OldestDate
010400200719                               FROM BCI433LIB/CONTACTS20;
010500190314
010600200719                             IF (SQLCODE <> 0) OR (SQLWN0 = 'W')
010601200719                                AND (SQLWN2 <> 'W');
010602200719                               OldestDate = D'9999-09-09';
010603200719                             ENDIF;
010700190314
010701200720
010800200719                           EXEC SQL
010900200720                             SELECT MAX(PHNLDC) INTO :MostRecent
010901200719                               FROM BCI433LIB/CONTACTS20;
010902200719
010903200720
011102200720                             SELECT;
011103200720                               WHEN SQLWN2 = 'W';
011104200720                                 DUMMY = 0;
011105200720                               WHEN (SQLCODE <> 0) OR (SQLWN0 = 'W');
011200200720                                 MostRecent = D'9999-09-09';
011201200720                             ENDSL;
011202200719
012100080923       // D E T E R M I N E   T H E   U S E R   S E R V E R   &   T I M E S T A
012200200719                           EXEC SQL
012201200719                             SELECT USER, CURRENT TIMESTAMP, CURRENT SERVER
012202200719                             INTO :User, :Timestamp, :Server
012300200719                               FROM SYSIBM/SYSDUMMY1;
012400200720
012800080923                         ENDSR;
