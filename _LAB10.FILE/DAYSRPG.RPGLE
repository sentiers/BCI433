000100200801          DCL-f DayDsp Workstn;
000200200726          Dcl-PI  Main  extPgm('DAYSRPG');
000300200726             Solution   char(15);
000400200726         End-PI;
000401200801
000500200801       /COPY LAB10,DAYPROTO
000501200801
000700200402           EXFMT INPUT;
000800170918           DOW NOT(*IN03);
000900200402              DayName = DayNumName(DayIn);
001000190327              *in99 = *on;
001100200402               WRITE INPUT;
001200200402               EXFMT OUTPUT;
001300190327              *in99 = *off;
001400170918               IF *IN03 = '0';
001500200402                 DayIn = 0;
001600200402                 EXFMT INPUT ;
001700170918               ENDIF;
001800170918            ENDDO;
001900170918            *INLR = *ON;
002000170918            RETURN;
002100170918
002200200801
