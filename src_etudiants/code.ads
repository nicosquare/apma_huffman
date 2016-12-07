
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;

-- Representation d'un code binaire, suite de bits 0 ou 1.
-- D'autres operations peuvent etre ajoutees si necessaire, et 
-- toutes ne vous seront pas forcement utiles...

package Code is

	Code_Vide, Code_Trop_Court : exception;

	-- Representation de bits
	subtype Bit is Natural range 0 .. 1;
	ZERO : constant Bit := 0;
	UN   : constant Bit := 1;

    type Octet is new Integer range 0..255;
    for Octet'Size use 8;

	type Code_Binaire is private;

	-- Cree un code initialement vide
	function Cree_Code return Code_Binaire;

	-- Copie un code existant
	function Cree_Code(C : in Code_Binaire) return Code_Binaire;

	-- Libere un code
	procedure Libere_Code(C : in out Code_Binaire);
	
	-- Retourne le nb de bits d'un code
	function Longueur(C : in Code_Binaire) return Natural;

	-- Affiche un code
	procedure Affiche(C : in Code_Binaire);

	-- Ajoute le bit B en tete du code C
	procedure Ajoute_Avant(B : in Bit; C : in out Code_Binaire);

	-- Ajoute le bit B en queue du code C
	procedure Ajoute_Apres(B : in Bit; C : in out Code_Binaire);

	-- ajoute les bits de C1 apres ceux de C
	procedure Ajoute_Apres(C1 : in Code_Binaire; C : in out Code_Binaire);


------------------------------------------------------------------------
--   PARCOURS D'UN CODE VIA UN "ITERATEUR"
--   Permet un parcours sequentiel du premier au dernier bit d'un code
--
--   Meme modele d'utilisation qu'en Java, C++, ... :
--	It : Iterateur_Code;
--	B : Bit;    
--	...
--	It := Cree_Iterateur(Code);
--	while Has_Next(It) loop
--		B := Next(It);
--		...	-- Traiter B
--	end loop;
------------------------------------------------------------------------

	Code_Entierement_Parcouru : exception;

	type Iterateur_Code is private;

	-- Cree un iterateur initialise sur le premier bit du code
	function Cree_Iterateur(C : Code_Binaire) return Iterateur_Code;

	-- Libere un iterateur (pas le code parcouru!)
	procedure Libere_Iterateur(It : in out Iterateur_Code);

	-- Retourne True s'il reste des bits dans l'iteration
	function Has_Next(It : Iterateur_Code) return Boolean;

	-- Retourne le prochain bit et avance dans l'iteration
	-- Leve l'exception Code_Entierement_Parcouru si Has_Next(It) = False
	procedure Next(It : in out Iterateur_Code; B : out Bit);

------------------------------------------------------------------------
------------------------------------------------------------------------

	-- Comparer deux codes
	function Compare_Code(C: in Code_Binaire; D: in Code_Binaire) return boolean;
	-- Supprimmer le bit en queue d'une suite de Bits
	procedure Supprimer_Avant(B: out Bit; C: in out Code_Binaire);
	-- Ajuster la taille d'un code à certain quantite de bits donnée
	procedure Supprimer_Bits_Avant(C: in out Code_Binaire; n: in Integer; D: out Code_Binaire);
	-- Transformer un Code_Binaire en Octet
	function Convertir_En_Octet(C: in Code_Binaire) return Octet;
	-- Transformer un Octet en Code_Binaire
	function Convertir_En_Code(O: in Octet) return Code_Binaire;
    -- Inserer a la queue d'une suire de Bits un Octet
	procedure Inserer_Octet_Queue(C: in out Code_Binaire; O: in Octet);
	-- Prens un code pour le convertir en Octets selon la longueur
	procedure Ecrire_Binaire(C: in out Code_Binaire; Flux : in out Stream_Access);

private

	-- type prive: a definir dans le body du package, code.adb
	type Code_Binaire_Interne;

	type Code_Binaire is access Code_Binaire_Interne;

	-- type prive: a definir dans le body du package, code.adb
	type Iterateur_Code_Interne;

	type Iterateur_Code is access Iterateur_Code_Interne;


end Code;
