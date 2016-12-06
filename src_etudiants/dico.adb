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
	procedure Libere is new Ada.Unchecked_Deallocation (Info_Caractere_Interne, Info_Caractere);
	
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

	-- Libere l'information de Character
	-- garantit: en sortie toute la memoire a ete libere.
	procedure Libere_Info(I : in out Info_Caractere) is
	begin
		Libere(I);
	end Libere_Info;
	
	-- Affiche pour chaque caractere: son nombre d'occurences et son code
	-- (s'il a ete genere)
	procedure Affiche(D : in Dico_Caracteres) is
	Tmp : Dico_Caracteres := D;
	begin
		if D = null then
			raise Dico_Vide with "Dictionnaire vide";
		else
			while Tmp /= null loop
	            --Put("Char: ");
	            Put(Tmp.Char);
	            --Put(" Occ: ");
	            Put(Tmp.Infos.Occ,1);
	            --Put(" Code: ");
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
			Put_Line("Vacio");
			Info := new Info_Caractere_Interne'(1,Code);
			D := new Dico_Caracteres_Interne'(C,Info,null);
		else
			if D.Suiv = null then
				Put("1 elemento ");
				Put(D.Char);
				New_Line;
				Info := new Info_Caractere_Interne'(1,Code);
				Tmp.Suiv := new Dico_Caracteres_Interne'(C,Info,null);
			else
				Put("Mas de 1 elemento");
				Put(D.Char);
				New_Line;
				if C > D.Suiv.Char then
					Set_Code(C,Code,D.Suiv);
				end if;
			end if;
		end if;
		Libere_Info(Info);
        Libere_Dico(Tmp);
	end Set_Code;

	-- Associe les infos associees a un caractere
	-- (operation plus generale, si necessaire)
	procedure Set_Infos(C : in Character; Info : in Info_Caractere; D : in out Dico_Caracteres) is
	Tmp : Dico_Caracteres;
	DCour : Dico_Caracteres := D;
	DSuiv : Dico_Caracteres;
	begin
		if D = null then
			D := new Dico_Caracteres_Interne'(C,Info,null);
		else
			DSuiv := D.Suiv;
			while DSuiv /= null loop
				if DSuiv.Char < C then
					DCour := DSuiv;
					DSuiv := DSuiv.Suiv;
				else
					if DSuiv.Char = C then
						DSuiv.Infos.Occ := DSuiv.Infos.Occ + 1;
					else
						if DCour.Char < C then
							Tmp := new Dico_Caracteres_Interne'(C,Info,DSuiv);
							DCour.Suiv := Tmp;
						else
							if DCour.Char = C then
								DCour.Infos.Occ := DCour.Infos.Occ + 1;
							else
								Tmp := new Dico_Caracteres_Interne'(C,Info,DCour);
								D := Tmp;
							end if;
						end if;
					end if;
				end if;
	        end loop;
		end if;
        Libere_Dico(Tmp);
        Libere_Dico(DCour);
        Libere_Dico(DSuiv);
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
			while (Tmp /= null or not EP)  loop
				if(Tmp.Char = C) then
					EP := True;
				end if;
	            Tmp := Tmp.Suiv;
	        end loop;
		end if;
        Libere_Dico(Tmp);
        return EP;
	end Est_Present;

	-- Retourne le code binaire d'un caractere
	--  -> leve l'exception Caractere_Absent si C n'est pas dans D
	function Get_Code(C : Character; D : Dico_Caracteres) return Code_Binaire is
	Tmp : Dico_Caracteres := D;
	Code : Code_Binaire;
	begin
		if not Est_Present(C,D) then
			raise Caractere_Absent with "Caractere n'est pas present";
		else
			while Tmp.Char /= C  loop
				Tmp := Tmp.Suiv;
	        end loop;
	        Code := Tmp.Infos.Code;
		end if;
		Libere_Dico(Tmp);
		return Code;
	end Get_Code;

	-- Retourne les infos associees a un caractere
	--  -> leve l'exception Caractere_Absent si C n'est pas dans D
	function Get_Infos(C : Character; D : Dico_Caracteres) return Info_Caractere is
	Tmp : Dico_Caracteres := D;
	Info : Info_Caractere;
	begin
		if not Est_Present(C,D) then
			raise Caractere_Absent with "Caractere n'est pas present";
		else
			while Tmp.Char /= C  loop
				Tmp := Tmp.Suiv;
	        end loop;
	        Info := Tmp.Infos;
		end if;
		Libere_Dico(Tmp);
		return Info;
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