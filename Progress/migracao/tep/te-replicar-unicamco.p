/*Objetivo: ler uma UNICAMCO previamente criada pela tela do sistema e replicar para os demais codigos de unidade necessarios.*/
DEF BUFFER b-unicamco FOR unicamco.
ETIME(TRUE).

FIND FIRST unicamco NO-LOCK
     WHERE unicamco.cd-unidade = 37
       AND unicamco.dt-limite  >= TODAY.

/*
run replicar-unicamco(039).
run replicar-unicamco(650).
run replicar-unicamco(546).
run replicar-unicamco(375).
run replicar-unicamco(803).
run replicar-unicamco(601).
run replicar-unicamco(374).
run replicar-unicamco(769).
run replicar-unicamco(410).
run replicar-unicamco(837).
run replicar-unicamco(805).
run replicar-unicamco(705).
run replicar-unicamco(801).
*/
/*
run replicar-unicamco(940).
run replicar-unicamco(554).
run replicar-unicamco(565).
run replicar-unicamco(070).
run replicar-unicamco(480).
run replicar-unicamco(372).
run replicar-unicamco(569).
run replicar-unicamco(847).
run replicar-unicamco(385).
run replicar-unicamco(623).
run replicar-unicamco(771).
run replicar-unicamco(896).
run replicar-unicamco(946).
run replicar-unicamco(525).
run replicar-unicamco(850).
run replicar-unicamco(494).
*/
/*
run replicar-unicamco(802).
run replicar-unicamco(900).
run replicar-unicamco(794).
*/
/*
run replicar-unicamco(083).
run replicar-unicamco(373).
run replicar-unicamco(415).
run replicar-unicamco(556).
run replicar-unicamco(679).
run replicar-unicamco(945).
run replicar-unicamco(380).
run replicar-unicamco(458).
run replicar-unicamco(482).
run replicar-unicamco(506).
run replicar-unicamco(767).
run replicar-unicamco(888).
run replicar-unicamco(895).
run replicar-unicamco(944).
run replicar-unicamco(952).
run replicar-unicamco(954).
run replicar-unicamco(351).
run replicar-unicamco(392).
run replicar-unicamco(406).
run replicar-unicamco(463).
run replicar-unicamco(597).
run replicar-unicamco(658).
run replicar-unicamco(743).
run replicar-unicamco(059).
run replicar-unicamco(366).
run replicar-unicamco(585).
run replicar-unicamco(652).
run replicar-unicamco(711).
run replicar-unicamco(731).
run replicar-unicamco(784).
run replicar-unicamco(933).
run replicar-unicamco(349).
run replicar-unicamco(571).
run replicar-unicamco(707).
run replicar-unicamco(726).
run replicar-unicamco(785).
run replicar-unicamco(806).
run replicar-unicamco(840).
run replicar-unicamco(993).
run replicar-unicamco(046).
run replicar-unicamco(365).
run replicar-unicamco(412).
run replicar-unicamco(461).
run replicar-unicamco(464).
run replicar-unicamco(498).
run replicar-unicamco(522).
run replicar-unicamco(541).
run replicar-unicamco(596).
run replicar-unicamco(910).
run replicar-unicamco(918).
run replicar-unicamco(467).
run replicar-unicamco(478).
run replicar-unicamco(517).
run replicar-unicamco(653).
run replicar-unicamco(745).
run replicar-unicamco(750).
run replicar-unicamco(823).
run replicar-unicamco(901).
run replicar-unicamco(000).
run replicar-unicamco(462).
run replicar-unicamco(470).
run replicar-unicamco(544).
run replicar-unicamco(561).
run replicar-unicamco(685).
run replicar-unicamco(760).
run replicar-unicamco(869).
*/

run replicar-unicamco(546).
run replicar-unicamco(940).
run replicar-unicamco(650).
run replicar-unicamco(601).
run replicar-unicamco(000).
run replicar-unicamco(802).
run replicar-unicamco(039).
run replicar-unicamco(743).
run replicar-unicamco(372).
run replicar-unicamco(794).
run replicar-unicamco(952).
run replicar-unicamco(375).
run replicar-unicamco(896).
run replicar-unicamco(373).
run replicar-unicamco(869).
run replicar-unicamco(679).
run replicar-unicamco(918).
run replicar-unicamco(498).
run replicar-unicamco(850).
run replicar-unicamco(803).
run replicar-unicamco(478).
run replicar-unicamco(366).
run replicar-unicamco(652).
run replicar-unicamco(556).
run replicar-unicamco(726).
run replicar-unicamco(561).
run replicar-unicamco(392).
run replicar-unicamco(901).
run replicar-unicamco(900).
run replicar-unicamco(767).
run replicar-unicamco(506).
run replicar-unicamco(597).
run replicar-unicamco(569).
run replicar-unicamco(945).
run replicar-unicamco(658).
run replicar-unicamco(785).
run replicar-unicamco(470).
run replicar-unicamco(745).
run replicar-unicamco(760).
run replicar-unicamco(554).
run replicar-unicamco(461).
run replicar-unicamco(946).
run replicar-unicamco(565).
run replicar-unicamco(458).
run replicar-unicamco(954).
run replicar-unicamco(380).
run replicar-unicamco(467).
run replicar-unicamco(685).
run replicar-unicamco(462).
run replicar-unicamco(731).
run replicar-unicamco(482).
run replicar-unicamco(046).
run replicar-unicamco(888).
run replicar-unicamco(771).
run replicar-unicamco(415).
run replicar-unicamco(463).
run replicar-unicamco(571).
run replicar-unicamco(823).
run replicar-unicamco(653).

MESSAGE "Processo concluido." SKIP ETIME / 1000 "segundos"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

PROCEDURE replicar-unicamco:
  DEF INPUT PARAM cd-unidade-par AS INT NO-UNDO.
  
  CREATE b-unicamco.
  BUFFER-COPY unicamco EXCEPT cd-unidade TO b-unicamco.
  ASSIGN b-unicamco.cd-unidade = cd-unidade-par.
END PROCEDURE.
