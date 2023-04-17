000100190313       //**************************************************************************                 
000200191105       //* THIS PROGRAM USES A CURSOR TO LOAD A TEMPORARY RESULT TABLE FROM 3                       
000300191105       //* SEPARATE TABLES, ONTARIO, QUEBEC AND MANITOBA. A NUMBER IS PASSED                        
000400191105       //* TO THE PROGRAM TO DETERMINE WHICH RECORDS ARE INLCUDED FROM THE 3 TABLES                 
000500190313       //**************************************************************************                 
000600190313           DCL-F PROVREPORT PRINTER OFLIND(*IN01) ;                                                 
000601200726                                                                                                    
000700190313           DCL-S ProvinceH    Char(10);                                                             
000800190313           DCL-S EndOfFile    IND;                                                                  
000900190313           DCL-S TotalRecords PACKED(5:0) ;                                                         
000901200726                                                                                                    
001000190315             // LowLimit is passed to the program                                                   
001100200726             DCL-PI MAIN EXTPGM('PROVSQLH');                                                        
001200200726                LOWLIMITIN PACKED(15:5);                                                            
001300200726             END-PI;                                                                                
001301200726                                                                                                    
001400190315             // All Host Variables available under a single name                                    
001500200726             DCL-DS CUSTOMERRECORD;                                                                 
001501200726               CUSTID    CHAR(6);                                                                   
001600200726               FULLNAME  CHAR(31);                                                                  
001700200726               CITY      CHAR(20);                                                                  
001800200726               PURCHASE  PACKED(7:2);                                                               
001900200726               PDATE     DATE;                                                                      
002000200726               PROVINCE  CHAR(10);                                                                  
002200200726             End-Ds CustomerRecord;                                                                 
002300200726                                                                                                    
002400200726       //************************************************************************                   
002500200726       //                       ***   M A I N   R O U T I N E   ***                                 
002600200726       //************************************************************************                   
002700200726                                                                                                    
002700             /SET CCSID(*CHAR:*JOBRUNMIX)                                                                 
002700             // SQL COMMUNICATION AREA                                                //SQL               
002700             DCL-DS SQLCA;                                                            //SQL               
002700               SQLCAID CHAR(8) INZ(X'0000000000000000');                              //SQL               
002700                SQLAID CHAR(8) OVERLAY(SQLCAID);                                      //SQL               
002700               SQLCABC INT(10);                                                       //SQL               
002700                SQLABC BINDEC(9) OVERLAY(SQLCABC);                                    //SQL               
002700               SQLCODE INT(10);                                                       //SQL               
002700                SQLCOD BINDEC(9) OVERLAY(SQLCODE);                                    //SQL               
002700               SQLERRML INT(5);                                                       //SQL               
002700                SQLERL BINDEC(4) OVERLAY(SQLERRML);                                   //SQL               
002700               SQLERRMC CHAR(70);                                                     //SQL               
002700                SQLERM CHAR(70) OVERLAY(SQLERRMC);                                    //SQL               
002700               SQLERRP CHAR(8);                                                       //SQL               
002700                SQLERP CHAR(8) OVERLAY(SQLERRP);                                      //SQL               
002700               SQLERR CHAR(24);                                                       //SQL               
002700                SQLER1 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002700                SQLER2 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002700                SQLER3 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002700                SQLER4 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002700                SQLER5 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002700                SQLER6 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002700                SQLERRD INT(10) DIM(6) OVERLAY(SQLERR);                               //SQL               
002700               SQLWRN CHAR(11);                                                       //SQL               
002700                SQLWN0 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002700                SQLWN1 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002700                SQLWN2 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002700                SQLWN3 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002700                SQLWN4 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002700                SQLWN5 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002700                SQLWN6 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002700                SQLWN7 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002700                SQLWN8 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002700                SQLWN9 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002700                SQLWNA CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002700                SQLWARN CHAR(1) DIM(11) OVERLAY(SQLWRN);                              //SQL               
002700               SQLSTATE CHAR(5);                                                      //SQL               
002700                SQLSTT CHAR(5) OVERLAY(SQLSTATE);                                     //SQL               
002700             END-DS SQLCA;                                                            //SQL               
002700             DCL-PR SQLROUTE_CALL EXTPGM(SQLROUTE);                                   //SQL               
002700               CA LIKEDS(SQLCA);                                                      //SQL               
002700               *N BINDEC(4) OPTIONS(*NOPASS);                                         //SQL               
002700               *N CHAR(1) OPTIONS(*NOPASS);                                           //SQL               
002700             END-PR SQLROUTE_CALL;                                                    //SQL               
002700             DCL-PR SQLOPEN_CALL EXTPGM(SQLOPEN);                                     //SQL               
002700               CA LIKEDS(SQLCA);                                                      //SQL               
002700               *N BINDEC(4);                                                          //SQL               
002700             END-PR SQLOPEN_CALL;                                                     //SQL               
002700             DCL-PR SQLCLSE_CALL EXTPGM(SQLCLSE);                                     //SQL               
002700               CA LIKEDS(SQLCA);                                                      //SQL               
002700               *N BINDEC(4);                                                          //SQL               
002700             END-PR SQLCLSE_CALL;                                                     //SQL               
002700             DCL-PR SQLCMIT_CALL EXTPGM(SQLCMIT);                                     //SQL               
002700               CA LIKEDS(SQLCA);                                                      //SQL               
002700               *N BINDEC(4);                                                          //SQL               
002700             END-PR SQLCMIT_CALL;                                                     //SQL               
002700             /RESTORE CCSID(*CHAR)                                                                        
002700             DCL-C SQLROUTE CONST('QSYS/QSQROUTE');                                   //SQL               
002700             DCL-C SQLOPEN CONST('QSYS/QSQROUTE');                                    //SQL               
002700             DCL-C SQLCLSE CONST('QSYS/QSQLCLSE');                                    //SQL               
002700             DCL-C SQLCMIT CONST('QSYS/QSQLCMIT');                                    //SQL               
002700             DCL-C SQFRD CONST(2);                                                    //SQL               
002700             DCL-C SQFCRT CONST(8);                                                   //SQL               
002700             DCL-C SQFOVR CONST(16);                                                  //SQL               
002700             DCL-C SQFAPP CONST(32);                                                  //SQL               
009100           D                 DS                                                       OPEN                
009100           D  SQL_00000              1      2B 0 INZ(128)                             length of header    
009100           D  SQL_00001              3      4B 0 INZ(2)                               statement number    
009100           D  SQL_00002              5      8U 0 INZ(0)                               invocation mark     
009100           D  SQL_00003              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
009100           D  SQL_00004             10    128A   CCSID(*JOBRUNMIX)                    end of header       
009100           D  SQL_00005            129    132P 2                                      LOWLIMIT            
009100           D  SQL_00006            133    136P 2                                      LOWLIMIT            
009100           D  SQL_00007            137    140P 2                                      LOWLIMIT            
010103           D                 DS                                                       FETCH               
010103           D  SQL_00008              1      2B 0 INZ(128)                             length of header    
010103           D  SQL_00009              3      4B 0 INZ(3)                               statement number    
010103           D  SQL_00010              5      8U 0 INZ(0)                               invocation mark     
010103           D  SQL_00011              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
010103           D  SQL_00012             10    128A   CCSID(*JOBRUNMIX)                    end of header       
010103           D  SQL_00013            129    134A   CCSID(*JOBRUNMIX)                    CUSTID              
010103           D  SQL_00014            135    165A   CCSID(*JOBRUNMIX)                    FULLNAME            
010103           D  SQL_00015            166    185A   CCSID(*JOBRUNMIX)                    CITY                
010103           D  SQL_00016            186    189P 2                                      PURCHASE            
010103           D  SQL_00017            190    197D   DATFMT(*MDY/)                        PDATE               
010103           D  SQL_00018            198    207A   CCSID(*JOBRUNMIX)                    PROVINCE            
011504           D                 DS                                                       CLOSE               
011504           D  SQL_00019              1      2B 0 INZ(128)                             length of header    
011504           D  SQL_00020              3      4B 0 INZ(4)                               statement number    
011504           D  SQL_00021              5      8U 0 INZ(0)                               invocation mark     
011504           D  SQL_00022              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
011504           D  SQL_00023             10    127A   CCSID(*JOBRUNMIX)                    end of header       
011504           D  SQL_00024            128    128A   CCSID(*JOBRUNMIX)                    end of header       
011513           D                 DS                                                       SELECT              
011513           D  SQL_00025              1      2B 0 INZ(128)                             length of header    
011513           D  SQL_00026              3      4B 0 INZ(5)                               statement number    
011513           D  SQL_00027              5      8U 0 INZ(0)                               invocation mark     
011513           D  SQL_00028              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
011513           D  SQL_00029             10    127A   CCSID(*JOBRUNMIX)                    end of header       
011513           D  SQL_00030            129    132P 2                                      LOWLIMIT            
011513           D  SQL_00031            133    134P 0                                      ONTTOTAL            
011522           D                 DS                                                       SELECT              
011522           D  SQL_00032              1      2B 0 INZ(128)                             length of header    
011522           D  SQL_00033              3      4B 0 INZ(6)                               statement number    
011522           D  SQL_00034              5      8U 0 INZ(0)                               invocation mark     
011522           D  SQL_00035              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
011522           D  SQL_00036             10    127A   CCSID(*JOBRUNMIX)                    end of header       
011522           D  SQL_00037            129    132P 2                                      LOWLIMIT            
011522           D  SQL_00038            133    134P 0                                      QUETOTAL            
011531           D                 DS                                                       SELECT              
011531           D  SQL_00039              1      2B 0 INZ(128)                             length of header    
011531           D  SQL_00040              3      4B 0 INZ(7)                               statement number    
011531           D  SQL_00041              5      8U 0 INZ(0)                               invocation mark     
011531           D  SQL_00042              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
011531           D  SQL_00043             10    127A   CCSID(*JOBRUNMIX)                    end of header       
011531           D  SQL_00044            129    132P 2                                      LOWLIMIT            
011531           D  SQL_00045            133    134P 0                                      MANTOTAL            
002701200726                LOWLIMIT = LOWLIMITIN;                                                              
002800100309                EXSR PrepareFiles;                                                                  
002900200709                Write ReportHdg;                                                                    
003000200709                Write RColumns;                                                                     
003100100309                EXSR GetRow;                                                                        
003200190313                Write NewProv;                                                                      
003300070209                ProvinceH = Province;                                                               
003400070202                DOW NOT EndOfFile;                                                                  
003500200726                    IF *IN01 = *ON;                                                                 
003700200709                        Write RColumns;                                                             
003800190313                       *IN01 = *OFF;                                                                
003900070209                    ENDIF;                                                                          
004000190315                    // Province may change                                                          
004100200726                    IF PROVINCEH = PROVINCE;                                                        
004101200726                      WRITE DETAIL;                                                                 
004102200726                    ELSE;                                                                           
004103200726                      PROVINCEH = PROVINCE;                                                         
004104200726                      WRITE TOTALS;                                                                 
004105200726                      TOTALPURCH = 0;                                                               
004106200726                      WRITE NEWPROV;                                                                
004107200726                      WRITE DETAIL;                                                                 
004108200726                    ENDIF;                                                                          
004200200726                                                                                                    
005200200726                  //TotalPurch     = TotalPurch     + Purchase;                                     
005300200726                  //TotalRecords= TotalRecords + 1;                                                 
005301200726                    TOTALPURCH += PURCHASE;                                                         
005302200726                    TOTALRECORDS += 1;                                                              
005400100309                    EXSR GetRow;                                                                    
005500070119                ENDDO;                                                                              
005600190313                Write Totals;                                                                       
005700070202                EXSR   WRAPUP;                                                                      
005800190313                Write UnderLimit;                                                                   
005900070119                *INLR = *ON;                                                                        
006000070119                RETURN;                                                                             
006100100309        //**********************************************************************                    
006200100309        // O P E N F I L E S   S U B R O U T I N E                                                  
006300100309        //**********************************************************************                    
006400100309         BEGSR  PrepareFiles;                                                                       
006500190315        // S E T   U P   T H E   T E M P O R A R Y   R E S U L T  STRUCTURE                         
006600200726       //*    EXEC SQL                                                                              
006601200726       //*      DECLARE ALLPROVCURSOR CURSOR                                                        
006602200726       //*        FOR                                                                               
006603200726       //*                                                                                          
006604200726       //*        SELECT  CUSTID, TRIM(FNAME) || ' ' || LNAME,                                      
006700200726       //*                CITY, PURCHASE, PDATE,                                                    
006800200726       //*                'Ontario' AS PROVINCE                                                     
006900200726       //*           FROM    BCI433LIB/ONTARIO                                                      
007000200726       //*           WHERE   PURCHASE > :LowLimit                                                   
007100190315       //*                                                                                          
007200200726       //*        UNION ALL                                                                         
007300190315       //*                                                                                          
007301200726       //*        SELECT  CUSTID, TRIM(FNAME) || ' ' || LNAME,                                      
007302200726       //*                CITY, PURCHASE, PDATE,                                                    
007303200726       //*                'Quebec' AS PROVINCE                                                      
007304200726       //*           FROM BCI433LIB/QUEBEC                                                          
007305200726       //*           WHERE PURCHASE > :LowLimit                                                     
007306200726       //*                                                                                          
007400200726       //*        UNION ALL                                                                         
007401200726       //*                                                                                          
007402200726       //*        SELECT CUSTID, TRIM(FNAME) || ' ' || LNAME,                                       
007403200726       //*               CITY, PURCHASE, PDATE,                                                     
007500200726       //*               'Manitoba' AS PROVINCE                                                     
007501200726       //*           FROM BCI433LIB/MANITOBA                                                        
007502200726       //*           WHERE PURCHASE > :LowLimit                                                     
007503200726       //*                                                                                          
007600200726       //*        FOR READ ONLY;                                                                    
007601200726                                                                                                    
008800100309        // A   T E M P O R A R Y   R E S U L T   T A B L E   I S   C R E A T E D                    
008900100309                                                                                                    
009000200726       //*    EXEC SQL                                                                              
009100200726       //*         OPEN ALLPROVCURSOR;                                                              
009100                SQL_00005 = LOWLIMIT;                                                 //SQL               
009100                SQL_00006 = LOWLIMIT;                                                 //SQL               
009100                SQL_00007 = LOWLIMIT;                                                 //SQL               
009100                SQLER6 = -4;                                                          //SQL               
009100                IF SQL_00002 = 0                                                      //SQL               
009100                OR SQL_00003 <> *LOVAL;                                               //SQL               
009100                SQLROUTE_CALL(                                                        //SQL               
009100                     SQLCA                                                            //SQL               
009100                   : SQL_00000                                                        //SQL               
009100                );                                                                    //SQL               
009100                ELSE;                                                                 //SQL               
009100                SQLOPEN_CALL(                                                         //SQL               
009100                     SQLCA                                                            //SQL               
009100                   : SQL_00000                                                        //SQL               
009100                );                                                                    //SQL               
009100                ENDIF;                                                                //SQL               
009200190315                                                                                                    
009300200726                IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                    
009301200726                  ENDOFFILE = *ON;                                                                  
009302200726                ENDIF;                                                                              
009600100309            ENDSR;                                                                                  
009700100309        //**********************************************************************                    
009800100309        //   G E T     R O W    S U B R O U T I N E                                                 
009900100309        //**********************************************************************                    
010000100309            BEGSR     GETROW;                                                                       
010100200726       //*       EXEC SQL                                                                           
010101200726       //*         FETCH NEXT                                                                       
010102200726       //*         FROM ALLPROVCURSOR                                                               
010103200726       //*         INTO :CUSTOMERRECORD;                                                            
010103                SQLER6 = -4;                                                          //SQL 3             
010103                SQLROUTE_CALL(                                                        //SQL               
010103                     SQLCA                                                            //SQL               
010103                   : SQL_00008                                                        //SQL               
010103                );                                                                    //SQL               
010103                IF SQL_00011 = '1';                                                   //SQL               
010103                EVAL CUSTID = SQL_00013;                                              //SQL               
010103                EVAL FULLNAME = SQL_00014;                                            //SQL               
010103                EVAL CITY = SQL_00015;                                                //SQL               
010103                EVAL PURCHASE = SQL_00016;                                            //SQL               
010103                EVAL PDATE = SQL_00017;                                               //SQL               
010103                EVAL PROVINCE = SQL_00018;                                            //SQL               
010103                ENDIF;                                                                //SQL               
010104200726                                                                                                    
010203200726                IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                    
010204200726                  ENDOFFILE = *ON;                                                                  
010205200726                ENDIF;                                                                              
010206200726                                                                                                    
010207200726            ENDSR;                                                                                  
010300190315                                                                                                    
010400200726                                                                                                    
011200100309        //**********************************************************************                    
011300100309        // W R A P U P     S U B R O U T I N E                                                      
011400100309        //**********************************************************************                    
011500100309           BEGSR WRAPUP;                                                                            
011503200726       //*      EXEC SQL                                                                            
011504200726       //*        CLOSE ALLPROVCURSOR;                                                              
011504                SQLER6 = 4;                                                           //SQL               
011504                IF SQL_00021 = 0;                                                     //SQL               
011504                SQLROUTE_CALL(                                                        //SQL               
011504                     SQLCA                                                            //SQL               
011504                   : SQL_00019                                                        //SQL               
011504                );                                                                    //SQL               
011504                ELSE;                                                                 //SQL               
011504                SQLCLSE_CALL(                                                         //SQL               
011504                     SQLCA                                                            //SQL               
011504                   : SQL_00019                                                        //SQL               
011504                );                                                                    //SQL               
011504                ENDIF;                                                                //SQL               
011505200726                                                                                                    
011506200726               IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                     
011507200726                  ENDOFFILE = *ON;                                                                  
011508200726                ENDIF;                                                                              
011509200726                                                                                                    
011510200726       //*      EXEC SQL                                                                            
011511200726       //*        SELECT COUNT(*) INTO :ONTTOTAL                                                    
011512200726       //*          FROM  BCI433LIB/ONTARIO                                                         
011513200726       //*          WHERE PURCHASE <= :LOWLIMIT;                                                    
011513                SQL_00030 = LOWLIMIT;                                                 //SQL               
011513                SQLER6 = -4;                                                          //SQL 5             
011513                SQLROUTE_CALL(                                                        //SQL               
011513                     SQLCA                                                            //SQL               
011513                   : SQL_00025                                                        //SQL               
011513                );                                                                    //SQL               
011513                IF SQL_00028 = '1';                                                   //SQL               
011513                EVAL ONTTOTAL = SQL_00031;                                            //SQL               
011513                ENDIF;                                                                //SQL               
011514200726                                                                                                    
011515200726              IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                      
011516200726                  ONTTOTAL = -999;                                                                  
011517200726              ENDIF;                                                                                
011518200726                                                                                                    
011519200726       //*      EXEC SQL                                                                            
011520200726       //*        SELECT COUNT(*) INTO :QUETOTAL                                                    
011521200726       //*          FROM BCI433LIB/QUEBEC                                                           
011522200726       //*          WHERE PURCHASE <= :LOWLIMIT;                                                    
011522                SQL_00037 = LOWLIMIT;                                                 //SQL               
011522                SQLER6 = -4;                                                          //SQL 6             
011522                SQLROUTE_CALL(                                                        //SQL               
011522                     SQLCA                                                            //SQL               
011522                   : SQL_00032                                                        //SQL               
011522                );                                                                    //SQL               
011522                IF SQL_00035 = '1';                                                   //SQL               
011522                EVAL QUETOTAL = SQL_00038;                                            //SQL               
011522                ENDIF;                                                                //SQL               
011523200726                                                                                                    
011524200726              IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                      
011525200726                  QUETOTAL = -999;                                                                  
011526200726              ENDIF;                                                                                
011527200726                                                                                                    
011528200726       //*      EXEC SQL                                                                            
011529200726       //*        SELECT COUNT(*) INTO :MANTOTAL                                                    
011530200726       //*          FROM BCI433LIB/MANITOBA                                                         
011531200726       //*          WHERE PURCHASE <= :LOWLIMIT;                                                    
011531                SQL_00044 = LOWLIMIT;                                                 //SQL               
011531                SQLER6 = -4;                                                          //SQL 7             
011531                SQLROUTE_CALL(                                                        //SQL               
011531                     SQLCA                                                            //SQL               
011531                   : SQL_00039                                                        //SQL               
011531                );                                                                    //SQL               
011531                IF SQL_00042 = '1';                                                   //SQL               
011531                EVAL MANTOTAL = SQL_00045;                                            //SQL               
011531                ENDIF;                                                                //SQL               
011532200726                                                                                                    
011533200726              IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                      
011534200726                  MANTOTAL = -999;                                                                  
011535200726              ENDIF;                                                                                
011536200726                                                                                                    
011600100309          ENDSR;                                                                                    
011700190315                                                                                                    
011800190315                                                                                                    
011900200726                                                                                                    
