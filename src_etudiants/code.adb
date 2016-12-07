with Ada.Text_IO, Ada.Integer_Text_Io, Code, Ada.Streams.Stream_IO, Ada.IO_Exceptions, Ada.Command_line, Ada.Unchecked_Deallocation;
use Ada.Text_IO, Ada.Integer_Text_Io, Code, Ada.Streams.Stream_IO, Ada.Command_line;
package body Code is

	-- Definition Code_Binaire_Interne
    type Code_Binaire_Interne is record
        Val: Bit;
        Suiv: Code_Binaire;
    end record;
	-- Definition Iterateur_Code_Interne
    type Iterateur_Code_Interne is record
        Val: Code_Binaire;
    end record;

    -- Procedures pour vider allocation de memoire
	procedure Libere is new Ada.Unchecked_Deallocation (Code_Binaire_Interne, Code_Binaire);
	procedure Libere is new Ada.Unchecked_Deallocation (Iterateur_Code_Interne, Iterateur_Code);

	-- Cree un code initialement vide
	function Cree_Code return Code_Binaire is
	begin
		return null;
	end Cree_Code;

	-- Copie un code existant
	function Cree_Code(C : in Code_Binaire) return Code_Binaire is
	Tmp : Code_Binaire := new Code_Binaire_Interne;
  courant1,courant2 : Code_Binaire;
	begin
    if C=Null then
      return Null;
    end if;
    courant1:=C;
    courant2:=Tmp;
    tmp.all:=C.all;
    while(courant1.suiv/=NULL) loop
      courant2.suiv:= new Code_Binaire_Interne;
      courant2.suiv.all:=courant1.suiv.all;
      courant1:=courant1.suiv;
      courant2:=courant2.suiv;

    end loop;
		return Tmp;
	end Cree_Code;

	-- Libere un code
	procedure Libere_Code(C : in out Code_Binaire) is
  courant: Code_Binaire:=C;
	begin
    while(C/=NULL) loop
      courant:=C;
      C:=C.suiv;
      Libere(courant);


    end loop;

	end Libere_Code;

	-- Retourne le nb de bits d'un code
	function Longueur(C : in Code_Binaire) return Natural is
	L: Integer := 0;
    Tmp: Code_Binaire := C;
	begin
		if C = null then
        	return 0;
        else
		 	while Tmp /= null loop
	            L := L + 1;
	            Tmp := Tmp.Suiv;
	        end loop;
        end if;
        Libere_Code(Tmp);
        return L;
	end Longueur;

	-- Affiche un code
	procedure Affiche(C : in Code_Binaire) is
	Tmp: Code_Binaire := C;
    begin
    	if C = null then
        	raise Code_Vide with "Code vide";
        else
		 	while Tmp /= null loop
	            Put(Tmp.Val,1);
	            Tmp := Tmp.Suiv;
	        end loop;
        	New_Line;
        end if;
        Libere_Code(Tmp);
	end Affiche;

	-- Ajoute le bit B en tete du code C
	procedure Ajoute_Avant(B : in Bit; C : in out Code_Binaire) is
	begin
		C := new Code_Binaire_Interne'(B,C);
	end Ajoute_Avant;

	-- Ajoute le bit B en queue du code C
	procedure Ajoute_Apres(B : in Bit; C : in out Code_Binaire) is
	Tmp: Code_Binaire := C;
    begin
		if C = null then
        	C := new Code_Binaire_Interne'(B,null);
        else
            while Tmp.Suiv /= null loop
                Tmp := Tmp.Suiv;
            end loop;
            Tmp.Suiv := new Code_Binaire_Interne'(B,null);
        end if;
	end Ajoute_Apres;

	-- ajoute les bits de C1 apres ceux de C
	procedure Ajoute_Apres(C1 : in Code_Binaire; C : in out Code_Binaire) is
	Tmp: Code_Binaire := C;
    begin
    	if C = null then
    		if C1 = null then
    			raise Code_Vide with "Code vide";
    		else
    			C := Cree_Code(C1);
    		end if;
        else
            while Tmp.Suiv /= null loop
                Tmp := Tmp.Suiv;
            end loop;
            Tmp.Suiv := Cree_Code(C1);
        end if;
	end Ajoute_Apres;

	-- Cree un iterateur initialise sur le premier bit du code
	function Cree_Iterateur(C : Code_Binaire) return Iterateur_Code is
	begin
		if C = null then
			return null;
		else
			return new Iterateur_Code_Interne'(Val =>Cree_Code(C));
		end if;
	end Cree_Iterateur;

	-- Libere un iterateur (pas le code parcouru!)
	procedure Libere_Iterateur(It : in out Iterateur_Code) is
	begin
		Libere(It);
	end Libere_Iterateur;

	-- Retourne True s'il reste des bits dans l'iteration
	function Has_Next(It : Iterateur_Code) return Boolean is
	begin
		if It = null then
        	return False;
        else
            if It.Val = null then
            	return False;
        	else
        		return True;
            end if;
        end if;
	end Has_Next;

	-- Retourne le prochain bit et avance dans l'iteration
	-- Leve l'exception Code_Entierement_Parcouru si Has_Next(It) = False
	procedure Next(It : in out Iterateur_Code; B : out Bit) is
    courant: Code_Binaire;
	begin
		if not Has_Next(It) then
			raise Code_Entierement_Parcouru  with "Code parcouru entierement";
		else
			B := It.Val.Val;
      courant:=It.Val;
			It.Val := It.Val.Suiv;
    --  Libere_Code(courant);
		end if;
	end Next;

