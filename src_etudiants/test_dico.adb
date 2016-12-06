with Ada.Text_IO, Ada.Integer_Text_IO, Code, Dico; use  Ada.Text_IO, Ada.Integer_Text_IO, Code, Dico;
procedure Test_Dico is
D1,D2,D3,D4 : Dico_Caracteres;
I : Info_Caractere;
C : Character;
C1,C2,C3,C4 : Code_Binaire;
begin

	C1 := Cree_Code;
    Ajoute_Avant(ZERO,C1);
    Ajoute_Avant(ZERO,C1);
    Ajoute_Avant(ZERO,C1);
    Ajoute_Avant(ZERO,C1);
    Put("C1: ");
    Affiche(C1);

    C2 := Cree_Code;
    Ajoute_Avant(ZERO,C2);
    Ajoute_Avant(ZERO,C2);
    Ajoute_Avant(ZERO,C2);
    Ajoute_Avant(UN,C2);
    Put("C2: ");
    Affiche(C2);

    C3 := Cree_Code;
    Ajoute_Avant(ZERO,C3);
    Ajoute_Avant(ZERO,C3);
    Ajoute_Avant(UN,C3);
    Ajoute_Avant(ZERO,C3);
    Put("C3: ");
    Affiche(C3);

    C4 := Cree_Code;
    Ajoute_Avant(ZERO,C4);
    Ajoute_Avant(ZERO,C4);
    Ajoute_Avant(UN,C4);
    Ajoute_Avant(UN,C4);
    Put("C4: ");
    Affiche(C4);


	D1 := Cree_Dico;
	C := 'a';
	Set_Code(C,C1,D1);
	C := 'b';
	Set_Code(C,C2,D1);
	C := 'b';
	Set_Code(C,C2,D1);
	C := 'a';
	Set_Code(C,C1,D1);
	C := 'c';
	Set_Code(C,C3,D1);
	C := 'D';
	I := Info_Caractere'(5,C4);
	Set_Infos(C,I,D1);

	Affiche(D1);

	C := 'X';
	Put(C);
	if Est_Present(C,D1) then
		Put_Line(" Est Present");
	else
		Put_Line(" Pas Present");
	end if;

	--Get_Code ne marche pas
	C := 'b';
	Put(C);
	Put(" => code => ");
	Affiche(Get_Code(C,D1));

	Affiche(D1);
	Affiche(Get_Code('c',D1));
	 --Get_Infos ne marche pas
	C := 'b';

	Put(C);
	Put(" => Info => ");
	I := Get_Infos(C,D1);
	Put(" Occ: ");
	Put(I.Occ);
	Put(" Code: ");
	Affiche(I.Code);

	Put("Caracteres differentes: ");
	Put(Nb_Caracteres_Differents(D1));
	New_Line;

	Put("Caracteres total: ");
	Put(Nb_Total_Caracteres(D1));
	New_Line;



end Test_Dico;
