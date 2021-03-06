with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with dico; use dico;
with Code; use Code;
-- paquetage representant un arbre de Huffman de caracteres

package Huffman is

	type Arbre is private;

	type Arbre_Huffman is record
		-- l'arbre de Huffman proprement dit
		A : Arbre;
		-- autres infos utiles: nb total de caracteres lus, ...
		Nb_Total_Caracteres : Natural;
		-- A completer selon vos besoins!
	end record;

	-- Libere l'arbre de racine A.
	-- garantit: en sortie toute la memoire a ete libere, et A = null.
	function creer_arbre(C: Character;i:Integer) return Arbre;
	procedure Libere_Arbre(A: in out Arbre);
	procedure Libere(H : in out Arbre_Huffman);
	procedure Affiche_Arbre(A:in Arbre);
	procedure Affiche(H : in Arbre_Huffman);


	-- Cree un arbre de Huffman a partir d'un fichier texte
	-- Cette function lit le fichier et compte le nb d'occurences des
	-- differents caracteres presents, puis genere l'arbre correspondant
	-- et le retourne.
procedure Fusion_Arbre(moins_prio1: in out Arbre_Huffman;moins_prio2: in Arbre_Huffman) ;

	function Cree_Huffman(Nom_Fichier : in String)
		return Arbre_Huffman;

	-- Stocke un arbre dans un flux ouvert en ecriture
	-- Le format de stockage est celui decrit dans le sujet
	-- Retourne le nb d'octets ecrits dans le flux (pour les stats)
	procedure Ecrit_Arbre(A:in Arbre;Flux : Ada.Streams.Stream_IO.Stream_Access);
	function Ecrit_Huffman(H : in Arbre_Huffman;
	                        Flux : Ada.Streams.Stream_IO.Stream_Access)
		return Positive;

	-- Lit un arbre stocke dans un flux ouvert en lecture
	-- Le format de stockage est celui decrit dans le sujet
	function Lit_Huffman(Flux : Ada.Streams.Stream_IO.Stream_Access)
		return Arbre_Huffman;


	-- Retourne un dictionnaire contenant les caracteres presents
	-- dans l'arbre et leur code binaire (evite les parcours multiples)
	-- de l'arbre

	procedure Genere_Dic_Arbre(A: in Arbre; D:in out Dico_Caracteres;C: in out Code_Binaire) ;
	function Genere_Dictionnaire(H :  Arbre_Huffman) return Dico_Caracteres;



------ Parcours de l'arbre (decodage)

-- Parcours a l'aide d'un iterateur sur un code, en partant du noeud A
--  * Si un caractere a ete trouve il est retourne dans Caractere et
--    Caractere_Trouve vaut True. Le code n'a eventuellement pas ete
--    totalement parcouru. A est une feuille.
--  * Si l'iteration est terminee (plus de bits a parcourir ds le code)
--    mais que le parcours s'est arrete avant une feuille, alors
--    Caractere_Trouve vaut False, Caractere est indetermine
--    et A est le dernier noeud atteint.
--	procedure Get_Caractere(It_Code : in Iterateur_Code; A : in out Arbre;
	--			Caractere_Trouve : out Boolean;
		--		Caractere : out Character);


private

	-- type Noeud prive: a definir dans le body du package, huffman.adb
	type Noeud;

	type Arbre is Access Noeud;

end Huffman;
