000100190313         // **************************************************************************              
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
002100             /SET CCSID(*CHAR:*JOBRUNMIX)                                                                 
002100             // SQL COMMUNICATION AREA                                                //SQL               
002100             DCL-DS SQLCA;                                                            //SQL               
002100               SQLCAID CHAR(8) INZ(X'0000000000000000');                              //SQL               
002100                SQLAID CHAR(8) OVERLAY(SQLCAID);                                      //SQL               
002100               SQLCABC INT(10);                                                       //SQL               
002100                SQLABC BINDEC(9) OVERLAY(SQLCABC);                                    //SQL               
002100               SQLCODE INT(10);                                                       //SQL               
002100                SQLCOD BINDEC(9) OVERLAY(SQLCODE);                                    //SQL               
002100               SQLERRML INT(5);                                                       //SQL               
002100                SQLERL BINDEC(4) OVERLAY(SQLERRML);                                   //SQL               
002100               SQLERRMC CHAR(70);                                                     //SQL               
002100                SQLERM CHAR(70) OVERLAY(SQLERRMC);                                    //SQL               
002100               SQLERRP CHAR(8);                                                       //SQL               
002100                SQLERP CHAR(8) OVERLAY(SQLERRP);                                      //SQL               
002100               SQLERR CHAR(24);                                                       //SQL               
002100                SQLER1 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER2 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER3 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER4 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER5 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER6 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLERRD INT(10) DIM(6) OVERLAY(SQLERR);                               //SQL               
002100               SQLWRN CHAR(11);                                                       //SQL               
002100                SQLWN0 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN1 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN2 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN3 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN4 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN5 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN6 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN7 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN8 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN9 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWNA CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWARN CHAR(1) DIM(11) OVERLAY(SQLWRN);                              //SQL               
002100               SQLSTATE CHAR(5);                                                      //SQL               
002100                SQLSTT CHAR(5) OVERLAY(SQLSTATE);                                     //SQL               
002100             END-DS SQLCA;                                                            //SQL               
002100             DCL-PR SQLROUTE_CALL EXTPGM(SQLROUTE);                                   //SQL               
002100               CA LIKEDS(SQLCA);                                                      //SQL               
002100               *N BINDEC(4) OPTIONS(*NOPASS);                                         //SQL               
002100               *N CHAR(1) OPTIONS(*NOPASS);                                           //SQL               
002100             END-PR SQLROUTE_CALL;                                                    //SQL               
002100             DCL-PR SQLOPEN_CALL EXTPGM(SQLOPEN);                                     //SQL               
002100               CA LIKEDS(SQLCA);                                                      //SQL               
002100               *N BINDEC(4);                                                          //SQL               
002100             END-PR SQLOPEN_CALL;                                                     //SQL               
002100             DCL-PR SQLCLSE_CALL EXTPGM(SQLCLSE);                                     //SQL               
002100               CA LIKEDS(SQLCA);                                                      //SQL               
002100               *N BINDEC(4);                                                          //SQL               
002100             END-PR SQLCLSE_CALL;                                                     //SQL               
002100             DCL-PR SQLCMIT_CALL EXTPGM(SQLCMIT);                                     //SQL               
002100               CA LIKEDS(SQLCA);                                                      //SQL               
002100               *N BINDEC(4);                                                          //SQL               
002100             END-PR SQLCMIT_CALL;                                                     //SQL               
002100             /RESTORE CCSID(*CHAR)                                                                        
002100             DCL-C SQLROUTE CONST('QSYS/QSQROUTE');                                   //SQL               
002100             DCL-C SQLOPEN CONST('QSYS/QSQROUTE');                                    //SQL               
002100             DCL-C SQLCLSE CONST('QSYS/QSQLCLSE');                                    //SQL               
002100             DCL-C SQLCMIT CONST('QSYS/QSQLCMIT');                                    //SQL               
002100             DCL-C SQFRD CONST(2);                                                    //SQL               
002100             DCL-C SQFCRT CONST(8);                                                   //SQL               
002100             DCL-C SQFOVR CONST(16);                                                  //SQL               
002100             DCL-C SQFAPP CONST(32);                                                  //SQL               
005300           D                 DS                                                       SELECT              
005300           D  SQL_00000              1      2B 0 INZ(128)                             length of header    
005300           D  SQL_00001              3      4B 0 INZ(1)                               statement number    
005300           D  SQL_00002              5      8U 0 INZ(0)                               invocation mark     
005300           D  SQL_00003              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
005300           D  SQL_00004             10    128A   CCSID(*JOBRUNMIX)                    end of header       
005300           D  SQL_00005            129    131P 0                                      CSTNUM              
005300           D  SQL_00006            132    139D   DATFMT(*MDY/)                        NEXTCDATE           
005300           D  SQL_00008            140    147D   DATFMT(*MDY/)                        PHNLDC              
005300           D  SQL_00010            148    162A   CCSID(*JOBRUNMIX)                    CSTPHN              
005300           D  SQL_00011            163    189A   VARYING CCSID(*JOBRUNMIX)            PHNCOM              
005300           D  SQL_00012            190    192A   CCSID(*JOBRUNMIX)                    CSTSLN              
005300           D  SQL_00007            193    194B 0                                      INDNEXTCDATE        
005300           D  SQL_00009            195    196B 0                                      INDLASTCDATE        
007502           D                 DS                                                       SELECT              
007502           D  SQL_00013              1      2B 0 INZ(128)                             length of header    
007502           D  SQL_00014              3      4B 0 INZ(2)                               statement number    
007502           D  SQL_00015              5      8U 0 INZ(0)                               invocation mark     
007502           D  SQL_00016              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
007502           D  SQL_00017             10    128A   CCSID(*JOBRUNMIX)                    end of header       
007502           D  SQL_00018            129    131P 0                                      CONTACTT            
008000           D                 DS                                                       SELECT              
008000           D  SQL_00019              1      2B 0 INZ(128)                             length of header    
008000           D  SQL_00020              3      4B 0 INZ(3)                               statement number    
008000           D  SQL_00021              5      8U 0 INZ(0)                               invocation mark     
008000           D  SQL_00022              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
008000           D  SQL_00023             10    128A   CCSID(*JOBRUNMIX)                    end of header       
008000           D  SQL_00024            129    131P 0                                      CUSTOMERT           
009300           D                 DS                                                       SELECT              
009300           D  SQL_00025              1      2B 0 INZ(128)                             length of header    
009300           D  SQL_00026              3      4B 0 INZ(4)                               statement number    
009300           D  SQL_00027              5      8U 0 INZ(0)                               invocation mark     
009300           D  SQL_00028              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
009300           D  SQL_00029             10    128A   CCSID(*JOBRUNMIX)                    end of header       
009300           D  SQL_00030            129    131P 0                                      UNKNOWNT            
010400           D                 DS                                                       SELECT              
010400           D  SQL_00031              1      2B 0 INZ(128)                             length of header    
010400           D  SQL_00032              3      4B 0 INZ(5)                               statement number    
010400           D  SQL_00033              5      8U 0 INZ(0)                               invocation mark     
010400           D  SQL_00034              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
010400           D  SQL_00035             10    128A   CCSID(*JOBRUNMIX)                    end of header       
010400           D  SQL_00036            129    136D   DATFMT(*MDY/)                        OLDESTDATE          
010901           D                 DS                                                       SELECT              
010901           D  SQL_00037              1      2B 0 INZ(128)                             length of header    
010901           D  SQL_00038              3      4B 0 INZ(6)                               statement number    
010901           D  SQL_00039              5      8U 0 INZ(0)                               invocation mark     
010901           D  SQL_00040              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
010901           D  SQL_00041             10    128A   CCSID(*JOBRUNMIX)                    end of header       
010901           D  SQL_00042            129    136D   DATFMT(*MDY/)                        MOSTRECENT          
012300           D                 DS                                                       SELECT              
012300           D  SQL_00043              1      2B 0 INZ(128)                             length of header    
012300           D  SQL_00044              3      4B 0 INZ(7)                               statement number    
012300           D  SQL_00045              5      8U 0 INZ(0)                               invocation mark     
012300           D  SQL_00046              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
012300           D  SQL_00047             10    128A   CCSID(*JOBRUNMIX)                    end of header       
012300           D  SQL_00048            129    138A   CCSID(*JOBRUNMIX)                    USER                
012300           D  SQL_00049            139    164Z                                        TIMESTAMP           
012300           D  SQL_00050            165    174A   CCSID(*JOBRUNMIX)                    SERVER              
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
004801200720       //*                    EXEC SQL                                                              
004802200720       //*                      SELECT PHNLDC + PHNCIT DAYS, PHNLDC, CSTPHN,                        
004900200720       //*                             PHNCOM, CSTSLN                                               
005000200720       //*                      INTO :NEXTCDATE :INDNEXTCDATE, :PHNLDC                              
005100200720       //*                           :INDLastCDate, :CSTPHN, :PHNCOM, :CSTSLN                       
005200200720       //*                        FROM BCI433LIB/CONTACTS20                                         
005300200720       //*                        WHERE CSTNUM = :CSTNUM;                                           
005300                SQL_00005 = CSTNUM;                                                   //SQL               
005300                SQLER6 = -4;                                                          //SQL 1             
005300                SQLROUTE_CALL(                                                        //SQL               
005300                     SQLCA                                                            //SQL               
005300                   : SQL_00000                                                        //SQL               
005300                );                                                                    //SQL               
005300                IF SQL_00003 = '1';                                                   //SQL               
005300                IF SQL_00007 >= 0;                                                    //SQL               
005300                EVAL NEXTCDATE = SQL_00006;                                           //SQL               
005300                ENDIF;                                                                //SQL               
005300                EVAL INDNEXTCDATE = SQL_00007;                                        //SQL               
005300                IF SQL_00009 >= 0;                                                    //SQL               
005300                EVAL PHNLDC = SQL_00008;                                              //SQL               
005300                ENDIF;                                                                //SQL               
005300                EVAL INDLASTCDATE = SQL_00009;                                        //SQL               
005300                EVAL CSTPHN = SQL_00010;                                              //SQL               
005300                EVAL PHNCOM = SQL_00011;                                              //SQL               
005300                EVAL CSTSLN = SQL_00012;                                              //SQL               
005300                ENDIF;                                                                //SQL               
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
007500200719       //*                    EXEC SQL                                                              
007501200719       //*                      SELECT COUNT(*) INTO :CONTACTT                                      
007502200719       //*                        FROM BCI433LIB/CONTACTS20;                                        
007502                SQLER6 = -4;                                                          //SQL 2             
007502                SQLROUTE_CALL(                                                        //SQL               
007502                     SQLCA                                                            //SQL               
007502                   : SQL_00013                                                        //SQL               
007502                );                                                                    //SQL               
007502                IF SQL_00016 = '1';                                                   //SQL               
007502                EVAL CONTACTT = SQL_00018;                                            //SQL               
007502                ENDIF;                                                                //SQL               
007503200719                                                                                                    
007600200719                             IF (SQLCODE <> 0) OR (SQLWN0 = 'W');                                   
007601200719                               CONTACTT = -99999;                                                   
007602200719                             ENDIF;                                                                 
007700190314                                                                                                    
007800200719       //*                    EXEC SQL                                                              
007900200719       //*                      SELECT COUNT(*) INTO :CUSTOMERT                                     
008000200720       //*                        FROM BCI433LIB/CUSTOMER20;                                        
008000                SQLER6 = -4;                                                          //SQL 3             
008000                SQLROUTE_CALL(                                                        //SQL               
008000                     SQLCA                                                            //SQL               
008000                   : SQL_00019                                                        //SQL               
008000                );                                                                    //SQL               
008000                IF SQL_00022 = '1';                                                   //SQL               
008000                EVAL CUSTOMERT = SQL_00024;                                           //SQL               
008000                ENDIF;                                                                //SQL               
008100190314                                                                                                    
008200200719                             IF (SQLCODE <> 0) OR (SQLWN0 = 'W');                                   
008201200719                               CUSTOMERT = -99999;                                                  
008202200719                             ENDIF;                                                                 
008300190314                                                                                                    
008400200719                                                                                                    
009000190314        // D E T E R M I N E   N U M B E R   O F   U N K N O W N   LAST   DATE CALLED               
009100200719       //*                    EXEC SQL                                                              
009101200719       //*                      SELECT COUNT(*) INTO :UNKNOWNT                                      
009200200719       //*                        FROM BCI433LIB/CONTACTS20                                         
009300200719       //*                        WHERE CstLastCallDate IS NULL;                                    
009300                SQLER6 = -4;                                                          //SQL 4             
009300                SQLROUTE_CALL(                                                        //SQL               
009300                     SQLCA                                                            //SQL               
009300                   : SQL_00025                                                        //SQL               
009300                );                                                                    //SQL               
009300                IF SQL_00028 = '1';                                                   //SQL               
009300                EVAL UNKNOWNT = SQL_00030;                                            //SQL               
009300                ENDIF;                                                                //SQL               
009400190314                                                                                                    
009500200719                             IF (SQLCODE <> 0) OR (SQLWN0 = 'W');                                   
009501200719                               UNKNOWNT = -99999;                                                   
009502200719                             ENDIF;                                                                 
009600190314                                                                                                    
009700200719                                                                                                    
010100080923        //  D E T E R M I N E   O L D E S T   &  M O S T   R E C E N T  L A S T                     
010200200719       //*                    EXEC SQL                                                              
010300200719       //*                      SELECT MIN(PHNLDC) INTO :OldestDate                                 
010400200719       //*                        FROM BCI433LIB/CONTACTS20;                                        
010400                SQLER6 = -4;                                                          //SQL 5             
010400                SQLROUTE_CALL(                                                        //SQL               
010400                     SQLCA                                                            //SQL               
010400                   : SQL_00031                                                        //SQL               
010400                );                                                                    //SQL               
010400                IF SQL_00034 = '1';                                                   //SQL               
010400                EVAL OLDESTDATE = SQL_00036;                                          //SQL               
010400                ENDIF;                                                                //SQL               
010500190314                                                                                                    
010600200719                             IF (SQLCODE <> 0) OR (SQLWN0 = 'W')                                    
010601200719                                AND (SQLWN2 <> 'W');                                                
010602200719                               OldestDate = D'9999-09-09';                                          
010603200719                             ENDIF;                                                                 
010700190314                                                                                                    
010701200720                                                                                                    
010800200719       //*                    EXEC SQL                                                              
010900200720       //*                      SELECT MAX(PHNLDC) INTO :MostRecent                                 
010901200719       //*                        FROM BCI433LIB/CONTACTS20;                                        
010901                SQLER6 = -4;                                                          //SQL 6             
010901                SQLROUTE_CALL(                                                        //SQL               
010901                     SQLCA                                                            //SQL               
010901                   : SQL_00037                                                        //SQL               
010901                );                                                                    //SQL               
010901                IF SQL_00040 = '1';                                                   //SQL               
010901                EVAL MOSTRECENT = SQL_00042;                                          //SQL               
010901                ENDIF;                                                                //SQL               
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
012200200719       //*                    EXEC SQL                                                              
012201200719       //*                      SELECT USER, CURRENT TIMESTAMP, CURRENT SERVER                      
012202200719       //*                      INTO :User, :Timestamp, :Server                                     
012300200719       //*                        FROM SYSIBM/SYSDUMMY1;                                            
012300                SQLER6 = -4;                                                          //SQL 7             
012300                SQLROUTE_CALL(                                                        //SQL               
012300                     SQLCA                                                            //SQL               
012300                   : SQL_00043                                                        //SQL               
012300                );                                                                    //SQL               
012300                IF SQL_00046 = '1';                                                   //SQL               
012300                EVAL USER = SQL_00048;                                                //SQL               
012300                EVAL TIMESTAMP = SQL_00049;                                           //SQL               
012300                EVAL SERVER = SQL_00050;                                              //SQL               
012300                ENDIF;                                                                //SQL               
012400200720                                                                                                    
012800080923                         ENDSR;                                                                     
