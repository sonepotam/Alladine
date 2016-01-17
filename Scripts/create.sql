
CREATE TABLE alFormula (
       Classified           INTEGER NOT NULL,
       Label                VARCHAR2(50) NULL,
       Value                VARCHAR2(2000) NULL,
       PRIMARY KEY (Classified)
);

CREATE UNIQUE INDEX XAK1alFormula ON alFormula
(
       Label                          ASC
);


CREATE TABLE alLibrary (
       Classified           INTEGER NULL,
       Label                VARCHAR2(50) NULL,
       PRIMARY KEY (Classified)
);


CREATE TABLE alLibraryContent (
       idFormula            INTEGER NOT NULL,
       idLibrary            INTEGER NOT NULL,
       PRIMARY KEY (idFormula, idLibrary)
);


CREATE TABLE alReadyTasks (
       Classified           INTEGER NOT NULL,
       CodeDep              CHAR(4) NULL,
       CodeCB               CHAR(3) NULL,
       curDate              DATE NULL,
       Summa1               NUMBER(24,3) NULL,
       Summa2               NUMBER(24,3) NULL,
       Summa3               NUMBER(24,3) NULL,
       Summa4               NUMBER(24,3) NULL,
       Summa5               NUMBER(24,3) NULL,
       Summa6               NUMBER(24,3) NULL,
       Summa7               NUMBER(24,3) NULL,
       Summa8               NUMBER(24,3) NULL,
       Summa9               NUMBER(24,3) NULL,
       Summa10              NUMBER(24,3) NULL,
       Equivalent           NUMBER NULL,
       idTask               NUMBER NOT NULL,
       PRIMARY KEY (Classified)
);


CREATE TABLE alRestInfo (
       CurDate              DATE NOT NULL,
       DepCode              VARCHAR2(4) NOT NULL,
       balAccount           VARCHAR2(20) NOT NULL,
       CurrencyISO          VARCHAR2(3) NOT NULL,
       TypeRest             INTEGER NOT NULL,
       Balance              NUMBER(24,2) NULL,
       OBD                  NUMBER(24,2) NULL,
       OBK                  NUMBER(24,2) NULL,
       PRIMARY KEY (CurDate, DepCode, balAccount, CurrencyISO, 
              TypeRest)
);


CREATE TABLE alTableColumns (
       Classified           NUMBER NULL,
       idTable              NUMBER NULL,
       ColumnName           VARCHAR2(30) NULL,
       Label                VARCHAR2(20) NULL,
       Description          VARCHAR2(250) NULL,
       ColumnType           NUMBER NULL,
       PRIMARY KEY (Classified)
);


CREATE TABLE alTableDesc (
       Classified           NUMBER NULL,
       TableName            VARCHAR2(50) NULL,
       TableDesc            VARCHAR2(250) NULL,
       PRIMARY KEY (Classified)
);


CREATE TABLE alTask (
       Classified           INTEGER NOT NULL,
       idTaskType           integer NOT NULL,
       CreateDate           DATE NULL,
       PRIMARY KEY (Classified)
);


CREATE TABLE alTaskAttr (
       idTaskClass          INTEGER NOT NULL,
       nOrder               NUMBER NULL,
       idClassified         INTEGER NOT NULL,
       Obj                  INTEGER NULL,
       Value                VARCHAR2(20) NULL,
       PRIMARY KEY (idTaskClass, idClassified, nOrder)
);


CREATE TABLE alTaskAttrTypes (
       idClassified         INTEGER NULL,
       Label                VARCHAR2(20) NULL,
       PRIMARY KEY (idClassified)
);


CREATE TABLE alTaskFormulas (
       nOrder               INTEGER NULL,
       idLibrary            INTEGER NOT NULL,
       idTask               INTEGER NOT NULL,
       Classified           INTEGER NULL,
       PRIMARY KEY (Classified)
);


CREATE TABLE alTaskTypes (
       Classified           integer NOT NULL,
       Label                VARCHAR2(50) NULL,
       SQLBlock             VARCHAR2(4000) NULL,
       Enabled              NUMBER(1) NULL,
       idCube               NUMBER NULL,
       PRIMARY KEY (Classified)
);


ALTER TABLE alLibraryContent
       ADD  ( FOREIGN KEY (idLibrary)
                             REFERENCES alLibrary ) ;


ALTER TABLE alLibraryContent
       ADD  ( FOREIGN KEY (idFormula)
                             REFERENCES alFormula ) ;


ALTER TABLE alReadyTasks
       ADD  ( FOREIGN KEY (idTask)
                             REFERENCES alTask ) ;


ALTER TABLE alTableColumns
       ADD  ( FOREIGN KEY (idTable)
                             REFERENCES alTableDesc ) ;


ALTER TABLE alTask
       ADD  ( FOREIGN KEY (idTaskType)
                             REFERENCES alTaskTypes ) ;


ALTER TABLE alTaskAttr
       ADD  ( FOREIGN KEY (idClassified)
                             REFERENCES alTaskAttrTypes ) ;


ALTER TABLE alTaskAttr
       ADD  ( FOREIGN KEY (idTaskClass)
                             REFERENCES alTask ) ;


ALTER TABLE alTaskFormulas
       ADD  ( FOREIGN KEY (idTask)
                             REFERENCES alTask ) ;


ALTER TABLE alTaskFormulas
       ADD  ( FOREIGN KEY (idLibrary)
                             REFERENCES alLibrary ) ;


ALTER TABLE alTaskTypes
       ADD  ( FOREIGN KEY (idCube)
                             REFERENCES alTableDesc ) ;

