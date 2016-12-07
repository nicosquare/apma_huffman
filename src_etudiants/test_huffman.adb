with Ada.Integer_Text_IO, Ada.Text_IO;
use Ada.Integer_Text_IO, Ada.Text_IO;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with huffman; use huffman;
with dico; use dico;



procedure Test_Huffman is
  A:Arbre_Huffman;
  Fichier : Ada.Streams.Stream_IO.File_Type;
  Flux : Ada.Streams.Stream_IO.Stream_Access;
  i:Integer;
  D: Dico_Caracteres;
begin
A:=Cree_Huffman("longtemps.txt");
Put_Line("premier Arbre");
Affiche(A);
D:=Genere_Dictionnaire(A);
--Affiche(D);

Create(Fichier, Out_File,"test_hoffman.txt");
Flux := Stream(Fichier);
i:=Ecrit_Huffman(A,Flux);

Close(Fichier);

Open(Fichier, In_File, "test_hoffman.txt");
Flux := Stream(Fichier);
Put_Line("Deuxieme Arbre");
A:=Lit_Huffman(Flux);


Close(Fichier);
Affiche(A);
D:=Genere_Dictionnaire(A);
--Affiche(D);
end Test_Huffman;
