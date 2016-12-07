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
    Cod : Code_Binaire := Cree_Code;
    I : Integer;
	begin

		-- Initialiser le flux de sortie
		Create(Fichier_Out,Out_File,Nom_Fichier_Out);
        Flux_Out := Stream(Fichier_Out);
		-- Creer arbre Huffman à partir de fichier
		H := Cree_Huffman(Nom_Fichier_In);		
		-- Creer Dico à partir d'arbre Huffman
		D := Genere_Dictionnaire(H);
		-- Ecrite l'arbre Huffman sur le fichier de sortie
		I := Ecrit_Huffman(H,Flux_Out);

		Open_Fichier(Fichier_In,Flux_In,Nom_Fichier_In);
		-- Commencer à lire le text en le transformant en Octets
		while not End_Of_File(Fichier_In) loop
            -- Lire caractère par caractêre
            Character'Read(Flux_In,C);
            -- Get code selon le Dico
            Ajoute_Apres(Get_Code(C,D),Cod);
            -- Transformer le code à Octet et l'écrire
            Ecrire_Binaire(Cod,Flux_Out);
        end loop;
        for j in Integer range 1..7 loop
            Ajoute_Apres(ZERO,Cod);
        end loop;
        Ecrire_Binaire(Cod,Flux_Out);
        Close(Fichier_In);
        Close(Fichier_Out);

		return;
	end Compresse;



------------------------------------------------------------------------------
-- DECOMPRESSION
------------------------------------------------------------------------------

	procedure Decompresse(Nom_Fichier_In, Nom_Fichier_Out : in String) is
	
		procedure Ecrire_Text(C: in out Code_Binaire; D: in Dico_Caracteres; Flux: in out Stream_Access) is
            Tmp : Code_Binaire;
            B : Bit;
            L : Integer :=  Longueur(C);
            Char : Character;
            Nb_Character : Integer := Nb_Total_Caracteres(D);
        begin
            for i in Integer range 1..L loop
                Supprimer_Avant(B,C);
                Ajoute_Apres(B,Tmp);
                Char := Get_Char(D,Tmp);
                if Char /= Character'Val(16#00#) then
                    Character'Write(Flux,Char);
                    Nb_Character := Nb_Character - 1;
                    if Nb_Character = 0 then 
                    	return; 
                	end if;
                    Tmp := Cree_Code;
                end if;
            end loop;
            C := Tmp;
        end Ecrire_Text;

	Fichier_In : Ada.Streams.Stream_IO.File_Type;
	Fichier_Out : Ada.Streams.Stream_IO.File_Type;
	Flux_In: Stream_Access;
	Flux_Out: Stream_Access;
	H : Arbre_Huffman;
	D : Dico_Caracteres;
    Cod : Code_Binaire := Cree_Code;
    O : Octet;
	begin
		
		Create(Fichier_Out,Out_File,Nom_Fichier_Out);
		Flux_Out := Stream(Fichier_Out);

		Open_Fichier(Fichier_In,Flux_In,Nom_Fichier_In);

		H := Lit_Huffman(Flux_In);
		D := Genere_Dictionnaire(H);

		while not End_Of_File(Fichier_In) loop
            Octet'Read(Flux_In,O);
        	Inserer_Octet_Queue(Cod,O);
        	Ecrire_Text(Cod,D,Flux_Out);    
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

