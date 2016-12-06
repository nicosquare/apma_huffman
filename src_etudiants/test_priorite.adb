with Ada.Integer_Text_IO, Ada.Text_IO;
use Ada.Integer_Text_IO, Ada.Text_IO;
with file_priorite;


procedure Test_Priorite is


	-- implementation d'un ABR d'entiers
	package File_Priorite_Character is
     new File_Priorite(Character,Integer,"=","<");
	use File_Priorite_Character;

	F : File_Prio;

c:Character;
d:Integer;
begin
  --exception when File_Prio_Pleine => Put_Line("file pleine");
  --exception when File_Prio_Vide => Put_Line("File vide");

	F := Cree_File(5);
  Put_Line(Boolean'Image(Est_Vide(F)));
  Insere(F,'a',5);
  Put_Line("a");
  Insere(F,'b',1);
  Put_Line("a");
  Insere(F,'c',3);
  Put_Line("a");
  Insere(F,'d',4);
  Put_Line("a");
  Insere(F,'e',1);
  Put_Line("a");

  Put_Line(Boolean'Image(Est_Pleine(F)));
  Supprime(F,c,d);
  Put_Line(c & Integer'Image(d));
  Supprime(F,c,d);
  Put_Line(c & Integer'Image(d));
  Supprime(F,c,d);
  Put_Line(c & Integer'Image(d));
  Supprime(F,c,d);
  Put_Line(c & Integer'Image(d));
  Supprime(F,c,d);
  Put_Line(c & Integer'Image(d));
  Supprime(F,c,d);
  Put_Line(c & Integer'Image(d));
end Test_Priorite;
