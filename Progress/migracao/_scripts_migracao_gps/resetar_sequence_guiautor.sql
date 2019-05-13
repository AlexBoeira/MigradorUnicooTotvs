connect gp;
drop sequence seq_guiautor;
Create SEQUENCE seq_guiautor minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
grant all on seq_guiautor to unicoogps;
