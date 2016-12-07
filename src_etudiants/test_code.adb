with Ada.Text_IO, Ada.Integer_Text_IO, Code; use  Ada.Text_IO, Ada.Integer_Text_IO, Code;
procedure Test_Code is
C,D,E : Code_Binaire;
B : Bit := ZERO;
It : Iterateur_Code;
begin

    C := Cree_Code;
    Ajoute_Avant(UN,C);
    Ajoute_Avant(ZERO,C);
    Ajoute_Avant(ZERO,C);
    Ajoute_Avant(ZERO,C);
    Put("C: ");
    Affiche(C);
    E:=Cree_Code(C);
    Put("E: ");
    Affiche(E);
    Ajoute_Apres(ZERO,C);
    Ajoute_Apres(UN,C);
    Ajoute_Apres(UN,C);
    Ajoute_Apres(UN,C);
    Put("C: ");
    Affiche(C);
    Put("E: ");
    Affiche(E);



    D := Cree_Code;
    Ajoute_Avant(UN,D);
    Put("D: ");
    Affiche(D);
    Ajoute_Apres(C,D);
    Put("D: ");
    Affiche(D);
    Ajoute_Avant(UN,D);
    Put("D: ");
    Affiche(D);

    Put("D: ");
    It := Cree_Iterateur(D);
    while Has_Next(It) loop
        Next(It,B);
        Put(B,2);
    end loop;
    New_Line;
    Put("D:");
    Affiche(D);

    Libere_Code(C);
    Put("E: ");
    Affiche(E);
    Put("Longueur C: ");
    Put(Longueur(C));
    New_Line;
    Put("Longueur D: ");
    Put(Longueur(D));
    New_Line;
    Affiche(D);
    New_Line;
    --C := Cree_Code(D);
    Put("Longueur C: ");
    Put(Longueur(C));
    New_Line;
    Affiche(D);
    New_Line;

    Put("C: ");
    It := Cree_Iterateur(C);
    while Has_Next(It) loop
        Next(It,B);
        Put(B,2);
    end loop;
    New_Line;


end Test_Code;
