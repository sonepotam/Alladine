create or replace trigger alFormula_OnNewRecord
before insert on alFormula
for each row
begin
  if :new.Classified is null or :new.Classified=0 then
    select alClassified.nextval into :new.Classified from dual;
  end if;
end;
/


create or replace trigger alLibrary_OnNewRecord
before insert on alLibrary
for each row
begin
  if :new.Classified is null or :new.Classified=0 then
    select alClassified.nextval into :new.Classified from dual;
  end if;
end;
/


create or replace trigger alTaskTypes_OnNewRecord
before insert on alTaskTypes
for each row
begin
  if :new.Classified is null or :new.Classified=0 then
    select alClassified.nextval into :new.Classified from dual;
  end if;
end;
/


create or replace trigger alTaskFormulas_OnNewRecord
before insert on alTaskFormulas
for each row
begin
  if :new.Classified is null or :new.Classified=0 then
    select alClassified.nextval into :new.Classified from dual;
  end if;
end;
/


create or replace trigger alTask_OnNewRecord
before insert on alTask
for each row
begin
  if :new.Classified is null or :new.Classified=0 then
    select alClassified.nextval into :new.Classified from dual;
  end if;
end;
/


create or replace trigger alReadyTasks_OnNewRecord
before insert on alReadyTasks
for each row
begin
  if :new.Classified is null or :new.Classified=0 then
    select alClassified.nextval into :new.Classified from dual;
  end if;
end;
/


create or replace trigger alTableDesc_OnNewRecord
before insert on alTableDesc
for each row
begin
  if :new.Classified is null or :new.Classified=0 then
    select alClassified.nextval into :new.Classified from dual;
  end if;
end;
/


create or replace trigger alTablecolumns_OnNewRecord
before insert on altablecolumns
for each row
begin
  if :new.Classified is null or :new.Classified=0 then
    select alClassified.nextval into :new.Classified from dual;
  end if;
end;
/


create or replace trigger alTaskAttrTypes_OnNewRecord
before insert on alTaskAttrTypes
for each row
begin
  if :new.idClassified is null or :new.idClassified=0 then
    select alClassified.nextval into :new.idClassified from dual;
  end if;
end;
/
