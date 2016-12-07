with Ada.Integer_Text_IO, Ada.Text_IO, Code; use Ada.Integer_Text_IO, Ada.Text_IO, Code; with Ada.Unchecked_Deallocation;
package body Dico is

	-- Definition Code_Binaire_Interne
    type Dico_Caracteres_Interne is record
    	Char: Character;
        Infos: Info_Caractere;
        Suiv: Dico_Caracteres;
    end record;

    -- Procedures pour vider allocation de memoire
	procedure Libere is new Ada.Unchecked_Deallocation (Dico_Caracteres_Interne, Dico_Caracteres);

	-- Cree un dictionnaire D, initialement vide
	function Cree_Dico return Dico_Caracteres is
	begin
		return null;
	end Cree_Dico;

	-- Libere le dictionnaire D
	-- garantit: en sortie toute la memoire a ete libere, et D = null.
	procedure Libere_Dico(D : in out Dico_Caracteres) is
	begin
		Libere(D);
	end Libere_Dico;

	-- Affiche pour chaque caractere: son nombre d'occurences et son code
	-- (s'il a ete genere)
	procedure Affiche(D : in Dico_Caracteres) is
	Tmp : Dico_Caracteres := D;
	begin
		if D = null then
			raise Dico_Vide with "Dictionnaire vide";
		else
			while Tmp /= null loop
	            Put("Char: ");
	            Put(Tmp.Char);
	            Put(" Occ: ");
	            Put(Tmp.Infos.Occ,1);
	            Put(" Code: ");
	            Affiche(Tmp.Infos.Code);
	            Tmp := Tmp.Suiv;
	        end loop;
		end if;
        Libere_Dico(Tmp);
	end Affiche;


-- Ajouts d'informations dans le dictionnaire

	-- Associe un code a un caractere
	procedure Set_Code(C : in Character; Code : in Code_Binaire; D : in out Dico_Caracteres) is
	Info : Info_Caractere;
	Tmp : Dico_Caracteres := D;
	begin
		if D = null then
			Info := Info_Caractere'(1,Code);
			D := new Dico_Caracteres_Interne'(C,Info,null);
		else
			while (Tmp.Suiv /= null and Tmp.Char /= C) loop
				Tmp := Tmp.Suiv;
			end loop;
			if Tmp.Char = C then
				Tmp.Infos.Occ := Tmp.Infos.Occ + 1;
			else
				if Tmp.Suiv = null then
					Info := Info_Caractere'(1,Code);
					Tmp.Suiv := new Dico_Caracteres_Interne'(C,Info,null);
				end if;
			end if;
		end if;
	end Set_Code;

	-- Associe les infos associees a un caractere
	-- (operation plus generale, si necessaire)
	procedure Set_Infos(C : in Character; Info : in Info_Caractere; D : in out Dico_Caracteres) is
	Tmp : Dico_Caracteres := D;
	begin
		if D = null then
			D := new Dico_Caracteres_Interne'(C,Info,null);
		else
			while (Tmp.Suiv /= null and Tmp.Char /= C) loop
				Tmp := Tmp.Suiv;
			end loop;
			if Tmp.Char = C then
				Tmp.Infos.Occ := Tmp.Infos.Occ + 1;
			else
				if Tmp.Suiv = null then
					Tmp.Suiv := new Dico_Caracteres_Interne'(C,Info,null);
				end if;
			end if;
		end if;
	end Set_Infos;

-- Acces aux informations sur un caractere

	-- retourne True sur le caractere C est present dans le D
	function Est_Present(C : Character; D : Dico_Caracteres) return Boolean is
	Tmp : Dico_Caracteres := D;
	EP : Boolean := False;
	begin
		if D = null then
			raise Dico_Vide with "Dictionnaire vide";
		else
			while (Tmp /= null and not EP)  loop
				EP := (Tmp.Char = C);
				Tmp := Tmp.Suiv;
	        end loop;
		end if;
        --Libere_Dico(Tmp);
        return EP;
	end Est_Present;

	-- Retourne le code binaire d'un caractere
	--  -> leve l'exception Caractere_Absent si C n'est pas dans D
	function Get_Code(C : Character; D : Dico_Caracteres) return Code_Binaire is
    courant : Dico_Caracteres:=D;
	begin
		if not Est_Present(C,D) then
			raise Caractere_Absent with "Caractere n'est pas present";
		else
      while(courant/=NULL) loop
			if courant.Char = C then
				return courant.Infos.Code;
			end if;
      courant:=courant.suiv;
    end loop;
    return courant.Infos.Code;
		end if;
	end Get_Code;

	-- Retourne le caractere d'un code binaire
	function Get_Char(D: in Dico_Caracteres; Code : in Code_Binaire) return Character is
    Tmp: Dico_Caracteres := D;
    begin
        while Tmp /= null loop
            if Compare_Code(Tmp.Infos.Code,Code) then
                return Tmp.Char;
            end if;
            Tmp := Tmp.Suiv;
        end loop;
        return Character'Val(16#00#); 
    end Get_Char; 

	-- Retourne les infos associees a un caractere
	--  -> leve l'exception Caractere_Absent si C n'est pas dans D
	function Get_Infos(C : Character; D : Dico_Caracteres) return Info_Caractere is
    courant:Dico_Caracteres:=D;
	begin
		if not Est_Present(C,D) then
			raise Caractere_Absent with "Caractere n'est pas present";
		else
      while(courant/=NULL) loop
			     if courant.Char = C then
				         return courant.Infos;
			            end if;
                  courant:=courant.suiv;
                end loop;
                return courant.Infos;
		            end if;
	end Get_Infos;


-- Statistiques sur le dictionnaire (au besoin)

	-- Retourne le nombre de caracteres differents dans D
	function Nb_Caracteres_Differents(D : in Dico_Caracteres) return Natural is
	L: Integer := 0;
    Tmp: Dico_Caracteres := D;
	begin
		if D = null then
        	return 0;
        else
		 	while Tmp /= null loop
	            L := L + 1;
	            Tmp := Tmp.Suiv;
	        end loop;
        end if;
        Libere_Dico(Tmp);
        return L;
	end Nb_Caracteres_Differents;

	-- Retourne le nombre total de caracteres
	--  =  somme des nombre d'occurences de tous les caracteres de D
	function Nb_Total_Caracteres(D : in Dico_Caracteres) return Natural is
	L: Integer := 0;
    Tmp: Dico_Caracteres := D;
	begin
		if D = null then
        	return 0;
        else
		 	while Tmp /= null loop
	            L := L + Tmp.Infos.Occ;
	            Tmp := Tmp.Suiv;
	        end loop;
        end if;
        Libere_Dico(Tmp);
        return L;
	end Nb_Total_Caracteres;

end Dico;
