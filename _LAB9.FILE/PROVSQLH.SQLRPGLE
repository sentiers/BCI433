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
006600200726           EXEC SQL
006601200726             DECLARE ALLPROVCURSOR CURSOR
006602200726               FOR
006603200726
006604200726               SELECT  CUSTID, TRIM(FNAME) || ' ' || TRIM(LNAME),
006700200726                       CITY, PURCHASE, PDATE,
006800200726                       'Ontario' AS PROVINCE
006900200726                  FROM    BCI433LIB/ONTARIO
007000200726                  WHERE   PURCHASE > :LowLimit
007100190315
007200200726               UNION ALL
007300190315
007301200726               SELECT  CUSTID, TRIM(FNAME) || ' ' || TRIM(LNAME),
007302200726                       CITY, PURCHASE, PDATE,
007303200726                       'Quebec' AS PROVINCE
007304200726                  FROM BCI433LIB/QUEBEC
007305200726                  WHERE PURCHASE > :LowLimit
007306200726
007400200726               UNION ALL
007401200726
007402200726               SELECT CUSTID, TRIM(FNAME) || ' ' || TRIM(LNAME),
007403200726                      CITY, PURCHASE, PDATE,
007500200726                      'Manitoba' AS PROVINCE
007501200726                  FROM BCI433LIB/MANITOBA
007502200726                  WHERE PURCHASE > :LowLimit
007503200726
007600200726               FOR READ ONLY;
007601200726
008800100309        // A   T E M P O R A R Y   R E S U L T   T A B L E   I S   C R E A T E D
008900100309
009000200726           EXEC SQL
009100200726                OPEN ALLPROVCURSOR;
009200190315
009300200726                IF SQLCODE <> 0 OR SQLWN0 = 'W';
009301200726                  ENDOFFILE = *ON;
009302200726                ENDIF;
009600100309            ENDSR;
009700100309        //**********************************************************************
009800100309        //   G E T     R O W    S U B R O U T I N E
009900100309        //**********************************************************************
010000100309            BEGSR     GETROW;
010100200726              EXEC SQL
010101200726                FETCH NEXT
010102200726                FROM ALLPROVCURSOR
010103200726                INTO :CUSTOMERRECORD;
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
011503200726             EXEC SQL
011504200726               CLOSE ALLPROVCURSOR;
011505200726
011506200726               IF SQLCODE <> 0 OR SQLWN0 = 'W';
011507200726                  ENDOFFILE = *ON;
011508200726                ENDIF;
011509200726
011510200726             EXEC SQL
011511200726               SELECT COUNT(*) INTO :ONTTOTAL
011512200726                 FROM  BCI433LIB/ONTARIO
011513200726                 WHERE PURCHASE <= :LOWLIMIT;
011514200726
011515200726              IF SQLCODE <> 0 OR SQLWN0 = 'W';
011516200726                  ONTTOTAL = -999;
011517200726              ENDIF;
011518200726
011519200726             EXEC SQL
011520200726               SELECT COUNT(*) INTO :QUETOTAL
011521200726                 FROM BCI433LIB/QUEBEC
011522200726                 WHERE PURCHASE <= :LOWLIMIT;
011523200726
011524200726              IF SQLCODE <> 0 OR SQLWN0 = 'W';
011525200726                  QUETOTAL = -999;
011526200726              ENDIF;
011527200726
011528200726             EXEC SQL
011529200726               SELECT COUNT(*) INTO :MANTOTAL
011530200726                 FROM BCI433LIB/MANITOBA
011531200726                 WHERE PURCHASE <= :LOWLIMIT;
011532200726
011533200726              IF SQLCODE <> 0 OR SQLWN0 = 'W';
011534200726                  MANTOTAL = -999;
011535200726              ENDIF;
011536200726
011600100309          ENDSR;
011700190315
011800190315
011900200726
