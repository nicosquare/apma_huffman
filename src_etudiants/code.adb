with Ada.Integer_Text_IO,Ada.Text_IO; use Ada.Integer_Text_IO,Ada.Text_IO; with Ada.Unchecked_Deallocation;
package body Code is 

	procedure Libere is new Ada.Unchecked_Deallocation (Code_Binaire_Interne, Code_Binaire);
	procedure Libere is new Ada.Unchecked_Deallocation (Iterateur_Code_Interne, Iterateur_Code);

	-- Cree un code initialement vide
	function Cree_Code return Code_Binaire is
	begin
		return null;
	end Cree_Code;

	-- Copie un code existant
	function Cree_Code(C : in Code_Binaire) return Code_Binaire is
	Tmp : Code_Binaire := C;
	begin
		return Tmp;
	end Cree_Code;

	-- Libere un code
	procedure Libere_Code(C : in out Code_Binaire) is
	begin
		Libere(C);
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
    			C := C1;
    		end if;
        else 
            while Tmp.Suiv /= null loop
                Tmp := Tmp.Suiv;
            end loop;
            Tmp.Suiv := C1;
        end if;
	end Ajoute_Apres;

	-- Cree un iterateur initialise sur le premier bit du code
	function Cree_Iterateur(C : Code_Binaire) return Iterateur_Code is
	begin
		if C = null then
			return null;
		else
			return new Iterateur_Code_Interne'(Val => C);
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
	begin
		if not Has_Next(It) then
			raise Code_Entierement_Parcouru  with "Code parcouru entierement";
		else
			B := It.Val.Val;
			It.Val := It.Val.Suiv;
		end if;
	end Next;

end Code;