------------------------------------------------------------------------
------------------------------------------------------------------------

	-- Comparer deux codes
	function Compare_Code(C: in Code_Binaire; D: in Code_Binaire) return boolean is 
	begin
		if C = null and D = null 
		then 
			return true; 
		end if;
		if C = null and D /= null then 
			return false; 
		end if;
		if C /= null and D = null then 
			return false; 
		end if;
		if C.Val = D.Val 
			then return (Compare_Code(C.Suiv,D.Suiv));
		else 
			return false; 
		end if;
	end Compare_Code;

	-- Supprimmer le bit en queue d'une suite de Bits
    procedure Supprimer_Avant(B: out Bit; C: in out Code_Binaire) is
    Tmp: Code_Binaire := C;
    begin
        if C = null then
            raise Code_Vide with "Code vide";
        else 
            C := C.Suiv;
            B := Tmp.Val;
        end if;
    end Supprimer_Avant; 

    -- Ajuster la taille d'un code à certain quantite de bits donnée
    procedure Supprimer_Bits_Avant(C: in out Code_Binaire; n: in Integer; D: out Code_Binaire) is
    B : Bit;
    begin
        D := Cree_Code;
        if Longueur(C) < n then 
        	return; 
    	end if;
        for i in 1..n loop
            Supprimer_Avant(B,C);
            Ajoute_Apres(B,D);
        end loop;
    end Supprimer_Bits_Avant;

    -- Transformer un Code_Binaire en Octet
    function Convertir_En_Octet(C: in Code_Binaire) return Octet is
    Tmp : Code_Binaire := C;
    O: Octet := 0;
    begin
        for i in Integer range 0..7 loop
            O := O + Octet(Tmp.Val*(2**(7-i)));
            Tmp := Tmp.Suiv;
        end loop;
        return O; 
    end Convertir_En_Octet;

    -- Transformer un Octet en Code_Binaire
    function Convertir_En_Code(O: in Octet) return Code_Binaire is
    Tmp : Integer := Integer(O);
    C : Code_Binaire := Cree_Code;
    begin
        for i in Integer range 0..7 loop
            Ajoute_Avant(Bit(Integer(Tmp-Integer(Tmp/2)*2)),C);
            Tmp := Integer(Tmp/2);
        end loop;
        return C; 
    end Convertir_En_Code;

    -- Inserer a la queue d'une suire de Bits un Octet
	procedure Inserer_Octet_Queue(C: in out Code_Binaire; O: in Octet) is
	begin
		Ajoute_Apres(Convertir_En_Code(O),C);
	end Inserer_Octet_Queue;    

	-- Prens un code pour le convertir en Octets selon la longueur
	procedure Ecrire_Binaire(C: in out Code_Binaire; Flux : in out Stream_Access) is
	Tmp : Code_Binaire := Cree_Code;
	begin
		while Longueur(C) >= 8 loop
			Supprimer_Bits_Avant(C,8,Tmp);
			Octet'Write(Flux,Convertir_En_Octet(Tmp));
		end loop;
		return;
	end Ecrire_Binaire; 


end Code;
