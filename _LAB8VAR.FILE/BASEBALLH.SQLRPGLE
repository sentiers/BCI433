000100191105       //***********************************************************************
000200200810       //* Name: Hyunji Cho
000300200811       //* #128065182
000400200721       //*
000500191105       //***********************************************************************
000600200811
000603200811       DCL-F BBALLRPT PRINTER OFLIND(*IN01);
000604200811
000605200811       DCL-S PositionH  CHAR(10);
000606200811       DCL-S TotalAge   PACKED(5:0);
000607200811       DCL-S TotalWt    PACKED(5:0);
000608200811
000610200811       DCL-S EndOfFile  IND;
000611200811
000612200811       DCL-S TeamIn     PACKED(3:0);
000613200811
000614200811       DCL-PI Main EXTPGM('BASEBALLH');
000615200811         TeamNum CHAR(3);
000616200811       END-PI;
000617200811
000618200811       DCL-DS PlayerRecord;
000619200811         PPosition CHAR(9);
000620200811         FullName CHAR(36);
000621200811         Number CHAR(2);
000622200811         BirthDate DATE;
000623200811         AGE ZONED(2);
000624200811         Height CHAR(6);
000625200811         Weight PACKED(3:0);
000626200811         HitsThrows CHAR(4);
000627200811       END-DS PlayerRecord;
000628200811
000629200811       DCL-DS TeamData;
000630200811         *N CHAR(20) INZ('Boston Red Sox');
000631200811         *N CHAR(20) INZ('New York Yankees');
000632200811         *N CHAR(20) INZ('Toronto Blue Jays');
000633200811         *N CHAR(20) INZ('Baltimore Orioles');
000634200811         *N CHAR(20) INZ('Tampa Bay Rays');
000636200811         TeamArray CHAR(20) DIM(5) POS(1);
000638200811       END-DS TeamData;
000639200811
000640200811      //*************************************************************************
000641200811      //                   ***   M A I N   R O U T I N E   ***
000642200811      //*************************************************************************
000643200811       DAYSTOWS = %DIFF(D'2020-10-20':%DATE():*DAYS);
000644200811       TeamIn = %DEC(TeamNum:3:0);
000645200811
000646200811       IF TeamIn > 0  AND TeamIn < 6;
000648200811         TeamName = TeamArray(TeamIn);
000649200811
000650200811         EXSR PrepareFiles;
000651200811         WRITE PAGESTART;
000652200811         WRITE HEADINGS;
000653200811
000654200811         EXSR GetRow;
000656200811         WRITE NEWPOSN;
000657200811         PositionH = PPosition;
000658200811
000659200811           DOW NOT EndOfFile;
000660200811
000661200811             IF PositionH = PPosition;
000662200811               WRITE PLAYERINFO;
000663200811
000664200811             ELSE;
000666200811               AVERAGEAGE = TOTALAGE/TOTALPOS;
000667200811               AVERAGEWT = TOTALWT/TOTALPOS;
000668200811               WRITE AVERAGEPOS;
000669200811
000670200811               TOTALPOS = 0;
000671200811               TOTALAGE = 0;
000672200811               TOTALWT = 0;
000673200811
000674200811               PositionH = PPosition;
000675200811               WRITE NEWPOSN;
000676200811               WRITE PLAYERINFO;
000677200811             ENDIF;
000678200811
000679200811             TOTALPOS += 1;
000680200811             TOTALAGE += AGE;
000681200811             TOTALWT += WEIGHT;
000682200811
000683200811             EXSR GetRow;
000685200811           ENDDO;
000686200811
000687200811         WRITE AVERAGEPOS;
000688200811
000689200811         EXSR WRAPUP;
000691200811         WRITE LEAGUETOTL;
000692200811
000693200811         *INLR = *ON;
000694200811
000695200811       ELSE;
000696200811         TeamName = 'Invalid Team Number';
000697200811         WRITE PAGESTART;
000698200811
000699200811         *INLR = *ON;
000700200811       ENDIF;
000701200811
000702200811       RETURN;
000703200811
000704200811       //**********************************************************************
000705200811       // O P E N F I L E S   S U B R O U T I N E
000706200811       //**********************************************************************
000707200811
000708200811       BEGSR  PrepareFiles;
000709200811
000710200811       // S E T   U P   T H E   T E M P O R A R Y   R E S U L T  S T R U C T U
000711200811       EXEC SQL
000712200811         DECLARE ALLBBCURSOR CURSOR
000713200811           FOR
000714200811
000715200811           SELECT  'Catcher' AS PPOSITION,
000716200811                   TRIM(FNAME) || ' ' || TRIM(LNAME) AS FULLNAME,
000717200811                   NUMBER,
000718200811                   BIRTHDATE,
000719200811                   FLOOR((DAYS(CURRENT DATE) - DAYS(BIRTHDATE))/365.25) AS AGE,
000720200811                   HEIGHT,
000721200811                   WEIGHT,
000722200811                   HITSTHROWS
000723200811             FROM  BASEBALL20/AMERICANLG
000724200811             WHERE TEAM = :TeamIn AND POSITION = 'C'
000725200811
000726200811           UNION ALL
000727200811
000728200811           SELECT  'DHitter' AS PPOSITION,
000729200811                   TRIM(FNAME) || ' ' || TRIM(LNAME) AS FULLNAME,
000730200811                   NUMBER,
000731200811                   BIRTHDATE,
000732200811                   FLOOR((DAYS(CURRENT DATE) - DAYS(BIRTHDATE))/365.25) AS AGE,
000733200811                   HEIGHT,
000734200811                   WEIGHT,
000735200811                   HITSTHROWS
000736200811             FROM  BASEBALL20/AMERICANLG
000737200811             WHERE TEAM = :TeamIn AND POSITION = 'D'
000738200811
000739200811           UNION ALL
000740200811
000741200811           SELECT  'Infield' AS PPOSITION,
000742200811                   TRIM(FNAME) || ' ' || TRIM(LNAME) AS FULLNAME,
000743200811                   NUMBER,
000744200811                   BIRTHDATE,
000745200811                   FLOOR((DAYS(CURRENT DATE) - DAYS(BIRTHDATE))/365.25) AS AGE,
000746200811                   HEIGHT,
000747200811                   WEIGHT,
000748200811                   HITSTHROWS
000749200811             FROM  BASEBALL20/AMERICANLG
000750200811             WHERE TEAM = :TeamIn AND POSITION = 'I'
000751200811
000752200811           UNION ALL
000753200811
000754200811           SELECT  'Outfield' AS PPOSITION,
000755200811                   TRIM(FNAME) || ' ' || TRIM(LNAME) AS FULLNAME,
000756200811                   NUMBER,
000757200811                   BIRTHDATE,
000758200811                   FLOOR((DAYS(CURRENT DATE) - DAYS(BIRTHDATE))/365.25) AS AGE,
000759200811                   HEIGHT,
000760200811                   WEIGHT,
000761200811                   HITSTHROWS
000762200811             FROM  BASEBALL20/AMERICANLG
000763200811             WHERE TEAM = :TeamIn AND POSITION = 'O'
000764200811
000765200811           UNION ALL
000766200811
000767200811           SELECT  'Pitcher' AS PPOSITION,
000768200811                   TRIM(FNAME) || ' ' || TRIM(LNAME) AS FULLNAME,
000769200811                   NUMBER,
000770200811                   BIRTHDATE,
000771200811                   FLOOR((DAYS(CURRENT DATE) - DAYS(BIRTHDATE))/365.25) AS AGE,
000772200811                   HEIGHT,
000773200811                   WEIGHT,
000774200811                   HITSTHROWS
000775200811             FROM  BASEBALL20/AMERICANLG
000776200811             WHERE TEAM = :TeamIn AND POSITION = 'P'
000777200811
000778200811           FOR READ ONLY;
000779200811
000780200811
000781200811        // A   T E M P O R A R Y   R E S U L T   T A B L E   I S   C R E A T E D
000782200811           EXEC SQL
000783200811             OPEN ALLBBCURSOR;
000784200811
000785200811             IF SQLCODE <> 0 OR SQLWN0 = 'W';
000786200811               ENDOFFILE = *ON;
000787200811             ENDIF;
000788200811
000789200811        ENDSR;
000790200811
000791200811       //**********************************************************************
000792200811       //   G E T     R O W    S U B R O U T I N E
000793200811       //**********************************************************************
000794200811            BEGSR GetRow;
000795200811              EXEC SQL
000796200811                FETCH NEXT
000797200811                  FROM ALLBBCURSOR
000798200811                  INTO: PlayerRecord;
000799200811
000800200811                  IF SQLCODE <> 0 OR SQLWN0 = 'W';
000801200811                  ENDOFFILE = *ON;
000802200811                ENDIF;
000803200811
000804200811             ENDSR;
000805200811        //**********************************************************************
000806200811        // W R A P U P     S U B R O U T I N E
000807200811        //**********************************************************************
000808200811           BEGSR WRAPUP;
000809200811             EXEC SQL
000810200811               CLOSE ALLBBCURSOR;
000811200811
000812200811             IF SQLCODE <> 0 OR SQLWN0 = 'W';
000813200811               ENDOFFILE = *ON;
000814200811             ENDIF;
000815200811
000816200811             EXEC SQL
000817200811               SELECT COUNT(*) INTO :TEAMTOTAL
000818200811                 FROM  BASEBALL20/AMERICANLG
000819200811                 WHERE TEAM = :TeamIn;
000820200811
000821200811             IF SQLCODE <> 0 OR SQLWN0 = 'W';
000822200811               TEAMTOTAL = -999;
000823200811             ENDIF;
000824200811
000825200811             EXEC SQL
000826200811               SELECT COUNT(*) INTO :WESTTOTAL
000827200811                 FROM  BASEBALL20/AMERICANLG
000828200811                 WHERE DIVISION = 'W';
000829200811
000830200811             IF SQLCODE <> 0 OR SQLWN0 = 'W';
000831200811               WESTTOTAL = -999;
000832200811             ENDIF;
000833200811
000834200811             EXEC SQL
000835200811               SELECT COUNT(*) INTO :EASTTOTAL
000836200811                 FROM  BASEBALL20/AMERICANLG
000837200811                 WHERE DIVISION = 'E';
000838200811
000839200811             IF SQLCODE <> 0 OR SQLWN0 = 'W';
000840200811               EASTTOTAL = -999;
000841200811             ENDIF;
000842200811
000844200811          ENDSR;
000845200811
000846200811        //**********************************************************************
000847200811        // C O N T R O L   B R E A K   S U B R O U T I N E
000848200811        //**********************************************************************
000849200811           BEGSR CBreak;
000850200811
000852200811        // A control break occurs when the value of a certain field changes
000853200811        // from one record to the next as a file is being read sequentially
000854200811
000855200811
000856200811          ENDSR;
000857200811
