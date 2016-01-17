  create table alCredSvodInfo(
  curDate     DATE,
  depCode     varchar2( 4),
  balAccount  varchar2( 20),
  currencyISO varchar2( 3),
  filType     varchar2( 5),
  filIdent    varchar2( 6),
  risk        number( 2),
  Schet       varchar2( 20),
  obd         number( 24,2),
  obk         number( 24,2),
  obdrub      number( 24,2),
  obkrub      number( 24,2),
  rest        number( 24,2),
  restrub     number( 24,2),
  taxid       varchar2( 12),
  kreddog     varchar2( 15),
  primary key ( curDate, filIdent, filType, depCode, balaccount, currencyISO))

  create global temporary table gtt_alCredSvodInfo(
  curDate     DATE,
  depCode     varchar2( 4),
  balAccount  varchar2( 20),
  currencyISO varchar2( 3),
  filType     varchar2( 5),
  filIdent    varchar2( 6),
  risk        number( 2),
  Schet       varchar2( 20),
  taxid       varchar2( 12),
  kreddog     varchar2( 15))
  on commit delete rows;

alter table gtt_alCredSvodInfo add(
summa1  number( 24, 2),
summa2  number( 24, 2),
summa3  number( 24, 2),
summa4  number( 24, 2),
summa5  number( 24, 2),
summa6  number( 24, 2),
summa7  number( 24, 2),
summa8  number( 24, 2),
summa9  number( 24, 2),
summa10 number( 24, 2),
summa11 number( 24, 2),
summa12 number( 24, 2),
summa13  number( 24, 2),
summa14  number( 24, 2),
summa15  number( 24, 2),
summa16  number( 24, 2),
summa17  number( 24, 2),
summa18  number( 24, 2),
summa19  number( 24, 2),
summa20 number( 24, 2),
summa21  number( 24, 2),
summa22  number( 24, 2),
summa23  number( 24, 2),
summa24  number( 24, 2),
summa25  number( 24, 2),
summa26  number( 24, 2),
summa27  number( 24, 2),
summa28  number( 24, 2),
summa29  number( 24, 2),
summa30 number( 24, 2));


  
create public synonym alCredSvodInfo for od.alCredSvodInfo;

grant select on alCredSvodInfo to olap_user;

grant all on gtt_alCredSvodInfo to olap_user;

create public synonym gtt_alCredSvodInfo for od.gtt_alCredSvodInfo;

