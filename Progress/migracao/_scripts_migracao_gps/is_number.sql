CREATE OR REPLACE function IS_NUMBER(str in varchar2) return varchar2 IS
dummy number;
begin
dummy := TO_NUMBER(str);
return ('TRUE');
Exception WHEN OTHERS then
return ('FALSE');
end; 