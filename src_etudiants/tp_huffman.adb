with Ada.Text_IO, Ada.Integer_Text_Io, Code , huffman, dico, Ada.Streams.Stream_IO, Ada.IO_Exceptions, Ada.Command_line;
use Ada.Text_IO, Ada.Integer_Text_Io, Code , huffman, dico, Ada.Streams.Stream_IO, Ada.Command_line;
procedure tp_huffman is

------------------------------------------------------------------------------
-- COMPRESSION
------------------------------------------------------------------------------

	procedure Open_Fichier(Fichier :out Ada.Streams.Stream_IO.File_Type; Flux: out Stream_Access; Nom_Fichier: in String ) is
    begin
        Open(Fichier,In_File,Nom_Fichier);
        Flux := Stream(Fichier);
    end Open_fichier;

	procedure Compresse(Nom_Fichier_In, Nom_Fichier_Out : in String) is
	Fichier_In : Ada.Streams.Stream_IO.File_Type;
	Fichier_Out : Ada.Streams.Stream_IO.File_Type;
	Flux_In: Stream_Access;
	Flux_Out: Stream_Access;
	H : Arbre_Huffman;
	D : Dico_Caracteres;
    C : Character;
    Cod : Code_Binaire;
    I : Integer;
	begin

		Create(Fichier_Out,Out_File,Nom_Fichier_Out);
        Flux_Out := Stream(Fichier_Out);
		
		H := Cree_Huffman(Nom_Fichier_In);		
		D := Genere_Dictionnaire(H);

		I := Ecrit_Huffman(H,Flux_Out);

		Affiche(D);

		Open_Fichier(Fichier_In,Flux_In,Nom_Fichier_In);

		while not End_Of_File(Fichier_In) loop
            Character'Read(Flux_In,C);
            -- ??
        end loop;

        Close(Fichier_In);
        Close(Fichier_Out);

		return;
	end Compresse;



------------------------------------------------------------------------------
-- DECOMPRESSION
------------------------------------------------------------------------------

	procedure Decompresse(Nom_Fichier_In, Nom_Fichier_Out : in String) is
	
	Fichier_In : Ada.Streams.Stream_IO.File_Type;
	Fichier_Out : Ada.Streams.Stream_IO.File_Type;
	Flux_In: Stream_Access;
	Flux_Out: Stream_Access;
	H : Arbre_Huffman;
	D : Dico_Caracteres;
    C : Character;
    Cod : Code_Binaire;
    O : Octet;
	begin
		
		Create(Fichier_Out,Out_File,Nom_Fichier_Out);
		Flux_Out := Stream(Fichier_Out);

		Open_Fichier(Fichier_In,Flux_In,Nom_Fichier_In);

		H := Lit_Huffman(Flux_In);
		D := Genere_Dictionnaire(H);

		while not End_Of_File(Fichier_In) loop
            Octet'Read(Flux_In,O);
        	-- ??    
        end loop;

		return;
	end Decompresse;


------------------------------------------------------------------------------
-- PG PRINCIPAL
------------------------------------------------------------------------------

begin

	if (Argument_Count /= 3) then
		Put_Line("utilisation:");
		Put_Line("  compression : ./huffman -c fichier.txt fichier.comp");
		Put_Line("  decompression : ./huffman -d fichier.comp fichier.comp.txt");
		Set_Exit_Status(Failure);
		return;
	end if;

	if (Argument(1) = "-c") then
		Compresse(Argument(2), Argument(3));
	else
		Decompresse(Argument(2), Argument(3));
	end if;

	Set_Exit_Status(Success);

end tp_huffman;

