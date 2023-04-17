000100191105       //***********************************************************************                    
000200200810       //* Name: Hyunji Cho                                                                         
000300200721       //*                                                                                          
000400200721       //*                                                                                          
000500191105       //***********************************************************************                    
000600200811                                                                                                    
000602200811                                                                                                    
000603200811       DCL-F BBALLRPT PRINTER OFLIND(*IN01);                                                        
000604200811                                                                                                    
000605200811       DCL-S PositionH  CHAR(10);                                                                   
000606200811       DCL-S TotalAge   PACKED(5:0) ;                                                               
000607200811       DCL-S TotalWt    PACKED(5:0) ;                                                               
000608200811       DCL-S TeamIn     PACKED(3:0);                                                                
000609200811       DCL-S EndOfFile  IND;                                                                        
000610200811                                                                                                    
000611200811                                                                                                    
000612200811                                                                                                    
000613200811       DCL-PI Main EXTPGM('BASEBALLH');                                                             
000614200811         TeamInP CHAR(3);                                                                           
000615200811       END-PI;                                                                                      
000616200811                                                                                                    
000617200811       DCL-DS PlayersData;                                                                          
000618200811         PPosition CHAR(9);                                                                         
000619200811         FullName CHAR(36);                                                                         
000620200811         Number CHAR(2);                                                                            
000621200811         BirthDate DATE;                                                                            
000622200811         AGE ZONED(2);                                                                              
000623200811         Height CHAR(6);                                                                            
000624200811         Weight PACKED(3:0);                                                                        
000625200811         HitsThrows CHAR(4);                                                                        
000626200811       END-DS PlayersData;                                                                          
000627200811                                                                                                    
000628200811       DCL-DS TeamData;                                                                             
000629200811         *N CHAR(20) INZ('Boston Red Sox');                                                         
000630200811         *N CHAR(20) INZ('New York Yankees');                                                       
000631200811         *N CHAR(20) INZ('Toronto Blue Jays');                                                      
000632200811         *N CHAR(20) INZ('Baltimore Orioles');                                                      
000633200811         *N CHAR(20) INZ('Tampa Bay Rays');                                                         
000634200811                                                                                                    
000635200811         TeamArray CHAR(20) DIM(5) POS(1);                                                          
000636200811       END-DS TeamData;                                                                             
000637200811                                                                                                    
000638200811      //*************************************************************************                   
000639200811      //                   ***   M A I N   R O U T I N E   ***                                      
000640200811      //*************************************************************************                   
000640             /SET CCSID(*CHAR:*JOBRUNMIX)                                                                 
000640             // SQL COMMUNICATION AREA                                                //SQL               
000640             DCL-DS SQLCA;                                                            //SQL               
000640               SQLCAID CHAR(8) INZ(X'0000000000000000');                              //SQL               
000640                SQLAID CHAR(8) OVERLAY(SQLCAID);                                      //SQL               
000640               SQLCABC INT(10);                                                       //SQL               
000640                SQLABC BINDEC(9) OVERLAY(SQLCABC);                                    //SQL               
000640               SQLCODE INT(10);                                                       //SQL               
000640                SQLCOD BINDEC(9) OVERLAY(SQLCODE);                                    //SQL               
000640               SQLERRML INT(5);                                                       //SQL               
000640                SQLERL BINDEC(4) OVERLAY(SQLERRML);                                   //SQL               
000640               SQLERRMC CHAR(70);                                                     //SQL               
000640                SQLERM CHAR(70) OVERLAY(SQLERRMC);                                    //SQL               
000640               SQLERRP CHAR(8);                                                       //SQL               
000640                SQLERP CHAR(8) OVERLAY(SQLERRP);                                      //SQL               
000640               SQLERR CHAR(24);                                                       //SQL               
000640                SQLER1 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000640                SQLER2 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000640                SQLER3 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000640                SQLER4 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000640                SQLER5 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000640                SQLER6 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000640                SQLERRD INT(10) DIM(6) OVERLAY(SQLERR);                               //SQL               
000640               SQLWRN CHAR(11);                                                       //SQL               
000640                SQLWN0 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000640                SQLWN1 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000640                SQLWN2 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000640                SQLWN3 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000640                SQLWN4 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000640                SQLWN5 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000640                SQLWN6 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000640                SQLWN7 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000640                SQLWN8 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000640                SQLWN9 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000640                SQLWNA CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000640                SQLWARN CHAR(1) DIM(11) OVERLAY(SQLWRN);                              //SQL               
000640               SQLSTATE CHAR(5);                                                      //SQL               
000640                SQLSTT CHAR(5) OVERLAY(SQLSTATE);                                     //SQL               
000640             END-DS SQLCA;                                                            //SQL               
000640             DCL-PR SQLROUTE_CALL EXTPGM(SQLROUTE);                                   //SQL               
000640               CA LIKEDS(SQLCA);                                                      //SQL               
000640               *N BINDEC(4) OPTIONS(*NOPASS);                                         //SQL               
000640               *N CHAR(1) OPTIONS(*NOPASS);                                           //SQL               
000640             END-PR SQLROUTE_CALL;                                                    //SQL               
000640             DCL-PR SQLOPEN_CALL EXTPGM(SQLOPEN);                                     //SQL               
000640               CA LIKEDS(SQLCA);                                                      //SQL               
000640               *N BINDEC(4);                                                          //SQL               
000640             END-PR SQLOPEN_CALL;                                                     //SQL               
000640             DCL-PR SQLCLSE_CALL EXTPGM(SQLCLSE);                                     //SQL               
000640               CA LIKEDS(SQLCA);                                                      //SQL               
000640               *N BINDEC(4);                                                          //SQL               
000640             END-PR SQLCLSE_CALL;                                                     //SQL               
000640             DCL-PR SQLCMIT_CALL EXTPGM(SQLCMIT);                                     //SQL               
000640               CA LIKEDS(SQLCA);                                                      //SQL               
000640               *N BINDEC(4);                                                          //SQL               
000640             END-PR SQLCMIT_CALL;                                                     //SQL               
000640             /RESTORE CCSID(*CHAR)                                                                        
000640             DCL-C SQLROUTE CONST('QSYS/QSQROUTE');                                   //SQL               
000640             DCL-C SQLOPEN CONST('QSYS/QSQROUTE');                                    //SQL               
000640             DCL-C SQLCLSE CONST('QSYS/QSQLCLSE');                                    //SQL               
000640             DCL-C SQLCMIT CONST('QSYS/QSQLCMIT');                                    //SQL               
000640             DCL-C SQFRD CONST(2);                                                    //SQL               
000640             DCL-C SQFCRT CONST(8);                                                   //SQL               
000640             DCL-C SQFOVR CONST(16);                                                  //SQL               
000640             DCL-C SQFAPP CONST(32);                                                  //SQL               
000771           D                 DS                                                       OPEN                
000771           D  SQL_00000              1      2B 0 INZ(128)                             length of header    
000771           D  SQL_00001              3      4B 0 INZ(2)                               statement number    
000771           D  SQL_00002              5      8U 0 INZ(0)                               invocation mark     
000771           D  SQL_00003              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000771           D  SQL_00004             10    128A   CCSID(*JOBRUNMIX)                    end of header       
000771           D  SQL_00005            129    130P 0                                      TEAMIN              
000771           D  SQL_00006            131    132P 0                                      TEAMIN              
000771           D  SQL_00007            133    134P 0                                      TEAMIN              
000771           D  SQL_00008            135    136P 0                                      TEAMIN              
000771           D  SQL_00009            137    138P 0                                      TEAMIN              
000784           D                 DS                                                       FETCH               
000784           D  SQL_00010              1      2B 0 INZ(128)                             length of header    
000784           D  SQL_00011              3      4B 0 INZ(3)                               statement number    
000784           D  SQL_00012              5      8U 0 INZ(0)                               invocation mark     
000784           D  SQL_00013              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000784           D  SQL_00014             10    128A   CCSID(*JOBRUNMIX)                    end of header       
000784           D  SQL_00015            129    137A   CCSID(*JOBRUNMIX)                    PPOSITION           
000784           D  SQL_00016            138    173A   CCSID(*JOBRUNMIX)                    FULLNAME            
000784           D  SQL_00017            174    175A   CCSID(*JOBRUNMIX)                    NUMBER              
000784           D  SQL_00018            176    183D   DATFMT(*MDY/)                        BIRTHDATE           
000784           D  SQL_00019            184    185S 0                                      AGE                 
000784           D  SQL_00020            186    191A   CCSID(*JOBRUNMIX)                    HEIGHT              
000784           D  SQL_00021            192    193P 0                                      WEIGHT              
000784           D  SQL_00022            194    197A   CCSID(*JOBRUNMIX)                    HITSTHROWS          
000796           D                 DS                                                       CLOSE               
000796           D  SQL_00023              1      2B 0 INZ(128)                             length of header    
000796           D  SQL_00024              3      4B 0 INZ(4)                               statement number    
000796           D  SQL_00025              5      8U 0 INZ(0)                               invocation mark     
000796           D  SQL_00026              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000796           D  SQL_00027             10    127A   CCSID(*JOBRUNMIX)                    end of header       
000796           D  SQL_00028            128    128A   CCSID(*JOBRUNMIX)                    end of header       
000805           D                 DS                                                       SELECT              
000805           D  SQL_00029              1      2B 0 INZ(128)                             length of header    
000805           D  SQL_00030              3      4B 0 INZ(5)                               statement number    
000805           D  SQL_00031              5      8U 0 INZ(0)                               invocation mark     
000805           D  SQL_00032              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000805           D  SQL_00033             10    127A   CCSID(*JOBRUNMIX)                    end of header       
000805           D  SQL_00034            129    130P 0                                      TEAMIN              
000805           D  SQL_00035            131    132P 0                                      TEAMTOTAL           
000814           D                 DS                                                       SELECT              
000814           D  SQL_00036              1      2B 0 INZ(128)                             length of header    
000814           D  SQL_00037              3      4B 0 INZ(6)                               statement number    
000814           D  SQL_00038              5      8U 0 INZ(0)                               invocation mark     
000814           D  SQL_00039              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000814           D  SQL_00040             10    127A   CCSID(*JOBRUNMIX)                    end of header       
000814           D  SQL_00041            129    130P 0                                      WESTTOTAL           
000823           D                 DS                                                       SELECT              
000823           D  SQL_00042              1      2B 0 INZ(128)                             length of header    
000823           D  SQL_00043              3      4B 0 INZ(7)                               statement number    
000823           D  SQL_00044              5      8U 0 INZ(0)                               invocation mark     
000823           D  SQL_00045              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000823           D  SQL_00046             10    127A   CCSID(*JOBRUNMIX)                    end of header       
000823           D  SQL_00047            129    130P 0                                      EASTTOTAL           
000641200811       DAYSTOWS = %DIFF(D'2020-10-20':%DATE():*DAYS);                                               
000642200811       TeamIn = %DEC(TeamInP:3:0);                                                                  
000643200811                                                                                                    
000644200811       IF TeamIn > 0  AND TeamIn < 6;                                                               
000645200811         TeamName = TeamArray(TeamIn);                                                              
000646200811         EXSR PrepareFiles;                                                                         
000647200811         WRITE PAGESTART;                                                                           
000648200811         WRITE HEADINGS;                                                                            
000649200811         EXSR GetRow;                                                                               
000650200811         WRITE NEWPOSN;                                                                             
000651200811         PositionH = PPosition;                                                                     
000652200811           DOW NOT EndOfFile;                                                                       
000653200811                                                                                                    
000654200811             IF PositionH = PPosition;                                                              
000655200811               WRITE PLAYERINFO;                                                                    
000656200811             ELSE;                                                                                  
000657200811               PositionH = PPosition;                                                               
000658200811               AVERAGEAGE = TOTALAGE/TOTALPOS;                                                      
000659200811               AVERAGEWT = TOTALWT/TOTALPOS;                                                        
000660200811               WRITE AVERAGEPOS;                                                                    
000661200811               TOTALPOS = 0;                                                                        
000662200811               AVERAGEAGE = 0;                                                                      
000663200811               AVERAGEWT= 0;                                                                        
000664200811               WRITE NEWPOSN;                                                                       
000665200811               WRITE PLAYERINFO;                                                                    
000666200811             ENDIF;                                                                                 
000667200811                                                                                                    
000668200811             TOTALPOS += 1;                                                                         
000669200811             TOTALAGE += AGE;                                                                       
000670200811             TOTALWT += WEIGHT;                                                                     
000671200811                                                                                                    
000672200811             EXSR GetRow;                                                                           
000673200811           ENDDO;                                                                                   
000674200811         WRITE AVERAGEPOS;                                                                          
000675200811         EXSR WRAPUP;                                                                               
000676200811         WRITE LEAGUETOTL;                                                                          
000677200811         *INLR = *ON;                                                                               
000678200811       ELSE;                                                                                        
000679200811         TeamName = 'Invalid Team Number';                                                          
000680200811         WRITE PAGESTART;                                                                           
000681200811         *INLR = *ON;                                                                               
000682200811       ENDIF;                                                                                       
000683200811       RETURN;                                                                                      
000684200811                                                                                                    
000685200811       //**********************************************************************                     
000686200811       // O P E N F I L E S   S U B R O U T I N E                                                   
000687200811       //**********************************************************************                     
000688200811                                                                                                    
000689200811       BEGSR  PrepareFiles;                                                                         
000690200811                                                                                                    
000691200811       // S E T   U P   T H E   T E M P O R A R Y   R E S U L T  S T R U C T U                      
000692200811       //*EXEC SQL                                                                                  
000693200811       //*  DECLARE ALLPLAYERSCURSOR CURSOR                                                         
000694200811       //*    FOR                                                                                   
000695200811       //*                                                                                          
000696200811       //*    SELECT  'Catcher' AS PPOSITION,                                                       
000697200811       //*            TRIM(FNAME) || ' ' || TRIM(LNAME) AS FULLNAME,                                
000698200811       //*            NUMBER,                                                                       
000699200811       //*            BIRTHDATE,                                                                    
000700200811       //*            FLOOR((DAYS(CURRENT DATE) - DAYS(BIRTHDATE))/365.25) AS AG                    
000704200811       //*            HEIGHT,                                                                       
000706200811       //*            WEIGHT,                                                                       
000707200811       //*            HITSTHROWS                                                                    
000708200811       //*    FROM    BASEBALL20/AMERICANLG                                                         
000709200811       //*    WHERE  TEAM = :TeamIn AND POSITION = 'C'                                              
000710200811       //*                                                                                          
000711200811       //*    UNION ALL                                                                             
000712200811       //*                                                                                          
000713200811       //*    SELECT  'DHitter' AS PPOSITION,                                                       
000714200811       //*            TRIM(FNAME) || ' ' || TRIM(LNAME) AS FULLNAME,                                
000715200811       //*            NUMBER,                                                                       
000716200811       //*            BIRTHDATE,                                                                    
000717200811       //*            TIMESTAMPDIFF(256,CHAR(TIMESTAMP(BIRTHDATE)                                   
000718200811       //*            - CURRENT_TIMESTAMP)) AS AGE,                                                 
000719200811       //*            HEIGHT,                                                                       
000720200811       //*            WEIGHT,                                                                       
000721200811       //*            HITSTHROWS                                                                    
000722200811       //*    FROM    BASEBALL20/AMERICANLG                                                         
000723200811       //*    WHERE   TEAM = :TeamIn AND POSITION = 'D'                                             
000724200811       //*                                                                                          
000725200811       //*    UNION ALL                                                                             
000726200811       //*                                                                                          
000727200811       //*    SELECT  'Infield' AS PPOSITION,                                                       
000728200811       //*            TRIM(FNAME) || ' ' || TRIM(LNAME) AS FULLNAME,                                
000729200811       //*            NUMBER,                                                                       
000730200811       //*            BIRTHDATE,                                                                    
000731200811       //*            TIMESTAMPDIFF(256,CHAR(TIMESTAMP(BIRTHDATE)                                   
000732200811       //*            - CURRENT_TIMESTAMP)) AS AGE,                                                 
000733200811       //*            HEIGHT,                                                                       
000734200811       //*            WEIGHT,                                                                       
000735200811       //*            HITSTHROWS                                                                    
000736200811       //*    FROM    BASEBALL20/AMERICANLG                                                         
000737200811       //*    WHERE   TEAM = :TeamIn AND POSITION = 'I'                                             
000738200811       //*                                                                                          
000739200811       //*    UNION ALL                                                                             
000740200811       //*                                                                                          
000741200811       //*    SELECT  'Outfield' AS PPOSITION,                                                      
000742200811       //*            TRIM(FNAME) || ' ' || TRIM(LNAME) AS FULLNAME,                                
000743200811       //*            NUMBER,                                                                       
000744200811       //*            BIRTHDATE,                                                                    
000745200811       //*            TIMESTAMPDIFF(256,CHAR(TIMESTAMP(BIRTHDATE)                                   
000746200811       //*            - CURRENT_TIMESTAMP)) AS AGE,                                                 
000747200811       //*            HEIGHT,                                                                       
000748200811       //*            WEIGHT,                                                                       
000749200811       //*            HITSTHROWS                                                                    
000750200811       //*    FROM    BASEBALL20/AMERICANLG                                                         
000751200811       //*    WHERE   TEAM = :TeamIn AND POSITION = 'O'                                             
000752200811       //*                                                                                          
000753200811       //*    UNION ALL                                                                             
000754200811       //*                                                                                          
000755200811       //*    SELECT  'Pitcher' AS PPOSITION,                                                       
000756200811       //*            TRIM(FNAME) || ' ' || TRIM(LNAME) AS FULLNAME,                                
000757200811       //*            NUMBER,                                                                       
000758200811       //*            BIRTHDATE,                                                                    
000759200811       //*            TIMESTAMPDIFF(256,CHAR(TIMESTAMP(BIRTHDATE)                                   
000760200811       //*            - CURRENT_TIMESTAMP)) AS AGE,                                                 
000761200811       //*            HEIGHT,                                                                       
000762200811       //*            WEIGHT,                                                                       
000763200811       //*            HITSTHROWS                                                                    
000764200811       //*    FROM    BASEBALL20/AMERICANLG                                                         
000765200811       //*    WHERE   TEAM = :TeamIn AND POSITION = 'P'                                             
000766200811       //*                                                                                          
000767200811       //*    FOR READ ONLY;                                                                        
000768200811                                                                                                    
000769200811        // A   T E M P O R A R Y   R E S U L T   T A B L E   I S   C R E A T E D                    
000770200811       //*    EXEC SQL                                                                              
000771200811       //*   OPEN ALLPLAYERSCURSOR;                                                                 
000771                SQL_00005 = TEAMIN;                                                   //SQL               
000771                SQL_00006 = TEAMIN;                                                   //SQL               
000771                SQL_00007 = TEAMIN;                                                   //SQL               
000771                SQL_00008 = TEAMIN;                                                   //SQL               
000771                SQL_00009 = TEAMIN;                                                   //SQL               
000771                SQLER6 = -4;                                                          //SQL               
000771                IF SQL_00002 = 0                                                      //SQL               
000771                OR SQL_00003 <> *LOVAL;                                               //SQL               
000771                SQLROUTE_CALL(                                                        //SQL               
000771                     SQLCA                                                            //SQL               
000771                   : SQL_00000                                                        //SQL               
000771                );                                                                    //SQL               
000771                ELSE;                                                                 //SQL               
000771                SQLOPEN_CALL(                                                         //SQL               
000771                     SQLCA                                                            //SQL               
000771                   : SQL_00000                                                        //SQL               
000771                );                                                                    //SQL               
000771                ENDIF;                                                                //SQL               
000772200811           IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                         
000773200811             ENDOFFILE = *ON;                                                                       
000774200811           ENDIF;                                                                                   
000775200811        ENDSR;                                                                                      
000776200811                                                                                                    
000777200811       //**********************************************************************                     
000778200811       //   G E T     R O W    S U B R O U T I N E                                                  
000779200811       //**********************************************************************                     
000780200811            BEGSR GetRow;                                                                           
000781200811       //*       EXEC SQL                                                                           
000782200811       //*         FETCH NEXT                                                                       
000783200811       //*           FROM ALLPLAYERSCURSOR                                                          
000784200811       //*           INTO: PlayersData;                                                             
000784                SQLER6 = -4;                                                          //SQL 3             
000784                SQLROUTE_CALL(                                                        //SQL               
000784                     SQLCA                                                            //SQL               
000784                   : SQL_00010                                                        //SQL               
000784                );                                                                    //SQL               
000784                IF SQL_00013 = '1';                                                   //SQL               
000784                EVAL PPOSITION = SQL_00015;                                           //SQL               
000784                EVAL FULLNAME = SQL_00016;                                            //SQL               
000784                EVAL NUMBER = SQL_00017;                                              //SQL               
000784                EVAL BIRTHDATE = SQL_00018;                                           //SQL               
000784                EVAL AGE = SQL_00019;                                                 //SQL               
000784                EVAL HEIGHT = SQL_00020;                                              //SQL               
000784                EVAL WEIGHT = SQL_00021;                                              //SQL               
000784                EVAL HITSTHROWS = SQL_00022;                                          //SQL               
000784                ENDIF;                                                                //SQL               
000785200811                                                                                                    
000786200811                  IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                  
000787200811                  ENDOFFILE = *ON;                                                                  
000788200811                ENDIF;                                                                              
000789200811                                                                                                    
000790200811             ENDSR;                                                                                 
000791200811        //**********************************************************************                    
000792200811        // W R A P U P     S U B R O U T I N E                                                      
000793200811        //**********************************************************************                    
000794200811           BEGSR WRAPUP;                                                                            
000795200811       //*      EXEC SQL                                                                            
000796200811       //*        CLOSE ALLPLAYERSCURSOR;                                                           
000796                SQLER6 = 4;                                                           //SQL               
000796                IF SQL_00025 = 0;                                                     //SQL               
000796                SQLROUTE_CALL(                                                        //SQL               
000796                     SQLCA                                                            //SQL               
000796                   : SQL_00023                                                        //SQL               
000796                );                                                                    //SQL               
000796                ELSE;                                                                 //SQL               
000796                SQLCLSE_CALL(                                                         //SQL               
000796                     SQLCA                                                            //SQL               
000796                   : SQL_00023                                                        //SQL               
000796                );                                                                    //SQL               
000796                ENDIF;                                                                //SQL               
000797200811                                                                                                    
000798200811             IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                       
000799200811               ENDOFFILE = *ON;                                                                     
000800200811             ENDIF;                                                                                 
000801200811                                                                                                    
000802200811       //*      EXEC SQL                                                                            
000803200811       //*        SELECT COUNT(*) INTO :TEAMTOTAL                                                   
000804200811       //*          FROM BASEBALL20/AMERICANLG                                                      
000805200811       //*          WHERE TEAM = :TeamIn;                                                           
000805                SQL_00034 = TEAMIN;                                                   //SQL               
000805                SQLER6 = -4;                                                          //SQL 5             
000805                SQLROUTE_CALL(                                                        //SQL               
000805                     SQLCA                                                            //SQL               
000805                   : SQL_00029                                                        //SQL               
000805                );                                                                    //SQL               
000805                IF SQL_00032 = '1';                                                   //SQL               
000805                EVAL TEAMTOTAL = SQL_00035;                                           //SQL               
000805                ENDIF;                                                                //SQL               
000806200811                                                                                                    
000807200811             IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                       
000808200811               TEAMTOTAL = -999;                                                                    
000809200811             ENDIF;                                                                                 
000810200811                                                                                                    
000811200811       //*      EXEC SQL                                                                            
000812200811       //*        SELECT COUNT(*) INTO :WESTTOTAL                                                   
000813200811       //*          FROM BASEBALL20/AMERICANLG                                                      
000814200811       //*          WHERE DIVISION = 'W';                                                           
000814                SQLER6 = -4;                                                          //SQL 6             
000814                SQLROUTE_CALL(                                                        //SQL               
000814                     SQLCA                                                            //SQL               
000814                   : SQL_00036                                                        //SQL               
000814                );                                                                    //SQL               
000814                IF SQL_00039 = '1';                                                   //SQL               
000814                EVAL WESTTOTAL = SQL_00041;                                           //SQL               
000814                ENDIF;                                                                //SQL               
000815200811                                                                                                    
000816200811             IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                       
000817200811               WESTTOTAL = -999;                                                                    
000818200811             ENDIF;                                                                                 
000819200811                                                                                                    
000820200811       //*      EXEC SQL                                                                            
000821200811       //*        SELECT COUNT(*) INTO :EASTTOTAL                                                   
000822200811       //*          FROM BASEBALL20/AMERICANLG                                                      
000823200811       //*          WHERE DIVISION = 'E';                                                           
000823                SQLER6 = -4;                                                          //SQL 7             
000823                SQLROUTE_CALL(                                                        //SQL               
000823                     SQLCA                                                            //SQL               
000823                   : SQL_00042                                                        //SQL               
000823                );                                                                    //SQL               
000823                IF SQL_00045 = '1';                                                   //SQL               
000823                EVAL EASTTOTAL = SQL_00047;                                           //SQL               
000823                ENDIF;                                                                //SQL               
000824200811                                                                                                    
000825200811             IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                       
000826200811               EASTTOTAL = -999;                                                                    
000827200811             ENDIF;                                                                                 
000828200811                                                                                                    
000829200811                                                                                                    
000830200811          ENDSR;                                                                                    
000831200811        //**********************************************************************                    
000832200811        // C O N T R O L   B R E A K   S U B R O U T I N E                                          
000833200811        //**********************************************************************                    
000834200811           BEGSR CBreak;                                                                            
000835200811          ENDSR;                                                                                    
000836200811                                                                                                    
