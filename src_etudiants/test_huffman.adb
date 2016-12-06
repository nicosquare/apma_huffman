with Ada.Integer_Text_IO, Ada.Text_IO;
use Ada.Integer_Text_IO, Ada.Text_IO;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with huffman; use huffman;



procedure Test_Huffman is
  A:Arbre_Huffman;
  Fichier : Ada.Streams.Stream_IO.File_Type;
  Flux : Ada.Streams.Stream_IO.Stream_Access;
  i:Integer;
begin
A:=Cree_Huffman("mini.txt");
Affiche(A);

Create(Fichier, Out_File,"prout.txt");
Flux := Stream(Fichier);
i:=Ecrit_Huffman(A,Flux);

Close(Fichier);




Close(Fichier);

end Test_Huffman;
