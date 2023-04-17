000100200803         Ctl-Opt NoMain;
000101200803
000102200803       /COPY LAB10,DAYPROTO
000103200803
000104200803       Dcl-Proc DayNumName  EXPORT;
000105200803         Dcl-Pi *N CHAR(9) ;
000106200803           Number  Packed(1);
000107200803         End-PI;
000108200803
000112200803         DCL-DS DayData;
000113200803           *n Char(9) Inz('Monday');
000114200803           *n Char(9) Inz('Tuesday');
000115200803           *n Char(9) Inz('Wednesday');
000116200803           *n Char(9) Inz('Thursday');
000117200803           *n Char(9) Inz('Friday');
000118200803           *n Char(9) Inz('Saturday');
000119200803           *n Char(9) Inz('Sunday');
000120200803
000121200803           DayArray Char(9) Dim(7) Pos(1);
000122200803
000123200803         END-DS;
000124200803
000125200803         Return DayArray(Number);
000126200803
000127200803         End-Proc;
000128200803
000129200803
000130200803
