-- Create database link 
create public database link UNICOO_MIGRA
  connect to PRODUCAO identified by ebad
  using 'UNICOO_MIGRA';
